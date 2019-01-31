 {**************--===ION Tek===--****************}
 { Shared procedures unit                        }
 {***********************************************}
unit Shared;

interface

uses
  Windows, Forms, Classes, Graphics, Dialogs, Globals;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
procedure ExtractRes(const ResType, ResName, ResNewName: string); //Extracts upx.exe and ups.exe
function GetPriority: cardinal; //Gets priority selected on the SetupForm
 //Function StrDiv(Const InStr: String): String;
function AlreadyPacked: boolean;
function GetCompressParams: string;
procedure ExtractUPX(const Action: TExtractDelete);
procedure ScrambleUPX;
function GetUPXVersion(const FileName: string): string;
function GetBuild(const BuildInfo: TBuildInfo): string;
procedure DrawGradient(const DrawCanvas: TCanvas;
  const ColorCycles, Height, Width: integer;
  const StartColor, EndColor: TColor);
 //Procedure DrawGradientVertical(Const DrawCanvas: TCanvas;
 //  Const ColorCycles, Height, Width: Integer;
 //  Const StartColor, EndColor: TColor);
function ProcessSize(const Size: integer): string;
//Function AnalyzeFileSize(Const FileName: String): String;
function GetFileSize(const FileName: string): integer;
 //Function TokenizeStr(Const InStr: String): TTokenStr;
 //Function IsNumber(Const InStr: String): Boolean;
 //Procedure WriteLog(Const InStr: String);
function GetStringProperty(Component: TComponent;
  const PropName: string): string;
procedure SetStringProperty(AComp: TComponent; const APropName: string;
  const AValue: string);
function GetComponentTree(Component: TComponent): string;
function IsNumeric(const InStr: string): boolean;
function PropertyExists(Component: TComponent;
  const PropName: string): boolean;

implementation

uses
  SysUtils, TypInfo,
  UPXScrambler, Translator,
  MainFrm, SetupFrm;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

//Extract resources from the upxshell.exe (upx.exe)
procedure ExtractRes(const ResType, ResName, ResNewName: string);
var
  Res: TResourceStream;
begin
  try
    Res := TResourceStream.Create(Hinstance, Resname, PChar(ResType));
    Res.SavetoFile(ResNewName);
  finally
    FreeAndNil(Res);
  end;
end;
 //This one is used for getting the priority of the compression
 //and the scrambler thread
function GetPriority: cardinal;
var
  Priority: integer;
begin
  priority := SetupForm.cmbPriority.ItemIndex;
  case priority of
    0:
    begin
      Result := IDLE_PRIORITY_CLASS;
    end;
    1:
    begin
      Result := NORMAL_PRIORITY_CLASS;
    end;
    2:
    begin
      Result := HIGH_PRIORITY_CLASS;
    end;
    3:
    begin
      Result := REALTIME_PRIORITY_CLASS;
    end;
    else
    begin
      Result := NORMAL_PRIORITY_CLASS;
    end;
  end;
end;

(* //Function not used in UPXShell
//Puts a a space after every third character
Function StrDiv(Const InStr: String): String;
Var
  outstr: Array[1..255] Of Char;
  i, c, m, l: Integer;
Begin
  i := 0;
  c := 0;
  m := length(instr);
  l := m Div 3;
  fillchar(outstr, 255, #0);
  While i <= length(instr) + c Do
  Begin
    inc(i);
    If (i Mod 4 <> 0) Then
      outstr[m + l] := instr[m + c]
    Else
    Begin
      outstr[m + l] := ' ';
      inc(c);
    End;
    dec(m);
  End;
  Result := Trim(outstr);
End;
*)
//Analyzes the file to check if it's already compressed
function AlreadyPacked: boolean;
var
  f: TFileStream;
  GlobalChain: array[1..$3F0] of char;
begin
  try
    f := TFileStream.Create(GlobFileName, fmOpenRead);
    f.Position := 0;
    try
      f.ReadBuffer(GlobalChain, $3EF);
    except
      on E: Exception do
      begin
        //TODO: Change message to something else. Add also for translation.
        MessageBox(0, TranslateMsg(
          'Could not access file. It may be allready open!'),
          TranslateMsg('Error'), MB_ICONERROR or MB_OK);
      end;
    end;
    if pos('UPX', GlobalChain) <> 0 then
    begin
      Result := True;
    end
    else begin
      Result := False;
    end;
    // offset $34b... test the typical string in .EXE & .DLL 'This file is packed with the UPX'
    // offset $1F9... test string in .SCR 'This file is packed with the UPX'
    // offset $55... string 'UPX' in .COM
    // new offset in .EXE in UPX 1.08
    // another offset in .EXE in UPX 1.20
  finally
    FreeAndNil(f);
  end;
end;
//Gets compression parameters to be passed to upx
function GetCompressParams: string;
begin
  with MainForm do
  begin
    Result := workdir + 'upx.exe ' + '"' + GlobFileName + '"';
    if not chkDecomp.Checked then
    begin
      if trbCompressLvl.Position < 10 then
      begin
        Result := Result + ' -' + IntToStr(trbCompressLvl.Position);
      end
      else begin
        Result := Result + ' --best';
      end;
      if SetupForm.chkCompression.Checked then
      begin
        Result := Result + ' --crp-ms=' +
          IntToStr(SetupForm.trbCompression.Position);
      end;
      if SetupForm.chkForce.Checked then
      begin
        Result := Result + ' --force';
      end;
      if SetupForm.chkResources.Checked then
      begin
        Result := Result + ' --compress-resources=1';
      end
      else begin
        Result := Result + ' --compress-resources=0';
      end;
      if SetupForm.chkRelocs.Checked then
      begin
        Result := Result + ' --strip-relocs=1';
      end
      else begin
        Result := Result + ' --strip-relocs=0';
      end;
      if chkBackup.Checked then
      begin
        Result := Result + ' -k';
      end;
      case SetupForm.cmbIcons.ItemIndex of
        0:
        begin
          Result := Result + ' --compress-icons=2';
        end;
        1:
        begin
          Result := Result + ' --compress-icons=1';
        end;
        2:
        begin
          Result := Result + ' --compress-icons=0';
        end;
      end;
      if SetupForm.chkExports.Checked then
      begin
        Result := Result + ' --compress-exports=1';
      end
      else begin
        Result := Result + ' --compress-exports=0';
      end;
      //UPX v1.9x Only
      if MainForm.chkUPX2.Checked then
      begin
        if SetupForm.chkBrute.Checked then
        begin
          Result := Result + ' --brute';
        end
        else
        begin
          if SetupForm.chkMethods.Checked then
          begin
            Result := Result + ' --all-methods';
          end;
          if SetupForm.chkFilters.Checked then
          begin
            Result := Result + ' --all-filters';
          end;
        end;
      end;
      Result := Result + ' ' + SetupForm.edtCommands.Text;
    end
    else begin
      Result := Result + ' -d';
    end;
  end;
end;

procedure ExtractUPX(const Action: TExtractDelete);
var
  sExtractVersion: string;
begin
  SetCurrentDir(WorkDir);
  if Action = edExtract then
  begin
    if FileExists(workdir + 'upx.exe') then
    begin
      UpxExist := True;
    end
    else begin
      UpxExist := False;
      //Check what version to extract
      if MainForm.chkUPX1.Checked then
      begin
        sExtractVersion := '1.25';
      end
      else begin
        if MainForm.chkUPX2.Checked then
        begin
          sExtractVersion := '1.93';
        end
        else begin
          sExtractVersion := sUPXVersion;
        end;
      end;
      if sExtractVersion = '1.93' then
      begin
        //Extract UPX Version 1.93
        ExtractRes('EXEFILE', 'UPX193', WorkDir + 'UPX.EXE');
      end
      else begin
        //Extract UPX Version 1.25
        ExtractRes('EXEFILE', 'UPX125', WorkDir + 'UPX.EXE');
      end;
    end;
  end
  else begin
    if not UpxExist then
    begin
      DeleteFile(workdir + 'UPX.EXE');
    end;
  end;
end;

{*****************************************
* This Function Scrambles the UPXed file *
*****************************************}
procedure ScrambleUPX;
var
  Scrambled: boolean;
begin
  if GlobFileName <> '' then
  begin
    if AlreadyPacked then
    begin
      Scrambled := fScrambleUPX(GlobFileName);
      if Scrambled then
      begin
        MainForm.chkDecomp.Checked  := False;
        MainForm.stbMain.Panels[1].Text :=
          MainForm.stbMain.Panels[1].Text + TranslateMsg(' & scrambled');
      end
      else begin
        MainForm.stbMain.Panels[1].Text :=
          MainForm.stbMain.Panels[1].Text + TranslateMsg(' & scrambled') +
          ' ' + TranslateMsg('Failed');
      end;
    end
    else begin
      if Application.MessageBox(TranslateMsg(
        'This file doesn''t seem to be packed. Run the Scrambler?'),
        TranslateMsg('Confirmation'), MB_YESNO + MB_ICONEXCLAMATION) =
        idYes then
      begin
        Scrambled := fScrambleUPX(GlobFileName);
        if Scrambled then
        begin
          MainForm.chkDecomp.Checked  := False;
          MainForm.stbMain.Panels[1].Text :=
            MainForm.stbMain.Panels[1].Text + TranslateMsg(' & scrambled');
        end
        else begin
          MainForm.stbMain.Panels[1].Text :=
            MainForm.stbMain.Panels[1].Text + TranslateMsg(' & scrambled') +
            ' ' + TranslateMsg('Failed');
        end;
      end;
    end;
  end;
end;

{*****************************************
* This Function extracts the UPX Version *
*****************************************}
function GetUPXVersion(const FileName: string): string;
var
  fsSource:     TFileStream;
  GlobalChain:  array[1..$3F0] of char;
  VersionChain: array[1..$4] of char;
  PosString:    integer;
  UPXVersion:   string;
begin
  try
    fsSource := TFileStream.Create(FileName, fmOpenRead);
    fsSource.Position := 0;
    fsSource.Seek(0, soFromBeginning);
    fsSource.ReadBuffer(GlobalChain, $3EF);
    //Reading old UPX version number
    if pos('$Id: UPX', GlobalChain) <> 0 then
    begin
      PosString := (pos('$Id: UPX', GlobalChain) - 1);
      fsSource.Seek((PosString + 9), soFromBeginning);
      fsSource.ReadBuffer(VersionChain, $4);
      UPXVersion := VersionChain;
      Result     := UPXVersion;
    end
    //Else, reading new UPX version number
    else begin
      if pos(#$00'UPX!', GlobalChain) <> 0 then
      begin
        PosString := (pos(#$00'UPX!', GlobalChain) - 1);
        fsSource.Seek((PosString - 4), soFromBeginning);
        fsSource.ReadBuffer(VersionChain, $4);
        UPXVersion := VersionChain;
        Result     := UPXVersion;
      end;
    end;
  finally
    FreeAndNil(fsSource);
  end;
end;

{ Returns verson info from FileName in dotted decimal string format:
  Release.Major.Minor.Build (biFull)
  or Release.Major.Minor (biNoBuild)
  or Release.MajorMinor (biCute)
  or each one separately (biMajor, biMinor, biRelease, biBuild) }
function GetBuild(const BuildInfo: TBuildInfo): string;
var
  dwI, dwJ: dword;
  VerInfo:  Pointer;
  VerValue: PVSFixedFileInfo;
begin
  Result := '';
  dwI    := GetFileVersionInfoSize(PChar(Application.ExeName), dwJ);
  if dwI > 0 then
  begin
    VerInfo := nil;
    try
      GetMem(VerInfo, dwI);
      GetFileVersionInfo(PChar(Application.ExeName), 0, dwI, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), dwJ);
      case BuildInfo of
        biFull:
        begin
          with VerValue^ do
          begin
            Result := IntToStr(dwFileVersionMS shr 16) + '.';
            Result := Result + IntToStr(dwFileVersionMS and $FFFF) + '.';
            Result := Result + IntToStr(dwFileVersionLS shr 16) + '.';
            Result := Result + IntToStr(dwFileVersionLS and $FFFF);
          end;
        end;
        biNoBuild:
        begin
          with VerValue^ do
          begin
            Result := IntToStr(dwFileVersionMS shr 16) + '.';
            Result := Result + IntToStr(dwFileVersionMS and $FFFF) + '.';
            Result := Result + IntToStr(dwFileVersionLS shr 16);
          end;
        end;
        biCute:
        begin
          with VerValue^ do
          begin
            Result := IntToStr(dwFileVersionMS shr 16) + '.';
            Result := Result + IntToStr(dwFileVersionMS and $FFFF);
            Result := Result + IntToStr(dwFileVersionLS shr 16);
          end;
        end;
        biRelease:
        begin
          Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
        end;
        biMajor:
        begin
          Result := IntToStr(VerValue^.dwFileVersionMS and $FFFF);
        end;
        biMinor:
        begin
          Result := IntToStr(VerValue^.dwFileVersionLS shr 16);
        end;
        biBuild:
        begin
          Result := IntToStr(VerValue^.dwFileVersionLS and $FFFF);
        end;
      end;
    finally
      FreeMem(VerInfo, dwI);
    end;
  end;
end;
//These are the proceudres to draw that gradient near UPX logo
type
  TCustomColorArray = array[0..255] of TColor;

function CalculateColorTable(StartColor, EndColor: TColor;
  ColorCycles: integer): TCustomColorArray;
var
  BeginRGB:   array[0..2] of byte;
  DiffRGB:    array[0..2] of integer;
  R, G, B, I: byte;
begin
  BeginRGB[0] := GetRValue(ColorToRGB(StartColor));
  BeginRGB[1] := GetGValue(ColorToRGB(StartColor));
  BeginRGB[2] := GetBValue(ColorToRGB(StartColor));
  DiffRGB[0]  := GetRValue(ColorToRGB(EndColor)) - BeginRGB[0];
  DiffRGB[1]  := GetGValue(ColorToRGB(EndColor)) - BeginRGB[1];
  DiffRGB[2]  := GetBValue(ColorToRGB(EndColor)) - BeginRGB[2];
  for i := 0 to 255 do
  begin
    R := BeginRGB[0] + MulDiv(I, DiffRGB[0], ColorCycles - 1);
    G := BeginRGB[1] + MulDiv(I, DiffRGB[1], ColorCycles - 1);
    B := BeginRGB[2] + MulDiv(I, DiffRGB[2], ColorCycles - 1);
    Result[i] := RGB(R, G, B);
  end;
end;

procedure DrawGradient(const DrawCanvas: TCanvas;
  const ColorCycles, Height, Width: integer;
  const StartColor, EndColor: TColor);
var
  Rec:  TRect;
  i:    integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
begin
  try
    ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
    Temp     := TBitmap.Create;
    Temp.Width := Width;
    Temp.Height := Height;
    Rec.Top  := 0;
    Rec.Bottom := Height;
    with Temp do
    begin
      for I := 0 to ColorCycles do
      begin
        Rec.Left  := MulDiv(I, Width, ColorCycles);
        Rec.Right := MulDiv(I + 1, Width, ColorCycles);
        Canvas.Brush.Color := ColorArr[i];
        Canvas.FillRect(Rec);
      end;
    end;
    DrawCanvas.Draw(0, 0, Temp);
  finally
    FreeAndNil(Temp);
  end;
end;

(* //Functions not used in UPXShell
Procedure DrawGradientVertical(Const DrawCanvas: TCanvas;
  Const ColorCycles, Height, Width: Integer;
  Const StartColor, EndColor: TColor);
Var
  Rec: TRect;
  i: Integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
Begin
  ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
  Temp := TBitmap.Create;
  Try
    Temp.Width := Width;
    Temp.Height := Height;
    Rec.Left := 0;
    Rec.Right := Width;
    With Temp Do
      For I := 0 To ColorCycles Do
      Begin
        Rec.Top := MulDiv(I, Height, ColorCycles);
        Rec.Bottom := MulDiv(I + 1, Height, ColorCycles);
        Canvas.Brush.Color := ColorArr[i];
        Canvas.FillRect(Rec);
      End;
    DrawCanvas.Draw(0, 0, Temp);
  Finally
    FreeAndNil(Temp);
  End;
End;
Procedure DrawGradientPartial(DrawCanvas: TCanvas; ColorCycles, Height, Width: Integer;
  StartPos: Integer; StartColor, EndColor: TColor);
Var
  Rec: TRect;
  i: Integer;
  Temp: TBitmap;
  ColorArr: TCustomColorArray;
Begin
  Try
    ColorArr := CalculateColorTable(StartColor, EndColor, ColorCycles);
    Temp := TBitmap.Create;
    Temp.Width := Width;
    Temp.Height := Height;
    Rec.Top := 0;
    Rec.Bottom := Height;
    With Temp Do
      For I := 0 To ColorCycles Do
      Begin
        Rec.Left := MulDiv(I, Width, ColorCycles);
        Rec.Right := MulDiv(I + 1, Width, ColorCycles);
        Canvas.Brush.Color := ColorArr[i];
        Canvas.FillRect(Rec);
      End;
    DrawCanvas.Draw(StartPos, 0, Temp);
  Finally
    FreeAndNil(Temp);
  End;
End;
*)
function ProcessSize(const Size: integer): string;
begin
  Result := IntToStr(Size);
  case length(Result) of
    1..3:
    begin
      Result := IntToStr(size) + ' B';
    end;
    4..6:
    begin
      Result := IntToStr(Size shr 10) + ' KB';
    end;
    7..9:
    begin
      Result := IntToStr(Size shr 20) + ' MB';
    end;
    10..12:
    begin
      Result := IntToStr(Size shr 30) + ' GB';
    end;
  end;
end;

(* //Function not used in UPXShell
Function AnalyzeFileSize(Const FileName: String): String;
Var
  Size: Integer;
Begin
  If GetFileSize(FileName) <> 0 Then
  Begin
    Size := GetFileSize(FileName);
    Result := ProcessSize(Size);
  End
  Else
  Begin
    Result := 'I/O Error';
  End;
End;
*)
function GetFileSize(const FileName: string): integer;
var
  sr: TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, sr) = 0 then
  begin
    Result := sr.Size;
  end
  else begin
    Result := -1;
  end;
  FindClose(sr);
end;

(* //Functions not used in UPXShell
Function TokenizeStr(Const InStr: String): TTokenStr;
Var
  i: Integer;
  GetVal: Boolean;
Begin
  If trim(InStr) <> '' Then
  Begin
    GetVal := False;
    SetLength(Result, length(Result) + 1);
    For i := 1 To Length(InStr) Do
    Begin
      If InStr[i] = ' ' Then
      Begin
        GetVal := False;
        SetLength(Result, length(Result) + 1);
      End
      Else
      Begin
        If GetVal Then
          Result[high(Result)].Value := Result[high(Result)].Value + InStr[i]
        Else
          If InStr[i] = '=' Then
            GetVal := True
          Else
            Result[high(Result)].Token := Result[high(Result)].Token + InStr[i];
      End;
    End;
  End;
End;
Function IsNumber(Const InStr: String): Boolean;
Const
  Digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
Var
  i: Integer;
Begin
  If trim(InStr) <> '' Then
  Begin
    Result := True;
    For i := 1 To length(InStr) Do
      If Not (InStr[i] In Digits) Then
      Begin
        Result := False;
        break;
      End;
  End
  Else
    Result := False;
End;
Procedure WriteLog(Const InStr: String);
Const
  CRLF = #13#10;
  TimeFormat = 'dd/mm/yy||hh:nn:ss' + #09;
Var
  fs: TFileStream;
  filemode: Word;
  date: String;
Begin
  If Globals.Config.DebugMode Then
  Begin
    If FileExists('log.txt') Then
      filemode := fmOpenReadWrite
    Else
      filemode := fmCreate;
    fs := TFileStream.Create('log.txt', filemode);
    Try
      fs.Seek(0, soFromEnd);
      date := FormatDateTime(TimeFormat, now);
      fs.Write((@date[1])^, length(date));
      fs.Write((@InStr[1])^, length(InStr));
      fs.Write(CRLF, length(CRLF));
    Finally
      FreeAndNil(fs);
    End;
  End;
End;
*)

function GetStringProperty(Component: TComponent;
  const PropName: string): string;
var
  PropInfo: PPropInfo;
  TK: TTypeKind;
begin
  Result   := '';
  PropInfo := GetPropInfo(Component.ClassInfo, PropName);
  if PropInfo <> nil then
  begin
    TK := PropInfo^.PropType^.Kind;
    if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
    begin
      Result := GetStrProp(Component, PropInfo);
    end;
  end;
end;

procedure SetStringProperty(AComp: TComponent; const APropName: string;
  const AValue: string);
var
  PropInfo: PPropInfo;
  TK: TTypeKind;
begin
  PropInfo := GetPropInfo(AComp.ClassInfo, APropName);
  if PropInfo <> nil then
  begin
    TK := PropInfo^.PropType^.Kind;
    if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
    begin
      SetStrProp(AComp, PropInfo, AValue);
    end;
  end;
end;

function GetComponentTree(Component: TComponent): string;
var
  Owner: TComponent;
begin
  Result := Component.Name;
  Owner  := Component.Owner;
  while Owner <> Application do
  begin
    Result := Owner.Name + '.' + Result;
    Owner  := Owner.Owner;
  end;
end;

function IsNumeric(const InStr: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to length(InStr) do
  begin
    if not (InStr[i] in ['1'..'9', '0']) then
    begin
      Result := False;
      break;
    end;
  end;
end;

function PropertyExists(Component: TComponent;
  const PropName: string): boolean;
var
  PropInfo: PPropInfo;
  TK: TTypeKind;
begin
  Result   := False;
  PropInfo := GetPropInfo(Component.ClassInfo, PropName);
  if PropInfo <> nil then
  begin
    TK := PropInfo^.PropType^.Kind;
    if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
    begin
      Result := True;
    end;
  end;
end;

end.


