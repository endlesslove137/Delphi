unit ConsoleTest;
//download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    meOutput: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ExecuteISQL(FileName: string);
  end;

var
  Form1             : TForm1;

implementation

{$R *.dfm}

procedure TForm1.ExecuteISQL(FileName: string);

const
  BufSize           = $4000;
  FMSSQLBinnDir     = 'C:\Program Files\Microsoft SQL Server\80\Tools\BINN\';
  FDBServerName     = 'EISERVER';
  FDBDatabaseName   = 'mendale_drp';

type
  TPipeHandles = record
    hRead, hWrite: DWORD;
  end;

  procedure ClosePipe(var Pipe: TPipeHandles);
  begin
    with Pipe do
    begin
      if hRead <> 0 then
        CloseHandle(hRead);
      if hWrite <> 0 then
        CloseHandle(hWrite);
      hRead := 0;
      hWrite := 0;
    end;
  end;

  function ReadPipe(var Pipe: TPipeHandles): string;
  var
    ReadBuf         : array[0..BufSize] of Char;
    BytesRead       : Dword;
  begin
    result := '';
    if PeekNamedPipe(Pipe.hRead, nil, 0, nil, @BytesRead, nil) and
      (BytesRead > 0) then
    begin
      ReadFile(Pipe.hRead, ReadBuf, BytesRead, BytesRead, nil);
      if BytesRead > 0 then
      begin
        ReadBuf[BytesRead] := #0;
        result := ReadBuf;
      end;
    end;
  end;

var
  SecAttr           : TSecurityAttributes;
  StartupInfo       : TStartupInfo;
  PipeStdOut        : TPipeHandles;
  PipeStdErr        : TPipeHandles;
  Cmd               : string;
  dwExitCode        : DWORD;
  ProcessInformation: TProcessInformation;
  outstr            : string;
  error_msg         : string;

begin
  SecAttr.nLength := SizeOf(SecAttr);
  SecAttr.lpSecurityDescriptor := nil;
  SecAttr.bInheritHandle := TRUE;

  error_msg := '';

  with PipeStdOut do
    if not CreatePipe(hRead, hWrite, @SecAttr, BufSize) then
      Showmessage('Ne mogu kreirati STDOUT pipe');
  //      XWinError('Ne mogu kreirati STDOUT pipe');

  try
    with PipeStdErr do
      if not CreatePipe(hRead, hWrite, @SecAttr, BufSize) then
        Showmessage('Ne mogu kreirati STDERR pipe');
    // XWinError('Ne mogu kreirati STDERR pipe');

  except
    ClosePipe(PipeStdOut);
    raise;
  end;

  try
    FillChar(StartupInfo, SizeOf(StartupInfo), 0);
    with StartupInfo do
    begin
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      hStdOutput := PipeStdOut.hWrite;
      hStdError := PipeStdErr.hWrite;
      wShowWindow := SW_HIDE;
    end;

    Cmd := FMSSQLBinnDir + 'isql.exe' +
      ' -S "' + FDBServerName + '"' +
      ' -U "' + 'sa' + '"' +
      ' -P "' + '' + '"' +
      ' -d "' + FDBDatabaseName + '"' +
      ' -w 255 -n ' +
      ' -i "' + FileName + '"' +
      ' -r1 -l 10';

    if CreateProcess(
      nil, PChar(Cmd), nil, nil, true,
      DETACHED_PROCESS or NORMAL_PRIORITY_CLASS,
      nil, PChar(FMSSQLBinnDir),
      StartupInfo,
      ProcessInformation
      ) then
    begin
      dwExitCode := STILL_ACTIVE;
      Screen.Cursor := crHourglass;
     // bbTerminate.Enabled := true;
      try
        repeat
          ///WaitForSingleObject(ProcessInformation.hProcess, 0);
          GetExitCodeProcess(ProcessInformation.hProcess, dwExitCode);

          Application.ProcessMessages;

          outstr := ReadPipe(PipeStdOut);
          if outstr <> '' then
          begin
            //LogStyle(ltNormal);
            meOutput.SelText := outstr;
            meOutput.Perform(EM_SCROLLCARET, 0, 0);
          end;

          outstr := ReadPipe(PipeStdErr);
          if outstr <> '' then
          begin
           // LogStyle(ltError);
            meOutput.SelText := outstr;
            meOutput.Perform(EM_SCROLLCARET, 0, 0);

            if (error_msg = '') and (Pos('Msg 1105, Level 17', outstr) > 0) then
            begin
              (* Error Message text:
                Can't allocate space for object '%.*s' in database '%.*s' because the
                '%.*s' segment is full. If you ran out of space in Syslogs, dump the
                transaction log. Otherwise, use ALTER DATABASE or sp_extendsegment to increase
                the size of the segment.
                *)
              error_msg :=
                'Nema mjesta na segmentu baze podataka, treba pokusati isprazniti transaction log ili poveæatibazu.';
            end;
          end;

        until dwExitCode <> STILL_ACTIVE;

        if not GetExitCodeProcess(ProcessInformation.hProcess, dwExitCode) then
          Showmessage('Ne mogu oèitati exit code!');

        if dwExitCode <> 0 then
          raise Exception.Create('Exit code ' + IntToStr(dwExitCode));

      finally
        Screen.Cursor := crDefault;
       // bbTerminate.Enabled := false;
        if dwExitCode = STILL_ACTIVE then
          TerminateProcess(ProcessInformation.hProcess, 1);
        CloseHandle(ProcessInformation.hProcess);
        CloseHandle(ProcessInformation.hThread);
        ProcessInformation.hProcess := 0;
      end;
    end
    else
      Showmessage('Ne mogu lansirati ' + FMSSQLBinnDir + 'isql.exe!' + #10 +
        'Cmd: ' + Cmd);

  finally
    ClosePipe(PipeStdOut);
    ClosePipe(PipeStdErr);
  end;

  if error_msg <> '' then
    raise Exception.Create(error_msg);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.ExecuteISQL('');
end;

end.

