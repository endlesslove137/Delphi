unit uGetConsoleOutput;
//download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGetConsoleOutput = class(TForm)
    Memo1: TMemo;
    btnOpenFile: TButton;
    btnRun: TButton;
    OpenDialog1: TOpenDialog;
    editfilename: TEdit;
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGetConsoleOutput: TfrmGetConsoleOutput;

implementation

{$R *.dfm}

procedure CheckResult(b: Boolean);
begin
  if not b then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

function RunDOS(const Prog, CommandLine, Dir: string; var ExitCode: DWORD):
  string;
var
  HRead, HWrite     : THandle;
  StartInfo         : TStartupInfo;
  ProceInfo         : TProcessInformation;
  b                 : Boolean;
  sa                : TSecurityAttributes;
  inS               : THandleStream;
  sRet              : TStrings;
begin
  Result := '';
  FillChar(sa, sizeof(sa), 0);
  //设置允许继承，否则在NT和2000下无法取得输出结果
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := True;
  sa.lpSecurityDescriptor := nil;
  b := CreatePipe(HRead, HWrite, @sa, 0);
  CheckResult(b);

  FillChar(StartInfo, SizeOf(StartInfo), 0);
  StartInfo.cb := SizeOf(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;
  //使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式
  StartInfo.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
  StartInfo.hStdError := HWrite;
  StartInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE); //HRead;
  StartInfo.hStdOutput := HWrite;

  b := CreateProcess(PChar(Prog),       //lpApplicationName: PChar
    PChar(CommandLine),                 //lpCommandLine: PChar
    nil, //lpProcessAttributes: PSecurityAttributes
    nil,                                //lpThreadAttributes: PSecurityAttributes
    True,                               //bInheritHandles: BOOL
    CREATE_NEW_CONSOLE,
    nil,
    PChar(Dir),
    StartInfo,
    ProceInfo);

  CheckResult(b);
  WaitForSingleObject(ProceInfo.hProcess, INFINITE);
  GetExitCodeProcess(ProceInfo.hProcess, ExitCode);

  inS := THandleStream.Create(HRead);
  if inS.Size > 0 then
  begin
    sRet := TStringList.Create;
    sRet.LoadFromStream(inS);
    Result := sRet.Text;
    sRet.Free;
  end;
  inS.Free;

  CloseHandle(HRead);
  CloseHandle(HWrite);
end;

function GetDosOutput(const CommandLine: string): string;
var
  SA                : TSecurityAttributes;
  SI                : TStartupInfo;
  PI                : TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK             : Boolean;
  Buffer            : array[0..255] of Char;
  BytesRead         : Cardinal;
  WorkDir, Line     : string;
begin
  Application.ProcessMessages;
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  // create pipe for standard output redirection
  CreatePipe(StdOutPipeRead,            // read handle
    StdOutPipeWrite,                    // write handle
    @SA,                                // security attributes
    0 // number of bytes reserved for pipe - 0 default
    );
  try
    // Make child process use StdOutPipeWrite as standard out,
    // and make sure it does not show on screen.
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdinput
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;

    // launch the command line compiler
    WorkDir := ExtractFilePath(CommandLine);
    WasOK := CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil,
      PChar(WorkDir), SI, PI);

    // Now that the handle has been inherited, close write to be safe.
    // We don't want to read or write to it accidentally.
    CloseHandle(StdOutPipeWrite);
    // if process could be created then handle its output
    if not WasOK then
      raise Exception.Create('Could not execute command line!')
    else
    try
      // get all output until dos app finishes
      Line := '';
      repeat
        // read block of characters (might contain carriage returns and line feeds)
        WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);

        // has anything been read?
        if BytesRead > 0 then
        begin
          // finish buffer to PChar
          Buffer[BytesRead] := #0;
          // combine the buffer with the rest of the last run
          Line := Line + Buffer;
        end;
      until not WasOK or (BytesRead = 0);
      // wait for console app to finish (should be already at this point)
      WaitForSingleObject(PI.hProcess, INFINITE);
    finally
      // Close all remaining handles
      CloseHandle(PI.hThread);
      CloseHandle(PI.hProcess);
    end;
  finally
    result := Line;
    CloseHandle(StdOutPipeRead);
  end;
end;

procedure TfrmGetConsoleOutput.btnOpenFileClick(Sender: TObject);
begin
  if opendialog1.Execute then
    editfilename.Text := opendialog1.FileName;
end;

procedure TfrmGetConsoleOutput.btnRunClick(Sender: TObject);
var
  hReadPipe, hWritePipe: THandle;
  si                : STARTUPINFO;
  lsa               : SECURITY_ATTRIBUTES;
  pi                : PROCESS_INFORMATION;
  //  mDosScreen        : string;
  cchReadBuffer     : DWORD;
  ph                : PChar;
  fname             : PChar;
  // i,  j                 : integer;
begin
  fname := allocmem(255);
  ph := AllocMem(5000);
  lsa.nLength := sizeof(SECURITY_ATTRIBUTES);
  lsa.lpSecurityDescriptor := nil;
  lsa.bInheritHandle := True;

  if CreatePipe(hReadPipe, hWritePipe, @lsa, 0) = false then
  begin
    ShowMessage('Can not create pipe!');
    exit;
  end;
  fillchar(si, sizeof(STARTUPINFO), 0);
  si.cb := sizeof(STARTUPINFO);
  si.dwFlags := (STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW);
  si.wShowWindow := SW_SHOW;
  si.hStdOutput := hWritePipe;
  StrPCopy(fname, EditFilename.text);
  if CreateProcess(nil, fname, nil, nil, true, 0, nil, nil, si, pi) = False then
  begin
    ShowMessage('can not create process');
    FreeMem(ph);
    FreeMem(fname);
    Exit;
  end;

  while (true) do
  begin
    if not PeekNamedPipe(hReadPipe, ph, 1, @cchReadBuffer, nil, nil) then
      break;
    if cchReadBuffer <> 0 then
    begin
      if ReadFile(hReadPipe, ph^, 4096, cchReadBuffer, nil) = false then
        break;
      ph[cchReadbuffer] := chr(0);
      Memo1.Lines.Add(ph);
    end
    else if (WaitForSingleObject(pi.hProcess, 0) = WAIT_OBJECT_0) then
      break;
    Sleep(100);
  end;

  ph[cchReadBuffer] := chr(0);
  Memo1.Lines.Add(ph);
  CloseHandle(hReadPipe);
  CloseHandle(pi.hThread);
  CloseHandle(pi.hProcess);
  CloseHandle(hWritePipe);
  FreeMem(ph);
  FreeMem(fname);

end;

end.

