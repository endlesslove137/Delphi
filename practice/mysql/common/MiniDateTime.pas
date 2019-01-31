unit MiniDateTime;

interface

uses
  SysUtils, Windows;

type
  TMiniDateTime = Integer;

                            
function EncodeMiniDateTime(wYear, wMon, wDay, wHour, wMin, wSec: Word):TMiniDateTime;
function MiniDateTimeOfNow():TMiniDateTime;

implementation

type
  PTMonthSeconds=^TMonthSeconds;
  TMonthSeconds = array [1..12] of Integer;

const
  SecOfMin    = 60;
  SecOfHour   = SecOfMin * 60;
  SecOfDay    = SecOfHour * 24;
  SecOfMonths : array [Boolean] of TMonthSeconds = (
    ( 31 * SecOfDay, 28 * SecOfDay, 31 * SecOfDay,
      30 * SecOfDay, 31 * SecOfDay, 30 * SecOfDay,
      31 * SecOfDay, 31 * SecOfDay, 30 * SecOfDay,
      31 * SecOfDay, 30 * SecOfDay, 31 * SecOfDay
    ),       
    ( 31 * SecOfDay, 29 * SecOfDay, 31 * SecOfDay,
      30 * SecOfDay, 31 * SecOfDay, 30 * SecOfDay,
      31 * SecOfDay, 31 * SecOfDay, 30 * SecOfDay,
      31 * SecOfDay, 30 * SecOfDay, 31 * SecOfDay
    )
  );
  SecOfYears  : array [Boolean] of Integer = ( 365 * SecOfDay, 366 * SecOfDay );

  MiniDateBaseYear  = 2008;

var
  MonthSecondsGone : array [Boolean] of TMonthSeconds;

function EncodeMiniDateTime(wYear, wMon, wDay, wHour, wMin, wSec: Word):TMiniDateTime;
begin
  Result   := wSec + wMin * SecOfMin + wHour * SecOfHour + wDay * SecOfDay;

  Inc( Result, MonthSecondsGone[IsLeapYear(wYear),wMon] );
  
  while wYear > MiniDateBaseYear do
  begin
    Inc( Result, SecOfYears[IsLeapYear(wYear)] );
    Dec( wYear );
  end;
end;

function MiniDateTimeOfNow():TMiniDateTime;
var
  wYear, wMon, wDay, wHour, wMin, wSec, wMilSec: Word;
  dDate: TDateTime;
begin
  dDate := Now();
  DecodeDate( dDate, wYear, wMon, wDay );
  DecodeTime( dDate, wHour, wMin, wSec, wMilSec );
  Result := EncodeMiniDateTime( wYear, wMon, wDay, wHour, wMin, wSec );
end;

procedure InitMonthGoneSeconds();
var
  I: Integer;
begin
  MonthSecondsGone[False,1] := SecOfMonths[False,1];
  MonthSecondsGone[True,1] := SecOfMonths[True,1];
  for I := 2 to 12 do
  begin
    MonthSecondsGone[False,I] := MonthSecondsGone[False,I-1] + SecOfMonths[False,I];
    MonthSecondsGone[True,I] := MonthSecondsGone[True,I-1] + SecOfMonths[True,I];
  end;
end;

initialization
  InitMonthGoneSeconds();

end.
