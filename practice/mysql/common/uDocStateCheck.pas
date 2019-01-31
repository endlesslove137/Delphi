unit uDocStateCheck;

interface

uses IdTCPClient, ExtCtrls, Classes;

type
  TDocStateType = (dsOpen = 6767, dsList, dsClose, dsForceClose, dsOpenDocIP);


  TDocStateCheck = class(TObject)
  private
    IdTCPClient: TIdTCPClient;
    ConnectedCheckTimer: TTimer;
    OpenDocList: TStringList;
    procedure LoadConfig;
    function TCPConnected: Boolean;
    procedure TimerConnectedCheckTimer(Sender: TObject);
    function GetConnected: Boolean;
    function GetOpenDocIP(sDoc: string): string;
  public
    OpenDocIP: string;
    sHostName: string;
    constructor Create;
    destructor Destroy; override;

    function CheckDocState(sDoc: string;AddRecord: Boolean=True): Boolean;
    procedure CloseDocState(sDoc: string);
    function GetOpenDocList: string;
  end;

var
  DocStateCheck: TDocStateCheck;
  BisDebug :boolean; // 是不是调试状态(供开发人员使用)
implementation

{ TDocStateCheck }

uses IniFiles, SysUtils, Dialogs;

function TDocStateCheck.CheckDocState(sDoc: string;AddRecord: Boolean): Boolean;
begin
  Result := False;
  if BisDebug then
  begin
     Result := True;
     Exit;
  end;
  
  if GetConnected then
  begin
    IdTCPClient.IOHandler.Write(Integer(dsOpen));
    IdTCPClient.IOHandler.Write(Length(sDoc));
    IdTCPClient.IOHandler.Write(sDoc);
    IdTCPClient.IOHandler.Write(Length(sHostName));
    IdTCPClient.IOHandler.Write(sHostName);
    Result := IdTCPClient.IOHandler.ReadSmallInt = Integer(dsOpen);
    if Result and AddRecord then
    begin
      OpenDocList.Add(sDoc);
    end
    else begin
      OpenDocIP := GetOpenDocIP(sDoc);
    end;
  end;
end;

procedure TDocStateCheck.CloseDocState(sDoc: string);
var
  Idx: Integer;
begin
  if GetConnected then
  begin
    IdTCPClient.IOHandler.Write(Integer(dsClose));
    IdTCPClient.IOHandler.Write(Length(sDoc));
    IdTCPClient.IOHandler.Write(sDoc);
    Idx := OpenDocList.IndexOf(sDoc);
    if Idx <> -1 then
    begin
      OpenDocList.Delete(Idx);
    end;
  end;
end;

// 通过配置连接服务哭
constructor TDocStateCheck.Create;
begin
  inherited;
  IdTCPClient := TIdTCPClient.Create(nil);
  IdTCPClient.ReadTimeout := 15000;
  LoadConfig;
  if not BisDebug then  TCPConnected ;
  ConnectedCheckTimer := TTimer.Create(nil);
  ConnectedCheckTimer.Interval := 5000;
  ConnectedCheckTimer.OnTimer := TimerConnectedCheckTimer;
  ConnectedCheckTimer.Enabled := False;
  if not BisDebug then ConnectedCheckTimer.Enabled := True;
  OpenDocList := TStringList.Create;
end;

destructor TDocStateCheck.Destroy;
begin
  inherited;
  IdTCPClient.Disconnect;
  IdTCPClient.Free;
  ConnectedCheckTimer.Free;
  OpenDocList.Free;
end;

function TDocStateCheck.GetConnected: Boolean;
begin
  Result := False;
  try
    Result := IdTCPClient.Connected;
  except
  end;
end;

function TDocStateCheck.GetOpenDocIP(sDoc: string): string;
begin
  Result := '';
  if TCPConnected then
  begin
    IdTCPClient.IOHandler.Write(Integer(dsOpenDocIP));
    IdTCPClient.IOHandler.Write(Length(sDoc));
    IdTCPClient.IOHandler.Write(sDoc);
    Result := IdTCPClient.IOHandler.ReadString(IdTCPClient.IOHandler.ReadInteger);
  end;
end;

function TDocStateCheck.GetOpenDocList: string;
begin
  Result := '';
  if GetConnected then
  begin
    IdTCPClient.IOHandler.Write(Integer(dsList));
    Result := IdTCPClient.IOHandler.ReadString(IdTCPClient.IOHandler.ReadInteger);
  end;
end;

procedure TDocStateCheck.LoadConfig;
const
  sConfigName = '.\DocStateCheck.ini';
var
  Section: string;
  Ident: string;
begin
  with TIniFile.Create(sConfigName) do
  begin
    Section := '设置';
    Ident := '主机';
    if not ValueExists(Section,Ident) then
    begin
      WriteString(Section,Ident,'127.0.0.1');
    end;
    IdTCPClient.Host := ReadString(Section,Ident,'127.0.0.1');
    Ident := '端口';
    if not ValueExists(Section,Ident) then
    begin
      WriteInteger(Section,Ident,5880);
    end;
    IdTCPClient.Port := ReadInteger(Section,Ident,5880);

    Ident := '调试状态';
    if not ValueExists(Section,Ident) then
    begin
      WriteBool(Section,Ident,False);
    end;
    BisDebug := ReadBool(Section,Ident,False);
//    ShowMessage('LoadConfig' + BoolToStr(BisDebug,True));
    Free;
  end;
end;

function TDocStateCheck.TCPConnected: Boolean;
begin
  Result := False;
  try
    if not GetConnected then
    begin
      IdTCPClient.Disconnect;
      IdTCPClient.Connect;
    end;
    Result := GetConnected;
  except on E: Exception do
    ShowMessage(Format('%s: %s(%s)', [SysErrorMessage(GetLastError), '无法连接文档状态服务器',IdTCPClient.Host]));
  end;
end;

procedure TDocStateCheck.TimerConnectedCheckTimer(Sender: TObject);
var
  I: Integer;
begin
  if not GetConnected then
  begin
    try
      IdTCPClient.Disconnect;
      IdTCPClient.Connect;
    except
      ConnectedCheckTimer.Enabled := False;
      ShowMessage('与文档状态服务器断开连接'+IdTCPClient.Host);
      ConnectedCheckTimer.Enabled := False;
      ConnectedCheckTimer.Enabled := True;
    end;
    if GetConnected then
    begin
      for I := 0 to OpenDocList.Count - 1 do
      begin
        CheckDocState(OpenDocList.Strings[I], False);
      end;
    end;
  end;
end;

end.
