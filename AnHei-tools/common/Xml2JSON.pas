unit Xml2JSON;

interface

uses MSXML, Classes, SysUtils, dialogs;

const
  SJSonAttr = '"%s":"%s"';
  SJSonRecord = '"%s":{';
  SJSonRecordFiter = '{';
  SJSonRecordend = '}';
  SJSonRecordend2 = '},';
  SJSonArray = '"%s":[';
  SJSonArrayFilter = '[';
  SJSonArrayEnd = ']';
  SSplite = ',';
type
  TOnGetXMLValue = function (FNode,Node: IXMLDOMNode): string of Object;
  TOnGetXMLNode = function (Node: IXMLDOMNode): string of Object;

  TXml2JSON = class
  private
    FBaseName: string;
//    FMainFile: string;
    FJSONFileName: string;
    FFilterZero: Boolean;
    FOnGetXMLValue: TOnGetXMLValue;
    FOnGetXMLNode: TOnGetXMLNode;
    procedure ReadXmlNode(FNode: IXMLDOMNode;var StrList: TStringList; Blast:Boolean=false);
    function GetParentCount(FNode: IXMLDOMNode): Integer;
    function SetOnGetXMLValue(FNode,Node: IXMLDOMNode): string;
    function SetOnGetXMLNode(FNode: IXMLDOMNode): string;
  public
    constructor Create();
    function Xml2JSON(NodeList: IXMLDOMNodeList;IdNode: string; sMaster: string = ''): string;
    property OnGetXMLValue: TOnGetXMLValue read FOnGetXMLValue write FOnGetXMLValue;
    property OnGetXMLNode: TOnGetXMLNode read FOnGetXMLNode write FOnGetXMLNode;
//    property sMainFile: string read FMainFile write FMainFile;
    property JSONFileName: string read FJSONFileName write FJSONFileName;
    property bFilterZero: Boolean read FFilterZero write FFilterZero;
  end;

implementation

{ TXml2JSON }

constructor TXml2JSON.Create;
begin
  bFilterZero := True;
end;

function TXml2JSON.GetParentCount(FNode: IXMLDOMNode): Integer;
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

procedure TXml2JSON.ReadXmlNode(FNode: IXMLDOMNode; var StrList: TStringList; Blast:boolean);
var
  I: Integer;
  bLine: Boolean;
  sTab,S,sNode,sValue, sAdd: string;
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
    sValue := SetOnGetXMLValue(FNode,FNode.attributes[I]);
    if sValue <> '' then
    begin
      if (FNode.hasChildNodes) or (i <> FNode.attributes.length - 1) then  sValue := sValue + SSplite;

      if bLine then
          StrList.Add(sTab + #9 + sValue)
      else
          S := S + ' ' + sValue;
    end;
  end;
  
  for I := 0 to FNode.childNodes.length - 1 do
  begin
    ReadXmlNode(FNode.childNodes[I],StrList, I=FNode.childNodes.length - 1);
  end;

  if sNode <> '' then
  begin
    if FNode.attributes.length <> 0 then
     sAdd := SJSonRecordend
    else
     sAdd := SJSonArrayEnd;
    if not Blast  then  sAdd := sadd + SSplite;
    if bLine then
      StrList.Add(sTab + sAdd)
    else
      StrList.Add(S + sAdd);
  end;
end;

function TXml2JSON.SetOnGetXMLNode(FNode: IXMLDOMNode): string;
var
 iAttr :integer;
 stemp : string;
 BRecode: boolean;
begin
//  Result := FNode.nodeName + ' = {';
  if Assigned(OnGetXMLNode) then
  begin
    Result := OnGetXMLNode(FNode);
  end;

  iAttr := FNode.attributes.length;
  BRecode := iAttr <> 0;
  if Trim(Result) = '' then
  begin
    if BRecode  then
     stemp := SJSonRecordFiter
    else
     stemp := SJSonArrayFilter;
  end
  else
  begin
    if BRecode  then
     stemp := Format(SJSonRecord, [FNode.nodeName])
    else
     stemp := Format(SJSonArray, [FNode.nodeName]);
  end;
  Result :=stemp;


end;

function TXml2JSON.SetOnGetXMLValue(FNode,Node: IXMLDOMNode): string;
begin

  Result := Format(SJSonAttr, [Node.nodeName, Node.nodeValue]);
  if Assigned(OnGetXMLValue) then
  begin
    Result := OnGetXMLValue(FNode,Node)
  end;
end;

function TXml2JSON.Xml2JSON(NodeList: IXMLDOMNodeList;IdNode: string; sMaster: string): string;
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
    strList.Clear;
    strList.Add(SJSonArrayFilter);;
    for I := 0 to NodeList.length - 1 do
    try
      sName := (NodeList[I] as IXMLDOMElement).getAttribute(IdNode);
      TryStrToInt(sName,Id);
      FBaseName := NodeList[I].nodeName;
      if bFilterZero and (Id = 0) then continue;
      ReadXmlNode(NodeList[I],strList);
    except
     on e: exception do
     showmessage('JSON¥ÌŒÛ–≈œ¢: ' + e.Message + #13#10 +  '¥ÌŒÛID: ' + sName);
    end;
    if Trim(strList[strList.Count -1]) = SJSonRecordend2  then
     strList[strList.Count -1] := SJSonRecordend;
    strList.Add(SJSonArrayEnd);;
    strList.SaveToFile(FJSONFileName);

  finally
    strList.Free;
  end;
end;

end.
