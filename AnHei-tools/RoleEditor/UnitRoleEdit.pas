unit UnitRoleEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, StdCtrls, ComCtrls, Clipbrd, Menus, msxml, Spin, CheckLst,
  ExtCtrls;

const
  STR_ExcRoleKindAttrName = '不排斥任务分类';
  ErrorTaget = '哥 本任务目标随机 目标配置有%d个, 请至少配置%d种奖励';
  ErrorRandom = '哥 本任务目标随机, 请至少配置2个目标';
  ErrorRandomTaget = '哥 本任务目标随机, 重复次数为%d 请至少配置%d个目标';
  ErrorNpc = '哥 接受npc 和 受理npc 必须填写';
  ErrorNpc1 = '哥 任务发布/受理 类型为[0 从NPC上接任务] 接受/受理npc 必须填写';

type
  TfrmRoleEdit = class(TForm)
    Button1: TButton;
    Button2: TButton;
    pmAward: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    pmTarget: TPopupMenu;
    E1: TMenuItem;
    D1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lvTargets: TListView;
    TabSheet2: TTabSheet;
    ListViewAwards: TListView;
    PageControl3: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBoxEX;
    Label10: TLabel;
    SpinEdit6: TSpinEdit;
    GroupBox9: TGroupBox;
    Label20: TLabel;
    SpinEdit9: TSpinEdit;
    SpinEdit10: TSpinEdit;
    Label21: TLabel;
    CheckBox1: TCheckBox;
    CheckListBox1: TCheckListBox;
    SpinEdit11: TSpinEdit;
    SpinEdit12: TSpinEdit;
    Label22: TLabel;
    TabSheet7: TTabSheet;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    Label14: TLabel;
    SpinEdit8: TSpinEdit;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    GroupBox6: TGroupBox;
    Label12: TLabel;
    Label18: TLabel;
    cbPropNpc: TComboBox;
    ComboBox6: TComboBoxEx;
    GroupBox3: TGroupBox;
    SpinEdit16: TSpinEdit;
    SpinEdit17: TSpinEdit;
    SpinEdit18: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    CheckBox2: TCheckBox;
    ComboBox8: TComboBox;
    Label5: TLabel;
    Label15: TLabel;
    ComboBox9: TComboBox;
    btnUpRole: TButton;
    btnDownRole: TButton;
    CheckBox3: TCheckBox;
    cBoxAutoWaiver: TCheckBox;
    cBoxTransmit: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox4: TGroupBox;
    MemoPromTalk: TMemo;
    GroupBox7: TGroupBox;
    MemoCompTalk: TMemo;
    TabSheet8: TTabSheet;
    GroupBox8: TGroupBox;
    MemoAcceptStory: TMemo;
    GroupBox10: TGroupBox;
    MemoFinishStory: TMemo;
    chkFindByDriver: TCheckBox;
    ts1: TTabSheet;
    lv1: TListView;
    pm1: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    grp1: TGroupBox;
    cbCompNpc: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    cb2: TComboBoxEx;
    lbl3: TLabel;
    cb3: TComboBox;
    chk1: TCheckBox;
    cb4: TComboBox;
    lbl4: TLabel;
    chk2: TCheckBox;
    chk3: TCheckBox;
    lbl5: TLabel;
    se1: TSpinEdit;
    lbl7: TLabel;
    cb5: TComboBox;
    lbl8: TLabel;
    se3: TSpinEdit;
    lbl9: TLabel;
    se4: TSpinEdit;
    ts2: TTabSheet;
    lvConds: TListView;
    pmCond: TPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    chk4: TCheckBox;
    lvAwardTags: TListView;
    pmAwardTag: TPopupMenu;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    pnl1: TPanel;
    C1: TMenuItem;
    P1: TMenuItem;
    P2: TMenuItem;
    C2: TMenuItem;
    seinterval: TSpinEdit;
    lbl10: TLabel;
    pmSurprise: TPopupMenu;
    EditSurprise: TMenuItem;
    delSurprise: TMenuItem;
    CopySurprise: TMenuItem;
    pasteSurprise: TMenuItem;
    MenuItem23: TMenuItem;
    AddSurprise: TMenuItem;
    ts3: TTabSheet;
    lvsurprise: TListView;
    grp2: TGroupBox;
    lbl6: TLabel;
    seAward: TSpinEdit;
    seEntrust: TSpinEdit;
    lbl12: TLabel;
    cbDoubleMoney: TComboBox;
    lbl13: TLabel;
    grp3: TGroupBox;
    lbl17: TLabel;
    cbAgainMoney: TComboBox;
    lbl11: TLabel;
    seStar: TSpinEdit;
    CheckBoxGiveAward: TCheckBox;
    tsMutiAward: TTabSheet;
    lvMutiAward: TListView;
    pmMutiAward: TPopupMenu;
    editMA: TMenuItem;
    DelMA: TMenuItem;
    CopyMA: TMenuItem;
    PasteMA: TMenuItem;
    MenuItem24: TMenuItem;
    AddMA: TMenuItem;
    CBComTrans: TCheckBox;
    procedure pmMutiAwardPopup(Sender: TObject);
    procedure AddMAClick(Sender: TObject);
    procedure pasteMAClick(Sender: TObject);
    procedure CopyMAClick(Sender: TObject);
    procedure delMAClick(Sender: TObject);
    procedure EditMAClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure pasteSurpriseClick(Sender: TObject);
    procedure CopySurpriseClick(Sender: TObject);
    procedure pmSurprisePopup(Sender: TObject);
    procedure AddSurpriseClick(Sender: TObject);
    procedure delSurpriseClick(Sender: TObject);
    procedure EditSurpriseClick(Sender: TObject);
    procedure edtLuckRateKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmAwardTagPopup(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure lvAwardTagsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure pmCondPopup(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pmTargetPopup(Sender: TObject);
    procedure pmAwardPopup(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbPropNpcChange(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure ComboBox6Select(Sender: TObject);
    procedure cb2Select(Sender: TObject);
    procedure ComboBox8Select(Sender: TObject);
    procedure btnUpRoleClick(Sender: TObject);
    procedure btnDownRoleClick(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
  private
    { Private declarations }
    m_Role  :IXMLDOMNode;
    m_RoleId:Integer;
    m_AwardId: Integer;
    procedure ReadRoleMutiAward;
    procedure AddMutiAwardList(MutiAwardNode: IXMLDOMNode; Badd: Boolean);
    procedure AddSurpriseList(SurpriseNode: IXMLDOMNode; Badd:Boolean = true);
    procedure ReadRoleSurprise;
    procedure SetEditCtrl(Bedit :Boolean);
    procedure AddAwardsTagList(AwardNode: IXMLDOMNode; Badd: boolean= True);
    procedure ReadRoleAwardsTag;
    procedure AddCondsList(Role: TRoleCond; Badd:Boolean = True);overload;
    procedure AddCondsList(AwardNode: IXMLDOMNode;Badd:Boolean = true);overload;
    procedure ReadRoleConds;
    procedure ReadRoleInfo();
    procedure UpDateRoleInfo();
    procedure EnumAllRoles();
    procedure ReadRoleTargets();
    function ReadRoleAwards(iTag :Integer):IXMLDOMElement;
    //Bneed 快速完成
    procedure ReadRoleNeeds;
    procedure AddAwardsList(AwardNode: IXMLDOMNode; badd:boolean=True);overload;
    procedure AddNeedsList(NeedNode: IXMLDOMNode);
    procedure AddItemsList(ItemNode: IXMLDOMNode; badd:Boolean=True);
    procedure UpDateRoleTargets(RoleElement: IXMLDOMElement);
    procedure UpDateRoleAwards();
    procedure UpDateRoleComp(RoleElement: IXMLDOMElement);
    procedure UpDateRoleProm(RoleElement: IXMLDOMElement);
    procedure UpDateRoleConds(RoleElement: IXMLDOMElement);
    procedure UpDateRoleNeeds(RoleElement: IXMLDOMElement);
    procedure UpDateRoleSurprise(RoleElement: IXMLDOMElement);
    procedure ReadRoleComp();
    procedure ReadRoleProm();
    function GetCustomRoleItemId(): Integer;
    procedure CopyNode(var CopyNode: TCloneNode; ListView: TListView);
  public
    { Public declarations }
    CurAwardTag : IXMLDOMElement;
    m_curRole: Integer;
    curListView: TListView;
    BeditAward: boolean;
    function EditRole(const ARole: IXMLDOMNode):Boolean;
  end;

implementation

uses   UnitRoleItemAndAward, UnitTaskType, UnitLangPackage;

{$R *.dfm}

{ TfrmRoleEdit }



procedure TfrmRoleEdit.AddCondsList(Role: TRoleCond; Badd:Boolean);
var
  nVal, J, iTemp: Integer;
  S,S1: string;
  TempListItem: TListItem;
begin
    if Badd then
     TempListItem := lvConds.Items.Add
    else
    begin
      TempListItem := lvConds.Selected;
      if TempListItem = nil then Exit;
    end;

    with TempListItem do
    begin
      StateIndex :=  Role.bttype;
      Caption := GetRoleCondModeStr(StateIndex);
      SubItems.Clear;
      if Role.bttype in CondItemindexSet then
       SubItems.Add(frmMain.GetItemName(Role.id))
      else
       SubItems.Add(IntToStr(Role.id));
      SubItems.Add(IntToStr(Role.count));
      SubItems.Add(IntToStr(Role.id));
    end;
end;


procedure TfrmRoleEdit.AddCondsList(AwardNode: IXMLDOMNode; Badd:Boolean);
var
  nVal, J, iTemp: Integer;
  S,S1: string;
  TempListItem: TListItem;
begin
    if Badd then
     TempListItem := lvConds.Items.Add
    else
    begin
      TempListItem := lvConds.Selected;
      if TempListItem = nil then Exit;
    end;

    with TempListItem do
    begin
      nVal    := AwardNode.attributes.getNamedItem(CondtypeAttr).nodeValue;
      StateIndex :=  nVal;
      Caption := GetRoleCondModeStr(nVal);
      SubItems.Clear;
      iTemp := AwardNode.attributes.getNamedItem(CondidAttr).nodeValue;
      if nVal in CondItemindexSet then
       SubItems.Add(frmMain.GetItemName(iTemp))
      else
       SubItems.Add(IntToStr(iTemp));
      SubItems.Add(AwardNode.attributes.getNamedItem(CondCountAttr).nodeValue);
      SubItems.Add(IntToStr(iTemp));
    end;
end;

procedure TfrmRoleEdit.AddSurpriseList(SurpriseNode: IXMLDOMNode; Badd:Boolean);
var
  nVal, J, iTemp: Integer;
  S,S1: string;
  TempListItem: TListItem;
begin
    if Badd then
     TempListItem := lvsurprise.Items.Add
    else
    begin
      TempListItem := lvsurprise.Selected;
    end;
    if TempListItem = nil then Exit;

    with TempListItem do
    begin
      nVal    := SurpriseNode.attributes.getNamedItem(surpriseawardprobAttr).nodeValue;
      StateIndex :=  nVal;
      Caption := inttostr(nVal);
      SubItems.Clear;
      SubItems.Add(SurpriseNode.attributes.getNamedItem(surpriseawardrateAttr).nodeValue);
    end;
end;


procedure TfrmRoleEdit.AddMutiAwardList(MutiAwardNode: IXMLDOMNode; Badd:Boolean);
var
  TempListItem: TListItem;
  i: Integer;
begin
    if Badd then
     TempListItem := lvMutiAward.Items.Add
    else
    begin
      TempListItem := lvMutiAward.Selected;
    end;
    if TempListItem = nil then Exit;

    with TempListItem do
    begin
      i := MutiAwardNode.attributes.getNamedItem(MAMoneyTypeAttr).nodeValue;
      Caption    := MoneyTypeStr[i];
      SubItems.Clear;
      SubItems.Add(MutiAwardNode.attributes.getNamedItem(MARateAttr).nodeValue);
      SubItems.Add(MutiAwardNode.attributes.getNamedItem(MAmoneyCountAttr).nodeValue);
    end;
end;





procedure TfrmRoleEdit.AddAwardsTagList(AwardNode: IXMLDOMNode; Badd: boolean);
var
 ListItem : TListItem;
begin
    if Badd then
     ListItem := lvAwardTags.Items.Add
    else
    begin
      ListItem := lvAwardTags.Selected;
      if ListItem = nil then Exit;
    end;

    with ListItem do
    begin
      Caption := AwardNode.attributes.getNamedItem(TagAttr).nodeValue;
    end;
end;



procedure TfrmRoleEdit.AddAwardsList(AwardNode: IXMLDOMNode; Badd:Boolean);
var
  nVal, J, itemp: Integer;
  S,S1: string;
  listitem: TListItem;
begin
  if Badd then
  begin
   listitem := ListViewAwards.Items.Add;
  end else
   listitem := ListViewAwards.Selected;
  if listitem = nil then Exit;

    with listitem do
    begin
      nVal    := AwardNode.attributes.getNamedItem(AwardModeAtbName).nodeValue;
      Caption := GetRoleAwardModeStr(nVal);
      StateIndex :=  nVal;
      SubItems.clear;

      itemp := AwardNode.attributes.getNamedItem(AWardItemIdAtbName).nodeValue;
      if nVal in AwordItemIndexSet then
       SubItems.Add(frmMain.GetItemName(itemp))
      else
       SubItems.Add(IntToStr(itemp));

      SubItems.Add(AwardNode.attributes.getNamedItem(AWardCountAtbName).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(AWardQualityAtbName).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(AWardStrongAtbName).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(groupAttr).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(AWardItemBindAtbName).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(jobAttr).nodeValue);
      SubItems.Add(AwardNode.attributes.getNamedItem(sexAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(levelRateAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(ringRateAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(vipLevelAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(bossLevelAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(importantLevelAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(initAttrsAttr).nodeValue);
//      SubItems.Add(AwardNode.attributes.getNamedItem(datastrAttr).nodeValue);
      // id 对应的字符串
//      SubItems.Add(IntToStr(itemp));
    end;
end;


procedure TfrmRoleEdit.AddNeedsList(NeedNode: IXMLDOMNode);
var
  nVal: Integer;
begin
    nVal    := NeedNode.attributes.getNamedItem(QuickModeAtbName).nodeValue;
    with lv1.Items.Add do
    begin
      Caption := GetRoleNeedModeStr(TRoleNeedsMode(nVal));
      StateIndex :=  nVal;
      nVal  := NeedNode.attributes.getNamedItem(QuickItemIdAtbName).nodeValue;
      case TRoleNeedsMode(StateIndex) of
        rnItem:
        begin
          SubItems.AddObject(frmMain.GetItemName(nVal), TObject(nVal));
        end
        else
        begin
          SubItems.AddObject('', nil);
        end;
      end;
      nVal  := NeedNode.attributes.getNamedItem(QuickCountAtbName).nodeValue;
      SubItems.AddObject(IntToStr(nVal), TObject(nVal));
    end;
end;

procedure TfrmRoleEdit.AddItemsList(ItemNode: IXMLDOMNode; badd:Boolean);
var
  nVal, idata, idm, itemp: Integer;
  listitem: TListItem;
begin
  if badd then
    listitem := lvTargets.Items.Add
  else
  begin
    listitem := lvTargets.Selected;
    if listitem = nil then Exit;
  end;
  with listitem, ItemNode.attributes do
  begin
    nVal := ItemNode.attributes.getNamedItem(ItemExecModeAtbName).nodeValue;
    Caption := GetRoleItemModeStr(nVal);
    StateIndex :=  nVal;
    SubItems.Clear;
    itemp := getNamedItem(ItemExecIdAtbName).nodeValue;
    if nVal in  TargetItemindexSet then
     SubItems.Add(frmMain.GetItemName(itemp))
    else if nVal in  TargetMonindexSet then
     SubItems.Add(frmMain.GetMonsterName(itemp))
    else if nVal in  TaegetSenceIndexSet then
     SubItems.Add(frmMain.GetMap(itemp).MapName)
    else if nVal in  TaegetNpcIndexSet then
     SubItems.Add(frmMain.GetNPCName(itemp))
    else
     SubItems.Add(IntToStr(itemp));

    SubItems.Add(getNamedItem(ItemNeedCountAtbName).nodeValue);
    TryStrToInt(getNamedItem(dataAttr).nodeValue, idata);
    SubItems.Add(LanguagePackage.GetLangText(RoleLangCategoryId, idata));
    TryStrToInt(getNamedItem(dataMonsterAttr).nodeValue, idm);
    SubItems.Add(LanguagePackage.GetLangText(RoleLangCategoryId, idm));
    SubItems.Add(getNamedItem(useListAttr).nodeValue);
    SubItems.Add(getNamedItem(rewardIdAttr).nodeValue);
    SubItems.Add(IntToStr(idata));
    SubItems.Add(IntToStr(idm));
  end;
end;

procedure TfrmRoleEdit.SetEditCtrl(Bedit :Boolean);
begin
 Button1.Enabled := Bedit;
 btnUpRole.Enabled := not Bedit;
 btnDownRole.Enabled := not Bedit;
end;

procedure TfrmRoleEdit.btn1Click(Sender: TObject);
begin
 UpDateRoleAwards();
end;

procedure TfrmRoleEdit.btnDownRoleClick(Sender: TObject);
begin
  Inc(m_curRole);
  if curListView.Items.Count < m_curRole+1 then
  begin
    m_curRole := 0;
  end;
  if curListView.Items[m_curRole].ImageIndex = 1 then
  begin
    curListView.ClearSelection;
    curListView.Selected := curListView.Items.Item[m_curRole];
    if curListView = frmMain.ListView1 then
      m_Role := frmMain.GetRoleNodeById(Integer(curListView.Items.Item[m_curRole].SubItems.Objects[1]))
    else
      m_Role := frmMain.GetRoleNodeById(Integer(curListView.Items.Item[m_curRole].Data));
    m_RoleId:= m_Role.attributes.getNamedItem(RoleIdAtbName).nodeValue;
    EnumAllRoles();
    ReadRoleInfo();
  end;
end;

procedure TfrmRoleEdit.btnUpRoleClick(Sender: TObject);
begin
  Dec(m_curRole);
  if m_curRole < 0 then
  begin
    m_curRole := curListView.Items.Count-1
  end;
  if curListView.Items[m_curRole].ImageIndex = 1 then
  begin
    curListView.ClearSelection;
    curListView.Selected := curListView.Items.Item[m_curRole];
    if curListView = frmMain.ListView1 then
      m_Role := frmMain.GetRoleNodeById(Integer(curListView.Items.Item[m_curRole].SubItems.Objects[1]))
    else
      m_Role := frmMain.GetRoleNodeById(Integer(curListView.Items.Item[m_curRole].Data));
    m_RoleId:= m_Role.attributes.getNamedItem(RoleIdAtbName).nodeValue;
    EnumAllRoles();
    ReadRoleInfo();
  end;
end;

procedure TfrmRoleEdit.C1Click(Sender: TObject);
begin
  CopyNode(m_CopyTargetNode,lvTargets);
end;

procedure TfrmRoleEdit.C2Click(Sender: TObject);
var
  I,iCount: Integer;
begin
  iCount := 0;
  m_CopyAwardNode.RoleId := m_RoleId;
  m_CopyAwardNode.AwardId := m_AwardId;
  SetLength(m_CopyAwardNode.CopyArray,ListViewAwards.SelCount);
  for I := 0 to ListViewAwards.Items.Count - 1 do
  begin
    if ListViewAwards.Items[I].Selected then
    begin
      m_CopyAwardNode.CopyArray[iCount] := I;
      Inc(iCount);
    end;
  end;
end;

procedure TfrmRoleEdit.ComboBox1Change(Sender: TObject);
begin
 if ComboBox1.ItemIndex = 0 then cbDoubleMoney.ItemIndex := 2;
 
end;

procedure TfrmRoleEdit.ComboBox2Select(Sender: TObject);
begin
  SpinEdit3.Value := 0;
  SpinEdit4.Value := 0;
  SpinEdit5.Value := 0;
end;

procedure TfrmRoleEdit.cbPropNpcChange(Sender: TObject);
begin
  SpinEdit6.MaxValue    := $FF;
  if ComboBox6.ItemIndex = 0 then
    SpinEdit6.MaxValue  := 127;
  if SpinEdit6.Value > SpinEdit6.MaxValue then
    SpinEdit6.Value := SpinEdit6.MaxValue;
 if (Sender as TComboBox).itemindex = 0 then
 begin
   Label18.Font.Color := clRed;
   Label12.Font.Color := clRed;
   lbl2.Font.Color := clRed;
   lbl1.Font.Color := clRed;
 end
 else
 begin
   Label18.Font.Color := clWindowText;
   Label12.Font.Color := clWindowText;
   lbl2.Font.Color := clWindowText;
   lbl1.Font.Color := clWindowText;
 end;
 

end;

procedure TfrmRoleEdit.ComboBox6Select(Sender: TObject);
var
  Idx: Integer;
begin
  cbPropNpc.Items.Clear;
  cbPropNpc.Items.AddStrings( TRoleEnvir(ComboBox6.Items.Objects[ComboBox6.ItemIndex]).NPCList );
  Idx := cbPropNpc.Items.IndexOf(cbPropNpc.Text);
  cbPropNpc.Text := '';
  cbPropNpc.ItemIndex := Idx;
end;

procedure TfrmRoleEdit.cb2Select(Sender: TObject);
var
  Idx: Integer;
begin
  cbCompNpc.Items.Clear;
  cbCompNpc.Items.AddStrings( TRoleEnvir(cb2.Items.Objects[cb2.ItemIndex]).NPCList );
  Idx  := cbCompNpc.Items.IndexOf(cbCompNpc.Text);
  cbCompNpc.Text := '';
  cbCompNpc.ItemIndex := Idx;
end;

procedure TfrmRoleEdit.ComboBox8Select(Sender: TObject);
begin             
  SpinEdit16.Value := 0;
  SpinEdit17.Value := 0;
  SpinEdit18.Value := 0;
  if ComboBox8.ItemIndex in [2,3] then
  begin
    SpinEdit16.Visible := False;
    SpinEdit17.Visible := False; 
    SpinEdit18.Visible := True;
    Label27.Visible := False;
    Label28.Visible := False;
    Label29.Visible := True;
    Label29.Caption := '次';
  end
  else if ComboBox8.ItemIndex = 1 then
  begin
    SpinEdit16.Visible := True;
    SpinEdit17.Visible := True;
    SpinEdit18.Visible := True;
    Label27.Visible := True;
    Label28.Visible := True;
    Label29.Visible := True;
    Label29.Caption := '分';
  end
  else begin  
    SpinEdit16.Visible := False;
    SpinEdit17.Visible := False;   
    SpinEdit18.Visible := False;
    Label27.Visible := False;
    Label28.Visible := False;   
    Label29.Visible := False;
  end;
end;

procedure TfrmRoleEdit.CopyNode(var CopyNode: TCloneNode; ListView: TListView);
var
  I,iCount: Integer;
begin
  iCount := 0;
  CopyNode.RoleId := m_RoleId;
  SetLength(CopyNode.CopyArray,ListView.SelCount);
  for I := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[I].Selected then
    begin
      CopyNode.CopyArray[iCount] := I;
      Inc(iCount);
    end;
  end;
end;

procedure TfrmRoleEdit.CopySurpriseClick(Sender: TObject);
begin
  CopyNode(m_CopySurpriseNode,lvsurprise);
end;

procedure TfrmRoleEdit.D1Click(Sender: TObject);
var
  Node   : IXMLDOMNode;
  i : integer;
begin
  Node := m_Role.selectSingleNode(RoleItemsSceName);
  for I := lvTargets.Items.Count - 1 downto 0 do
  if lvTargets.Items[I].Selected then
  begin
      Node.removeChild(Node.childNodes[lvTargets.Selected.index]);
      lvTargets.Items[I].Delete;
  end;
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.E1Click(Sender: TObject);
var
  TargetElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  if lvTargets.Selected = nil then  Exit;
  Node := m_Role.selectSingleNode(RoleItemsSceName);
  TargetElement := Node.childNodes[lvTargets.Selected.index] as IXMLDOMElement;
  if TargetElement =  nil then  Exit;
  if not EditRoleTarget(TargetElement, lvTargets.Selected.index) then    Exit;
  AddItemsList(TargetElement, False);
   SetEditCtrl(True);
end;

function TfrmRoleEdit.EditRole(const ARole: IXMLDOMNode):Boolean;
begin
  Result  := False;
  m_Role  := ARole;
  m_RoleId:= ARole.attributes.getNamedItem(RoleIdAtbName).nodeValue;
  EnumAllRoles();
  ReadRoleInfo();
  if ShowModal = mrOK then
  begin
    UpDateRoleInfo();
    Result := True;
  end;
end;

procedure TfrmRoleEdit.edtLuckRateKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9','.', #8, #13]) then
  begin
    Key := #0;
    ShowMessage('只能输入数字');
  end;
end;

procedure TfrmRoleEdit.EnumAllRoles;
var
  I, nId,Idx: Integer;
  S: string;
  NodeList: IXMLDOMNodeList;
begin
  NodeList := frmMain.m_MainNode.selectNodes('*//' + RoleSecName);
  if NodeList = nil then
    Exit;
  ComboBox1.Clear;
  ComboBox1.Items.AddObject('无', nil);
  for I := 0 to NodeList.length - 1 do
  begin
    nId := NodeList.item[I].attributes.getNamedItem(RoleIdAtbName).nodeValue;
    if nId = m_RoleId then
      continue;
//    if (NodeList.item[I].attributes.getNamedItem(RoleMaxTimeAtbName).nodeValue <> 1)
//    and (CompareText(GetPCNPCName(NodeList.item[I], RolePromulgationNPC), ROLE_AUTO_PROMULGATE) = 0)
//    then
//      continue;
    S := LanguagePackage.GetLangText(RoleLangCategoryId,StrToInt(NodeList.item[I].attributes.getNamedItem(RoleNameAtbName).text));
    Idx := NodeList.item[I].attributes.getNamedItem(RoleIdAtbName).nodeValue;
    ComboBox1.Items.AddObject(S,TObject(nId));

  end;
end;

procedure TfrmRoleEdit.FormClose(Sender: TObject; var Action: TCloseAction);
var
 iTarget, iAword, irepeat: integer;
begin
 iTarget := lvTargets.Items.Count;
 iAword  := lvAwardTags.Items.Count;
 irepeat := SpinEdit6.value;



 if ((cb3.ItemIndex=0) and (cbPropNpc.ItemIndex < 0))
  or((cb4.ItemIndex=0) and (cbCompNpc.ItemIndex < 0))
  then
 begin
    MessageDlg(ErrorNpc1, mtError, [mbOK], 0);
    Action := caNone;
 end;

 if chk4.Checked  then
 begin
    //随即任务的目标至少要有两个
    if iTarget < 2 then
    begin
     MessageDlg(ErrorRandom, mtError, [mbOK], 0);
     Action := caNone;
    end
    //当创建目标的时候，不勾选“随机目标”不需要判断提示，当勾选随机目标时：奖励数要大于或等于目标数
    else if iAword < iTarget then
    begin
     MessageDlg(Format(ErrorTaget, [iTarget, iTarget]), mtError, [mbOK], 0);
     Action := caNone;
    end;
 end;

 //当任务类型是 12-天书任务/降魔刷新任务时不需要检测
 //任务id 8107 任务名 任务编辑器提示更改
// if ComboBox9.ItemIndex <> 12 then
//   if (irepeat <> 0) and (chk4.Checked) and (iTarget <= irepeat) then
//   begin
//      MessageDlg(format(ErrorRandomTaget, [irepeat, irepeat+1]), mtError, [mbOK], 0);
//      Action := caNone;
//   end;
end;

procedure TfrmRoleEdit.FormCreate(Sender: TObject);
var
 s: string;
begin
  ComboBox6.Items.AddStrings(frmMain.m_MapList);
  cb2.Items.AddStrings(frmMain.m_MapList);
  cb5.ItemIndex := 0;

  for s in MoneyTypeStr do
  begin
   cbDoubleMoney.Items.add(s);
   cbAgainMoney.Items.add(s);
  end;

  ComboBox9.Items.Clear;
  for s in RoleTypeStr do
  begin
   ComboBox9.Items.add(s);
  end;




  PageControl1.ActivePageIndex := 0;
  PageControl3.ActivePageIndex := 0;
  m_curRole := -1;
end;

procedure TfrmRoleEdit.FormShow(Sender: TObject);
begin
  btnUpRole.Enabled := m_curRole <> -1;
  btnDownRole.Enabled := m_curRole <> -1;
  Label18.Font.Color := clRed;
end;

function TfrmRoleEdit.GetCustomRoleItemId: Integer;
var
  I, J: Integer;
  boExists : Boolean;
begin
  //任务系统的存储中使用$8000位做时间标识，此值必须小于$8000
  for I := 30001 to $7FFF  do
  begin
    boExists := False;
    for J := 0 to lvTargets.Items.Count - 1 do
    begin
      if Integer(lvTargets.Items[J].SubItems.Objects[0]) = I then
      begin             
        boExists:= True;
        break;
      end;
    end;
    if not boExists then
    begin
      Result := I;
      exit;
    end;
  end;
  Raise Exception.Create('已无可用的自定义任务条件ID');
end;

procedure TfrmRoleEdit.Memo1DblClick(Sender: TObject);
resourcestring
  sAddCompRoleNPC = '完成后回复<%s(%s)/M%s:%d:%d:%s>';
  sAddItemDistribute = '从<%s(%s)/M%s:%d:%d:%s>处收集%s个<(c0xFF00FF00)%s>';
  sAddMonDistribute = '击杀%s个<%s(%s)/M%s:%d:%d:%s>';
var
  I: Integer;
  btExecMode: TRoleExecuteMode;
  RoleMap: TRoleEnvir;
  NPC: TEnvirNPC;
  Mon: TEnvirMonster;
begin
  Memo1.Lines.Add('---------------------------------------');
  for I := 0 to lvTargets.Items.Count - 1 do
  begin
    btExecMode := TRoleExecuteMode(lvTargets.Items[I].StateIndex);
    case btExecMode of
      reGetItem:begin  
        if frmMain.GetRoleNeedDetail(btExecMode, Integer(lvTargets.Items[I].SubItems.Objects[0]), RoleMap, Mon) then
        begin
          Memo1.Lines.Add(Format(sAddItemDistribute,
            [FilterMonName(Mon.Name), RoleMap.MapName,
            RoleMap.MapName, Mon.Position.X, Mon.Position.Y, FilterMonName(Mon.Name),
            lvTargets.Items[I].SubItems[1],
            lvTargets.Items[I].SubItems[0]]));
        end;
      end;
      reKillMon,reTameMon:begin
        if frmMain.GetRoleNeedDetail(btExecMode, Integer(lvTargets.Items[I].SubItems.Objects[0]), RoleMap, Mon) then
        begin
          Memo1.Lines.Add(Format(sAddMonDistribute, [
            lvTargets.Items[I].SubItems[1],
            FilterMonName(lvTargets.Items[I].SubItems[0]),
            RoleMap.MapName, RoleMap.MapName, Mon.Position.X, Mon.Position.Y,
            lvTargets.Items[I].SubItems[0]]));
        end;
      end;
    end;
  end;
  if cbCompNpc.ItemIndex <> -1 then
  begin
    NPC := frmMain.GetMapNPC( cb2.Text, cbCompNpc.Text );
    Memo1.Lines.Add(Format(sAddCompRoleNPC, [cbCompNpc.Text, cb2.Text,
      cb2.Text, NPC.Position.X, NPC.Position.Y, cbCompNpc.Text]));
  end;
end;

procedure TfrmRoleEdit.MenuItem10Click(Sender: TObject);
var
  RoleNeed: TRoleNeed;
begin
  FillChar(RoleNeed, sizeof(RoleNeed), 0);
  if not EditRoleNeed(RoleNeed) then
    Exit;
  with lv1.Items.Add do
  begin
    Caption := GetRoleNeedModeStr(RoleNeed.Mode);
    StateIndex  := Integer(RoleNeed.Mode);
    SubItems.Clear;
    case RoleNeed.Mode of
      rnItem:
      begin
        SubItems.AddObject(frmMain.GetItemName(RoleNeed.ItemId), TObject(RoleNeed.ItemId));
      end
      else
      begin
        SubItems.AddObject('', nil);
      end;
    end;
    SubItems.AddObject(IntToStr(RoleNeed.count), TObject(RoleNeed.count));
  end;
end;


procedure TfrmRoleEdit.MenuItem11Click(Sender: TObject);
begin
  CopyNode(m_CopyCondNode,lvConds);
end;

procedure TfrmRoleEdit.MenuItem12Click(Sender: TObject);
var
  I,Idx: Integer;
  Node,NewNode,CondNode: IXMLDOMNode;
  NodeList: IXMLDOMNodeList;
begin
  if m_CopyCondNode.RoleId > 0 then
  begin
    Node := frmMain.GetRoleNodeById(m_CopyCondNode.RoleId);
    CondNode := m_Role.selectSingleNode(RoleConditionS);
    if (Node <> nil) and (CondNode <> nil) then
    begin
      NodeList := Node.selectNodes(RoleConditionS+'/'+RoleCondition);
      for I := 0 to High(m_CopyCondNode.CopyArray) do
      begin
        Idx := m_CopyCondNode.CopyArray[I];
        if Idx < NodeList.length then
        begin
          NewNode := NodeList[Idx].cloneNode(True);
          CondNode.appendChild(NewNode);
        end;
      end;
      ReadRoleConds();
    end;
    m_CopyCondNode.RoleId := 0;
  end;
end;

procedure TfrmRoleEdit.MenuItem14Click(Sender: TObject);
var
  RoleCond: TRoleCond;
  S: string;
  I: Integer;
begin
  FillChar(RoleCond, sizeof(RoleCond), 0);
  RoleCond.Count := 1;

  if not EditRoleCond(RoleCond) then
    Exit;
 AddCondsList(RoleCond,True);
 SetEditCtrl(True);
end;


procedure TfrmRoleEdit.MenuItem15Click(Sender: TObject);
var
 Tagname :string;
 Node : IXMLDOMNode;
begin
  if lvAwardTags.Selected = nil then Exit;
  Tagname := Trim(InputBox('修改目标奖励分类','请输入名称',lvAwardTags.Selected.Caption));
  if Tagname = '' then Exit;
  if CurAwardTag = nil then Exit;
  CurAwardTag.setAttribute(TagAttr, Tagname);
  AddAwardsTagList(CurAwardTag, False);
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.MenuItem16Click(Sender: TObject);
begin
 if lvAwardTags.Selected= nil then Exit;
 
 if CurAwardTag <> nil then
 begin
   lvAwardTags.Items[lvAwardTags.Selected.Index].Delete;
   CurAwardTag.parentNode.removeChild(CurAwardTag);
   ListViewAwards.Clear;
   CurAwardTag :=  nil;
 end;
  SetEditCtrl(True);
end;

procedure TfrmRoleEdit.EditMAClick(Sender: TObject);
var
  MutiAwardElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  if lvMutiAward.Selected = nil then Exit;
  Node := m_Role.selectSingleNode(MultiAwardTable);
  MutiAwardElement := Node.childNodes[lvMutiAward.Selected.index] as IXMLDOMElement;
  if MutiAwardElement =  nil then  Exit;
  if not EditMutiAward(MutiAwardElement) then Exit;
  AddMutiAwardList(MutiAwardElement, False);
  SetEditCtrl(True);
end;

procedure TfrmRoleEdit.delMAClick(Sender: TObject);
var
  Node   : IXMLDOMNode;
  i : integer;
begin
  Node := m_Role.selectSingleNode(MultiAwardTable);
  for I := lvMutiAward.Items.Count - 1 downto 0 do
  if lvMutiAward.Items[I].Selected then
  begin
      Node.removeChild(Node.childNodes[lvMutiAward.Selected.index]);
      lvMutiAward.Items[I].Delete;
  end;
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.EditSurpriseClick(Sender: TObject);
var
  SurpriseElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  if lvsurprise.Selected = nil then Exit;
  Node := m_Role.selectSingleNode(surpriseAwardTable);
  SurpriseElement := Node.childNodes[lvsurprise.Selected.index] as IXMLDOMElement;
  if SurpriseElement =  nil then  Exit;
  if not EditRoleSurprise(SurpriseElement) then Exit;
  AddSurpriseList(SurpriseElement, False);
  SetEditCtrl(True);
end;


procedure TfrmRoleEdit.delSurpriseClick(Sender: TObject);
var
  Node   : IXMLDOMNode;
  i : integer;
begin
  Node := m_Role.selectSingleNode(surpriseAwardTable);
  for I := lvsurprise.Items.Count - 1 downto 0 do
  if lvsurprise.Items[I].Selected then
  begin
      Node.removeChild(Node.childNodes[lvsurprise.Selected.index]);
      lvsurprise.Items[I].Delete;
  end;
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.MenuItem1Click(Sender: TObject);
var
  AwardElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  if ListViewAwards.Selected = nil then Exit;
  AwardElement := CurAwardTag.childNodes[ListViewAwards.Selected.index] as IXMLDOMElement;
  if AwardElement =  nil then  Exit;

  if not EditRoleAward(AwardElement) then Exit;
  AddAwardsList(AwardElement, False);
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.MenuItem20Click(Sender: TObject);
var
 Tagname :string;
 itag : Integer;
 Node : IXMLDOMNode;
begin
  itag :=  lvAwardTags.Items.Count + 1;
  if itag <=  lvTargets.Items.Count then
   Tagname :=lvTargets.Items[itag -1].SubItems[0];



  Tagname := Trim(InputBox('新增目标奖励分类','请输入名称',Tagname));
  if Tagname = '' then Exit;

  Node := m_Role.selectSingleNode(RoleAwardsSecName);
  if node = nil then Exit;
  CurAwardTag  := frmMain.m_Xml.createElement(AwardTagAttr);
  CurAwardTag.setAttribute(TagAttr, Tagname);
  Node.appendChild(CurAwardTag);
  AddAwardsTagList(CurAwardTag, True);
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.CopyMAClick(Sender: TObject);
begin
  CopyNode(m_CopyMutiAwardNode,lvMutiAward);
end;

procedure TfrmRoleEdit.pasteMAClick(Sender: TObject);
var
  I,Idx: Integer;
  Node,NewNode,TableNode: IXMLDOMNode;
  NodeList: IXMLDOMNodeList;
begin
  if m_CopyMutiAwardNode.RoleId > 0 then
  begin
    Node := frmMain.GetRoleNodeById(m_CopyMutiAwardNode.RoleId);
    TableNode := m_Role.selectSingleNode(MultiAwardTable);
    if (Node <> nil) and (TableNode <> nil) then
    begin
      NodeList := Node.selectNodes(MultiAwardTable+'/'+MultiAwardsTable);
      for I := 0 to High(m_CopyMutiAwardNode.CopyArray) do
      begin
        Idx := m_CopyMutiAwardNode.CopyArray[I];
        if Idx < NodeList.length then
        begin
          NewNode := NodeList[Idx].cloneNode(True);
          TableNode.appendChild(NewNode);
        end;
      end;
      ReadRoleMutiAward();
    end;
    m_CopyMutiAwardNode.RoleId := 0;
  end;
end;

procedure TfrmRoleEdit.AddMAClick(Sender: TObject);
var
  TargetElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  Node := m_Role.selectSingleNode(MultiAwardTable);
  if Node = nil  then exit;
  TargetElement  := frmMain.m_Xml.createElement(MultiAwardSTable);
  if not EditMutiAward(TargetElement) then  Exit;
  AddMutiAwardList(TargetElement, True);
  Node.appendChild(TargetElement);
  SetEditCtrl(True);
end;

procedure TfrmRoleEdit.AddSurpriseClick(Sender: TObject);
var
  SurpriseElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
begin
  Node := m_Role.selectSingleNode(surpriseAwardTable);
  if Node = nil  then exit;
  SurpriseElement  := frmMain.m_Xml.createElement(surpriseAwardSTable);
  if not EditRoleSurprise(SurpriseElement) then  Exit;
  AddSurpriseList(SurpriseElement, True);
  Node.appendChild(SurpriseElement);
  SetEditCtrl(True);
end;
procedure TfrmRoleEdit.MenuItem2Click(Sender: TObject);
var
  I: Integer;
begin
  if CurAwardTag = nil then Exit;
  
  for I := ListViewAwards.Items.Count - 1 downto 0 do
  begin
    if ListViewAwards.Items[I].Selected then
    begin
     CurAwardTag.removeChild(CurAwardTag.childNodes[ListViewAwards.Selected.index]);
     ListViewAwards.Items[I].Delete;
    end;
  end;
   SetEditCtrl(True);
end;




procedure TfrmRoleEdit.MenuItem4Click(Sender: TObject);
var
  AwardElement: IXMLDOMElement;
begin
  if CurAwardTag = nil then Exit;

  AwardElement  := frmMain.m_Xml.createElement(RoleAwardSecName);
  if not EditRoleAward(AwardElement) then Exit;
  
  AddAwardsList(AwardElement, True);
  CurAwardTag.appendChild(AwardElement);
  SetEditCtrl(True);
end;

procedure TfrmRoleEdit.MenuItem5Click(Sender: TObject);
var
  RoleNeed: TRoleNeed;
begin
  if lv1.Selected = nil then Exit;
  RoleNeed.Mode  := TRoleNeedsMode(lv1.Selected.StateIndex);
  RoleNeed.ItemId := Integer(lv1.Selected.SubItems.Objects[0]);
  RoleNeed.Count  := TRoleAwardCount(lv1.Selected.SubItems.Objects[1]);

  if not EditRoleNeed(RoleNeed) then
    Exit;
  with lv1.Selected do
    begin
      Caption := GetRoleNeedModeStr(RoleNeed.mode);
      StateIndex  := Integer(RoleNeed.mode);
      SubItems.Clear;
      case RoleNeed.mode of
        rnItem:
        begin
        SubItems.AddObject(frmMain.GetItemName(RoleNeed.ItemId), TObject(RoleNeed.ItemId));
        end
        else
        begin
          SubItems.AddObject('', nil);
        end;
      end;
    SubItems.AddObject(IntToStr(RoleNeed.count), TObject(RoleNeed.count));
    end;
end;


procedure TfrmRoleEdit.MenuItem6Click(Sender: TObject);
var
  I: Integer;
begin
  for I := lv1.Items.Count - 1 downto 0 do
    if lv1.Items[I].Selected then
       lv1.Items[I].Delete;
end;

procedure TfrmRoleEdit.MenuItem7Click(Sender: TObject);
var
  RoleCond: TRoleCond;
  S: string;
  I: Integer;
begin
  if lvConds.Selected = nil then
    Exit;

  with lvConds.Selected, RoleCond do
  begin
     btType         := StateIndex;
     id             := StrToInt(SubItems[2]);
     Count          := StrToInt(SubItems[1]);
  end;
  if not EditRoleCond(RoleCond) then
    Exit;
 AddCondsList(RoleCond,False);
  SetEditCtrl(True);
end;


procedure TfrmRoleEdit.MenuItem8Click(Sender: TObject);
var
 i :integer;
begin
  for I := lvConds.Items.Count - 1 downto 0 do
    if lvConds.Items[I].Selected then
      lvConds.Items[I].Delete;

  SetEditCtrl(True);

end;

procedure TfrmRoleEdit.N2Click(Sender: TObject);
var
  TargetElement: IXMLDOMElement;
  Node   : IXMLDOMNode;
  idata, idm :integer;
begin
  Node := m_Role.selectSingleNode(RoleItemsSceName);
  if Node = nil  then exit;
  TargetElement  := frmMain.m_Xml.createElement(RoleItemSecName);
  TargetElement.appendChild(frmMain.m_Xml.createElement(locationesAttr));
  if not EditRoleTarget(TargetElement, Node.childNodes.length) then  Exit;
  AddItemsList(TargetElement, True);
  Node.appendChild(TargetElement);
   SetEditCtrl(True);
end;

procedure TfrmRoleEdit.P1Click(Sender: TObject);
var
  I,J,Idx: Integer;
  Node,NewNode,CondNode: IXMLDOMNode;
  NodeList,ChildList: IXMLDOMNodeList;
begin
  if m_CopyTargetNode.RoleId > 0 then
  begin
    Node := frmMain.GetRoleNodeById(m_CopyTargetNode.RoleId);
    CondNode := m_Role.selectSingleNode(RoleItemsSceName);
    if (Node <> nil) and (CondNode <> nil) then
    begin
      NodeList := Node.selectNodes(RoleItemsSceName+'/'+RoleItemSecName);
      for I := 0 to High(m_CopyTargetNode.CopyArray) do
      begin
        Idx := m_CopyTargetNode.CopyArray[I];
        if Idx < NodeList.length then
        begin
          NewNode := NodeList[Idx].cloneNode(True);
          CopyNodeText(NewNode as IXMLDOMElement,dataAttr);
          CopyNodeText(NewNode as IXMLDOMElement,dataMonsterAttr);
          ChildList := NewNode.selectNodes(locationesAttr+'/'+PassesAttr+'/'+PassAttr);
          for J := 0 to ChildList.length - 1 do
          begin
            CopyNodeText(ChildList[J] as IXMLDOMElement,actionDescAttr);
          end;
          CondNode.appendChild(NewNode);
        end;
      end;
      ReadRoleTargets();
    end;
    m_CopyTargetNode.RoleId := 0;
  end;
end;

procedure TfrmRoleEdit.P2Click(Sender: TObject);
var
  I,J,Idx: Integer;
  Node,NewNode: IXMLDOMNode;
  NodeList,ChildList: IXMLDOMNodeList;
begin
  if CurAwardTag = nil then Exit;
  if m_CopyAwardNode.RoleId > 0 then
  begin
    Node := frmMain.GetRoleNodeById(m_CopyAwardNode.RoleId);
    if Node = nil then Exit;
    NodeList := Node.selectNodes(RoleAwardsSecName+'/'+AwardTagAttr);
    if m_CopyAwardNode.AwardId < NodeList.length then
    begin
      ChildList := NodeList[m_CopyAwardNode.AwardId].selectNodes(RoleAwardSecName);
    end;
    if ChildList = nil then Exit;
    for I := 0 to High(m_CopyAwardNode.CopyArray) do
    begin
      Idx := m_CopyAwardNode.CopyArray[I];
      if Idx < ChildList.length then
      begin
        NewNode := ChildList[Idx].cloneNode(True);
        CopyNodeText(ChildList[J] as IXMLDOMElement,datastrAttr);
        CurAwardTag.appendChild(NewNode);
      end;
    end;
    ReadRoleAwards(m_AwardId);
    m_CopyAwardNode.RoleId := 0;
  end;
end;

procedure TfrmRoleEdit.pmAwardTagPopup(Sender: TObject);
begin
  MenuItem16.Enabled := (lvAwardTags.Selected <>nil);
  MenuItem15.Enabled := (lvAwardTags.Selected <>nil);
end;

procedure TfrmRoleEdit.pmCondPopup(Sender: TObject);
begin
  MenuItem7.Enabled := lvConds.Selected <> nil;
  MenuItem8.Enabled := lvConds.SelCount > 0;
  MenuItem11.Enabled := lvConds.SelCount > 0;
  MenuItem12.Enabled := m_CopyCondNode.RoleId > 0;
end;

procedure TfrmRoleEdit.pmMutiAwardPopup(Sender: TObject);
begin
  EditMA.Enabled  := lvMutiAward.Selected <> nil;
  DelMA.Enabled  := lvMutiAward.SelCount > 0;
  copyMA.Enabled  := lvMutiAward.SelCount > 0;
  pasteMA.Enabled  := m_CopyMutiAwardNode.RoleId > 0;
end;

procedure TfrmRoleEdit.pmSurprisePopup(Sender: TObject);
begin
  EditSurprise.Enabled  := lvsurprise.Selected <> nil;
  DelSurprise.Enabled  := lvsurprise.SelCount > 0;
  copysurprise.Enabled  := lvsurprise.SelCount > 0;
  pastesurprise.Enabled  := m_CopySurpriseNode.RoleId > 0;
end;

procedure TfrmRoleEdit.pmTargetPopup(Sender: TObject);
begin
  E1.Enabled  := lvTargets.Selected <> nil;
  D1.Enabled  := lvTargets.SelCount > 0;
  C1.Enabled  := lvTargets.SelCount > 0;
  P1.Enabled  := m_CopyTargetNode.RoleId > 0;
end;

procedure TfrmRoleEdit.pasteSurpriseClick(Sender: TObject);
var
  I,Idx: Integer;
  Node,NewNode,surpriseNode: IXMLDOMNode;
  NodeList: IXMLDOMNodeList;
begin
  if m_CopySurpriseNode.RoleId > 0 then
  begin
    Node := frmMain.GetRoleNodeById(m_CopySurpriseNode.RoleId);
    surpriseNode := m_Role.selectSingleNode(surpriseAwardTable);
    if (Node <> nil) and (surpriseNode <> nil) then
    begin
      NodeList := Node.selectNodes(surpriseAwardTable+'/'+surpriseAwardSTable);
      for I := 0 to High(m_CopySurpriseNode.CopyArray) do
      begin
        Idx := m_CopySurpriseNode.CopyArray[I];
        if Idx < NodeList.length then
        begin
          NewNode := NodeList[Idx].cloneNode(True);
          surpriseNode.appendChild(NewNode);
        end;
      end;
      ReadRoleSurprise();
    end;
    m_CopySurpriseNode.RoleId := 0;
  end;
end;


procedure TfrmRoleEdit.pmAwardPopup(Sender: TObject);
begin
  MenuItem4.Enabled := (lvAwardTags.Selected <>nil) ;
  MenuItem2.Enabled := (lvAwardTags.Selected <>nil) and (ListViewAwards.Selected<>nil);
  MenuItem1.Enabled := (lvAwardTags.Selected <>nil) and (ListViewAwards.Selected<>nil);
  C2.Enabled := ListViewAwards.SelCount > 0;
  P2.Enabled := m_CopyAwardNode.RoleId > 0;
end;

function TfrmRoleEdit.ReadRoleAwards(iTag :Integer):IXMLDOMElement;
Resourcestring
  sQueryAwardsNodeStr= RoleAwardsSecName;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(RoleAwardsSecName);
  if Node = nil then Exit;

  if Node.childNodes.length - 1 < iTag then
    Exit
  else
  begin
    Node := Node.childNodes[itag] ;
    Result := Node as IXMLDOMElement;
  end;

  ListViewAwards.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddAwardsList(Node.childNodes.item[I]);
  end;
end;

procedure TfrmRoleEdit.ReadRoleAwardsTag;
Resourcestring
  sQueryAwardsTagNodeStr= RoleAwardsSecName;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(sQueryAwardsTagNodeStr);
  if Node = nil then Exit;
  lvAwardTags.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddAwardsTagList(Node.childNodes.item[I]);
  end;
  lvAwardTags.ClearSelection;
  CurAwardTag := nil;
end;



procedure TfrmRoleEdit.ReadRoleConds;
Resourcestring
  sQueryAwardsNodeStr= RoleConditionS;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(RoleConditionS);
  if Node = nil then
    Exit;
  lvConds.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddCondsList(Node.childNodes.item[I]);
  end;
end;

procedure TfrmRoleEdit.ReadRoleSurprise;
Resourcestring
  sQuerySurprise= surpriseAwardTable;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(surpriseAwardTable);
  if Node = nil then Exit;
  lvsurprise.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddSurpriseList(Node.childNodes.item[I]);
  end;
end;

procedure TfrmRoleEdit.ReadRoleMutiAward;
Resourcestring
  sQuerySurprise= surpriseAwardTable;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(MultiAwardTable);
  if Node = nil then Exit;
  lvMutiAward.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddMutiAwardList(Node.childNodes.item[I], True);
  end;
end;



procedure TfrmRoleEdit.ReadRoleNeeds;
Resourcestring
  sQuickCompNeedsStr= QuickCompNeedsSecName;
var
  Node: IXMLDOMNode;
  I: Integer;
begin
  Node  := m_Role.selectSingleNode(QuickCompNeedsSecName);
  if Node = nil then  Exit;
  lv1.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddNeedsList(Node.childNodes.item[I]);
  end;
end;

procedure TfrmRoleEdit.ReadRoleInfo;
var
  InheritedId, I: Integer;
  D: TRoleDateTime;
begin
  Edit1.Text  := IntToStr(m_Role.attributes.getNamedItem(RoleIdAtbName).nodeValue);
  Edit2.Text  := LanguagePackage.GetLangText(RoleLangCategoryId,StrToInt(m_Role.attributes.getNamedItem(RoleNameAtbName).text));
  InheritedId := m_Role.attributes.getNamedItem(RoleInheritedAtbName).nodeValue;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOfObject(TObject(InheritedId));
  //任务类型
  ComboBox9.ItemIndex := m_Role.attributes.getNamedItem(RoleKindAttrName).nodeValue;
  SpinEdit8.Value   := m_Role.attributes.getNamedItem(RoleNeedLevel).nodeValue;

//  chkYB.Checked := m_Role.attributes.getNamedItem(doubleYBAttr).nodeValue;
  i := m_Role.attributes.getNamedItem(DoubleMoneyTypeAttr).nodeValue;
  if (i > high(MoneyTypeStr)) or (i < low(MoneyTypeStr)) then i := high(MoneyTypeStr);
  cbDoubleMoney.ItemIndex := i;

  i := m_Role.attributes.getNamedItem(AgainMoneyTypeAttr).nodeValue;
  if (i > high(MoneyTypeStr)) or (i < low(MoneyTypeStr)) then i := high(MoneyTypeStr);
  cbAgainMoney.ItemIndex := i;


  seEntrust.Value   := m_Role.attributes.getNamedItem(entrustAttr).nodeValue;
  seAward.Value   := m_Role.attributes.getNamedItem(multiAwardAttr).nodeValue;

  se4.Value   := m_Role.attributes.getNamedItem(maxcirAttr).nodeValue;
  se1.Value   := m_Role.attributes.getNamedItem(circleAttr).nodeValue;
  cb5.ItemIndex   := m_Role.attributes.getNamedItem(guideIdAttr).nodeValue;
  se3.Value   := m_Role.attributes.getNamedItem(speedYbAttr).nodeValue;
  CheckBox2.Checked := m_Role.attributes.getNamedItem(ExcludeChilds).nodeValue;
  CheckBox3.Checked := m_Role.attributes.getNamedItem(RoleAbortable).nodeValue;
  SpinEdit6.Value := m_Role.attributes.getNamedItem(RoleMaxTimeAtbName).nodeValue;
  seinterval.Value := m_Role.attributes.getNamedItem(RoleIntervalValue).nodeValue;
  seStar.value := m_Role.attributes.getNamedItem(starAttr).nodeValue;


   // 布尔属性
  cBoxTransmit.Checked := m_Role.attributes.getNamedItem(RoleAutoTransmitAttrName).nodeValue;
  CBComTrans.Checked := m_Role.attributes.getNamedItem(RoleAutoCompleteAttrName).nodeValue;

  chkFindByDriver.Checked := m_Role.attributes.getNamedItem(RoleWayfindingByDriver).nodeValue;
  chk3.Checked := m_Role.attributes.getNamedItem(automountAttr).nodeValue;
  chk4.Checked := m_Role.attributes.getNamedItem(randomTargetAttr).nodeValue;
  CheckBoxGiveAward.Checked := m_Role.attributes.getNamedItem(notGiveAwardAttr).nodeValue;
  // 大文本属性
  Memo1.Text  := StringReplace(
    getAttrLangText(m_Role as IXMLDOMElement, RoleDescSecName),
    '\', #13#10, [rfReplaceAll]);
  MemoPromTalk.Text  := StringReplace(
    getAttrLangText(m_Role as IXMLDOMElement, RolePromTalkSecName),
    '\', #13#10, [rfReplaceAll]);
  MemoCompTalk.Text  := StringReplace(
    getAttrLangText(m_Role as IXMLDOMElement, RoleCompTalkSecName),
    '\', #13#10, [rfReplaceAll]);
  MemoAcceptStory.Text  := StringReplace(
    getAttrLangText(m_Role as IXMLDOMElement, RoleAcceptStorySecName),
    '\', #13#10, [rfReplaceAll]);
  MemoFinishStory.Text  := StringReplace(
    getAttrLangText(m_Role as IXMLDOMElement, RoleFinishStorySecName),
    '\', #13#10, [rfReplaceAll]);

  ReadRoleTargets();
  ReadRoleComp();
  ReadRoleProm();
  ReadRoleAwardsTag();
  ReadRoleConds();
  ReadRoleSurprise();
  ReadRoleMutiAward();
//  ComboBox3Change(cbPropNpc);
end;

procedure TfrmRoleEdit.ReadRoleTargets;
Resourcestring
  sQueryItemsNodeStr = RoleItemsSceName;
var
  I: Integer;
  Node: IXMLDOMElement;
begin
  Node  := m_Role.selectSingleNode(RoleItemsSceName) as IXMLDOMElement;
  if Node = nil then
    Exit;
  lvTargets.Items.Clear;
  for I := 0 to Node.childNodes.length - 1 do
  begin
    AddItemsList(Node.childNodes.item[I]);
  end;
  
end;



procedure TfrmRoleEdit.UpDateRoleProm;
var
  Element: IXMLDOMElement;
  I,iCount: Integer;
begin
  Element := RoleElement.selectSingleNode(PromAttr) as IXMLDOMElement;

  if ComboBox6.ItemIndex > -1 then
    Element.setAttribute(RolePromulgationMap, TRoleEnvir(ComboBox6.Items.Objects[ComboBox6.ItemIndex]).MapLangid)
  else
    Element.setAttribute(RolePromulgationMap, defint);

  if cbPropNpc.ItemIndex > -1 then
    Element.setAttribute(RolePromulgationNPC, TEnvirNPC(cbPropNpc.Items.Objects[cbPropNpc.ItemIndex]).NPCLangID)
  else
    Element.setAttribute(RolePromulgationNPC, defint);

  Element.setAttribute(PromtypeAttr, cb3.ItemIndex);
  if chk1.Checked then
   Element.setAttribute(PromisFPAttr, 0)
  else
   Element.setAttribute(PromisFPAttr, 1);
end;


procedure TfrmRoleEdit.UpDateRoleComp;
var
  Element: IXMLDOMElement;
  I,iCount: Integer;
begin
  Element := RoleElement.selectSingleNode(CompAttr) as IXMLDOMElement;

  if cb2.ItemIndex > -1 then
    Element.setAttribute(RoleAcceptMap, TRoleEnvir(cb2.Items.Objects[cb2.ItemIndex]).MapLangid)
  else
    Element.setAttribute(RoleAcceptMap, defint);

  if cbCompNpc.ItemIndex > -1 then
    Element.setAttribute(RoleAcceptNPC, TEnvirNPC(cbCompNpc.Items.Objects[cbCompNpc.ItemIndex]).NPCLangID)
  else
    Element.setAttribute(RoleAcceptNPC, defint);

  Element.setAttribute(ComptypeAttr, cb4.ItemIndex);
  if chk2.Checked then
   Element.setAttribute(CompisFPAttr, 0)
  else
   Element.setAttribute(CompisFPAttr, 1);
end;




procedure TfrmRoleEdit.ReadRoleProm;
var
  Element: IXMLDOMElement;
  i64: Int64;
  RoleMap: TRoleEnvir;
  NPC: TEnvirNPC;
begin
  Element := m_Role.selectSingleNode(PromAttr) as IXMLDOMElement;
  try
    //发行地图和NPC
    cb3.ItemIndex := TryGetAttrValue(Element, PromtypeAttr);
    if TryGetAttrValue(Element, PromisFPAttr) = 0 then
       chk1.Checked := true
    else
       chk1.Checked := False;


    i64 := TryGetAttrValue(Element, RolePromulgationMap);
    RoleMap := frmMain.GetMapByLangid( i64 );
    if RoleMap <> nil then
    begin
      ComboBox6.ItemIndex := ComboBox6.Items.IndexOfObject( RoleMap );
      ComboBox6Select( ComboBox6 );

      NPC := frmMain.GetMapNPCByLandid( i64, GetPCNPCName(Element, RolePromulgationNPC) );
      if NPC <> nil then
        cbPropNpc.ItemIndex := cbPropNpc.Items.IndexOfObject( NPC )
      else cbPropNpc.Text := '无效的NPC';
    end
    else begin
      ComboBox6.Text := '无效的地图';
      cbPropNpc.Text := '无效的NPC';
    end;
  except
    Exit;
  end;
end;


procedure TfrmRoleEdit.ReadRoleComp;
var
  Element: IXMLDOMElement;
  i64: Int64;
  RoleMap: TRoleEnvir;
  NPC: TEnvirNPC;
begin
  Element := m_Role.selectSingleNode(CompAttr) as IXMLDOMElement;


 //接受地图和NPC
  try
    cb4.ItemIndex := TryGetAttrValue(Element, ComptypeAttr);
    if TryGetAttrValue(Element, CompisFPAttr) = 0 then
       chk2.Checked := true
    else
       chk2.Checked := False;

    i64 :=   TryGetAttrValue(Element, RoleAcceptMap);
    RoleMap := frmMain.GetMapByLangid( i64 );
    if RoleMap <> nil then
    begin
      cb2.ItemIndex := cb2.Items.IndexOfObject( RoleMap );
      cb2Select( cb2 );

      NPC := frmMain.GetMapNPCByLandid( i64, GetPCNPCName(Element, RoleAcceptNPC) );
      if NPC <> nil then
        cbCompNpc.ItemIndex := cbCompNpc.Items.IndexOfObject( NPC )
      else cbCompNpc.Text := '无效的NPC';
    end
    else begin
      cb2.Text := '无效的地图';
      cbCompNpc.Text := '无效的NPC';
    end;
  except
    Exit;
  end;
end;


procedure TfrmRoleEdit.UpDateRoleSurprise;
var
  Node   : IXMLDOMNode;
  NodeList   : IXMLDOMNodeList;
  Element: IXMLDOMElement;
  I,iCount: Integer;
begin
  Node := RoleElement.selectSingleNode(surpriseAwardTable);
  NodeList := Node.selectNodes(surpriseAwardSTable);
  for I := 0 to lvsurprise.Items.Count - 1 do
  begin
    if I < NodeList.length then
    begin
      Element := NodeList[I] as IXMLDOMElement;
      Element.setAttribute(surpriseawardprobAttr, lvsurprise.Items[I].Caption);
      Element.setAttribute(surpriseawardrateAttr, lvsurprise.Items[I].SubItems[0]);
    end
    else begin
      Element  := frmMain.m_Xml.createElement(surpriseAwardSTable) as IXMLDOMElement;
      Element.setAttribute(surpriseawardprobAttr, lvsurprise.Items[I].Caption);
      Element.setAttribute(surpriseawardrateAttr, lvsurprise.Items[I].SubItems[0]);
      Node.appendChild(Element);
    end;
  end;

  iCount := NodeList.length-1;
  for I := 0 to NodeList.length - lvsurprise.Items.Count-1 do
  begin
    NodeList[0].parentNode.removeChild(NodeList[iCount]);
    Dec(iCount);
  end;
end;

procedure TfrmRoleEdit.UpDateRoleConds;
var
  Node   : IXMLDOMNode;
  NodeList   : IXMLDOMNodeList;
  Element: IXMLDOMElement;
  I,iCount: Integer;
begin
  Node := RoleElement.selectSingleNode(RoleConditionS);
  NodeList := Node.selectNodes(RoleCondition);
  for I := 0 to lvConds.Items.Count - 1 do
  begin
    if I < NodeList.length then
    begin
      Element := NodeList[I] as IXMLDOMElement;
      Element.setAttribute(CondtypeAttr, lvConds.Items[I].StateIndex);
      Element.setAttribute(CondidAttr, lvConds.Items[I].SubItems[2]);
      Element.setAttribute(CondCountAttr, lvConds.Items[I].SubItems[1]);
    end
    else begin
      Element  := frmMain.m_Xml.createElement(RoleCondition) as IXMLDOMElement;
      Element.setAttribute(CondtypeAttr, lvConds.Items[I].StateIndex);
      Element.setAttribute(CondidAttr, lvConds.Items[I].SubItems[2]);
      Element.setAttribute(CondCountAttr, lvConds.Items[I].SubItems[1]);
      Node.appendChild(Element);
    end;
  end;
  iCount := NodeList.length-1;
  for I := 0 to NodeList.length - lvConds.Items.Count-1 do
  begin
    NodeList[0].parentNode.removeChild(NodeList[iCount]);
    Dec(iCount);
  end;
end;


procedure TfrmRoleEdit.UpDateRoleAwards;
var
  Node   : IXMLDOMNode;
  NodeList   : IXMLDOMNodeList;
  AwardElement: IXMLDOMElement;
  I,iCount: Integer;
begin

  NodeList := CurAwardTag.selectNodes(RoleAwardSecName);

  for I := 0 to ListViewAwards.Items.Count - 1 do
  begin
    if I < NodeList.length then
    begin
      AwardElement  := NodeList[I] as IXMLDOMElement;
      AwardElement.setAttribute(AwardModeAtbName, ListViewAwards.Items[I].StateIndex);
      // 0-id 15-idname
      AwardElement.setAttribute(AWardItemIdAtbName, ListViewAwards.Items[I].SubItems[15]);
      AwardElement.setAttribute(AWardCountAtbName, ListViewAwards.Items[I].SubItems[1]);
      AwardElement.setAttribute(AWardQualityAtbName, ListViewAwards.Items[I].SubItems[2]);
      AwardElement.setAttribute(AWardStrongAtbName, ListViewAwards.Items[I].SubItems[3]);
      AwardElement.setAttribute(groupAttr, ListViewAwards.Items[I].SubItems[4]);
      AwardElement.setAttribute(AWardItemBindAtbName, ListViewAwards.Items[I].SubItems[5]);
      AwardElement.setAttribute(jobAttr, ListViewAwards.Items[I].SubItems[6]);
      AwardElement.setAttribute(sexAttr, ListViewAwards.Items[I].SubItems[7]);
      AwardElement.setAttribute(levelRateAttr, ListViewAwards.Items[I].SubItems[8]);
      AwardElement.setAttribute(ringRateAttr, ListViewAwards.Items[I].SubItems[9]);
      AwardElement.setAttribute(vipLevelAttr, ListViewAwards.Items[I].SubItems[10]);
      AwardElement.setAttribute(bossLevelAttr, ListViewAwards.Items[I].SubItems[11]);
      AwardElement.setAttribute(importantLevelAttr, ListViewAwards.Items[I].SubItems[12]);
      AwardElement.setAttribute(initAttrsAttr, ListViewAwards.Items[I].SubItems[13]);
      AwardElement.setAttribute(datastrAttr, ListViewAwards.Items[I].SubItems[14]);
    end
    else begin
      AwardElement  := frmMain.m_Xml.createElement(RoleAwardSecName) as IXMLDOMElement;
      AwardElement.setAttribute(AwardModeAtbName, ListViewAwards.Items[I].StateIndex);
      AwardElement.setAttribute(AWardItemIdAtbName, ListViewAwards.Items[I].SubItems[15]);
      AwardElement.setAttribute(AWardCountAtbName, ListViewAwards.Items[I].SubItems[1]);
      AwardElement.setAttribute(AWardQualityAtbName, ListViewAwards.Items[I].SubItems[2]);
      AwardElement.setAttribute(AWardStrongAtbName, ListViewAwards.Items[I].SubItems[3]);
      AwardElement.setAttribute(groupAttr, ListViewAwards.Items[I].SubItems[4]);
      AwardElement.setAttribute(AWardItemBindAtbName, ListViewAwards.Items[I].SubItems[5]);
      AwardElement.setAttribute(jobAttr, ListViewAwards.Items[I].SubItems[6]);
      AwardElement.setAttribute(sexAttr, ListViewAwards.Items[I].SubItems[7]);
      AwardElement.setAttribute(levelRateAttr, ListViewAwards.Items[I].SubItems[8]);
      AwardElement.setAttribute(ringRateAttr, ListViewAwards.Items[I].SubItems[9]);
      AwardElement.setAttribute(vipLevelAttr, ListViewAwards.Items[I].SubItems[10]);
      AwardElement.setAttribute(bossLevelAttr, ListViewAwards.Items[I].SubItems[11]);
      AwardElement.setAttribute(importantLevelAttr, ListViewAwards.Items[I].SubItems[12]);
      AwardElement.setAttribute(initAttrsAttr, ListViewAwards.Items[I].SubItems[13]);
      AwardElement.setAttribute(datastrAttr, ListViewAwards.Items[I].SubItems[14]);
      CurAwardTag.appendChild(AwardElement);
    end;
  end;
  iCount := NodeList.length-1;
  for I := 0 to NodeList.length-ListViewAwards.Items.Count-1 do
  begin
    NodeList[0].parentNode.removeChild(NodeList[iCount]);
    Dec(iCount);
  end;
end;



procedure TfrmRoleEdit.UpDateRoleNeeds;
var
  Node   : IXMLDOMNode;
  NodeList   : IXMLDOMNodeList;
  NeedElement: IXMLDOMElement;
  I,iCount: Integer;
begin
  Node := RoleElement.selectSingleNode(QuickCompNeedsSecName);
  NodeList := Node.selectNodes(QuickCompNeedSecName);
  for I := 0 to lv1.Items.Count - 1 do
  begin
    if I < NodeList.length then
    begin
      NeedElement := NodeList[I] as IXMLDOMElement;
      NeedElement.setAttribute(QuickModeAtbName, lv1.Items[I].StateIndex);
      NeedElement.setAttribute(QuickItemIdAtbName, Integer(lv1.Items[I].SubItems.Objects[0]));
      NeedElement.setAttribute(QuickCountAtbName, Integer(lv1.Items[I].SubItems.Objects[1]));
    end
    else begin
      NeedElement  := frmMain.m_Xml.createElement(QuickCompNeedSecName) as IXMLDOMElement;
      NeedElement.setAttribute(QuickModeAtbName, lv1.Items[I].StateIndex);
      NeedElement.setAttribute(QuickItemIdAtbName, Integer(lv1.Items[I].SubItems.Objects[0]));
      NeedElement.setAttribute(QuickCountAtbName, Integer(lv1.Items[I].SubItems.Objects[1]));
      Node.appendChild(NeedElement);
    end;
  end;
  iCount := NodeList.length-1;
  for I := 0 to NodeList.length-lv1.Items.Count-1 do
  begin
    NodeList[0].parentNode.removeChild(NodeList[iCount]);
    Dec(iCount);
  end;
end;


procedure TfrmRoleEdit.lvAwardTagsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if lvAwardTags.Selected = nil then Exit;
 m_AwardId := lvAwardTags.Selected.Index;
 CurAwardTag := ReadRoleAwards(m_AwardId);
end;

procedure TfrmRoleEdit.UpDateRoleInfo;
var
  Element: IXMLDOMElement;
  nIdx, I, nRoleId, nOldID: Integer;
  RoleDate: TRoleDateTime;
  // 要不要修改id
  function BchageID(oldRoleType:Integer):BOOlean;
  var
   NewRoleType :integer;
  begin
    NewRoleType := ComboBox9.ItemIndex;
    Result := ((oldRoleType = 0) and (NewRoleType <> 0))
            or((NewRoleType = 0) and (oldRoleType <> 0));
  end;
begin
  Element := m_Role.cloneNode(TRUE) as IXMLDOMElement;
  nIdx  := 0;
  if ComboBox1.ItemIndex > -1 then
    nIdx := Integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  Element.setAttribute(RoleInheritedAtbName, nIdx);
  // 可重复执行的任务ID > 8000
  nOldID := TryGetAttrValue(Element, RoleIdAtbName);

  if BchageID(TryGetAttrValue(Element, RoleKindAttrName)) then
  begin
    if ComboBox9.ItemIndex <> 0 then
    begin
      nRoleId := frmMain.AllocRoleId(True, nOldID);
      Element.setAttribute(RoleIdAtbName, nRoleId);
    end else
    begin
      nRoleId := frmMain.AllocRoleId(False, nOldID);
      Element.setAttribute(RoleIdAtbName, nRoleId);
    end;

    frmMain.ListView1.Selected.SubItems.Objects[1] := TObject(nRoleId);
  end;


  Element.setAttribute(RoleNeedLevel, SpinEdit8.Value);
  Element.setAttribute(RoleMaxTimeAtbName, SpinEdit6.Value);

  Element.setAttribute(entrustAttr, seEntrust.Value);
  Element.setAttribute(multiAwardAttr, seAward.Value);
//  Element.setAttribute(doubleYBAttr, getluaboolstr(chkYB.Checked));

  Element.setAttribute(DoubleMoneyTypeAttr, cbDoubleMoney.ItemIndex);
  Element.setAttribute(AgainMoneyTypeAttr, cbAgainMoney.ItemIndex);


  Element.setAttribute(maxcirAttr, se4.Value);
  Element.setAttribute(circleAttr, se1.Value);
  Element.setAttribute(guideIdAttr, cb5.ItemIndex);
  Element.setAttribute(speedYbAttr, se3.Value);
  Element.setAttribute(RoleKindAttrName, ComboBox9.ItemIndex);
  //更新排斥任务分类
  Element.setAttribute(ExcludeChilds, GetLuaBoolStr(CheckBox2.Checked));
  Element.setAttribute(RoleAbortable, GetLuaBoolStr(CheckBox3.Checked));
  Element.setAttribute(RoleAutoTransmitAttrName, GetLuaBoolStr(cBoxTransmit.Checked));
  Element.setAttribute(RoleAutoCompleteAttrName, GetLuaBoolStr(CBComTrans.Checked));


  // NoFindByDriver 不通过车夫寻路
  Element.setAttribute(RoleWayfindingByDriver, GetLuaBoolStr(chkFindByDriver.Checked));
  Element.setAttribute(automountAttr, GetLuaBoolStr(chk3.Checked));
  Element.setAttribute(randomTargetAttr, GetLuaBoolStr(chk4.Checked));
  Element.setAttribute(notGiveAwardAttr, GetLuaBoolStr(CheckBoxGiveAward.Checked));

  Element.setAttribute(RoleIntervalValue, seinterval.Value);
  Element.setAttribute(starAttr, seStar.Value);


  UpDateRoleConds(Element);
  UpDateRoleComp(Element);
  UpDateRoleProm(Element);
  UpDateRoleSurprise(Element);



  nIdx := 0;

    setAttrLangText(Element, RoleDescSecName,
      StringReplace(Memo1.Text, #13#10, '\', [rfReplaceAll]));

    setAttrLangText(Element, RolePromTalkSecName,
      StringReplace(MemoPromTalk.Text, #13#10, '\', [rfReplaceAll]));

    setAttrLangText(Element, RoleCompTalkSecName,
      StringReplace(MemoCompTalk.Text, #13#10, '\', [rfReplaceAll]));

    setAttrLangText(Element, RoleAcceptStorySecName,
      StringReplace(MemoAcceptStory.Text, #13#10, '\', [rfReplaceAll]));

    setAttrLangText(Element, RoleFinishStorySecName,
      StringReplace(MemoFinishStory.Text, #13#10, '\', [rfReplaceAll]));

  m_Role.parentNode.replaceChild(Element, m_Role);
end;

procedure TfrmRoleEdit.UpDateRoleTargets;
var
  Node   : IXMLDOMNode;
  NodeList   : IXMLDOMNodeList;
  ItemElement: IXMLDOMElement;
  I, nVal,iCount: Integer;
begin
//  Node := RoleElement.selectSingleNode(RoleItemsSceName);
//  NodeList := Node.selectNodes(RoleItemSecName);
//  for I := 0 to lvTargets.Items.Count - 1 do
//  begin
//    nVal := lvTargets.Items[I].StateIndex;
//    if I < NodeList.length then
//    begin
//      ItemElement := NodeList[I] as IXMLDOMElement;
//      ItemElement.setAttribute(ItemExecModeAtbName, nVal);
//      ItemElement.setAttribute(ItemExecIdAtbName, Integer(lvTargets.Items[I].SubItems.Objects[0]));
//      ItemElement.setAttribute(ItemNeedCountAtbName, Integer(lvTargets.Items[I].SubItems.Objects[1]));
//      ItemElement.setAttribute(ItemNeedQualityAtbName, Integer(lvTargets.Items[I].SubItems.Objects[2]));
//      ItemElement.setAttribute(ItemNeedStrongLevelAtbName, Integer(lvTargets.Items[I].SubItems.Objects[3]));
//      if nVal = Integer(reCustom) then
//        SetAttrLangText(ItemElement, ItemCustomDataAtbName, GetRoleCustomItemStr(lvTargets.Items[I].SubItems[0]));
//      ItemElement.setAttribute(ItemNeedLocationAtbName, SetStrLocations(TRoleExecuteMode(nVal),lvTargets.Items[I].SubItems[4]));
//      ItemElement.setAttribute(ItemJobAtbName, Integer(lvTargets.Items[I].SubItems.Objects[5]));
//    end
//    else begin
//      ItemElement  := frmMain.m_Xml.createElement(RoleItemSecName) as IXMLDOMElement;
//      ItemElement.setAttribute(ItemExecModeAtbName, nVal);
//      ItemElement.setAttribute(ItemExecIdAtbName, Integer(lvTargets.Items[I].SubItems.Objects[0]));
//      ItemElement.setAttribute(ItemNeedCountAtbName, Integer(lvTargets.Items[I].SubItems.Objects[1]));
//      ItemElement.setAttribute(ItemNeedQualityAtbName, Integer(lvTargets.Items[I].SubItems.Objects[2]));
//      ItemElement.setAttribute(ItemNeedStrongLevelAtbName, Integer(lvTargets.Items[I].SubItems.Objects[3]));
//      if nVal = Integer(reCustom) then                                         
//        SetAttrLangText(ItemElement, ItemCustomDataAtbName, GetRoleCustomItemStr(lvTargets.Items[I].SubItems[0]))
//      else ItemElement.setAttribute(ItemCustomDataAtbName, 0);
//      ItemElement.setAttribute(ItemNeedLocationAtbName, SetStrLocations(TRoleExecuteMode(nVal),lvTargets.Items[I].SubItems[4]));
//      ItemElement.setAttribute(ItemJobAtbName, Integer(lvTargets.Items[I].SubItems.Objects[5]));
//      Node.appendChild(ItemElement);
//    end;
//  end;
//  iCount := NodeList.length-1;
//  for I := 0 to NodeList.length-lvTargets.Items.Count-1 do
//  begin
//    NodeList[0].parentNode.removeChild(NodeList[iCount]);
//    Dec(iCount);
//  end;
end;

end.
