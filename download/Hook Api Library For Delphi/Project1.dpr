{
  Ring3 Hook api Demo By Anskya
  Email: Anskya@Gmail.com
}
program Project1;

uses
  Windows, HookApiLib in 'HookApiLib.pas';

Type
  TMessageBoxA = function(hWnd: HWND; lpText, lpCaption: PAnsiChar; uType: UINT): Integer; stdcall;
  
var
  MessageBoxANextHook: TMessageBoxA; 

function MessageBoxAHookProc(hWnd: HWND; lpText, lpCaption: PAnsiChar; uType: UINT): Integer; stdcall;
begin
  Result := MessageBoxANextHook(0, lpText, 'Hookd: Anskya', 0);
end;

begin
  MessageBox(0, 'MessageBoxA[≤‚ ‘]!', '!', 0);

  //  π“π≥
  @MessageBoxANextHook := HookCode(GetProcAddress(LoadLibrary('user32.dll'), 'MessageBoxA'), @MessageBoxAHookProc);

  MessageBox(0, 'MessageBoxA[≤‚ ‘]!', '!', 0);

  //  Õ—π≥
  UnHookCode(@MessageBoxANextHook);

  MessageBox(0, 'MessageBoxA[≤‚ ‘]!', '!', 0);
end.
