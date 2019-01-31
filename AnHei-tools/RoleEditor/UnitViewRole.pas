unit UnitViewRole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, msxml, Spin, CheckLst;

type
  TfrmViewRoleInfo = class(TForm)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Memo1: TMemo;
    Edit3: TEdit;
    Label7: TLabel;
    ListView1: TListView;
    Label8: TLabel;
    ListView2: TListView;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    Edit7: TEdit;
    Label11: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label12: TLabel;
    Edit8: TEdit;
    Label21: TLabel;
    ComboBox5: TComboBox;
    GroupBox9: TGroupBox;
    Label22: TLabel;
    CheckListBox1: TCheckListBox;
    SpinEdit9: TSpinEdit;
    SpinEdit10: TSpinEdit;
    CheckBox1: TCheckBox;
    Label18: TLabel;
    Label23: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label14: TLabel;
    Edit12: TEdit;
    Label15: TLabel;
    Edit13: TEdit;
    Edit14: TEdit;
    Label17: TLabel;
    Label20: TLabel;
    Edit15: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    EditRoleCountry: TEdit;
    Label13: TLabel;
    ComboBox1: TComboBox;
    Label16: TLabel;
    Label19: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    ComboBox2: TComboBox;
    CheckBox2: TCheckBox;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    dtpEffectiveDate: TDateTimePicker;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    dtpEndDate: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ShowRoleItems(Role: IXMLDOMNode);
    procedure ShowRoleAwards(Role: IXMLDOMNode);
  public
    { Public declarations }
    procedure ShowRoleInfo(const Role: IXMLDOMNode);
  end;

var
  frmViewRoleInfo: TfrmViewRoleInfo;

implementation

uses UnitMain, UnitLangPackage;

{$R *.dfm}

{ TfrmViewRoleInfo }

procedure TfrmViewRoleInfo.FormCreate(Sender: TObject);
const
  dColor  = clWhite;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TEdit then
      TEdit(Components[I]).Color := dColor;
    if Components[I] is TMemo then
      TMemo(Components[I]).Color := dColor;
    if Components[I] is TListView then
      TListView(Components[I]).Color := dColor;
    if Components[I] is TScrollBox then
      TScrollBox(Components[I]).Color := dColor;
  end;
  ScrollBox1.DoubleBuffered := True;
end;

procedure TfrmViewRoleInfo.ShowRoleAwards(Role: IXMLDOMNode);
Resourcestring
  sQueryAwardsNodeStr= RoleAwardsSecName;
var
  Node, SubNode: IXMLDOMNode;
  I, nVal, J: Integer;
  S, S1: string;
begin
  ListView2.Clear;
  Node  := Role.selectSingleNode(RoleAwardsSecName);
  if Node = nil then
    Exit;
  for I := 0 to Node.childNodes.length - 1 do
    begin
    SubNode := Node.childNodes.item[I];
    nVal    := SubNode.attributes.getNamedItem(AwardModeAtbName).nodeValue;
    with ListView2.Items.Add do
    begin
      Caption := GetRoleAwardModeStr(nVal);
      StateIndex :=  nVal;
      nVal  := SubNode.attributes.getNamedItem(AWardItemIdAtbName).nodeValue;
      case TRoleAwardMode(StateIndex) of
        raItem:
        begin
          SubItems.AddObject(frmMain.GetItemName(nVal), TObject(nVal));
        end;
        else
        begin
         SubItems.AddObject('', nil);
        end;
      end;
      nVal  := SubNode.attributes.getNamedItem(AWardCountAtbName).nodeValue;
      SubItems.AddObject(IntToStr(nVal), TObject(nVal));
      nVal  := SubNode.attributes.getNamedItem(AWardQualityAtbName).nodeValue;
      SubItems.AddObject(IntToStr(nVal), TObject(nVal));
      nVal  := SubNode.attributes.getNamedItem(AWardStrongAtbName).nodeValue;
      SubItems.AddObject(IntToStr(nVal), TObject(nVal));
      CheckBox2.Checked := SubNode.attributes.getNamedItem(AWardItemBindAtbName).nodeValue;
      nVal  := SubNode.attributes.getNamedItem(AWardItemTimeAtbName).nodeValue;
      SubItems.AddObject(BoolToStr(Boolean(nVal),True), TObject(nVal));
      nVal  := SubNode.attributes.getNamedItem(AWardHole1AtbName).nodeValue;
      SubItems.AddObject(frmMain.GetItemName(nVal), TObject(nVal));
    end;
  end;
end;

procedure TfrmViewRoleInfo.ShowRoleInfo(const Role: IXMLDOMNode);
var
  Node: IXMLDOMNode;
  D: TRoleDateTime;
  i64: Int64;
  I, nVal: Integer;
  s1: string;
  Map: TRoleEnvir;
begin
  Edit2.Text  := IntToStr(Role.attributes.getNamedItem(RoleIdAtbName).nodeValue);
  Edit1.Text  := LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(Role.attributes.getNamedItem(RoleNameAtbName).text));
  if Role.attributes.getNamedItem(RoleInheritedAtbName).nodeValue = 0 then
    Edit3.Text  := '无'
  else begin
    Node        := frmMain.GetRoleNodeById(Role.attributes.getNamedItem(RoleInheritedAtbName).nodeValue);
    if Node <> nil then
      begin
        Edit3.Font.Color  := clBlack;
        Edit3.Text  := LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(Node.attributes.getNamedItem(RoleNameAtbName).text));
      end
      else begin
        Edit3.Font.Color  := clRed;
        Edit3.Text  := '无效的父任务';
      end;
  end;
  Memo1.Text  := StringReplace(
    GetChildNodeLangText(Role as IXMLDOMElement, RoleDescSecName),
    '\', #13#10, [rfReplaceAll]);  

  i64 := Role.attributes.getNamedItem(RoleIntervalValue).nodeValue;
  D := TRoleDateTime(i64);
  if nVal = Integer(riTime) then
    Edit15.Text  := Format('%d年%d月%d日%d时%d分', [D.wYear, D.btMonth, D.btDay, D.btHour, D.btMin])
  else if nVal = Integer(riDayMax) then
    Edit15.Text  := Format('每日%d次', [D.btMin])
  else Edit15.Text := '无周期限制';
       

  if Role.attributes.getNamedItem(RoleMaxTimeAtbName).nodeValue > 1 then
    Edit5.Text  := Format('%s次', [Role.attributes.getNamedItem(RoleMaxTimeAtbName).text])
  else begin
    if Role.attributes.getNamedItem(RoleMaxTimeAtbName).nodeValue = 0 then
      Edit5.Text  := '无限次'
    else
      Edit5.Text  := '不可重复';
  end;

  nVal := Role.attributes.getNamedItem(RolePromulgationMap).nodeValue;
  s1 := GetPCNPCName(Role, RolePromulgationNPC);
  Map := frmMain.GetMap( nVal );
  if Map <> nil then
  begin      
    Edit12.Font.Color := clBlack;
    Edit12.Text := Map.MapName;
    if frmMain.GetMapNPC( nVal, s1 ) <> nil then
    begin
      if nVal = 0 then
        Edit6.Font.Color := clLime
      else Edit6.Font.Color := clBlack;
      Edit6.Text  := s1;
    end
    else begin
      Edit6.Font.Color := clRed;
      Edit6.Text  := '无效的NPC';
    end;
  end
  else begin
    Edit12.Font.Color := clRed;
    Edit12.Text := '无效的地图';
    Edit6.Font.Color := clRed;
    Edit6.Text  := '无效的NPC';
  end;

  nVal := Role.attributes.getNamedItem(RoleAcceptMap).nodeValue;
  s1 := GetAttrLangText(Role as IXMLDOMElement, RoleAcceptNPC);
  Map := frmMain.GetMap( nVal );
  if Map <> nil then
  begin
    Edit13.Font.Color := clBlack;
    Edit13.Text := Map.MapName;
    if frmMain.GetMapNPC( nVal, s1 ) <> nil then
    begin
      if nVal = 0 then
        Edit7.Font.Color := clLime
      else Edit7.Font.Color := clBlack;
      Edit7.Text  := s1;
    end
    else begin
      Edit7.Font.Color := clRed;
      Edit7.Text  := '无效的NPC';
    end;
  end
  else begin              
    Edit13.Font.Color := clRed;
    Edit13.Text := '无效的地图';
    Edit7.Font.Color := clRed;
    Edit7.Text  := '无效的NPC';
  end;

  Edit8.Text  := IntToStr(Role.attributes.getNamedItem(RoleNeedLevel).nodeValue);
  if Role.attributes.getNamedItem(ExcludeChilds).nodeValue = True then
    Label25.Caption := '是'
  else Label25.Caption := '否';

  if Role.attributes.getNamedItem(RoleAbortable).nodeValue = True then
    Label19.Caption := '是'
  else Label19.Caption := '否';




  if Role.attributes.getNamedItem(RoleAutoTransmitAttrName).nodeValue = True then
    Label31.Caption := '是'
  else Label31.Caption := '否';






  ComboBox1.ItemIndex := Role.attributes.getNamedItem(RoleKindAttrName).nodeValue;
  with Role.selectSingleNode(RoleCondition) do
  begin
//    nVal := attributes.getNamedItem(CondOfWeekAtrName).nodeValue;
//    CheckBox1.Checked := nVal and 1 <> 0;
//    for I := 1 to 7 do
//    begin
//      CheckListBox1.Checked[I-1] := nVal and (1 shl I) <> 0;
//    end;
//    nVal := attributes.getNamedItem(CondOfTime).nodeValue;
//    SpinEdit9.Value :=  LOBYTE(nVal);
//    SpinEdit10.Value := HIBYTE(nVal);
//    SpinEdit1.Value := LOBYTE(HIWORD(nVal));  
//    SpinEdit2.Value := HIBYTE(HIWORD(nVal));
  end;
  ShowRoleItems(Role);
  ShowRoleAwards(Role);
  ScrollBox1.VertScrollBar.Position := 0;
end;

procedure TfrmViewRoleInfo.ShowRoleItems(Role: IXMLDOMNode);
Resourcestring
  sQueryItemsNodeStr = RoleItemsSceName;
var
  Node, SubNode: IXMLDOMElement;
  I, nVal: Integer;
begin
//  ListView1.Clear;
//  Node  := Role.selectSingleNode(RoleItemsSceName) as IXMLDOMElement;
//  if Node = nil then
//    Exit;
//  for I := 0 to Node.childNodes.length - 1 do
//  begin
//    SubNode := Node.childNodes.item[I] as IXMLDOMElement;
//    nVal    := SubNode.getAttribute(ItemExecModeAtbName);
//    with ListView1.Items.Add do
//    begin
//      Caption := GetRoleItemModeStr(TRoleExecuteMode(nVal));
//      StateIndex :=  nVal;
//      nVal  := SubNode.getAttribute(ItemExecIdAtbName);
//      case TRoleExecuteMode(StateIndex) of
//        reGetItem,reBuyItem,reStrengthenItem,reBuyCommissionItem:  SubItems.AddObject(frmMain.GetItemName(nVal), TObject(nVal));
//        reKillMon,reTameMon:  SubItems.AddObject(frmMain.GetMonsterName(nVal), TObject(nVal));
//        reCustom:  SubItems.AddObject('(' + IntToStr(nVal) + ')' + GetAttrLangText(SubNode, ItemCustomDataAtbName), TObject(nVal));
//        reKillLevelMon: SubItems.AddObject(IntToStr(nVal), TObject(nVal));
//        else SubItems.AddObject('', nil);
//      end;
//      nVal  := SubNode.attributes.getNamedItem(ItemNeedCountAtbName).nodeValue;
//      SubItems.AddObject(IntToStr(nVal), TObject(nVal));   
//      nVal  := SubNode.attributes.getNamedItem(ItemNeedQualityAtbName).nodeValue;
//      SubItems.AddObject(IntToStr(nVal), TObject(nVal));   
//      nVal  := SubNode.attributes.getNamedItem(ItemNeedStrongLevelAtbName).nodeValue;
//      SubItems.AddObject(IntToStr(nVal), TObject(nVal));
//      nVal  := SubNode.attributes.getNamedItem(ItemJobAtbName).nodeValue;
//      SubItems.AddObject(frmMain.GetJobName(nVal), TObject(nVal));
//    end;
//  end;
end;

end.
