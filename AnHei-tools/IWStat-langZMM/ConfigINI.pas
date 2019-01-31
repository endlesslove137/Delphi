unit ConfigINI;

interface

uses IniFiles, Classes;

type
  TConfigINI = class(TObject)
  public
    sFileName      : string;

    sAppTitle      : string;
    sAppName       : string;
    curTipText     : string;
    ServerListXML  : string;
    ShopListXML    : string;
    ItemListXML    : string;
    TaskListXML    : string;
    LogIdentFile   : string;
    CommandFile    : string;
    MaxLevel       : Integer;
    RMBFormat      : string;
    OpenLossStat   : Boolean;
    LossSpid       : string;
    DataDisposeSpid: string;

    AutoWidth      : Integer;
    AutoHeigth     : Integer;
    DefaultWidth   : Integer;
    IW_Port        : Integer;

    MaxPageCount   : Integer;

    LossBuildTime  : string;

    EngineConnectPort: Integer;
    EngineConnectStart: Boolean;
    DelayUpholePass: string;
    LangType: Integer;

    SafetyPassPort : Integer;
    SafetyPassStart: Boolean;

    OpenSpanPK     : Boolean;
    AcrossWeek     : Integer;
    AcrossDTime    : string;
    AcrossPass     : string;
    AcrossAwardWeek : Integer;
    AcrossAwardDTime: string;
    AcrossImportDBDataRetry: Integer;
    HTType: Integer;

    CallBonusHttp  : string;

    IWBoServer: Boolean;
    IWServerSPID : string;
    IWServerIP   : string;
    IWServerPort : Integer;
    IW_SPID : string;
    IW_SID : Integer;

    constructor Create(FileName: string);
    procedure ReadINI;
    procedure WriteStringINI(Section,Ident,Value: string);
    procedure WriteIntegerINI(Section,Ident: string;Value: Integer);
    procedure WriteBooleanINI(Section,Ident: string; Value: Boolean);
    procedure WriteFloatINI(Section,Ident: string; Value: double);
  end;

var
  objINI: TConfigINI;

implementation

{ TConfigINI }

constructor TConfigINI.Create(FileName: string);
begin
  sFileName := FileName;
  ReadINI;
end;

procedure TConfigINI.ReadINI;
var
  Section,Ident: string;
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    Section := '基本设置';
    Ident := 'IW端口';
    IW_Port := FConfigINI.ReadInteger(Section,Ident,89);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IW_Port);
    Ident := '后台SPID';
    IW_SPID := FConfigINI.ReadString(Section,Ident,'vsk');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IW_SPID);
    Ident := '后台SID';
    IW_SID := FConfigINI.ReadInteger(Section,Ident,1);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IW_SID);
    Ident := '后台类型';
    HTType := FConfigINI.ReadInteger(Section,Ident,0);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,HTType);
    Ident := 'IE标题';
    sAppTitle := FConfigINI.ReadString(Section,Ident,'暗黑降魔录数据统计');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,sAppTitle);
    Ident := '服务进程名称';
    sAppName := FConfigINI.ReadString(Section,Ident,'IWDataStat');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,sAppName);

    Ident := '功能提示';
    curTipText := FConfigINI.ReadString(Section,Ident,'当前服务器：%s -> %s');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,curTipText);
    Ident := '服务器列表';
    ServerListXML := FConfigINI.ReadString(Section,Ident,'http://static.lhzs.521g.com/autoconf/admin.xml');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ServerListXML);
    Ident := '游戏最大级别';
    MaxLevel := FConfigINI.ReadInteger(Section,Ident,60);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,MaxLevel);
    Ident := '商城列表';
    ShopListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/store.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ShopListXML);
    Ident := '物品列表';
    ItemListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/stditems.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ItemListXML);
    Ident := '任务列表';
    TaskListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/stdquest.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,TaskListXML);
    Ident := '行为列表';
    LogIdentFile := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/LogIdent.txt');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LogIdentFile);

    Ident := '命令列表';
    CommandFile := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/CommandGS.txt');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,CommandFile);

    Ident := '红利接口';
    CallBonusHttp := FConfigINI.ReadString(Section,Ident,'http://127.0.0.1:8083/zjcq/%s/awd?');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,CallBonusHttp);
    Ident := 'RMB显示格式';
    RMBFormat := FConfigINI.ReadString(Section,Ident,'%.1n');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,RMBFormat);
    Ident := '流失统计时间';
    LossBuildTime := FConfigINI.ReadString(Section,Ident,'03:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LossBuildTime);
    Ident := '开启流失统计';
    OpenLossStat := FConfigINI.ReadBool(Section,Ident,False);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,OpenLossStat);
    Ident := '流失统计运商列表';
    LossSpid := FConfigINI.ReadString(Section,Ident,'wyi');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LossSpid);
    Ident := '后台数据处理运营商列表';
    DataDisposeSpid := FConfigINI.ReadString(Section,Ident,'wyi');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,DataDisposeSpid);
    Section := '图表设置';
    Ident := '图表自动宽';
    AutoWidth := FConfigINI.ReadInteger(Section,Ident,55);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AutoWidth);
    Ident := '图表自动高';
    AutoHeigth := FConfigINI.ReadInteger(Section,Ident,45);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AutoHeigth);
    Ident := '图表默认宽';
    DefaultWidth := FConfigINI.ReadInteger(Section,Ident,600);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,DefaultWidth);
    Section := '数据显示设置';
    Ident := '分页每页最大值';
    MaxPageCount := FConfigINI.ReadInteger(Section,Ident,100);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,MaxPageCount);
    Section := '安全密码接口';
    Ident := '端口';
    SafetyPassPort := FConfigINI.ReadInteger(Section,Ident,95);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,SafetyPassPort);
    Ident := '开启服务';
    SafetyPassStart := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,SafetyPassStart);
    Section := '服务端管理';
    Ident := '端口';
    EngineConnectPort := FConfigINI.ReadInteger(Section,Ident,8500);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,EngineConnectPort);
    Ident := '开启服务';
    EngineConnectStart := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,EngineConnectStart);
    Ident := '倒计时密码';
    DelayUpholePass := FConfigINI.ReadString(Section,Ident, 'xianhai');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,DelayUpholePass);
    Ident := '语言类型';
    LangType := FConfigINI.ReadInteger(Section,Ident,0);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,LangType);

    Section := '跨服战管理';
    Ident := '开启跨服战';
    OpenSpanPK := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,OpenSpanPK);
    Ident := '数据处理周';
    AcrossWeek := FConfigINI.ReadInteger(Section,Ident,7);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossWeek);
    Ident := '数据处理时间';
    AcrossDTime := FConfigINI.ReadString(Section,Ident, '00:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossDTime);
    Ident := '数据处理密码';
    AcrossPass := FConfigINI.ReadString(Section,Ident, 'zjkfz');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossPass);
    Ident := '奖励处理周';
    AcrossAwardWeek := FConfigINI.ReadInteger(Section,Ident,1);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossAwardWeek);
    Ident := '奖励处理时间';
    AcrossAwardDTime := FConfigINI.ReadString(Section,Ident, '00:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossAwardDTime);
    Ident := '失败重试次数';
    AcrossImportDBDataRetry := FConfigINI.ReadInteger(Section,Ident,2);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossImportDBDataRetry);

    Section := '后台管理中心';
    Ident := '总服务后台';
    IWBoServer := FConfigINI.ReadBool(Section,Ident,False);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,IWBoServer);
    Ident := '总后台SPID';
    IWServerSPID := FConfigINI.ReadString(Section,Ident,'vsk');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IWServerSPID);
    Ident := '总后台IP';
    IWServerIP := FConfigINI.ReadString(Section,Ident,'125.90.196.141');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IWServerIP);
    Ident := '总后台端口';
    IWServerPort := FConfigINI.ReadInteger(Section,Ident,8600);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IWServerPort);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteBooleanINI(Section, Ident: string;
  Value: Boolean);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteBool(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteFloatINI(Section, Ident: string; Value: double);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteFloat(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteIntegerINI(Section, Ident: string; Value: Integer);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteInteger(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteStringINI(Section, Ident, Value: string);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteString(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

end.
