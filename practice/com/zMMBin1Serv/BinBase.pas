unit BinBase;

interface
uses
  Windows, ActiveX, ComObj, classes, BinIntf;

type
  TBinItem = class
  protected
    FDescription: string;
    FValue: Integer;
  public
    property Description: string read FDescription;
    property Value: Integer read FValue;
  end;

  TBin = class
  protected
    FValue: Integer;
    FItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
    property Items: TList read FItems;
    property Value: Integer read FValue write FValue;
  end;

  TAbstractOneDBin = class(TComObject, IzmmOneDBin, IzmmOneDBin2)
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
    {Declare IOneDBin methods here}
    procedure SetMaxValue(AMaxValue: Integer);
    procedure AddItem(AQuantity: Integer; ADescription: WideString; AValue: Integer);
    procedure Optimize; virtual; abstract;
    function GetName: WideString; virtual; abstract;
    function NextBin: Boolean;
    function NextItem(var ADescription: WideString; var AValue: Integer): Boolean;
    function NumBins: Integer;
    function PercentWaste: Double;
  end;

implementation
 
uses ComServ;


{ TAbstractOneDBin }

{ TBin }

constructor TBin.Create;
begin
  FItems := TList.Create;
end;

destructor TBin.Destroy;
begin
  FItems.Free;
end;

{ TAbstractOneDBin }

procedure TAbstractOneDBin.AddItem(AQuantity: Integer; ADescription: WideString;
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

destructor TAbstractOneDBin.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to FItems.Count - 1 do
    TBinItem(FItems[Index]).Free;
  FItems.Free;

  for Index := 0 to FBins.Count - 1 do
    TBin(FBins[Index]).Free;
  FBins.Free;
end;

procedure TAbstractOneDBin.Initialize;
begin
  FItems := TList.Create;
  FBins := TList.Create;
end;

function TAbstractOneDBin.NextBin: Boolean;
begin
  if FBinIndex < FBins.Count - 1 then begin
    Inc(FBinIndex);
    FCurrentBin := TBin(FBins[FBinIndex]);
    FItemIndex := -1;
    Result := True;
  end else
    Result := False;
end;

function TAbstractOneDBin.NextItem(var ADescription: WideString;
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

function TAbstractOneDBin.NumBins: Integer;
begin
  Result := FBins.Count;
end;

function TAbstractOneDBin.PercentWaste: Double;
var
  TotalWeight: Integer;
  UsedWeight: Integer;
  BinIndex: Integer;
  Bin: TBin;
  ItemIndex: Integer;
  Item: TBinItem;
begin
  TotalWeight := 0;
  UsedWeight := 0;

  for BinIndex := 0 to FBins.Count - 1 do
  begin
    Inc(TotalWeight, FMaxValue);
    Bin := TBin(FBins[BinIndex]);
    for ItemIndex := 0 to Bin.FItems.Count - 1 do begin
      Item := TBinItem(Bin.FItems[ItemIndex]);
      Inc(UsedWeight, Item.FValue);
    end;
  end;

  Result := (1.0 - UsedWeight / TotalWeight) * 100.0;
end;

procedure TAbstractOneDBin.SetMaxValue(AMaxValue: Integer);
begin
  FMaxValue := AMaxValue;
end;

end.
