 {**************--===ION Tek===--****************}
 { Compression unit                              }
 { Note that major difference from previous      }
 { version is that this is no more a separate    }
 { thread!                                       }
 {***********************************************}
unit Compression;

interface

uses
  Forms, Windows, Globals;

procedure CompressFile(const Params: string; Compress: TCompDecomp);

implementation

uses
  Shared, Translator, SysUtils, Math, Dialogs, Classes,
  MainFrm, SetupFrm;

//Allocates console window and sets the cursor position to (0,0)
procedure AllocateConsole;
var
  CursorPos:    TCoord;
  ConsoleTitle: array[1..MAX_PATH] of char;
begin
  AllocConsole;
  if not Globals.Config.DebugMode then
  begin
    GetConsoleTitle( @ConsoleTitle, MAX_PATH);
    ShowWindow(FindWindow(nil, @ConsoleTitle), 0);
    Application.BringToFront;
  end;
  hStdOut     := GetStdHandle(STD_OUTPUT_HANDLE);
  CursorPos.X := high(TLine);
  CursorPos.Y := 50;
  SetConsoleScreenBufferSize(hStdOut, CursorPos);
  CursorPos.X := 0;
  CursorPos.Y := 0;
  SetConsoleCursorPosition(hStdOut, CursorPos);
end;
//This procedure is used to hide the upx.exe console window
procedure FindWin;
var
  ConsoleTitle: array[1..MAX_PATH] of char;
begin
  if not Globals.Config.DebugMode then
  begin
    GetConsoleTitle( @ConsoleTitle, MAX_PATH);
    ShowWindow(FindWindow(nil, @ConsoleTitle), 0);
    Application.BringToFront;
  end;
end;
 //The main part - reads the data from upx console and
 //updates the progress bars
procedure GetProgress(ProcInfo: TProcessInformation);
var
  EC:              cardinal;
  c:               integer;
  Offset:          integer;
  SingleProgress:  integer;
  MultiProgress:   integer;
  ProgressValue:   integer;
  TotalProgress:   integer;
  CurRepeat:       integer;
  CompressSize:    string;
  MultiRepeat:     TStringList;
  CursorPos:       TCoord;
  CharsRead:       DWord;
  Line:            TLine;
  IsMultiProgress: Boolean;
begin
  GetExitCodeProcess(ProcInfo.hProcess, ec);
  CursorPos.x := 0;
  CursorPos.y := 0;
  DecimalSeparator := '.'; //In localized Windows it could be a comma ','
  SingleProgress := 0;
  MultiProgress  := 0;
  Offset         := 0;
  CurRepeat      := 1; //This needs to be 1 becouse the first time this value isn't from UPX.EXE
  MultiRepeat := TStringList.Create;

  //Check if UPX will do more then only 1 compression cycle, and get the current cycle.
  if MainForm.chkUPX2.Checked and
     SetupForm.chkBrute.Checked or
     SetupForm.chkFilters.Checked or
     SetupForm.chkMethods.Checked then
  begin
    IsMultiProgress := true;
  end
  else
  begin
    IsMultiProgress := false;
  end;

  while True do //Let's find where the progress starts
  begin
    ReadConsoleOutputCharacter(hStdOut, Line, 80, CursorPos, charsRead);
    Offset := pos('[', Line) - 1;
    if Offset > -1 then
    begin
      break;
    end
    else begin
      Inc(CursorPos.Y);
    end;
    if CursorPos.Y > 20 then
    begin //If we get here - something's wrong
      CursorPos.Y := 0;
      GetExitCodeProcess(ProcInfo.hProcess, ec);
      if ec <= 2 then
      begin
        Exit;
      end;
    end;
  end;

  while ec > 2 do //ec >= STILL_ACTIVE
  begin
    {**
     Line[Offset + 1] = The first . or * for the progressbar
     Line[64] = The last . or * for the progressbar
    **}
    ReadConsoleOutputCharacter(hStdOut, Line, 80, CursorPos, charsRead);
    if Line[Offset] = '[' then
    begin
      CompressSize := '';
      TotalProgress := 65 - (Offset + 1);

      If IsMultiProgress then
      begin
        Split('/',
              Trim(Line[Offset-7] + Line[Offset-6] + Line[Offset-5] +
                   Line[Offset-4] + Line[Offset-3] + Line[Offset-2]),
              MultiRepeat);

        if (CurRepeat = StrToInt(MultiRepeat[0])) then
        begin
          for c := (Offset + 1) + SingleProgress to 64 do
          begin
            if Line[c] = '*' then
            begin
              Inc(SingleProgress);
              Inc(MultiProgress);
            end
            else
            begin
              Break;
            end;
          end;
        end;

        (* //This is here for debuging
        MainForm.Label1.Caption := 'MultiProg: ' + IntToStr(MultiProgress) +
                                   '| SingelProg: ' + IntToStr(SingleProgress) +
                                   '| TotalProg: ' + IntToStr(TotalProgress * StrToInt(MultiRepeat[1])) +
                                   '| CurrRepeat: ' + MultiRepeat[0] + '[' + IntToStr(CurRepeat) + ']' +
                                   '| TotalRepeat: ' + MultiRepeat[1] + '';
        *)
        if (SingleProgress = TotalProgress) then
        begin
          Inc(CurRepeat);
          SingleProgress := 0;
        end;

      end
      else
      begin
        for c := (Offset + 1) + SingleProgress to 64 do
        begin
          if Line[c] = '*' then
          begin
            Inc(SingleProgress);
          end
          else
          begin
            Break;
          end;
        end;
      end;

      if IsMultiProgress then
      begin
        ProgressValue := floor((MultiProgress / (TotalProgress * StrToInt(MultiRepeat[1]))) * 100);
      end
      else
      begin
        ProgressValue := floor((SingleProgress / TotalProgress) * 100);
      end;

      CompressSize := Line[69] + Line[70] + Line[71] + Line[72]; //The percentage of the compression
      MainForm.prbSize.Progress := round(strtofloat(CompressSize));
      MainForm.prbCompress.Progress := ProgressValue;
      Application.Title := 'UPX Shell - ' + IntToStr(ProgressValue) + '%';
      sleep(50);
      Application.ProcessMessages;
      if ProgressValue >= 100 then
      begin
        Exit;
      end;
    end;
    GetExitCodeProcess(ProcInfo.hProcess, ec);
  end;
  Application.Title := 'UPX Shell';
end;

//Gets compression ratio
function GetRatio: integer;
var
  finalsz: integer;
  Size:    integer;
begin
  MainForm.prbCompress.Progress := 100;
  Finalsz := GetFileSize(GlobFileName);
  Size    := round((finalsz / FileSize) * 100);
  with MainForm do
  begin
    lblCSizeCap.Visible := True;
    lblCSize.Visible    := True;
    lblCSize.Caption    := ProcessSize(finalsz);
    prbSize.Progress    := size;
    bvlRatio.Visible    := True;
    lblRatioCap.Visible := True;
    lblRatio.Visible    := True;
    lblRatio.Caption    := IntToStr(size) + ' %';
    if lblFSize.Width > lblCSize.Width then
    begin
      bvlRatio.Width := lblFSize.Width + 10;
      bvlRatio.Left  := lblFSize.Left - 5;
    end
    else begin
      bvlRatio.Width := lblCSize.Width + 10;
      bvlRatio.Left  := lblCSize.Left - 5;
    end;
  end;
  Result := size;
end;
 //This is used for setting the size of the
 //blue line (when decompressing files)
procedure SetStatBar(Value: integer);
var
  TrackLen: integer;
  StatLen:  integer;
begin
  TrackLen := MainForm.prbSize.Width;
  StatLen  := round((TrackLen / Value) * 100);
  MainForm.sttDecomp.Width := StatLen - 3;
end;

procedure ResetVisuals;
begin
  with MainForm do
  begin
    prbSize.Progress     := 0;
    prbCompress.Progress := 0;
    sttDecomp.Width      := 0;
  end;
end;

//Sets statusbar text
function SetStatus(ExitCode: cardinal; Compress: TCompDecomp): TCompResult;
var
  CompResult: TCompResult;

  procedure SetSuccess;
  begin
    if Compress = cdCompress then
    begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('File successfully compressed');
    end
    else begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('File successfully decompressed');
    end;
    CompResult := crSuccess;
  end;

  procedure SetWarning;
  begin
    if Compress = cdCompress then
    begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('File compressed with warnings');
    end
    else begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('File decompressed with warnings');
    end;
    CompResult := crWarning;
  end;

  procedure SetError;
  begin
    if Compress = cdCompress then
    begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('Errors occured. File not compressed');
    end
    else begin
      MainForm.stbMain.Panels[1].Text :=
        TranslateMsg('Errors occured. File not decompressed');
    end;
    CompResult := crError;
  end;

begin
  case ExitCode of
    0:
    begin
      SetSuccess;
    end; //Successfull compression
    1:
    begin
      SetError;
    end; //Errors encountered - unsuccessfull compression
    2:
    begin
      SetWarning;
    end; //Warnings encountered while compressing
    else
    begin
      SetWarning;
    end
  end;
  Result := CompResult;
end;

//Does exactly the same as above, except for that it sets test results
procedure SetStatusTest(ExitCode: cardinal);
begin
  case ExitCode of
    0:
    begin
      MainForm.stbMain.Panels[1].Text := MainForm.stbMain.Panels[1].Text +
        TranslateMsg(' & tested');
    end; //Successfull testing
    1:
    begin
      MainForm.stbMain.Panels[1].Text := MainForm.stbMain.Panels[1].Text +
        TranslateMsg(' & tested w/warnings');
    end; //Warnings encountered while testing
    2:
    begin
      MainForm.stbMain.Panels[1].Text := MainForm.stbMain.Panels[1].Text +
        TranslateMsg(' & test failed');
    end; //Errors encountered - unsuccessfull test
    else
    begin
      MainForm.stbMain.Panels[1].Text := MainForm.stbMain.Panels[1].Text +
        TranslateMsg(' & tested w/warnings');
    end;
  end;
end;

//Reads error line (6) from upx console and shows the error message
procedure GetErrorText;

  function ReadErrorLine(i: integer): string;
  var
    TextLen:   DWord;
    CursorPos: TCoord;
    CharsRead: DWord;
  begin
    TextLen := high(TLine);
    SetLength(Result, high(TLine));
    CursorPos.x := 0;
    CursorPos.y := i;
    charsRead   := 0;
    ReadConsoleOutputCharacter(hStdOut, @Result[1], textlen,
      CursorPos, charsRead);
  end;

var
  Error: string;
begin
  Error := PChar(Trim(ReadErrorLine(6)));
  if Error <> '' then
  begin
    beep;
    Error := TranslateMsg('UPX returned following error: ') + Error;
    Application.MessageBox(PChar(Error), TranslateMsg('Error'),
      MB_OK + MB_ICONERROR);
  end;
end;

function TestFile: cardinal;
var
  StartInfo: Tstartupinfo;
  ProcInfo:  TProcessInformation;
  Params:    string;
  ExitCode:  cardinal;
begin
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  with StartInfo do
  begin
    cb      := SizeOf(StartInfo);
    dwFlags := startf_UseShowWindow;
    wShowWindow := 2;
    StartInfo.lpTitle := PChar('UPX Shell 3.x - ' + GlobFileName);
  end;
  Params := WorkDir + 'upx.exe -t ' + GlobFileName;
  Createprocess(nil, PChar(Params), nil, nil, True, Create_default_error_mode,
    nil, PChar(workdir), StartInfo, ProcInfo);
  Waitforsingleobject(ProcInfo.hProcess, infinite);
  GetExitCodeProcess(ProcInfo.hProcess, ExitCode);
  Result := ExitCode;
end;

procedure CompressFile(const Params: string; Compress: TCompDecomp);
var
  StartInfo:  Tstartupinfo;
  ProcInfo:   TProcessInformation;
  ExitCode:   cardinal;
  CompResult: TCompResult;
begin
  ResetVisuals;
  CalcFileSize;
  AllocateConsole;
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  with StartInfo do
  begin
    cb      := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := 2;
    lpTitle := PChar('UPX Shell 3.x - ' + GlobFileName);
  end;
  ExtractUPX(edExtract);
  SetCurrentDir(WorkDir);
  //Now start upx.exe with specified parameters
  CreateProcess(nil, PChar(Params), nil, nil, True, Create_default_error_mode +
    GetPriority, nil, PChar(workdir), StartInfo, ProcInfo);
  FindWin; //Hide console window if it still shows
  if Compress = cdCompress then
  begin
    GetProgress(ProcInfo);
  end;
  WaitForSingleObject(ProcInfo.hProcess, infinite);
  GetExitCodeProcess(ProcInfo.hProcess, ExitCode);
  CompResult := SetStatus(ExitCode, Compress);
  case CompResult of
    crSuccess:
    begin
      CompressionResult := True;
      if Compress = cdCompress then
      begin
        GetRatio;
      end
      else begin
        SetStatBar(GetRatio);
      end;
    end;
    crWarning, crError:
    begin
      CompressionResult := False;
      GetErrorText; //Shows error message
    end;
  end;
  //Check whether to test the compressed file
  if (MainForm.chkTest.Checked) and (Compress = cdCompress) and
    (CompResult = crSuccess) then
  begin
    ExitCode := TestFile;
    SetStatusTest(ExitCode);
  end;
  ExtractUpx(edDelete);
  if AlreadyPacked then
    //This one checks if the file is compressed and sets checkbox
  begin
    MainForm.chkDecomp.Checked := True;
    sUPXVersion := GetUPXVersion(GlobFileName);
    MainForm.chkUPX1.Enabled := False;
    MainForm.chkUPX2.Enabled := False;
  end
  else begin
    MainForm.chkDecomp.Checked := False;
    sUPXVersion := '';
    MainForm.chkUPX1.Enabled := True;
    MainForm.chkUPX2.Enabled := True;
    if bStdUPXVersion = 2 then
    begin
      MainForm.chkUPX2.Checked := True;
    end
    else begin
      MainForm.chkUPX1.Checked := True;
    end;
  end;
end;

end.

