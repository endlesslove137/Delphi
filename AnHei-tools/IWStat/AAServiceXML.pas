unit AAServiceXML;

interface

uses MSXML, Classes, SysUtils, ActiveX;

const
  AAServiceFile = 'AAService.xml';
  AcrossAwardsFile = 'AcrossAwards.xml';

type
  PTAAServersData = ^TAAServersData;
  TAAServersData = record
    Index: Integer;
    Name: string;
    LevelMax: Integer;
    DBServer: string;
    DataBase: string;
    DBUser: string;
    DBPass: AnsiString;
    DBPort: Integer;                
  end;
  
  TAAServiceXML = class
  private
    xmlPath: string;
    procedure ClearAAServersListData;
  public
    SPID: string;
    ServerIDBase: Integer;
    Expense : Integer;
    SQLUserName: string;
    SQLUserPass: string;
    ServerList: string;
    AAServersList: TStringList;
    AwardList: array of Integer;
    constructor Create(AppPath: string);
    destructor  Destroy();override;
    procedure ReadXMLData;
    procedure LoadAwardConfig;
    function GetMaxLevelAAServersData(level: Integer):PTAAServersData;
  end;

implementation

{ TAAServiceXML }

procedure TAAServiceXML.ClearAAServersListData;
var
  I: Integer;
begin
  for I := 0 to AAServersList.Count - 1 do
  begin
    Dispose(PTAAServersData(AAServersList.Objects[I]));
  end;
  AAServersList.Clear;
end;

constructor TAAServiceXML.Create(AppPath: string);
begin
  xmlPath := AppPath;
  AAServersList := TStringList.Create;
  ReadXMLData;
  LoadAwardConfig;
end;

destructor TAAServiceXML.Destroy;
begin
  ClearAAServersListData;
  AAServersList.Free;
  SetLength(AwardList,0);
  inherited;
end;

function TAAServiceXML.GetMaxLevelAAServersData(
  level: Integer): PTAAServersData;
var
  I: Integer;
  ServersData: PTAAServersData;
begin
  Result := nil;
  for I := AAServersList.Count-1 downto 0 do
  begin
    ServersData := PTAAServersData(AAServersList.Objects[I]);
    if level <= ServersData.LevelMax then
    begin
      Result := ServersData;
    end;
  end;
end;

procedure TAAServiceXML.LoadAwardConfig;
var
  I: Integer;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  NodeList: IXMLDomNodeList;
begin
  CoInitialize(nil);
  xmlDoc := CoDOMDocument.Create();
  try
    if FileExists(xmlPath+AcrossAwardsFile) then
    begin
      if xmlDoc.load(xmlPath+AcrossAwardsFile) then
      begin
        xmlNode := xmlDoc.documentElement;
        if xmlNode <> nil then
        begin
          NodeList := xmlNode.selectNodes('//Award');
          SetLength(AwardList,NodeList.length);
          for I := 0 to NodeList.length - 1 do
          begin
            AwardList[I] := NodeList.item[I].attributes.getNamedItem('ItemID').nodeValue;
          end;
        end;
      end;
    end;
  finally
    xmlDoc := nil;
    CoUninitialize;
  end;
end;

procedure TAAServiceXML.ReadXMLData;
var
  I: Integer;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  NodeList: IXMLDomNodeList;
  ServersData: PTAAServersData;
begin
  CoInitialize(nil);
  xmlDoc := CoDOMDocument.Create();
  try
    if FileExists(xmlPath+AAServiceFile) then
    begin
      if xmlDoc.load(xmlPath+AAServiceFile) then
      begin
        xmlNode := xmlDoc.documentElement;
        if xmlNode <> nil then
        begin
          SPID := xmlNode.selectSingleNode('SPID').text;
          ServerIDBase := StrToInt(xmlNode.selectSingleNode('ServerIDBase').text);
          Expense := StrToInt(xmlNode.selectSingleNode('Expense').text);
          SQLUserName := xmlNode.selectSingleNode('SQLUser').attributes.getNamedItem('user').nodeValue;
          SQLUserPass := xmlNode.selectSingleNode('SQLUser').attributes.getNamedItem('pass').nodeValue;
          ServerList := xmlNode.selectSingleNode('ServerList').text;
          NodeList := xmlNode.selectNodes('//Server');
          ClearAAServersListData;
          for I := 0 to NodeList.length - 1 do
          begin
            New(ServersData);
            ServersData.Index := NodeList.item[I].attributes.getNamedItem('id').nodeValue;
            ServersData.Name := NodeList.item[I].attributes.getNamedItem('name').nodeValue;
            ServersData.LevelMax := NodeList.item[I].attributes.getNamedItem('LevelMax').nodeValue;
            ServersData.DBServer := NodeList.item[I].attributes.getNamedItem('db').nodeValue;
            ServersData.DataBase := NodeList.item[I].attributes.getNamedItem('database').nodeValue;
            AAServersList.AddObject(IntToStr(ServersData.LevelMax),TObject(ServersData));
          end;
        end;
      end;
    end;
  finally
    xmlDoc := nil;
    CoUninitialize;
  end;
end;

end.
