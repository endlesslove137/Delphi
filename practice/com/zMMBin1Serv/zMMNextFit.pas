unit zMMNextFit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, BinIntf;

type
  TBinItem = class
  protected
    FDescription: string;
    FValue: Integer;
  end;

  TBin = class
  protected
    FValue: Integer;
    FItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
  end;


  TzMMNextFit = class(TComObject, IzmmOneDBin)
  protected
    FMaxValue: Integer;
    FItems: TList;
    FBins: TList;
    FCurrentBin: TBin;
    FBinIndex: Integer;
    FItemIndex: Integer;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    {Declare IzmmOneDBin methods here}
    procedure SetMaxValue(AMaxValue: Integer);
    procedure AddItem(AQuantity: Integer; ADescription: WideString; AValue: Integer);
    procedure Optimize;
    function NextBin: Boolean;
    function NextItem(var ADescription: WideString; var AValue: Integer): Boolean;
  end;


implementation

uses ComServ;

{ TzMMNextFit }

procedure TzMMNextFit.AddItem(AQuantity: Integer; ADescription: WideString;
  AValue: Integer);
var
  Item: TBinItem;
  Index: Integer;
begin
  for Index := 1 to AQuantity do begin
    Item := TBinItem.Create;
    Item.FDescription := ADescription;
    Item.FValue := AValue;
    FItems.Add(Item);
  end;
end;

destructor TzMMNextFit.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to FBins.Count - 1 do
    TBin(FBins[Index]).Free;
  FBins.Free;

  for Index := 0 to FItems.Count - 1 do
    TBinItem(FItems[Index]).Free;
  FItems.Free;
end;

procedure TzMMNextFit.Initialize;
begin
  FItems := TList.Create;
  FBins := TList.Create;
end;

function TzMMNextFit.NextBin: Boolean;
begin
  if FBinIndex < FBins.Count - 1 then begin
    Inc(FBinIndex);
    FCurrentBin := TBin(FBins[FBinIndex]);
    FItemIndex := -1;
    Result := True;
  end else
    Result := False;
end;

function TzMMNextFit.NextItem(var ADescription: WideString;
  var AValue: Integer): Boolean;
begin
  if FItemIndex < FCurrentBin.FItems.Count - 1 then begin
    Inc(FItemIndex);
    ADescription := TBinItem(FCurrentBin.FItems[FItemIndex]).FDescription;
    AValue := TBinItem(FCurrentBin.FItems[FItemIndex]).FValue;
    Result := True;
  end else
    Result := False;
end;

procedure TzMMNextFit.Optimize;
var
  Index: Integer;
  Item: TBinItem;
begin
  FCurrentBin := nil;
  for Index := 0 to FItems.Count - 1 do begin
    Item := TBinItem(FItems[Index]);
    if (FCurrentBin = nil) or (FCurrentBin.FValue + Item.FValue > FMaxValue) then begin
      FCurrentBin := TBin.Create;
      FBins.Add(FCurrentBin);
    end;

    FCurrentBin.FItems.Add(Item);
    FCurrentBin.FValue := FCurrentBin.FValue + Item.FValue;
  end;

  FBinIndex := -1;
end;

procedure TzMMNextFit.SetMaxValue(AMaxValue: Integer);
begin
  FMaxValue := AMaxValue;
end;


{ TBin }

constructor TBin.Create;
begin
  FItems := TList.Create;
end;

destructor TBin.Destroy;
begin
  FItems.Free;
end;

initialization
  TComObjectFactory.Create(ComServer, TzMMNextFit, Class_zMMNextFit,
    'zMMNextFit', 'zMMNextFitDes', ciMultiInstance, tmApartment);
end.
