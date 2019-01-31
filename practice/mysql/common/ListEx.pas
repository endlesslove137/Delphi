unit ListEx;

interface

uses
  Windows, SysUtils, SortList, Classes;

type
  TLockSortList = class (TSortList)
  private  
    m_Lock: TRTLCriticalSection;
  public
    constructor Create();override;
    destructor Destroy();override;
    procedure Lock();
    procedure Unlock();
  end;
  
  TDoubleList = class(TLockSortList)
  private
    m_AppendList: TSortList;
    function GetAppendCount: Integer;
  public
    constructor Create();override;
    destructor Destroy();override;
    procedure Append(P: Pointer);  
    procedure Flush();

    property AppendCount: Integer read GetAppendCount;
    property AppendList: TSortList read m_AppendList;
  end;

  TLockStringList = class(TStringList)
  private
    m_Lock: TRTLCriticalSection;
  public
    constructor Create();virtual;
    destructor Destroy();override;
    procedure Lock();
    procedure Unlock();
  end;

  TDoubleStringList = class(TLockStringList)    
    m_AppendStrings: TStringList;
    function GetAppendCount: Integer;
  private
  public
    constructor Create();override;
    destructor Destroy();override;
    procedure Append(S: string);
    procedure AppendObject(s: string; AObject: TObject);  
    procedure Flush();

    property AppendCount: Integer read GetAppendCount;
    property AppendList: TStringList read m_AppendStrings;
  end;

implementation

{ TDoubleList }

procedure TDoubleList.Append(P: Pointer);
begin    
  EnterCriticalSection( m_Lock );
  try
    m_AppendList.Add(P);
  finally
    LeaveCriticalSection( m_Lock );
  end;
end;

constructor TDoubleList.Create;
begin
  inherited Create;
  m_AppendList := TSortList.Create;
end;

destructor TDoubleList.Destroy;
begin
  m_AppendList.Free;
  inherited;
end;

procedure TDoubleList.Flush;
begin
  EnterCriticalSection( m_Lock );
  try
    AddList( m_AppendList );
    m_AppendList.Trunc(0);
  finally
    LeaveCriticalSection( m_Lock );
  end;
end;

function TDoubleList.GetAppendCount: Integer;
begin
  result := m_AppendList.Count;
end;

{ TLockSortList }

constructor TLockSortList.Create;
begin
  inherited Create();
  InitializeCriticalSection( m_Lock );
end;

destructor TLockSortList.Destroy;
begin
  DeleteCriticalSection( m_Lock );
  inherited;
end;

procedure TLockSortList.Lock;
begin
  EnterCriticalSection( m_Lock );
end;

procedure TLockSortList.Unlock;
begin
  LeaveCriticalSection( m_Lock );
end;

{ TLockStringList }

constructor TLockStringList.Create;
begin
  inherited Create;
  InitializeCriticalSection( m_Lock );
end;

destructor TLockStringList.Destroy;
begin
  DeleteCriticalSection( m_Lock );
  inherited;
end;

procedure TLockStringList.Lock;
begin
  EnterCriticalSection( m_Lock );
end;

procedure TLockStringList.Unlock;
begin
  LeaveCriticalSection( m_Lock );
end;

{ TDoubleStringList }

procedure TDoubleStringList.Append(S: string);
begin
  EnterCriticalSection( m_Lock );
  try
    m_AppendStrings.Add( S );
  finally
    LeaveCriticalSection( m_Lock );
  end;
end;

procedure TDoubleStringList.AppendObject(s: string; AObject: TObject);
begin
  EnterCriticalSection( m_Lock );
  try
    m_AppendStrings.AddObject( S, AObject );
  finally
    LeaveCriticalSection( m_Lock );
  end;
end;

constructor TDoubleStringList.Create;
begin
  inherited Create;
  m_AppendStrings := TStringList.Create;
end;

destructor TDoubleStringList.Destroy;
begin
  m_AppendStrings.Free;
  inherited;
end;

procedure TDoubleStringList.Flush;
begin
  EnterCriticalSection( m_Lock );
  try
    AddStrings( m_AppendStrings );
    m_AppendStrings.Clear();
  finally
    LeaveCriticalSection( m_Lock );
  end;
end;

function TDoubleStringList.GetAppendCount: Integer;
begin
  Result := m_AppendStrings.Count;
end;

end.
