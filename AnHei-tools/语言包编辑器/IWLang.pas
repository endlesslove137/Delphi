(*
  功能：语言包 用于切换后台语言
  版本：V1.0.0.0
  创建日期：2013-03-11 14：30
  更新日期：2013-03-11 19：00
*)

unit IWLang;

interface

uses Classes, Windows, DateUtils, SysUtils, Dialogs, MSXML;

type
  TLangInfo = packed record
    idx: Integer;      //序号
    CaptionName: string; //标题名称
  end;
  PTLangInfo = ^TLangInfo;

  TLangFile = class
  private
    xmlDoc : IXMLDOMDocument;
    xmlNode: IXMLDomNode;
    procedure ClearScript;
  public
    ilist: TList;
    userNode: IXMLDomNode;
    constructor Create;
    destructor Destroy; override;

    function Find(str: string): string;
    function FindEx(str: string): Integer;
    function Add(pli: PTLangInfo): Boolean;

    function AddXML(pli: PTLangInfo; files: string): Boolean;
    function ChgXML(pli: PTLangInfo; files: string): Boolean;
    procedure DelXML(idx: Integer; files: string);

    procedure LoadLangFile(files: string);
    procedure ReLoadLangFile(idx: Integer);
  end;

var
   Alang: TLangFile;

implementation


constructor TLangFile.Create;
begin
  inherited;
  ilist:= TList.Create;
end;

destructor TLangFile.Destroy;
begin
  ClearScript();
  xmlDoc := nil;
  ilist.Free;
  inherited;
end;

//处理清除
procedure TLangFile.ClearScript;
var
  i: Integer;
begin
  for i := 0 to ilist.Count - 1 do
  begin
    if PTLangInfo(ilist.Items[i]) <> nil then
      DisPose(PTLangInfo(ilist.Items[i]));
  end;
  ilist.Clear;
end;

function TLangFile.Find(str: string): string;
var
  i: Integer;
  pli: PTLangInfo;
begin
  Result := '';
  for i := 0 to ilist.Count - 1 do
  begin
    pli := PTLangInfo(ilist.Items[i]);
    if pli <> nil then
    if pli.CaptionName = str then begin
      Result := pli.CaptionName;
      Break;
    end;
  end;
end;

function TLangFile.FindEx(str: string): Integer;
var
  i: Integer;
  pli: PTLangInfo;
begin
  Result := -1;
  for i := 0 to ilist.Count - 1 do
  begin
    pli := PTLangInfo(ilist.Items[i]);
    if pli <> nil then
    if pli.CaptionName = str then begin
      Result := pli.idx;
      Break;
    end;
  end;
end;

function TLangFile.Add(pli: PTLangInfo): Boolean;
begin
  Result := False;
  if Find( pli.CaptionName) <> '' then Exit;
  ilist.Add(pli);
  Result := True;
end;

function TLangFile.AddXml(pli: PTLangInfo; files: string): Boolean;
var
  Element : IXMLDOMElement;
begin
  Result := False;
  if Find(pli.CaptionName) <> '' then Exit;
  ilist.Add(pli);

  userNode := xmlNode.appendChild(xmlDoc.createElement('Caption'));
  Element := userNode as IXMLDOMElement;

  Element.setAttribute('idx',pli.idx);
  Element.setAttribute('name',pli.CaptionName);
  xmlDoc.save(files);
  Result := True;
end;

function TLangFile.ChgXml(pli: PTLangInfo; files: string): Boolean;
var
  Element : IXMLDOMElement;
begin
  Result := False;
  if Find( pli.CaptionName) = '' then Exit;

  userNode := xmlDoc.selectSingleNode(format('//*[@idx=''%s'']',[inttostr(pli.idx)]));
  Element := userNode as IXMLDOMElement;
  Element.setAttribute('idx',inttostr(pli.idx));
  Element.setAttribute('name',pli.CaptionName);
  xmlDoc.save(files);
  Result := True;
end;

procedure TLangFile.DelXML(idx: Integer; files: string);
var
  i: Integer;
  pli: PTLangInfo;
begin
  for I := 0 to ilist.Count - 1 do
  begin
    pli := PTLangInfo(ilist.Items[i]);
    if pli <> nil then
    if pli.idx = idx then begin
      userNode := xmlDoc.selectSingleNode(format('//*[@idx=''%s'']',[inttostr(idx)]));
      userNode.parentNode.removeChild(userNode);
      xmlDoc.save(files);
      ilist.Delete(i);
      Dispose(pli);
      Break;
    end;
  end;
end;


procedure TLangFile.ReLoadLangFile(idx: Integer);
begin
  ClearScript;
  LoadLangFile('');
end;

procedure TLangFile.LoadLangFile(files: string);
var
  i: Integer;
  pli: PTLangInfo;
begin
  xmlDoc := CoDOMDocument.Create();
  if xmlDoc.load(files) then
  begin
    xmlNode := xmlDoc.documentElement;
    for I := 0 to xmlNode.childNodes.length - 1 do
    begin
      New(pli);
      pli.idx := xmlNode.childNodes.item[I].attributes.getNamedItem('idx').nodeValue;
      pli.CaptionName := xmlNode.childNodes.item[I].attributes.getNamedItem('name').nodeValue;
     // if not Add(pli) then
     //   MessageDlg ( pli.CaptionName + ' .' + IntToStr(pli.idx), mtWarning, [mbOk], 0);
      Add(pli);
    end;
  end;
end;

end.
