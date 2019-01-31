unit SortUtil;

interface

uses
  Windows, SysUtils;
  
type
  TQSortCallBack = function (lpData1, lpData2: Pointer): Integer;

procedure qsort(lpData: Pointer; nDataSize, nCount: Integer; Compare:TQSortCallBack);

implementation

procedure qsort(lpData: Pointer; nDataSize, nCount: Integer; Compare:TQSortCallBack);
var
  I, Index, Value: Integer;
  pCur, pTarget: PByte;
  TempData: array [0..2047] of Char;
begin              
  if nCount > sizeof(TempData) then Exit;
  
  I := 1;
  while I < nCount  do
  begin
    Index := I - 1;
    pCur := lpData;
    Inc( pCur, I * nDataSize );
    pTarget := lpData;
    Inc( pTarget, Index * nDataSize );

    Value := Compare( pCur, pTarget );
    if Value <> 0 then
    begin
      if Value < 0 then
      begin
        if Index > 0 then
        begin
          repeat
            Dec( Index );
            Dec( pTarget, nDataSize );
          until (Index < 0) or (Compare( pCur, pTarget ) >= 0);
          Inc( Index );
        end;
      end
      else begin
        if Index < nCount - 1 then
        begin     
          Inc( Index );
          repeat
            Inc( Index );    
            Inc( pTarget, nDataSize );
          until (Index >= nCount) or (Compare( pCur, pTarget ) <= 0);
          Dec( Index );
        end;
      end;  
      if I <> Index then
      begin               
        pTarget := lpData;
        Inc( pTarget, Index * nDataSize );
        Move( pTarget^, TempData[0], nDataSize );
        Move( pCur^, pTarget^, nDataSize );
        Move( TempData[0], pCur^, nDataSize );
      end
      else Inc( I );
    end
    else Inc( I );
  end;
end;

end.
