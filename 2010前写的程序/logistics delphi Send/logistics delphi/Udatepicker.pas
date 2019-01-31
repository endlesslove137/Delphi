unit Udatepicker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,upublic,ComCtrls, ExtCtrls, Buttons;

type
  TFdatepicker = class(TForm)
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fdatepicker: TFdatepicker;

implementation

uses Umoney;

{$R *.dfm}

procedure TFdatepicker.SpeedButton1Click(Sender: TObject);
begin
 date1:=datetimepicker1.Date;
 date2:=datetimepicker2.Date;
 showform( TFmoney,Fmoney);
 close;
end;

procedure TFdatepicker.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

end.
