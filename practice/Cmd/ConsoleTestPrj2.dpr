program ConsoleTestPrj2;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  uConsoleClass in 'uConsoleClass.pas';

var
  MyConsole         : TConsoleControl;

procedure Stars;
var
  x, y, w, h        : Integer;
  x1, y1            : Integer;
  CharInfo          : Char;
  i                 : integer;
begin
  MyConsole.ClearScreen;
  x := MyConsole.GetScreenLeft;
  y := MyConsole.GetScreenTop;
  h := MyConsole.GetScreenHeight div 4;
  w := MyConsole.GetScreenWidth div 4;
  for i := 1 to 15000 do
  begin
    x1 := x + Random(w) * 4;
    y1 := y + Random(h) * 4;
    MyConsole.SetCursorTo(x1, y1);
    MyConsole.GetCharAtPos(x1, y1, CharInfo);

    MyConsole.SetForegroundColor(Bool(Random(2)), Bool(Random(2)),
      Bool(Random(2)), Bool(Random(2)));
    if (CharInfo = ' ') or (CharInfo = #0) then
    begin
      MyConsole.WriteText('.');
    end
    else if CharInfo = '.' then
    begin
      MyConsole.WriteText('+');
    end
    else if CharInfo = '+' then
    begin
      MyConsole.WriteText('*');
    end
    else if CharInfo = '*' then
    begin
      MyConsole.WriteText(' ');
    end;
    sleep(5);
  end;
end;

begin
  MyConsole := TConsoleControl.Create;
  Stars;
  MyConsole.Free;
end.

