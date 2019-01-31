unit UnitIWfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvToolButton,
  IWControl, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompEdit, IWTMSImgCtrls, IWCompButton,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls;

type
  TIWfrmMain = class(TIWFormBasic)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

implementation

uses ServerController;

function IsDebuggerPresent():LongBool;stdcall;external Kernel32;

{$R *.dfm}

procedure TIWfrmMain.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if IsDebuggerPresent() then
  begin
    ReportMemoryLeaksOnShutdown := True;
  end;
end;

initialization
  RegisterClass(TIWfrmMain);
  
end.
