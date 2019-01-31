unit LinkMapAnalyzer;

interface

uses
  Windows;

const
  MapAnalyzerDLL = 'dmapAnalyzer.dll';
  InvalidLineNumber = DWord(-1);
  
type

  tagMapAnalyzerType =
  (
	  maUnTyped,
	  maVCMap,
	  maDelphiMap
  );
  TMapAnalyzerType = tagMapAnalyzerType;

  TLinkMapAnalyzer = THandle;


  PSYMBOLDATA = ^TSYMBOLDATA;
  TSYMBOLDATA = record
	  dwAddressStart: DWord;
	  dwAddressEnd: DWord;
	  lpName: PChar;
	  lpSourceName: PChar;
	  dwLineNumber: DWord;  
	  dwOffsetLineNumber: DWord;
  end;

function CreateLinkMapAnalyzer(MapType: TMapAnalyzerType):TLinkMapAnalyzer;stdcall;
procedure FreeLinkMapAnalyzer(Analyzer: TLinkMapAnalyzer);stdcall;
function LinkMapAnalyzerLoadMap(Analyzer: TLinkMapAnalyzer; sMapFile: PChar):LongBool;stdcall;
function LinkMapAnalyzerGetSymbolAtAddress(Analyzer: TLinkMapAnalyzer;
  dwAddress: DWORD; var lpSymbolData: TSYMBOLDATA):LongBool;stdcall;
function LinkMapAnalyzerSetModuleBaseAddress(Analyzer: TLinkMapAnalyzer;
  dwAddress: DWORD):LongBool;stdcall;

implementation

function CreateLinkMapAnalyzer(MapType: TMapAnalyzerType):TLinkMapAnalyzer;stdcall;external MapAnalyzerDLL;
procedure FreeLinkMapAnalyzer(Analyzer: TLinkMapAnalyzer);stdcall;external MapAnalyzerDLL;
function LinkMapAnalyzerLoadMap(Analyzer: TLinkMapAnalyzer; sMapFile: PChar):LongBool;stdcall;external MapAnalyzerDLL;
function LinkMapAnalyzerGetSymbolAtAddress(Analyzer: TLinkMapAnalyzer;
  dwAddress: DWORD; var lpSymbolData: TSYMBOLDATA):LongBool;stdcall;external MapAnalyzerDLL;
function LinkMapAnalyzerSetModuleBaseAddress(Analyzer: TLinkMapAnalyzer;
  dwAddress: DWORD):LongBool;stdcall;external MapAnalyzerDLL;  

end.
