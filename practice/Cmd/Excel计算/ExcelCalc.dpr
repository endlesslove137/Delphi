program ExcelCalc;

{$APPTYPE CONSOLE}

uses
  ExceptionLog,
  Windows,
  ComObj,
  SysUtils;

procedure ClearScreen;
var
  SBInfo            : TConsoleScreenBufferInfo;
  ulWrittenChars    : Cardinal;
  TopLeft           : TCoord;
  FhStdOut          : THandle;
begin
  FhStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(FhStdOut, SBInfo);
  SetConsoleTextAttribute(FhStdOut,40 or 30);
  TopLeft.X := SBInfo.srWindow.Left;
  TopLeft.Y := SBInfo.srWindow.Top;
  FillConsoleOutputCharacter(FhStdOut, ' ', (SBInfo.srWindow.Right -
    SBInfo.srWindow.Left) * (SBInfo.srWindow.Bottom - SBInfo.srWindow.Top),
    TopLeft, ulWrittenChars);
  FillConsoleOutputAttribute(FhStdOut, FOREGROUND_RED or FOREGROUND_BLUE or
    FOREGROUND_GREEN, (SBInfo.srWindow.Right - SBInfo.srWindow.Left) *
    (SBInfo.srWindow.Bottom - SBInfo.srWindow.Top), TopLeft, ulWrittenChars);
end;

procedure SetCursorTo(x, y: integer);
var
  Coords            : TCoord;
  SBInfo            : TConsoleScreenBufferInfo;
  FhStdOut          : THandle;
begin
  FhStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(FhStdOut, SBInfo);
  if x < 0 then
    Exit;
  if y < 0 then
    Exit;
  if x > SbInfo.dwSize.X then
    Exit;
  if y > SbInfo.dwSize.Y then
    Exit;

  Coords.X := x;
  Coords.Y := y;
  SetConsoleCursorPosition(FhStdOut, Coords);
end;


procedure CalcExcel;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol :integer;
  I: Integer;
  id, name, ItemDup, ItemDesc :string;
begin
  SD1.Filter := 'Excel2007格式文件|*.xlsx|Excel2003格式文件|*.xls';
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    workbook := ExcelApp.WorkBooks.Add;
    Sheet := ExcelApp.Sheets[1];
    Sheet.cells[1,1].value := 'ID';
    Sheet.cells[1,2].value := 'Text';

    rpb1.TotalParts := LangList.Count;

    for I := 0 to LangList.Count-1 do
    begin
      Sheet.cells[2 + I,1].value := LangList.Names[i];
      Sheet.cells[2 + I,2].value := LangList.ValueFromIndex[i];
      rpb1.IncPartsByOne;
      application.ProcessMessages;
      caption := format(StrInfor, [i + 1, rpb1.TotalParts]);
    end;
      ExcelApp.ActiveSheet.Columns[1].Columnwidth  := 20;
      ExcelApp.ActiveSheet.Columns[2].Columnwidth  := 20;
  finally
    if SD1.Execute then
      begin
        ExcelApp.ActiveWorkbook.saveas(SD1.FileName);
      end
    else
      ExcelApp.ActiveWorkBook.Saved := True;
    Sheet := unassigned;
    workbook.Close;
    ExcelApp.quit;
    ExcelApp := unassigned;
    showmessage(MsgSucce)
  end;
end;


procedure ShowTitle;
begin
  ClearScreen;
  SetCursorTo(0, 0);
  writeln('=======================================');
  writeln('==       变形金钢 之 实验数据统计    ==');
  writeln('==       by 809779839@qq.com         ==');
  writeln('=======================================');
end;

begin
 ShowTitle;
 writnln()
 SetCursorTo(0, 5);
 Readln;
end.
