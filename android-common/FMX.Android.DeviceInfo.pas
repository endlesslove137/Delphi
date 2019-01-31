(* ************************************************************************

  Oldroid Components for Delphi

  Copyright ?013 by David Esperalta

  http://www.davidesperalta.com/
  mailto:info@davidesperalta.com

  ************************************************************************ *)

unit FMX.Android.DeviceInfo;

interface

uses
  System.Classes, XSuperObject;

type
  TDeviceInfo = record // class(TObject)
  private
    function GetIMEI(): string;
  public

    ID: string;
    IMEI: string;
    User: string;
    Host: string;
    Tags: string;
    Time: string;
    AType: string;
    Board: string;
    Radio: string;
    Brand: string;
    Model: string;
    Serial: string;
    Device: string;
    CpuABI: string;
    CpuABI2: string;
    Display: string;
    Product: string;
    Hardware: string;
    Bootloader: string;
    FingerPrint: string;
    Manufacturer: string;
    procedure GetInformation();
  end;

implementation

uses
{$IFDEF ANDROID}
  AndroidAPI.JNI.Os,
  FMX.Helpers.Android,
  AndroidAPI.JNIBridge,
  AndroidAPI.JNI.Provider,
  AndroidAPI.JNI.JavaTypes,
  AndroidAPI.JNI.Telephony,
  AndroidAPI.JNI.GraphicsContentViewText,
{$ENDIF}
  System.SysUtils;

{ TDeviceInfo }

//constructor TDeviceInfo.Create; // (AOwner: TComponent)
//begin
//  // inherited Create;
//  GetInformation();
//end;

procedure TDeviceInfo.GetInformation();
begin
  IMEI := Self.GetIMEI();
{$IFDEF ANDROID}
  Time := IntToStr(TJBuild.JavaClass.Time);
  ID := JStringToString(TJBuild.JavaClass.ID);
  User := JStringToString(TJBuild.JavaClass.User);
  AType := JStringToString(TJBuild.JavaClass.&TYPE);
  Host := JStringToString(TJBuild.JavaClass.Host);
  Tags := JStringToString(TJBuild.JavaClass.Tags);
  Radio := JStringToString(TJBuild.JavaClass.Radio);
  Brand := JStringToString(TJBuild.JavaClass.Brand);
  Board := JStringToString(TJBuild.JavaClass.Board);
  Model := JStringToString(TJBuild.JavaClass.Model);
  Device := JStringToString(TJBuild.JavaClass.Device);
  Serial := JStringToString(TJBuild.JavaClass.Serial);
  CpuABI := JStringToString(TJBuild.JavaClass.CPU_ABI);
  Product := JStringToString(TJBuild.JavaClass.Product);
  Display := JStringToString(TJBuild.JavaClass.Display);
  CpuABI2 := JStringToString(TJBuild.JavaClass.CPU_ABI2);
  Hardware := JStringToString(TJBuild.JavaClass.Hardware);
  Bootloader := JStringToString(TJBuild.JavaClass.Bootloader);
  FingerPrint := JStringToString(TJBuild.JavaClass.FingerPrint);
  Manufacturer := JStringToString(TJBuild.JavaClass.Manufacturer);
{$ENDIF}
end;

function TDeviceInfo.GetIMEI(): string;
{$IFDEF ANDROID}
var
  JObj: JObject;
  Manager: JTelephonyManager;
{$ENDIF}
begin
  Result := '';
{$IFDEF ANDROID}
  JObj := SharedActivityContext.getSystemService
    (TJContext.JavaClass.TELEPHONY_SERVICE);
  if JObj <> nil then
  begin
    Manager := TJTelephonyManager.Wrap((JObj as ILocalObject).GetObjectID);
    if Manager <> nil then
      Result := JStringToString(Manager.getDeviceId);
  end;

  if Result = '' then
  begin
    Result := JStringToString(TJSettings_Secure.JavaClass.getString
      (SharedActivity.getContentResolver,
      TJSettings_Secure.JavaClass.ANDROID_ID));
  end;
{$ENDIF}
end;

end.
