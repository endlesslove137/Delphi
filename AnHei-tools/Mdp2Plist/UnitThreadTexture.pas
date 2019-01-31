unit UnitThreadTexture;

interface

uses
  Windows, Messages, SysUtils,Registry, Variants, Classes, Graphics,msxml, Controls, Forms, ShellAPI,ActiveX,
  Dialogs, StdCtrls, ExtCtrls, XMLDoc,XMLIntf, Spin, StrUtils, ComCtrls, Buttons,UnitStdXmlForm ;


  type TtrhreadPara = record
       flag: integer;   //1表示 mdp 2表示 texture
       handle: THandle;
       NP2: Integer;
       np3: Integer;
       Kind: string;
       MdpDirName: string;
       plistFilename :string;
       pngFilename :string;
       pngDirName :string;
  end;
  ptrhreadPara = ^TtrhreadPara;

  TMYtrhread = class(TThread)
   Flag:Integer;
   FMdpFilename,FMdpDirName, FHead: string;
   FBTexturePacker, FBeffect, FBmount ,FBnpc: Boolean;
   paraArr :array of TtrhreadPara;
  private
   procedure MDPacker(const Filename: string);
   constructor create(CreateSuspended: Boolean; i:Integer; sMdpFilename:string; kind:string);overload;
   procedure Execute;override;
  public
   constructor create(CreateSuspended: Boolean; i:Integer);overload;

  end;

implementation

uses
UnitMdpToPlist;

{ TMYtrhread }

constructor TMYtrhread.create(CreateSuspended: Boolean; i: Integer);
begin
 inherited create(CreateSuspended);
 FreeOnTerminate := True;
 Flag := i;
end;

constructor TMYtrhread.create(CreateSuspended: Boolean; i:Integer; sMdpFilename:string; kind:string);
begin
 inherited create(CreateSuspended);
 FreeOnTerminate := True;
// EnterCriticalSection(CSmain);
 Flag := i;
 FMdpFilename := sMdpFilename;
 FBTexturePacker := False;
// FBmdp := False;
 FBeffect := False;
 FBnpc := false;
 FBmount := false;

 case Flag of
   0:FBeffect:= true ;
   3:FBnpc := True ;
   5:FBmount := True ;
 end;

 if FBmount then
  SetLength(paraArr, 3)
 else
  SetLength(paraArr, 2);


 for I := 0 to Length(paraArr) - 1 do
 begin
 
 end;



 FHead := kind;

 FrmMdpToPlist.Caption := mdpStart;
 MDPacker(FMdpFilename);
 FrmMdpToPlist.pb1.StepBy(1);

end;

function ThreadFun(p: Pointer): DWORD; stdcall;
var
 sTemp:string;
 trhreadPara,trhreadPara2 :TtrhreadPara;
begin


  trhreadPara :=ptrhreadPara(p)^;
//  trhreadPara2 := ptrhreadPara(@(p + 1)))^ ;
  if WaitForSingleObject(trhreadPara.handle, INFINITE) = WAIT_OBJECT_0 then
  begin
    // BMDP
    if trhreadPara.flag = 1 then
    begin
     if Beffect then
     begin
       trhreadPara.NP2 := StrToIntDef(trhreadPara.MdpDirName, 0);
       trhreadPara.plistFilename := Format(EplistFM1, [rootDir, trhreadPara.kind, trhreadPara.NP2]);
       trhreadPara.pngFilename := Format(EplistpngFM2, [rootDir, trhreadPara.kind, trhreadPara.NP2]);
     end
     else
     begin
       if Bnpc or Bmount then
       begin
         trhreadPara.NP3 := 0;
         trhreadPara.NP2 := StrToIntDef(trhreadPara.MdpDirName, 0);
       end
       else
       begin
         trhreadPara.NP3 := StrToIntDef(RightStr(trhreadPara.MdpDirName,2), 0);
         trhreadPara.NP2 := StrToIntDef(Copy(trhreadPara.MdpDirName,1, length(trhreadPara.MdpDirName)-2), 0);
       end;

       if Bmount then
       begin
        plistFN :=  Format(plistFM1, [rootDir, trhreadPara.kind, trhreadPara.NP2, 0]);
        plistFN1 :=  Format(plistFM1, [rootDir, trhreadPara.kind, trhreadPara.NP2, 1]);
        plistpngFN := Format(plistpngFM2, [rootDir, trhreadPara.kind, trhreadPara.NP2, 0]);
        plistpngFN1 := Format(plistpngFM2, [rootDir, trhreadPara.kind, trhreadPara.NP2, 1]);
        MountpngDirFN0 :=Format(MountpngDirFM, [rootDir, trhreadPara.MdpDirName,0]);
        MountpngDirFN1 :=Format(MountpngDirFM, [rootDir, trhreadPara.MdpDirName,1]);
       end
       else
       begin
         plistFN :=  Format(plistFM1, [rootDir, trhreadPara.kind, trhreadPara.NP2, trhreadPara.NP3]);
         plistpngFN := Format(plistpngFM2, [rootDir, trhreadPara.kind, trhreadPara.NP2, trhreadPara.NP3]);
       end;
     end;
     pngDirFN :=Format(pngDirFM, [rootDir, trhreadPara.MdpDirName]);
     offsetFN := Format(offsetFM, [rootDir, trhreadPara.MdpDirName]);
     MDPDirFN := Format(MDPDirFM, [rootDir]);
     if Bmount then
     begin
      MountMDPDirFN0 := Format(MountMDPDirFM0, [rootDir]);
      MountMDPDirFN1 := Format(MountMDPDirFM1, [rootDir]);
     end;
     FrmMdpToPlist.caption := mdpFinish;
     FrmMdpToPlist.RenamePng;
     Bmdp := False;
    end else
    if BTexturePacker then
    begin
     FrmMdpToPlist.caption := TextureFinish;
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

procedure TMYtrhread.MDPacker(const Filename:string);
var
  tempStr, fstr :string;
  pInfo: TProcessInformation;
  sInfo: TStartupInfo;
  ThreadID: DWORD;
begin
  if not FileExists(Filename) then  exit;
  tempStr := UpperCase(ExtractFileName(Filename));
  FMdpDirName :=StringReplace(tempStr, '.MDP', '', [rfReplaceAll]);
  tempStr := Format(mdpCmd,[Filename]);

  FillChar(sInfo, SizeOf(sInfo), 0);
  if CreateProcess(mdpExe,PChar(mdpExe + tempStr),nil,nil,false,0, nil, nil, sinfo, pinfo ) then
  begin
    paraArr[0].flag := 1;
    paraArr[0].handle := pInfo.hProcess;
    FrmMdpToPlist.Caption := mdpStart;
    CreateThread( nil, 0 , @ThreadFun, @paraArr[0], 0, ThreadID);
  end;
end;





procedure TMYtrhread.Execute;
begin
   EnterCriticalSection(CSmain);
   mdplongname := FrmMdpToPlist.mmFiles.Lines[Flag];
   FrmMdpToPlist.Caption := mdpStart;
   FrmMdpToPlist.MDPacker(mdplongname);
   FrmMdpToPlist.pb1.StepBy(1);
end;
end.
