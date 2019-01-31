unit desktopItems;


interface

uses Windows, Messages, SysUtils, CommCtrl;

type IDesktopItems = interface ['{AD828DE0-3570-11D3-A52D-00005A180D69}']
                       function  ItemCount   : integer;
                       function  GetPosition (index: integer) : TPoint;
                       property  Position    [index: integer] : TPoint read GetPosition;
                       function  GetName     (index: integer) : string;
                       property  Name        [index: integer] : string read GetName;
                       procedure Refresh;
                     end;

function GetDesktopItems : IDesktopItems;

implementation

{$ifndef ver120} type cardinal = integer; {$endif}

type TDesktopItem   = record
                        pos  : TPoint;
                        name : array [0..MAX_PATH] of char;
                      end;
     TDesktopItems  = record
                        itemCount : integer;
                        items     : array [0..$FFFE] of TDesktopItem;
                      end;
     TPDesktopItems = ^TDesktopItems;
     TIDesktopItems = class (TInterfacedObject, IDesktopItems)
                      private
                        FFileMapping   : cardinal;
                        FPDesktopItems : TPDesktopItems;
                        constructor Create;
                        destructor Destroy; override;
                        function  ItemCount   : integer;
                        function  GetPosition (index: integer) : TPoint;
                        function  GetName     (index: integer) : string;
                        procedure Refresh;
                      end;

constructor TIDesktopItems.Create;
begin
  inherited;
  Refresh;
end;

destructor TIDesktopItems.Destroy;
begin
  if FPDesktopItems<>nil then UnMapViewOfFile(FPDesktopItems);
  if FFileMapping  <>0   then CloseHandle    (FFileMapping  );
  inherited;
end;

function TIDesktopItems.ItemCount : integer;
begin
  result:=FPDesktopItems^.itemCount;
end;

function TIDesktopItems.GetPosition(index: integer) : TPoint;
begin
  if (index<0) or (index>=FPDesktopItems^.itemCount) then
    raise Exception.Create('Index out of range.');
  result:=FPDesktopItems^.items[index].pos;
end;

function TIDesktopItems.GetName(index: integer) : string;
begin
  if (index<0) or (index>=FPDesktopItems^.itemCount) then
    raise Exception.Create('Index out of range.');
  result:=FPDesktopItems^.items[index].name;
end;

procedure TIDesktopItems.Refresh;
var lv   : cardinal;
    ic   : integer;
    dll  : cardinal;
    hook : cardinal;
    ev   : cardinal;
begin
  if FPDesktopItems<>nil then UnMapViewOfFile(FPDesktopItems);
  if FFileMapping  <>0   then CloseHandle    (FFileMapping  );
  lv:=FindWindowEx(FindWindowEx(FindWindow('Progman','Program Manager'),0,'SHELLDLL_DefView',''),0,'SysListView32','');
  if lv<>0 then ic:=SendMessage(lv,LVM_GETITEMCOUNT,0,0) else ic:=0;
  FFileMapping:=CreateFileMapping(INVALID_HANDLE_VALUE,nil,PAGE_READWRITE,0,4+ic*sizeOf(TDesktopItem),'mappedMemoryForDesktopIcons');
  if FFileMapping<>0 then begin
    FPDesktopItems:=MapViewOfFile(FFileMapping,FILE_MAP_ALL_ACCESS,0,0,0);
    FPDesktopItems^.itemCount:=ic;
    dll:=LoadLibrary(pchar(ExtractFilePath(ParamStr(0))+'hook.dll'));
    if dll<>0 then
      try
        ev:=CreateEvent(nil,true,false,'eventForDesktopIcons');
        if ev<>0 then
          try
            hook:=SetWindowsHookEx(WH_GETMESSAGE,GetProcAddress(dll,'HookMessageProc'),dll,GetWindowThreadProcessID(lv,nil));
            if hook<>0 then
              try
                PostThreadMessage(GetWindowThreadProcessID(lv,nil),WM_NULL,0,0);
                WaitForSingleObject(ev,2000);
              finally UnhookWindowsHookEx(hook) end;
          finally CloseHandle(ev) end;
      finally FreeLibrary(dll) end;
  end else FPDesktopItems:=nil;
end;

function GetDesktopItems : IDesktopItems;
begin
  result:=TIDesktopItems.Create;
end;

end.
