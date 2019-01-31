unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, Buttons,adoconed;

type
  TForm1 = class(TForm)
    ADOCommand1: TADOCommand;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
 s:string;
begin
 s:='use master if exists(select*from sysdatabases where name=''Jxc'') exec sp_detach_db Jxc exec sp_attach_db @dbname='+char(39)+'Jxc'+char(39)+', '+
    '@filename1='+char(39)+extractfilepath(paramstr(0))+'Jxc_data.mdf'+char(39)+', '+
    '@filename2='+char(39)+extractfilepath(paramstr(0))+'Jxc_log.ldf'+char(39);
 adocommand1.CommandText:=s;
 adocommand1.Execute();
 messagebox(handle,'安装成功','恭喜',mb_ok+mb_iconinformation);    
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  editconnectionstring(adocommand1);
end;

end.
