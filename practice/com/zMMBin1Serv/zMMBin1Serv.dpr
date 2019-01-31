library zMMBin1Serv;

uses
  ExceptionLog,
  ComServ,
  zMMNextFit in 'zMMNextFit.pas' {zMMNextFit: CoClass},
  BinIntf in 'BinIntf.pas',
  zMMFirstFit in 'zMMFirstFit.pas' {zmmFirstFit: CoClass},
  zMMBestFit in 'zMMBestFit.pas' {zMMBestFit: CoClass},
  BinBase in 'BinBase.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.RES}

begin
end.
