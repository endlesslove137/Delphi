unit ScriptIncludeFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,  StdCtrls,  ExtCtrls,  Mask,
  ComCtrls, acProgressBar,strutils,clipbrd,
  sGroupBox, RzEdit, RzBtnEdt, RzPanel, RzLstBox, RzSplit, RzPrgres,
  RzShellDialogs, Menus, RzButton, RzRadChk;
const
 sg_sEngineRoot = 'D:\mine\百度网盘\我的文档\work\program\521g\idgp\AnHei\!SC\Server\data';
 sTotal = '共搜索到%d个文件(.txt)';
 sProgress = '计算结果[重复引用 %d / 共有引用 %d]';

type
  pincludeINFO = ^TincludeINFO;
  TincludeINFO = record
    includeStr:tstringlist;
//    Filename:string;
    FirstFilename:string;
    Files:tstringlist;
  end;
  TForm1 = class(TForm)
    rzgrpbx1: TRzGroupBox;
    btn1: TRzButtonEdit;
    btn2: TSpeedButton;
    RZPG1: TRzProgressBar;
    RzSplitter1: TRzSplitter;
    rzgrpbxGpInclude: TRzGroupBox;
    RzListBox1: TRzListBox;
    rzgrpbx2: TRzGroupBox;
    RzListBox2: TRzListBox;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    pm1: TPopupMenu;
    R1: TMenuItem;
    btn3: TRzButtonEdit;
    btn4: TSpeedButton;
    od1: TRzOpenDialog;
    RzCheckBox1: TRzCheckBox;
    procedure tsb1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RzListBox1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn3ButtonClick(Sender: TObject);
  private
    procedure GetIncdude(const LuaFilename: string; Bexpand:boolean=false);
    procedure ClearIncdudelist;
    procedure SetContByFile(edit: TRzButtonEdit; const FileExt: string;
      Sb: TSpeedButton);
    procedure DeleteMoreInclude;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IncludeList :tstringlist;
  g_sEngineRoot: string;
implementation

{$R *.dfm}




function MakeFileList(Path,FileExt:string):TStringList ;
var
 sch:TSearchrec;
begin
  Result:=TStringlist.Create;

  if rightStr(trim(Path), 1) <> '\' then
      Path := trim(Path) + '\'
  else
      Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
      Result.Clear;
      exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
      repeat
         if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
         if DirectoryExists(Path+sch.Name) then
         begin
           Result.AddStrings(MakeFileList(Path+sch.Name,FileExt));
         end
         else
         begin
           if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt)) or (FileExt='.*') then
           Result.Add(Path+sch.Name);
         end;
      until FindNext(sch) <> 0;
      SysUtils.FindClose(sch);
  end;
end;

function LoadUTFFile(const FileName: string): string;
var
  MemStream: TMemoryStream;
  S, HeaderStr:string;
  strTmp: TStringList;
begin
  Result:='';
  if not FileExists(FileName) then Exit;
  MemStream := TMemoryStream.Create;
  try
    MemStream.LoadFromFile(FileName);
    SetLength(HeaderStr, 3);
    MemStream.Read(HeaderStr[1], 3);
    if HeaderStr = #$EF#$BB#$BF then
    begin
      SetLength(S, MemStream.Size - 3);
      MemStream.Read(S[1], MemStream.Size - 3);
      Result := Utf8ToAnsi(S);
    end else
    begin
      strTmp := TStringList.Create;
      try
        strTmp.LoadFromFile(FileName);
        S := strTmp.Text;
      finally
        strTmp.Free;
      end;
      Result := S;
    end;
  finally
    MemStream.Free;
  end;
end;


procedure TForm1.btn1ButtonClick(Sender: TObject);
begin
 if RzSelectFolderDialog1.Execute then
 begin
  btn1.Text := RzSelectFolderDialog1.SelectedPathName;
  btn2.Enabled := DirectoryExists(btn1.Text);
 end;

end;

procedure TForm1.btn2Click(Sender: TObject);
var
 txtfile:tstringlist;
 i:integer;
begin
 g_sEngineRoot := btn1.Text;

 txtfile := MakeFileList(g_sEngineRoot, '.txt');
 RZPG1.TotalParts := txtfile.Count;
 caption := format(sTotal, [RZPG1.TotalParts]);
 ClearIncdudelist;
 for i := 0 to txtfile.Count-1 do
 begin
  application.ProcessMessages;
  GetIncdude(txtfile[I]);
  RZPG1.IncPartsByOne;
  caption := format(sProgress, [I+1,RZPG1.TotalParts]);
 end;

 for i := IncludeList.Count-1 downto 0  do
 begin
   if pincludeINFO(IncludeList.Objects[i]).Files.Count <2 then
   begin
     pincludeINFO(IncludeList.Objects[i]).Files.Free;
     IncludeList.Delete(i);
   end;

 end;


 RzListBox1.Items.Assign(IncludeList);
 txtfile.Free;
end;

procedure TForm1.btn3ButtonClick(Sender: TObject);
begin
 SetContByFile(btn3, 'Txt文件|*.txt', btn4);
end;

procedure TForm1.SetContByFile(edit:TRzButtonEdit; Const FileExt:string; Sb:TSpeedButton);
begin
 OD1.Filter := FileExt;
 if OD1.Execute then
 begin
   edit.Text := OD1.FileName;
 end;
 if fileexists(edit.Text) then
   Sb.Enabled := true
 else
   Sb.Enabled := false;
end;


procedure TForm1.btn4Click(Sender: TObject);
var
 i, isum:integer;
begin
 g_sEngineRoot := btn1.Text;

 ClearIncdudelist;
 GetIncdude(btn3.Text, true);
 isum := IncludeList.Count;
 for i := IncludeList.Count-1 downto 0  do
 begin
   if pincludeINFO(IncludeList.Objects[i]).Files.Count <2 then
   begin
     pincludeINFO(IncludeList.Objects[i]).Files.Free;
     pincludeINFO(IncludeList.Objects[i]).includeStr.Free;
     IncludeList.Delete(i);
   end;
 end;
 caption := format(sProgress,[IncludeList.Count, isum] );
 RzListBox1.Items.Assign(IncludeList);
 if RzCheckBox1.Checked  then DeleteMoreInclude();

end;


procedure TForm1.ClearIncdudelist();
var
 i: integer;
begin
 try
  RzListBox2.Items.Clear;
   for i := 0 to IncludeList.Count-1 do
   begin
     pincludeINFO(IncludeList.Objects[i]).includeStr.Free;
     pincludeINFO(IncludeList.Objects[i]).Files.Free;
     dispose(pincludeINFO(IncludeList.Objects[i]));
   end;
   IncludeList.Clear;
 except
  IncludeList.Clear;
 end;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
 IncludeList := tstringlist.Create;
 IncludeList.Sorted := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 ClearIncdudelist;
 IncludeList.Free;
end;

procedure TForm1.GetIncdude(Const LuaFilename:string; Bexpand:boolean);
const
  sIncludeIdent = '--#include ';
  sFunctions = 'Functions\';
  slanguage = 'language\';
  sPatch = '\';
var
  I, nCount, J, nPos, iindex: Integer;
  sLine,sOldLine, sFile, sInclude,sPath: string;
  ScriptList: TStrings;
  boFound: Boolean;
  pinclude: pincludeINFO;
begin
  ScriptList := TStringList.Create;
  ScriptList.LoadFromFile(LuaFilename);

  nCount := ScriptList.Count;
  I := 0;
  sPath := '';
  for I :=0 to nCount-1  do
  begin
    sLine := ScriptList[I];
    sOldLine := sLine;
    if (Length(sLine) > Length(sIncludeIdent)) and (StrLIComp(PChar(sLine), sIncludeIdent, Length(sIncludeIdent)) = 0) then
    begin
      boFound := false;
      sInclude := '';
      nPos := Pos('"', sLine);
      if nPos > 0 then
      begin
        //../Config/DayTargetProgressConfig.txt"
        sLine := Copy(sLine, nPos + 1, Length(sLine) - nPos);
        nPos := Pos('"', sLine);
        if nPos > 0 then
        begin
          //../Config/DayTargetProgressConfig.txt
          sInclude := Copy(sLine, 1, nPos - 1);
        end;
      end
      else continue;

      if not boFound then
      begin
        sFile := extractfilepath(LuaFilename) + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + sPatch + sInclude;
        boFound := FileExists(  sFile );
      end;
      if boFound then
      begin
        sFile := ExpandFileName( sFile );//返回文件的全路径(含驱动器、路径
        sPath := ExtractFilePath(sFile);
        iindex := IncludeList.IndexOf( sFile );
        if iindex < 0 then
        begin
          new(pinclude);
          pinclude.firstFilename := LuaFilename;

          pinclude.includeStr := tstringlist.Create;
          pinclude.includeStr.sorted := True;
          pinclude.includeStr.Duplicates := dupIgnore;
          pinclude.includeStr.Add(sOldLine);

          pinclude.Files := tstringlist.Create;
          pinclude.Files.sorted := True;
          pinclude.Files.Duplicates := dupIgnore;
          pinclude.Files.Add(LuaFilename);

          IncludeList.AddObject(sFile, TOBJECT(pinclude));
        end
        else
        begin
          pinclude := pincludeINFO(IncludeList.Objects[iindex]);
          pinclude.Files.Add(LuaFilename);
          pinclude.includeStr.Add(sOldLine);
        end;
        if Bexpand then
        GetIncdude(sFile, Bexpand);
      end
    end;

  end;
  ScriptList.free;
end;


procedure TForm1.DeleteMoreInclude();
var
 i,j,k:integer;
 tempStringlist: tstringlist;
 pinclude: pincludeINFO;
 TempFile, TempInclude:string;
begin
 tempStringlist := tstringlist.Create;
 try
   RZPG1.TotalParts := IncludeList.Count;
   for i := IncludeList.Count-1 downto 0  do
   begin
     pinclude := pincludeINFO(IncludeList.Objects[i]);
     if pinclude.Files.Count >1 then
     begin
       for j := 0 to pinclude.Files.Count-1 do
       begin
        //保留第一个引用此文件的引用
        TempFile := pinclude.Files[j];
        if TempFile = pinclude.FirstFilename then continue;
        tempStringlist.LoadFromFile(TempFile);
        for k := 0 to pinclude.includeStr.Count-1 do
        begin
          TempInclude :=pinclude.includeStr[k];
          tempStringlist.Text := stringreplace(tempStringlist.Text, TempInclude,'',[rfReplaceAll])
        end;
        tempStringlist.SaveToFile(TempFile);
       end;
     end;
    RZPG1.IncPartsByOne;
   end;
 finally
  tempStringlist.Free;
 end;



end;


procedure TForm1.R1Click(Sender: TObject);
begin
 clipboard().astext := RzListBox2.Items[RzListBox2.ItemIndex]
end;

procedure TForm1.RzListBox1Click(Sender: TObject);
var
 i :integer;
begin
  i := RzListBox1.ItemIndex;
  RzListBox2.Items.Assign(pincludeINFO(IncludeList.Objects[i]).Files);
end;

procedure PerProcessLuaScript(sScritpFileName, sPatch: string; ScriptList: TStrings);
const
  sIncludeIdent = '--#include ';
  sFunctions = 'Functions\';
  slanguage = 'language\';
var
  I, nCount, J, nPos: Integer;
  sLine, sFile, sInclude,sPath: string;
  SL, Includeed: TStrings;
  boFound: Boolean;
begin
  Includeed := TStringList.Create;
  SL := TStringList.Create;
  (Includeed as TStringList).Sorted := True;

  nCount := ScriptList.Count;
  I := 0;
  sPath := '';
  while I < nCount do
  begin
    sLine := ScriptList[I];

    if (Length(sLine) > Length(sIncludeIdent)) and (StrLIComp(PChar(sLine), sIncludeIdent, Length(sIncludeIdent)) = 0) then
    begin
      sInclude := '';
      nPos := Pos('"', sLine);
      if nPos > 0 then
      begin
        //../Config/DayTargetProgressConfig.txt"
        sLine := Copy(sLine, nPos + 1, Length(sLine) - nPos);
        nPos := Pos('"', sLine);
        if nPos > 0 then
        begin
          //../Config/DayTargetProgressConfig.txt
          sInclude := Copy(sLine, 1, nPos - 1);
        end;
      end;

      sFile := sPatch + sInclude;
      boFound := FileExists(sFile );
      if not boFound then
      begin
        sFile := g_sEngineRoot + sPatch + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := sPath + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\item\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\store\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if not boFound then
      begin
        sFile := g_sEngineRoot + '\config\quest\' + sInclude;
        boFound := FileExists(  sFile );
      end;
      if boFound then
      begin
        sFile := ExpandFileName( sFile );//返回文件的全路径(含驱动器、路径
        sPath := ExtractFilePath(sFile);
        if Includeed.IndexOf( sFile ) < 0 then
        begin
          Includeed.Add( sFile );
          SL.Text := LoadUTFFile(sFile);
          ScriptList[I] := '';
          for J := 0 to SL.Count - 1 do
          begin
            ScriptList.Insert( I + 1 + J, SL[J] );
          end;
          Inc( nCount, SL.Count );
        end;
      end
      else begin
        ShowMessage( Format('[脚本错误]"%s"包含文件"%s"未找到', [sScritpFileName, sFile]) );
      end;
    end;
    Inc( I );
  end;
  SL.Free;
  Includeed.Free;
end;

procedure TForm1.tsb1Click(Sender: TObject);
const
  szFileName = '\config\item\StdItems.txt';
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(g_sEngineRoot+ szFileName);
    PerProcessLuaScript(g_sEngineRoot+ szFileName, '\', SL);
//    ts1.Items.Assign(SL);
  finally
    SL.Free;
  end;
end;

end.
