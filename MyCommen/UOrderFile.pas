unit UOrderFile;

interface
uses classes,sysutils,strutils,windows, ActiveX, UrlMon ;

type
 TBindStatusCallback = class(TInterfaceList, IBindStatusCallback)
  public
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
  end;



function MakeFileList(Path,FileExt:string):TStringList ;
function CompareFile(mFileName1,mFileName2: string): Boolean;// 返回两个文件是否相等
function CompareStream(mStream1, mStream2: TStream): Boolean;

implementation




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

function CompareStream(mStream1, mStream2: TStream): Boolean;
var
  vBuffer1, vBuffer2: array[0..$1000-1] of Char;
  vLength1, vLength2: Integer;
begin
  Result := mStream1 = mStream2;
  if Result then Exit;
  if not Assigned(mStream1) or not Assigned(mStream2) then Exit;// 其中一个为空
  while True do
  begin
      vLength1 := mStream1.Read(vBuffer1, SizeOf(vBuffer1));
      vLength2 := mStream2.Read(vBuffer2, SizeOf(vBuffer2));
      if vLength1 <> vLength2 then Exit;
      if vLength1 =0 then Break;
      if not CompareMem(@vBuffer1[0],@vBuffer2[0], vLength1) then Exit;
  end;
  Result := True;
end;{ CompareStream }


function CompareFile(mFileName1,mFileName2: string): Boolean;// 返回两个文件是否相等
var
 vFileHandle1, vFileHandle2: THandle;
 vFileStream1, vFileStream2: TFileStream;
 vShortPath1, vShortPath2: array[0..MAX_PATH] of Char;
begin
  Result := False;
  // 其中一个文件不存在
  if not FileExists(mFileName1) or not FileExists(mFileName2) then Exit;
  GetShortPathName(PChar(mFileName1), vShortPath1, SizeOf(vShortPath1));
  GetShortPathName(PChar(mFileName2), vShortPath2, SizeOf(vShortPath2));
  Result := SameText(vShortPath1, vShortPath2);// 两个文件名是否相同
  if Result then Exit;
  vFileHandle1 := _lopen(PansiChar(mFileName1), OF_READ or OF_SHARE_DENY_NONE);
  vFileHandle2 := _lopen(PansiChar(mFileName2), OF_READ or OF_SHARE_DENY_NONE);
  Result :=(Integer(vFileHandle1)>0) and (Integer(vFileHandle2)>0);// 文件是否可以访问
  if not Result then
  begin
      _lclose(vFileHandle1);
      _lclose(vFileHandle2);
      Exit;
  end;
  Result := GetFileSize(vFileHandle1, nil)= GetFileSize(vFileHandle2, nil);// 文件大小是否一致
  if not Result then
  begin
      _lclose(vFileHandle1);
      _lclose(vFileHandle2);
      Exit;
  end;
  vFileStream1 := TFileStream.Create(vFileHandle1);
  vFileStream2 := TFileStream.Create(vFileHandle2);
  try
      Result := CompareStream(vFileStream1, vFileStream2);// 比较两个文件内容是否相同
  finally
      vFileStream1.Free;
      vFileStream2.Free;
  end;
end;{ CompareFile }



{ TBindStatusCallback }

function TBindStatusCallback.GetBindInfo(out grfBINDF: DWORD;
  var bindinfo: TBindInfo): HResult;
begin
  Result := S_OK;
end;

function TBindStatusCallback.GetPriority(out nPriority): HResult;
begin
  Result := S_OK;
end;

function TBindStatusCallback.OnDataAvailable(grfBSCF, dwSize: DWORD;
  formatetc: PFormatEtc; stgmed: PStgMedium): HResult;
var
  Stream: IStream;
  mem: TMemoryStream;
begin
  if dwSize > 0 then
  begin
    Stream := IStream(stgmed.stm);
    mem := TMemoryStream.Create;
    mem.SetSize(dwSize);
    Stream.Read(mem.Memory, dwSize, nil);
    //ShowMessage(IntToStr(mem.Size));
    mem.SaveToFile('C:\PMark_1.rar');
    mem.Free;
    Result := S_OK;
  end
  else Result := E_ABORT;
end;

function TBindStatusCallback.OnLowResource(reserved: DWORD): HResult;
begin
  Result := S_OK;
end;

function TBindStatusCallback.OnObjectAvailable(const iid: TGUID;
  punk: IInterface): HResult;
begin
  Result := S_OK;
end;

function TBindStatusCallback.OnProgress(ulProgress, ulProgressMax,
  ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult;
begin
  //如果需要下载进度就在这里写代码
  Result := S_OK;
end;

function TBindStatusCallback.OnStartBinding(dwReserved: DWORD;
  pib: IBinding): HResult;
begin
  Result := S_OK;
end;

function TBindStatusCallback.OnStopBinding(hresult: HResult;
  szError: LPCWSTR): HResult;
begin
  Result := S_OK;
end;


end.
