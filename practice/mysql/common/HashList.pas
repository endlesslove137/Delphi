unit HashList;

interface

type
  PPHashItem = ^PHashItem;
  PHashItem = ^THashItem;
  THashItem = record
    Next: PHashItem;
    Key: string;
    Data: Pointer;
  end;

  PHashItemList = ^THashItemList;
  THashItemList = array of PHashItem;

  TStringHashList = class
  private
    FBuckets: array of PHashItem;
    FFreeItem: PHashItem;
    function GetBuckets: PHashItemList;
    function GetBucketCount: Integer;
  protected
    function Find(const Key: string): PPHashItem;
  public
    constructor Create(Size: Cardinal = 256);
    destructor Destroy; override;
    procedure Clear;
    procedure Remove(const Key: string);
    procedure Add(const Key: string; Data: Pointer);
    procedure Put(const Key: string; Data: Pointer);
    function Get(const Key: string): Pointer;

    property Buckets: PHashItemList read GetBuckets;
    property BucketCount: Integer read GetBucketCount;
  end;

function bzhashstr(const str: PAnsiChar; seed: Cardinal): Cardinal;

implementation

var                
  //哈希运算种子表
  cryptTable: array [0..$500-1] of Cardinal;   

function bzhashstr(const str: PAnsiChar; seed: Cardinal): Cardinal;
var
  key: PByte;
  seed1, seed2: Cardinal;
  ch: Byte;
begin
	key := PByte(str);
	seed1 := $7FED7FED;
  seed2 := $EEEEEEEE;

	while (key^ <> 0) do
  begin
    ch := key^;
    Inc(key);
    
    if (ch >= Ord('a')) and (ch <= Ord('z')) then
      ch := ch xor $20;

		seed1 := cryptTable[(seed shl 8) + ch] xor (seed1 + seed2);
		seed2 := ch + seed1 + seed2 + (seed2 shl 5) + 3;
	end;
  Result := seed1;
end;  

procedure InitCryptrTable();
var
  seed, index1, index2, i: Cardinal;
  temp1, temp2: Cardinal;
begin
	seed := $00100001;
  
  for index1 := 0 to $FF do
  begin
    index2 := index1;
    for I := 0 to 4 do
    begin
			seed := (seed * 125 + 3) mod $2AAAAB;
			temp1 := (seed and $FFFF) shl $10;
			seed := (seed * 125 + 3) mod $2AAAAB;
			temp2 := (seed and $FFFF);
			cryptTable[index2] := ( temp1 or temp2 );
      Inc(index2, $100);
    end;
	end;
end;


{ TStringHashList }

procedure TStringHashList.Clear;
var
  I: Integer;
  P, N: PHashItem;
begin
  for I := 0 to Length(FBuckets) - 1 do
  begin
    P := FBuckets[I];
    while P <> nil do
    begin
      N := P^.Next;
      P^.Next := FFreeItem;
      FFreeItem := P;
      P := N;
    end;
    FBuckets[I] := nil;
  end;
end;

constructor TStringHashList.Create(Size: Cardinal);
begin
  inherited Create;
  SetLength(FBuckets, Size);
end;

destructor TStringHashList.Destroy;
var
  P: PHashItem;
begin
  Clear;
  while FFreeItem <> nil do
  begin
    P := FFreeItem;
    FFreeItem := FFreeItem^.Next;
    Dispose(P);
  end;
  inherited Destroy;
end;

function TStringHashList.Find(const Key: string): PPHashItem;
var
  Hash: Integer;
begin
  Hash := bzhashstr(PChar(Key), 1) mod Cardinal(Length(FBuckets));
  Result := @FBuckets[Hash];
  while Result^ <> nil do
  begin
    if Result^.Key = Key then
      Exit
    else
      Result := @Result^.Next;
  end;
end;

procedure TStringHashList.Put(const Key: string; Data: Pointer);
var
  P: PHashItem;
begin
  P := Find(Key)^;
  if P <> nil then
  begin
    P^.Data := Data;
  end
  else begin
    Add(Key, Data);
  end;
end;

procedure TStringHashList.Remove(const Key: string);
var
  P: PHashItem;
  Prev: PPHashItem;
begin
  Prev := Find(Key);
  P := Prev^;
  if P <> nil then
  begin
    Prev^ := P^.Next;
    P^.Next := FFreeItem;
    FFreeItem := P;
  end;
end;

function TStringHashList.Get(const Key: string): Pointer;
var
  P: PHashItem;
begin
  P := Find(Key)^;
  if P <> nil then
    Result := P^.Data
  else
    Result := nil;
end;

function TStringHashList.GetBuckets: PHashItemList;
begin
  Result := @FBuckets;
end;

function TStringHashList.GetBucketCount: Integer;
begin
  Result := Length(FBuckets);
end;

procedure TStringHashList.Add(const Key: string; Data: Pointer);
var
  Hash: Cardinal;
  Bucket: PHashItem;
begin
  Hash := bzhashstr(PChar(Key), 1) mod Cardinal(Length(FBuckets));
  if FFreeItem <> nil then
  begin
    Bucket := FFreeItem;
    FFreeItem := FFreeItem^.Next;
  end
  else New(Bucket);
  Bucket^.Key := Key;
  Bucket^.Data := Data;
  Bucket^.Next := FBuckets[Hash];
  FBuckets[Hash] := Bucket;
end;

initialization
  InitCryptrTable();

end.
