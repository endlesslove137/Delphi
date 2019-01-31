unit UnitfrmOnlineAndPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSCal, DateUtils, AdvChart, IWCompCheckbox;

type
  TIWfrmOnlineAndPay = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    IWLabel4: TIWLabel;
    IWButton6: TIWButton;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryOnlineAndPay(dMinDateTime,dMaxDateTime: TDateTime);
    procedure QueryAlldata(dMinDateTime, dMaxDateTime: TDateTime);
  end;

var
  IWfrmOnlineAndPay: TIWfrmOnlineAndPay;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

procedure TIWfrmOnlineAndPay.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-DayOf(Now())+1);
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(StatToolButtonStr[tbOnlineAndPay]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbOnlineAndPay]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbOnlineAndPay])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;
  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmOnlineAndPay.IWBtnBuildClick(Sender: TObject);
begin
  inherited;
  try
    try
      QueryOnlineAndPay(pSDate.Date,pEDate.Date);
    finally
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmOnlineAndPay.IWButton6Click(Sender: TObject);
begin
  inherited;
  try
      try
        QueryAlldata(pSDate.Date,pEDate.Date);
      finally
      end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmOnlineAndPay.QueryOnlineAndPay(dMinDateTime,
  dMaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayTotalMoney = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59" GROUP BY date(orderdate)';
  sqlPayTotalMoney2 = 'SELECT date(orderdate),SUM(rmb) AS TotalMoney FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59" GROUP BY date(orderdate)';
  sqlPayTotalUser = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  sqlPayTotalUser2 = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder_%s WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  sTipText = 180;//'  自 %s 到 %s 的总计充值金额为：%s，总计充值用户数为：%d ，ARPU值为：%.1f';
var
  dValue: Double;
  sqlMaxTime: TDateTime;
  I,iValue,TotalMoney,TotalUser: Integer;
  psld, pslsd: PTServerListData;
  OnlineList,PayList: TStringList;
  samdb, saccont: string;
  procedure SumList(strList: TStringList;sDate: string;iValue: Integer);
  var
    Idx: Integer;
  begin
    Idx := strList.IndexOf(sDate);
    if Idx = -1 then
    begin
      strList.AddObject(sDate,TObject(iValue));
    end
    else begin
      strList.Objects[Idx] := TObject(Integer(strList.Objects[Idx])+iValue);
    end;
  end;
begin
  OnlineList := TStringList.Create;
  PayList := TStringList.Create;
  try
    TotalMoney := 0; TotalUser := 0; samdb := ''; saccont := '';
    for I := 0 to ServerList.Count - 1 do
    begin
      psld := PTServerListData(ServerList.Objects[I]);
      pslsd:= GetServerListData(IWcBoxZJHTServers.Items.Strings[IWcBoxZJHTServers.ItemIndex]); //平台判断
      if (psld^.Index = 0) and (psld^.spID = pslsd.spID) then
      begin
        UserSession.ConnectionLogMysql(psld^.LogDB,psld^.LogHostName);
        UserSession.ConnectionSessionMysql(psld^.AccountDB,psld^.SessionHostName);
        with UserSession.quOnlineCount do
        begin

          sqlMaxTime := dMinDateTime;
          while sqlMaxTime<=dMaxDateTime do
          begin
            if UserSession.IsCheckOnlineTable(psld^.LogDB,Format('log_onlinecount_%s',[FormatDateTime('yyyymmdd',sqlMaxTime)])) then
            begin
              SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',sqlMaxTime)]);
              Open;

              SumList(OnlineList,DateToStr(sqlMaxTime),Fields[0].AsInteger);
              Close;
            end;
            sqlMaxTime := sqlMaxTime + 1;
          end;
        end;

        with UserSession.quPay do
        begin
          if IWAmdbMode.Checked then
            SQL.Text := Format(sqlPayTotalMoney2,[psld^.Amdb,FormatDateTime('YYYYMM',dMinDateTime),psld^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
          else
            SQL.Text := Format(sqlPayTotalMoney,[psld^.Amdb,psld^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);

          Open;

          while not Eof do
          begin
        //    iValue := Trunc(Fields[1].AsFloat*psld^.CurrencyRate*10);
            iValue := ROUND(DivZero(Fields[1].AsInteger,psld.CurrencyRate) * 10);
            Inc(TotalMoney,iValue);

            SumList(PayList,Fields[0].AsString,iValue);
            Next;
          end;
          Close;
        end;
        with UserSession.quPay do
        begin
          SQL.Text := Format(sqlPayTotalUser,[psld^.Amdb,psld^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
          Open;
          TotalUser := TotalUser + Fields[0].AsInteger;
          Close;
        end;
        //新增加
        if pslsd^.SessionHostName2 <> '127.0.0.1' then
        begin
          if pslsd^.AccountDB2 = 'cq_account' then saccont := pslsd^.AccountDB
          else  saccont := pslsd^.AccountDB2;

          if pslsd^.Amdb2 = 'amdb' then samdb := pslsd^.Amdb
          else  samdb := pslsd^.Amdb2;

          if UserSession.IsCheckConnectionSessionMysql(saccont,pslsd^.SessionHostName2) then
          begin
            UserSession.ConnectionSessionMysql(saccont,pslsd^.SessionHostName2);
            with UserSession.quPay do
            begin
              if IWAmdbMode.Checked then
                SQL.Text := Format(sqlPayTotalMoney2,[samdb,FormatDateTime('YYYYMM',dMinDateTime),pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
              else
                SQL.Text := Format(sqlPayTotalMoney,[samdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);

              Open;
              //TotalCount := 0;
              while not Eof do
              begin
               // iValue := Trunc(Fields[1].AsFloat*pslsd^.CurrencyRate*10);
                iValue := ROUND(DivZero(Fields[1].AsInteger,psld.CurrencyRate) * 10);
                Inc(TotalMoney,iValue);

                SumList(PayList,Fields[0].AsString,iValue);
                Next;
              end;
              Close;
            end;
            with UserSession.quPay do
            begin
              SQL.Text := Format(sqlPayTotalUser,[samdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
              Open;
              TotalUser := TotalUser + Fields[0].AsInteger;
              Close;
            end;
          end;
        end;
        UserSession.SQLConnectionSession.Close;
        UserSession.SQLConnectionLog.Close;
      end;
    end;
    dValue := TotalMoney;
    if dValue <> 0 then dValue := DivZero(TotalMoney,TotalUser);
    IWLabel4.Caption := Format(Langtostr(sTipText),[FormatDateTime('YYYY-MM-DD',dMinDateTime),FormatDateTime('YYYY-MM-DD',dMaxDateTime),Format(objINI.RMBFormat,[TotalMoney/10]),TotalUser,dValue / 10]); // dValue / 10  Arpu值 除以10
    with TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      for I := 0 to OnlineList.Count - 1 do
      begin
        Series[0].AddSinglePoint(ChangeZero(Integer(OnlineList.Objects[I])),
                  FormatDateTime('MM-DD',StrToDate(OnlineList.Strings[I])));
        Range.RangeFrom := 0;
        Range.RangeTo := OnlineList.Count-1;
      end;
      Title.Text:= Langtostr(22);
    end;
    if OnlineList.Count * objINI.AutoWidth < objINI.DefaultWidth then
      TIWAdvChart1.Width := objINI.DefaultWidth
    else
      TIWAdvChart1.Width := OnlineList.Count * objINI.AutoWidth;
    with TIWAdvChart2.Chart do
    begin
      Series[0].ClearPoints;
      for I := 0 to PayList.Count - 1 do
      begin
        Series[0].AddSinglePoint(ChangeZero(Integer(PayList.Objects[I]) / 10),
                  FormatDateTime('MM-DD',StrToDate(PayList.Strings[I])));
        Range.RangeFrom := 0;
        Range.RangeTo := PayList.Count-1;
      end;
      Title.Text:= Langtostr(181);
    end;
    if PayList.Count * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart2.Width := objINI.DefaultWidth
    else
      TIWAdvChart2.Width := PayList.Count * (objINI.AutoWidth+20);

    TIWAdvChart1.Visible := True;
    TIWAdvChart2.Visible := True;
  finally
    OnlineList.Free;
    PayList.Free;

  end;
end;

procedure TIWfrmOnlineAndPay.QueryAlldata(dMinDateTime, dMaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayAndOLTotal = 'SELECT SUM(money)/10 AS TotalMoney,COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
var
  sqlMaxTime: TDateTime;
  I,TotalCount,TotalMoney,TotalUser: Integer;
  pslsd: PTServerListData;
  samdb, saccont: string;
    sBuffer  : string;
begin
  try
    samdb := ''; saccont := ''; sBuffer:= '';
    for I := 0 to ServerList.Count - 1 do
    begin
      pslsd := PTServerListData(ServerList.Objects[I]);
//      psld:= GetServerListData(IWcBoxZJHTServers.Items.Strings[IWcBoxZJHTServers.ItemIndex]); //平台判断
    //  if (pslsd^.Index = 0) and (pslsd^.spID = psld.spID) then
     // begin
      if (pslsd^.Index = 0) then
      begin
        if UserSession.IsCheckConnectionLogMysql(pslsd^.LogDB,pslsd^.LogHostName) and
           UserSession.IsCheckConnectionSessionMysql(pslsd^.AccountDB,pslsd^.SessionHostName) then
        begin
          UserSession.ConnectionLogMysql(pslsd^.LogDB,pslsd^.LogHostName);
          UserSession.ConnectionSessionMysql(pslsd.AccountDB,pslsd^.SessionHostName);
          sqlMaxTime := dMinDateTime;
          while sqlMaxTime<=dMaxDateTime do
          begin
            TotalUser := 0; TotalCount := 0; TotalMoney := 0;
            with UserSession.quOnlineCount do
            begin
              if UserSession.IsCheckOnlineTable(pslsd^.LogDB,Format('log_onlinecount_%s',[FormatDateTime('yyyymmdd',sqlMaxTime)])) then
              begin
                SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',sqlMaxTime)]);
                Open;
                Inc(TotalCount,Fields[0].AsInteger);
                Close;
              end;
            end;

            with UserSession.quPay do
            begin
              SQL.Text := Format(sqlPayAndOLTotal,[pslsd.amdb,pslsd.spid, DateToStr(sqlMaxTime),DateToStr(sqlMaxTime)]);;
              Open;
              TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*pslsd^.CurrencyRate*10);
              TotalUser  := TotalUser + Fields[1].AsInteger;
              Close;
            end;

            //新增加
            if pslsd^.SessionHostName2 <> '127.0.0.1' then
            begin
              if pslsd^.AccountDB2 = 'cq_account' then saccont := 'cq_account'
              else  saccont := pslsd^.AccountDB2;

              if pslsd^.Amdb2 = 'amdb' then samdb := 'amdb'
              else  samdb := pslsd^.Amdb2;

              if UserSession.IsCheckConnectionSessionMysql(saccont,pslsd^.SessionHostName2) then
              begin
                UserSession.ConnectionSessionMysql(saccont,pslsd^.SessionHostName2);

                with UserSession.quPay do
                begin
                  SQL.Text := Format(sqlPayAndOLTotal,[samdb,pslsd.spid, DateToStr(sqlMaxTime),DateToStr(sqlMaxTime)]);;
                  Open;
                  TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*pslsd^.CurrencyRate*10);
                  TotalUser  := TotalUser + Fields[1].AsInteger;
                  Close;
                end;
              end;
            end;

            sBuffer := DateToStr(sqlMaxTime) +' 00:05:00/'+ pslsd.spid +'/'+IntToStr(TotalMoney)+'/'+IntToStr(TotalUser)+'/'+IntToStr(TotalCount);
            IWServerController.InsertPayAndOL2(sBuffer);
            sqlMaxTime := sqlMaxTime + 1;
          end;

          UserSession.SQLConnectionSession.Close;
          UserSession.SQLConnectionLog.Close;
        end;
      end;
    end;
  finally

  end;
end;


end.
