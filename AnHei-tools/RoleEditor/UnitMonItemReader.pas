unit UnitMonItemReader;

interface

uses
  Windows, SysUtils, Classes, msxml;

type
  PTMonItemInfo=^TMonItemInfo;
  TMonItemInfo = record
    btType: Byte;
    btResv: Byte;
    wItemId: Word;
    btQuality: ShortInt;
    btStrong: ShortInt;
    wCount: Word;
    nRate: Integer;
  end;

  TItemMonster = class
  private
    m_sName: string;
    m_ItemList: TList;
    procedure ClearItemList();
    function GetDropItemRecord(ItemId: Integer): PTMonItemInfo;
  public
    constructor Create();
    destructor Destroy();override;
    function LoadFromFile(const sFile: string): Integer;

    property DropItem[ItemId: Integer]: PTMonItemInfo read GetDropItemRecord;
  end;

  TItemOfMonsters = array of TItemMonster;
  PItemOfMonsters = ^TItemOfMonsters;

  TMonItemReader = class(TObject)
  private
    { private declarations }
    m_MonsterList: TStringList;
    m_ItemOfMonsters: array [Word] of TItemOfMonsters;
    m_sBaseDir: string;
    procedure ClearMonsterList();
    function GetMonsterByItemId(ItemId: Integer): string;
    procedure AddMonsterToItemList(Monster: TItemMonster);
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create();
    destructor Destroy();override;
    function LoadMonItems(): Integer;
    function GetMonsterListByItemId(ItemId: Integer; MonNames: TStrings): Integer;
    
    property MonsterNameOfItem[ItemId: Integer]: string read GetMonsterByItemId;
  published
    { published declarations }
    property BaseDir: string read m_sBaseDir write m_sBaseDir;
  end;

implementation

uses FuncUtil, UnitMain, UnitLangPackage;

function GetAttrValue(Element: IXMLDOMElement; AttrName: WideString; DefVal: OleVariant): OleVariant;
var
  Node: IXMLDOMAttribute;
begin
  Node := Element.getAttributeNode(AttrName);
  if Node = nil then
    Result := DefVal
  else Result := Node.value;
end;

{ TMonItemReader }

procedure TMonItemReader.AddMonsterToItemList(Monster: TItemMonster);
var
  I, nLen: Integer;
  pItem: PTMonItemInfo;     
  pMonList: PItemOfMonsters;
begin
  for I := 0 to Monster.m_ItemList.Count - 1 do
  begin
//    pItem := Monster.m_ItemList.List^[I];
    pItem := Monster.m_ItemList.List[i];
    pMonList := @m_ItemOfMonsters[pItem^.wItemId];
    nLen := Length(pMonList^);
    SetLength(pMonList^, nLen + 1);
    pMonList^[nLen] := Monster;
  end;
end;

procedure TMonItemReader.ClearMonsterList;
var
  I: Integer;
begin
  for I := 0 to m_MonsterList.Count - 1 do
  begin
    TItemMonster(m_MonsterList.Objects[I]).Free;
  end;
  m_MonsterList.Clear();
  for I := Low(m_ItemOfMonsters) to High(m_ItemOfMonsters) do
  begin
    SetLength(m_ItemOfMonsters[I], 0);
  end;
end;

constructor TMonItemReader.Create;
begin
  m_MonsterList := TStringList.Create;
  m_MonsterList.CaseSensitive := False;
  m_MonsterList.Sorted := True;
  m_sBaseDir := '.\Envir\MonItems';
end;

destructor TMonItemReader.Destroy;
begin
  ClearMonsterList();
  m_MonsterList.Free;
  inherited;
end;

function TMonItemReader.GetMonsterByItemId(ItemId: Integer): string;
var
  pMonList: PItemOfMonsters;
begin
  Result := '';
  pMonList := @m_ItemOfMonsters[ItemId];
  if Length(pMonList^) > 0 then
  begin
    Result := pMonList^[0].m_sName;
  end;
end;

function TMonItemReader.GetMonsterListByItemId(ItemId: Integer;
  MonNames: TStrings): Integer;
var
  I: Integer;
  pMonList: PItemOfMonsters;
begin
  pMonList := @m_ItemOfMonsters[ItemId];
  Result := Length(pMonList^);
  for I := 0 to Length(pMonList^) - 1 do
  begin
    MonNames.Add(pMonList^[I].m_sName);
  end;
end;

function TMonItemReader.LoadMonItems: Integer;
var
  I,nId: Integer;
  MonFile: string;
  Monster: TItemMonster;
  xmlDoc : IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;  
begin
  Result := 0;
  ClearMonsterList();
  xmlDoc := CoDOMDocument.Create();
  try
    if xmlDoc.load('.\Monsters.xml') then
    begin
      Nodes := xmlDoc.documentElement.selectNodes('//Monster');
      for I := 0 to Nodes.length - 1 do
      begin
        if Nodes[I].attributes.getNamedItem('MonItem') <> nil then
        begin
          Monster := TItemMonster.Create;
          Monster.m_sName := LanguagePackage.GetLangText(MonLangCategoryId, Nodes[I].attributes.getNamedItem('name').nodeValue);
          nId := Nodes[I].attributes.getNamedItem('MonItem').nodeValue;
          MonFile := StringOfChar('0',5-Length(IntToStr(nId)))+IntToStr(nId) + '.xml';
          Monster.LoadFromFile(m_sBaseDir + '\' + MonFile);
          m_MonsterList.AddObject(Monster.m_sName, Monster);
          AddMonsterToItemList(Monster);
          Inc( Result );
        end;
      end;
    end;
  finally
    xmlDoc := nil;
  end;
end;

{ TItemMonster }

procedure TItemMonster.ClearItemList;
var
  I: Integer;
begin
  for I := 0 to m_ItemList.Count - 1 do
  begin
    Dispose( PTMonItemInfo(m_ItemList[I]) );
  end;
  m_ItemList.Clear;
end;

constructor TItemMonster.Create;
begin
  m_ItemList := TList.Create;
end;

destructor TItemMonster.Destroy;
begin
  ClearItemList();
  m_ItemList.Free;
  inherited;
end;

function TItemMonster.GetDropItemRecord(ItemId: Integer): PTMonItemInfo;
var
  pItemInfo: PTMonItemInfo;
  I: Integer;
begin
  Result := nil;
  ItemId := ItemId + 1;
  for I := 0 to m_ItemList.Count - 1 do
  begin
    pItemInfo :=  m_ItemList[I];
    if pItemInfo^.wItemId = ItemId then
    begin
      Result := pItemInfo;
      break;
    end;
  end;
end;

function TItemMonster.LoadFromFile(const sFile: string): Integer;
var
  Doc: IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;
  I: Integer;
  Element: IXMLDOMElement;
  pItemInfo: PTMonItemInfo;
begin
  ClearItemList();

  Result := 0;
  Doc := CoDOMDocument.Create;
  if Doc.load(sFile) then
  begin
    Nodes := Doc.documentElement.selectNodes('Item');
    for I := 0 to Nodes.length - 1 do
    begin
      Element := Nodes.item[i] as IXMLDOMElement;
      New( pItemInfo );
      pItemInfo^.btType := GetAttrValue(Element, 'Type',0);
      pItemInfo^.wItemId := GetAttrValue(Element, 'Index',0);
      pItemInfo^.btQuality :=  GetAttrValue(Element, 'Count', 0);
      pItemInfo^.btStrong := GetAttrValue(Element, 'Quality', 0);
      pItemInfo^.wCount := GetAttrValue(Element, 'Strong', 0);
      pItemInfo.nRate := GetAttrValue(Element, 'ProbHigh', 0);
      m_ItemList.Add(pItemInfo);
      Inc( Result );
    end;
  end;
  Doc := nil;
end;

end.
