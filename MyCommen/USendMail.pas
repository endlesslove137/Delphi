unit uSendMail;

interface

uses IdSMTP, IdMessage;

type
  TSendMail = class(TObject)
  private
    FUserName: string;
    FPassWord: string;
    FSmtpHost: string;
    FPort: Integer;
    FSubject: string;
    FFromName: string;
    FFromAddress: string;
    FMessageText: string;
    FEMailAddresses: string;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
  public
    constructor Create;
    destructor Destroy; override;

    property UserName: string read FUserName write FUserName;
    property PassWord: string read FPassWord write FPassWord;
    property SmtpHost: string read FSmtpHost write FSmtpHost;
    property Port: Integer read FPort write FPort;
    property Subject: string read FSubject write FSubject;
    property FromName: string read FFromName write FFromName;
    property FromAddress: string read FFromAddress write FFromAddress;
    property MessageText: string read FMessageText write FMessageText;
    property EMailAddresses: string read FEMailAddresses write FEMailAddresses;
    function SendMail: Boolean;
  end;

implementation

{ TSendMail }

constructor TSendMail.Create;
begin
  inherited;
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
end;

destructor TSendMail.Destroy;
begin
  IdSMTP.Free;
  IdMessage.Free;
  inherited;
end;

function TSendMail.SendMail: Boolean;
begin
  Result := False;
  if IdSMTP.Connected then IdSMTP.Disconnect;
  if (UserName = '') and (FromAddress <> '') then
  begin
    UserName := Copy(FromAddress,1,Pos('@',FromAddress)-1);
  end;
  IdSMTP.Username := UserName;
  IdSMTP.Password := PassWord;
  IdSMTP.Host := SmtpHost;
  IdSMTP.Port := Port;
  IdSMTP.Connect;
  if IdSMTP.Connected then
  begin
    IdMessage.Body.Text := MessageText;
    IdMessage.Subject := Subject;
    IdMessage.From.Name := FromName;
    IdMessage.From.Address := FromAddress;
    IdMessage.Recipients.EMailAddresses := EMailAddresses;
    if IdSMTP.Authenticate then
    begin
      IdSMTP.Send(IdMessage);
      Result := True;
    end;
  end;
end;

end.
