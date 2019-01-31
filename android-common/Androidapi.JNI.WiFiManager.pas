unit Androidapi.JNI.WiFiManager;

interface
 {$IF DEFINED(ANDROID)}
uses
  Androidapi.JNIBridge, Androidapi.Jni,  androidapi.JNI.JavaTypes, androidapi.JNI.Net,
  androidapi.JNI.Os, FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Util,
  System.SysUtils,
  System.Classes,
  system.StrUtils;

Type
  JWiFiManager = interface;   // android/net/wifi/WifiManager
  JMulticastLock = interface; // android/net/wifi/WifiManager$MulticastLock
  JDhcpInfo  = interface;
  JDhcpInfoClass = interface(JObjectClass)
  ['{B41D3B6B-852D-4B72-A3BA-490CF8C5A1C6}']

  function init: JDhcpInfo;

  {Methods}
  end;
  [JavaSignature('android/net/DhcpInfo')]
  JDhcpInfo = interface(JObject)
   ['{DD76F257-701F-4200-88EA-3CE08716893B}']

  function _getdns1: Integer;
  function _getdns2: Integer;
  function _getgateway: Integer;
  function _getipAddress: Integer;
  function _getleaseDuration: Integer;
  function _getnetmask: Integer;
  function _getserverAddress: Integer;
  {Properties}

  property  dns1:Integer read _getdns1;
  property  dns2:Integer read _getdns2;
  property  gateway:Integer read _getgateway;
  property  ipAddress:Integer read _getipAddress;
  property  leaseDuration:Integer read _getleaseDuration;
  property  netmask:Integer read _getnetmask;
  property  serverAddress:Integer read _getserverAddress;

   function  toString():jstring;cdecl;
  end;
  TJDhcpInfo = class(TJavaGenericImport<JDhcpInfoClass, JDhcpInfo>)
  end;

  JWifiInfoClass = interface(JObjectClass)
  ['{367D067C-9E4C-4009-B905-5CC3F0DA9DDB}']
  {Methods}
  end;
  [JavaSignature('android/net/WifiInfo')]
  JWifiInfo = interface(JObject)
  ['{C0AA36B7-5666-4BD0-BE3E-7B45F5221804}']
    {Methods}
   function  getIpAddress():Integer;cdecl;
  end;
  TJWifiInfo = class(TJavaGenericImport<JWifiInfoClass, JWifiInfo>)
  end;

  JWiFiManagerClass = interface(JObjectClass)
   ['{F69F53AE-BC63-436A-8F69-57389B30CAA8}']
    function getSystemService(Contex: JString): JWiFiManager; cdecl;
  end;

  [JavaSignature('android/net/wifi/WifiManager')]
  JWiFiManager = interface(JObject)
    ['{382E85F2-6BF8-4255-BA3C-03C696AA6450}']
    function createMulticastLock(tag: JString): JMulticastLock; cdecl;
    function getConnectionInfo():JWifiInfo; cdecl;
    function getScanResults() :JList; cdecl;
    function getDhcpInfo(): JDhcpInfo; cdecl;
  end;

  TJWiFiManager = class(TJavaGenericImport<JWiFiManagerClass, JWiFiManager>) end;

  JMulticastLockClass = interface(JObjectClass)
  ['{C0546633-3DF2-46B0-8E2C-C14411674A6F}']
  end;

  [JavaSignature('android/net/wifi/WifiManager$MulticastLock')]
  JMulticastLock = interface(JObject)
  ['{CFA00D0C-097C-45E3-8B33-0E5A6C9FB9F1}']
    procedure acquire();
    function isHeld(): Boolean;
    procedure release();
    procedure setReferenceCounted(refCounted: boolean);
  end;

  TJMulticastLock = class(TJavaGenericImport<JMulticastLockClass, JMulticastLock>) end;

  //--
  function GetWiFiManager: JWiFiManager;
  function GetIP: string;
 {$ENDIF}
implementation
 {$IF DEFINED(ANDROID)}
 uses
    IdGlobal;
 type
  u_char = Byte;
  PAnsiChar =PIdAnsiChar;
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;
  PInAddr = ^TInAddr;
  in_addr = record
    case integer of
      0: (S_un_b: SunB);
  end;
  TInAddr = in_addr;

 procedure StringToTInAddr(AIP: string; var AInAddr);
begin
  with TInAddr(AInAddr).S_un_b do begin
    s_b1 := u_char(StrToInt(Fetch(AIP, '.')));    {Do not Localize}
    s_b2 := u_char(StrToInt(Fetch(AIP, '.')));    {Do not Localize}
    s_b3 := u_char(StrToInt(Fetch(AIP, '.')));    {Do not Localize}
    s_b4 := u_char(StrToInt(Fetch(AIP, '.')));    {Do not Localize}
  end;
end;
function  TInAddrToString(var AInAddr:Integer): string;
begin
  with TInAddr(AInAddr).S_un_b do begin
    result := IntToStr(integer(s_b1)) + '.' + IntToStr(integer(s_b2)) + '.'
        + IntToStr(integer(s_b3)) + '.'    {Do not Localize}
        + IntToStr(integer(s_b4));
  end;
end;
function GetWiFiManager: JWiFiManager;
var
  Obj: JObject;
begin
  Obj := SharedActivityContext.getSystemService(TJContext.JavaClass.WIFI_SERVICE);
  if not Assigned(Obj) then
    raise Exception.Create('Could not locate Wifi Service');
  Result := TJWiFiManager.Wrap((Obj as ILocalObject).GetObjectID);
  if not Assigned(Result) then
    raise Exception.Create('Could not access Wifi Manager');
end;
function GetIP: string;
var
DhcpInfo:JDhcpInfo;
ipAddress:integer;
begin

   DhcpInfo:= GetWiFiManager.getDhcpInfo;
   if DhcpInfo<>nil then begin

      ipAddress :=DhcpInfo.ipAddress;
      result:=TInAddrToString( ipAddress);
   end;
end;
{$ENDIF}
end.
