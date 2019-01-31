unit SelectSockReg;

interface

uses
  Classes, SelectSocket, SockBind;
  
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents( 'SelectSockManager', [TSocketBind, TSocketManager] );
end;

end.
