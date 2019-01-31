unit UnitfrmWebGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWWebGrid, IWAdvWebGrid, IWCompButton,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

type
  TIWfrmWebGrid = class(TIWFormBasic)
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    WebGridDataList: TStringList;
    procedure QueryWebGrid(sSQL: string);
    procedure SetQueryWebGridData; virtual;
  end;

var
  IWfrmWebGrid: TIWfrmWebGrid;

implementation

uses ServerController;

{$R *.dfm}

{ TIWfrmWebGrid }

procedure TIWfrmWebGrid.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  WebGridDataList := TStringList.Create;
end;

procedure TIWfrmWebGrid.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  ClearWebGridDataList(WebGridDataList);
  WebGridDataList.Free;
end;

procedure TIWfrmWebGrid.QueryWebGrid(sSQL: string);
var
  I: Integer;
  StringArray: PTStringArray;
begin
  with UserSession.quWebGrid,TIWAdvWebGrid1 do
  begin
    SQL.Text := sSQL;
    Open;
    ClearWebGridDataList(WebGridDataList);
    ClearCells;
    try
      while not Eof do
      begin
        New(StringArray);
        SetLength(StringArray^,FieldList.Count);
        for I := 0 to Length(StringArray^) - 1 do
        begin
          if TIWAdvWebGrid1.Columns[i+1].Tag <> 0 then
          begin
             StringArray^[I] := Utf8ToString(FieldList.Fields[I].AsAnsiString);
          end else
            StringArray^[I] := String(FieldList.Fields[I].AsAnsiString);
        end;
        WebGridDataList.AddObject(StringArray^[0],TObject(StringArray));
        Next;
      end;
    finally
      Close;
    end;
    TotalRows := WebGridDataList.Count;
    RowCount := WebGridDataList.Count;
    SetQueryWebGridData;
  end;
end;

procedure TIWfrmWebGrid.SetQueryWebGridData;
var
  I,J: Integer;
  StringArray: PTStringArray;
begin
  for I := 0 to WebGridDataList.Count - 1 do
  begin
    StringArray := PTStringArray(WebGridDataList.Objects[I]);
    for J := 1 to Length(StringArray^) do
    begin
        TIWAdvWebGrid1.cells[J,I] := (StringArray^[J-1]);
    end;
  end;
end;

end.
