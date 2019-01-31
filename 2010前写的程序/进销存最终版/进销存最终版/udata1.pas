unit udata1;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  Tdata1 = class(TDataModule)
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  data1: Tdata1;

implementation

{$R *.dfm}

end.
