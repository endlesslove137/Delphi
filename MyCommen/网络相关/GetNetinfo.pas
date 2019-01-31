unit GetNetinfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  MAX_HOSTNAME_LEN    = 128;
  MAX_DOMAIN_NAME_LEN = 128;
  MAX_SCOPE_ID_LEN    = 256;
  iphlpapidll = 'iphlpapi.dll';

type
  //
  // TIPAddressString - store an IP address or mask as dotted decimal string
  //
  PIPAddressString = ^TIPAddressString;
  PIPMaskString    = ^TIPAddressString;
  TIPAddressString = record
    _String: array[0..(4 * 4) - 1] of ansiChar;
  end;
  TIPMaskString = TIPAddressString;

  //
  // TIPAddrString - store an IP address with its corresponding subnet mask,
  // both as dotted decimal strings
  //
  PIPAddrString = ^TIPAddrString;
  TIPAddrString = packed record
    Next: PIPAddrString;
    IpAddress: TIPAddressString;
    IpMask: TIPMaskString;
    Context: DWORD;
  end;

  //
  // FIXED_INFO - the set of IP-related information which does not depend on DHCP
  //
  PFixedInfo = ^TFixedInfo;
  TFixedInfo = packed record
    HostName: array[0..MAX_HOSTNAME_LEN + 4 - 1] of ansiChar;
    DomainName: array[0..MAX_DOMAIN_NAME_LEN + 4 - 1] of ansiChar;
    CurrentDnsServer: PIPAddrString;
    DnsServerList: TIPAddrString;
    NodeType: UINT;
    ScopeId: array[0..MAX_SCOPE_ID_LEN + 4 - 1] of ansiChar;
    EnableRouting,
    EnableProxy,
    EnableDns: UINT;
  end;
function GetNetworkParams(pFixedInfo: PFixedInfo; pOutBufLen: PULONG): DWORD; stdcall;
function GetNetworkParams; external iphlpapidll Name 'GetNetworkParams';
function GetDNS():TStringList;


implementation


function GetDNS():TStringList;
var
  pFI: PFixedInfo;
  pIPAddr: PIPAddrString;
  OutLen: Cardinal;
begin
  Result := TStringList.Create;
  OutLen := SizeOf(TFixedInfo);
  GetMem(pFI, SizeOf(TFixedInfo));
  try
    if GetNetworkParams(pFI, @OutLen) = ERROR_BUFFER_OVERFLOW then
    begin
      ReallocMem(pFI, OutLen);
      if GetNetworkParams(pFI, @OutLen) <> NO_ERROR then Exit;
    end;
    // If there is no network available there may be no DNS servers defined
    if pFI^.DnsServerList.IpAddress._String[0] = #0 then Exit;
    // Add first server
    Result.Add(pFI^.DnsServerList.IpAddress._String);
    // Add rest of servers
    pIPAddr := pFI^.DnsServerList.Next;
    while Assigned(pIPAddr) do
    begin
      Result.Add(pIPAddr^.IpAddress._String);
      pIPAddr := pIPAddr^.Next;
    end;
  finally
    FreeMem(pFI);
  end;
end;

end.
