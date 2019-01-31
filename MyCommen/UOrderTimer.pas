unit UOrderTimer;

interface

uses
  Windows, SysUtils, SyncObjs;

type
  TWaitableTimer = class(TSynchroObject)
  protected
    FHandle: THandle;
    FPeriod: LongInt;
    FDueTime: TDateTime;
    FLastError: Integer;
    FLongTime: Int64;
  public
    constructor Create(ManualReset : Boolean;
      TimerAttributes: PSecurityAttributes; const Name : string );
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    function Wait(Timeout: LongInt): TWaitResult;
    property Handle: THandle read FHandle;
    property LastError: integer read FLastError;
    property Period: integer read FPeriod write FPeriod;
    property Time: TDateTime read FDueTime write FDueTime;
    property LongTime: int64 read FLongTime write FLongTime;
  end;

implementation

{ TWaitableTimer }
constructor TWaitableTimer.Create(ManualReset: Boolean;
  TimerAttributes: PSecurityAttributes; const Name: string);
var
  pName: PChar;
begin
 inherited Create;
 if Name = '' then pName := nil else pName := PChar(Name);
 FHandle := CreateWaitableTimer(TimerAttributes, ManualReset, pName);
end;

destructor TWaitableTimer.Destroy;
begin
  CloseHandle(FHandle);
  inherited Destroy;
end;

procedure TWaitableTimer.Start;
var
  SysTime: TSystemTime;
  LocalTime, UTCTime: FileTime;
  Value: Int64 absolute UTCTime;
begin
  if FLongTime = 0 then
  begin
    DateTimeToSystemTime(FDueTime, SysTime);
    SystemTimeToFileTime(SysTime, LocalTime);
    LocalFileTimeToFileTime(LocalTime, UTCTime);
  end else
    Value := FLongTime;
  SetWaitableTimer(FHandle, Value, FPeriod, nil, nil, False);
end;

procedure TWaitableTimer.Stop;
begin
  CancelWaitableTimer(FHandle);
end;

function TWaitableTimer.Wait(Timeout: Integer): TWaitResult;
begin
  case WaitForSingleObjectEx(Handle, Timeout, BOOL(1)) of
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_OBJECT_0: Result := wrSignaled;
    WAIT_TIMEOUT: Result := wrTimeout;
    WAIT_FAILED: begin
      Result := wrError;
      FLastError := GetLastError;
    end;
  else
    Result := wrError;
  end;
end;

end.

