unit UWorkHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ShellAPI, Spin, Menus, clipbrd,
  FMTBcd, DB, SqlExpr, RzListVw, msxml, uordermysql, DBXMSSQL, uordernetfile,
  DBXMySQL, dateutils, DBXSybaseASA, comobj, activex,pngimage, Vcl.OleCtrls,
  SHDocVw,WinSock;

const
 Servertype : array[0..2] of string = ('中国', '韩国', '越南');
 ServerRootPath = 'D:\work\program\521g\idgp\ZhanJiangII\!SC\';
 ServerPath : array[0..2] of string = ('Server\GameCenter\', 'branch\Server\韩服版本2012-10-11\', 'branch\Server\2012-10-11\');
 ServerLanPath : array[0..2] of string =('Server\GameCenter\Language\zh-CN.db', 'Server\GameCenter\Language\zh-KR.db', 'Server\GameCenter\Language\zh-YN.db') ;
 sqlActiveUser = 'SELECT max(onlinecount) as count FROM globallog.game2_0_countlog where logdate >= "%s" and logdate <= "%S" and serverindex = 0';
 sqlRMBUser = 'SELECT COUNT(DISTINCT account) as count  FROM amdb.payorder where type=1 and orderdate>="%s" AND orderdate<="%s"';
 cStr = '正在计算%S数据 [%d/%d]';
 sqlTotalMoney ='SELECT SUM(Money)  as count FROM amdb.payorder WHERE orderdate>="%s" AND orderdate<="%s" AND type in (1,3) ';
 sqlTotalOrder ='SELECT COUNT(DISTINCT account)  as count FROM amdb.payorder WHERE orderdate>="%s" AND orderdate<="%s" AND type in (1,3)';
 SthreadExit ='此线程退出码是%d (259代表未退出)';
 UpdateSvn = '更新Svn文件';
 CommitSvn = '提交Svn文件';
 ServerExcel = 'D:\mine\百度网盘\我的文档\work\bakeup\数据查询\各平台Ip.xlsx';
 sqlRegister = 'SELECT count(*) as count FROM 5eglobal.globaluser WHERE createdate>="%S" AND createdate<="%S"';
 sqlRegister1 =' and account not like "wuyitest%" ;';
 sqlRechange = 'SELECT SUM(rmb) as count FROM %s.payorder WHERE orderdate>="%s" AND orderdate<="%s" AND type in (1,3) and yunying = "%s"';
 //战千雄游戏充值金额排名前100玩家账号
 sqlorder50 ='select account,sum(rmb) as rmb,orderdate,count(account) as count,max(rmb) as mrmb from %s.payorder where type in (1,3) and yunying = "%s"  GROUP BY account ORDER BY rmb DESC limit 0,100';
 //查询各个平台单次充值5000RMB及以上的明细
 sqlorder5000 = 'select account,rmb,orderdate from %s.payorder where rmb>=%d AND type in (1,3) and yunying = "%s"';
 sqlInt64 = 'select * from %s.test';

 sqlDayOnline = 'SELECT max(onlinecount) as count FROM %s.game2_0_countlog where logdate >= "%s" and logdate <= "%S" and serverindex = 0';
 sqlDayOnlineByServerid = 'SELECT max(onlinecount) as count FROM %s.game2_0_countlog where logdate >= "%s" and logdate <= "%s" and serverindex BETWEEN %d and %d GROUP BY CONCAT(year(logdate),"-",month(logdate),"-",day(logdate)),serverindex';

 sqlAvgDayOnline = 'SELECT avg(onlinecount) as count FROM %s.game2_0_countlog  where logdate >= "%s" and logdate <= "%S" and serverindex = 0';
 sqlAvgDayOnlineByServerid = 'SELECT SUM(onlinecount)/(144*30) as count FROM %s.game2_0_countlog where logdate >= "%s" and logdate <= "%s" and serverindex BETWEEN %d and %d';
 sqlMonthPayUser ='SELECT COUNT(DISTINCT account) as count  FROM %s.payorder where type in (1,3) and orderdate>="%s" AND orderdate<="%s"';
 sqlMonthPayUserBySPID ='SELECT COUNT(DISTINCT account) as count  FROM %s.payorder where type in (1,3) and orderdate>="%s" AND orderdate<="%s" and yunying = "%s"';
 sqlMonthRegister = 'SELECT count(*) as count FROM %s.globaluser WHERE createdate>="%S" AND createdate<="%S"';
 sqlMonthRegisterByServerid = 'SELECT count(*) as count FROM %s.globaluser WHERE createdate>"%s" AND createdate<="%s" and inserver BETWEEN %d and %d ';
 strCaption = '正在统计数据 [%d/%d]';
 QueryStartDate = '2012-03-01';
 type
 TMyShape = packed record
    ID: Integer;
    case flag:Boolean of
      True:  (x1, y1, x2, y2: Integer);
      False: (x, y, r: Integer);
  end;

 pOrderInfo =^TOrderInfo;
 TOrderInfo = record
  account: string;
  rmb: Double;
  orderdate: string;
  Operators: string;
 end;

 type
   ThreadSql= class(TThread)
   private
    serverdata: PserverData;
    Resultlist: TStringList;
    SqlQuery : TSQLQuery;
    SessionCon: TSQLConnection;
    logCon: TSQLConnection;
   public
   constructor Create(CreateSuspended:Boolean; serverdata1: PserverData); overload;
   procedure execute;override;
   destructor Destroy; override;

 end;



type

 FAnimateWindow = function(
                       const hwnd : HWND;       //仅对窗口有效
                       const dwTime : DWORD;    //动画持续时间，默认200ms
                       const dwFlags : DWORD): DWORD; stdcall;

  oaStyle = (oaview, oaedit);
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    cbbCbTarget: TComboBoxEx;
    btn1: TSpeedButton;
    chkUpdate: TCheckBox;
    chkcommit: TCheckBox;
    mmo1: TMemo;
    lbledt1: TLabeledEdit;
    chk3: TCheckBox;
    lbledt2: TLabeledEdit;
    mmo2: TMemo;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    se1: TSpinEdit;
    btn4: TSpeedButton;
    lbl1: TLabel;
    btn5: TSpeedButton;
    pm: TPopupMenu;
    N1: TMenuItem;
    pmsvn: TPopupMenu;
    MenuItem1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ts5: TTabSheet;
    mmo3: TMemo;
    btn6: TSpeedButton;
    pmstr: TPopupMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    chk1: TCheckBox;
    chk2: TCheckBox;
    edtCh: TEdit;
    edtCh1: TEdit;
    btn7: TSpeedButton;
    ts6: TTabSheet;
    pnl1: TPanel;
    pnl2: TPanel;
    lbledtRGB: TLabeledEdit;
    lbledtDecimal: TLabeledEdit;
    lbledtHexColor: TLabeledEdit;
    sqlqry1: TSQLQuery;
    ts7: TTabSheet;
    pnl3: TPanel;
    lbledt3: TLabeledEdit;
    btnGetServer: TSpeedButton;
    con1: TSQLConnection;
    btn8: TButton;
    ts8: TTabSheet;
    pb1: TPaintBox;
    btn9: TButton;
    btn10: TButton;
    btn11: TButton;
    chk4: TCheckBox;
    btn12: TSpeedButton;
    chk5: TCheckBox;
    se2: TSpinEdit;
    btn13: TSpeedButton;
    edt1: TEdit;
    edt2: TEdit;
    btn14: TButton;
    btn15: TButton;
    ts9: TTabSheet;
    pnl4: TPanel;
    btn16: TSpeedButton;
    lbledt4: TLabeledEdit;
    btn17: TButton;
    RZLV1: TRzListView;
    pb2: TProgressBar;
    ts10: TTabSheet;
    img1: TImage;
    btn18: TButton;
    edt3: TEdit;
    RZLVServerlist: TRzListView;
    tswebchat: TTabSheet;
    wb1: TWebBrowser;
    edt4: TEdit;
    con2: TSQLConnection;
    trycn1: TTrayIcon;
    pmTray: TPopupMenu;
    N8: TMenuItem;
    se3: TSpinEdit;
    N9: TMenuItem;
    ts11: TTabSheet;
    Button1: TButton;
    pnl5: TPanel;
    lbledt5: TLabeledEdit;
    lbledt6: TLabeledEdit;
    btn19: TSpeedButton;
    btn20: TSpeedButton;
    edt5: TEdit;
    se4: TSpinEdit;
    btn21: TSpeedButton;
    btn22: TSpeedButton;
    btn23: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure mmo3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnl1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGetServerClick(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pb1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn9Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure btn15Click(Sender: TObject);
    procedure btn16Click(Sender: TObject);
    procedure btn17Click(Sender: TObject);
    procedure btn18Click(Sender: TObject);
    procedure edt3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure img1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure edt4KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure trycn1DblClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure 取得转生等级(Sender: TObject);
    procedure btn23Click(Sender: TObject);
    procedure btn22Click(Sender: TObject);
  private
    procedure Doinit;
    procedure iniServerFile;
    procedure SvnUpdateFile(const Filepath: string);
    procedure SvnCommitFile(const Filepath, StrMsg:string);
    procedure OnMinsize(var msg:twmsyscommand);message wm_syscommand;
    procedure openOA(const OANum:Integer; OS: oaStyle);
    function GetMyPath(SourStr: string): string;
    procedure HandleMemo(var SourceMemo: tmemo; sourceStr, tartgetStr:string);
    function GetStrBetweenChar(const SourceStr: string; StartCh,
      endCh: string): string;
    function DelphiColorToRGB(const SourColor: Tcolor): string;
    procedure LoadServerList;
    procedure ReadServerTOlist;
    procedure CalcAdd();
    procedure CalcRegister(var nlist:TListItem);
    procedure CalcActiveUser(var nlist: TListItem;logip:string);
    procedure CalcRMBUser(var nlist: TListItem);
    procedure CalcARPU(var nlist: TListItem; Rate:byte);
    procedure MemoAddIndex(var SourceMemo: tmemo; ConnectionStr: string);
    procedure ClearServerlist;
    procedure ClearOrderlist;
  protected
    procedure createparams(var params : TCreateParams);override;
  public
    function GetSqlCount(Const Sql:string; Const StartDate,endDate:Tdate):Integer;overload;
  end;


function AnimateWindow(const hWnd : HWND; const dwTime : DWORD;
                       const dwFlags : DWORD): DWORD;

function GetSqlCount2(const StrSessionIP: string; Const Sql:string; Const StartDate,endDate:Tdate):Integer;overload;
function GetSqlCount(const Con: TSQLConnection; SqlStr: string; Sq:tsqlquery): Integer;

var
  Form1: TForm1;
  cs, cs2, cs3 :TRTLCriticalSection;
  stemp: string;
  nlist: TListItem;
  ServerList, Orderlist: TStringList;
  iname, ICount, AllCount, itemp: integer;
  pt: tpoint;
implementation
var
 hMutex: THandle; {互斥对象的句柄}
 hSemaphore: THandle;
 hThread: thandle;
 pt1: TPoint; {这个坐标点将会已指针的方式传递给线程 , 它应该是全局的}
 hProcess: THandle; {进程句柄}



{$R *.dfm}
function AnimateWindow(const hWnd : HWND; const dwTime : DWORD;
                       const dwFlags : DWORD): DWORD;
var
   DLLHandle : THandle;
   AnimateWindow : FAnimateWindow;
begin
   Result := 0;
   DLLHandle := LoadLibrary('user32.dll');
   @AnimateWindow := GetProcAddress(DllHandle,'AnimateWindow');
   Result := AnimateWindow(hWnd, dwTime, dwFlags);
end;

{ 等待一个指定句柄的进程什么时候结束 }
function MyThreadFun(p: Pointer): DWORD; stdcall;
begin
  if WaitForSingleObject(hProcess, INFINITE) = WAIT_OBJECT_0 then
  begin
    Form1.Text := '操作完成';
    Result := 0;
  end;
end ;

function DivZero(sValue,eValue: integer): integer;
begin
  Result := 0;
  if (sValue <> 0) and (eValue <> 0) then
  begin
    Result := sValue div eValue;
  end;
end;

procedure TForm1.SvnUpdateFile(const Filepath:string);
const
 UpdateStr = ' /command:update /path:"%s" /closeonend:1';
var
  tempStr :string;
  pInfo: TProcessInformation;
  sInfo: TStartupInfo;
  ThreadID: DWORD;

begin
 if Trim(Filepath)='' then exit;
 tempStr := Filepath;
 tempStr := StringReplace(tempStr, #13#10, '*', [rfReplaceAll]);
 tempStr := StringReplace(tempStr, '"', '', [rfReplaceAll]);
 tempStr := StringReplace(tempStr, '/', '\', [rfReplaceAll]);
 if Pos('*', tempStr)> 0 then
 tempStr := Copy(tempStr, 1, length(tempStr)-1 );
 tempStr := Format(UpdateStr, [tempStr]);
// ShellExecute(Handle,nil,'TortoiseProc.exe',PChar(tempStr), nil, SW_HIDE);

  FillChar(sInfo, SizeOf(sInfo), 0);
  if CreateProcess('C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe',PChar(tempStr),nil,nil,false,0, nil, nil, sinfo, pinfo ) then
  begin
    hProcess := pInfo.hProcess;                           {获取进程句柄}
    Text := Format( '正在更新Svn文件', [hProcess]);
    CreateThread( nil, 0 , @MyThreadFun, nil, 0, ThreadID); {建立线程监视}
  end;

end;

procedure TForm1.trycn1DblClick(Sender: TObject);
begin
 N8Click(Sender);
end;

function paintNum(p:pointer):integer;stdcall;
var
 i: integer;
 pt1: TPoint;       {因为指针参数给的点随时都在变 , 需用线程的局部变量存起来 }
begin
  pt1 := TPoint(p^); {转换}
// for i := 0 to 5000 do
// begin
   inc(itemp);
   form1.pb1.Canvas.Lock;
   form1.pb1.Canvas.TextOut(pt1.X, pt1.Y, inttostr(itemp));
   form1.pb1.Canvas.unLock;
   sleep(117);
// end;
 Result := 137;   {这个返回值将成为线程的退出代码 , 99 是我随意给的数字}
end;




procedure TForm1.SvnCommitFile(const Filepath, StrMsg:string);
const
 UpdateStr = ' /command:commit /path:"%s" /logmsg:"%s" /closeonend:1';
var
  tempStr, fstr :string;
  pInfo: TProcessInformation;
  sInfo: TStartupInfo;
  ThreadID: DWORD;
begin
 tempStr := Filepath;
 if Trim(tempStr)='' then exit;
 tempStr := StringReplace(tempStr, #13#10, '*', [rfReplaceAll]);
 tempStr := StringReplace(tempStr, '"', '', [rfReplaceAll]);
 tempStr := StringReplace(tempStr, '/', '\', [rfReplaceAll]);
 if Pos('*', tempStr)> 0 then
 tempStr := Copy(tempStr, 1, length(tempStr)-1 );
 fstr:= Format(UpdateStr, [tempStr, StrMsg]);
// showmessage(fstr);
// ShellExecute(Handle,nil,'TortoiseProc.exe',PChar(fstr), nil, SW_HIDE);

  FillChar(sInfo, SizeOf(sInfo), 0);
  if CreateProcess('C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe',PChar(fstr),nil,nil,false,0, nil, nil, sinfo, pinfo ) then
  begin
    hProcess := pInfo.hProcess;                           {获取进程句柄}
    tempStr := '提交Svn文件';
    Text := Format( '正在提交Svn文件', [hProcess]);
    CreateThread( nil, 0 , @MyThreadFun, nil, 0, ThreadID); {建立线程监视}
  end;
end;

procedure TForm1.openOA(const OANum:Integer; OS: oaStyle);
const
// EditOAUrl = 'http://192.168.0.159/zentaopms/www/index.php?m=task&f=edit&taskID=%d';
// ViewOAUrl = 'http://192.168.0.159/zentaopms/www/index.php?m=task&f=view&taskID=%d';
 EditOAUrl = 'http://oa.521g.cn/oa/order/edit?id=%d&backtype=1';
 ViewOAUrl = 'http://oa.521g.cn/oa/order/edit?id=%d&backtype=1';

begin
 if OANum <= 0 then Exit;

 case OS of
  oaview:
   ShellExecute(Handle,'open',PChar(Format(ViewOAUrl, [OANum])),nil, nil, SW_SHOWNORMAL);
  oaedit:
   ShellExecute(Handle,'open',PChar(Format(EditOAUrl, [OANum])),nil, nil, SW_SHOWNORMAL);
 end;
end;


procedure TForm1.pb1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 id: DWORD;
 pt2: Tpoint;
begin
 pt1 := point(x,y);
 hThread := CreateThread( nil, 0, @paintNum, @pt1, 0, id);
end;

procedure TForm1.pnl1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 releasecapture();
 setcapture(pnl1.handle);
 pnl1.Tag := 1;
end;

procedure TForm1.pnl1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 dc: hdc;
 tempColor: tcolor;
 Pos: tpoint;
begin
 if pnl1.Tag = 1 then
 begin
   dc := getdc(0);
   getcursorpos(Pos);
   tempColor := GetPixel( DC, Pos.X, Pos.Y );
   pnl1.Color := tempcolor;
//   pnl1.Refresh;
   lbledtRGB.Text := DelphiColorToRGB(tempcolor);
   lbledtHexColor.Text  := '0x' + IntToHex(tempcolor, 8);
   lbledtDecimal.Text := inttostr(tempcolor);
 end;
end;


function TForm1.DelphiColorToRGB(const SourColor:Tcolor):string;
var
   R, G, B: Byte;
   uValue: Cardinal;
   wLo,wHi: Word;
   bLo,bHi: Byte;
begin
    R := GetRValue(SourColor);
    G := GetGValue(SourColor);
    B := GetBValue(SourColor);
    uValue := ($FF shl 24) or (R shl 16) or (G shl 8) or B;
    wLo := LoWord(uValue);
    wHi := HiWord(uValue);
    Result := Format('%d,%d,%d,%d',[Hi(wHi),Lo(wHi),Hi(wLo),Lo(wLo)]);
end;


procedure TForm1.pnl1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture();
  pnl1.Tag := 0;
end;


function GetInt64(const Serverdata: Pserverdata; sqlquery:string):integer;
var
  svalue, strSql, temp :string;
  ivalue : Int64;
  list: tstringlist;
begin
  try
    entercriticalsection(cs2);
    CoInitialize(nil);


    if sqlquery = sqlInt64 then
    begin
     list := Serverdata.orderTemp;
     if Serverdata.BOffLine then
      strSql := format(sqlquery, [Serverdata.SessionDB, temp, Serverdata.Spid])
     else
      strSql := format(sqlquery, ['amdb',temp, Serverdata.Spid]);
    end;

    if not Serverdata.SessionCon.Connected  then Serverdata.SessionCon.Connected := true;
    Serverdata.Sq.Close;
    Serverdata.Sq.SQLConnection := Serverdata.SessionCon;
    with Serverdata.Sq do
    begin
      close;
      SQL.Text := strSql;
      Open;
      if IsEmpty then list.Add(#9 + '此数据为空');

      while not eof do
      begin
       application.ProcessMessages;

       ICount := FieldByName('value').Value;
       svalue := FieldByName('value').AsString;
       list.Add(svalue + #9 + IntToStr(ICount));
       Next;
      end;
    end;
  finally
    ICount := ICount + 1;
    form1.pb2.Position := Icount;
    form1.caption := format(strCaption, [ICount, AllCount]);
    CoUninitialize;
    leaveCriticalSection(cs2);
  end;


end;


function ExeSql(const Serverdata: Pserverdata; sqlquery:string):integer;
const
 StrConsume= 'globalconsumelog_%s';
 Strlogin= 'globalloginlog_%s';
 StrInserConsume = 'insert into gstatic.UserConsume SELECT * from globallog.%s';
 StrInserlogin = 'insert into gstatic.UserLogin SELECT * from globallog.%s';
 InserConsumeINfo = '正在执行%s 之 %s 的合并操作[%d/%d]';
var
 strSql, saccount, srmb, sorderdate,scount, smax: string;
 sDayStart, sDayEnd, sTabelname :string;
 list: TStringList;
 itemp, iAll: Integer;
 Bcreate:Boolean;
  StartDate, EndDate: Tdate;
begin
  try
   entercriticalsection(cs2);
   CoInitialize(nil);
   if Serverdata.BOffLine then Exit;
   if not Serverdata.LogCon.Connected  then Serverdata.LogCon.Connected := true;
   Serverdata.Sq.SQLConnection := Serverdata.LogCon;

   startdate := strtodate('2013-05-25');
   EndDate := strtodate('2014-06-30');
   itemp:= 0;
   ICount := DaysBetween(EndDate,startdate);
   while  startdate <  EndDate do
   begin
    sDayStart :=  formatdatetime('YYYYMMDD', StartDate);
    //消费表合并
    sTabelname := format(StrConsume, [sDayStart]);
    if not IsCheckTable(Serverdata.Sq, 'globallog', sTabelname) then
    begin
      startdate := Incday(startdate, 1);
      itemp := itemp + 1;
      Form1.Caption := Format(InserConsumeINfo, [Serverdata.ServerName, sDayStart, itemp, icount]);
      Continue;
    end;
    strSql := Format(StrInserConsume, [sTabelname]);
    with Serverdata.Sq do
    begin
      close;
      SQL.Text := strSql;
      ExecSQL(True);
    end;

    //登录表合并
    sTabelname := format(Strlogin, [sDayStart]);
    if not IsCheckTable(Serverdata.Sq, 'globallog', sTabelname) then
    begin
      startdate := Incday(startdate, 1);
      itemp := itemp + 1;
      Form1.Caption := Format(InserConsumeINfo, [Serverdata.ServerName, sDayStart, itemp, icount]);
      Continue;
    end;
    strSql := Format(StrInserlogin, [sTabelname]);
    with Serverdata.Sq do
    begin
      close;
      SQL.Text := strSql;
      ExecSQL(True);
    end;


    startdate := Incday(startdate, 1);
    itemp := itemp + 1;
    Form1.Caption := Format(InserConsumeINfo, [Serverdata.ServerName, sDayStart, itemp, icount])
   end;
  finally

//    ICount := ICount + 1;
//    form1.pb2.Position := Icount;
//    form1.caption := format(strCaption, [ICount, AllCount]);
    CoUninitialize;
    leaveCriticalSection(cs2);
  end;


end;



function Getorder(const Serverdata: Pserverdata; sqlquery:string):integer;
var
 strSql, saccount, srmb, sorderdate,scount, smax: string;
 list: TStringList;
 temp: Integer;
begin
  try
    entercriticalsection(cs2);
    CoInitialize(nil);


    if sqlquery = sqlorder5000 then
    begin
     list := Serverdata.orderTemp;
     temp := round(5000 / Serverdata.rate) ;



     if Serverdata.BOffLine then
      strSql := format(sqlquery, [Serverdata.SessionDB, temp, Serverdata.Spid])
     else
      strSql := format(sqlquery, ['amdb',temp, Serverdata.Spid]);
    end
    else
    begin
     if Serverdata.BOffLine then
     strSql := format(sqlquery, [Serverdata.SessionDB, Serverdata.Spid])
     else
     strSql := format(sqlquery, ['amdb', Serverdata.Spid]);
     list := Serverdata.orderlist;

    end;

    if not Serverdata.SessionCon.Connected  then Serverdata.SessionCon.Connected := true;
    Serverdata.Sq.Close;
    Serverdata.Sq.SQLConnection := Serverdata.SessionCon;
    with Serverdata.Sq do
    begin
      close;
      SQL.Text := strSql;
      Open;
//      if IsEmpty then list.Add(#9 + '此数据为空');

      while not eof do
      begin
       application.ProcessMessages;

       saccount := FieldByName('account').AsString;
       srmb := FloatToStr(FieldByName('rmb').AsCurrency * Serverdata.rate);
       sorderdate := FieldByName('orderdate').AsString;
       scount :=  FieldByName('count').AsString;
       smax := FieldByName('mrmb').AsString;
       list.Add(saccount + #9 + srmb + #9 + sorderdate + #9 + scount + #9 + smax + #9 + ServerData.ServerName);
       Next;
      end;
    end;
  finally
    ICount := ICount + 1;
    form1.pb2.Position := Icount;
    form1.caption := format(strCaption, [ICount, AllCount]);
    CoUninitialize;
    leaveCriticalSection(cs2);
  end;


end;



function MonthRechange(const Serverdata: Pserverdata;const CountDate:tdate):integer;
var
  sStartDate, sEndDate, Sql: string;
begin
  entercriticalsection(cs3);
  try
    result := 0;
    sStartDate := formatdatetime('YYYY-MM-01 00:00:00', CountDate);
    if EndOfTheMonth(CountDate) > now  then
     sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', now)
    else
     sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', EndOfTheMonth(CountDate));
    if Serverdata.BOffLine then
     Sql := format(sqlRechange, [Serverdata.SessionDB, sStartDate, sEndDate, Serverdata.Spid])
    else
     Sql := format(sqlRechange, ['amdb', sStartDate, sEndDate, Serverdata.Spid]);
    result := GetSqlCount(Serverdata.SessionCon, Sql, Serverdata.sq);
  finally
    leaveCriticalSection(cs3);

  end;
end;

function MonthPayUsers(const Serverdata: Pserverdata;Const CountDate:tdate):integer;
var
  sStartDate, sEndDate, Sql: string;
begin
//  entercriticalsection(cs);
  result := 0;
  sStartDate := formatdatetime('YYYY-MM-01 00:00:00', CountDate);
  if EndOfTheMonth(CountDate) > now  then
   sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', now)
  else
   sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', EndOfTheMonth(CountDate));
  if Serverdata.BOffLine then
   Sql := format(sqlMonthPayUserBySPID, [Serverdata.SessionDB, sStartDate, sEndDate, Serverdata.Spid])
  else
   Sql := format(sqlMonthPayUser, ['amdb', sStartDate, sEndDate]);
  result := GetSqlCount(Serverdata.SessionCon, Sql, Serverdata.sq);
//  leaveCriticalSection(cs);
end;

function MonthRegister(const Serverdata: Pserverdata;Const CountDate:tdate):integer;
var
  sStartDate, sEndDate, Sql: string;
begin
//  entercriticalsection(cs);
  result := 0;
  sStartDate := formatdatetime('YYYY-MM-01 00:00:00', CountDate);
  if EndOfTheMonth(CountDate) > now  then
   sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', now)
  else
   sEndDate := formatdatetime('YYYY-MM-DD HH:MM:SS', EndOfTheMonth(CountDate));

  if Serverdata.BOffLine then
   Sql := format(sqlMonthRegisterByServerid, [Serverdata.SessionDB, sStartDate, sEndDate, Serverdata.MinServerID, Serverdata.MaxServerId])
  else
   Sql := format(sqlMonthRegister, ['5eglobal', sStartDate, sEndDate]);
  Sql := sql + sqlRegister1;

  result := GetSqlCount(Serverdata.SessionCon, Sql, Serverdata.sq);
//  leaveCriticalSection(cs);
end;


//每日最高在线人数相加除以天数
function MonthOnline(const Serverdata: Pserverdata;Const CountDate:tdate):integer;
var
  StartDate, EndDate: Tdate;
  sDayStart, sDayEnd, Sql :string;
  DayOnLine: integer;
begin
//  entercriticalsection(cs);
  StartDate := StartOfTheMonth(CountDate);
  EndDate := EndOfTheMonth(CountDate);
  if EndDate > now  then   EndDate := now;
  DayOnLine := 0;
  while StartDate < EndDate do
  begin
   sDayStart := formatdatetime('YYYY-MM-DD 00:00:00', StartDate);
   sDayEnd := formatdatetime('YYYY-MM-DD 23:59:59', StartDate);
   if Serverdata.BOffLine then
    Sql := format(sqlDayOnlineByServerid, [Serverdata.LogDB, sDayStart, sDayEnd, Serverdata.MinServerID, Serverdata.MaxServerId])
   else
    Sql := format(sqlDayOnline, [Serverdata.LogDB, sDayStart, sDayEnd]);

   DayOnLine := DayOnLine + GetSqlCount(Serverdata.LogCon, Sql, Serverdata.sq);
   StartDate := incday(StartDate, 1);
  end;
  result := DivZero(DayOnLine,DaysInMonth(CountDate)) ;
//  leaveCriticalSection(cs);
end;


//月 日平均在线人数
function MonthAVGOnline(const Serverdata: Pserverdata;Const CountDate:tdate):integer;
var
  StartDate, EndDate: Tdate;
  sDayStart, sDayEnd, Sql :string;
begin
//  entercriticalsection(cs);
  StartDate := StartOfTheMonth(CountDate);
  EndDate := EndOfTheMonth(CountDate);
  if EndDate > now  then   EndDate := now;
  sDayStart := formatdatetime('YYYY-MM-DD 00:00:00', StartDate);
  sDayEnd := formatdatetime('YYYY-MM-DD 23:59:59', EndDate);

  Sql := format(sqlAvgDayOnlineByServerid, [Serverdata.LogDB, sDayStart, sDayEnd, Serverdata.MinServerID, Serverdata.MaxServerId]);
  result := GetSqlCount(Serverdata.LogCon, Sql, Serverdata.sq);
//  leaveCriticalSection(cs);
end;


function Testint64( Serverdata: Pserverdata):DWORD; stdcall;overload;
begin
  try
  entercriticalsection(cs);
  CoInitialize(nil);

    Serverdata.orderlist.Clear;
    Serverdata.ordertemp.Clear;
    Serverdata.ordertemp.Add('int64测试' + #9 + 'str转换值'+ #9 + 'int直接取值');

    GetInt64(Serverdata, sqlInt64);
  finally
   CoUninitialize;
   leaveCriticalSection(cs);
  end;
end;


//合并消费数据
function ThreadMegerCounsume( Serverdata: Pserverdata):DWORD; stdcall;overload;
var
  date: tdate;
  SumReChange, SumMonthOnline, SumMonthPayUser, SumMonthARPU, SumMonthRegister: integer;
  TempServer: Pserverdata;
begin
  try
  entercriticalsection(cs);
  CoInitialize(nil);
  Serverdata.orderlist.Clear;
//  Serverdata.orderlist.Add(Serverdata.ServerName+'金额排名前100' + #9 + '账号' + #9 + '充值金额'+ #9 + '充值日期'+ #9 + '充值次数');
  Serverdata.ordertemp.Clear;
//  Serverdata.ordertemp.Add('单次充值5000RMB及以上账号' + #9 + '充值金额'+ #9 + '充值日期'+ #9 + '平台');

  ExeSql(Serverdata, sqlorder50);
//  Getorder(Serverdata, sqlorder5000);

  finally
   CoUninitialize;
   leaveCriticalSection(cs);

  end;

end;



function ThreadGetOrderlist( Serverdata: Pserverdata):DWORD; stdcall;overload;
var
  date: tdate;
  SumReChange, SumMonthOnline, SumMonthPayUser, SumMonthARPU, SumMonthRegister: integer;
  TempServer: Pserverdata;
begin
  try
  entercriticalsection(cs);
  CoInitialize(nil);
  Serverdata.orderlist.Clear;
//  Serverdata.orderlist.Add(Serverdata.ServerName+'金额排名前100' + #9 + '账号' + #9 + '充值金额'+ #9 + '充值日期'+ #9 + '充值次数');
  Serverdata.ordertemp.Clear;
//  Serverdata.ordertemp.Add('单次充值5000RMB及以上账号' + #9 + '充值金额'+ #9 + '充值日期'+ #9 + '平台');

  Getorder(Serverdata, sqlorder50);
//  Getorder(Serverdata, sqlorder5000);

  finally
   CoUninitialize;
   leaveCriticalSection(cs);

  end;

end;


function GetSumData( Serverdata: Pserverdata):DWORD; stdcall;
var
  date: tdate;
  DayAVGonline:Integer;
  SumReChange, SumMonthOnline, SumMonthPayUser, SumMonthARPU, SumMonthRegister: integer;
begin
  entercriticalsection(cs);
  CoInitialize(nil);
  try
    date := strtodate(QueryStartDate);
    Serverdata.SumText.Add(Serverdata.ServerName + #9 + '月流水' + #9 + '日最大平均在线'+ #9 + '月付费用户'+ #9 + '月ARPU'+ #9 +'月底注册用户数'+ #9 +'日平均在线数');
//    Serverdata.SumText.Add(Serverdata.ServerName + #9 + '月流水' + #9 + '月均在线');

    while date < now do
    begin
     Application.ProcessMessages;
     SumReChange := MonthRechange(Serverdata, date);
     SumMonthOnline:= MonthOnline(Serverdata, date);
     SumMonthPayUser := MonthPayUsers(Serverdata, date);
     SumMonthARPU := DivZero(SumReChange,SumMonthPayUser);
     SumMonthRegister := MonthRegister(Serverdata, date);
     DayAVGonline := MonthAVGOnline(Serverdata, date);
  //  entercriticalsection(cs);
  //  CoInitialize(nil);
  //   Serverdata.SumText.Add(formatdatetime('YYYY年MM月', date) + #9 + inttostr(SumReChange)+ #9 + inttostr(SumMonthOnline));
     Serverdata.SumText.BeginUpdate;
     Serverdata.SumText.Add(formatdatetime('YYYY年MM月', date) + #9 + inttostr(SumReChange)+ #9 + inttostr(SumMonthOnline)+ #9 + inttostr(SumMonthPayUser)+ #9 + inttostr(SumMonthARPU) + #9 + inttostr(SumMonthRegister)+ #9 + inttostr(DayAVGonline));
//     Serverdata.SumText.Add(formatdatetime('YYYY年MM月', date) + #9 + inttostr(SumReChange)+ #9 + inttostr(SumMonthOnline));
     Serverdata.SumText.EndUpdate;

     date := IncMonth(date, 1);
  //   ICount := ICount + 1;
  //   form1.caption := format(strCaption, [ICount, AllCount]);
  //   form1.pb2.Position := Icount;
  //   if ICount = AllCount then  form1.btn16.enabled := true;

    end;
  finally
    CoUninitialize;
    leaveCriticalSection(cs);
  end;


end;


procedure TForm1.ReadServerTOlist;
var
  ExcelApp,workbook,sheet:Variant;
  iRow, iCol, Rows :integer;
  Bselect : Boolean;
  I: Integer;
  stemp :string;
  ServerData :PserverData;
begin
  try
    ExcelApp:=UnAssigned();
    ExcelApp := CreateOleObject('Excel.application');
    ExcelApp.WorkBooks.Open(lbledt4.Text);
    ExcelApp.Visible := false;
    Sheet := ExcelApp.Sheets[1];
    Rows:=ExcelApp.ActiveSheet.UsedRange.Rows.Count;
    ClearServerlist;
    pb2.Max := Rows;
    pb2.Position := 0;
    for I := 2 to Rows do
    begin
      stemp := Sheet.cells[I,3].value;
      if trim(stemp)= '' then continue;

      new(ServerData);
      ServerData.ServerName := Sheet.cells[I,1].value;
      ServerData.SessionIP := Sheet.cells[I,2].value;
      ServerData.LogIP := Sheet.cells[I,3].value;
      ServerData.LogDB := Sheet.cells[I,4].value;
      ServerData.SessionDB := Sheet.cells[I,5].value;
      ServerData.spid := Sheet.cells[I,6].value;
      ServerData.MinServerID := Sheet.cells[I,7].value;
      ServerData.MaxServerID := Sheet.cells[I,8].value;
      if ServerData.spid = '_qtw' then
       ServerData.rate := 0.2009
      else if ServerData.spid = '_qkr' then
       ServerData.rate := 0.005426
      else if ServerData.spid = '_qyn' then
       ServerData.rate := 0.0002873
      else
       ServerData.rate := 1;


      if trim(ServerData.LogIP)='192.168.0.203' then
        ServerData.BOffLine := true
      else
        ServerData.BOffLine := false;
      ServerData.SumText := tstringlist.Create;
      ServerData.SessionCon := tsqlconnection.Create(nil);
      ServerData.orderlist := tstringlist.Create;
      ServerData.orderTemp := tstringlist.Create;

      ServerData.SessionCanUse := ConnectionSessionDB(ServerData.SessionCon,ServerData);

      ServerData.LogCon := tsqlconnection.Create(nil);
      ServerData.LogCanUse := ConnectionLogDB(ServerData.LogCon,ServerData);
      ServerData.SQ := tsqlquery.Create(nil);

      ServerList.AddObject(ServerData.ServerName,tobject(ServerData));
      pb2.Position := pb2.Position + 1;
      application.ProcessMessages;
    end;
    pb2.Position := pb2.Max;
  except
   on e:exception do
   showmessage('ReadServerTOlist' + e.Message);
  end;
    ExcelApp.ActiveWorkBook.Saved := True;
    ExcelApp.ActiveWorkBook.Close;
    Sheet := unassigned;
    ExcelApp.quit;
    ExcelApp := unassigned;
end;


function  TForm1.GetMyPath(SourStr:string):string;
var
 itemp: integer;
begin
  if trim(SourStr)='' then result :='';;
  result := StringReplace(SourStr, '"', '', [rfReplaceAll]);
  result := StringReplace(result, '/', '\', [rfReplaceAll]);
  itemp :=  pos( '!SC', result);
  result := trimright(result);
  result := trimleft(result);

  if itemp = 0 then
   result := ServerRootPath + result
  else
   result := ServerRootPath + copy(result, itemp + length('!SC\'), length(result)-itemp)
end;


function GetRegisterAccount(Const StartDate,EndDate:tdate):integer;
begin

end;


procedure TForm1.btn10Click(Sender: TObject);
var
 shap1 :TMyShape;
begin
 shap1.ID := 1;
 shap1.flag := true;
end;

procedure TForm1.btn11Click(Sender: TObject);
const
 stemp ='坐标点位置x:%d, y:%d' ;
var
  num: Int64;
  pt: TPoint absolute num;
  arr: array[0..1] of Integer absolute pt;
begin
  pt.X := 111;
  pt.Y := 222;
  ShowMessageFmt(stemp, [arr[0], arr[1]]);                {111, 222}
  ShowMessageFmt(stemp, [num shl 32 shr 32, num shr 32]); {111, 222}
end;

procedure TForm1.btn12Click(Sender: TObject);
const
 NoteStr = '{%d}';
var
 i, j, ic: integer;
 stemp :string;
begin
 ic := se2.value;
 stemp := '';
 for  i := 1 to mmo3.Lines.Count do
 begin
   if i mod ic =0 then
    stemp := stemp + mmo3.Lines[i-1] + edt2.Text + #13#10
   else
    stemp := stemp + mmo3.Lines[i-1] + edt2.Text;
 end;
 clipboard().AsText := stemp;
end;

procedure TForm1.btn13Click(Sender: TObject);
var
 i: integer;
begin
 for  i := 0 to mmo3.Lines.Count-1 do
 begin
   mmo3.Lines[i] := format(edt1.Text, [mmo3.Lines[i]]);
 end;
end;

procedure TForm1.btn15Click(Sender: TObject);
var
 s:string;
 p:pointer;
begin
 s := '这是一个测试的例子';
 p := @s;
 showmessage(string(p^));

end;




function GetSqlCount(const Con: TSQLConnection; SqlStr: string; Sq:tsqlquery): Integer;
var
  sStartDate, sEndDate, sSql: string;
  sqlqryTemp: TSQLQuery;
begin
  entercriticalsection(cs2);
//  CoInitialize(nil);
 try
  result := 0;
  Sq.Close;
  Sq.SQLConnection := Con;
  try
    if not Con.Connected  then Con.Connected := true;
    with Sq do
    begin
      close;
      SQL.Text := SqlStr;
      Open;
      first;
      while not eof do
      begin
       result := result + FieldByName('count').AsInteger;
       Next;
      end;
    end;
  except
   result := 0;
  end;
 finally
//  CoUninitialize;
  leaveCriticalSection(cs2);
 end;

end;



procedure TForm1.btn16Click(Sender: TObject);
var
 i: integer;
 threadid: DWORD;
begin
 try
   readservertolist;
   ICount := 0;
   // 月充值统计
   AllCount :=(MonthsBetween(strtodate(QueryStartDate), now) + 1) * ServerList.Count;
   // 付款订单
   AllCount :=2 * ServerList.Count;
   pb2.Max := allcount;
   RZLV1.Items.Clear;
   for I := 0 to ServerList.Count - 1 do
//   for I := 0 to 3 do
   begin
    with RZLV1.Items.Add do
    begin
     caption := PserverData(ServerList.Objects[I]).ServerName;
     subitems.Add(PserverData(ServerList.Objects[I]).SessionIP);
     subitems.Add(PserverData(ServerList.Objects[I]).LogIP);
     subitems.Add(PserverData(ServerList.Objects[I]).SessionDB);
     subitems.Add(PserverData(ServerList.Objects[I]).LogDB);
     subitems.Add(booltostr(PserverData(ServerList.Objects[I]).BOffLine,true));
     subitems.Add(booltostr(PserverData(ServerList.Objects[I]).SessionCanUse,true));
     subitems.Add(booltostr(PserverData(ServerList.Objects[I]).LogCanUse,true));
     PserverData(ServerList.Objects[I]).SumText.Clear;
     Data := PserverData(ServerList.Objects[I]);
     ThreadSql.Create(False, PserverData(ServerList.Objects[I]));

     //月数据统计
//     CreateThread( nil, 0, @GetSumData, PserverData(ServerList.Objects[I]), 0, threadid);
//     GetSumData(PserverData(ServerList.Objects[I]));
//     Form1.Caption := Format('[%d / %d]', [i+1,ServerList.Count])
//   充值查询
//     CreateThread( nil, 0, @ThreadGetOrderlist, PserverData(ServerList.Objects[I]), 0, threadid);
//   测试int64
//     CreateThread( nil, 0, @Testint64, PserverData(ServerList.Objects[I]), 0, threadid);

     //充值金额前100名
//     ThreadGetOrderlist(PserverData(ServerList.Objects[I]));
//合并用户消费数据
     ThreadMegerCounsume(PserverData(ServerList.Objects[I]));
//     self.caption :=format(cStr, [inttostr(I + 1), 24, 24]);
    end;
   end;
 except on E: Exception do
   showmessage('btn16Click' + e.Message);
 end;
   showmessage('完成');


end;


procedure TForm1.btn17Click(Sender: TObject);
var
 i, j :integer;
 sTemp: string;
begin
  for i := 0 to serverlist.Count -1 do
  begin
//月充值信息
   sTemp := sTemp + PserverData(ServerList.Objects[I]).SumText.Text + #13#10;
//   sTemp := sTemp + PserverData(ServerList.Objects[I]).orderlist.Text
//   sTemp := sTemp + PserverData(ServerList.Objects[I]).ordertemp.Text + #13#10;
  end;
  Clipboard().AsText := sTemp;
//
//  showmessage('请保存信息');
//  sTemp :='';
//  for i := 0 to serverlist.Count -1 do
//  begin
////月充值信息
//   sTemp := sTemp + PserverData(ServerList.Objects[I]).SumText.Text + #13#10;
////   sTemp := sTemp + PserverData(ServerList.Objects[I]).orderlist.Text + #13#10;
////   sTemp := sTemp + PserverData(ServerList.Objects[I]).ordertemp.Text + #13#10;
//  end;
//  Clipboard().AsText := sTemp;
  showmessage('请保存信息');

end;


procedure TForm1.btn18Click(Sender: TObject);
var
  png: TPngImage;
begin
  png := TPngImage.Create;
//  png.LoadFromFile('D:\work\program\521g\tcgp\trunk\AnHei\tools\Launcher\Release\config\main1.png');
  png.LoadFromFile('D:\work\program\521g\tcgp\trunk\AnHei\tools\Launcher\Release\37\config\main1.png');
  img1.Width := png.Width;
  img1.Height := png.Height;
  img1.Picture.Assign(png);
  form1.ClientWidth := png.Width;
  form1.ClientHeight := png.Height;

  caption := format('宽%d:高%d', [png.Width, png.Height] );
  Canvas.Draw(0, 0, png);
  png.Free;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
 i, itemp: integer;
 newpath, strTemp: string;
 pathList: TStringList;
begin
 pathList := TStringList.Create;
 pathList.Sorted := True;
 pathList.Duplicates := dupIgnore;

 for i := 0 to mmo1.Lines.Count -1 do
 begin
  pathList.Add(GetMyPath(mmo1.Lines[i]));
 end;
 mmo1.Text := pathList.Text;

 pathList.Clear;
 if chkUpdate.Checked then
 begin
   for i := 0 to mmo1.Lines.Count -1 do
   begin
     pathList.Add(ExtractFilePath(mmo1.Lines[i]))
   end;
   SvnUpdateFile(pathList.Text);
 end;
 SvnCommitFile(mmo1.Text, '');

 pathList.Clear;
 for i := 0 to mmo1.Lines.Count -1 do
 begin
  newpath := mmo1.Lines[i];
  newpath :=  StringReplace(newpath, ServerPath[0], ServerPath[cbbCbTarget.ItemIndex], [rfReplaceAll]);
  CopyFile(PChar(mmo1.Lines[i]), PChar(newpath), False );
//  showmessage(lbledt2.Text + mmo1.Lines[i] +#13#10 + ' ->'  +newpath);
  pathList.Add(newpath);
 end;

 if chkcommit.Checked then
 begin
   SvnCommitFile(pathList.Text, lbledt1.Text);
 end;
end;

procedure TForm1.取得转生等级(Sender: TObject);
var
 i: Integer;
begin
 for  i := 1 to se4.Value do
 begin
   mmo3.Lines.Add(edt5.Text);
 end;

end;

procedure TForm1.btn22Click(Sender: TObject);
var
 i,itemp:Integer;
begin
//      cells[8,iCount] := IntToStr(LoWord(FieldByName('charlevel').AsInteger));
//      cells[9,iCount] := IntToStr(HiWord(FieldByName('charlevel').AsInteger));
 for  i := 0 to mmo3.Lines.Count-1 do
 begin
  itemp := StrToInt(mmo3.Lines[i]);
  mmo3.Lines[i] := Format('%d转%d级',[HiWord(itemp),LoWord(itemp)])
 end;

end;

procedure TForm1.btn23Click(Sender: TObject);
var
 i,itemp: Integer;
begin
 for  i := 0 to mmo3.Lines.Count-1 do
 begin
  Application.ProcessMessages;
  try
   itemp := StrToInt(mmo3.Lines[i]);
   mmo3.Lines[i] :=inet_ntoa(in_addr(itemp));
  except
   Continue;
  end;
 end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
 pathList: TStringList;
 strPath: string;
 i: Integer;
begin

 pathList := TStringList.Create;
 pathList.Sorted := True;
 pathList.Duplicates := dupIgnore;

  for i := 0 to mmo2.Lines.Count -1 do
  begin
   pathList.Add(mmo2.Lines[i]) ;
  end;

  SvnCommitFile(pathList.Text, '');
  pathList.Free;
end;


procedure TForm1.btn3Click(Sender: TObject);
var
 pathList: TStringList;
 strPath: string;
 i: Integer;
begin

 pathList := TStringList.Create;
 pathList.Sorted := True;
 pathList.Duplicates := dupIgnore;


  for i := 0 to mmo2.Lines.Count -1 do
  begin
   pathList.Add(ExtractFilePath(mmo2.Lines[i])) ;
  end;
   SvnUpdateFile(pathList.Text);
 pathList.Free;
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
 openOA(se1.Value, oaview);
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
 openOA(se1.Value, oaedit);
end;

procedure TForm1.btn6Click(Sender: TObject);
var
 i: integer;
begin
 for  i := 0 to mmo3.Lines.Count-1 do
 begin
   mmo3.Lines[i] :=  GetStrBetweenChar(mmo3.Lines[i], edtCh.Text, edtCh1.Text);
 end;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
if chk1.Checked then HandleMemo(mmo3, #13#10, '');
if chk2.Checked then HandleMemo(mmo3, ' ', '');
//if chk4.Checked then
if chk5.Checked then MemoAddIndex(mmo3,':');

end;

procedure TForm1.btn8Click(Sender: TObject);
var
 i, j :integer;
 sTemp: string;
begin
//  for i := 0 to RZLVServerlist.Columns.Count -1 do
//  begin
//   sTemp := stemp + RZLVServerlist.Columns[i].Caption + #9;
//  end;
//  sTemp := sTemp + #10 ;
//
//  for i := 0 to RZLVServerlist.Items.Count -1 do
//  begin
//    sTemp := sTemp + RZLVServerlist.Items[i].Caption + #9;
//    for j := 0 to   RZLVServerlist.Items[i].SubItems.Count -1 do
//    begin
//     sTemp := stemp + RZLVServerlist.Items[i].SubItems[j] + #9;
//    end;
//    sTemp := sTemp + #10
//  end;

  for I := 0 to ServerList.Count - 1 do
  begin
   sTemp := sTemp + PserverData(ServerList.Objects[I]).SumText.Text;
  end;


 Clipboard().AsText := sTemp;

end;

procedure TForm1.btn9Click(Sender: TObject);
var
 exitCode: dword;
begin
 getexitcodethread(hThread, exitcode);
 text := format(SthreadExit, [exitcode])
end;

procedure TForm1.btnGetServerClick(Sender: TObject);
begin
// if ConnectionSC(con1,'61.160.241.111' ) then
// showmessage('yes');
//  LoadServerList;
//  CalcAdd;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 svalue :string;
 ivalue :Int64;
begin
  ConnectionSessionDB(con1, '192.168.0.203');
  sqlqry1.Close;
  sqlqry1.SQL.Text := Format(sqlInt64, ['358wan']);
  sqlqry1.Open;
  svalue := sqlqry1.FieldByName('value').AsString;
  ivalue := sqlqry1.FieldByName('value').AsInteger;
  ivalue := sqlqry1.FieldByName('value').Value;
  ShowMessage(svalue);
  sqlqry1.Close;

end;

function TForm1.GetSqlCount(Const Sql:string; Const StartDate,endDate:Tdate):Integer;
var
  sStartDate, sEndDate, sSql: string;

begin
  sStartDate := formatdatetime('YYYY-MM-DD 00:00:00', StartDate);
  sEndDate := formatdatetime('YYYY-MM-DD 23:59:59', endDate);
  sSql := format(Sql, [sStartDate, sEndDate]);
  if Sql = sqlRegister then
     sSql := sSql + sqlRegister1;
  application.ProcessMessages;
  try
    if not con1.Connected then con1.Connected := true;
    result := 0;
    with sqlqry1 do
    begin
      close;
      SQL.Text := sSql;
//      showmessage(sSql);
      Open;
      result := FieldByName('count').AsInteger;
    end;
  except
    on e:exception do
    begin
     result := 0;
//     showmessage(e.message);
    end;
  end;
end;

procedure TForm1.CalcRMBUser(var nlist:TListItem);
var
  startdate, enddate :Tdate;
  icount :integer;
begin
   // 2012年充值用户
  startdate := strtodate('2012-01-01');
  enddate := endoftheyear(startdate);
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第一季度
  startdate := strtodate('2012-01-01');
  enddate := strtodate('2012-03-31');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第二季度
  startdate := strtodate('2012-04-01');
  enddate := strtodate('2012-06-30');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第三季度
  startdate := strtodate('2012-07-01');
  enddate := strtodate('2012-09-30');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第四季度
  startdate := strtodate('2012-10-01');
  enddate := strtodate('2012-12-31');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
 // 2013年第一季度
  startdate := strtodate('2013-01-01');
  enddate := strtodate('2013-03-31');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2013年第二季度
  startdate := strtodate('2013-04-01');
  enddate := strtodate('2013-06-30');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2013年第三季度
  startdate := strtodate('2013-07-01');
  enddate := strtodate('2013-09-30');
  iCount:= GetSqlCount(sqlRMBUser, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));

end;


procedure TForm1.CalcARPU(var nlist:TListItem; Rate:byte);
var
  startdate, enddate :Tdate;
  icount, TotalMoney, TotalOrder, iarpu :integer;
begin
   // 2012年充值用户
  startdate := strtodate('2012-01-01');
  enddate := endoftheyear(startdate);
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2012年第一季度
  startdate := strtodate('2012-01-01');
  enddate := strtodate('2012-03-31');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2012年第二季度
  startdate := strtodate('2012-04-01');
  enddate := strtodate('2012-06-30');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2012年第三季度
  startdate := strtodate('2012-07-01');
  enddate := strtodate('2012-09-30');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2012年第四季度
  startdate := strtodate('2012-10-01');
  enddate := strtodate('2012-12-31');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
 // 2013年第一季度
  startdate := strtodate('2013-01-01');
  enddate := strtodate('2013-03-31');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2013年第二季度
  startdate := strtodate('2013-04-01');
  enddate := strtodate('2013-06-30');
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));
  // 2013年第三季度
  startdate := strtodate('2013-07-01');
  enddate := now();
  TotalMoney:= GetSqlCount(sqlTotalMoney, startdate, enddate);
  TotalOrder:= GetSqlCount(sqlTotalOrder, startdate, enddate);
  iarpu :=DivZero(TotalMoney, TotalOrder)div Rate;
  nlist.SubItems.Add(inttostr(iarpu));

end;



procedure TForm1.CalcRegister(var nlist:TListItem);
var
  startdate, enddate :Tdate;
  icount :integer;
  StrSessionIP : string;
begin
   StrSessionIP := nlist.SubItems[0];
   // 2012年注册用户数
  startdate := strtodate('2012-01-01');
  enddate := endoftheyear(startdate);
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第一季度
  startdate := strtodate('2012-01-01');
  enddate := strtodate('2012-03-31');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第二季度
  startdate := strtodate('2012-04-01');
  enddate := strtodate('2012-06-30');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第三季度
  startdate := strtodate('2012-07-01');
  enddate := strtodate('2012-09-30');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2012年第四季度
  startdate := strtodate('2012-10-01');
  enddate := strtodate('2012-12-31');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
 // 2013年第一季度
  startdate := strtodate('2013-01-01');
  enddate := strtodate('2013-03-31');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2013年第二季度
  startdate := strtodate('2013-04-01');
  enddate := strtodate('2013-06-30');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));
  // 2013年第三季度
  startdate := strtodate('2013-07-01');
  enddate := strtodate('2013-09-30');
  iCount:= Form1.GetSqlCount(sqlRegister, startdate, enddate);
  nlist.SubItems.Add(inttostr(iCount));

end;

// 计算活跃用户
procedure TForm1.CalcActiveUser(var nlist:TListItem; logip:string);
var
  startdate, enddate :Tdate;
  icount, isum, iday :integer;
begin

//  2013年第一季度
//  startdate := strtodate('2013-01-01');
//  enddate := strtodate('2013-01-03');
//  icount := 0;  isum := 0; iday := 0;
//  while startdate <=  enddate do
//  begin
//   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
//   startdate := incday(startdate,1) ;
//   isum := isum + iCount;
//   iday := iday + 1;
//  end;
//  isum := isum div iday;
//  nlist.SubItems.Add(inttostr(isum));
//  exit;


   // 2012年活跃用户
  startdate := strtodate('2012-01-01');
  enddate := endoftheyear(startdate);
  icount := 0;  isum := 0; iday :=0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday +1;
   caption := format(cStr, ['2012年活跃用户',iday,DaysInAYear(2012)]);
  end;
  isum := isum div DaysInAYear(2012);
  nlist.SubItems.Add(inttostr(isum));

  // 2012年第一季度
  startdate := strtodate('2012-01-01');
  enddate := strtodate('2012-03-31');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;

   caption := format(cStr, ['2012年第一季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));

  // 2012年第二季度
  startdate := strtodate('2012-04-01');
  enddate := strtodate('2012-06-30');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2012年第二季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));

  // 2012年第三季度
  startdate := strtodate('2012-07-01');
  enddate := strtodate('2012-09-30');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2012年第三季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));
  // 2012年第四季度
  startdate := strtodate('2012-10-01');
  enddate := strtodate('2012-12-31');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2012年第四季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));
//  2013年第一季度
  startdate := strtodate('2013-01-01');
  enddate := strtodate('2013-03-31');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2013年第一季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));
  // 2013年第二季度
  startdate := strtodate('2013-04-01');
  enddate := strtodate('2013-06-30');
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2013年第二季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));
  // 2013年第三季度
  startdate := strtodate('2013-07-01');
  enddate := now();
  icount := 0;  isum := 0; iday := 0;
  while startdate <=  enddate do
  begin
   iCount:= GetSqlCount(sqlActiveUser, startdate, startdate);
   startdate := incday(startdate,1) ;
   isum := isum + iCount;
   iday := iday + 1;
   caption := format(cStr, ['2013年第三季度',iday,DaysBetween(enddate,startdate)]);
  end;
  isum := isum div iday;
  nlist.SubItems.Add(inttostr(isum));

end;


procedure TForm1.CalcAdd();
var
  nlist: TListItem;
  i , j, iSum, itemp: integer;
begin
  nlist := RZLVServerlist.Items.Add;
//  nlist.Caption := '总注册用户';
//  nlist.Caption := '总活跃用户';
//  nlist.Caption := '总充值用户';
  nlist.Caption := '总ARPU';

  for i := 0 to RZLVServerlist.Columns.Count -2 do
  begin
   iSum := 0;
   itemp := 0;
   for j := 0 to RZLVServerlist.Items.Count -2 do
   begin
    if i > RZLVServerlist.Items[j].SubItems.Count -1 then
    break;

    try
     itemp := strtoint(RZLVServerlist.Items[j].SubItems[i]);
    except
     itemp := 0;
    end;
    iSum := isum + itemp;
   end;
   nlist.SubItems.Add(inttostr(iSum));
  end;
end;

function test(p:pointer):integer;stdcall;
var
  startdate, enddate :Tdate;
  icount :integer;
  nlist: tlistitem;
  StrSessionIP :string;
  procedure AddCountItem();
  begin
    nlist.SubItems.Add(inttostr(iCount));

//    nlist.SubItems.Add(inttostr(MilliSecondOf(now())));
  end;
begin
//  entercriticalsection(cs);

  nlist := tlistitem(p);
  StrSessionIP := nlist.SubItems[0];

  // 2012年注册用户数
  startdate := strtodate('2012-01-01');
  enddate := endoftheyear(startdate);
  iCount:= GetSqlCount2(StrSessionIP, sqlRegister, startdate, enddate);
  AddCountItem;
  // 2012年第一季度
  startdate := strtodate('2012-01-01');
  enddate := strtodate('2012-03-31');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
  // 2012年第二季度
  startdate := strtodate('2012-04-01');
  enddate := strtodate('2012-06-30');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
  // 2012年第三季度
  startdate := strtodate('2012-07-01');
  enddate := strtodate('2012-09-30');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
  // 2012年第四季度
  startdate := strtodate('2012-10-01');
  enddate := strtodate('2012-12-31');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
 // 2013年第一季度
  startdate := strtodate('2013-01-01');
  enddate := strtodate('2013-03-31');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
  // 2013年第二季度
  startdate := strtodate('2013-04-01');
  enddate := strtodate('2013-06-30');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
  // 2013年第三季度
  startdate := strtodate('2013-07-01');
  enddate := strtodate('2013-09-30');
  iCount:= GetSqlCount2(StrSessionIP,sqlRegister, startdate, enddate);
  AddCountItem;
//  showmessage(stemp);
//  leaveCriticalSection(cs);

end;




procedure TForm1.LoadServerList;
var
  I,J,n,iCount, irate: Integer;
  Threadid: dword;
  sBonusKey,tmpXML, spD, serverName, SessionIP, logIP: string;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  GroupList,NodeList: IXMLDomNodeList;
  startdate, enddate :Tdate;
  Temp :dword;
begin
  iname := 0;
  tmpXML := GetHttpXML(lbledt3.text);
  if trim(tmpXML) = '' then
  begin
    showmessage('无法猎取SeverList');
    exit;
  end;
  xmlDoc := CoDOMDocument.Create();
  try
    if xmlDoc.loadXML(tmpXML) then
    begin
      xmlNode := xmlDoc.documentElement;
      GroupList := xmlNode.selectNodes('//Group');
//创建信号
      CloseHandle(hSemaphore);
      hSemaphore := createsemaphore(nil, GroupList.length, GroupList.length, nil);
      for n := 0 to GroupList.length - 1 do
//      for n := 0 to 1 do
      begin
        NodeList := GroupList.item[n].selectNodes('Server');
        serverName := GroupList.item[n].attributes.getNamedItem('name').nodeValue;
        if pos('真武', serverName) > 1 then continue;
        if NodeList.length >=1 then
        SessionIP := NodeList.item[0].attributes.getNamedItem('ss').nodeValue;
        nlist := RZLVServerlist.Items.Add;
        nlist.Caption := serverName;
        nlist.SubItems.Add(SessionIP);
        if pos('q57', serverName) > 1 then
         logIP := '61.160.254.150'
        else if pos('q26', serverName) > 1 then
         logIP := '61.160.254.158'
        else if pos('JUU', serverName) > 1 then
         logIP := '61.160.254.166'
        else if pos('g2', serverName) > 1 then
         logIP := '61.160.254.160'
        else if pos('游戏多', serverName) > 1 then
         logIP := '61.160.254.167'
        else if pos('真武', serverName) > 1 then
        begin
         logIP := '61.160.254.177'
        end
        else if pos('7711', serverName) > 1 then
         logIP := '61.160.254.176'
        else if pos('台服', serverName) > 1 then
         logIP := '203.75.237.101'
        else if pos('qyz', serverName) > 1 then
         logIP := '203.223.159.138'
        else if pos('嬉戏族', serverName) > 1 then
         logIP := '61.160.243.149'
        else
         logIP := 'Unknow';

        if (pos('台服', serverName) > 1) or (pos('qyz', serverName) > 1) then
         irate := 2
        else
         irate := 10;


        nlist.SubItems.Add(logIP);
        if ConnectionSessionDB(con1, SessionIP) then
        begin
          nlist.SubItems.Add('在线');
          caption := '正在计算' + inttostr(N+1) +'/' + inttostr(GroupList.length);
          // 计算注册用户
//          Temp := @nlist;
//          test(Temp);
//          showmessage(inttostr(integer(nlist)));
          CreateThread(nil, 0, @test, nlist, 0, Threadid);


          // 计算充值用户
//           CalcRMBUser(nlist);
//           计算ARPU
//        CalcARPU(nlist, irate));  ;
        end
//        if ConnectionLogDB(con1, logIP) then
//        begin
//          nlist.SubItems.Add('在线');
//          // 计算注册用户
//          caption := '正在计算' + inttostr(N+1) +'/' + inttostr(GroupList.length);
//          CalcActiveUser(nlist, logIP);
//        end

        else
          nlist.SubItems.Add('离线');

      end;
    end;
  finally
    xmlDoc := nil;
    showmessage('猎取SeverList 成功');
  end;
end;

procedure TForm1.createparams(var params: TCreateParams);
begin
 inherited;
// params.Style:= params.Style or WS_MAXIMIZE;//{实现窗体最大化}
// params.Style:= params.Style and (not WS_THICKFRAME);// {取消窗体放大缩小的拖曳功能}
//  params.Style:= params.Style and (not WS_CAPTION); //取消标题栏
//  params.ExStyle:= params.ExStyle or (WS_EX_CLIENTEDGE);   {实现阴影效果}
//  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW; // 让窗体出现在任务栏上
//  Params.Style := Params.Style or WS_SYSMENU or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
//  Params.EXStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
//  Params.WndParent := GetDesktopWindow;
end;

procedure TForm1.Doinit();
begin
iniServerFile();
end;

procedure TForm1.edt3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin


//  img1.ScreenToClient()
end;

procedure TForm1.edt4KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = word(#13) then
  wb1.Navigate(edt4.Text);
end;

function GetSqlCount2(const StrSessionIP: string; const Sql: string;
  const StartDate, endDate: Tdate): Integer;
var
  sStartDate, sEndDate, sSql: string;
  conTemp: TSQLConnection;
  sqlqryTemp: TSQLQuery;
begin
//  entercriticalsection(cs);
  result := 0;
//  if WaitForSingleObject(hMutex, INFINITE) = WAIT_OBJECT_0 then
  if WaitForSingleObject(hSemaphore, INFINITE) = WAIT_OBJECT_0 then
  begin
    sStartDate := formatdatetime('YYYY-MM-DD 00:00:00', StartDate);
    sEndDate := formatdatetime('YYYY-MM-DD 23:59:59', endDate);
    sSql := format(Sql, [sStartDate, sEndDate]);
    if Sql = sqlRegister then  sSql := sSql + sqlRegister1;

    conTemp := TSQLConnection.Create(nil);
//    conTemp.Name := 'TSQLConnection' + inttostr(iname);
    sqlqryTemp := TSQLQuery.Create(nil);
//    sqlqryTemp.Name := 'TSQLQuery' + inttostr(iname);
    iname := iname +1;
    sqlqryTemp.SQLConnection := conTemp;
//    showmessage(inttostr(Integer(@conTemp)) + inttostr(integer(@sqlqryTemp)));
    try
      ConnectionSessionDB(conTemp, StrSessionIP);
      if not conTemp.Connected then conTemp.Connected := true;
      result := 0;
      with sqlqryTemp do
      begin
        close;
        SQL.Text := sSql;
        Open;
        result := FieldByName('count').AsInteger;
      end;
    except
      on e:exception do
      begin
       result := 0;
      end;
    end;
// result := iname;
// result := MilliSecondOfTheYear(now);
   freeandnil(conTemp);
   freeandnil(sqlqryTemp);

   ReleaseSemaphore(hSemaphore, 1, nil)
//   ReleaseMutex(hMutex);
  end;

//  leaveCriticalSection(cs);

end;




function TForm1.GetStrBetweenChar(Const SourceStr:string; StartCh, endCh: string):string;
var
 i1, i2, iScount, iECount :word;
 BspecialStart, BSpecialEnd: boolean;
begin
 result := '';
 BspecialStart := false;
 BSpecialEnd := false;

 if StartCh = '\s' then
 begin
  i1 := 0;
  BspecialStart := true;
  iScount := 1;
 end
 else
 begin
  i1 := Ansipos(StartCh, SourceStr);
  iScount := length(StartCh);
 end;


 if endCh = '\e' then
 begin
   i2 := length(SourceStr);
   BSpecialEnd := true;
   iECount := 1;
 end
 else
 begin
  i2 := Ansipos(endCh, SourceStr);
  iECount := length(endCh);
 end;

 if (not BspecialStart) and (i1 = 0)then exit;
 if (not BSpecialEnd) and (i2 = 0)then exit;



 if i2 <= i1  then  exit;
 if BSpecialEnd then
  result := copy(SourceStr, i1 + iScount, i2 - i1 -iScount + 1)
 else
  result := copy(SourceStr, i1 + iScount, i2 - i1 -iScount);
end;


procedure TForm1.MemoAddIndex(var SourceMemo: tmemo; ConnectionStr:string);
var
 tempList: tstringlist;
 i, iindex: integer;
 tempStr: string;
begin
 if trim(SourceMemo.Text)= '' then exit;
 tempList := tstringlist.Create;
 iindex := se3.Value;
 try
   for i := 0 to SourceMemo.Lines.Count - 1 do
   begin
    tempStr := SourceMemo.Lines[i];

    tempStr := inttostr(iindex) + ConnectionStr + tempStr;
    Inc(iindex);
    tempList.Add(tempStr);
   end;
   SourceMemo.Text := tempList.Text;
 finally
   tempList.Free;
 end;
end;


procedure TForm1.HandleMemo(var SourceMemo: tmemo; sourceStr, tartgetStr:string);
var
 tempList: tstringlist;
 i: integer;
 tempStr: string;
begin
 if trim(SourceMemo.Text)= '' then exit;
 tempList := tstringlist.Create;

 try
   for i := 0 to SourceMemo.Lines.Count - 1 do
   begin
    tempStr := SourceMemo.Lines[i];
    if (sourceStr= #13#10) and (trim(tartgetStr)='')  then
     if trim(tempStr) = '' then continue;
    if (trim(sourceStr)='') and (trim(tartgetStr)='')  then
    begin
     tempStr := stringreplace(tempStr, ' ', '', [rfreplaceall]);
     tempStr := stringreplace(tempStr, #9, '', [rfreplaceall]);

    end;
    tempStr := stringreplace(tempStr, sourceStr, tartgetStr, [rfreplaceall]);
    tempList.Add(tempStr);
   end;
   SourceMemo.Text := tempList.Text;
 finally
   tempList.Free;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
 if ParamCount >= 1 then
 begin
  if ParamCount =1 then
    openOA(StrToInt(ParamStr(1)), oaview)
  else if ParamStr(1)='e' then
    openOA(StrToInt(ParamStr(2)), oaedit)
  else
  if ParamStr(1)='v' then
    openOA(StrToInt(ParamStr(2)), oaview);

  Application.Terminate;
 end;
 iname := 0;
 Doinit();
 InitializeCriticalSection(cs);
 InitializeCriticalSection(cs2);
 InitializeCriticalSection(cs3);
 wb1.silent := true;

 hMutex := CreateMutex(nil, False, nil);
 ServerList := tstringlist.Create;
 Orderlist :=  tstringlist.Create;


end;

procedure TForm1.ClearServerlist;
var
  I: Integer;
begin
  try
    for I := 0 to ServerList.Count - 1 do
    begin
      freeandnil(PserverData(ServerList.Objects[I]).SumText);
      freeandnil(PserverData(ServerList.Objects[I]).orderlist);
      freeandnil(PserverData(ServerList.Objects[I]).orderTemp);

      freeandnil(PserverData(ServerList.Objects[I]).SessionCon);
      freeandnil(PserverData(ServerList.Objects[I]).LogCon);
      freeandnil(PserverData(ServerList.Objects[I]).SQ);
      System.DisPose(PserverData(ServerList.Objects[I]));
    end;
    ServerList.Clear;
  except
   on e:exception do
   showmessage('ClearServerlist' + e.Message);
  end;
end;

procedure TForm1.ClearOrderlist;
var
  I: Integer;
begin
  try
    for I := 0 to Orderlist.Count - 1 do
    begin
      System.DisPose(Porderinfo(ServerList.Objects[I]));
    end;
    Orderlist.Clear;
  except
   on e:exception do
   showmessage('ClearOrderlist' + e.Message);
  end;
end;



procedure TForm1.FormDestroy(Sender: TObject);
begin
 DeleteCriticalSection(cs);
 DeleteCriticalSection(cs2);
 DeleteCriticalSection(cs3);

 CloseHandle(hMutex);
 CloseHandle(hsemaPhore);
 ClearServerlist;
 ServerList.Free;
 Clearorderlist;
 orderList.Free;

end;

procedure TForm1.FormHide(Sender: TObject);
begin
 trycn1.ShowBalloonHint;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   wb1.Navigate(edt4.Text);
      AnimateWindow(Self.Handle, 300, 6);
end;

procedure TForm1.img1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  edt3.Text := format('%d:%d',[x, y])
end;

procedure TForm1.iniServerFile();
var
 s: string;
begin

 cbbCbTarget.Items.Clear;

 for s in Servertype do
 begin
  cbbCbTarget.Items.Add(s);
 end;
 cbbCbTarget.ItemIndex := 0;
end;


procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  mmo2.Text := ServerRootPath + ServerLanPath[cbbCbTarget.ItemIndex];
  btn3Click(nil);
  btn2click(nil);
end;

procedure TForm1.mmo3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key = ord('A'))  and (ssCtrl in Shift)  then
 (sender as TMemo).SelectAll;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  mmo1.Text := ServerLanPath[cbbCbTarget.ItemIndex];
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  mmo2.Text := 'D:\work\program\521g\idgp\AnHei\!SC\tools\AHXYAddtion\AHXYEditor.map' + #13#10
              +'D:\work\program\521g\idgp\AnHei\!SC\tools\AHXYAddtion\AHXYEditor.exe';
  btn3Click(nil);
  btn2click(nil);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
 mmo2.Text :='D:\work\program\521g\idgp\AnHei\!SC\tools\TaskEditor\TaskEditor.exe' + #13#10
           + 'D:\work\program\521g\idgp\AnHei\!SC\tools\TaskEditor\TaskEditor.map';

 btn3Click(nil);
 btn2click(nil);
end;

procedure TForm1.N4Click(Sender: TObject);
var
 i: integer;
 strTemp: string;
 pathList: TStringList;
 TagetMemo :TMemo;
begin
 pathList := TStringList.Create;
 pathList.Duplicates := dupIgnore;

 if pgc1.ActivePageIndex = 0 then
  TagetMemo := mmo1
 else if pgc1.ActivePageIndex = 1 then
  TagetMemo := mmo2;


 pathList.Add(datetimetostr(now) + ' 修改文件如下');
 strTemp := StringReplace(TagetMemo.text, lbledt2.Text, '', [rfReplaceAll]);
 strTemp := StringReplace(strTemp, 'D:\work\program\521g\idgp\AnHei\', '', [rfReplaceAll]);
 pathList.Add(strTemp);


 pathList.Add(#13#10 + '操作步骤 ');
 i := 0;
 if pos( 'ZuoCi', TagetMemo.Text) > 0 then
 begin
   inc(i);
   pathList.Add(inttostr(i) + ': ' + '刷新NPC');
   pathList.Add('许昌 左慈');
   pathList.Add('成都 左慈');
   pathList.Add('建业 左慈');
 end;
 if pos( 'QiXiShiZhe', TagetMemo.Text) > 0 then
 begin
   inc(i);
   pathList.Add(inttostr(i) + ': ' + '刷新NPC');
   pathList.Add('荆州 节日使者');
   pathList.Add('荊州 節日使者');
 end;

 if pos( 'FunctionGoods', TagetMemo.Text) > 0 then
 begin
   inc(i);
   pathList.Add(inttostr(i) + ': ' + '刷新物品数据库');
   inc(i);
   pathList.Add(inttostr(i) + ': ' + '重新加载-扩展脚本-功能脚本');
 end;
 if pos( '.db', TagetMemo.Text) > 0 then
 begin
   inc(i);
   pathList.Add(inttostr(i) + ': ' + '重新加载语言包');
 end;


   inc(i);
   pathList.Add(inttostr(i) + ': ' + '请测试并返回bug, 若需要修改汉字描述 请 写明 将 xxx 修改为 xxx');


 Clipboard().AsText := pathList.Text;
end;



procedure TForm1.N8Click(Sender: TObject);
begin
// ShowWindow(Self.Handle, SW_SHOW);
 Self.Visible := True;
 SetForegroundWindow(Self.Handle);
end;

procedure TForm1.N9Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.OnMinsize(var msg: twmsyscommand);
begin
if msg.CmdType = SC_MAXIMIZE then
begin//此处添加对最小化事件的处理过程
    Hide();
    msg.CmdType := SC_CONTEXTHELP;
end;
inherited;
end;

{ ThreadSql }

constructor ThreadSql.Create(CreateSuspended:Boolean; serverdata1: PserverData);
begin
  inherited Create(CreateSuspended);
  serverdata := serverdata1;
  Resultlist := TStringList.Create;
  SqlQuery := TSQLQuery.Create(nil);
  SessionCon := TSQLConnection.Create(nil);
  logCon := TSQLConnection.Create(nil);
  ConnectionSessionDB(SessionCon, serverdata.SessionIP);
  ConnectionLogDB(logCon,ServerData.LogIP)
end;

destructor ThreadSql.Destroy;
begin
  inherited;
  SessionCon.Free;
  logCon.Free;
  SqlQuery.Free;
  Resultlist.Free;
end;

procedure ThreadSql.execute;
begin
  inherited;
  serverdata.SumText.Add(serverdata.ServerName + ' ' + DateTimeToStr(now))
end;

end.
