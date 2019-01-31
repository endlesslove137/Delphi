unit uZXing;

interface
 uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts,
  System.Rtti,
  {$IF DEFINED(ANDROID)}
  FMX.Helpers.Android,
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  FMX.Platform.Android,
   {$ENDIF}
  FMX.platform;
const
  C_CodeModes: array[0..2] of string = ('PRODUCT_MODE', 'QR_CODE_MODE', 'SCAN_MODE');
type
   TCodeMode =(PRODUCT_MODE,QR_CODE_MODE,SCAN_MODE);
   TOnScanFinished =procedure(sData:string)of object;
   TZXingCall = class(TObject)
   private
    FClipboardService: IFMXClipboardService;
    FClipboardValue: TValue;
    FZXingCalled: Boolean;
    FZXingApkOpened: Boolean;
    FOnScanFinished:TOnScanFinished;
    FCanUse:Boolean;
    FOnInstallFinished:TNotifyEvent;
    procedure ClipboardSave;
    procedure ClipboardBack;
    {$IF DEFINED(ANDROID)}
    function GetZXingIntent: JIntent;

    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    function IsIntentCallable(const AIntent: JIntent): Boolean;
     {$ENDIF}
   public
    FAAppEvent: TApplicationEvent;
    constructor Create(Sender:TObject);
    destructor Destroy; override;
    procedure CallZXing( CodeMode:TCodeMode=SCAN_MODE);
    {$IF DEFINED(ANDROID)}
    function CheckEnvironment(var ErrorID:Integer):Boolean;
    {$ENDIF}
    procedure OpenURL(const AURL: string);
    procedure openFile(const sPath: string);
    property OnScanFinished:TOnScanFinished read FOnScanFinished write FOnScanFinished;
    property OnInstallFinished:TNotifyEvent read FOnInstallFinished write  FOnInstallFinished;
  end;
implementation

{ TZXingCall }

procedure TZXingCall.CallZXing(CodeMode:TCodeMode);
{$IF DEFINED(ANDROID)}
var
  LIntent: JIntent;
 {$ENDIF}
begin
  FZXingApkOpened := false;
  if not FCanUse then Exit;

  ClipboardSave;
  FClipboardService.SetClipboard('');
  {$IF DEFINED(ANDROID)}

  LIntent := GetZXingIntent();
  LIntent.putExtra(StringToJString('SCAN_MODE'), StringToJString(C_CodeModes[ord(CodeMode)]));
  SharedActivity.startActivityForResult(LIntent, 0);
  {$ENDIF}
  FZXingCalled := True;
end;

{$IF DEFINED(ANDROID)}
function TZXingCall.CheckEnvironment(var ErrorID:Integer): Boolean;
var
  LFMXApplicationEventService: IFMXApplicationEventService;
  LIsZXingCallable: Boolean;
  LStr: string;
begin
  Result := False;
  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService,
       IInterface(LFMXApplicationEventService)) then begin
    LFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent)
  end else begin
    ErrorID :=-1;
  end;
  if not TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,
       IInterface(FClipboardService)) then begin
    ErrorID :=-2;
  end;
  LIsZXingCallable := IsIntentCallable(GetZXingIntent);
  if not LIsZXingCallable then
  begin
    ErrorID :=-3;
  end ;
  result := Assigned(LFMXApplicationEventService) and
            Assigned(FClipboardService) and LIsZXingCallable;
  FCanUse := result;
end;
function TZXingCall.IsIntentCallable(const AIntent: JIntent): Boolean;
var
  LJPackageManager: JPackageManager;
begin
  Result := False;
  if Assigned(AIntent) then
  begin
    LJPackageManager := SharedActivityContext.getPackageManager;
    Result := LJPackageManager.queryIntentActivities(AIntent,
      TJPackageManager.JavaClass.MATCH_DEFAULT_ONLY).size <> 0;
  end;
end;

function TZXingCall.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
var
  LResult: string;
  ErrorID:Integer;
begin
  if FZXingCalled and (AAppEvent = TApplicationEvent.aeBecameActive) then
  begin
    LResult := FClipboardService.GetClipboard.ToString;
    FClipboardService.SetClipboard('');
    if Assigned(FOnScanFinished) then begin
      FOnScanFinished(LResult);
    end;
    ClipboardBack;
    FZXingCalled := False;
  end;
  if FZXingApkOpened and (AAppEvent = TApplicationEvent.aeBecameActive)  then
  begin
    //--

    if Assigned(FOnInstallFinished) then begin
      FAAppEvent := AAppEvent;
      FOnInstallFinished(self);
    end;

    if self.CheckEnvironment(ErrorID) then begin
        FZXingApkOpened := False;
        self.CallZXing(QR_CODE_MODE);
    end;
  end;

  Result := True;
end;
function TZXingCall.GetZXingIntent: JIntent;
const
  GOOGLE_ZXING = 'com.google.zxing.client.android.SCAN';
  GOOGLE_ZXING_PACKAGE = 'com.google.zxing.client.android';
begin
  Result := TJIntent.JavaClass.init(StringToJString(GOOGLE_ZXING));
  Result.setPackage(StringToJString(GOOGLE_ZXING_PACKAGE));
end;

{$ENDIF}
procedure TZXingCall.ClipboardBack;
begin
  FClipboardService.SetClipboard(FClipboardValue);
end;


procedure TZXingCall.ClipboardSave;
begin
  FClipboardValue := FClipboardService.GetClipboard;
end;


constructor TZXingCall.Create(Sender: TObject);
begin
  //--
  FCanUse := False;
  FZXingApkOpened := False;
end;
procedure TZXingCall.OpenURL(const AURL: string);
{$IF DEFINED(ANDROID)}
var
  LIntent: JIntent;
{$ENDIF}
begin
  {$IF DEFINED(ANDROID)}
  LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
    TJnet_Uri.JavaClass.parse(StringToJString(AURL)));
  SharedActivity.startActivity(LIntent);
  {$ENDIF}
end;
procedure TZXingCall.openFile(const sPath: string);
{$IF DEFINED(ANDROID)}
var
  LIntent: JIntent;
  barfile:JFile;
{$ENDIF}
begin
  {$IF DEFINED(ANDROID)}
  LIntent := TJIntent.JavaClass.init();
  LIntent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  LIntent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  barfile := TJFile.JavaClass.init(StringToJString(sPath));
  barfile.setReadable(True,False);  //--这几句很重要，不然调不出来安装包
  barfile.setWritable(True,False);
  LIntent.setDataAndType(TJnet_Uri.JavaClass.fromFile(barfile),
                          StringToJString('application/vnd.android.package-archive'));

  //--SharedActivity.startActivity(LIntent);
  SharedActivity.startActivityForResult(LIntent, 0);
  FZXingApkOpened := True;
  {$ENDIF}
end;

destructor TZXingCall.Destroy;
begin

  inherited;
end;


end.

