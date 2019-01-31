(*
  功能：定时管理器 用于处理非人工操作
  版本：V1.0.0.5
  创建日期：2012-10-16 19：00
  更新日期：2012-12-28 15：32
*)
unit AIWRobot;

interface

uses Classes, Windows, DateUtils, SysUtils, EDcode, UserSessionUnit;

type
 {NumType 操作类型 0 无操作
                   --公告
                   1 增加
                   2 删除
                   --经验倍率
                   3 定时设置
                   4 删除到时}
  TAutoRunRecord  = record
    spid            : string;
    MsgType         : Integer; //消息类型
    sdata           : string;  //公告内容
    ServerIdx       : Integer; //服务器ID
    NumType         : Integer; //操作类型 0 无操作 1增加 2删除
    dNextRun        : TDateTime;  //下次执行时间
    RunTick         : Integer; //执行次数
  end;
  PTAutoRunRecord = ^TAutoRunRecord;

  TFileRoot = class
    FileAutoList: TList;
  private
    procedure ClearScript;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ProcessRun;

    function Find(sdata, spid: string; idx: Integer): PTAutoRunRecord;
    function Add(parr: PTAutoRunRecord): Boolean;
    procedure Delete(sdata: string; idx: Integer);
    procedure DeleteEx(sdata: string; idx: Integer; daTime: TDateTime);
    procedure DeleteEx2(idx, num: Integer);

    procedure LoadRobotList;
    procedure ReLoadRobotFile;

    procedure ClearRobot; //销毁服务器获取
  end;

var
  ARobots: TFileRoot;

implementation

uses ServerController, ConfigINI;

{ TFileRoot }

constructor TFileRoot.Create;
begin
  inherited;
  FileAutoList:= TList.Create;
end;

destructor TFileRoot.Destroy;
begin
  ClearScript();
  FileAutoList.Free;
  inherited;
end;

//处理清除
procedure TFileRoot.ClearScript;
var
  i: Integer;
begin
  for i := 0 to FileAutoList.Count - 1 do
  begin
    if PTAutoRunRecord(FileAutoList.Items[i]) <> nil then
      DisPose(PTAutoRunRecord(FileAutoList.Items[i]));
  end;
  FileAutoList.Clear;
end;
//自动处理
procedure TFileRoot.ProcessRun;
var
  i: Integer;
  chktime: TDateTime;
  parr: PTAutoRunRecord;
begin
  chktime := Now();

  for i := FileAutoList.Count - 1 downto 0 do
  begin
    parr := PTAutoRunRecord(FileAutoList.Items[i]);
    if parr <> nil then
    begin
      {--开始高效处理--}
      if (chktime >= parr^.dNextRun) and (parr.NumType > 0) then
      begin
        // 多检操作方便扩展
        case parr^.NumType of
           1: // 增加公告
             begin
               IWServerController.SendAddNotices(parr^.spid, parr^.ServerIdx, parr^.MsgType, parr^.RunTick, parr^.sdata);
             end;
           2: // 删除公告
             begin
               IWServerController.SendDelNotices(parr^.spid, parr^.ServerIdx, parr^.sdata);
             end;
           3: // 增加经验
             begin
               IWServerController.SendSetExpRates(parr^.spid, parr^.ServerIdx, parr^.MsgType, parr^.RunTick, parr^.sdata);
               parr^.NumType := 4;
               parr^.dNextRun:= IncMinute(parr^.dNextRun, parr^.RunTick);
               IWServerController.SetRobotMessage(parr^.spid, parr^.ServerIdx, parr^.MsgType, 102, parr^.RunTick, parr^.sdata, parr^.dNextRun);
             end;
           4: // 删除经验
             begin
               FileAutoList.Delete(I);
               IWServerController.SetRobotMessage(parr^.spid, parr^.ServerIdx, parr^.MsgType, 100, parr^.RunTick, parr^.sdata, parr^.dNextRun);
               Dispose(parr);
             end;
        else
          //其他处理
        end;
      end;
    end;
  end;
end;

function TFileRoot.Find(sdata, spid: string; idx: Integer): PTAutoRunRecord;
var
  i: Integer;
  parr: PTAutoRunRecord;
begin
  Result := nil;
  for i := 0 to FileAutoList.Count - 1 do
  begin
    parr := PTAutoRunRecord(FileAutoList.Items[i]);
    if parr <> nil then
    if (CompareText(parr.sdata, sdata) = 0) and
       (CompareText(parr.spid, spid) = 0) and
       (parr.ServerIdx = idx) then begin
      Result := parr;
      Break;
    end;
  end;
end;

function TFileRoot.Add(parr: PTAutoRunRecord): Boolean;
begin
  Result := False;
  if Find(parr.sdata, parr.spid, parr.ServerIdx) <> nil then Exit;
  FileAutoList.Add(parr);
  Result := True;
end;

procedure TFileRoot.Delete(sdata: string; idx: Integer);
var
  i: Integer;
  parr: PTAutoRunRecord;
begin
  for I := 0 to FileAutoList.Count - 1 do
  begin
    parr := PTAutoRunRecord(FileAutoList.Items[i]);
    if parr <> nil then
    if (CompareText(parr.sdata, sdata) = 0) and
       (parr.ServerIdx = idx) then begin
      FileAutoList.Delete(i);
      Dispose(parr);
      Break;
    end;
  end;
end;

procedure TFileRoot.DeleteEx(sdata: string; idx: Integer; daTime: TDateTime);
var
  i: Integer;
  parr: PTAutoRunRecord;
begin
  for I := 0 to FileAutoList.Count - 1 do
  begin
    parr := PTAutoRunRecord(FileAutoList.Items[i]);
    if parr <> nil then
    if (CompareText(parr.sdata, sdata) = 0) and
       (parr.ServerIdx = idx) and (parr.dNextRun = daTime) then begin
      FileAutoList.Delete(i);
      Dispose(parr);
      Break;
    end;
  end;
end;

procedure TFileRoot.DeleteEx2(idx, num: Integer);
var
  i: Integer;
  parr: PTAutoRunRecord;
begin
  for I := 0 to FileAutoList.Count - 1 do
  begin
    parr := PTAutoRunRecord(FileAutoList.Items[i]);
    if parr <> nil then
    if (parr.ServerIdx = idx) and (parr.NumType = num) then begin
      FileAutoList.Delete(i);
      IWServerController.SetRobotMessage(parr.spid, idx, parr.MsgType, 101, parr.RunTick, parr.sdata, parr.dNextRun);
      Dispose(parr);
      Break;
    end;
  end;
end;

procedure TFileRoot.LoadRobotList;
const
  sqlnoticeinfo = 'SELECT * FROM %s.robotinfo';
  sqlCreateRobot = 'CREATE TABLE %s.robotinfo (spid varchar(3) NOT NULL, serverindex int(10) NOT NULL default "0",'+
                   'msgtype int(10) NOT NULL default "0", message varchar(300) NOT NULL, numtype int(10) NOT NULL default "0",'+
                   'logdate datetime NOT NULL, runtick int(10) NOT NULL default "0") ENGINE=MyISAM DEFAULT CHARSET=utf8;';
var
  I: Integer;
  psld, psld2: PTServerListData;
  parr: PTAutoRunRecord;
begin
  try
    for I := 0 to ServerList.Count - 1 do
    begin
      psld2 := PTServerListData(ServerList.Objects[I]);
      if psld2 <> nil then
      begin
        if psld2.Index <> 0 then Continue;
        if Pos(psld2^.spID,objINI.DataDisposeSpid) <> 0 then
        begin
          psld := GetServerListDataBySPID(psld2.spid);
          if psld = nil then Exit;
          with IWServerController do
          begin
            ConnectionLogMysql(SQLConnectionRAuto,psld.LogDB,psld.LogHostName);
            try
              if not IsCheckTable(quRobotInfo,psld.GstaticDB,'robotinfo') then
              begin
                 DBExecSQL(quRobotInfo,Format(sqlCreateRobot,[psld.GstaticDB]));
              end;
              with quRobotInfo do
              begin
                SQL.Text := Format(sqlnoticeinfo,[psld.GstaticDB]);
                Open;
                while not Eof do
                begin
                   New(parr);
                   ZeroMemory( parr, sizeof(parr^) );
                   parr.spid := Fields[0].AsString;
                   parr.ServerIdx:=  Fields[1].AsInteger;
                   parr.MsgType := Fields[2].AsInteger;
                   parr.sdata := Utf8ToString(Fields[3].AsAnsiString);
                   parr.NumType :=  Fields[4].AsInteger;
                   parr.dNextRun := Fields[5].AsDateTime;
                   parr.RunTick :=  Fields[6].AsInteger;
                   Add(parr);
                   Next;
                end;
                Close;
              end;
            finally
               SQLConnectionRAuto.Close;
            end;
          end;
        end;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TFileRoot.ReLoadRobotFile;
begin
  ClearScript;
  LoadRobotList;
end;

procedure TFileRoot.ClearRobot;
var
  i: Integer;
  parr: PTAutoRunRecord;
begin
  for I := FileAutoList.Count - 1 downto 0 do
  begin
    parr := PTAutoRunRecord(FileAutoList[i]);
    if parr <> nil then
    begin
      if parr^.NumType = 0 then
      begin
        FileAutoList.Delete(I);
        Dispose(parr);
      end;
    end;
  end;
end;

end.
