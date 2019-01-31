unit UnitfrmTaskLoss;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWWebGrid,
  IWAdvWebGrid, IWTMSCal;

type
  TIWfrmTaskLoss = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    IWCbTaskType: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    procedure LoadComboBoxList;
  public
    procedure QueryTaskLoss(MinDateTime: TDateTime;ServerIndex: Integer);
  end;

var
  IWfrmTaskLoss: TIWfrmTaskLoss;

const
  TaskTypeStr: array[0..13] of Integer = (280,281,282,343,284,285,286,287,288,289,290,339,292,293);

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmTaskLoss.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbTaskLoss]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbTaskLoss]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbTaskLoss])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  LoadComboBoxList;

  IWLabel1.Caption := Langtostr(188);
  IWLabel2.Caption := Langtostr(294);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton1.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[0].Title:= Langtostr(295);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(296);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(294);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(297);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(298);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(299);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(265);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(266);
end;

procedure TIWfrmTaskLoss.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryTaskLoss(pSDate.Date,ServerListData.Index);
    finally
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmTaskLoss.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'TaskLoss'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmTaskLoss.LoadComboBoxList;
var
  I: Integer;
begin
  IWCbTaskType.Items.Add(Langtostr(276));
  for I := Low(TaskTypeStr) to High(TaskTypeStr) do
  begin
    IWCbTaskType.Items.Add(Langtostr(TaskTypeStr[I]));
  end;
  IWCbTaskType.ItemIndex := 0;
end;

procedure TIWfrmTaskLoss.QueryTaskLoss(MinDateTime: TDateTime;
  ServerIndex: Integer);
const
  RoleCountTip = 278;//'&nbsp;&nbsp;总角色数：%d，总任务数：%d &nbsp;';
  sqlLoss = 'SELECT TaskID,iCount FROM (SELECT idtask & 0xFFFF AS TaskID,COUNT(DISTINCT b.actorid) AS iCount FROM actors a,goingquest b '+
            'WHERE a.actorid=b.actorid AND updatetime<"%s" GROUP BY idtask & 0xFFFF UNION ALL '+
            'SELECT idtime & 0xFFFF AS TaskID,COUNT(DISTINCT b.actorid) AS iCount FROM actors a,repeatquest b '+
            'WHERE a.actorid=b.actorid AND updatetime<"%s" GROUP BY idtime & 0xFFFF) tmp ORDER BY iCount DESC';
  sqlTotalRoleCount = 'SELECT COUNT(1) AS TotalCount FROM actors';
var
  pTask: PTTask;
  iCount,iTotalRoleCount,iRoleCount: Integer;
begin
  iTotalRoleCount := GetRecordCount(sqlTotalRoleCount,UserSession.quLoss);
  with UserSession.quLoss, TIWAdvWebGrid1 do
  begin
    iCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlLoss,[DateToStr(MinDateTime),DateToStr(MinDateTime)]);
    Open;
    while not Eof do
    begin
      pTask := OnGetTaskName(FieldByName('TaskID').AsInteger);
      TotalRows := RowCount+iCount;
      cells[0,iCount] := IntToStr(FieldByName('TaskID').AsInteger);
      if pTask = nil then
      begin
        cells[1,iCount] := Langtostr(279);//'未知任务';
      end
      else begin
        if IWCbTaskType.ItemIndex <> 0 then
        begin
          if IWCbTaskType.Items.Strings[IWCbTaskType.ItemIndex] <> Langtostr(TaskTypeStr[pTask^.bType]) then
          begin
            Next;
            continue;
          end;
        end;
        cells[1,iCount] := string(pTask^.sTaskName);
        cells[2,iCount] := Langtostr(TaskTypeStr[pTask^.bType]);
        cells[3,iCount] := IntToStr(pTask^.bAcceptLevel);
        cells[4,iCount] := IntToStr(pTask^.bMaxLevel);
      end;
      iRoleCount := FieldByName('iCount').AsInteger;
      cells[5,iCount] := IntToStr(iRoleCount);
      cells[6,iCount] := IntToStr(iTotalRoleCount-iRoleCount);
      cells[7,iCount] := Format('%.2f%%',[iRoleCount/iTotalRoleCount*100]);
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;    
    Controller.Caption := Format(Langtostr(RoleCountTip),[iTotalRoleCount,TaskList.Count]);
  end;
end;

initialization
  RegisterClass(TIWfrmTaskLoss);
  
end.
