unit UorderDesktop;

interface
uses  Winapi.Windows, CommCtrl;

type
  TLVItem64 = packed record
    mask: UINT;
    iItem: Integer;
    iSubItem: Integer;
    state: UINT;
    stateMask: UINT;
    _align: LongInt;
    pszText: Int64;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: lParam;
  end;

function GetIconRect(strIconName: String; var lpRect, rpRect: TRECT): boolean;
var
 DesktopLvHand: THandle;


implementation
var
 B64: Boolean;



function GetDesktopLvHand: THandle;
begin
  Result := FindWindow('progman', nil);
  Result := GetWindow(Result, GW_Child);
  Result := GetWindow(Result, GW_Child);
end;


function OSIsWin64: boolean;
var
  Kernel32Handle: THandle;
  IsWow64Process: function(Handle: Winapi.Windows.THandle;
    var Res: Winapi.Windows.BOOL): Winapi.Windows.BOOL; stdcall;
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;
  isWoW64: BOOL;
  SystemInfo: TSystemInfo;
const
  PROCESSOR_ARCHITECTURE_AMD64 = 9;
  PROCESSOR_ARCHITECTURE_IA64 = 6;
begin
  Kernel32Handle := GetModuleHandle('KERNEL32.DLL');
  if Kernel32Handle = 0 then
    Kernel32Handle := LoadLibrary('KERNEL32.DLL');
  if Kernel32Handle <> 0 then
  begin
    IsWow64Process := GetProcAddress(Kernel32Handle, 'IsWow64Process');
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle,
      'GetNativeSystemInfo');
    if Assigned(IsWow64Process) then
    begin
      IsWow64Process(GetCurrentProcess, isWoW64);
      Result := isWoW64 and Assigned(GetNativeSystemInfo);
      if Result then
      begin
        GetNativeSystemInfo(SystemInfo);
        Result := (SystemInfo.wProcessorArchitecture =
          PROCESSOR_ARCHITECTURE_AMD64) or
          (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);
      end;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

function GetIconRect64(hDeskWnd: HWND; strIconName: String;
  var lpRect, rpRect: TRECT): boolean;
const
  cchTextMax = 512;
var
  ItemBuf: array [0 .. 512] of char;
  pszText: PChar;
  LVItem: TLVItem64;
  ProcessID, ProcessHD: DWORD;
  drTmp: SIZE_T;
  pLVITEM: Pointer;
  pItemRc, pAllRc: ^TRECT;
  itemRc, AllRc: TRECT;
  nCount, iItem: Integer;
begin
  Result := False;
  GetWindowThreadProcessId(hDeskWnd, ProcessID);
  ProcessHD := OpenProcess(PROCESS_VM_OPERATION or PROCESS_VM_READ or
    PROCESS_VM_WRITE, False, ProcessID);
  if (ProcessHD = 0) then
    Exit
  else
  begin
    pLVITEM := VirtualAllocEx(ProcessHD, nil, SizeOf(TLVItem64), MEM_COMMIT,
      PAGE_READWRITE);
    pszText := VirtualAllocEx(ProcessHD, nil, cchTextMax, MEM_COMMIT,
      PAGE_READWRITE);
    pItemRc := VirtualAllocEx(ProcessHD, nil, SizeOf(TRECT), MEM_COMMIT,
      PAGE_READWRITE);
    pAllRc := VirtualAllocEx(ProcessHD, nil, SizeOf(TRECT), MEM_COMMIT,
      PAGE_READWRITE);
    if (pLVITEM = nil) then
    else
    begin
      LVItem.iSubItem := 0;
      LVItem.cchTextMax := cchTextMax;
      LVItem.pszText := Int64(pszText);
      WriteProcessMemory(ProcessHD, pLVITEM, @LVItem, SizeOf(TLVItem64), drTmp);
      itemRc.Left := LVIR_ICON;
      WriteProcessMemory(ProcessHD, pItemRc, @itemRc, SizeOf(TRECT), drTmp);
      AllRc.Left := LVIR_SELECTBOUNDS;
      WriteProcessMemory(ProcessHD, pAllRc, @AllRc, SizeOf(TRECT), drTmp);
      nCount := SendMessage(hDeskWnd, LVM_GETITEMCOUNT, 0, 0);
      for iItem := 0 to nCount - 1 do
      begin
        SendMessage(hDeskWnd, LVM_GETITEMTEXT, iItem, Integer(pLVITEM));
        ReadProcessMemory(ProcessHD, pszText, @ItemBuf, cchTextMax, drTmp);
        if (ItemBuf = strIconName) then
        begin
          SendMessage(hDeskWnd, LVM_GETITEMRECT, iItem, lParam(pItemRc));
          ReadProcessMemory(ProcessHD, pItemRc, @lpRect, SizeOf(TRECT), drTmp);
          SendMessage(hDeskWnd, LVM_GETITEMRECT, iItem, lParam(pAllRc));
          ReadProcessMemory(ProcessHD, pAllRc, @rpRect, SizeOf(TRECT), drTmp);
          Result := True;
          Break;
        end;
      end;
      VirtualFreeEx(ProcessHD, pLVITEM, 0, MEM_RELEASE);
      VirtualFreeEx(ProcessHD, pszText, 0, MEM_RELEASE);
      VirtualFreeEx(ProcessHD, pAllRc, 0, MEM_RELEASE);
      VirtualFreeEx(ProcessHD, pItemRc, 0, MEM_RELEASE);
    end;
    CloseHandle(ProcessHD);
  end;
end;


// ues CommCtrl
function GetIconRect32(hDeskWnd: HWND; strIconName: String;
  var lpRect, rpRect: TRECT): boolean;
const
  cchTextMax = 512;
var
  ItemBuf: array [0 .. 512] of char;
  pszText: PChar;
  LVItem: TLVItem;
  ProcessID, ProcessHD: DWORD;
  drTmp: SIZE_T;
  pLVITEM: Pointer;
  pItemRc, pAllRc: ^TRECT;
  itemRc, AllRc: TRECT;
  nCount, iItem: Integer;
begin
  Result := False;
  GetWindowThreadProcessId(hDeskWnd, ProcessID);
  ProcessHD := OpenProcess(PROCESS_VM_OPERATION or PROCESS_VM_READ or
    PROCESS_VM_WRITE, False, ProcessID);
  if (ProcessHD = 0) then
    Exit
  else
  begin
    pLVITEM := VirtualAllocEx(ProcessHD, nil, SizeOf(TLVItem), MEM_COMMIT,
      PAGE_READWRITE);
    pszText := VirtualAllocEx(ProcessHD, nil, cchTextMax, MEM_COMMIT,
      PAGE_READWRITE);
    pItemRc := VirtualAllocEx(ProcessHD, nil, SizeOf(TRECT), MEM_COMMIT,
      PAGE_READWRITE);
    pAllRc := VirtualAllocEx(ProcessHD, nil, SizeOf(TRECT), MEM_COMMIT,
      PAGE_READWRITE);
    if (pLVITEM = nil) then
    else
    begin
      LVItem.iSubItem := 0;
      LVItem.cchTextMax := cchTextMax;
      LVItem.pszText := PChar(Integer(pLVITEM) + SizeOf(TLVItem));
      WriteProcessMemory(ProcessHD, pLVITEM, @LVItem, SizeOf(TLVItem), drTmp);

      itemRc.Left := LVIR_ICON;
      WriteProcessMemory(ProcessHD, pItemRc, @itemRc, SizeOf(TRECT), drTmp);
      AllRc.Left := LVIR_SELECTBOUNDS;
      WriteProcessMemory(ProcessHD, pAllRc, @AllRc, SizeOf(TRECT), drTmp);

      nCount := SendMessage(hDeskWnd, LVM_GETITEMCOUNT, 0, 0);
      for iItem := 0 to nCount - 1 do
      begin
        SendMessage(hDeskWnd, LVM_GETITEMTEXT, iItem, Integer(pLVITEM));
        ReadProcessMemory(ProcessHD, Pointer(Integer(pLVITEM) + SizeOf(TLVItem)
          ), @ItemBuf, cchTextMax, drTmp);
        if (ItemBuf = strIconName) then
        begin

          SendMessage(hDeskWnd, LVM_GETITEMRECT, iItem, lParam(pItemRc));
          ReadProcessMemory(ProcessHD, pItemRc, @lpRect, SizeOf(TRECT), drTmp);

          SendMessage(hDeskWnd, LVM_GETITEMRECT, iItem, lParam(pAllRc));
          ReadProcessMemory(ProcessHD, pAllRc, @rpRect, SizeOf(TRECT), drTmp);
          Result := True;
          Break;
        end;
      end;
      VirtualFreeEx(ProcessHD, pLVITEM, SizeOf(TLVItem) + cchTextMax,
        MEM_DECOMMIT);
      VirtualFreeEx(ProcessHD, pszText, 0, MEM_RELEASE);
      VirtualFreeEx(ProcessHD, pAllRc, 0, MEM_RELEASE);
      VirtualFreeEx(ProcessHD, pItemRc, 0, MEM_RELEASE);
    end;
    CloseHandle(ProcessHD);
  end;
end;

function GetIconRect(strIconName: String; var lpRect, rpRect: TRECT): boolean;
begin
  if B64 then
   Result := GetIconRect64(DesktopLvHand, strIconName, lpRect, rpRect)
  else
   Result := GetIconRect32(DesktopLvHand, strIconName, lpRect, rpRect);
end;


initialization
 B64 :=  OSIsWin64;
 DesktopLvHand := GetDesktopLvHand;

finalization



end.
