unit SockBind;

interface

uses
  Windows, SysUtils, Classes, WinSock2;
  
type
  TSockBindAddress = class(TCollectionItem)
  private
    m_BindAddrIn : TSockAddrIn;
    function GetBindAddress: string;
    function GetBindPort: Integer;
    procedure SetBindAddress(const Value: string);
    procedure SetBindAddrIn(const Value: TSockAddrIn);
    procedure SetBindPort(const Value: Integer);
  public
    constructor Create(Collection: TCollection);override;
    property BindAddrIn: TSockAddrIn read m_BindAddrIn write SetBindAddrIn;
    procedure Assign(Address: TSockBindAddress);
  published
    property Address: string read GetBindAddress write SetBindAddress;
    property Port: Integer read GetBindPort write SetBindPort;
  end;
  
  TSockBindAddresses = class(TCollection)
  private
    function GetItem(Index: Integer): TSockBindAddress;
    procedure SetItem(Index: Integer; Value: TSockBindAddress);
  public
    function Add: TSockBindAddress;
    property Items[Index: Integer]: TSockBindAddress read GetItem write SetItem; default;
  end;

  TSocketBind = class(TComponent)
  private
    m_Binds : TSockBindAddresses;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy();override;
  published
    property Binds: TSockBindAddresses read m_Binds;
  end;

implementation

{ TSocketBind }

procedure TSockBindAddress.Assign(Address: TSockBindAddress);
begin
  if Address <> nil then m_BindAddrIn := Address.m_BindAddrIn;
end;

constructor TSockBindAddress.Create(Collection: TCollection);
begin
  inherited;
  m_BindAddrIn.sin_family := AF_INET;
end;

function TSockBindAddress.GetBindAddress: string;
begin
  Result := inet_ntoa(m_BindAddrIn.sin_addr);
end;

function TSockBindAddress.GetBindPort: Integer;
begin
  Result := htons(m_BindAddrIn.sin_port);
end;

procedure TSockBindAddress.SetBindAddress(const Value: string);
begin
  m_BindAddrIn.sin_addr.S_addr := inet_addr(PChar(Value));
end;

procedure TSockBindAddress.SetBindAddrIn(const Value: TSockAddrIn);
begin
  m_BindAddrIn := Value;
  m_BindAddrIn.sin_family := AF_INET;
end;

procedure TSockBindAddress.SetBindPort(const Value: Integer);
begin
  m_BindAddrIn.sin_port := htons(Value);
end;

{ TSocketBinds }

function TSockBindAddresses.Add: TSockBindAddress;
begin
  Result := TSockBindAddress(inherited Add);
end;

function TSockBindAddresses.GetItem(Index: Integer): TSockBindAddress;
begin
  Result := TSockBindAddress(inherited GetItem(Index));
end;

procedure TSockBindAddresses.SetItem(Index: Integer; Value: TSockBindAddress);
begin
  inherited SetItem(Index, Value);
end;

{ TSocketBind }

constructor TSocketBind.Create(AOwner: TComponent);
begin
  inherited;
  m_Binds := TSockBindAddresses.Create(TSockBindAddress);
end;

destructor TSocketBind.Destroy;
begin
  m_Binds.Free;
  inherited;
end;

end.
