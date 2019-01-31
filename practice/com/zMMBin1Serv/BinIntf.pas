unit BinIntf;

interface

type
  IzmmOneDBin = interface
    ['{78E7134E-BFF9-4F49-8434-0EEDFEEEE45E}']
    procedure SetMaxValue(AMaxValue: Integer);
    procedure AddItem(AQuantity: Integer; ADescription: WideString; AValue: Integer);
    procedure Optimize;
    function NextBin: Boolean;
    function NextItem(var ADescription: WideString; var AValue: Integer): Boolean;
  end;

  IzmmOneDBin2 = interface(IzmmOneDBin)
    ['{5029F7E7-77E9-4E9C-B4DB-5A0E7CAC1390}']
    function GetName: WideString;
    function NumBins: Integer;
    function PercentWaste: Double;
  end;

const
  Class_zMMNextFit: TGUID = '{B45990FA-7568-4A5B-AA0B-9CEAC0841158}';
  Class_zMMBestFit: TGUID = '{11F67CA0-CB9F-44F9-AA3A-285902505189}';
  Class_zmmFirstFit: TGUID = '{0693132E-1A82-4446-8D9D-793A0805924D}';

implementation

end.
