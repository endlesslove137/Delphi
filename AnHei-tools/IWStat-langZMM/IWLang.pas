(*
  功能：语言包 用于切换后台语言
  版本：V1.0.0.0
  创建日期：2013-03-11 14：30
  更新日期：2013-03-11 19：00
*)

unit IWLang;

interface

uses Classes, Windows, SysUtils, MSXML, ActiveX;

type
  TLangInfo = packed record
    Num: Integer;      //语言类型
    idx: Integer;      //序号
    CaptionName: string; //标题名称
  end;
  PTLangInfo = ^TLangInfo;

  TLangFile = class
    ilist: TList;
  private
    procedure ClearScript;
  public
    constructor Create;
    destructor Destroy; override;

    function Find(Num, idx: Integer): string;
    function Add(pli: PTLangInfo): Boolean;

    procedure LoadLangFile(num: Integer = 0);
    procedure ReLoadLangFile(num: Integer);
  end;


implementation

uses ServerController;

constructor TLangFile.Create;
begin
  inherited;
  ilist:= TList.Create;
end;

destructor TLangFile.Destroy;
begin
  ClearScript();

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

function TLangFile.Find(Num, idx: Integer): string;
var
  i: Integer;
  pli: PTLangInfo;
begin
  Result := '';
  for i := 0 to ilist.Count - 1 do
  begin
    pli := PTLangInfo(ilist.Items[i]);
    if pli <> nil then
    if (pli.Num = Num) and (pli.idx = idx) then begin
      Result := pli.CaptionName;
      Break;
    end;
  end;
end;

function TLangFile.Add(pli: PTLangInfo): Boolean;
begin
  Result := False;
  if Find(pli.Num, pli.idx) <> '' then Exit;
  ilist.Add(pli);
  Result := True;
end;

procedure TLangFile.ReLoadLangFile(num: Integer);
begin
  ClearScript;
  LoadLangFile(num);
end;

function LangsTypestr(num: Integer): string;
begin
  case num of
     0 : Result := 'Lang\Chinese.xml';      //中文
  else
     Result := 'Lang\Language' + inttostr(num)+ '.xml';
  end;
end;

procedure TLangFile.LoadLangFile(num: Integer);
var
  i: Integer;
  pli: PTLangInfo;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
begin
  CoInitialize(nil);
  xmlDoc := CoDOMDocument.Create();
  try
    if FileExists(AppPathEx + LangsTypestr(num)) then
    begin
      if xmlDoc.load(AppPathEx + LangsTypestr(num)) then
      begin
        xmlNode := xmlDoc.documentElement;
        if xmlNode <> nil then
        begin
          for I := 0 to xmlNode.childNodes.length - 1 do
          begin
            New(pli);
            pli.Num := num;
            pli.idx := xmlNode.childNodes.item[I].attributes.getNamedItem('idx').nodeValue;
            pli.CaptionName := xmlNode.childNodes.item[I].attributes.getNamedItem('name').nodeValue;
            Add(pli);
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
