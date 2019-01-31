unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids;

type
  TFsingledbgrid = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fsingledbgrid: TFsingledbgrid;

implementation

{$R *.dfm}

end.
