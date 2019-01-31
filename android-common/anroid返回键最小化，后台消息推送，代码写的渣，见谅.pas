unit Unit6;

interface

uses
  System.SysUtils, System.Types, System.UITypes,
  System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo, System.Rtti,
  FMX.Helpers.Android,
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  FMX.platform,
  FMX.platform.Android,
  FMX.Notification;

type
  TForm6 = class(TForm)
    CornerButton1: TCornerButton;
    Label1: TLabel;
    Memo1: TMemo;
    Timer1: TTimer;
    NotificationCenter1: TNotificationCenter;
    procedure FormShow(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure SetBack(const AAction: JString);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure Log(s: string);
  public
    function HandleAppEvent(AAppEvent: TApplicationEvent;
      AContext: TObject): Boolean;
  end;

var
  Form6: TForm6;

implementation

{$R *.fmx}

uses
  Unit7;

procedure SendNotification(title: string; info: string);
var
  NotificationService: IFMXNotificationCenter;
  Notification: TNotification;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXNotificationCenter)
  then
    NotificationService := TPlatformServices.Current.GetPlatformService
      (IFMXNotificationCenter) as IFMXNotificationCenter;

  if Assigned(NotificationService) then
  begin
    Notification := TNotification.Create;
    try
      Notification.Name := 'test';
      Notification.AlertBody := 'this is text';
      Notification.FireDate := Now + EncodeTime(0, 0, 5, 0);
      NotificationService.ScheduleNotification(Notification);
    finally
      Notification.Free;
    end;
  end
end;

procedure TForm6.SetBack(const AAction: JString); // 后台运行。。
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(AAction);
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_HOME);
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  SharedActivityContext.startActivity(Intent);
end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
  SendNotification('test', '消息推送设置');
  Timer1.Enabled := false;
end;

procedure TForm6.CornerButton1Click(Sender: TObject);
begin
  Form7.Show;
end;

procedure TForm6.FormCreate(Sender: TObject);
var
  aFMXApplicationEventService: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(aFMXApplicationEventService)) then
    aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent)
  else
    Log('Application Event Service is not supported.');
end;

function TForm6.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    aeEnteredBackground:
      begin
        Timer1.Enabled := true;
        Log('进入后台');
      end;
    aeWillBecomeForeground:
      Log('变成前台');

  end;
  Result := true;
end;

procedure TForm6.Log(s: string);
begin
  Memo1.Lines.Add(TimeToStr(Now) + ': ' + s);
end;

procedure TForm6.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  aFMXApplicationEventService: IFMXApplicationEventService;
begin
  if Key = vkHardwareBack then
    SetBack(TJIntent.JavaClass.ACTION_MAIN);
  // MainActivity.finish;

  // TApplicationEvent.aeEnteredBackground;
  // Memo1.Lines.Add();
  // aFMXApplicationEventService.SetApplicationEventHandler(TApplicationEvent.aeEnteredBackground);
  // SetBack(TJIntent.JavaClass.ACTION_MAIN);
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  showmessage('ok');
end;

end.
