unit UnitStdXmlForm;

interface

uses
  SysUtils, Forms, msxml;

const
  DOCVersionAttrName  = 'Version';
  DOCUpdateDateTimeAttrName = 'Update';
  DOCDesignAttrName = 'Design';
  DOCNextIDAttrName = 'NextID';

type
  TStdXmlForm = class(TForm)
  private
    { private declarations }      
    procedure SetFileName(const Value: string);
  protected
    { protected declarations }
    FFileName       : string;
    FXML            : IXMLDOMDocument;
    FBaseNode       : IXMLDOMNode;  
    FSaveFlag       : Boolean;        
    FAutoIncrementId: Integer;
    function  GetMainComment():string;virtual;
    function  ReadXMLData():Boolean;virtual;    
    procedure ChangeDocumentBaseInfo(AttrNode: IXMLDOMNode);virtual;
    procedure Save();virtual;
    procedure SaveDocument();virtual;
    procedure RaiseXMLError();overload;virtual;
    procedure RaiseXMLError(const XmlDoc: IXMLDOMDocument);overload;virtual;
    function GetDocVersion: string;virtual;
    function GetDocumentNodeName: string;virtual;   
    function  AllocAutoIncrementId():Integer;    
  public
    { public declarations  }
    
    procedure CreateNewFile(const FileName: string);virtual;
    procedure Open(const FileName: string);virtual;
  published
    { published declarations }
    property FileName: string read FFileName write SetFileName;
    property DocVersion: string read GetDocVersion;
    property DocumentNodeName: string read GetDocumentNodeName;
  end;

implementation

{ TStdXmlForm }

function TStdXmlForm.AllocAutoIncrementId: Integer;
begin
  Result := FAutoIncrementId;
  Inc( FAutoIncrementId );
end;

procedure TStdXmlForm.ChangeDocumentBaseInfo(AttrNode: IXMLDOMNode);
begin
  with AttrNode as IXMLDOMElement do
  begin
    setAttribute( DOCVersionAttrName, DocVersion );
    setAttribute( DOCUpdateDateTimeAttrName,
      FormatDateTime( 'yyyy-mm-dd hh:nn:ss', Now ) );
    setAttribute( DOCDesignAttrName, 'Miros' );
    setAttribute( DOCNextIDAttrName, FAutoIncrementId );
  end;
end;

procedure TStdXmlForm.CreateNewFile(const FileName: string);
var
  xml   : IXMLDOMDocument;
  node  : IXMLDOMNode;
begin
  xml := CoDOMDocument.Create();
  xml.appendChild(xml.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"'));
  xml.appendChild(xml.createComment(GetMainComment()));
  node  := xml.appendChild(xml.createElement(DocumentNodeName));
  FAutoIncrementId := 1;
  ChangeDocumentBaseInfo( node );
  xml.save(FileName);
  RaiseXMLError( xml );
  xml := nil;
  Open(FileName);
end;

function TStdXmlForm.GetDocumentNodeName: string;
begin
  Result := 'stdxmlform';
end;

function TStdXmlForm.GetDocVersion: string;
begin
  Result := '0.0.0.0';
end;

function TStdXmlForm.GetMainComment: string;
begin
  Result := '';
end;

procedure TStdXmlForm.Open(const FileName: string);
begin
  FFileName := FileName;
  FXML  := CoDOMDocument.Create();
  FXML.load(FileName);
  if FXML.parseError.errorCode <> 0  then
    Raise Exception.CreateFmt('加载XML文件:'#13#10'%s'#13#10'失败'#13#10'错误码:[%d]'#13#10'错误消息:[%s]', [FileName, FXML.parseError.errorCode, FXML.parseError.reason]);
  FBaseNode := FXML.documentElement;
  if not ReadXMLData() then
    Raise Exception.Create('非有效的文件类型!');
  Show();
end;

procedure TStdXmlForm.RaiseXMLError;
begin  
  if FXML.parseError.errorCode <> 0 then
    Raise Exception.Create( FXML.parseError.reason );
end;

procedure TStdXmlForm.RaiseXMLError(const XmlDoc: IXMLDOMDocument);
begin    
  if XmlDoc.parseError.errorCode <> 0 then
    Raise Exception.Create( XmlDoc.parseError.reason );
end;

function TStdXmlForm.ReadXMLData: Boolean;
begin
  Result := False;

  if FBaseNode <> nil then
  begin
    FAutoIncrementId := FBaseNode.attributes.getNamedItem( DOCNextIDAttrName ).nodeValue;
    Result := True;
  end;
end;

procedure TStdXmlForm.Save;
begin
  FSaveFlag := True;
end;

procedure TStdXmlForm.SaveDocument;
begin 
  ChangeDocumentBaseInfo( FBaseNode );
  FXML.save( FFileName );
  RaiseXMLError();
  FSaveFlag := False;
end;

procedure TStdXmlForm.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

end.
