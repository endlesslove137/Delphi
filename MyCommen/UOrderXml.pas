unit UOrderXml;

interface
uses
 msxml, sysutils;


procedure ChangeNodeName(var RootNode: IXMLDOMNode; NodePath: WideString; NewName: WideString);

implementation

procedure SetAttrLangText(Element: IXMLDOMElement; LangID: Integer;AttrName, Text: Widestring);
var
  AttrNode: IXMLDOMNode;
begin
  AttrNode := Element.attributes.getNamedItem(AttrName);
  if (AttrNode <> nil) and (AttrNode.nodeValue <> 0) then
  begin
//    LanguagePackage.ReplaceLangText(LangID, AttrNode.nodeValue,Text);
  end
  else begin
//    Element.setAttribute(AttrName, LanguagePackage.AddLangText(LangID, Text));
  end;
end;


function GetAttrLangText(Element: IXMLDOMElement; LangID: Integer; AttrName: string): Widestring;
var
  AttrNode: IXMLDOMNode;
begin
  AttrNode := Element.attributes.getNamedItem(AttrName);
  if (AttrNode <> nil) and (AttrNode.nodeValue <> 0) then
  begin
//    Result := LanguagePackage.GetLangText(LangID, AttrNode.nodeValue);
  end
  else begin
    Result := '';
  end;
end;

function TryGetAttrValue(Element: IXMLDOMElement; AttrName: string): Variant;
var
  AttrNode: IXMLDOMNode;
begin
  Result := 0;
  AttrNode := Element.attributes.getNamedItem(AttrName);
  if (AttrNode <> nil) and (Trim(AttrNode.nodeValue) <> '') then
    Result := AttrNode.nodeValue
  else
    Exit;
end;



procedure ChangeNodeName(var RootNode: IXMLDOMNode; NodePath: WideString; NewName: WideString);
var
 NodeList: IXMLDOMNodeList;
 i, j: integer;
 SourEle: IXMLDOMElement;
 TagNode: IXMLDOMNode;
 FXML: IXMLDOMDocument;
begin
  FXML  := CoDOMDocument.Create();
  NodeList := RootNode.selectNodes('//' + NodePath);
  for I := NodeList.length -1 downto 0 do
  begin
   SourEle := NodeList[i] as IXMLDOMElement;
   TagNode := FXML.createElement(NewName);
   for j := 0 to SourEle.childNodes.length - 1 do
   begin
    TagNode.appendChild(SourEle.childNodes[j].cloneNode(True));
   end;
    NodeList[i].parentNode.appendChild(TagNode);
    NodeList[i].parentNode.removeChild(NodeList[i]);
  end;
  FXML := nil;
end;


end.
