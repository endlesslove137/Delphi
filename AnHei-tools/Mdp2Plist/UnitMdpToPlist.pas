unit UnitMdpToPlist;

interface


uses
  Windows, Messages, SysUtils,Registry, Variants, Classes, Graphics,msxml, Controls, Forms, ShellAPI,ActiveX,
  Dialogs, StdCtrls, ExtCtrls, XMLDoc,XMLIntf, Spin, StrUtils, ComCtrls, Buttons,UnitStdXmlForm ,UnitThreadTexture;
const
  //怪物_模型ID_动作帧数_图原名
  FNfmt = '%s_%d_%d_%d.png';
  EffectFNfmt = '%s_%d_%d.png';
  pngfile = '.PNG';
  DictNode = 'dict';
  offsetStr= '{%d,%d}';
  frameformat = '{{%d,%d},{%d,%d}}';
  TexturePackerformat = ' --data "%s" --format cocos2d --sheet "%s" --opt RGBA4444 --size-constraints AnySize "%s" --disable-rotation';
  TexturePacker ='TexturePacker';
  MDPDirFM = '%sMdp\';
  MountMDPDirFM0 = '%sMdp\0\';
  MountMDPDirFM1 = '%sMdp\1\';
  pngDirFM = '%sMdp\%s';
  MountpngDirFM = '%sMdp\%s\%d';
  offsetFM = '%sMdp\%s\offset';
  plistFM1 = '%splist\%s\%d\%d.plist';
  plistpngFM2 = '%splist\%s\%d\%d.png';
  EplistFM1 = '%splist\%s\%d.plist';
  EplistpngFM2 = '%splist\%s\%d.png';
  textfileFM = '"%sTexturePacker.exe"';
  mdpCmd = ' "%s"';
  mdpExe = 'MDPacker.exe';
  mdpStart = 'MDP解包中...';
  mdpFinish = 'MDP解包操作完成';
  TextureFinish = 'TexturePacker操作完成';
  TextureStart = 'TexturePacker正在生成文件';
  MoffsetStart = '正在修正offset...';
  MoffsetFinish = 'offset修正完成';
  RenameStart = '正在修改文件名字...';
  RenameEnd = '修改文件名字完成';
//  textfilename = 'TexturePacker.exe';
type
  TfrmMdpToPlist = class(Tform)
    pgmain: TPageControl;
    tsRename: TTabSheet;
    tsOffset: TTabSheet;
    RadioGroup1: TRadioGroup;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    leoffset: TLabeledEdit;
    btnoffset: TSpeedButton;
    pb1: TProgressBar;
    pnl1: TPanel;
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    btn3: TSpeedButton;
    spl1: TSplitter;
    mmFiles: TMemo;
    procedure btn3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure loadOffset;
    procedure SearchOffset(const plistFilename:string);
    procedure RenamePng();
  private
    { Private declarations }
  public
    procedure WMDROPFILES(var Msg: TMessage);message WM_DROPFILES;
    procedure MDPacker(const Filename: string);
    procedure TexturePackerFile(var listfile, pngfile, inpath: string);

  end;


var
  FrmMdpToPlist: TfrmMdpToPlist;
  offsetLilst:TStringList;
  hProcess: THandle;
  MdpFilename,mdplongname, offsetfilename, rootDir, MdpFileDir,textfileFN : string;
  offsetFN, plistFN, plistpngFN, plistFN1, plistpngFN1, pngDirFN, MountpngDirFN1, MountpngDirFN0 , MDPDirFN,Head, MountMDPDirFN0,MountMDPDirFN1 : string;
  BTexturePacker, Bmdp, Beffect, Bnpc, Bmount, Bmount2, BSpecialSort :boolean;
  n2,n3:integer;
  CSmain: TRTLCriticalSection;
implementation


{$R *.dfm}


function MyThreadFun(p: Pointer): DWORD; stdcall;
var
 sTemp:string;
begin
  if WaitForSingleObject(hProcess, INFINITE) = WAIT_OBJECT_0 then
  begin
    if Bmdp then
    begin
     if Beffect then
     begin
       n2 := StrToIntDef(MdpFileDir, 0);
       plistFN :=  Format(EplistFM1, [rootDir, Head, n2]);
       plistpngFN := Format(EplistpngFM2, [rootDir, Head, n2]);
     end
     else
     begin
       if Bnpc or Bmount then
       begin
         n3 := 0;
         n2 := StrToIntDef(MdpFileDir, 0);
       end
       else
       begin
         n3 := StrToIntDef(RightStr(MdpFileDir,2), 0);
         n2 := StrToIntDef(Copy(MdpFileDir,1, length(MdpFileDir)-2), 0);
       end;

       if Bmount then
       begin
        plistFN :=  Format(plistFM1, [rootDir, Head, n2, 0]);
        plistFN1 :=  Format(plistFM1, [rootDir, Head, n2, 1]);
        plistpngFN := Format(plistpngFM2, [rootDir, Head, n2, 0]);
        plistpngFN1 := Format(plistpngFM2, [rootDir, Head, n2, 1]);
        MountpngDirFN0 :=Format(MountpngDirFM, [rootDir, MdpFileDir,0]);
        MountpngDirFN1 :=Format(MountpngDirFM, [rootDir, MdpFileDir,1]);
       end
       else
       begin
         plistFN :=  Format(plistFM1, [rootDir, Head, n2, n3]);
         plistpngFN := Format(plistpngFM2, [rootDir, Head, n2, n3]);
       end;
     end;
     pngDirFN :=Format(pngDirFM, [rootDir, MdpFileDir]);
     offsetFN := Format(offsetFM, [rootDir, MdpFileDir]);
     MDPDirFN := Format(MDPDirFM, [rootDir]);
     if Bmount then
     begin
      MountMDPDirFN0 := Format(MountMDPDirFM0, [rootDir]);
      MountMDPDirFN1 := Format(MountMDPDirFM1, [rootDir]);
     end;
     FrmMdpToPlist.Text := mdpFinish;
     FrmMdpToPlist.RenamePng;
     Bmdp := False;
    end else
    if BTexturePacker then
    begin
     FrmMdpToPlist.Text := TextureFinish;
     FrmMdpToPlist.SearchOffset(pstring(p)^);
     BTexturePacker := False;
     if Bmount and not Bmount2 then
     begin
      Bmount2 := True;
      FrmMdpToPlist.TexturePackerFile(plistFN1, plistpngFN1, MountpngDirFN1);
     end
    end;
    Result := 0;
  end;
end ;


procedure TfrmMdpToPlist.MDPacker(const Filename:string);
var
  tempStr, fstr :string;
  pInfo: TProcessInformation;
  sInfo: TStartupInfo;
  ThreadID: DWORD;
begin
  if not FileExists(Filename) then
  begin
    ShowMessage('请指定mdp文件');
    exit;
  end;
  MdpFilename := ExtractFileName(Filename);
  MdpFileDir :=StringReplace(MdpFilename, '.mdp', '', [rfReplaceAll]);
  tempStr := Format(mdpCmd,[Filename]);


  FillChar(sInfo, SizeOf(sInfo), 0);
  if CreateProcess(mdpExe,PChar(mdpExe + tempStr),nil,nil,false,0, nil, nil, sinfo, pinfo ) then
  begin
    Bmdp := true;
    hProcess := pInfo.hProcess;
    FrmMdpToPlist.Text := mdpStart;
    CreateThread( nil, 0 , @MyThreadFun, nil, 0, ThreadID);
  end;
end;



procedure TfrmMdpToPlist.TexturePackerFile(var listfile, pngfile, inpath:string);
var
  tempStr, fstr :string;
  pInfo: TProcessInformation;
  sInfo: TStartupInfo;
  ThreadID: DWORD;
begin
 if not DirectoryExists(inPath) then Exit;

 if not DirectoryExists(ExtractFilePath(listfile)) then
   ForceDirectories(ExtractFilePath(listfile));
 tempStr:= Format(TexturePackerformat, [listfile, pngfile, inPath]);

  FillChar(sInfo, SizeOf(sInfo), 0);
  if CreateProcess(nil,PChar(textfileFN + tempStr),nil,nil,false,0, nil, nil, sinfo, pinfo ) then
  begin
    BTexturePacker := True;
    hProcess := pInfo.hProcess;                           {获取进程句柄}
    FrmMdpToPlist.Text := TextureStart;
    CreateThread( nil, 0 , @MyThreadFun, @listfile, 0, ThreadID); {建立线程监视}

  end;
end;


procedure GetALLFiles(dirName: string; List: TStrings; Bsub:Boolean=False; BonlyName:Boolean=false);
var
  SRec: TSearchRec;
begin
  if FindFirst(dirName + '*', faAnyFile, SRec) = 0 then
  begin
    repeat
      if (SRec.Name <> '.') and (SRec.Name <> '..') then
      begin
        if (SRec.Attr = faDirectory) and (not Bsub) then
        begin
          GetALLFiles(dirName + SRec.Name + '\', List, True);
        end
        else
        begin
         if (UpperCase(extractfileext(dirName + SRec.Name)) = UpperCase(pngfile))
          and Bsub then
         begin
           if BonlyName then
            List.Add(UpperCase(SRec.Name))
           else
            List.Add(dirName + SRec.Name);
         end;
        end;
      end;
    until(FindNext(SRec)<>0);
  end;
  FindClose(SRec);
end;

function RightPosEx(const Substr,S: string): Integer;
var
  iPos: Integer;
  TmpStr: string;
  i,j,len: Integer;
  PCharS,PCharSub: PChar;
begin
  PCharS:=PChar(s); //将字符串转化为PChar格式
  PCharSub:=PChar(Substr);
  Result:=0;
  len:=length(Substr);
  for i:=0 to length(S)-1 do begin
    for j:=0 to len-1 do begin
      if PCharS[i+j]<>PCharSub[j] then break;
    end;
    if j=len then Result:=i+1;
  end;
end;

function Modifyoffset(var offsetRootNode:IXMLNode; Newoffset:TSmallPoint):string;
var
 i, i1, i2, ih:integer;
 nodevalue, framevalue, offsetNew:string;
 tempNode, frameNode:IXMLNode;
begin
 for I := 0 to offsetRootNode.ChildNodes.Count - 1 do
 begin
   tempNode := offsetRootNode.ChildNodes[i];
   if tempNode.NodeValue = 'offset' then
   begin
    frameNode := tempNode.PreviousSibling;
    framevalue := frameNode.NodeValue;
    i1 := RightPosEx(','  , framevalue );
    i2 := RightPosEx('}}' , framevalue );
    framevalue := Copy(framevalue, i1 + 1 ,i2-i1-1);
    ih := StrToIntDef(framevalue, 0);
    offsetNew:= Format(offsetStr, [Newoffset.x, -(ih + Newoffset.y)]);
    tempNode := tempNode.NextSibling;
    Result := tempNode.nodevalue;
    tempNode.nodevalue := offsetNew;
   end
   else
    Continue;
 end;
end;





procedure TfrmMdpToPlist.SearchOffset(const plistFilename:string);
Var
  XMLDocument :IXMLDocument;
  XMLNode :IXMLNode;
  PicNode, tempNode:IXMLNode;
  t,pngname,offset, strAll: string;
  i, iPng, ipos:integer;
  offSetPoint : TSmallPoint;
begin
  Text := MoffsetStart;
  try
    CoInitialize(nil);
    XMLDocument := TXMLDocument.Create(plistFilename);
    XMLDocument.Active := True;
    XMLNode := XMLDocument.DocumentElement;
    //图片配置父节点
    PicNode := XMLNode.ChildNodes.FindNode(DictNode).ChildNodes[1];
    for I := 0 to PicNode.ChildNodes.Count-1 do
    begin
      tempNode := PicNode.ChildNodes[i];
      if tempNode.ChildNodes.Count = 1 then
      begin
        pngname := UpperCase(tempNode.NodeValue);
        ipos := offsetLilst.IndexOf(pngname);
        offSetPoint := TSmallPoint(offsetLilst.Objects[ipos]);
        iPng := Pos(pngfile, pngname);
        if iPng>0 then
        begin
         tempNode := tempNode.NextSibling;
         offset := Modifyoffset(tempNode, offSetPoint);
         strAll := strAll + pngname + ':' +offset + #13;
        end;
      end
      else
       Continue;
    end;
    XMLDocument.SaveToFile(plistFilename);
    Text := MoffsetFinish;
    if Bmount then
    begin
      if Bmount2 then
      LeaveCriticalSection(CSmain)
    end
    else
     LeaveCriticalSection(CSmain)
  finally
    couninitialize;
  end;

end;

function DescCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
var
 i1, i2, it1, it2 :Integer;
 s1, s2, t1, t2:string;
begin
  s1 := ExtractFileName(List[Index1]);
  s2 := ExtractFileName(List[Index2]);
//  if Bmount and BSpecialSort then
  if BSpecialSort then
  begin
    t1 := LeftStr(s1,9);
    t2 := LeftStr(s2,9);
    if t1 = t2 then
    begin
     it1 := RightPosEx('.', s1);
     it2 := RightPosEx('_', s1) + 1;
     i1 := StrToIntDef(Copy(s1, it2, it1-it2) , 0) ;
     it1 := RightPosEx('.', s2);
     it2 := RightPosEx('_', s2) + 1;
     i2 := StrToIntDef(Copy(s2, it2, it1-it2) , 0) ;
     Result  := i1 - i2
    end
    else
     Result := AnsiCompareText(t1, t2)
  end
  else
  begin
   if Length(s1) = Length(s2) then
    Result := AnsiCompareText(s1, s2)
   else
    Result := Length(s1) - Length(s2);
  end;

end;

procedure TfrmMdpToPlist.btn3Click(Sender: TObject);
var
 i:integer;
begin
 BTexturePacker := False;
 Bmdp := False;

 Beffect := False;
 Bnpc := false;
 Bmount := false;
 case RadioGroup1.ItemIndex of
   0,6:Beffect:= true ;
   3:Bnpc := True ;
   5:Bmount := True ;
 end;

 Head := RadioGroup1.Items.Strings[RadioGroup1.ItemIndex];

 pb1.Position := 0;
 pb1.Max :=mmFiles.Lines.count;
 for I := 0 to mmFiles.Lines.count - 1 do
 begin
  TMYtrhread.create(False, I);
 end;
end;

procedure TfrmMdpToPlist.loadOffset;
var
  Stream: TMemoryStream;
  Offsets: TSmallPoint;
  i:Integer;
begin
  Stream := TMemoryStream.Create;
  Stream.LoadFromFile(offsetFN);
  offsetLilst.Clear;
  GetALLFiles(ExtractFilePath(offsetFN), offsetLilst, True, True);
  BSpecialSort := true;
  offsetLilst.CustomSort(DescCompareStrings);

  i:=0;
  while Stream.Read(Offsets,sizeof(Offsets)) > 0 do
  begin
    offsetLilst.Objects[i] := TObject(Offsets);
    inc(i)
  end;
 offsetLilst.SaveToFile('d:\2.txt');
end;

procedure TfrmMdpToPlist.RenamePng();
var
  I,nValue: Integer;
  S,FileName,Path,NewPath, stemp, faDir, oldName, newName: string;
  FileList: TStringList;
begin
  Text := RenameStart;
  if not DirectoryExists(MDPDirFN) then exit;
  if rightStr(trim(MDPDirFN), 1) <> '\' then
      MDPDirFN := trim(MDPDirFN) + '\';
  FileList := TStringList.Create;
  GetALLFiles(MDPDirFN,FileList);
  BSpecialSort := false;
  FileList.CustomSort(DescCompareStrings);
  FileList.SaveToFile('d:\1.txt');

  for I := 0 to FileList.Count-1 do
  begin
    Path := ExtractFilePath(FileList.Strings[I]);
    FileName := ExtractFileName(FileList.Strings[I]);
    nValue := StrTOIntDef(Copy(FileName,1,Pos('.',FileName)-1),0);
    if Beffect then
     S := Format(EffectFNfmt,[Head,n2 ,nValue])
    else
    begin
      if Bnpc then
        S := Format(FNfmt,[Head,n2,0,nValue])
      else if Bmount then
      begin
       if i < 24 then
        S := Format(FNfmt,[Head,n2,0,nValue])
       else
        S := Format(FNfmt,[Head,n2,1,nValue-24])
      end     
      else
      S := Format(FNfmt,[Head,n2,n3,nValue]);
    end;
    NewPath := Path + S;
    RenameFile(FileList.Strings[I],NewPath);
    FileList.Strings[I] := NewPath;
  end;
  FrmMdpToPlist.loadOffset;
  //坐骑的需要分成两个文件
  if Bmount then
  begin
   for I := 0 to FileList.Count-1 do
   begin
     oldName :=  FileList.Strings[I];
     if i < 24 then
      newName :=  ExtractFilePath(oldName) + '0\' + ExtractFilename(oldName)
     else
      newName :=  ExtractFilePath(oldName) + '1\' + ExtractFilename(oldName);

     if i = 0  then
     begin
       if not DirectoryExists(ExtractFilePath(oldName) + '0\') then
         ForceDirectories(ExtractFilePath(oldName) + '0\');
       if not DirectoryExists(ExtractFilePath(oldName) + '1\') then
         ForceDirectories(ExtractFilePath(oldName) + '1\');
     end;

     MoveFile(PAnsiChar(oldName) ,PAnsiChar(newName));
   end;
  end;
  FileList.Free;
  Text := RenameEnd;
  if Bmount then
  begin
    Bmount2 := false;
    TexturePackerFile(plistFN, plistpngFN, MountpngDirFN0);
  end
  else
    TexturePackerFile(plistFN, plistpngFN, pngDirFN);

end;

procedure TfrmMdpToPlist.FormCreate(Sender: TObject);
var
 regtemp:TRegistry;
 temp:string;
begin
   InitializeCriticalSection(CSmain);
 DragAcceptFiles( Handle,True ) ;
 offsetLilst　:= TStringList.Create;
 rootDir := ExtractFilePath(Application.ExeName);
 with TRegistry.Create do
 begin
   RootKey := HKEY_CLASSES_ROOT;
   if OpenKey('TexturePacker.PNG\DefaultIcon',False) then
    if valueexists('') then
    begin
      temp:=readstring('');
      temp:= Copy(temp,2, Length(temp)-4);
      textfileFN := Format(textfileFM, [temp]);
    end
    else
     ShowMessage('程序检测不到TexturePacker 请安装后重试');
   CloseKey;
   Free;
 end;

end;

procedure TfrmMdpToPlist.FormDestroy(Sender: TObject);
begin
 offsetLilst.Free;
 DeleteCriticalSection(CSmain);

end;


procedure TfrmMdpToPlist.WMDROPFILES(var Msg: TMessage);
var
  FilesCount: Integer; 
  i: Integer;
  FileName: array[0..255] of Char;
begin
  FilesCount := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  mmFiles.Clear;
  for i := 0 to FilesCount - 1 do
  begin
    DragQueryFile(Msg.WParam, i, FileName, 256);
    if not SameText(UpperCase(ExtractFileExt(FileName)),'.MDP')  then
    begin
      Continue;
    end;
    mmFiles.Lines.Add(FileName)
  end;
  DragFinish(Msg.WParam);
end;





end.
