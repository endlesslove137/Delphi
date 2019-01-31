unit Upath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TFpath = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fpath: TFpath;

implementation
   uses udata2;
{$R *.dfm}

procedure TFpath.SpeedButton2Click(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then Exit;
  try
    Animate1.Visible:=True;//将Animate1隐藏
    data2.back.CommandText:='backup database jxc to disk='+''''+Trim(Edit1.Text)+'''';//将'backup database jxc to disk='+''''+Trim(Edit1.Text)+''''赋给data2.back.CommandText
    Animate1.Active:=True;//将Animate1的属性Active设为true
    data2.back.Execute;
    Animate1.Active:=False;//将Animate1的属性Active设为false
    Application.MessageBox('备份数据成功','提示',mb_ok);
  except
    Application.MessageBox('备份数据失败','提示',mb_ok);
  end;
  Animate1.Visible:=False;//不将Animate1隐藏
end;

procedure TFpath.SpeedButton1Click(Sender: TObject);
begin
 case tag of
 1:
 begin
  with tsavedialog.Create(nil) do
  begin
   title:='请选择备份位置';
   if execute then
   edit1.Text:=filename;//将文件备份路径赋给edit1.Text
   free;//释放空间
  end;
 end;
 2:
 begin
  with topendialog.Create(nil) do
  begin
   title:='请选择备份文件的位置';
   if execute then
   edit1.Text:=filename;//将文件备份路径赋给edit1.Text
   free;//释放空间
  end;
 end;
 end;

end;

procedure TFpath.SpeedButton3Click(Sender: TObject);
begin
 if Application.MessageBox('恢复前请先备份，是否开始恢复？','提示',mb_yesno)=id_no then
    Exit;
  if Trim(Edit1.Text)='' then Exit;
  try
    try
      Animate1.Visible:=True;//将Animate1隐藏
      data2.back.CommandText:='use master alter database jxc set offline WITH ROLLBACK IMMEDIATE use master restore database jxc from disk='+''''+Trim(Edit1.Text)+''''+'with replace alter database jxc set online with rollback immediate';
      Animate1.Active:=True;//将Animate1的属性Active设为True
      data2.back.Execute;
      Animate1.Active:=False;
      Application.MessageBox('恢复数据成功..您需要重启软件以使用还原的数据','提示',mb_ok);
    finally
      data2.back.CommandText:='use jxc';//将'use jxc'赋给data2.back.CommandText
      data2.back.Execute;
    end;
  except
    Application.MessageBox('恢复数据失败','提示',mb_ok);
  end;
  Animate1.Visible:=False;//不将Animate1隐藏


end;

end.
