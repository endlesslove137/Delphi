unit SQLFileDecrypt;

interface

const
  SQL_AESKey = '*0b&be3734eq!dc';
  DBLogin_AESKey = 'kc%dt#3*0m9d9%6';  

function GetRealKey(const sKey: string): string;

implementation

function GetRealKey(const sKey: string): string;
const
  ArrKey: Array[1..15] of Integer = (3,5,12,7,1,4,10,9,11,15,2,14,6,8,13);
var
  I: Integer;
begin
  Result := '';
  for I := Low(ArrKey) to High(ArrKey) do
  begin
    Result := Result + sKey[ArrKey[I]];
  end;
end;

end.
