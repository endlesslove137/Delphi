unit uWellDynPublicSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, StrUtils, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomPopupMenu,
  cxGridPopupMenu, StdCtrls, Mask, RzEdit, RzButton, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar, RzLabel, ExtCtrls,
  RzPanel, uROClient, uDAScriptingProvider, uDADataTable, uDAMemDataTable,
  uDAInterfaces, uStyleSeting, cxLookAndFeels, cxLookAndFeelPainters,
  cxDropDownEdit, UBusinessGlobal, cxTextEdit;

const
  DlgSysTitle = '系统提示';
  DlgSelectRecord = '请选择记录信息';
type
  TWellDynPublicSelectFrm = class(TForm)
    grdSelect: TcxGrid;
    gtvTableView: TcxGridDBTableView;
    glvGridLevel: TcxGridLevel;
    Panel2: TPanel;
    edtFilter: TRzEdit;
    Label1: TLabel;
    RzPanel1: TRzPanel;
    DADataSource: TDADataSource;
    gtvTableViewRowNumColumn: TcxGridDBColumn;
    cxStyleRepository1: TcxStyleRepository;
    styleNormal: TcxStyle;
    styleSelected: TcxStyle;
    cxLookAndFeelController1: TcxLookAndFeelController;
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterEnter(Sender: TObject);
    procedure gtvTableViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift:
      TShiftState; var AHandled: Boolean);
    procedure gtvTableViewMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure gtvTableViewRowNumColumnGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
  private
    procedure SetcxGridDBTableViewStyle(cxGridDBTableView: TcxGridDBTableView; EIRCStyle: TEIRCStyle);

  public
    { Public declarations }
    Flag: Boolean;
    FieldName: string;
    FrmClassName: TForm;
    DAMemDataTable: TDAMemDataTable;
    SelectRowValues: array of Variant;
    procedure InitGridView(aFieldName: string);
    procedure FilterTextIncxGrid(aText: string; ATableView: TcxGridDBTableView);
  published
  end;

var
  WellDynPublicSelectFrm: TWellDynPublicSelectFrm;
implementation


{$R *.dfm}

//进行模糊查询
procedure TWellDynPublicSelectFrm.FilterTextIncxGrid(aText: string; ATableView: TcxGridDBTableView);
var
  IDColumn, JPColumn: TcxGridDBColumn;
begin
  if not SameText(Trim(aText), '') then
  begin
    ATableView.DataController.Filter.clear;
  end;
  aText := UpperCase(aText);

  IDColumn := NIL;
  JPColumn := NIL;

  with ATableView do
  begin
    IDColumn := GetColumnByFieldName(FieldName);
    JPColumn := GetColumnByFieldName('SPY');
    DataController.Filter.BeginUpdate;
    try
      with DataController.Filter do
      begin
        Root.Clear;
        Root.BoolOperatorKind := fboOr;
        if IDColumn <> NIL then
        begin
          Root.AddItem(IDColumn, foLike, '%' + aText + '%', '''%' + aText + '%''');
          Root.AddItem(IDColumn, foEqual, aText, aText);
        end;
        if JPColumn <> NIL then
        begin
          Root.AddItem(JPColumn, foLike, '%' + aText + '%', '''%' + aText + '%''');
        end;
      end;
      DataController.Filter.Active := True;
    finally
      DataController.Filter.EndUpdate;
    end;
  end;
end;

procedure TWellDynPublicSelectFrm.edtFilterChange(Sender: TObject);
begin
  FilterTextIncxGrid(Trim(edtFilter.Text), gtvTableView);
end;

procedure TWellDynPublicSelectFrm.edtFilterEnter(Sender: TObject);
begin
  edtFilter.Text := '';
  gtvTableView.DataController.Filter.Clear;
end;

procedure TWellDynPublicSelectFrm.gtvTableViewCellDblClick(Sender:
  TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  I, J, K: Integer;
  cxPopupEdit: TcxPopupEdit;
begin
  try
    K := gtvTableView.ColumnCount;
    if K = 0 then
    begin
      Application.MessageBox(DlgSelectRecord, DlgSysTitle, Mrok);
      Exit;
    end;
    J := gtvTableView.Controller.FocusedRowIndex;
    SetLength(SelectRowValues, K);
    for I := 0 to K - 1 do
    begin
      SelectRowValues[I] := gtvTableView.ViewData.Records[J].Values[I];
    end;
    Flag := True;
  except

  end;
  //关闭下拉框
  for I := 0 to FrmClassName.ComponentCount - 1 do
  begin
    if (FrmClassName.Components[I] is TcxPopupEdit) then
    begin
      (FrmClassName.Components[I] as TcxPopupEdit).DroppedDown := False;
    end;
  end;
end;

//初始化表格信息
procedure TWellDynPublicSelectFrm.InitGridView(aFieldName: string);
var
  I, J: Integer;
begin
  edtFilter.Clear;
  try
    FieldName := aFieldName;
    with gtvTableView do
    begin
      gtvTableView.DataController.DataModeController.GridMode := True;
      DataController.DataSource := DADataSource;
      while DataController.ItemCount > 1 DO
      begin
        DataController.GetItem(1).Free;
      end;
      SetcxGridDBTableViewStyle(gtvTableView, ClassicStyle);
      DataController.CreateAllItems();

      for J := 1 to ColumnCount - 1 do
      begin
        if Columns[J].Caption <> Columns[J].DataBinding.Field.DisplayLabel then
        begin
          Break;
        end
        else
        begin
          if (Columns[J].DataBinding.Field.Visible) and
            (Columns[J].Caption <> Columns[J].DataBinding.FieldName) then
          begin
            Columns[J].Caption := HexToStr(Columns[J].DataBinding.Field.DisplayLabel);
          end;
        end;
      end;


      gtvTableView.DataController.DataModeController.GridMode := False;
    end;
  except
  end;
  for I := 0 to gtvTableView.ColumnCount - 1 do
  begin
    gtvTableView.Columns[I].HeaderAlignmentVert := vaCenter;
    gtvTableView.Columns[I].HeaderAlignmentHorz := taCenter;
    gtvTableView.Columns[I].HeaderGlyphAlignmentVert := vaCenter;
    gtvTableView.Columns[I].HeaderGlyphAlignmentHorz := taCenter;
  end;
end;

procedure TWellDynPublicSelectFrm.gtvTableViewMouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I, J, K: Integer;
  cxPopupEdit: TcxPopupEdit;
begin
  try
    K := gtvTableView.ColumnCount;
    if K = 0 then
    begin
      Application.MessageBox(DlgSelectRecord, DlgSysTitle, Mrok);
      Exit;
    end;
    J := gtvTableView.Controller.FocusedRowIndex;
    SetLength(SelectRowValues, K);
    for I := 0 to K - 1 do
    begin
      SelectRowValues[I] := gtvTableView.ViewData.Records[J].Values[I];
    end;
    Flag := True;
  except

  end;
  //关闭下拉框
  for I := 0 to FrmClassName.ComponentCount - 1 do
  begin
    if (FrmClassName.Components[I] is TcxPopupEdit) then
    begin
      (FrmClassName.Components[I] as TcxPopupEdit).DroppedDown := False;
    end;
  end;
end;

procedure TWellDynPublicSelectFrm.gtvTableViewRowNumColumnGetDataText(Sender:
  TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
var
  RecordCount: Integer;
begin
  RecordCount := gtvTableView.DataController.RecordCount;
  AText := Format('%.' + IntToStr(Length(IntToStr(RecordCount))) + 'd', [ARecordIndex + 1]);
end;


procedure TWellDynPublicSelectFrm.SetcxGridDBTableViewStyle(cxGridDBTableView: TcxGridDBTableView; EIRCStyle: TEIRCStyle);
begin

  cxGridDBTableView.OptionsView.Indicator := False;
  cxGridDBTableView.OptionsView.GroupByBox := False;
  cxGridDBTableView.Styles.ContentEven := TcxStyle.Create(cxGridDBTableView);
  cxGridDBTableView.Styles.ContentOdd := TcxStyle.Create(cxGridDBTableView);
  cxGridDBTableView.Styles.ContentEven.Color := $00FFDDDD;
  cxGridDBTableView.Styles.ContentOdd.Color := clCream;
  cxGridDBTableView.OptionsView.Navigator := True;
   //设置左下方按钮的
  cxGridDBTableView.OptionsView.ColumnAutoWidth := False;

  cxGridDBTableView.NavigatorButtons.Append.Visible := False;
  cxGridDBTableView.NavigatorButtons.Cancel.Visible := False;
  cxGridDBTableView.NavigatorButtons.Delete.Visible := False;
  cxGridDBTableView.NavigatorButtons.Edit.Visible := False;
  cxGridDBTableView.NavigatorButtons.Insert.Visible := False;
  cxGridDBTableView.NavigatorButtons.Post.Visible := False;
  cxGridDBTableView.NavigatorButtons.Refresh.Visible := False;
  cxGridDBTableView.OptionsSelection.CellSelect := False;
end;

end.

