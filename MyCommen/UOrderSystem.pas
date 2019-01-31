unit UOrderSystem;
////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: 张明明/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////

interface
uses
  Windows,SYSUTILS,graphics,WinSvc,Tlhelp32, PsAPI, Dialogs;

  procedure IniDateFormat(ChangeSystem:Boolean   =   False);
  function GetCurWindow():boolean;
  function StartService(AServName: string): Boolean; //use WinSvc
  procedure UninstallService(strServiceName:string);
  function StopService(AServName: string): Boolean;
  function GetChineseWeek:string;
  function GetProcessMemorySize(ProcessName: string;var Size:string;var PN:string): Boolean;
  function getprocessmemuse(pid: cardinal): cardinal;
function GetProcessMemorySize1(_sProcessName: string;
  var _nMemSize: Cardinal): Boolean;

implementation

function GetProcessMemorySize1(_sProcessName: string;
  var _nMemSize: Cardinal): Boolean;
var
  l_nWndHandle, l_nProcID, l_nTmpHandle: HWND;
  l_pPMC: PPROCESS_MEMORY_COUNTERS;
  l_pPMCSize: Cardinal;
begin
  l_nWndHandle := FindWindow(nil, PChar(_sProcessName));
  if l_nWndHandle = 0 then
  begin
    Result := False;
    showmessage('not found');
    Exit;
  end;

  l_pPMCSize := SizeOf(PROCESS_MEMORY_COUNTERS);
  GetMem(l_pPMC, l_pPMCSize);
  l_pPMC^.cb := l_pPMCSize;
  GetWindowThreadProcessId(l_nWndHandle, @l_nProcID);
  l_nTmpHandle := OpenProcess(PROCESS_ALL_ACCESS, False, l_nProcID);
  if (GetProcessMemoryInfo(l_nTmpHandle, l_pPMC, l_pPMCSize)) then
    _nMemSize := l_pPMC^.WorkingSetSize
  else
    _nMemSize := 0;
  FreeMem(l_pPMC);
  Result := True;
end;

function getprocessmemuse(pid: cardinal): cardinal;
var
pmc: pprocess_memory_counters; //uses psapi 
prochandle: hwnd; 
isize: dword;
begin 
result := 0; 
isize := sizeof(_process_memory_counters); 
getmem(pmc, isize); 
try 
pmc^.cb := isize; 
prochandle := openprocess(process_query_information or process_vm_read, 
false, pid); //由pid取得进程对象的句柄 
if getprocessmemoryinfo(prochandle, pmc, isize) then 
result := pmc^.workingsetsize; 
finally 
freemem(pmc); 
end; 
end;


{
 功能： 获取系统进程ID 内存占用大小
}
function GetProcessMemorySize(ProcessName: string;var Size:string;var PN:string): Boolean;
var
pProcess:THandle;
MemSize,t:Integer;
hProcSnap:THandle;
PPMCSize:Cardinal;
pe32:TProcessEntry32;
PPMC:PPROCESS_MEMORY_COUNTERS;
begin

  PPMCSize := SizeOf(PROCESS_MEMORY_COUNTERS);
  GetMem(PPMC, PPMCSize);
  PPMC^.cb:= PPMCSize;

  hProcSnap:=CreateToolHelp32SnapShot(TH32CS_SNAPALL,  0);
  if  hProcSnap=INVALID_HANDLE_VALUE  then  Exit;
  pe32.dwSize:=SizeOf(ProcessEntry32);
  if  Process32First(hProcSnap,pe32)=True then
      while  Process32Next(hProcSnap,pe32)=True  do
      begin
          if  uppercase(pe32.szExeFile)=uppercase(ProcessName)  then
          begin
            pProcess:=OpenProcess(PROCESS_ALL_ACCESS,FALSE, pe32.th32ProcessID);

            if (GetProcessMemoryInfo(pProcess,PPMC,PPMCSize)) then
             begin
               MemSize:=PPMC^.WorkingSetSize div 1024;
               t:= Length(IntToStr(MemSize))-2;
               Size:=IntToStr(MemSize);
               Insert(',',Size,t);
               PN:=ProcessName;
               FreeMem(PPMC);
               Result:=True;
             end
            else
             begin
               FreeMem(PPMC);
               Result:=False;
             end;

          end;
      end;
  CloseHandle(pProcess);
  CloseHandle(hProcSnap);
end;




function GetChineseWeek:string;
  function GetWeek: string;
  var
    mytime:SYSTEMTIME;
  begin
    GetLocalTime(mytime);
    case mytime.wDayOfWeek of
      0: Result:='星期日';
      1: Result:='星期一';
      2: Result:='星期二';
      3: Result:='星期三';
      4: Result:='星期四';
      5: Result:='星期五';
      6: Result:='星期六';
    end;
  end;
begin
  DateSeparator := '-';
  TimeSeparator := ':';
  ShortDateFormat:='yyyy-M-d';
  LongTimeFormat := 'H:mm:ss';
  Result := Format('%s %s',[FormatDateTime('YYYY年MM月DD日',Now),GetWeek]);
end;


function StopService(AServName: string): Boolean;
var
  SCManager, hService: SC_HANDLE;
  SvcStatus: TServiceStatus;
begin
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  Result := SCManager <> 0;
  if Result then
  try
    hService := OpenService(SCManager, PChar(AServName), SERVICE_ALL_ACCESS);
    Result := hService <> 0;
    if Result then
    try //停止并卸载服务;
      Result := ControlService(hService, SERVICE_CONTROL_STOP, SvcStatus);
      //删除服务，这一句可以不要;
      // DeleteService(hService);
    finally
      CloseServiceHandle(hService);
    end;
  finally
    CloseServiceHandle(SCManager);
  end;

end;



function KillTask(ExeFileName: string): Integer;
const
 PROCESS_TERMINATE = 01;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
    UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
    UpperCase(ExeFileName))) then
    Result := Integer(TerminateProcess(
    OpenProcess(PROCESS_TERMINATE,
    BOOL(0),
    FProcessEntry32.th32ProcessID),
    0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
    CloseHandle(FSnapshotHandle);
end;




//但是对于服务程序,它会提示"拒绝访问".其实只要程序拥有Debug权限即可:
function EnableDebugPrivilege: Boolean;
  function EnablePrivilege(hToken: Cardinal; PrivName: string; bEnable: Boolean): Boolean;
  var
  TP: TOKEN_PRIVILEGES;
  Dummy: Cardinal;
  begin
  TP.PrivilegeCount := 1;
  LookupPrivilegeValue(nil, pchar(PrivName), TP.Privileges[0].Luid);
  if bEnable then
  TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
  else TP.Privileges[0].Attributes := 0;
  AdjustTokenPrivileges(hToken, False, TP, SizeOf(TP), nil, Dummy);
  Result := GetLastError = ERROR_SUCCESS;
  end;
var
  hToken: Cardinal;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken);
  result:=EnablePrivilege(hToken, 'SeDebugPrivilege', True);
  CloseHandle(hToken);
end;


procedure UninstallService(strServiceName:string);
var
SCManager: SC_HANDLE;
Service: SC_HANDLE;
Status: TServiceStatus;
begin
SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
if SCManager = 0 then Exit;
try
Service := OpenService(SCManager, Pchar(strServiceName), SERVICE_ALL_ACCESS);
ControlService(Service, SERVICE_CONTROL_STOP, Status);
DeleteService(Service);
CloseServiceHandle(Service);
finally
CloseServiceHandle(SCManager);
end;
end;



// start services
function StartService(AServName: string): Boolean; //use WinSvc
var
  SCManager, hService: SC_HANDLE;
  lpServiceArgVectors: PChar;
begin
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  Result := SCManager <> 0;
  if Result then
  try
    hService := OpenService(SCManager, PChar(AServName), SERVICE_ALL_ACCESS);
    Result := hService <> 0;
    if (hService = 0) and (GetLastError = ERROR_SERVICE_DOES_NOT_EXIST) then
    Exception.Create('The specified service does not exist');
    if hService <> 0 then
    try
      lpServiceArgVectors := nil;
      Result := WinSvc.StartService(hService, 0, PChar(lpServiceArgVectors));
      if not Result and (GetLastError = ERROR_SERVICE_ALREADY_RUNNING) then
       Result := True;
    finally
      CloseServiceHandle(hService);
    end;
  finally
   CloseServiceHandle(SCManager);
  end;
end;



procedure   IniDateFormat(ChangeSystem:   Boolean   =   False);
begin
    //--Setup   user   DateSeparator
    DateSeparator   :='-';
    ShortDateFormat   :=   'yyyy-MM-dd';
    if   not   ChangeSystem   then   Exit;
    SetLocaleInfo(LOCALE_SLONGDATE,   LOCALE_SDATE,   '-');
    SetLocaleInfo(LOCALE_SLONGDATE,   LOCALE_SSHORTDATE,   'yyyy-MM-dd');
end;

//获取当前的 程序窗口
function GetCurWindow():boolean;
var
 rectTemp: trect;
 bmp: tbitmap;
begin
 getwindowrect(getforegroundwindow,rectTemp);
 bmp := tbitmap.create;
 bmp.SetSize(recttemp.Right - recttemp.Left, recttemp.Bottom - recttemp.Top);
 BitBlt(bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, GetDC(0), recttemp.Left, recttemp.Top, SRCCOPY);
 bmp.SaveToFile('c:\001.bmp');
 bmp.Free;
end;



end.
