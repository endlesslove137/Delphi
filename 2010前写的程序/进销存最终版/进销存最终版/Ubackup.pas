unit Ubackup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ToolWin, ActnMan, ActnCtrls, XPStyleActnCtrls,
  Buttons, ImgList, ComCtrls, StdCtrls, jpeg, ExtCtrls;

type
  TForm22 = class(TForm)
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Label1: TLabel;
    Splitter2: TSplitter;
    Label2: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form22: TForm22;

implementation

{$R *.dfm}
  uses upath;
procedure TForm22.SpeedButton1Click(Sender: TObject);
begin
 fpath.Tag:=1;//将值1赋给fpath.Tag
 fpath.SpeedButton3.Visible:=false;//不将fpath.SpeedButton3隐藏
 fpath.SpeedButton2.Visible:=true;//将fpath.SpeedButton2隐藏
 fpath.ShowModal;//显示fpath界面
end;

procedure TForm22.SpeedButton2Click(Sender: TObject);
begin
 fpath.Tag:=2;//将值2赋给fpath.Tag
 fpath.SpeedButton3.Visible:=true;//将fpath.SpeedButton3隐藏
 fpath.SpeedButton2.Visible:=false;//不将fpath.SpeedButton2隐藏
 fpath.ShowModal;//显示fpath界面
end;

end.
