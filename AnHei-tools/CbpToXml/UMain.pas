unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzBtnEdt, Buttons, ExtCtrls, RzPanel,
  RzPrgres, ComCBPRead_TLB, msxml, ComCtrls;

type
  TForm1 = class(TForm)
    RzPanel1: TRzPanel;
    btnToXml: TSpeedButton;
    RZBT1: TRzButtonEdit;
    dlgOpen1: TOpenDialog;
    pb1: TProgressBar;
    procedure RZBT1ButtonClick(Sender: TObject);
    procedure btnToXmlClick(Sender: TObject);
  private
    procedure CreateXML;
    procedure WriteToXml(const Field: ILuaField; var Ele: IXMLDOMElement);
    { Private declarations }
  public
    { Public declarations }
    CbpFileName: string;
    XmlFileName,RootName: string;
    xml   : IXMLDOMDocument;
    FBaseNode       : IXMLDOMNode;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}





procedure TForm1.btnToXmlClick(Sender: TObject);
var
  cbp: IComBinaryProperty;
  ValueField,ItemsField,TableField,LuaField: ILuaField;
  i, j, nodecount :integer;
  nodename , nodevalue : string;
  MainEle: IXMLDOMElement;
begin
  cbp := CreateLocalComBinaryProperty;
  try
    LuaField := cbp.LoadCBPFile(CbpFileName);
    CreateXML();
    pb1.Max :=  LuaField.FieldCount;
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;  //子列表
      if TableField <> nil then
      begin
       MainEle := fbasenode.appendChild(xml.createElement('Arra' + RootName)) as IXMLDOMElement;
       WriteToXml(TableField, MainEle);
      end;
      xml.save(XmlFileName);
    pb1.Position := i + 1;
    end;
  finally
    cbp := nil;
    xml := nil;
    btnToXml.Enabled := false;
  end;
end;

procedure TForm1.WriteToXml(const Field:ILuaField; var Ele:IXMLDOMElement);
var
 i, j, nodecount : integer;
 ItemsField, SubItemsField: ILuaField;
 nodevalue, nodename, tempStr: string;
 SubEle, SubEle1 : IXMLDOMElement;
 x: ixmldomnode;
begin
  if Field <> nil then
  begin
    for i := 0 to Field.FieldCount-1 do
    begin
      ItemsField := Field.FieldIndex[i];
      nodename := ItemsField.Name;
      nodecount := ItemsField.FieldCount;
      try
       nodevalue := ItemsField.AsString;
      except
       nodevalue := '';
      end;
      if nodecount <= 0then
      begin
        Ele.setAttribute( nodename, nodevalue );
      end else
      begin
       SubEle := Ele.appendChild(xml.createElement('Table' + nodename)) as IXMLDOMElement;
       for j := 0 to ItemsField.FieldCount-1 do
       begin

        SubEle1 := SubEle.appendChild(xml.createElement('Arra' + nodename)) as IXMLDOMElement;
        SubItemsField := ItemsField.FieldIndex[j];
//        nodename := SubItemsField.Name;
//        nodecount := SubItemsField.FieldCount;
//        SubItemsField := SubItemsField.GetTableValue;
//        nodename := SubItemsField.SeriesText;
        try
         SubItemsField := ItemsField.FieldIndex[j].AsTable;
        except
         continue;
        end;
        WriteToXml(SubItemsField,SubEle1);

       end;
      end;
    end;
  end;
end;


procedure TForm1.CreateXML();
var
  node  : IXMLDOMNode;
  Ele:IXMLDOMElement;
begin
  xml := CoDOMDocument.Create();
  xml.appendChild(xml.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"'));
  node  := xml.appendChild(xml.createElement(extractfilename(XmlFileName)));
  FBaseNode := xml.documentElement;
  xml.save(XmlFileName);
end;


procedure TForm1.RZBT1ButtonClick(Sender: TObject);

begin
 dlgOpen1.FileName := 'D:\mine\百度网盘\我的文档\work\program\521g\idgp\AnHei\!SC\Client\lang\zh-cn\activity.cbp';
 if dlgOpen1.Execute then
 begin
   RZBT1.Text := dlgOpen1.FileName;
   CbpFileName :=dlgOpen1.FileName;
   XmlFileName := changefileext(CbpFileName, '.xml');
   RootName := stringreplace(Extractfilename(XmlFileName), '.xml','',[rfReplaceAll]);
   if fileexists(CbpFileName) then
    btnToXml.Enabled := true
   else
    btnToXml.Enabled := false
 end;
end;

end.
