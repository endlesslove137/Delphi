unit zMMBestFit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, BinBase, BinIntf;

type
  TzMMBestFit = class(TAbstractOneDBin)
  protected
    procedure Optimize; override;
    function GetName: WideString; override;
  end;


implementation

uses ComServ;

{ TzMMBestFit }

function TzMMBestFit.GetName: WideString;
begin
  Result := 'Best Fit';
end;

procedure TzMMBestFit.Optimize;
var
  Index: Integer;
  Item: TBinItem;
  BinIndex: Integer;
  BestBinIndex: Integer;
  BestValue: Integer;
begin
  FCurrentBin := nil;
  for Index := 0 to FItems.Count - 1 do begin
    Item := TBinItem(FItems[Index]);

    // Find a bin with enough room
    BestBinIndex := -1;
    BestValue := 0;
    for BinIndex := 0 to FBins.Count - 1 do begin
      FCurrentBin := TBin(FBins[BinIndex]);
      if FCurrentBin.Value + Item.Value <= FMaxValue then begin
        if (BestBinIndex = -1) or
           (FCurrentBin.Value > BestValue) then begin
          BestBinIndex := BinIndex;
          BestValue := FCurrentBin.Value;
        end;
      end;
    end;

    // if no available bin, create a new one
    if BestBinIndex = -1 then begin
      FCurrentBin := TBin.Create;
      FBins.Add(FCurrentBin);
    end;

    FCurrentBin.Items.Add(Item);
    FCurrentBin.Value := FCurrentBin.Value + Item.Value;
  end;

  FBinIndex := -1;
end;

initialization
  TComObjectFactory.Create(ComServer, TzMMBestFit, Class_zMMBestFit,
    'zMMBestFit', 'zMMBestFit Des', ciMultiInstance, tmApartment);
end.
