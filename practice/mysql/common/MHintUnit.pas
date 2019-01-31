unit MHintUnit;

interface

uses
  Windows, Classes, Controls, Graphics, Forms, SysUtils, ExtCtrls;

type
  TOnDrawHint = procedure (Sender: TObject; ARect: TRect; ACanvas: TCanvas; HintText: string) of Object;
  TMirosHint = class(THintWindow)
  private
    //FWndBmp: TBitmap; //窗口位图
    //FHintBmp: TBitmap; //提示信息位图
    FBitMap : TBitMap;
    FHintHidePause: Cardinal;
    FHintPause: Cardinal;

    FRounderColor: TColor;
    FBorderColor : TColor;
    FOnDrawHint : TOnDrawHint;
  protected
    procedure Loaded;override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure NCPaint(DC: HDC); override;
    {画提示的图象}
    procedure DrawHintImg(Bmp:TBitmap; AHint: string);
    {取得提示窗口对应的桌面区域的图象}
    procedure GetDesktopImg(Bmp: TBitmap; R: TRect);
    {对桌面区域图象作处理,使其看起来像一块玻璃且带有一点阴影}
    procedure EffectHandle(WndBmp, HintBmp: TBitmap);

    procedure DrawBkGround(var ABitMap: TBitMap);
    procedure DrawHintText(var ABitMap: TBitMap; sText: string);
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  published
    property  HintHidePause: Cardinal read FHintPause write FHintPause;
    property  OnDrawHint: TOnDrawHint read FOnDrawHint write FOnDrawHint;
    property  RounderColor: TColor read FRounderColor write FRounderColor;
  end;

var
  MHintBevelColor : Integer = $00EFBEC6;
  MHintBorderColor: Integer = $00EFD3C6;


implementation

{ TwdHintWnd }

procedure TMirosHint.ActivateHint(Rect: TRect; const AHint: string);
var
  P: TPoint;
begin
  //在这里取得一个适当的尺寸显示文字
  if Assigned(FOnDrawHint) then
   begin
     FOnDrawHint(Self, Rect, FBitMap.Canvas, AHint);
   end;

  FRounderColor := MHintBevelColor;
  FBorderColor  := MHintBorderColor;

  FBitMap.Width   := Rect.Right - Rect.Left;
  FBitMap.Height := Rect.Bottom - Rect.Top + 4;
  Inc(Rect.Bottom, 2);
  BoundsRect := Rect;
  DrawBkGround(FBitMap);
  DrawHintText(FBitMap, AHint);
  //DrawHintImg(FBitMap, AHint);
//  FWndBmp.Width := Rect.Right - Rect.Left + 23;
//  FWndBmp.Height := Rect.Bottom - Rect.Top + 27;
 // Inc(Rect.Right, 23);
 // Inc(Rect.Bottom, 27);
  //Inc(Rect.Right, 2);

  if Left < Screen.DesktopLeft then
    Left := Screen.DesktopLeft;
  if Top < Screen.DesktopTop then
    Top := Screen.DesktopTop;
  if Left + Width > Screen.DesktopWidth then
    Left := Screen.DesktopWidth - Width;
  if Top + Height > Screen.DesktopHeight then
    Top := Screen.DesktopHeight - Height;
//  GetDesktopImg(FWndBmp, BoundsRect);
//  EffectHandle(FWndBmp, FHintBmp);  }
  P := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, P.X, P.Y, 0, 0,
  SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
{  FHintBmp.Width := Rect.Right - Rect.Left;
  FHintBmp.Height := Rect.Bottom - Rect.Top + 4;
  DrawHintImg(FHintBmp, AHint);
  FWndBmp.Width := Rect.Right - Rect.Left + 23;
  FWndBmp.Height := Rect.Bottom - Rect.Top + 27;
  Inc(Rect.Right, 23);
  Inc(Rect.Bottom, 27);
  BoundsRect := Rect;
  if Left < Screen.DesktopLeft then
    Left := Screen.DesktopLeft;
  if Top < Screen.DesktopTop then
    Top := Screen.DesktopTop;
  if Left + Width > Screen.DesktopWidth then
    Left := Screen.DesktopWidth - Width;
  if Top + Height > Screen.DesktopHeight then
    Top := Screen.DesktopHeight - Height;
  GetDesktopImg(FWndBmp, BoundsRect);
  EffectHandle(FWndBmp, FHintBmp);
  P := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, P.X, P.Y, 0, 0,
  SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);      }
end;


constructor TMirosHint.Create(Aowner: TComponent);
begin
  inherited;
  {FWndBmp := TBitmap.Create;
  FWndBmp.PixelFormat := pf24bit;
  FHintBmp := TBitmap.Create;  }
  FBitMap  := TBitMap.Create;
  FBitMap.PixelFormat := pf24Bit;
  FRounderColor   := $00C66931;
  FBorderColor    := $00EFD3C6;
  FHintHidePause  := Application.HintHidePause;
end;


procedure TMirosHint.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //去掉窗口边框
  Params.Style := Params.Style and not WS_BORDER;
end;


destructor TMirosHint.Destroy;
begin
  //FWndBmp.Free;
  //FHintBmp.Free;
  FBitMap.Free;
  inherited;
end;


procedure TMirosHint.GetDesktopImg(Bmp: TBitmap; R: TRect);
var
  C: TCanvas;
begin
  C:= TCanvas.Create;
  try
    C.Handle := GetDC(0);
    Bmp.Canvas.CopyRect(Rect(0, 0, Bmp.Width, Bmp.Height), C, R);
  finally
    C.Free;
  end;
end;


procedure TMirosHint.EffectHandle(WndBmp, HintBmp: TBitmap);
var
  R: TRect;
  i, j: Integer;
  P: PByteArray;
  Transt, TranstAngle: Integer;
begin
  R := Rect(0, 0, WndBmp.Width - 4, WndBmp.Height - 4);
  Frame3D(WndBmp.Canvas, R, clMedGray, clBtnShadow, 1);
  //作窗口底下的阴影效果
  Transt := 60;
  for j:= WndBmp.Height - 4 to WndBmp.Height - 1 do
    begin
      P := WndBmp.ScanLine[j];
      TranstAngle := Transt;
      for i:= 3 to WndBmp.Width - 1 do
        begin//如果正处于右下角
          if i > WndBmp.Width - 5 then
            begin
              P[3*i] := P[3*i] * TranstAngle div 100;
              P[3*i + 1] := P[3*i + 1] * TranstAngle div 100;
              P[3*i + 2] := P[3*i + 2] * TranstAngle div 100;
              TranstAngle := TranstAngle + 10;
              if TranstAngle > 90 then TranstAngle := 90;
            end
            else begin
              P[3*i] := P[3*i] * Transt div 100;
              P[3*i + 1] := P[3*i + 1] * Transt div 100;
              P[3*i + 2] := P[3*i + 2] * Transt div 100;
            end;
        end;
      Transt := Transt + 10;
    end;

  //作窗口右边的阴影效果
  for j := 3 to WndBmp.Height - 5 do
    begin
      P := WndBmp.ScanLine[j];
      Transt := 60;
      for i:= WndBmp.Width - 4 to WndBmp.Width -1 do
        begin
          P[3*i] := P[3*i] * Transt div 100;
          P[3*i + 1] := P[3*i + 1] * Transt div 100;
          P[3*i + 2] := P[3*i + 2] * Transt div 100;
          Transt := Transt + 10;
        end;
    end;
  WndBmp.Canvas.Draw(10, 10, HintBmp);
end;


procedure TMirosHint.NCPaint;
begin
//重载不让画边框
end;


procedure TMirosHint.Paint;
begin
  //Canvas.CopyRect(ClientRect, FWndBmp.Canvas, ClientRect);
  Canvas.CopyRect(ClientRect, FBitMap.Canvas, ClientRect);
end;


procedure TMirosHint.DrawHintImg(Bmp: TBitmap; AHint: string);
var
  R: TRect;
begin
  Bmp.Canvas.Brush.Color := Application.HintColor;
  Bmp.Canvas.Pen.Color := Application.HintColor;
  Bmp.Canvas.Rectangle(0, 0, Bmp.Width, Bmp.Height);
  Bmp.Canvas.Font.Color := Screen.HintFont.Color;
  R := Rect(0, 0, Bmp.Width, Bmp.Height);
  Inc(R.Left, 4);
  Inc(R.Top, 1);
  DrawText(Bmp.Canvas.Handle, PChar(AHint), -1, R, DT_LEFT or DT_NOPREFIX or
  DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

procedure TMirosHint.Loaded;
begin
  inherited;
  Application.HintHidePause := FHintHidePause;
end;

procedure TMirosHint.DrawBkGround(var ABitMap: TBitMap);
begin
  with ABitMap.Canvas do
   begin
    Pen.Color  := FRounderColor;
    Brush.Color:= FBorderColor;
    Rectangle(ClientRect);
   end;
end;

procedure TMirosHint.DrawHintText(var ABitMap: TBitMap; sText: string);
var
  Rec: TRect;
begin
  Rec := Rect(ClientRect.Left + 4, ClientRect.Top + 1, ClientRect.Right, ClientRect.Bottom);
  with ABitMap.Canvas do
   begin
    Brush.Style := bsClear;
    Font.Assign(Self.Font);
    DrawText(ABitMap.Canvas.Handle, PChar(sText), Length(sText), Rec, DT_LEFT or DT_NOPREFIX or
              DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly)
   end;
end;

initialization
begin
  Application.ShowHint := False;
  HintWindowClass := TMirosHint;
  Application.ShowHint := True;
end;

end.