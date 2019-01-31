unit UnitfrmAllOnlineAndPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWCompEdit, IWCompButton, IWCompListbox, IWTMSImgCtrls,
  IWControl, IWExchangeBar, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWAdvChart,
  IWTMSCal, AdvChart, DateUtils,IWCompCheckbox, IWWebGrid, IWAdvWebGrid;

type
  TIWfrmAllOnlineAndPay = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWAdvChart2: TTIWAdvChart;
    IWHZMode: TIWCheckBox;
    IWButton1: TIWButton;
    IWButton2: TIWButton;
    IWButton3: TIWButton;
    IWButton4: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWButton5: TIWButton;
    IWLabel2: TIWLabel;
    IWLabel5: TIWLabel;
    IWLabel6: TIWLabel;
    TIWHTMLLabPayMoney: TTIWHTMLLabel;
    IWAmdbMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryAllOnlineAndPay(dMinDateTime,dMaxDateTime: TDateTime);
    procedure QueryAllOnlineAndPayEx(dMinDateTime,dMaxDateTime: TDateTime);
  end;

var
  IWfrmAllOnlineAndPay: TIWfrmAllOnlineAndPay;

implementation

uses ServerController, ConfigINI, Share;

{$R *.dfm}

procedure TIWfrmAllOnlineAndPay.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();//IncDay(Now(),-DayOf(Now())+1); 默认不以月初开始
  pEDate.Date := Now();
  SetServerListSelect(Langtostr(StatToolButtonStr[tbAllOnlineAndPay]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbAllOnlineAndPay]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbAllOnlineAndPay])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel2.Caption := FormatDateTime('MM月DD日',IncDay(Now, -1));
  IWLabel5.Caption := FormatDateTime('MM月DD日',Now);
end;

procedure TIWfrmAllOnlineAndPay.IWBtnBuildClick(Sender: TObject);
begin
  inherited;
  try
    case TIWButton(Sender).Tag  of
        1: //昨天
        begin
          pSDate.Date := IncDay(Now, -1);
          pEDate.Date := IncDay(Now, -1);
        end;
        2: //今天
        begin
          pSDate.Date := Now();
          pEDate.Date := Now();
        end;
        3:
        begin
          pSDate.Date := IncDay(Now, -3); //前三天
          pEDate.Date := Now();
        end;
        4:
        begin
          pSDate.Date := IncDay(Now(),-DayOf(Now())+1); //月初开始
          pEDate.Date := Now();
        end;
    else
    end;
    if not IWHZMode.Checked then
    begin
      try
        QueryAllOnlineAndPay(pSDate.Date,pEDate.Date);
      finally
      end;
    end else
    begin
      try
        QueryAllOnlineAndPayEx(pSDate.Date,pEDate.Date);
      finally
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmAllOnlineAndPay.IWButton5Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'AllOnlineAndPay' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmAllOnlineAndPay.QueryAllOnlineAndPay(dMinDateTime,
  dMaxDateTime: TDateTime);
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayTotalMoney = 'SELECT date(orderdate),SUM(money)/10 AS TotalMoney FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59" GROUP BY date(orderdate)';
  sqlPayTotalUser = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  sqlPayTotalMoney2 = 'SELECT date(orderdate),SUM(money)/10 AS TotalMoney FROM %s.payorder_%s WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59" GROUP BY date(orderdate)';
  sqlPayTotalUser2 = 'SELECT COUNT(DISTINCT account) AS iCount FROM %s.payorder_%s WHERE yunying="_%s" AND type in (1,3) AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
  ChartColor : array [0..16] of Integer = (clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray, clDkGray, clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray, clSilver);
  sTipText = '  自 %s 到 %s 的总计充值金额为：%s，总计充值用户数为：%d ，ARPU值为：%.1f';
var
  dValue,dTmp: Double;
  sqlMaxTime: TDateTime;
  I,TotalCount,iValue,TotalMoney,TotalUser: Integer;
  pslsd: PTServerListData;
  OnlineList,PayList: TStringList;
  OnlineYunYingList,PayYunYingList: TStringList;
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
  OnlineYunYingList := TStringList.Create;
  PayYunYingList := TStringList.Create;
  try
    TotalMoney := 0; TotalUser := 0; samdb := ''; saccont := '';
    for I := 0 to ServerList.Count - 1 do
    begin
      pslsd := PTServerListData(ServerList.Objects[I]);
      if (pslsd^.Index = 0) then
      begin
        if UserSession.IsCheckConnectionLogMysql(pslsd^.LogDB,pslsd^.LogHostName) and
           UserSession.IsCheckConnectionSessionMysql(pslsd^.AccountDB,pslsd^.SessionHostName) then
        begin
          UserSession.ConnectionLogMysql(pslsd^.LogDB,pslsd^.LogHostName);
          UserSession.ConnectionSessionMysql(pslsd.AccountDB,pslsd^.SessionHostName);
          with UserSession.quOnlineCount do
          begin
            TotalCount := 0;
            sqlMaxTime := dMinDateTime;
            while sqlMaxTime<=dMaxDateTime do
            begin
              if UserSession.IsCheckOnlineTable(pslsd^.LogDB,Format('log_onlinecount_%s',[FormatDateTime('yyyymmdd',sqlMaxTime)])) then
              begin
                SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',sqlMaxTime)]);
                Open;
                if sqlMaxTime = dMaxDateTime then
                begin
                  Inc(TotalCount,Fields[0].AsInteger);
                end;
                SumList(OnlineList,DateToStr(sqlMaxTime),Fields[0].AsInteger);
                Close;
              end;
              sqlMaxTime := sqlMaxTime + 1;
            end;
          end;
          OnlineYunYingList.AddObject(ServerList.Strings[I],TObject(TotalCount));

          with UserSession.quPay do
          begin
            if IWAmdbMode.Checked then
             SQL.Text := Format(sqlPayTotalMoney2,[pslsd^.Amdb,FormatDateTime('YYYYMM',dMinDateTime),pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
            else
             SQL.Text := Format(sqlPayTotalMoney,[pslsd^.Amdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
            Open;
            TotalCount := 0;
            while not Eof do
            begin
              iValue := Trunc(Fields[1].AsFloat*pslsd^.CurrencyRate*10);
              Inc(TotalMoney,iValue);
              if Fields[0].AsDateTime = dMaxDateTime then
              begin
                Inc(TotalCount,iValue);
              end;
              SumList(PayList,Fields[0].AsString,iValue);
              Next;
            end;
            Close;
          end;
          with UserSession.quPay do
          begin
            if IWAmdbMode.Checked then
              SQL.Text := Format(sqlPayTotalUser2,[pslsd^.Amdb,FormatDateTime('YYYYMM',dMinDateTime),pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
            else
             SQL.Text := Format(sqlPayTotalUser,[pslsd^.Amdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);

            Open;
            TotalUser := TotalUser + Fields[0].AsInteger;
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
                if IWAmdbMode.Checked then
                  SQL.Text := Format(sqlPayTotalMoney2,[samdb,FormatDateTime('YYYYMM',dMinDateTime),pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
                else
                 SQL.Text := Format(sqlPayTotalMoney,[samdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
                Open;
                //TotalCount := 0;
                while not Eof do
                begin
                  iValue := Trunc(Fields[1].AsFloat*pslsd^.CurrencyRate*10);
                  Inc(TotalMoney,iValue);
                  if Fields[0].AsDateTime = dMaxDateTime then
                  begin
                    Inc(TotalCount,iValue);
                  end;
                  SumList(PayList,Fields[0].AsString,iValue);
                  Next;
                end;
                Close;
              end;
              with UserSession.quPay do
              begin
                if IWAmdbMode.Checked then
                 SQL.Text := Format(sqlPayTotalUser2,[samdb,FormatDateTime('YYYYMM',dMinDateTime),pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)])
                else
                 SQL.Text := Format(sqlPayTotalUser,[samdb,pslsd^.spID,DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
                Open;
                TotalUser := TotalUser + Fields[0].AsInteger;
                Close;
              end;
            end;
          end;
          PayYunYingList.AddObject(ServerList.Strings[I],TObject(TotalCount));
          UserSession.SQLConnectionSession.Close;
          UserSession.SQLConnectionLog.Close;
        end
        else  //失败的情况数值为0
        begin
           OnlineYunYingList.AddObject(ServerList.Strings[I],TObject(0));
           PayYunYingList.AddObject(ServerList.Strings[I],TObject(0));
        end;
      end;
    end;
    dValue := TotalMoney;
    if dValue <> 0 then dValue := DivZero(TotalMoney,TotalUser);
    TIWHTMLLabPayMoney.HTMLText := Format(sTipText,[FormatDateTime('YYYY-MM-DD',dMinDateTime),FormatDateTime('YYYY-MM-DD',dMaxDateTime),Format(objINI.RMBFormat,[TotalMoney/10]),TotalUser,dValue / 10]); // dValue / 10  Arpu值 除以10
    //--

    //--
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
        Series[0].AddSinglePoint(ChangeZero(Integer(PayList.Objects[I])/10),
                  FormatDateTime('MM-DD',StrToDate(PayList.Strings[I])));
        Range.RangeFrom := 0;
        Range.RangeTo := PayList.Count-1;
      end;
    end;
    if PayList.Count * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart2.Width := objINI.DefaultWidth
    else
      TIWAdvChart2.Width := PayList.Count * (objINI.AutoWidth+20);
    //--
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      for I := 0 to OnlineYunYingList.Count - 1 do
      begin
        RowCount := I + 1;
        iValue := Integer(OnlineYunYingList.Objects[I]);
        dValue := Integer(PayYunYingList.Objects[I])/10;
        cells[1,i] := OnlineYunYingList.Strings[I];
        cells[2,i] := Format(objINI.RMBFormat,[dValue]);
        cells[3,i] := Format(objINI.RMBFormat,[DivZero(dValue, TotalMoney) * 1000])+'%';
        cells[4,i] := IntToStr(iValue) ;
        cells[5,i] := {Format('%.2f',[DivZero(iValue, TotalCount) * 100])+}'0%';

     //   cells[2,i] := Format(objINI.RMBFormat,[dValue]) + ' ('+ Format(objINI.RMBFormat,[DivZero(dValue, TotalMoney) * 1000])+'%)';;
     //   cells[3,i] := IntToStr(iValue);
      end;
    end;
    TIWAdvChart1.Visible := True;
    TIWAdvChart2.Visible := True;
  finally
    OnlineList.Free;
    PayList.Free;
    OnlineYunYingList.Free;
    PayYunYingList.Free;
  end;
end;

procedure TIWfrmAllOnlineAndPay.QueryAllOnlineAndPayEx(dMinDateTime,
  dMaxDateTime: TDateTime);
const
  sqlPayAndOlTotalUser = 'SELECT date(logdate),globalonline,(paytotal/10) as paytotal,payuser,spid FROM %s.mypaydata WHERE  logdate>="%s" AND logdate<="%s 23:59:59" ORDER BY date(logdate) ASC, paytotal DESC';
  sTipText = '<br><p>&nbsp;&nbsp;&nbsp;自&nbsp;<FONT color="#FF0000"><B>%s </B></FONT>&nbsp;到&nbsp;<FONT color="#FF0000"><B>%s</B></FONT>&nbsp;&nbsp;的总金额：<FONT color="#FF0000"><B>%s</B></FONT>，' +
             '总充值用户：<FONT color="#FF0000"><B>%d </B></FONT>，ARPU值：<FONT color="#FF0000"><B>%.1f</B></FONT></p>';
var
  dValue,dTmp: Double;
//  sqlMaxTime: TDateTime;
  I,TotalCount,TotalMoney2, iValue,TotalOl,TotalMoney,TotalUser: Integer;
  pslsd, psld: PTServerListData;
  OnlineList,PayList: TStringList;
  OnlineYunYingList,PayYunYingList: TStringList;
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
  OnlineYunYingList := TStringList.Create;
  PayYunYingList := TStringList.Create;
  try
    TotalOl:= 0; TotalMoney := 0; TotalUser := 0;

    psld := GetServerListDataBySPID(objINI.IWServerSPID);
    if psld = nil then Exit;
    UserSession.ConnectionLogMysql(psld^.GstaticDB,psld^.LogHostName);

    with UserSession.quASunPay do
    begin

      SQL.Text := Format(sqlPayAndOlTotalUser,[psld^.GstaticDB, DateToStr(dMinDateTime),DateToStr(dMaxDateTime)]);
      Open;
      try
        while not Eof do
        begin
           TotalCount:= 0; TotalMoney2 := 0;

           Inc(TotalCount,FieldByName('globalonline').AsInteger); //单平台总在线
           Inc(TotalOl,TotalCount);  //累计平台在线

           SumList(OnlineList,FieldByName('date(logdate)').AsString, TotalCount); // 日期 + 在线人数线
           SumList(OnlineYunYingList,FieldByName('spid').AsString, TotalCount); // 平台 + 在线人数线

           iValue := Trunc(FieldByName('paytotal').AsFloat*10);
           Inc(TotalMoney,iValue);
           Inc(TotalMoney2,iValue);
           SumList(PayList,(FieldByName('date(logdate)').AsString),iValue); //日期 +充值
           SumList(PayYunYingList,(FieldByName('spid').AsString),TotalMoney2); // 台+ 充值

           TotalUser := TotalUser + FieldByName('payuser').AsInteger;
           Next;
        end;
      finally
        Close;
      end;
    end;
    UserSession.SQLConnectionLog.Close;

    dValue := TotalMoney;
    if dValue <> 0 then dValue := DivZero(TotalMoney,TotalUser);
    TIWHTMLLabPayMoney.HTMLText := Format(sTipText,[FormatDateTime('YYYY-MM-DD',dMinDateTime),FormatDateTime('YYYY-MM-DD',dMaxDateTime),Format(objINI.RMBFormat,[TotalMoney/10]),TotalUser,dValue / 10]); // dValue / 10  Arpu值 除以10

    //--
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
        Series[0].AddSinglePoint(ChangeZero(Integer(PayList.Objects[I])/10),
                  FormatDateTime('MM-DD',StrToDate(PayList.Strings[I])));
        Range.RangeFrom := 0;
        Range.RangeTo := PayList.Count-1;
      end;
    end;
    if PayList.Count * (objINI.AutoWidth+20) < objINI.DefaultWidth then
      TIWAdvChart2.Width := objINI.DefaultWidth
    else
      TIWAdvChart2.Width := PayList.Count * (objINI.AutoWidth+20);
    //--
    //--
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      for I := 0 to OnlineYunYingList.Count - 1 do
      begin
        RowCount := I + 1;
        iValue := Integer(OnlineYunYingList.Objects[I]);  //在线
        dValue := Integer(PayYunYingList.Objects[I])/10;  //充值
        cells[0,i] := inttostr(RowCount);
        cells[1,i] := OnlineYunYingList.Strings[I];
        cells[2,i] := GetServerListName(OnlineYunYingList.Strings[I], 0);
        cells[3,i] := Format(objINI.RMBFormat,[dValue]);
        cells[4,i] := Format(objINI.RMBFormat,[DivZero(dValue, TotalMoney) * 1000])+'%';
        cells[5,i] := IntToStr(iValue) ;
        cells[6,i] := Format('%.2f',[DivZero(iValue, TotalOl) * 100])+'%';
      end;
    end;
    TIWAdvWebGrid1.Height :=  (TIWAdvWebGrid1.RowCount + 2) * 22;

    TIWAdvChart1.Visible := True;
    TIWAdvChart2.Visible := True;
  finally
    OnlineList.Free;
    PayList.Free;
    OnlineYunYingList.Free;
    PayYunYingList.Free;
  end;
end;



end.
