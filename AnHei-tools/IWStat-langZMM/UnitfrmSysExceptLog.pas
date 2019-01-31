unit UnitfrmSysExceptLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompButton, IWTMSCal, IWTMSImgCtrls,
  IWControl, IWAdvToolButton, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompLabel, IWVCLBaseContainer, IWContainer,
  IWHTMLContainer, IWHTML40Container, IWRegion, IWCompMemo, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = '系统异常日志';

type
  TIWfrmSysExceptLog = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWMemo1: TIWMemo;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  IWfrmSysExceptLog: TIWfrmSysExceptLog;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmSysExceptLog }

procedure TIWfrmSysExceptLog.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmSysExceptLog.IWBtnBuildClick(Sender: TObject);
var
  ErrorLogFile: string;
begin
  inherited;
  ErrorLogFile := AppPathEx+'\Error\'+FormatDateTime('YYYYMMDD',pSDate.Date)+'.txt';
  if FileExists(ErrorLogFile) then
  begin
    IWMemo1.Lines.LoadFromFile(ErrorLogFile);
  end;
end;

initialization
  RegisterClass(TIWfrmSysExceptLog);

end.
