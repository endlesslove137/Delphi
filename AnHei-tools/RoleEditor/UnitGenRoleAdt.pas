unit UnitGenRoleAdt;

interface

uses
  SysUtils, Windows, Classes, UnitMain, msxml, AdtTypes, Dialogs;

type

  PTADTRoleClass=^TADTRoleClass;

  PTADTRoleNPC=^TADTRoleNPC;
  TADTRoleNPC = record
    MapID   : Integer;
    MapName : TADTNamePtr;
    Name    : TADTNamePtr;
    X       : SmallInt;
    Y       : SmallInt;
  end;

  TADTRoleNeedLocation = packed record
    MapName : TADTNamePtr;  
    TargetName : TADTNamePtr;
    wMapX : Word;
    wMapY : Word;
  end;
  
  PTADTRoleNeedInfo=^TADTRoleNeedInfo;
  TADTRoleNeedInfo = record
    btExecuteMode   :TRoleExecuteMode;
    btQuality       :Byte;
    btStrongLevel   :Byte;
    btRcv1          :Byte;
    wExecId         :Word;
    wNeedCount      :TRoleNeedCount;
    Location        :TADTRoleNeedLocation;
    case Integer of
      0: (ExecMonster: TADTNamePtr;); //kill mon role item only.
      1: (Customize: TADTNamePtr;); //customize role item only.
  end;

  PTADTRoleAwardInfo=^TADTRoleAwardInfo;
  TADTRoleAwardInfo = record
    btAwardMode   : TRoleAwardMode;
    btQuality     : Byte;
    btStrongLevel : Byte;
    btTime        : Byte;
    wAWardItemId  : Word;
    wRcv1         : Word;
    dwAwardCount  : DWord;
    pWardItems    : PTAwardSelectItem; //仅用于“选择奖励”以及“随机奖励”
  end;

  PTADTRole=^TADTRole;
  TADTRole = record
    nRoleId : Integer;
    btLevel : Byte;         //任务难度
    btMaxTime: Byte;  //重复次数
    wLvlMin: Word;
    wLvlMax: Word;
    btType : Byte;
    btIntervalType: TRoleIntervalType;
    RoleInterval: TRoleDateTime;
    Name    : TADTNamePtr;
    Desc    : TADTNamePtr;
    PromNPC : TADTRoleNPC;
    CompNPC : TADTRoleNPC;
    dwNeedCount : DWord;
    NeedItems   : PTADTRoleNeedInfo;
    dwAwardCount: DWord;
    AWards      : PTADTRoleAwardInfo;
    pClass : PTADTRoleClass;
    nTimeLimit: Integer;
    btTransmit: Byte;
    btRcv1  : array [1..3] of Byte;
  end;

  TADTRoleClass = record
    Name          : TADTNamePtr;
    ParentClass   : PTADTRoleClass;
    dwChildCount  : DWord;
    pChildClasses : PTADTRoleClass;
    dwRoleCount   : DWord;
    pRoles        : PTADTRole;
  end;


implementation

uses LuaDB, XML2Cbp, UnitLangPackage;

const

  //发布CBP的XML节点属性数据类型对照表
  //（不用发布的清不要包含，防止出现冗余数据增加Loading时间）
  RoleXMLNodePathDataTypes : array [0..45] of TXBPNodeDesc =
  (
    (NodePath: 'Roles.Role'; DataType: lfTable; NameType: pntIndex),
    (NodePath: 'Roles.Role.Id'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Name'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.Type'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.RoleKind'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.NeedLevel'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.MaxLevel'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.MaxTime'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Level'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.IntervalType'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Interval'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Desc'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.AcceptStoryText'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.FinishStoryText'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.TimeValue'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.AutoTransmit'; DataType: lfBool; NameType: pntSource),
    //    通过车夫寻路 默认值为true
    (NodePath: 'Roles.Role.FindByDriver'; DataType: lfBool; NameType: pntSource),
    (NodePath: 'Roles.Role.PromulgationMap'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Promulgation'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.AcceptMap'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Accept'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.OwnCountry'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.PutWorld'; DataType: lfBool; NameType: pntSource),
    (NodePath: 'Roles.Role.Items'; DataType: lfTable; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item'; DataType: lfTable; NameType: pntIndex),
    (NodePath: 'Roles.Role.Items.Item.Mode'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.ExecId'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.Count'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.Quality'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.Strong'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.CustomData'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.iLocation'; DataType: lfString; NameType: pntSource),
    (NodePath: 'Roles.Role.Items.Item.Job'; DataType: lfNumber; NameType: pntSource),

    (NodePath: 'Roles.Role.Awards'; DataType: lfTable; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award'; DataType: lfTable; NameType: pntIndex),
    (NodePath: 'Roles.Role.Awards.Award.Mode'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award.AWardId'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award.Count'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award.Quality'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award.Strong'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.Awards.Award.Hole1'; DataType: lfNumber; NameType: pntSource),
    //快速完成
    (NodePath: 'Roles.Role.QuickCompNeeds'; DataType: lfTable; NameType: pntSource),
    (NodePath: 'Roles.Role.QuickCompNeeds.QuickCompNeed'; DataType: lfTable; NameType: pntIndex),
    (NodePath: 'Roles.Role.QuickCompNeeds.QuickCompNeed.Mode'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.QuickCompNeeds.QuickCompNeed.ItemId'; DataType: lfNumber; NameType: pntSource),
    (NodePath: 'Roles.Role.QuickCompNeeds.QuickCompNeed.Count'; DataType: lfNumber; NameType: pntSource)
  );

procedure FillAttrsText(RootNode: IXMLDOMNode; NodePath: WideString; AttrName: WideString);
var
  I: Integer;
  Nodes: IXMLDOMNodeList;
  Element: IXMLDOMElement;
begin
  Nodes := RootNode.selectNodes(NodePath);
  for I := 0 to Nodes.length - 1 do
  begin
    Element := Nodes.item[I] as IXMLDOMElement;
    Element.setAttribute(AttrName, LanguagePackage.GetLangText(RoleLangCategoryId, Element.getAttribute(AttrName)));
  end;
end;  

procedure FillNodesText(RootNode: IXMLDOMNode; NodePath: WideString);
var
  I: Integer;
  Nodes: IXMLDOMNodeList;
  Node: IXMLDOMNode;
begin
  Nodes := RootNode.selectNodes(NodePath);
  for I := 0 to Nodes.length - 1 do
  begin
    Node := Nodes.item[I];
    Node.text :=LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(Node.text));
  end;
end;

function CloneAndAjustNodes(RootNode: IXMLDOMNode): IXMLDOMNode;
var
  Nodes: IXMLDOMNodeList;
  I,nVal: Integer;
  RoleNode: IXMLDOMElement;

begin
  Nodes := RootNode.selectNodes('//' + RoleSecName);
  Result := RootNode.Get_ownerDocument().createElement(RoleMainSecName);
  for I := 0 to Nodes.Length - 1 do
  begin
    RoleNode := Result.appendChild(Nodes.item[I].cloneNode(True)) as IXMLDOMElement;
    //调整各节点文本
    RoleNode.setAttribute(RoleNameAtbName, LanguagePackage.GetLangText(RoleLangCategoryId, RoleNode.getAttribute(RoleNameAtbName)));
    RoleNode.setAttribute(RolePromulgationNPC, GetPCNPCName(RoleNode, RolePromulgationNPC));
    RoleNode.setAttribute(RoleAcceptNPC, GetPCNPCName(RoleNode, RoleAcceptNPC));
    RoleNode.setAttribute(RoleKindAttrName, RoleNode.getAttribute(RoleKindAttrName));
    FillNodesText(RoleNode, RoleDescSecName);
    FillNodesText(RoleNode, RoleAcceptStorySecName);
    FillNodesText(RoleNode, RoleFinishStorySecName);
  end;
  Nodes := Result.selectNodes('//'+RoleItemSecName);
  for I := 0 to Nodes.Length - 1 do
  begin
    with (Nodes[I] as IXMLDOMElement) do
    begin
//      setAttribute(ItemNeedLocationAtbName,GetStrLocations(TRoleExecuteMode(getAttribute(ItemExecModeAtbName)),getAttribute(ItemNeedLocationAtbName)));
//      nVal := getAttribute(AwardModeAtbName);
//      case TRoleExecuteMode(nVal) of
//        reKillMon, reTameMon:
//        begin
//          setAttribute(ItemCustomDataAtbName,frmMain.GetMonsterNameEx(getAttribute(ItemExecIdAtbName)));
//        end;
//        reCustom:
//        begin
//          if getAttribute(ItemCustomDataAtbName) <> '' then
//          begin
//            setAttribute(ItemCustomDataAtbName,GetAttrLangText(Nodes[I] as IXMLDOMElement,ItemCustomDataAtbName));
//          end;
//        end;
//      end;
    end;
  end;
end;

end.
