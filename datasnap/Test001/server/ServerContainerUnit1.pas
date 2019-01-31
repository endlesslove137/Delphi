unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSTCPServerTransport,
  Datasnap.DSHTTPCommon, Datasnap.DSHTTP,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher,
  Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry,
  Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight,
  Datasnap.DSProxyFreePascal_iOS,
  Datasnap.DSAuth, IPPeerServer, DbxSocketChannelNative, DbxCompressionFilter,
  Datasnap.DSProxyJavaScript, Datasnap.DSMetadata, Datasnap.DSServerMetadata;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    DSHTTPService1: TDSHTTPService;
    DSAuthenticationManager1: TDSAuthenticationManager;
    DSHTTPServiceProxyDispatcher1: TDSHTTPServiceProxyDispatcher;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    DSHTTPServiceFileDispatcher1: TDSHTTPServiceFileDispatcher;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSAuthenticationManager1UserAuthorize(Sender: TObject;
      EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManager1UserAuthenticate(Sender: TObject;
      const Protocol, Context, User, Password: string; var valid: Boolean;
      UserRoles: TStrings);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  ServerContainer1: TServerContainer1;

implementation

uses Winapi.Windows, ServerMethodsUnit1;

{$R *.dfm}

procedure TServerContainer1.DataModuleCreate(Sender: TObject);
begin
  //write the JavaScript proxy on startup
  DSProxyGenerator1.Write;
end;

procedure TServerContainer1.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthenticate(
  Sender: TObject; const Protocol, Context, User, Password: string;
  var valid: Boolean; UserRoles: TStrings);
begin
  { TODO : Validate the client user and password.
    If role-based authorization is needed, add role names to the UserRoles parameter  }
  valid := True;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthorize(
  Sender: TObject; EventObject: TDSAuthorizeEventObject;
  var valid: Boolean);
begin
  { TODO : Authorize a user to execute a method.
    Use values from EventObject such as UserName, UserRoles, AuthorizedRoles and DeniedRoles.
    Use DSAuthenticationManager1.Roles to define Authorized and Denied roles
    for particular server methods. }
  valid := True;
end;


end.

