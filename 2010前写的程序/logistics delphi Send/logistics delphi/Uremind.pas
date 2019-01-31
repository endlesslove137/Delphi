unit Uremind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,udata, upublic,ExtCtrls, Grids, DBGrids, StdCtrls,
  Buttons, DBCtrls, Mask;

type
  TFremind = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    TabSheet2: TTabSheet;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton2: TSpeedButton;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpeedButton3: TSpeedButton;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    SpeedButton4: TSpeedButton;
    ListBox1: TListBox;
    CheckBox2: TCheckBox;
    TabSheet4: TTabSheet;
    Panel4: TPanel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SpeedButton5: TSpeedButton;
    GroupBox2: TGroupBox;
    DBText1: TDBText;
    DBText2: TDBText;
    DBCheckBox1: TDBCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    GroupBox3: TGroupBox;
    DBGrid3: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure DBCheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fremind: TFremind;

implementation

{$R *.dfm}

procedure TFremind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isexit(self,action);
end;




procedure TFremind.SpeedButton1Click(Sender: TObject);
var
 s:string;
begin
 s:='select * from orders where state='+quotedstr('“—…Û«Î');
 settemp(s);
 dbgrid1.DataSource:=fdata.dstemp;
 label3.Caption:=inttostr(fdata.temp.recordcount);

end;


procedure TFremind.SpeedButton2Click(Sender: TObject);
var
 s:string;
begin
 s:='select * from orders where state='+quotedstr('‘⁄ø‚');
 settemp(s);
 dbgrid2.DataSource:=fdata.dstemp;
 label6.Caption:=inttostr(fdata.temp.recordcount);

end;



procedure TFremind.SpeedButton3Click(Sender: TObject);
var
 s:string;
begin
 s:='select b.master,b.phone,a.carinform from dispatch a inner join cars b on a.carid=b.carid where convert(char(10),shipdate,105)=convert(char(10),getdate(),105)';
 settemp(s);
 label9.Caption:=inttostr(fdata.temp.recordcount);
 listboxadditem(listbox1,fdata.temp,'master');
 if strtoint(label9.Caption)=0 then
  groupbox1.Visible:=false
 else
  groupbox1.Visible:=true;

end;


procedure TFremind.ListBox1Click(Sender: TObject);
begin
 fdata.temp.Locate('master',listbox1.Items.Strings[listbox1.itemindex],[]);
 setlabel(label13,'phone','q');
 setcheckbox(checkbox2,'carinform');
 speedbutton4.Enabled:=not checkbox2.Checked;
end;


procedure TFremind.SpeedButton4Click(Sender: TObject);
begin
  if issure then
  begin
   setprocedure('carinform;1','@master',listbox1);
   speedbutton4.Enabled:=false;
  end;
end;

procedure TFremind.SpeedButton5Click(Sender: TObject);
begin
 fdata.reparationinform.Open;
 if fdata.reparationinform.RecordCount=0 then
 begin
  setenable(groupbox3,0);
  setenable(groupbox2,0);
 end else
 begin
  setenable(groupbox3,1);
  setenable(groupbox2,1);
 end;
 label15.Caption:=inttostr(fdata.reparationinform.RecordCount);
end;

procedure TFremind.DBCheckBox1Click(Sender: TObject);
begin
  if dbcheckbox1.Checked then
  begin
    if issure then exit
    else dbcheckbox1.Checked:=false;
  end else
  exit;
end;

end.
