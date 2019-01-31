unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, luascript, MSXML;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    ItemsFlags1: TStringList;
    ItemsFlags2: TStringList;
    procedure LoadItemsFlags1;
    procedure LoadItemsFlags2;
    function ReadAttrList(FXML: IXMLDOMDocument; Element: IXMLDOMElement; DataConfig: TBaseLuaScript; AttrName: string): IXMLDOMElement;
    function ReadLevelList(FXML: IXMLDOMDocument; Element: IXMLDOMElement; DataConfig: TBaseLuaScript; AttrName: string): IXMLDOMElement;
    procedure ReadItemsFlags(FXML: IXMLDOMDocument; Element: IXMLDOMElement; DataConfig: TBaseLuaScript);
  end;

var
  Form2: TForm2;

implementation

uses UnitLangPackage;

{$R *.dfm}

{
  OpenFieldTable
  OpenGlobalTable
  成功后一定要使用
  DataConfig.CloseTable();

  bResult 默认为True
}
procedure TForm2.Button1Click(Sender: TObject);
var
  bResult: Boolean;
  S,sFileName,sPath: string;
  DataConfig: TBaseLuaScript;
  StrItemList: TList;
  Id,I,J,K,iCount,LevelCount,ItemCount: Integer;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  Element,NodeElement,LevelElement,AttrElement : IXMLDOMElement;
begin
  sPath := 'F:\WorkSVN\idgp\AnHei\!SC\Server\data\config\item\StdItems.xml';
  xmlDoc := CoDOMDocument.Create();
  xmlDoc.load(sPath);
  xmlNode := xmlDoc.documentElement;

  DataConfig := TBaseLuaScript.Create;
  StrItemList := TList.Create;
  try
    sFileName := Edit1.Text+'\config\item\StdItems.txt';
    DataConfig.SetScriptFile(sFileName);
    bResult := True;
    if DataConfig.OpenGlobalTable('StdItems') then
    begin
      ItemCount := DataConfig.GetTableLength;
      if DataConfig.EnumTableFirst() then
      begin
        for K := 0 to ItemCount - 1 do
        begin
          Element := xmlDoc.createElement('StdItem');
          Id := DataConfig.GetFieldInteger('id', bResult);
          Element.setAttribute('id',Id);
          Element.setAttribute('name',DataConfig.GetFieldString('name', bResult));
          Element.setAttribute('type',DataConfig.GetFieldInteger('type', bResult));
          Element.setAttribute('icon',DataConfig.GetFieldInteger('icon', bResult));
          Element.setAttribute('candidateIconCount',DataConfig.GetFieldInteger('candidateIconCount', bResult));
          Element.setAttribute('shape',DataConfig.GetFieldInteger('shape', bResult));
          Element.setAttribute('dura',DataConfig.GetFieldInteger('dura', bResult));
          Element.setAttribute('useDurDrop',DataConfig.GetFieldInteger('useDurDrop', bResult));
          Element.setAttribute('dup',DataConfig.GetFieldInteger('dup', bResult));
          Element.setAttribute('colGroup',DataConfig.GetFieldInteger('colGroup', bResult));
          Element.setAttribute('dealType',DataConfig.GetFieldInteger('dealType', bResult));
          Element.setAttribute('dealPrice',DataConfig.GetFieldInteger('dealPrice', bResult));
          Element.setAttribute('time',DataConfig.GetFieldInteger('time', bResult));
          Element.setAttribute('smithId',DataConfig.GetFieldInteger('smithId', bResult));
          Element.setAttribute('initSmithId',DataConfig.GetFieldInteger('initSmithId', bResult));
          Element.setAttribute('cdTime',DataConfig.GetFieldInteger('cdTime', bResult));
          Element.setAttribute('breakId',DataConfig.GetFieldInteger('breakId', bResult));
          Element.setAttribute('dropBroadcast',DataConfig.GetFieldInteger('dropBroadcast', bResult));
          Element.setAttribute('openUi',DataConfig.GetFieldString('openUi', bResult));
          Element.setAttribute('desc',DataConfig.GetFieldString('desc', bResult));
          Element.setAttribute('validFbId',DataConfig.GetFieldInteger('validFbId', bResult));
          Element.setAttribute('validSceneId',DataConfig.GetFieldInteger('validSceneId', bResult));
          Element.setAttribute('suitId',DataConfig.GetFieldInteger('suitId', bResult));
          Element.setAttribute('showQuality',DataConfig.GetFieldInteger('showQuality', bResult));
          Element.setAttribute('weight',DataConfig.GetFieldInteger('weight', bResult));
          Element.setAttribute('existScenes',DataConfig.GetFieldInteger('existScenes', bResult));
          if DataConfig.OpenFieldTable('existScenes') then
          begin
            iCount := DataConfig.GetTableLength;
            S := '';
            if DataConfig.EnumTableFirst then
            begin
              for I := 0 to iCount - 1 do
              begin
                S := S + IntToStr(DataConfig.GetFieldInteger(nil, bResult));
                if I < iCount then S := S + ',';
                DataConfig.EnumTableNext;
              end;
            end;
            if S = '' then
            begin
              S := '-1'
            end
            else begin
              S := '{' + S + '}';
            end;
            Element.setAttribute('existScenes',S);
            DataConfig.CloseTable();
          end;
          if DataConfig.OpenFieldTable('staitcAttrs') then
          begin
            NodeElement := ReadAttrList(xmlDoc,Element,DataConfig,'staitcAttrs');
            DataConfig.CloseTable();
          end;
          Element.appendChild(NodeElement);
          if DataConfig.OpenFieldTable('qualityAttrs') then
          begin
            NodeElement := ReadLevelList(xmlDoc,Element,DataConfig,'qualityAttrs');
            DataConfig.CloseTable();
          end;
          Element.appendChild(NodeElement);
          if DataConfig.OpenFieldTable('strongAttrs') then
          begin
            NodeElement := ReadLevelList(xmlDoc,Element,DataConfig,'strongAttrs');
            DataConfig.CloseTable();
          end;
          Element.appendChild(NodeElement);
          if DataConfig.OpenFieldTable('maxSmithAttrs') then
          begin
            NodeElement := ReadAttrList(xmlDoc,Element,DataConfig,'maxSmithAttrs');
            DataConfig.CloseTable();
          end;
          Element.appendChild(NodeElement);
          if DataConfig.OpenFieldTable('flags') then
          begin
            ReadItemsFlags(xmlDoc,Element,DataConfig);
            DataConfig.CloseTable();
          end;
          if DataConfig.OpenFieldTable('conds') then
          begin
            NodeElement := Element.appendChild(xmlDoc.createElement('conds')) as IXMLDOMElement;
            iCount := DataConfig.GetTableLength;
            if DataConfig.EnumTableFirst then
            begin
              for I := 0 to iCount - 1 do
              begin
                AttrElement := Element.appendChild(xmlDoc.createElement('Attr')) as IXMLDOMElement;
                AttrElement.setAttribute('cond',DataConfig.GetFieldInteger('cond', bResult));
                AttrElement.setAttribute('value',DataConfig.GetFieldNumber('value', bResult));
                NodeElement.appendChild(AttrElement);
                DataConfig.EnumTableNext;
              end;
            end;
            DataConfig.CloseTable();
          end;
          xmlNode.appendChild(Element);
          DataConfig.EnumTableNext();
        end;
      end;
      DataConfig.CloseTable();
    end;
    xmlDoc.save(sPath);
  finally
    xmlDoc := nil;
    DataConfig.Free;
    StrItemList.Free;
  end; 
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  sPath: string;
  DataConfig: TBaseLuaScript;
begin
  DataConfig := TBaseLuaScript.Create;
  try
    sPath := 'F:\WorkSVN\idgp\AnHei\!SC\Server\data\script\ZhenBeiShaMo\';
    DataConfig.SetScriptFile(sPath+'ErDangJia.txt');
  finally
    DataConfig.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  DataConfig: TBaseLuaScript;
begin
  DataConfig := TBaseLuaScript.Create;
  try
    sFileName := 'F:\WorkSVN\idgp\AnHei\!SC\Server\data\functions\MonsterFunction.txt';
    DataConfig.SetScriptFile(sFileName);
  finally
    DataConfig.Free;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Lang := TLanguagePackage.Create;
  Lang.Language := 'zh-cn';
  Lang.LoadFromDB(Edit1.Text+'\language\zh-cn.db');
  ItemsFlags1 := TStringList.Create;
  ItemsFlags2 := TStringList.Create;
  LoadItemsFlags1;
  LoadItemsFlags2;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  Lang.Free;
  ItemsFlags1.Free;
  ItemsFlags2.Free;
end;

procedure TForm2.LoadItemsFlags1;
begin
  ItemsFlags1.Add('recordLog');
  ItemsFlags1.Add('denyStorage');
  ItemsFlags1.Add('autoBindOnTake');
  ItemsFlags1.Add('autoStartTime');
  ItemsFlags1.Add('denyDeal');
  ItemsFlags1.Add('denySell');
  ItemsFlags1.Add('denyDestroy');
  ItemsFlags1.Add('destroyOnOffline');
  ItemsFlags1.Add('destroyOnDie');
  ItemsFlags1.Add('denyDropdown');
  ItemsFlags1.Add('dieDropdown');
  ItemsFlags1.Add('offlineDropdown');
  ItemsFlags1.Add('inlayable');
  ItemsFlags1.Add('hideDura');
  ItemsFlags1.Add('denySplite');
  ItemsFlags1.Add('asQuestItem');
  ItemsFlags1.Add('monAlwaysDropdown');
  ItemsFlags1.Add('hideQualityName');
  ItemsFlags1.Add('useOnPractice');
  ItemsFlags1.Add('denyTipsAutoLine');
  ItemsFlags1.Add('showLootTips');
  ItemsFlags1.Add('denyDropDua');
  ItemsFlags1.Add('denyRepair');
  ItemsFlags1.Add('canDig');
  ItemsFlags1.Add('bagSell');
  ItemsFlags1.Add('fullDel');
  ItemsFlags1.Add('diamondAlwaysActive');
  ItemsFlags1.Add('denyBuffOverlay');
  ItemsFlags1.Add('skillRemoveItem');
  ItemsFlags1.Add('denyHeroUse');
  ItemsFlags1.Add('matchAllSuit');
  ItemsFlags1.Add('notConsumeForCircleForge');
end;

procedure TForm2.LoadItemsFlags2;
begin
  ItemsFlags2.Add('notShowAppear');
  ItemsFlags2.Add('cankiss');
end;

function TForm2.ReadAttrList(FXML: IXMLDOMDocument; Element: IXMLDOMElement;
  DataConfig: TBaseLuaScript; AttrName: string): IXMLDOMElement;
var
  bResult: Boolean;
  I,iCount: Integer;
  AttrElement: IXMLDOMElement;
begin
  Result := Element.appendChild(FXML.createElement(AttrName)) as IXMLDOMElement;
  iCount := DataConfig.GetTableLength;
  if DataConfig.EnumTableFirst then
  begin
    for I := 0 to iCount - 1 do
    begin
      AttrElement := Element.appendChild(FXML.createElement('Attr')) as IXMLDOMElement;
      AttrElement.setAttribute('type',DataConfig.GetFieldInteger('type', bResult));
      AttrElement.setAttribute('value',DataConfig.GetFieldNumber('value', bResult));
      Result.appendChild(AttrElement);
      DataConfig.EnumTableNext;
    end;
  end;
end;

procedure TForm2.ReadItemsFlags(FXML: IXMLDOMDocument; Element: IXMLDOMElement;
  DataConfig: TBaseLuaScript);
var
  bResult: Boolean;
  I,flag1,flag2: Integer;
begin
  flag1 := 0;
  for I := 0 to ItemsFlags1.Count - 1 do
  begin
    if DataConfig.GetFieldBoolean(PChar(ItemsFlags1.Strings[I]),bResult) then
    begin
      flag1 := flag1 or (1 shl I);
    end;
  end;
  flag2 := 0;
  for I := 0 to ItemsFlags2.Count - 1 do
  begin
    if DataConfig.GetFieldBoolean(PChar(ItemsFlags2.Strings[I]),bResult) then
    begin
      flag2 := flag2 or (1 shl I);
    end;
  end;
  Element.setAttribute('flag1',flag1);
  Element.setAttribute('flag2',flag2);
end;

function TForm2.ReadLevelList(FXML: IXMLDOMDocument; Element: IXMLDOMElement;
  DataConfig: TBaseLuaScript; AttrName: string): IXMLDOMElement;
var
  bResult: Boolean;
  I,J,LevelCount,iCount: Integer;
  LevelElement,AttrElement: IXMLDOMElement;
begin
  Result := Element.appendChild(FXML.createElement(AttrName)) as IXMLDOMElement;
  LevelCount := DataConfig.GetTableLength;
  if DataConfig.EnumTableFirst then
  begin
    for I := 0 to LevelCount - 1 do
    begin
      LevelElement := Element.appendChild(FXML.createElement('Level')) as IXMLDOMElement;
      iCount := DataConfig.GetTableLength;
      if DataConfig.EnumTableFirst then
      begin
        for J := 0 to iCount - 1 do
        begin
          AttrElement := Element.appendChild(FXML.createElement('Attr')) as IXMLDOMElement;
          AttrElement.setAttribute('type',DataConfig.GetFieldInteger('type', bResult));
          AttrElement.setAttribute('value',DataConfig.GetFieldNumber('value', bResult));
          LevelElement.appendChild(AttrElement);
          DataConfig.EnumTableNext;
        end;
      end;
      Result.appendChild(LevelElement);
      DataConfig.EnumTableNext;
    end;
  end;
end;

end.
