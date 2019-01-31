unit zMMFirstFit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, BinBase, BinIntf;

type
  TzmmFirstFit = class(TAbstractOneDBin)
  protected
    procedure Optimize; override;
    function GetName: WideString; override;
  end;


implementation

uses ComServ;

{ TzmmFirstFit }

function TzmmFirstFit.GetName;
begin
  Result := 'First Fit';
end;


procedure TzmmFirstFit.Optimize;
var
  Index: Integer;
  Item: TBinItem;
  BinFound: Boolean;
  BinIndex: Integer;
begin
  FCurrentBin := nil;
  for Index := 0 to FItems.Count - 1 do begin
    Item := TBinItem(FItems[Index]);

    // Find a bin with enough room
    BinFound := False;
    BinIndex := 0;
    while (not BinFound) and (BinIndex < FBins.Count) do
    begin

      FCurrentBin := TBin(FBins[BinIndex]);
      if FCurrentBin.Value + Item.Value <= FMaxValue then
        BinFound := True
      else
        Inc(BinIndex);
    end;

    // if no available bin, create a new one
    if not BinFound then begin
      FCurrentBin := TBin.Create;
      FBins.Add(FCurrentBin);
    end;

    FCurrentBin.Items.Add(Item);
    FCurrentBin.Value := FCurrentBin.Value + Item.Value;
  end;

  FBinIndex := -1;
end;

initialization
  TComObjectFactory.Create(ComServer, TzmmFirstFit, Class_zmmFirstFit,
    'zmmFirstFit', 'zmmFirstFit Des', ciMultiInstance, tmApartment);
end.
