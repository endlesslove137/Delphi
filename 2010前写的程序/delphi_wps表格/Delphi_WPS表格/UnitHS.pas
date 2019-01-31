unit UnitHS;

interface
uses
StdCtrls, ExtCtrls, DBCtrls, DB,   ADODB,  Grids,  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, Menus,  ComCtrls,  DBGrids, Buttons;
function SaveToet(bg: TDBGrid ):boolean;
implementation
uses unit1;
function SaveToet(bg: TDBGrid ):boolean;

var  i,row,column,j:integer;begin
  if bg.DataSource.DataSet.RecordCount =0 then exit;
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet1'].Activate;

  column:=1;
  for j:=0 to bg.FieldCount-1 do
  begin
    IF bg.Columns[j].Visible =true then
    begin
    myworkbook.worksheets['sheet1'].cells[1,column].value:=bg.columns.Items[j].Title.caption   ;
    column:=column+1;
    end;
  end;
  row:=2;
  bg.DataSource.DataSet.First;

  While Not (bg.DataSource.DataSet.Eof) do
  begin
    column:=1;
    for i:=0 to bg.Columns.Count-1   do
    begin
      IF BG.Columns[I].Visible =true then
        begin
        myworkbook.worksheets['sheet1'].cells[row,column].value:=bg.Columns[i].Field.AsString   ;
        column:=column+1;
      end;
    end;
    bg.DataSource.DataSet.Next;
    row:=row+1;
  end;
    showmessage('导出完毕,请在wps表格中进行编辑、排版、打印等操作！');
 end;


end.
