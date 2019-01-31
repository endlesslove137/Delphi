unit UnitfrmShop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWCompLabel,DateUtils,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWAdvToolButton, IWCompEdit, IWTMSCheckList, IWTMSCal,
  IWCompButton, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, AdvChart, AdvChartViewGDIP,
  IWCompListbox, MSXML, IWCompRectangle, IWTMSCtrls, IWExchangeBar, IWExtCtrls;

const
  curTitle = '商城统计';
  ChartLeTitleSpace = ' - ';
  ShopChartColor : array [0..16] of Integer = (clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray, clDkGray, clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray, clSilver);
  TIWCheckListBox = 'TIWCheckListBox%d';

type
  TIWfrmShop = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWButton1: TIWButton;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWRegion3: TIWRegion;
    IWRegion5: TIWRegion;
    IWRegion6: TIWRegion;
    IWComboBox1: TIWComboBox;
    IWRegion7: TIWRegion;
    IWListboxSelect: TIWListbox;
    IWButton2: TIWButton;
    IWRegion8: TIWRegion;
    IWRadioGroup1: TIWRadioGroup;
    IWButton3: TIWButton;
    IWRegion9: TIWRegion;
    TIWAdvChart2: TTIWAdvChart;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart3: TTIWAdvChart;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWComboBox1Change(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWListboxSelectChange(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWRadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    xmlDoc : IXMLDOMDocument;
    Element: IXMLDOMElement;
    procedure LoadShopData;
    procedure HideCheckListBox;
    procedure ClearSelectList;
  public
    procedure QueryShop(ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
    function StringCharList(AChar: Char;strList: TStringList): string;
    procedure InitShopListObject(strList: TStringList);
    procedure SelectAsyncCheckClick(Sender: TObject;EventParams: TStringList; Index: Integer; Check: LongBool);
  end;

var
  IWfrmShop: TIWfrmShop;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmShop.QueryShop(ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
const
  sqlShop = 'SELECT consumedescr,SUM(paymentcount*-1) AS paymentcount FROM %s WHERE logid=115 AND %s consumedescr in (%s) GROUP BY consumedescr ORDER BY SUM(paymentcount*-1) DESC';
  tTableName = 'log_consume_%s';
  tServerID = 'serverindex=%d AND ';
var
  ShopColor: Integer;
  I,Idx,iCount: Integer;
  XValue: Double;
  sServerIndex,sTableName: string;
  LChartSerie: TAdvGDIPChartSerie;
  tmpSelList: TStringList;
begin
  TIWAdvChart1.Chart.Series.Clear;  Idx := 0;
  for I := 0 to IWListboxSelect.Items.Count -1 do
  begin
    LChartSerie := TIWAdvChart1.Chart.Series.Add;
    LChartSerie.ChartType := ctLine;
    LChartSerie.LineWidth := 2;
    if Idx <= High(ShopChartColor) then
    begin
      ShopColor := ShopChartColor[Idx];
    end
    else begin
      Randomize;
      ShopColor := RGB(Random(255),Random(255),Random(255));
    end;
    LChartSerie.LineColor := ShopColor;
    LChartSerie.Marker.MarkerType := mCircle;
    LChartSerie.Marker.MarkerSize := 6;
    LChartSerie.LegendText := IWListboxSelect.Items.Strings[I];
    LChartSerie.SelectedMark := False;
    LChartSerie.SelectedMarkSize := 0;
    LChartSerie.ShowValue := False;
    LChartSerie.Autorange := arCommon;
    LChartSerie.ValueFormat := objINI.RMBFormat;
    Inc(Idx);
    IWListboxSelect.Items.Delimiter := ',';
    Element.text := IWListboxSelect.Items.DelimitedText;
    xmlDoc.save(AppPathEx+UserPopFile);
  end;
  if IWListboxSelect.Items.Count > 0 then
  begin
    if MaxDateTime > Now then MaxDateTime := Now;
    iCount := 0; IWListboxSelect.ItemIndex := 0;
    sServerIndex := Format(tServerID,[ServerIndex]);
    if ServerIndex = 0 then sServerIndex := '';
    with UserSession.quShop,TIWAdvChart1.Chart do
    begin
      tmpSelList := TStringList.Create;
      tmpSelList.Assign(IWListboxSelect.Items);
      InitShopListObject(tmpSelList);
      try
        while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
        begin
          sTableName := Format(tTableName,[FormatDateTime('YYYYMMDD',MinDateTime)]);
  //        if UserSession.IsCheckTable('globallog',sTableName) then
  //        begin
            SQL.Text := Format(sqlShop,[sTableName,sServerIndex,StringCharList(',',IWListboxSelect.Items)]);
            Open;
            InitShopListObject(IWListboxSelect.Items);
            while not Eof do
            begin
              Idx := IWListboxSelect.Items.IndexOf(Utf8ToString(FieldByName('consumedescr').AsAnsiString));
              if Idx > -1 then
              begin
                IWListboxSelect.Items.Objects[Idx] := TObject(FieldByName('paymentcount').AsInteger);
                tmpSelList.Objects[Idx] := TObject(Integer(tmpSelList.Objects[Idx]) + FieldByName('paymentcount').AsInteger);
              end;
              Next;
            end;
            Close;
            for I := 0 to IWListboxSelect.Items.Count - 1 do
            begin
              XValue := DivZero(Integer(IWListboxSelect.Items.Objects[I]),10) * dRate;
              Series[I].AddSinglePoint(ChangeZero(XValue),FormatDateTime('MM-DD',MinDateTime));
            end;

            Inc(iCount);
  //        end;
          MinDateTime := IncDay(MinDateTime,1);
        end;
        for I := 0 to tmpSelList.Count - 1 do
        begin
          Series[I].LegendText := Format('%s'+ChartLeTitleSpace+'%.1f',[tmpSelList.Strings[I],DivZero(Integer(tmpSelList.Objects[I]),10) * dRate]);
        end;
        TIWAdvChart2.Chart.Series[0].ClearPoints;
        TIWAdvChart3.Chart.Series[0].ClearPoints;
        for I := 0 to tmpSelList.Count - 1 do
        begin
          XValue := DivZero(Integer(tmpSelList.Objects[I]),10) * dRate;
          if I <= High(ShopChartColor) then
          begin
            ShopColor := ShopChartColor[I];
          end
          else begin
            Randomize;
            ShopColor := RGB(Random(255),Random(255),Random(255));
          end;
          TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(XValue),ShopColor,tmpSelList[I]+' '+ FloatToStr(XValue));
          TIWAdvChart3.Chart.Series[0].AddSinglePoint(ChangeZero(XValue),tmpSelList[I]);
        end;
        if tmpSelList.Count > 20 then
        begin
          TIWAdvChart1.Height := 18*tmpSelList.Count;
          TIWAdvChart2.Height := 20*tmpSelList.Count;
        end;
        TIWAdvChart3.Height := 80+tmpSelList.Count * objINI.AutoHeigth;
        for I := 1 to IWListboxSelect.Items.Count - 1 do
        begin
          Series[I].XAxis.Visible := False;
          Series[I].YAxis.Visible := False;
        end;
        TIWAdvChart3.Chart.Range.RangeFrom := 0;
        TIWAdvChart3.Chart.Range.RangeTo := tmpSelList.Count-1;
        TIWAdvChart3.Chart.Series[0].Autorange := arEnabledZeroBased;
        Range.RangeFrom := 0;
        Range.RangeTo := iCount-1;
        if iCount * objINI.AutoWidth + 195 < objINI.DefaultWidth then
          TIWAdvChart1.Width := objINI.DefaultWidth + 195
        else
          TIWAdvChart1.Width := iCount * objINI.AutoWidth + 195;
        Series[0].ShowValue := True;
        Legend.Left := TIWAdvChart1.Width-240;
        Legend.Top := 0;
        TIWAdvChart1.Visible := IWRadioGroup1.ItemIndex = 0;
        TIWAdvChart2.Visible := IWRadioGroup1.ItemIndex = 1;
        TIWAdvChart3.Visible := IWRadioGroup1.ItemIndex = 2;
      finally
        tmpSelList.Free;
      end;
    end;
  end;
end;

procedure TIWfrmShop.SelectAsyncCheckClick(Sender: TObject;
  EventParams: TStringList; Index: Integer; Check: LongBool);
var
  I,Idx: Integer;
  curCheckListBox: TTIWCheckListBox;
begin
  curCheckListBox := (Sender as TTIWCheckListBox);
  if Index = -1 then
  begin
    for I := 0 to curCheckListBox.Items.Count - 1 do
    begin
      Idx := IWListboxSelect.Items.IndexOf(curCheckListBox.Items.Strings[I]);
      if (Idx > -1) and (not Check) then
      begin
        IWListboxSelect.Items.Delete(Idx);
      end;
      if (Idx = -1) and (Check) then
      begin
        IWListboxSelect.Items.Add(curCheckListBox.Items.Strings[I]);
      end;
    end;
    Exit;
  end;
  if curCheckListBox.Selected[Index] then
  begin
    IWListboxSelect.Items.Add(curCheckListBox.Items.Strings[Index]);
  end
  else
  begin
    Idx := IWListboxSelect.Items.IndexOf(curCheckListBox.Items.Strings[Index]);
    if Idx > -1 then
    begin
      IWListboxSelect.Items.Delete(Idx);
    end;
  end;
end;

function TIWfrmShop.StringCharList(AChar: Char; strList: TStringList): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to strList.Count - 1 do
  begin
    Result := Result + QuerySQLStr(strList.Strings[I])+ AChar;
  end;
  if strList.Count > 0 then
    Delete(Result,Length(Result),1);
end;

procedure TIWfrmShop.ClearSelectList;
var
  I,J: Integer;
  CheckListBox: TTIWCheckListBox;
begin
  for I := 1 to IWComboBox1.Items.Count do
  begin
    CheckListBox := FindComponent(Format(TIWCheckListBox,[I])) as TTIWCheckListBox;
    for J := 0 to CheckListBox.Items.Count - 1 do
    begin
      CheckListBox.Selected[J] := False;
    end;
  end;
  IWListboxSelect.Items.Clear;
end;

procedure TIWfrmShop.HideCheckListBox;
var
  I: Integer;
begin
  for I := 1 to IWComboBox1.Items.Count do
  begin
    (FindComponent(Format(TIWCheckListBox,[I])) as TTIWCheckListBox).Hide;
  end;
end;

procedure TIWfrmShop.InitShopListObject(strList: TStringList);
var
  I: Integer;
begin
  for I := 0 to strList.Count - 1 do
  begin
    strList.Objects[I] := TObject(0);
  end;
end;

procedure TIWfrmShop.IWAppFormCreate(Sender: TObject);
var
  xmlNode: IXMLDomNode;
begin
  inherited;
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  try
    pSDate.Date := IncDay(Now,-6);
    pEDate.Date := Now();
    xmlDoc := CoDOMDocument.Create();
    if xmlDoc.load(AppPathEx+UserPopFile) then
    begin
      xmlNode := xmlDoc.documentElement.selectSingleNode(Format('//User[@Name="%s"]',[UserSession.UserName]));
      Element := xmlNode.selectSingleNode('ShopSelectList') as IXMLDOMElement;
      if Element = nil  then
      begin
        Element := xmlDoc.createElement('ShopSelectList');
        xmlNode.appendChild(Element);
        xmlDoc.save(AppPathEx+UserPopFile);
      end
      else
      begin
        IWListboxSelect.Items.Delimiter := ',';
        IWListboxSelect.Items.DelimitedText := Element.text;
        if IWListboxSelect.Items.Count > 0 then IWListboxSelect.ItemIndex := 0;
      end;
    end;
    LoadShopData;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmShop.IWAppFormDestroy(Sender: TObject);
begin
  xmlDoc := nil;
  inherited;
end;

procedure TIWfrmShop.IWButton1Click(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage('起始日期应大于或等于结束日期，请重新选择');
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 10 then
  begin
    WebApplication.ShowMessage('查询很耗时，请将查询范围限制在10天以内');
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if psld.Index <> 0 then
    begin
      if psld.OpenTime = '' then
      begin
        Exit;
      end;
      if pSDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pSDate.Date := StrToDateTime(psld.OpenTime);
      end;
      if pEDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pEDate.Date := StrToDateTime(psld.OpenTime);
      end;
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryShop(psld.Index,psld.CurrencyRate,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmShop.IWButton2Click(Sender: TObject);
begin
  ClearSelectList;
end;

procedure TIWfrmShop.IWButton3Click(Sender: TObject);
begin
  ClearSelectList;
end;

procedure TIWfrmShop.IWComboBox1Change(Sender: TObject);
begin
  HideCheckListBox;
  (FindComponent(Format(TIWCheckListBox,[IWComboBox1.ItemIndex+1])) as TTIWCheckListBox).Show;
end;

procedure TIWfrmShop.IWListboxSelectChange(Sender: TObject);
var
  I,iPos: Integer;
begin
  if IWListboxSelect.ItemIndex = -1 then Exit;
  for I := 0 to TIWAdvChart1.Chart.Series.Count - 1 do
  begin
    TIWAdvChart1.Chart.Series[I].ShowValue := False;
    iPos := Pos(ChartLeTitleSpace,TIWAdvChart1.Chart.Series[I].LegendText);
    if Copy(TIWAdvChart1.Chart.Series[I].LegendText,1,iPos-1) = IWListboxSelect.Items.Strings[IWListboxSelect.ItemIndex] then
    begin
      TIWAdvChart1.Chart.Series[I].ShowValue := True;
    end;
  end;
end;

procedure TIWfrmShop.IWRadioGroup1Click(Sender: TObject);
begin
  inherited;
  TIWAdvChart1.Visible := IWRadioGroup1.ItemIndex = 0;
  TIWAdvChart2.Visible := IWRadioGroup1.ItemIndex = 1;
  TIWAdvChart3.Visible := IWRadioGroup1.ItemIndex = 2;
end;

procedure TIWfrmShop.LoadShopData;
var
  I,J: Integer;
  tmpList: TStringList;
  CheckListBox: TTIWCheckListBox;
begin
  for I := 0 to ShopList.Count - 1 do
  begin
    IWComboBox1.Items.Add(ShopList.Strings[I]);
    CheckListBox := TTIWCheckListBox.Create(self);
    CheckListBox.Name := Format(TIWCheckListBox,[I+1]);
    CheckListBox.Parent := IWRegion6;
    CheckListBox.CheckAllHelp := htLabel;
    CheckListBox.CheckAllBox := True;
    CheckListBox.CheckAllText := '全选';
    CheckListBox.UnCheckAllText := '全不选';
    CheckListBox.Align := alClient;
    CheckListBox.OnAsyncCheckClick := SelectAsyncCheckClick;
    tmpList := TStringList(ShopList.Objects[I]);
    for J := 0 to tmpList.Count - 1 do
    begin
      CheckListBox.Items.Add(tmpList.Strings[J]);
      if IWListboxSelect.Items.IndexOf(tmpList.Strings[J]) > -1 then
      begin
        CheckListBox.Selected[CheckListBox.Items.Count-1] := True;
      end;
    end;
  end;
  IWComboBox1.ItemIndex := 0;
  HideCheckListBox;
  (FindComponent(Format(TIWCheckListBox,[1])) as TTIWCheckListBox).Show;
end;

initialization
  RegisterClass(TIWfrmShop);

end.
