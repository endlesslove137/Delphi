unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, gdiplus, ExtCtrls, Mask, RzEdit, RzBtnEdt, shellapi,
  ComCtrls, Buttons, strutils, math;

const
 strSuccessText = '报告首长, 操作已成功完成';
 strSuccessCap = '来自Bad Boy 的温馨提示';


type
  TForm1 = class(TForm)
    pnl1: TPanel;
    pb1: TProgressBar;
    lbledt1: TLabeledEdit;
    btn1: TSpeedButton;
    lbledt2: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Photo: TGpImage;
    PhWidth: Integer;
    PhHeight: Integer;
    Watermark: TGpImage;
    WmWidth: Integer;
    WmHeight: Integer;
    Bmp: TGpBitmap;
    SavePath: string;
    procedure saveWaterMark(Const Filename:string);
    procedure WaterMarkFIle(const Filename: string);
  public
   procedure WMDROPFILES(var Msg: TMessage);message WM_DROPFILES;
  end;

var
  Form1: TForm1;

implementation
uses GdipTypes;

{$R *.dfm}

function MakeFileList(Path,FileExt:string):TStringList ;
var
sch:TSearchrec;
begin
Result:=TStringlist.Create;

if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
else
    Path := trim(Path);

if not DirectoryExists(Path) then
begin
    Result.Clear;
    exit;
end;

if FindFirst(Path + '*', faAnyfile, sch) = 0 then
begin
    repeat
       if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
//       if DirectoryExists(Path+sch.Name) then
//       begin
//         Result.AddStrings(MakeFileList(Path+sch.Name,FileExt));
//       end
//       else
       begin
         if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt)) or (FileExt='.*') then
         Result.Add(Path+sch.Name);
       end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
end;
end;

function GetTextWidthInPixel(Sender:TObject;DisplayText:String):Integer;
var
  vLabel:TLabel;
begin
  vLabel:=TLabel.Create(nil);
  vLabel.Parent:=(Sender as TWinControl);
  with vLabel do
  begin
    vLabel.Font.Name := 'arial';
    vLabel.Font.Size := 8;
    Caption:=DisplayText;
    Result:=Canvas.TextWidth(String(DisplayText));
  end;
  FreeAndNil(vLabel);
end;


procedure TForm1.WaterMarkFile(Const Filename:string);
const
  ColorMatrix: TColorMatrix =
  (
    (1.0, 0.0, 0.0, 0.0, 0.0),
    (0.0, 1.0, 0.0, 0.0, 0.0),
    (0.0, 0.0, 1.0, 0.0, 0.0),
    (0.0, 0.0, 0.0, 0.3, 0.0),
    (0.0, 0.0, 0.0, 0.0, 1.0)
  );
//  copyright = '花❤花曼屋 http://shop66451844.taobao.com'; // 346 * 17
var
  gp: TGpGraphics;
  x, y, i1: Single;
  ifont: integer;
  strFormat: TGpStringFormat;
  font: TGpFont;
  strTemp, copyright: string;
  imageAttr: TGpImageAttributes;

begin
  copyright := lbledt1.Text;
  if Trim(copyright)='' then Exit;

//  showmessage(SavePath);
  strTemp := ExtractFilename(Filename);
  SavePath := ExtractFileDir(Filename) + '\加水印后\' +strTemp;

  // 读取原始图片
  Photo := TGpImage.Create(Filename);
  PhWidth := Photo.Width;
  PhHeight := Photo.Height;
  // 读取水印图片
//  Watermark := TGpImage.Create('D:\mine\百度网盘\Desktop\飞信截图20130805173426.bmp');
//  WmWidth := Watermark.Width;
//  WmHeight := Watermark.Height;

  // 建立一个新的位图，分辨率为72
  Bmp := TGpBitmap.Create(PhWidth, PhHeight, pf32bppArgb);
  Bmp.SetResolution(72, 72);

  // 建立新位图的画布，并设置图像显示质量和文本显示质量
  gp := TGpGraphics.Create(Bmp);
  gp.SmoothingMode := smHighQuality;
  gp.TextRenderingHint := thAntiAlias;
  // 在画布上画原始图片
  gp.DrawImage(Photo, GpRect(0, 0, PhWidth, PhHeight),
               0, 0, PhWidth, PhHeight, utPixel);

  // 建立图像显示辅助类
//  imageAttr := TGpImageAttributes.Create;
//  // 设置透明颜色为水印图片四角的底色，水印图显示为圆角图片
//  imageAttr.SetColorKey($ff00ff00, $ff00ff00, ctBitmap);
//  // 设置水印图片不透明度为0.3
//  imageAttr.SetColorMatrix(ColorMatrix, cfDefault, ctBitmap);
//  // 在画布左上角画水印图
//  gp.DrawImage(Watermark, GpRect({PhWidth - WmWidth - }10, 10, WmWidth, WmHeight),
//               0, 0, WmWidth, WmHeight, utPixel, imageAttr);

  // 设置文本字体和显示格式
  i1 := 440 / 36 / 20;
  ifont := floor(PhWidth / i1 / 36);
  font := TGpFont.Create('arial', ifont, [fsBold]);

  strFormat := TGpStringFormat.Create;
  strFormat.Alignment := saCenter;
  // 在画布下方居中显示阴影文本
  x := PhWidth / 2;
  y := PhHeight - ifont -11;
  gp.DrawString(copyright, font, Brushs[$99000000], x + 1, y + 1, strFormat);
  gp.DrawString(copyright, font, Brushs[$99ffffff], x, y, strFormat);
//  showmessage(inttostr(length(copyright)) + ' - ' + inttostr(PhWidth));
  font.Free;
  strFormat.Free;
  gp.Free;

//  imageAttr.Free;
  saveWaterMark(SavePath);
end;

procedure  TForm1.saveWaterMark(Const Filename:string);
var
  Clsid: TGUID;
  Parameters: TEncoderParameters;
  Quality: Integer;
begin
  // 设置图像品质编码参数
  Parameters.Count := 1;
  Parameters.Parameter[0].Guid := EncoderQuality;
  Parameters.Parameter[0].ValueType := EncoderParameterValueTypeLong;
  Parameters.Parameter[0].NumberOfValues := 1;
  // 设置参数的值：品质等级，最高为100，图像文件大小与品质成正比
  Quality := 100;
  Parameters.Parameter[0].Value := @Quality;

  if not DirectoryExists(ExtractFileDir(Filename)) then
   ForceDirectories(ExtractFileDir(Filename));
  if GetEncoderClsid('image/jpeg', Clsid) then
  Bmp.Save(Filename, Clsid, @Parameters);

end;




procedure TForm1.btn1Click(Sender: TObject);
var
 Templist: tstringlist;
 i :integer;
begin
 Templist := makefilelist(lbledt2.text, '.jpg');
 pb1.Max := Templist.Count;

 for i := 0 to Templist.Count-1 do
 begin
   APPLICATION.ProcessMessages;
   WaterMarkFile(Templist[i]);
   pb1.Position := i +1;
 end;
 application.MessageBox(strSuccesstext, strSuccessCap ,0)

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Photo.Free;
  Watermark.Free;
  BMP.FREE;
end;

procedure TForm1.FormPaint(Sender: TObject);
//var
//  g: TGpGraphics;
begin
//  g := TGpGraphics.Create(Canvas.Handle);
//  // 显示原始图片
//  g.DrawImage(Photo, 0, 0, PhWidth, PhHeight);
//  // 显示水印原始图片
//  g.TranslateTransform(0, PhHeight + 5);
//  g.DrawImage(Watermark, 0, 0, WmWidth, WmHeight);
//  // 显示带水印和文本的图像
//  g.TranslateTransform(PhWidth, -(PhHeight + 5));
//  g.DrawImage(Bmp, 0, 0, PhWidth, PhHeight);
//  g.Free;

end;



procedure TForm1.WMDROPFILES(var Msg: TMessage);
var
  FilesCount: Integer; // 文件总数
  i: Integer;
  FileName: array[0..255] of Char;
begin
  lbledt2.Clear;
//  获取文件总数
  FilesCount := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  // 获取文件名
  for i := 0 to 0 do
  begin
    DragQueryFile(Msg.WParam, 0, FileName, 256);
    lbledt2.Text := FileName;
  end;
  DragQueryFile(Msg.WParam, 0, FileName, 256);
  lbledt2.Text := FileName;
  // 释放
  DragFinish(Msg.WParam);
end;

end.
