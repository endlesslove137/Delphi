unit UnitNORepeat;
//工程引用此单元就能防止同时出现多个实例unit MultInst;

interface

uses
 Windows ,Messages, SysUtils, Classes, Forms;

implementation

const
 STR_UNIQUE    = '{2BE6D96E-827F-4BF9-B33E-8740412CDE96}';
 MI_ACTIVEAPP  = 1;  {激活应用程序}
 MI_GETHANDLE  = 2;  {取得句柄}

var
 iMessageID    : Integer;
 OldWProc      : TFNWndProc;
 MutHandle     : THandle;
 BSMRecipients : DWORD;

function NewWndProc(Handle: HWND; Msg: Integer; wParam, lParam: Longint):
 Longint; stdcall;
var
 FormHandle :THandle;
begin
 Result := 0;
 if Msg = iMessageID then
 begin
   case wParam of
     MI_ACTIVEAPP: {激活应用程序}
       if lParam<>0 then
       begin
         {收到消息的激活前一个实例}
         {为什么要在另一个程序中激活?}
         {因为在同一个进程中SetForegroundWindow并不能把窗体提到最前}
         //判断是否最小化
         if IsIconic(lParam) then
         begin
           OpenIcon(lParam);
           SendMessage(lParam,WM_SYSCOMMAND,SC_MAXIMIZE ,SC_SCREENSAVE)
         end
         //如果程序隐藏了 处理
         else if not IsWindowVisible(lParam) then
         begin
            FormHandle := GetWindow(lParam, GW_Child);
            ShowWindow(lParam, SW_SHOW);
            ShowWindow(FormHandle, SW_SHOW);
         end
         else
           SetForegroundWindow(lParam);
           Application.Terminate; {终止本实例}
       end;
     MI_GETHANDLE: {取得程序句柄}
       begin
         PostMessage(HWND(lParam), iMessageID, MI_ACTIVEAPP,
           Application.Handle);
       end;
   end;
 end
 else
   Result := CallWindowProc(OldWProc, Handle, Msg, wParam, lParam);
end;

procedure InitInstance;
begin
 {取代应用程序的消息处理}
 OldWProc    := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
   Longint(@NewWndProc)));

 {打开互斥对象}
 MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, STR_UNIQUE);
 if MutHandle = 0 then
 begin
   {建立互斥对象}
   MutHandle := CreateMutex(nil, False, STR_UNIQUE);
 end
 else begin
   Application.ShowMainForm  :=  False;
   {已经有程序实例,广播消息取得实例句柄}
   BSMRecipients := BSM_APPLICATIONS;
   BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
       @BSMRecipients, iMessageID, MI_GETHANDLE,Application.Handle);
 end;
end;

initialization
 {注册消息}
 iMessageID  := RegisterWindowMessage(STR_UNIQUE);
 InitInstance;

finalization
 {还原消息处理过程}
 if OldWProc <> Nil then
   SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(OldWProc));

 {关闭互斥对象}
 if MutHandle <> 0 then CloseHandle(MutHandle);

end.


