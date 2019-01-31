unit UnitRoleItemAndAward;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Clipbrd, UnitLangPackage, msxml, UnitMain, ComCtrls, Buttons, Menus, ExtCtrls;

const
 xyStr = '%d:%d';
 InvalidTarge = '无效的目标';
 InvalidScene = '无效的地图';
type
  TfrmRoleItemAndAward = class(TForm)
    PageControl1: TPageControl;
    ts3: TTabSheet;
    tsAwards: TTabSheet;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    SpinEdit2: TSpinEdit;
    Button1: TButton;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    tsFastCom: TTabSheet;
    cbb1: TComboBox;
    lbl1: TLabel;
    cbb2: TComboBox;
    lbl2: TLabel;
    btn1: TSpeedButton;
    se1: TSpinEdit;
    lbl3: TLabel;
    lv1: TListView;
    se2: TSpinEdit;
    chk1: TCheckBox;
    chk2: TCheckBox;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edt1: TEdit;
    lbl7: TLabel;
    edt2: TEdit;
    lbl8: TLabel;
    edt3: TEdit;
    lbl9: TLabel;
    se5: TSpinEdit;
    lbl10: TLabel;
    se6: TSpinEdit;
    lbl11: TLabel;
    se7: TSpinEdit;
    lbl12: TLabel;
    se8: TSpinEdit;
    ts2: TTabSheet;
    cb1: TComboBox;
    lbl13: TLabel;
    se9: TSpinEdit;
    lbl14: TLabel;
    lbl15: TLabel;
    se10: TSpinEdit;
    grp2: TGroupBox;
    pnl1: TPanel;
    lbl19: TLabel;
    lbl20: TLabel;
    lbl21: TLabel;
    lbl18: TLabel;
    cb2: TComboBox;
    se13: TSpinEdit;
    se11: TSpinEdit;
    chk3: TCheckBox;
    se12: TSpinEdit;
    grp1: TGroupBox;
    lbl16: TLabel;
    lbl17: TLabel;
    edt4: TEdit;
    edt5: TEdit;
    ts4: TTabSheet;
    se18: TSpinEdit;
    lbl22: TLabel;
    se19: TSpinEdit;
    lbl26: TLabel;
    lbl27: TLabel;
    btn3: TButton;
    lbl28: TLabel;
    edt6: TEdit;
    pmpass: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    cb3: TComboBoxEx;
    cb4: TComboBoxEx;
    cb5: TComboBoxEx;
    cb8: TComboBoxEx;
    cb9: TComboBoxEx;
    grp3: TGroupBox;
    lvpass: TListView;
    pnl2: TPanel;
    lbl24: TLabel;
    lbl23: TLabel;
    lbl25: TLabel;
    se15: TSpinEdit;
    se16: TSpinEdit;
    chk4: TCheckBox;
    cb6: TComboBoxEx;
    cb7: TComboBoxEx;
    cbjob: TComboBox;
    cbsex: TComboBox;
    tsSurprise: TTabSheet;
    lblLuckValue: TLabel;
    seProb: TSpinEdit;
    lblLuckRate: TLabel;
    serate: TSpinEdit;
    tsMultiAward: TTabSheet;
    seMARate: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbMutiAwardType: TComboBox;
    Label3: TLabel;
    seMAValue: TSpinEdit;
    procedure cb9Select(Sender: TObject);
    procedure cb7Select(Sender: TObject);
    procedure cb6Select(Sender: TObject);
    procedure cb2Change(Sender: TObject);
    procedure cb5Change(Sender: TObject);
    procedure cb4Change(Sender: TObject);
    procedure cb3Change(Sender: TObject);
    procedure cb1Change(Sender: TObject);
    procedure pmpassPopup(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure cbb1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure setLocationValue;
    procedure AddPassList(ItemNode: IXMLDOMNode);
    procedure ReadLocationPass;
    procedure setPageVisible(tsname :TTabSheet);
    function EditTargetLoaction: boolean;          
    procedure ReadTargetLocation();
  public
    TargetElement: IXMLDOMElement;
    TargetLocation : IXMLDOMElement;
    LocationPasses : IXMLDOMNode;
    LocationPass : IXMLDOMElement;
    BaddLoaction: Boolean;
    BaddPass :boolean;
  published
  end;

function EditRoleCond(var RoleCond: TRoleCond):Boolean;
function EditRoleTarget(var TargetEle: IXMLDOMElement; itag:Integer =0):Boolean;
//function EditRoleAward(var RoleAward: TRoleAward):Boolean;overload;
function EditRoleAward(var TargetEle: IXMLDOMElement):Boolean;overload;
// 快速完成
function EditRoleNeed(var RoleNeed: TRoleNeed):Boolean;
function EditRoleSurprise(var TargetEle: IXMLDOMElement):Boolean;
function EditMutiAward(var TargetEle: IXMLDOMElement):Boolean;

implementation
uses UnitRoleEdit;



{$R *.dfm}

const
  ClientAWardHeights : array [TRoleAwardMode] of Integer = (
    198, 296  );
  ClientExecHeights : array [TRoleExecuteMode] of Integer = (
    220, 290, 220, 220, 290, 290, 290, 220, 290, 220, 220, 330, 220, 220
  );

  ClientNeedHeights : array [TRoleNeedsMode] of Integer = (
    222, 222, 222, 222
  );   //  517



function GetEleValue(const TargetElement: IXMLDOMElement; const Attr:string):Variant;
begin
  Result := 0;
 try
  Result := TargetElement.getAttribute(Attr);
 except
  Result := 0;
 end;
end;


procedure TfrmRoleItemAndAward.ReadLocationPass();
Resourcestring
  sQueryPassesNodeStr = PassesAttr;
var
  I: Integer;
begin
  LocationPasses := TargetLocation.selectSingleNode(sQueryPassesNodeStr) as IXMLDOMElement;
  lvpass.Items.Clear;
  if LocationPasses = nil then   Exit;
  BaddPass := true;
  for I := 0 to LocationPasses.childNodes.length - 1 do
  begin
    AddPassList(LocationPasses.childNodes.item[I]);
  end;
  BaddPass := False;
end;



procedure TfrmRoleItemAndAward.ReadTargetLocation();
Resourcestring
  sQueryLocationsNodeStr = locationesAttr;
var
  I: Integer;
  procedure ReadLocationAttr();
  var
   i64:Integer;
   RoleMap: TRoleEnvir;
   obj : TObject;
  begin
    with TargetLocation do
    begin
      try
        i64 :=   getAttribute(sceneidAttr);
        RoleMap := frmMain.GetMap( i64 );
        if RoleMap <> nil then
        begin
          cb6.ItemIndex := cb6.Items.IndexOfObject( RoleMap );
          cb6Select( cb6 );

          obj := frmMain.GetMapNPCOrMonster( i64, getAttribute(entityNameAttr) );
          if obj <> nil then
            cb7.ItemIndex := cb7.Items.IndexOfObject( obj )
          else cb7.Text := InvalidTarge;
        end
        else begin
          cb6.Text := InvalidScene;
          cb7.Text := InvalidTarge;
        end;
        se15.Value := getAttribute(locationXAttr);
        se16.Value := getAttribute(locationYAttr);
        chk4.Checked := getAttribute(hideFastTransferAttr);
      except
      end;
    end;
  end;
begin

  se15.Value := 0;
  se16.Value := 0;
  chk4.Checked := False;
  TargetLocation := TargetElement.selectSingleNode(sQueryLocationsNodeStr) as IXMLDOMElement;
  // 对于已存在的节点处理 需要再次添加子节点
  if TargetLocation = nil then
   TargetLocation := TargetElement.appendChild(frmMain.m_Xml.createElement(locationesAttr)) as IXMLDOMElement;
  ReadLocationAttr;
  ReadLocationPass;
end;


procedure TfrmRoleItemAndAward.setLocationValue;
var
 index :integer;
begin
  if TargetLocation = nil then exit;
  
  if cb6.ItemIndex > -1 then
   TargetLocation.setAttribute(sceneidAttr, TRoleEnvir(cb6.Items.Objects[cb6.ItemIndex]).MapId)
  else
   TargetLocation.setAttribute(sceneidAttr, 0);

  if cb7.ItemIndex > -1 then
  begin
   index := cb7.ItemIndex;
   if cb7.Items.Objects[index] is TEnvirNPC then
    TargetLocation.setAttribute(entityNameAttr, TEnvirNPC(cb7.Items.Objects[index]).NPCLangID)
   else if cb7.Items.Objects[index] is TEnvirMonster then
    TargetLocation.setAttribute(entityNameAttr, TEnvirMonster(cb7.Items.Objects[index]).MonLangid)
  end
  else
   TargetLocation.setAttribute(entityNameAttr, '');

  TargetLocation.setAttribute(locationXAttr, se15.Value);
  TargetLocation.setAttribute(locationYAttr, se16.Value);
  TargetLocation.setAttribute(hideFastTransferAttr, GetLuaBoolStr(chk4.Checked));
end;


procedure TfrmRoleItemAndAward.setPageVisible(tsname :TTabSheet);
var
 i :Byte;
begin
  if (tsname = ts4) then
  begin
    Button1.Visible := False;
  end else
    Button1.Visible := True;


  for I := 0 to PageControl1.PageCount - 1 do
  begin
    if PageControl1.Pages[i] = tsname then
    begin
     PageControl1.Pages[i].TabVisible := True;
//     PageControl1.TabIndex := i;
    end
    else
     PageControl1.Pages[i].TabVisible := False;
  end;
end;





procedure TfrmRoleItemAndAward.AddPassList(ItemNode: IXMLDOMNode);
var
  nVal, ien: Integer;
  TempItem : TListItem;
  obj: tobject;
begin
  if BaddPass then
   TempItem := lvpass.Items.Add
  else
   TempItem := lvpass.Selected;

  with TempItem, ItemNode.attributes do
  begin
    nVal := getNamedItem(PasssceneidAttr).nodeValue;
    StateIndex :=  nVal;
    Caption := frmMain.GetMap(nVal).MapName;
    SubItems.Clear;
    ien := getNamedItem(PassentityNameAttr).nodeValue;
    obj := frmMain.GetMapNPCOrMonster( StateIndex, ien);
    if obj <> nil then
      SubItems.Add(TCustomEnvirObject(obj).Name)
    else
      SubItems.Add(InvalidTarge);
    nVal := getNamedItem(xAttr).nodeValue;
    ien  := getNamedItem(yAttr).nodeValue;
    SubItems.Add(Format(xyStr, [nVal,ien]));
    SubItems.Add(LanguagePackage.GetLangText(RoleLangCategoryId, getNamedItem(actionDescAttr).nodeValue));

  end
end;

function EditRoleSurprise(var TargetEle: IXMLDOMElement):Boolean;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin
    setPageVisible(tsSurprise);
    Caption := '编辑惊喜奖励';
    try
      seProb.value := GetEleValue(TargetEle, surpriseawardprobAttr);
      serate.value := GetEleValue(TargetEle, surpriseawardrateAttr);
    except

    end;

    if ShowModal = mrOK then
    begin
      TargetEle.setAttribute(surpriseawardrateAttr, serate.value);
      TargetEle.setAttribute(surpriseawardprobAttr, seProb.value);
      result := true;
    end;
    Free;
  end;
end;


function EditMutiAward(var TargetEle: IXMLDOMElement):Boolean;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin
    setPageVisible(tsMultiAward);
    Caption := '编辑多倍奖励';
    try
      cbMutiAwardType.ItemIndex :=  GetEleValue(TargetEle, MAMoneyTypeAttr);
      seMARate.value := GetEleValue(TargetEle, MARateAttr);
      seMAValue.value := GetEleValue(TargetEle, MAmoneyCountAttr);
    except
      OutputDebugString('读取惊喜奖励 属性值时出错');
    end;

    if ShowModal = mrOK then
    begin
      TargetEle.setAttribute(MAMoneyTypeAttr, cbMutiAwardType.ItemIndex);
      TargetEle.setAttribute(MARateAttr, seMARate.value);
      TargetEle.setAttribute(MAmoneyCountAttr, seMAValue.value);
      result := true;
    end;
    Free;
  end;
end;

function EditRoleTarget(var TargetEle: IXMLDOMElement; itag :Integer):Boolean;
var
  S: string;
  idata, idm, imode :integer;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin

    Caption := '编辑任务目标';
    setPageVisible(ts3);
    TargetElement :=  TargetEle;
    cb6.Items.AddStrings(frmMain.m_MapList);
    cb8.Items.AddStrings(frmMain.m_MapList);
    se12.Value := itag;
    try
      iMode := GetEleValue(TargetElement, ItemExecModeAtbName);
      if iMode = 127 then
       cb2.ItemIndex := length(RoleExecuteModeStr)-2
      else
      if iMode = 256 then
       cb2.ItemIndex := length(RoleExecuteModeStr)-1
      else
       cb2.ItemIndex := iMode;

      se11.Value := GetEleValue(TargetElement, ItemExecIdAtbName);
      cb2Change(nil);
      se13.Value := GetEleValue(TargetElement, ItemNeedCountAtbName);


      TryStrToInt(GetEleValue(TargetElement, dataAttr), idata);
      edt4.Tag := idata;
      edt4.Text := LanguagePackage.GetLangText(RoleLangCategoryId, idata);

      TryStrToInt(GetEleValue(TargetElement, dataMonsterAttr), idm);
      edt5.Tag := idm;
      edt5.Text := LanguagePackage.GetLangText(RoleLangCategoryId, idm);
      chk3.Checked := GetEleValue(TargetElement, useListAttr);

    except

    end;
      ReadTargetLocation();

    if ShowModal = mrOK then                
    begin
        if cb2.ItemIndex >= length(RoleExecuteModeStr)-2 then
         if pos('127',cb2.Text)>0 then
           TargetElement.setAttribute(ItemExecModeAtbName, 127)
         else
           TargetElement.setAttribute(ItemExecModeAtbName, 256)
        else
         TargetElement.setAttribute(ItemExecModeAtbName, cb2.ItemIndex);
        TargetElement.setAttribute(ItemExecIdAtbName, se11.Value);
        TargetElement.setAttribute(ItemNeedCountAtbName, se13.Value);

        if edt4.Text = '' then
        begin
           TargetElement.setAttribute(dataAttr, edt4.Text)
        end else
        begin
          if edt4.Tag =0  then
          begin
            edt4.Tag :=LanguagePackage.AddLangText(RoleLangCategoryId,edt4.Text);
            TargetElement.setAttribute(dataAttr, edt4.Tag)
          end
          else
          begin
           idata := edt4.Tag;
           LanguagePackage.ReplaceLangText(RoleLangCategoryId, idata, edt4.Text);
          end;
        end;

        if edt5.Text = '' then
        begin
            TargetElement.setAttribute(dataMonsterAttr, edt5.Text);
        end
        else
        begin
          if edt5.Tag =0  then
          begin
            edt5.Tag :=LanguagePackage.AddLangText(RoleLangCategoryId,edt5.Text);
            TargetElement.setAttribute(dataMonsterAttr, edt5.Tag);
          end
          else
          begin
           idm := edt5.Tag;
           LanguagePackage.ReplaceLangText(RoleLangCategoryId, idm, edt5.Text);
          end;
        end;
        TargetElement.setAttribute(rewardIdAttr, se12.Value);
        TargetElement.setAttribute(useListAttr, GetLuaBoolStr(chk3.Checked));
        setLocationValue;
      TargetEle := TargetElement;
      result := true;
    end;
    Free;
  end;
end;

function EditRoleAward(var TargetEle: IXMLDOMElement):Boolean;overload;
var
  I: Integer;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin
    Caption := '编辑任务奖励';
    setPageVisible(tsAwards);
    ComboBox3.ItemIndex   := TryGetAttrValue(TargetEle, AwardModeAtbName);
    se2.Value       := TryGetAttrValue(TargetEle,AWardItemIdAtbName);
    ComboBox3Change(ComboBox3);
    SpinEdit4.Value := TryGetAttrValue(TargetEle,AWardQualityAtbName);
    SpinEdit3.Value := TryGetAttrValue(TargetEle,AWardStrongAtbName);
    SpinEdit2.Value := TryGetAttrValue(TargetEle,AWardCountAtbName);
    chk1.Checked := TryGetAttrValue(TargetEle,groupAttr);
    chk2.checked    := TryGetAttrValue(TargetEle,AWardItemBindAtbName);
    cbjob.ItemIndex := TryGetAttrValue(TargetEle,jobAttr);
    if TryGetAttrValue(TargetEle,sexAttr)= -1 then
      cbsex.ItemIndex := 2
    else
      cbsex.ItemIndex := TryGetAttrValue(TargetEle,sexAttr);

    edt1.Text       := LanguagePackage.GetLangText(RoleLangCategoryId, TryGetAttrValue(TargetEle,datastrAttr));
    edt2.Text       := TryGetAttrValue(TargetEle,levelRateAttr);
    edt3.Text       := TryGetAttrValue(TargetEle,ringRateAttr);
    se5.Value       := TryGetAttrValue(TargetEle,vipLevelAttr);
    se6.Value       := TryGetAttrValue(TargetEle,bossLevelAttr);
    se7.Value       := TryGetAttrValue(TargetEle,importantLevelAttr);
    se8.Value       := TryGetAttrValue(TargetEle,initAttrsAttr);

    if ShowModal = mrOK then
    begin
      Result := (ComboBox3.ItemIndex > -1) and (SpinEdit2.Value > 0);
      if not Result then
      begin
         ShowMessage('您没有选择奖励模式 或 没有奖励数量');
      end;
      
      if Result then
      begin
        with TargetEle do
        begin
         setAttribute(AwardModeAtbName, ComboBox3.ItemIndex);
         case ComboBox3.ItemIndex of
            0:
            begin
             setAttribute(AWardQualityAtbName, SpinEdit4.Value);
             setAttribute(AWardStrongAtbName, SpinEdit3.Value);
            end;
            else
            begin
             setAttribute(AWardQualityAtbName, 0);
             setAttribute(AWardStrongAtbName, 0);
            end;
         end;
          //group表示是否可选，0表示不可选（必送），否则表示可选奖励

         setAttribute(groupAttr, GetLuaBool(chk1.Checked));
         setAttribute(AWardItemIdAtbName, se2.Value);
         setAttribute(AWardQualityAtbName, SpinEdit4.Value);
         setAttribute(AWardStrongAtbName, SpinEdit3.Value);
         setAttribute(AWardCountAtbName, SpinEdit2.Value);
         setAttribute(AWardItemBindAtbName, GetLuaBoolstr(chk2.checked));
         setAttribute(jobAttr, cbjob.ItemIndex);
         if cbsex.ItemIndex = 2 then
          setAttribute(sexAttr, -1)
         else 
          setAttribute(sexAttr, cbsex.ItemIndex);
         SetAttrLangText(TargetEle, datastrAttr, edt1.Text);
         setAttribute(levelRateAttr, edt2.Text);
         setAttribute(ringRateAttr, edt3.Text);
         setAttribute(vipLevelAttr, se5.Value);
         setAttribute(bossLevelAttr, se6.Value);
         setAttribute(importantLevelAttr, se7.Value);
         setAttribute(initAttrsAttr, se8.Value);
        end;
      end;
    end;
    Free;
  end;
end;



function EditRoleCond(var RoleCond: TRoleCond):Boolean;
var
  I: Integer;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin
    Caption := '编辑任务条件';
    setPageVisible(ts2);

    with  RoleCond do
    begin
      cb1.ItemIndex   := btType;
      se9.Value       := id;
      cb1Change(cb1);
      se10.Value      := count;
    end;

    if ShowModal = mrOK then
    begin
      Result := (cb1.ItemIndex > -1) ;
      if Result then
      begin
        with RoleCond do
        begin
          btType := cb1.ItemIndex;
          id := se9.Value;
          count := se10.Value;
        end;
      end;
    end;
    Free;
  end;
end;


// 快速完成
function EditRoleNeed(var RoleNeed: TRoleNeed):Boolean;
begin
  Result := False;
  with TfrmRoleItemAndAward.Create(nil) do
  begin
    Caption := '编辑快速完成';
    setPageVisible(tsFastCom);
    cbb1.ItemIndex   := Integer(RoleNeed.Mode);
    cbb1Change(cbb1);
    case RoleNeed.Mode of
      rnItem:
      begin
        cbb2.ItemIndex := cbb2.Items.IndexOfObject(TObject(RoleNeed.ItemId));
        se1.Value := RoleNeed.count;
      end
      else
      begin
        se1.Value := RoleNeed.count;
      end;
    end;
    if ShowModal = mrOK then
    begin
      Result := (cbb1.ItemIndex > -1) and (se1.Value > 0);
      if Result then
      begin
        RoleNeed.Mode  := TRoleNeedsMode(cbb1.ItemIndex);
        case RoleNeed.Mode of
          rnItem:
          begin
            if cbb2.ItemIndex > -1 then
              RoleNeed.itemid := Integer(cbb2.Items.Objects[cbb2.ItemIndex]);
            RoleNeed.Count := se1.Value;
          end
          else
          begin
            if cbb2.ItemIndex > -1 then
              RoleNeed.itemid := Integer(cbb2.Items.Objects[cbb2.ItemIndex]);
            RoleNeed.Count := se1.Value;
          end;
        end;
      end;
    end;
    Free;
  end;
end;

procedure TfrmRoleItemAndAward.btn3Click(Sender: TObject);
  procedure setPassValue;
  var
   index :integer;
  begin
   with LocationPass do
   begin
     if cb8.ItemIndex > -1 then
      setAttribute(sceneidAttr, TRoleEnvir(cb8.Items.Objects[cb8.ItemIndex]).MapId)
     else
      setAttribute(sceneidAttr, 0);

      if cb9.ItemIndex > -1 then
      begin
       index := cb9.ItemIndex;
       if cb9.Items.Objects[index] is TEnvirNPC then
        setAttribute(PassentityNameAttr, TEnvirNPC(cb9.Items.Objects[index]).NPCLangID)
       else if cb9.Items.Objects[index] is TEnvirMonster then
        setAttribute(PassentityNameAttr, TEnvirMonster(cb9.Items.Objects[index]).MonLangid)
      end
      else
       setAttribute(PassentityNameAttr, 0);

     setAttribute(locationXAttr, se18.Value);
     setAttribute(locationYAttr, se19.Value);
     if edt6.tag<>0  then
      LanguagePackage.ReplaceLangText(RoleLangCategoryId, edt6.tag, edt6.Text)
     else
      setAttribute(actionDescAttr, LanguagePackage.AddLangText(RoleLangCategoryId,edt6.Text));
   end;
  end;
begin
   setPassValue;
   if BaddPass then LocationPasses.appendChild(LocationPass);
   AddPassList(LocationPass as IXMLDOMNode);
   setPageVisible(ts3);
end;


procedure TfrmRoleItemAndAward.cb1Change(Sender: TObject);
var
 itep :Integer;
 s :string;
begin
 with cb1  do
 begin
     if ItemIndex in CondItemindexSet then
     begin
       cb3.Items.Clear;
       cb3.Items.AddStrings(frmMain.m_DBItems);
       cb3.Visible := true;
       se9.Visible := False;
       cb3.ItemIndex := cb3.Items.IndexOfObject(TObject(se9.Value))
     end
     else if ItemIndex = 14 then
     begin
       cb3.Items.Clear;
       for s in RoleTypeStr do cb3.Items.add(s);
       cb3.Visible := true;
       se9.Visible := False;
       itep :=  se9.Value;
       cb3.ItemIndex := itep;
     end
     else
     begin
       cb3.Visible := False;
       se9.Visible := True;
     end;
 end;
end;

procedure TfrmRoleItemAndAward.cb2Change(Sender: TObject);
var
 monName : string;
begin
 with cb2  do
 begin
    cb5.Items.Clear;
    if ItemIndex in  TargetItemindexSet then
     begin
       cb5.Items.AddStrings(frmMain.m_DBItems);
       se11.Visible := False;
       cb5.Visible := true;
       cb5.ItemIndex := cb5.Items.IndexOfObject(TObject(se11.Value))
     end
    else if ItemIndex in  TargetMonindexSet then
     begin
       cb5.Items.AddStrings(frmMain.m_DBMonsters);
       se11.Visible := False;
       cb5.Visible := true;
       monName := frmMain.GetMonsterName(se11.Value);
       cb5.ItemIndex := cb5.Items.IndexOf(monName);
     end
    else if ItemIndex in  TaegetSenceIndexSet then
     begin
       cb5.Items.AddStrings(frmMain.m_MapList);
       se11.Visible := False;
       cb5.Visible := true;
       cb5.ItemIndex := cb5.Items.IndexOfObject(TObject(frmMain.GetMap(se11.Value)))
     end
    else if ItemIndex in  TaegetNpcIndexSet then
     begin
       cb5.Items.AddStrings(frmMain.m_ALlNPC);
       se11.Visible := False;
       cb5.Visible := true;
       cb5.ItemIndex := cb5.Items.IndexOfObject(TObject(se11.Value))
     end
    else
    begin
     cb5.Visible := False;
     se11.Visible := True;
    end;
 end;
end;

procedure TfrmRoleItemAndAward.cb3Change(Sender: TObject);
var
 i: Integer;
begin
  with Sender as TComboBoxEx do
  begin

    if ItemIndex <> -1 then
    begin
     if cb1.ItemIndex <> 14 then
      i :=  Integer(Items.objects[ItemIndex])
     else
      i :=  ItemIndex;
    end;

    se9.Value := i;
  end;
end;

procedure TfrmRoleItemAndAward.cb4Change(Sender: TObject);
var
 i: Integer;
begin
  with cb4 do
  begin
    if ItemIndex <> -1 then
    begin
      i :=  Integer(Items.objects[ItemIndex]);
      se2.Value := i;
    end;
  end;
end;


procedure TfrmRoleItemAndAward.cb5Change(Sender: TObject);
var
 i: Integer;
 st: string;
begin
  with cb5 do
  begin
    if ItemIndex >= 0 then
    begin
     try
      if Items.objects[ItemIndex] is TRoleEnvir then
       i := TRoleEnvir(Items.objects[ItemIndex]).MapId
      else if Items.objects[ItemIndex] is TEnvirMonster then
       i := TEnvirMonster(Items.objects[ItemIndex]).MonsterId
      else
       i :=  Integer(Items.objects[ItemIndex]);
     except
       i :=  Integer(Items.objects[ItemIndex]);
     end;
      se11.Value := i;
    end;
  end;
end;


procedure TfrmRoleItemAndAward.cb6Select(Sender: TObject);
var
  Idx: Integer;
  NpcCb, Mapcb: TComboBoxEx;
begin
  Mapcb := Sender as TComboBoxEx;
  if Mapcb = cb6 then
   NpcCb := cb7
  else if Mapcb = cb8 then
   NpcCb := cb9;

  NpcCb.Items.Clear;
  NpcCb.Items.AddStrings( TRoleEnvir(Mapcb.Items.Objects[Mapcb.ItemIndex]).NPCList);
  NpcCb.Items.AddStrings( TRoleEnvir(Mapcb.Items.Objects[Mapcb.ItemIndex]).MonList);
  
  Idx := NpcCb.Items.IndexOf(NpcCb.Text);
  NpcCb.Text := '';
  NpcCb.ItemIndex := Idx;
end;


procedure TfrmRoleItemAndAward.cb7Select(Sender: TObject);
var
  point: TPoint;
begin
 if cb7.ItemIndex > -1 then
 point := TCustomEnvirObject(cb7.Items.objects[cb7.ItemIndex]).Position;
 se15.value := point.x;
 se16.value := point.Y;
end;

procedure TfrmRoleItemAndAward.cb9Select(Sender: TObject);
var
  point: TPoint;
begin
 if cb9.ItemIndex > -1 then
 point := TCustomEnvirObject(cb9.Items.objects[cb9.ItemIndex]).Position;
 se18.value := point.x;
 se19.value := point.Y;
end;

procedure TfrmRoleItemAndAward.cbb1Change(Sender: TObject);
var
  ram: TRoleNeedsMode;
begin
  ram := TRoleNeedsMode(cbb1.ItemIndex);
  case ram of
    rnItem:
    begin
      cbb2.Clear;
      cbb2.Items.AddStrings(frmMain.m_DBItems);
      cbb2.Enabled := True;
    end
    else
    begin
      cbb2.Clear;
      cbb2.Enabled := False;
    end;
  end;
  ClientHeight := ClientNeedHeights[TRoleNeedsMode(cbb1.ItemIndex)];
end;


procedure TfrmRoleItemAndAward.ComboBox3Change(Sender: TObject);
begin
 with ComboBox3  do
 begin
    if ItemIndex in  AwordItemIndexSet then
     begin
      SpinEdit4.Visible := True;
      Label7.Visible := True;
      Label8.Visible := True;
      SpinEdit3.Visible := True;
      cb4.Visible := true;
       se2.Visible := False;
       cb4.ItemIndex := cb4.Items.IndexOfObject(TObject(se2.Value))
     end
     else
     begin
       cb4.Visible := False;
       se2.Visible := True;
      SpinEdit4.Visible := false;
      Label7.Visible := false;
      Label8.Visible := false;
      SpinEdit3.Visible := false;
     end;
 end;
end;




procedure TfrmRoleItemAndAward.FormCreate(Sender: TObject);
var
  S: string;
begin
  for S in RoleExecuteModeStr do
    cb2.Items.Add(S);
  for S in RoleAwardModeStr do
    ComboBox3.Items.Add(S);
  for S in RoleNeedModeStr do
    cbb1.Items.Add(S);
  for S in RoleCondModeStr do
    cb1.Items.Add(S);
  for s in MoneyTypeStr do
   cbMutiAwardType.Items.add(s);

    //物品列表

    cb4.Items.Clear;
    cb4.Items.AddStrings(frmMain.m_DBItems);


    cb5.Items.Clear;
    cb5.Items.AddStrings(frmMain.m_DBItems);

    TargetElement :=  nil;
    TargetLocation := nil;
    LocationPasses := nil;
    LocationPass := nil;
//    ShowModal;

end;

function TfrmRoleItemAndAward.EditTargetLoaction():boolean;
var
  S: string;
  idata, idm :integer;
begin
end;


procedure TfrmRoleItemAndAward.MenuItem10Click(Sender: TObject);
begin
  if LocationPasses = nil then
  begin
    LocationPasses := TargetLocation.appendChild(frmMain.m_Xml.createElement(PassesAttr) as IXMLDOMElement)
  end;
  BaddPass := true;

  cb8.itemindex := -1;
  cb9.itemindex := -1;
  se18.Value := 0;
  se19.Value := 0;
  edt6.tag := 0;
  edt6.Text :=  '';


  setPageVisible(ts4);
  LocationPass  := frmMain.m_Xml.createElement(PassAttr) as IXMLDOMElement;

end;

procedure TfrmRoleItemAndAward.MenuItem5Click(Sender: TObject);
var
 i64:Integer;
 RoleMap: TRoleEnvir;
 obj : TObject;
begin
  if lvpass.Selected = nil then Exit;
  BaddPass := False;
  setPageVisible(ts4);
  LocationPass := LocationPasses.childNodes[lvpass.Selected.index] as IXMLDOMElement;
  if LocationPass =nil then Exit;
  with LocationPass do
  begin

    i64 :=   getAttribute(sceneidAttr);
    RoleMap := frmMain.GetMap( i64 );
    if RoleMap <> nil then
    begin
      cb8.ItemIndex := cb8.Items.IndexOfObject( RoleMap );
      cb6Select( cb8 );
      obj := frmMain.GetMapNPCOrMonster( i64, getAttribute(PassentityNameAttr) );
      if obj <> nil then
        cb9.ItemIndex := cb9.Items.IndexOfObject( obj )
      else cb9.Text := InvalidTarge;
    end
    else begin
      cb8.Text := InvalidScene;
      cb9.Text := InvalidTarge;
    end;

    se18.Value := getAttribute(locationXAttr);
    se19.Value := getAttribute(locationYAttr);
    edt6.tag := getAttribute(actionDescAttr);
    edt6.Text :=  LanguagePackage.GetLangText(RoleLangCategoryId,edt6.tag)
  end;
end;

procedure TfrmRoleItemAndAward.MenuItem6Click(Sender: TObject);
var
  Node   : IXMLDOMNode;
  i :integer;
begin
  Node := LocationPasses as IXMLDOMNode;
  for I := lvpass.Items.Count - 1 downto 0 do
  if lvpass.Items[I].Selected then
  begin
      Node.removeChild(Node.childNodes[lvpass.Selected.index]);
      lvpass.Items[I].Delete;
  end;
end;


procedure TfrmRoleItemAndAward.pmpassPopup(Sender: TObject);
begin
  if (cb6.ItemIndex < 0) or (cb7.ItemIndex <0) then
  begin
    ShowMessage( '请选择 地图 和 对象名 后再试');
    MenuItem5.Enabled := False;
    MenuItem6.Enabled := False;
    MenuItem10.Enabled := False;
  end else
  begin
    MenuItem10.Enabled := True;
    MenuItem5.Enabled := lvpass.Selected <> nil;
    MenuItem6.Enabled := lvpass.SelCount > 0;
  end;
end;

end.
