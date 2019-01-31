unit UOrderExcel;
////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: 张明明/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////

//    // 获取有数据的结束行
//    sDataAddress := ExcelApp.ActiveSheet.Range['$A$1'].CurrentRegion.Address;
//    // 数据起始行
//    rowend := rightstr(sDataAddress, length(sDataAddress) - pos(':',
//        sDataAddress));
//    rowend := rightstr(rowend, length(rowend) - 1);
//    rowend := rightstr(rowend, length(rowend) - pos('$', rowend));
//    reDRowEnd.EditText := rowend;
//

interface
uses
  comobj,variants,sysutils,StrUtils,ADODB,dialogs,windows,classes,
  uorderstring, upublic;
type
  TFieldMap = record
    ColName: string;
    ColIndex: integer;
  end;


  TExcel=class(Tobject)
  ExcelFileName,os:string;
  SheetCount:integer;
  SheetName:string;
  ExcelApp: variant;
  IsLastsheet:boolean;
  IsFirstSheet:boolean;
  private
    FSheetIndex: integer;
    FDisplayFullScreen: boolean;
    FCaption: string;
    FSaveChange: boolean;
    Fvisible: boolean;
    FShowAll: boolean;
    FShowAllRC: boolean;
    procedure SetSheetIndex(const Value: integer);
    procedure SetDisplayFullScreen(const Value: boolean);
    procedure SetCaption(const Value: string);
    procedure SetSaveChange(const Value: boolean);
    procedure Setvisible(const Value: boolean);
    procedure SetShowAll(const Value: boolean);
    procedure SetShowAllRC(const Value: boolean);
  public
   //create Excle is visible
   constructor create();overload;
   //create Excle But is not visible
   constructor create(FileName:string);reintroduce;overload;
   Property Caption:string read FCaption write SetCaption;
   property SheetIndex:integer read FSheetIndex write SetSheetIndex;
   property DisplayFullScreen:boolean read FDisplayFullScreen write SetDisplayFullScreen;
   property SaveChange:boolean read FSaveChange write SetSaveChange;
   property visible:boolean read Fvisible write Setvisible;
   Property ShowAll:boolean read FShowAll write SetShowAll;
   Property ShowAllRC:boolean read FShowAllRC write SetShowAllRC;

   //Statistical the column distinct items
   function StatisticalItems(Col:integer;MultiFiles:boolean=false):tstringlist;
   //statisticl sheet's(stringlist) name by Filename
   function GetSheets(Filename:string=''):tstringlist;
   // the row is empty?
   function EmptyRow(RowIndex:integer=0):boolean;
   // the column is empty?
   function EmptyCol(ColIndex:integer=0):boolean;
   //the function is test the object
   function test():string;
   //the Excel maxrow number
   function MaxRow():integer;
   //the Excel maxclo number
   function MaxCol():integer;
   //the Excle Current column number
   function CurCol(isMerge:boolean=False):integer;
   //the Excle Current row number
   function CurRow(isMerge:boolean=False):integer;
   //the Excle is still open?
   function isopen():boolean;
   // the Cell is empty
   function IsEmptyCell(RowIndex,ColIndex:integer):boolean;
   // Get the value of the cell(row,col)
   function GetValue(RowIndex,ColIndex:integer;ProcessNull:Boolean=False):Variant;
   //Next sheet is activate
   function NextSheet():Boolean;
   //Pervious sheet is activate
   function PreviousSheet():Boolean;


   //GEt Excle header
   procedure DelCol(Colindex:Integer);
   //GEt Excle header
   procedure GetHeader(Headerstartrow,HeaderStartCol,HeaderEndRow,HeaderEndCol:Integer;var tblcol:tadotable);
   //Delete Special Row witch continue the SpecialString
   procedure DelSpecialRow(SpecialString:string;ColIndex:integer=0;RowStart:integer=1;SplitterString:String='#');
   //Delete The Colindex Row
   procedure DelEmpRow(Rowindex:Integer=1;Colindex:integer=0);
   //Delete EmpCol
   procedure DelEmpCol;
   //Teilen the Cell and Full the orixxx Value
   procedure teiLenFull(ColIndex:integer);
   //Full of the Value on Col(colindex) From Row(Rowindex)
   procedure FullAValue(Colindex:integer;value: String;Rowindex:integer=1);
   //Delete empty Sheet
   procedure DeleteEmptySheet(Sure:boolean=false);
   //Saveas the Excle File
   procedure SaveAs();
//   procedure ChangeValue(Colindex:integer;value: String);
   //Close the Excel File
   procedure Close();
   //Count sheet number of the Excle File
   procedure GetSheetCount;
end;


implementation

//将打开的Excel文件关闭
procedure TExcel.Close();
begin
  // 如果打开了Excel，那么退出的时候要关闭文档和程序。
  if not VarIsEmpty(ExcelApp) then
  begin
    try
      // no query is save?-no save
      ExcelApp.ActiveWorkBook.Saved :=true;
      FSaveChange:=false;
      DisplayFullScreen:=False;
      ExcelApp.DisplayAlerts := true;//
      ExcelApp.WorkBooks.Close;
      ExcelApp.quit;
      ExcelApp := Unassigned;
      VarClear(ExcelApp);
    except
      on e: exception do
        showmessage(e.message);
    end;
  end;

end;

//not exactly
constructor TExcel.create();
var
 odfile:Topendialog;
begin
  inherited;
  odfile:=topendialog.create(nil);
  odFile.Options := [ofHideReadOnly, ofEnableSizing];
  odFile.InitialDir := 'D:\zmm\work\DayProd-EXCel-DingBian';
  if not odFile.Execute() then exit
  else ExcelFileName := odFile.FileName;
  try
  begin
  if varisempty(ExcelApp) then
    ExcelApp := CreateOleObject('Excel.Application');  //
    ExcelApp.WorkBooks.Open(ExcelFileName);

    os:=excelapp.OperatingSystem;
    ExcelApp.DisplayAlerts := False;// no waring

    SheetIndex:=1;
    sheetcount:=ExcelApp.Worksheets.Count;
    ShowAll:=true;
    DisplayFullScreen:=true;
    odfile.FreeOnRelease;
    DeleteEmptySheet(true);
    SheetName:= ExcelApp.ActiveSheet.Name;
    ExcelApp.Visible := True;
    ShowAllRC:=true;
  end;
  except on Exception do
    messagebox(0,'zmm warning','Excel is not installed on your machine',0);
  end;



end;






constructor TExcel.create(FileName: string);
begin
  try
  begin
  if varisempty(ExcelApp) then
    ExcelApp := CreateOleObject('Excel.Application');  //
    ExcelFileName:=Filename;
    ExcelApp.WorkBooks.Open(ExcelFileName);
    os:=excelapp.OperatingSystem;
    ExcelApp.DisplayAlerts := False;// no waring
    SheetIndex:=1;
    sheetcount:=ExcelApp.Worksheets.Count;
    DisplayFullScreen:=False;
    DeleteEmptySheet(true);
    SheetName:= ExcelApp.ActiveSheet.Name;
    ExcelApp.Visible := false;
    ShowAllRC:=True;
  end;
  except on Exception do
    messagebox(0,'zmm warning','Excel is not installed on your machine',0);
  end;

end;

function TExcel.CurCol(isMerge:boolean): integer;
var
  strAddress:variant;
  iCol:integer;
begin
 if not isopen then    Exit;
 if isMerge then
 begin
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address].MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,
      length(strAddress));
    iCol := ExcelApp.ActiveSheet.Range[strAddress].Column;
    result:=iCol;
  end
  else
    result:=ExcelApp.ActiveCell.column;
 end
 else
   result:=ExcelApp.ActiveCell.column;

end;

function TExcel.CurRow(isMerge:boolean): integer;
var
  strAddress:variant;
  iRow:integer;
begin
 if not isopen then    Exit;
 if isMerge then
 begin
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address].MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,
      length(strAddress));
    iRow := ExcelApp.ActiveSheet.Range[strAddress].Row;
    result:=iRow;
  end
  else
    result:=ExcelApp.ActiveCell.Row;
 end
 else
   result:=ExcelApp.ActiveCell.Row;

end;
procedure TExcel.DelCol(Colindex: Integer);
begin
  try
  ExcelApp.ActiveSheet.Columns[Colindex].DELETE; 
  except on E: Exception do
  ShowMessage('删除出错');
  end; 
end;

procedure TExcel.DelEmpCol;
var
 i:integer;
 si:Integer;
begin
 i:=1;
 si:=MaxCol;
 while i<=si do
 begin
  if EmptyCol(i) then
  begin
    DelCol(i);
    si:=si-1;
    continue;
  end;
  i:=i+1;
 end;
end;


procedure TExcel.DelEmpRow(Rowindex:Integer;Colindex:integer);
var
 i:integer;
 si:Integer;
begin
 si:=MaxRow;
  i:=Rowindex;
 if ColIndex=0 then
 begin
  while i<=si do
  begin
    if EmptyRow(i) then
    begin
      ExcelApp.ActiveSheet.Rows[i].DELETE;
      si:=si-1;
      continue;
    end;
    i:=i+1;
  end;
 end
 else
 begin
  while i<=si do
  begin
  if IsEmptyCell(i,Colindex) then
  begin
    ExcelApp.ActiveSheet.Rows[i].DELETE;
    si:=si-1;
    continue;
  end;
  i:=i+1;
  end;
 end;
end;

procedure TExcel.DeleteEmptySheet(sure:boolean=false);
var
 i:integer;
 sh:variant;
label
 loop_start;
begin
 if not sure then exit
 else
 begin
   loop_start:
   for i :=1  to sheetcount do
   begin
    If ExcelApp.WorksheetFunction.CountA(ExcelApp.Worksheets[i].Cells) = 0 Then
    begin
      ExcelApp.DisplayAlerts := False;
      ExcelApp.Worksheets[i].Delete;
      ExcelApp.DisplayAlerts := True;
      Getsheetcount();
      goto loop_start;
    end;
   end;
 end;
   ExcelApp.WorkSheets[1].Activate;
end;



procedure TExcel.DelSpecialRow(SpecialString: string; ColIndex: integer;
  RowStart:integer;SplitterString: String);
var
  SplitStringList:tstringlist;
  iLst,iRow,Si:integer;
  iFound:boolean;
  TempStr:string;
  TempVar:variant;
begin
  DelEmprow(RowStart);DelEmpCol;
  si:=MaxRow;
  SplitStringList := SplitString(SpecialString, SplitterString);
  iRow:=RowStart;
  if Colindex=0 then
  begin
   while iRow<=Si do
   begin
    try
      iFound:=false;
      for iLst := 0 to SplitStringList.Count - 1 do
      begin
      if variserror(ExcelApp.ActiveSheet.cells[iRow,1].Value) then
      begin
        irow:=irow+1;                              //
        break;
      end;
      if (pos(SplitStringList.Strings[iLst],vartostr(ExcelApp.ActiveSheet.cells[iRow,3].Value)) > 0)
       or (pos(SplitStringList.Strings[iLst],vartostr(ExcelApp.ActiveSheet.cells[iRow,1].Value)) > 0)
       or (pos(SplitStringList.Strings[iLst],vartostr(ExcelApp.ActiveSheet.cells[iRow,2].Value)) > 0)
       then
      begin
        ExcelApp.ActiveSheet.Rows[iRow].DELETE;
        si:=si-1;
        iFound:=true;
        break;
      end;
      if IsEmptyCell(iRow,3)
       and IsEmptyCell(iRow,2)
       and IsEmptyCell(iRow,1)
       then
      begin
        ExcelApp.ActiveSheet.Rows[iRow].DELETE;
        si:=si-1;
        iFound:=true;
        break;
      end;
    end;
    if not iFound then iRow:=iRow+1;
    except on E: Exception do
        irow:=irow+1;
    end;
   end;
  end
  else
  begin
  try
   while iRow<=Si do
   begin
    iFound:=false;
    for iLst := 0 to SplitStringList.Count - 1 do
    begin
      if variserror(ExcelApp.ActiveSheet.cells[iRow,ColIndex].Value) then
      begin
        irow:=irow+1;
        break;
      end;
      if (pos(SplitStringList.Strings[iLst],VarToStrDef(ExcelApp.ActiveSheet.cells[iRow,ColIndex].Value,'')) > 0)
       then
      begin
        ExcelApp.ActiveSheet.Rows[iRow].DELETE;
        si:=si-1;
        iFound:=true;
        break;
      end;
    end;
    if not iFound then iRow:=iRow+1;
   end;
  except
   on e:exception do
   showmessage(e.Message);
  end;
  end;

end;


function TExcel.EmptyCol(ColIndex: integer): boolean;
begin
if Colindex=0 then
 begin
  if ExcelApp.CountA(ExcelApp.ActiveSheet.Columns[CurCol])= 0 then
      result:=true
  else
   result:=false;
 end else
 begin
  if ExcelApp.CountA(ExcelApp.ActiveSheet.Columns[ColIndex])= 0 then
      result:=true
  else
   result:=false;
 end;

end;

function TExcel.EmptyRow(RowIndex:integer=0): boolean;
begin
 if Rowindex=0 then
 begin
  if ExcelApp.CountA(ExcelApp.ActiveSheet.Rows[currow])= 0 then
      result:=true
  else
   result:=false;
 end else
 begin
  if ExcelApp.CountA(ExcelApp.ActiveSheet.Rows[RowIndex])= 0 then
   result:=true
  else
   result:=false;
 end;
end;

procedure TExcel.FullAValue(Colindex:integer;value: String;Rowindex:integer);
var
  i:integer;
begin
 DelEmpcol;DelEmpRow;
 for i :=RowIndex  to maxrow do
 begin
     ExcelApp.ActiveSheet.cells[i,Colindex].value:=value;
 end;



end;

procedure TExcel.GetHeader(Headerstartrow, HeaderStartCol, HeaderEndRow,
  HeaderEndCol: Integer;var tblcol:tadotable);
var
 icol,irow, ci, thei, num, numind:Integer;
 mhs, hs, ts, cs, SQL: WideString;
 strAddr:variant;
begin
  for iCol := HeaderStartCol to HeaderEndCol do
  begin
      hs := '';
      ts := '';
      cs := '';
      for iRow := Headerstartrow to HeaderEndRow do
      begin
        if ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells = true then
        begin
          if IsNumeric(ExcelApp.ActiveSheet.cells[iRow, iCol].Value) then
           mhs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value))
          else
           mhs := trim(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
          strAddr := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveSheet.cells[iRow, iCol].Address].MergeArea.Address;
          ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells := false;
          ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := mhs;
          mhs := '';
        end;
        cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
        cs := trim(cs);
        if cs = '' then
        begin
          ExcelApp.ActiveSheet.cells[iRow, iCol].Value :=
            ExcelApp.ActiveSheet.cells[iRow - 1, iCol].Value;
          cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
          cs := trim(cs);
        end;
        // 将全角转换为半角
        cs := ToDBC(cs);
        if ts <> cs then
        begin
          ts := cs;
          if IsNumeric(cs) then
          begin
            if hs = '' then
            begin
              hs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                  iCol].Value));
            end
            else
              hs := hs + '|' + trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                  iCol].Value));
          end
          else if hs = '' then
          begin
            hs := trim(cs);
          end
          else
            hs := hs + '|' + trim(cs);
        end;
      end;
      // 处理非汉字的非x,y
      ci := 1;
      thei := length(hs);
      while ci <= thei do
      begin
        if not((Word(hs[ci]) >= $3447) and (Word(hs[ci]) <= $FA29)) then
        begin
          if (hs[ci] = 'm') or (hs[ci] = 'T') or (hs[ci] = 't') or
            (hs[ci] = 'M') or (hs[ci] = '3') then
          begin
          end
          else
            hs := Stringreplace(hs, hs[ci], ' ', [rfreplaceall]);
          ci := ci + 1;
        end
        else
       ci := ci + 1;
      end;
      hs := Stringreplace(hs, ' ', '', [rfreplaceall]);
      hs := Stringreplace(hs, 'x', '', [rfreplaceall]);
      hs := Stringreplace(hs, '管理及运行状态', '', [rfreplaceall]);
      hs := Stringreplace(hs, '注水井日生产情况单位方', '', [rfreplaceall]);
      hs := Stringreplace(hs, '水源井日上水情况单位方', '', [rfreplaceall]);
      hs := Stringreplace(hs, '管理及运行情况', '', [rfreplaceall]);
      hs := Stringreplace(hs, '基础数据', '', [rfreplaceall]);
      hs := Stringreplace(hs, '其中', '', [rfreplaceall]);
      hs := Stringreplace(hs, '注水井注水情况', '', [rfreplaceall]);
      hs := Stringreplace(hs, '项目', '', [rfreplaceall]);
      if trim(hs)<>'' then
      begin
      tblCol.Append;
      tblCol.FieldByName('xlscolidx').AsInteger := iCol;
      tblCol.FieldByName('XLSColName').AsString := hs;
      tblCol.Post;
      end;
      tblCol.Close;
      tblCol.Open;
  end;
end;

procedure TExcel.GetSheetCount;
begin
    sheetcount:=ExcelApp.Worksheets.Count;
end;

function TExcel.GetSheets(Filename: string=''): tstringlist;
var
  i:integer;
  sheets:tstringlist;
begin
 sheets:=tstringlist.Create;
 ExcelApp.WorkSheets[1].Activate;
 for  i:=1  to sheetcount-1  do
 begin
   sheets.Add(ExcelApp.ActiveSheet.name);
   nextsheet;
 end;
   sheets.Add(ExcelApp.ActiveSheet.name);
 result:=sheets;
end;

function TExcel.GetValue(RowIndex, ColIndex: integer;ProcessNull:Boolean): Variant;
var
 strAddress:Variant;
 iMcol:Integer;
begin
   if ExcelApp.ActiveSheet.cells[RowIndex, ColIndex].MergeCells = true then
  begin
    try
      //Get merge Address
      strAddress := ExcelApp.ActiveSheet.cells[RowIndex, ColIndex].MergeArea.Address;
      // splite Address
      strAddress := LeftStr(strAddress, pos(':', strAddress) - 1);
      iMcol := ExcelApp.ActiveSheet.Range[strAddress].Column;
      Result := vartostr(ExcelApp.ActiveSheet.cells[RowIndex, iMcol].Value);
    except
      Result := 'Null';
    end;
  end
  else
    try
      Result := vartostr(ExcelApp.ActiveSheet.cells[RowIndex, ColIndex].Value);
    except
      Result := 'Null';
    end;
  //get the value of cell(rowindex,colindex-1)
  if ProcessNull then
  begin
    if trim(Result)='Null' then
    begin
      // 如果前一个单元格的索引无效，那么这个单元格的值就设置为-1
      if (ColIndex - 1) <= 0 then
        Result := 'Null'
      else
        try
          Result := vartostr(ExcelApp.ActiveSheet.cells[RowIndex, ColIndex-1].Value);
        except
          Result := 'Null';
        end;
   end;
  end;
end;

function TExcel.IsEmptyCell(RowIndex,ColIndex: integer): boolean;
begin
  try
    if   Trim(vartostr(ExcelApp.ActiveSheet.cells[RowIndex, ColIndex].value))='' then
     result:=true
    else
     result:=false;
  except on E: Exception do
     result:=false;
  end;

end;

function TExcel.isopen: boolean;
begin
  if VarIsEmpty(ExcelApp) then
  begin
   result:=false;
     messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end else
  result:=true;

end;

function TExcel.MaxCol: integer;
begin
 result:=ExcelApp.ActiveSheet.UsedRange.columns.count;
end;

//not exactly
function TExcel.MaxRow: integer;
begin
 result:=ExcelApp.ActiveSheet.UsedRange.Rows.Count;
end;




function TExcel.NextSheet():Boolean;
begin
  if not isopen then exit;
  If ExcelApp.ActiveSheet.Index <> sheetcount Then
  begin
     ExcelApp.ActiveSheet.Next.Activate;
//     showall:=true;
//     ShowAllRC:=true;
     Result:=True;
    IsLastsheet:=False;
    IsFirstSheet:=false;
  end
  Else
  begin
     IsLastsheet:=True;
     Result:=True;
     exit;
  end;
  SheetName := ExcelApp.ActiveSheet.Name;

end;

function TExcel.PreviousSheet():Boolean;
begin
  if not isopen then exit;
 If ExcelApp.ActiveSheet.Index <> 1 Then
 begin
    ExcelApp.ActiveSheet.Previous.Activate;
    showall:=true;
    ShowAllRC:=true;
    Result:=true;
    IsLastsheet:=False;
    IsFirstSheet:=false;
 end
  Else
 begin
    IsFirstSheet:=true;
    Result:=False;
    exit;
 end;
  SheetName := ExcelApp.ActiveSheet.Name;
end;

procedure TExcel.SaveAs;
var
 SaveDialog1:tsavedialog;
begin
    SaveDialog1:=tsavedialog.Create(NIl);
    SaveDialog1.Filter := 'Excel1997-Excel2003格式|*.XlS';
    if savedialog1.execute then
     begin
       if extractfileExt(savedialog1.FileName)<>'.XlS' then
       SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName,'.XlS');
        ExcelApp.activeworkbook.saveas(savedialog1.FileName);
     end;
    SaveDialog1.FreeOnRelease;
end;

procedure TExcel.SetCaption(const Value: string);
begin
  FCaption := Value;
  ExcelApp.caption:=value;
end;

procedure TExcel.SetDisplayFullScreen(const Value: boolean);
begin
  FDisplayFullScreen := Value;
  ExcelApp.DisplayFullScreen:=value;
end;

procedure TExcel.SetSaveChange(const Value: boolean);
begin
  FSaveChange := Value;
  if value then
  ExcelApp.activeworkbook.save;
end;

procedure TExcel.SetSheetIndex(const Value: integer);
begin
  FSheetIndex :=ExcelApp.activesheet.index;
  ExcelApp.WorkSheets[sheetIndex].Activate;
end;




procedure TExcel.SetShowAll(const Value: boolean);
begin
  FShowAll := Value;
  if value and ExcelApp.ActiveSheet.FilterMode   then
  ExcelApp.activesheet.ShowAllData;

end;

procedure TExcel.SetShowAllRC(const Value: boolean);
var
 i:integer;
begin
  try
    ExcelApp.activesheet.columns.hidden:=not value;
    ExcelApp.activesheet.Rows.hidden:=not value;
  except on E: Exception do
    exit;
  end;
end;

procedure TExcel.Setvisible(const Value: boolean);
begin
  Fvisible := Value;
  ExcelApp.Visible := value;
end;

function Texcel.StatisticalItems(Col:integer;MultiFiles:boolean=false):tstringlist;
var
 DatumList:tstringlist;
 TempValue:variant;
 Value:string;
 iRow,ipos:integer;
begin
 DatumList:=tstringlist.Create;
 for  iRow:=1  to maxRow  do
 begin
  TempValue:= ExcelApp.ActiveSheet.cells[iRow, Col].value;
  value:=vartostr(TempValue);
  value:=StringReplace(value,' ','',[rfreplaceall]);
  DatumList.Add(value);
 end;
 DatumList.Sort;
 for iRow:=Datumlist.Count-1 downto 1 do
 begin
   if DatumList[irow]=Datumlist[irow-1] then
      DatumList.Delete(irow);
 end;
 result:=DatumList;
end;

procedure TExcel.teiLenFull(ColIndex:integer);
var
 irow:integer;
 TheValue,straddr:variant;
begin
   for iRow := 1 to maxRow do
    begin
      if ExcelApp.ActiveSheet.cells[iRow, ColIndex].MergeCells = true then
      begin
       TheValue:= ExcelApp.ActiveSheet.cells[iRow, ColIndex].value;
       strAddr := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveSheet.cells[iRow, ColIndex].Address].MergeArea.Address;
       ExcelApp.ActiveSheet.cells[iRow, ColIndex].MergeCells := false;
       ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := TheValue;
      end;
    end;
end;

function TExcel.test: string;
begin
  //  ExcelApp.SendKeys('"'+'%fx'+'"');   //
end;

end.
