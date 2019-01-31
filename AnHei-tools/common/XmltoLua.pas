unit XmltoLua;

interface

uses MSXML, Classes, SysUtils, dialogs;

type
  TOnGetXMLValue = function (FNode,Node: IXMLDOMNode): string of Object;
  TOnGetXMLNode = function (Node: IXMLDOMNode): string of Object;

  TXmlToLua = class
  private
    FBaseName: string;
    FMainFile: string;
    FChildFile: string;
    FFilterZero: Boolean;
    FOnGetXMLValue: TOnGetXMLValue;
    FOnGetXMLNode: TOnGetXMLNode;
    procedure ReadXmlNode(FNode: IXMLDOMNode;var StrList: TStringList);
    function GetParentCount(FNode: IXMLDOMNode): Integer;
    function SetOnGetXMLValue(FNode,Node: IXMLDOMNode): string;
    function SetOnGetXMLNode(FNode: IXMLDOMNode): string;
  public
    constructor Create();
    function XmlToLua(NodeList: IXMLDOMNodeList;sInclude,IdNode: string; sMaster: string = ''): string;
    property OnGetXMLValue: TOnGetXMLValue read FOnGetXMLValue write FOnGetXMLValue;
    property OnGetXMLNode: TOnGetXMLNode read FOnGetXMLNode write FOnGetXMLNode;
    property sMainFile: string read FMainFile write FMainFile;
    property sChildFile: string read FChildFile write FChildFile;
    property bFilterZero: Boolean read FFilterZero write FFilterZero;
  end;

implementation

{ TXmlToLua }

constructor TXmlToLua.Create;
begin
  bFilterZero := True;
end;

function TXmlToLua.GetParentCount(FNode: IXMLDOMNode): Integer;
var
  Node: IXMLDOMNode;
begin
  Result := 0;
  Node := FNode;
  while Node <> nil do
  begin
    if Node.nodeName = FBaseName then break;
    Node := Node.parentNode;
    if Node = nil then break;
    Inc(Result);
  end;
end;

procedure TXmlToLua.ReadXmlNode(FNode: IXMLDOMNode; var StrList: TStringList);
var
  I: Integer;
  bLine: Boolean;
  sTab,S,sNode,sValue: string;
begin
  sTab := StringOfChar(#9,GetParentCount(FNode));
  bLine := (FNode.childNodes.length > 0) or (FNode.nodeName = FBaseName);
  sNode := SetOnGetXMLNode(FNode);
  S := '';
  if sNode <> '' then
  begin
    if bLine then
      StrList.Add(sTab + sNode)
    else begin
      S := sTab + sNode;
    end;
  end;
  for I := 0 to FNode.attributes.length - 1 do
  begin
    if bLine then
    begin
      sValue := SetOnGetXMLValue(FNode,FNode.attributes[I]);
      if sValue <> '' then
      begin
        if Pos(#13, sValue) > 0 then
         StrList.Add(sValue)
        else
         StrList.Add(sTab + #9 + sValue);
      end;
    end
    else begin
      sValue := SetOnGetXMLValue(FNode,FNode.attributes[I]);
      if sValue <> '' then
      begin
        if Pos(#13, sValue) > 0 then
         S := S + sValue
        else
         S := S + ' ' + sValue;

      end;
    end;
  end;
  for I := 0 to FNode.childNodes.length - 1 do
  begin
    ReadXmlNode(FNode.childNodes[I],StrList);
  end;
  if sNode <> '' then
  begin
    if bLine then
      StrList.Add(sTab + '},')
    else
      StrList.Add(S+' },');
  end;
end;

function TXmlToLua.SetOnGetXMLNode(FNode: IXMLDOMNode): string;
begin
  Result := FNode.nodeName + ' = {';
  if Assigned(OnGetXMLNode) then
  begin
    Result := OnGetXMLNode(FNode);
  end;
end;

function TXmlToLua.SetOnGetXMLValue(FNode,Node: IXMLDOMNode): string;
begin
  Result := Node.nodeName + ' = ' + Node.nodeValue + ',';
  if Assigned(OnGetXMLValue) then
  begin
    Result := OnGetXMLValue(FNode,Node)
  end;
end;

function TXmlToLua.XmlToLua(NodeList: IXMLDOMNodeList;sInclude,IdNode: string; sMaster: string): string;
var
  I,Id: Integer;
  sName,sBaseName: string;
  strList: TStringList;
begin
  strList := TStringList.Create;
  try
    if sMaster <> '' then
    begin
      sBaseName := sMaster;
    end
    else begin
      if NodeList.length > 0 then
      begin
        if NodeList[0].parentNode <> nil then
          sBaseName := NodeList[0].parentNode.nodeName;
      end;
    end;
    if sMainFile <> '' then
    begin
      strList.Add(sBaseName + ' = {');
      for I := 0 to NodeList.length - 1 do
      begin
        sName := (NodeList[I] as IXMLDOMElement).getAttribute(IdNode);
        TryStrToInt(sName,Id);
        if Id = 0 then sName := 'Sample';
        strList.Add(Format(sInclude,[sName]));
      end;
      strList.Add('}');
      strList.SaveToFile(sMainFile);
    end;
      for I := 0 to NodeList.length - 1 do
      try
        sName := (NodeList[I] as IXMLDOMElement).getAttribute(IdNode);
        TryStrToInt(sName,Id);
        FBaseName := NodeList[I].nodeName;
        if bFilterZero and (Id = 0) then continue;
        strList.Clear;
        sName := (NodeList[I] as IXMLDOMElement).getAttribute(IdNode);
        ReadXmlNode(NodeList[I],strList);
        strList.SaveToFile(Format(sChildFile,[sName]));
      except
       on e: exception do
       showmessage('¥ÌŒÛ–≈œ¢: ' + e.Message + #13#10 +  '¥ÌŒÛID: ' + sName);
      end;
  finally
    strList.Free;
  end;
end;

end.
