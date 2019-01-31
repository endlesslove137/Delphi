unit Udatamanager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ubackup, urstore,upublic,StdCtrls, jpeg, ExtCtrls, Buttons;

type
  TFdatamanager = class(TForm)
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Label1: TLabel;
    Splitter2: TSplitter;
    Label2: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fdatamanager: TFdatamanager;

implementation

{$R *.dfm}

procedure TFdatamanager.SpeedButton2Click(Sender: TObject);
begin
 if issure then
  showform(TFrestore,Frestore);
end;

procedure TFdatamanager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  isexit(self,action);
end;

procedure TFdatamanager.SpeedButton1Click(Sender: TObject);
begin
 showform( TFbackup,Fbackup);
end;

end.
