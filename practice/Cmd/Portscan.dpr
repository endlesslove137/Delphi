program Portscan;
{$APPTYPE CONSOLE}

uses
  winsock,
  sysutils,
  windows;

function isNumeric(s: Variant): boolean;
begin
  result := TRUE;
  try
    strToFloat(s);
  except
    result := FALSE;
  end;
end;

procedure ClearScreen;
var
  SBInfo            : TConsoleScreenBufferInfo;
  ulWrittenChars    : Cardinal;
  TopLeft           : TCoord;
  FhStdOut          : THandle;
begin
  FhStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(FhStdOut, SBInfo);
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

procedure ShowTitle;
begin
  ClearScreen;
  SetCursorTo(0, 0);
  writeln('=======================================');
  writeln('==       Very Slow Port Scanner      ==');
  writeln('==       by chinasf@hotmail.com      ==');
  writeln('=======================================');
end;

var
  host              : string;
  startport, stopport: string;
  s                 : tsocket;
  l, i, n, m, error : integer;
  server            : tsockaddrin;  wsa               : twsadata;
label
  inputStartPort;
label
  inputEndPort;
begin
  ShowTitle;
  write('== 请输入目标主机IP:');
  readln(host);
  inputStartPort:
  write('== 请输入起始扫描端口号(1~65535):');
  readln(startport);
  if not isNumeric(startPort) then
    goto inputStartPort;
  if strToInt(startPort) > 65535 then
    goto inputStartPort;

  inputEndPort:
  write('== 请输入扫描终止端口号(1~65535):');
  readln(stopport);
  if not isNumeric(stopport) then
    goto inputEndPort;
  if strToInt(stopport) > 65535 then
    goto inputEndPort;
  if strToInt(stopport) < strToInt(startport) then
  begin
    writeln('终止端口号必须大于起始端口号！');
    goto inputStartPort;
  end;
  ShowTitle;
  wsastartup(makeword(1, 1), wsa);
  server.sin_family := AF_INET;
  server.sin_addr.S_addr := inet_addr(PAnsiChar(host));
  L := 5;
  n := abs(strToInt(startPort));
  m := abs(strToInt(stopport));
  for i := n to m do
  begin
    SetCursorTo(0, 4);
    writeln('                                       ');
    SetCursorTo(0, 4);
    writeln('Port #' + inttostr(I) + '');

    s := socket(AF_INET, SOCK_STREAM, 0);
    server.sin_port := htons(i);
    error := connect(s, server, sizeof(server));
    if error = 0 then
    begin
      SetCursorTo(0, l);
      SetCursorTo(0, l);
      write('Port #' + inttostr(I) + ' [OK]');
      inc(l, 1);
      closesocket(s);
    end;
  end;
  SetCursorTo(0, L);
  writeln('=======================================');
  writeln('==Thank you for your test! Good luck!==');
  writeln('==        last update:2004.8.7       ==');
  writeln('=======================================');
  wsacleanup();
  readln;
end.

