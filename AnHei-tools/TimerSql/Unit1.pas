unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.FMTBcd, Vcl.Buttons, Data.DB,
  Data.SqlExpr, Data.DBXMySQL, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin, commctrl, msxml, Vcl.ImgList, UnitStdXmlForm,
  System.Actions, Vcl.ActnList, Vcl.Menus, System.IniFiles, richedit;

const
  //战千雄数据库密码
  CUM_USERNAME	     =	'gamestatic'; //用户名称
  CUM_PASSWORD      =	'xianhaiwangluo'; //密码
  CSS_DataBase      =  '5eglobal';//会话数据库
  colorGeneral   = clWhite;   // 普通信息 白色
  colorSuccess   = clGreen;   // 成功信息 绿色
  colorWarning   = clYellow;  // 警告信息 黄色
  colorerror     = clRed;     // 错误信息 红色加粗
  msgStart = '--------------%s 执行日志--------------';
  msgSuccess = '[%s][%s] 执行语句成功';
  msgerror = '[%s][%s] 执行语句失败 错误信息为：%s';
  msgCError = '[%s连接失败 错误信息为:%s]';
  msgCSucc = '[%s连接成功 错误信息为:%s]';
  msgCaption = '正在[%s]执行sql';
  xmlFileName = 'ServerList.xml';
  sConfigName = '.\TimerSql.ini';
  MesssageCaption = '仙海网络 温馨提醒';
  Parent_imageIndex = 8;
  Server_ImageIndex =9;
  Class_ImageIndex = 10;

 ClasssAttr = 'Class';
   ClassIDAttr = 'Id';
   ClassNameAttr = 'Name';

 ServerAttr = 'Server';
  ServerIdAttr = 'Id';
  ServerNameAttr = 'Name';
  ServerIPAttr = 'Ip';
  ServerDBAttr = 'DB';
  ServerPortAttr = 'Port';
//  ServerUserNameAttr = 'UserName';
//  ServerPasswordAttr = 'Password';
//  ServerPassive = 'Passive';
//  ServerNoteAttr = 'Note';


type
  TForm1 = class(TStdXmlForm )
    con1: TSQLConnection;
    sqlqry1: TSQLQuery;
    btn1: TSpeedButton;
    pnlpncommen: TPanel;
    pnlMain: TPanel;
    pnlEdit: TPanel;
    lbledt1: TLabeledEdit;
    pnl1: TPanel;
    se1: TSpinEdit;
    Label1: TLabel;
    btn2: TSpeedButton;
    lbledt2: TLabeledEdit;
    btn3: TSpeedButton;
    btnsave: TSpeedButton;
    il1: TImageList;
    tv1: TTreeView;
    pm1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    actDelnode1: TMenuItem;
    actlst1: TActionList;
    actNewFtp: TAction;
    actload: TAction;
    actsave: TAction;
    actSelectAll: TAction;
    actNoSelect: TAction;
    actGetChecked: TAction;
    actNewCLass: TAction;
    actDelnode: TAction;
    actConfig: TAction;
    redt1: TRichEdit;
    tmr1: TTimer;
    mmo1: TMemo;
    spl2: TSplitter;
    btn4: TSpeedButton;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function  ReadXMLData():Boolean;override;
    procedure ReadNode(Element: IXMLDOMElement; TreeNode: TTreeNode);
    procedure actNewCLassExecute(Sender: TObject);
    procedure actsaveExecute(Sender: TObject);
    procedure actNewFtpExecute(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btnsaveClick(Sender: TObject);
    procedure actDelnode1Click(Sender: TObject);
    procedure tv1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure tv1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tv1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbledt1Change(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure tv1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmr1Timer(Sender: TObject);
    procedure btn4Click(Sender: TObject);
      private
    FBaseTreeNode: TTreeNode;
    CurrentElement: IXMLDOMElement; //当前在编辑的节点
    UM_USERNAME, UM_PASSWORD, SS_DBDataBase:string;

    function GetDOMNode(TreeNode: TTreeNode): IXMLDOMNode;
    procedure SelectNode(ANode: TTreeNode);
    function GetDOMElementByObjectID(const nID: Integer): IXMLDOMElement;
    procedure SaveNoad(ANode: TTreeNode);
    procedure LoadConfig;
    function ConnectionMysql(var TargetSC:TSQLConnection; sHostName, sdb: string):boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// 设置TTreeView复选模式
procedure setCheckStyle(tv1:TTreeView);
var
  H: HWND;
begin
    tv1.Items[0].Expanded := True;
    H := tv1.Handle;
    SetWindowLong(H, GWL_STYLE, GetWindowLong(H, GWL_STYLE) or TVS_CHECKBOXES);
end;



function TForm1.ReadXMLData: Boolean;
var
  I,nId: Integer;
  H: HWND;
  Nodes: IXMLDOMNodeList;
  Element: IXMLDOMElement;
begin
  Result := Inherited ReadXMLData;
//  Templist.Clear;
  ReadNode(FBaseNode as IXMLDOMElement,tv1.Items[0]);
  setCheckStyle(tv1);
end;



//获取节点是否选中
function GetChecked(mTreeNode: TTreeNode): Boolean;
var
  vTVItem: TTVItem;
begin
  Result := false;
  if not Assigned(mTreeNode) or not Assigned(mTreeNode.TreeView)  then
    Exit;
  vTVItem.mask := TVIF_STATE;
  vTVItem.hItem := mTreeNode.ItemId;
  if TreeView_GetItem(mTreeNode.TreeView.Handle, vTVItem) then
    Result := (vTVItem.State and IndexToStateImageMask(2)) > 0;
  // 0:  None  1:  False  2:  True
end;

// 全选 tv1上的所有节点  Bcheck= true 为选中，否则 去掉勾选
procedure setTVSelected(tv1: TTreeView; Bcheck: Boolean);
var
  Node: TTreeNode;
  TVI: TTVItem;
begin
  for Node in tv1.Items do
  begin
    TVI.mask := TVIF_STATE;
    TVI.hItem := Node.ItemId;
    TVI.stateMask := TVIS_STATEIMAGEMASK;
    if Bcheck then TVI.state := $2000 else TVI.state := $2000 shr 1;
    TreeView_SetItem(tv1.Handle, TVI);
  end;
end;

// 全选 TTreeNode上所有的子结点  Bcheck= true 为选中，否则 去掉勾选
procedure setTNSelected(tv1: TTreeNode; Bcheck: Boolean);
var
  Node: TTreeNode;
  TVI: TTVItem;
  tempNode, parNode : TTreeNode;
begin
 if tv1.HasChildren then
 begin
  tempNode := tv1.getFirstChild;
  while tempNode <> nil  do
  begin
    TVI.mask := TVIF_STATE;
    TVI.hItem := tempNode.ItemId;
    TVI.stateMask := TVIS_STATEIMAGEMASK;
    if Bcheck then TVI.state := $2000 else TVI.state := $2000 shr 1;
    TreeView_SetItem(tv1.Handle, TVI);
    tempNode:= tempNode.getNextSibling;
  end;
 end;
end;

procedure   SetRDColorByAddText(RichEdit:TRichEdit;TargetStr:string);
begin
  if trim(RichEdit.Text)=''  then
  begin
   RichEdit.Lines.Add(format(msgStart,[DateTimeToStr(now)]));
  end;
  richedit.Lines.Add(TargetStr);

  RichEdit.SelStart   :=   RichEdit.SelStart - length(TargetStr) -1;   //寻找选择区域的起点位置
  RichEdit.SelLength   :=  length(TargetStr);   //获得选择当前行的长度

  if Pos('成功',TargetStr)>0 then
   RichEdit.SelAttributes.Color   :=   colorSuccess//设置字体颜色
  else if Pos('失败',TargetStr)>0 then
  begin
   RichEdit.SelAttributes.Color   :=   colorerror;//设置字体颜色
   RichEdit.SelAttributes.Style := [fsBold];
  end
  else
   RichEdit.SelAttributes.Color   :=   colorWarning;//设置字体颜色
  SendMessage(RichEdit.Handle,WM_VSCROLL,SB_PAGEDOWN,0);
  RichEdit.SelLength   :=   0;
end;



procedure TForm1.tmr1Timer(Sender: TObject);
var
 i:integer;
 Node:TTreeNode;
 Stime, Sserver,sDB: string;
begin
 btn2.Enabled := False;
 for Node in tv1.Items do
 begin
  Application.ProcessMessages;
  IF  Node.ImageIndex <> server_ImageIndex then CONTINUE;
  if GetChecked(Node) then
  begin
    try
      CurrentElement := GetDOMElementByObjectID(Integer(Node.Data));
      sDB := CurrentElement.getAttribute(ServerDBAttr);

      ConnectionMysql(con1,CurrentElement.getAttribute(ServerIPAttr), sDB);

     Stime := FormatDateTime('yyyy-mm-dd hh:MM:ss:ZZZ', now);
     Sserver := CurrentElement.getAttribute(ServerNameAttr);
     Caption := Format(msgCaption, [Sserver]);
     sqlqry1.Close;
     sqlqry1.SQL.Assign(mmo1.Lines);
     sqlqry1.ExecSQL(True);
     SetRDColorByAddText(redt1,Format(msgSuccess,[Stime, Sserver]));
    except
    on e:Exception do
    begin
      SetRDColorByAddText(redt1,Format(msgerror,[Stime, Sserver, e.Message]));
    end;
    end;
  end;
 end;
end;

procedure TForm1.tv1Change(Sender: TObject; Node: TTreeNode);
begin
//  ShowMessage('onChange');
  if Node.IsFirstNode then Exit;
   SelectNode(tv1.Selected);
end;

procedure TForm1.tv1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
 if btnsave.Enabled  then btnsave.Click;

end;


procedure TForm1.tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TargetTreeNode: TTreeNode;
  SourceDOMNode, TargetDOMNode: IXMLDOMNode;
  NewNodeList : IXMLDOMNodeList;
  I: Integer;
  boCopy: Boolean;
  SelectTreeList: TStrings;
begin
  TargetTreeNode := tv1.GetNodeAt( X, Y );
  if TargetTreeNode = nil then
    Exit;
  TargetDOMNode := GetDOMNode( TargetTreeNode );
  if TargetDOMNode <> nil then
  begin
    if Source = tv1 then
    begin
      SourceDOMNode := GetDOMNode( tv1.Selected );
      if SourceDOMNode = nil then
        Exit;
        SelectTreeList := TStringList.Create;
        for I:=0 to tv1.SelectionCount-1 do
        begin
          SelectTreeList.AddObject('',tv1.Selections[I]);
        end;
        for I:=0 to SelectTreeList.Count-1 do
        begin
          SourceDOMNode := GetDOMNode( TTreeNode(SelectTreeList.Objects[I]) );
          SourceDOMNode.parentNode.removeChild( SourceDOMNode );
          TargetDOMNode.appendChild( SourceDOMNode );
          TTreeNode(SelectTreeList.Objects[I]).MoveTo( TargetTreeNode, naAddChild );
        end;
        SelectTreeList.Free;
        actsaveExecute(nil);
    end
  end;
end;

procedure TForm1.tv1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  TargetTreeNode: TTreeNode;
  SourceLevel, TargetLevel: Integer;
  I : INTEGER;
begin
  Accept := False;
  TargetTreeNode := tv1.GetNodeAt( X, Y );
  if (TargetTreeNode = nil) or (TargetTreeNode = tv1.Selected)
  or (TargetTreeNode = tv1.Selected.Parent) then
  begin
    Exit;
  end;

  Accept := True;
  for I := 0 to tv1.SelectionCount - 1 do
  begin
   IF tv1.Selections[I].HasChildren THEN
   begin
    Accept := False;
    Break;
   end;
  end;
end;

function TForm1.GetDOMElementByObjectID(const nID: Integer): IXMLDOMElement;
ResourceString
  sQueryStr = '//*[@'+ServerIdAttr+'=%d]';
begin
  if nID = 0 then
    Result := FBaseNode as IXMLDOMElement
  else
    Result := FBaseNode.selectSingleNode( Format(sQueryStr, [nID]) ) as IXMLDOMElement;

end;

procedure TForm1.SelectNode(ANode: TTreeNode);
begin
  if ANode.ImageIndex <> Server_ImageIndex then
  begin
//   setEnabled(False);
   Exit;
  end;

//   setEnabled(True);
  if ANode <> nil then
  begin
   try
    CurrentElement := GetDOMElementByObjectID(Integer(ANode.Data))
   except
    Exit;
   end;
  end
  else
  begin
     CurrentElement := nil;
     exit;
  end;
  lbledt1.Text := CurrentElement.getAttribute(ServerNameAttr);
  lbledt2.Text := CurrentElement.getAttribute(ServerIPAttr);
  btnsave.Enabled := False;
end;


procedure TForm1.tv1Edited(Sender: TObject; Node: TTreeNode; var S: string);
var
  Element: IXMLDOMElement;
begin
  S := Trim( S );
  if S <> Node.Text then
  begin
    Element := GetDOMNode( Node ) as IXMLDOMElement;
    Element.setAttribute(ClassNameAttr, s);
  end;
  actsaveExecute(nil);
end;


// 单击选中一个节点 全选/取消 它的子节点
procedure TForm1.tv1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
  TVI: TTVItem;
  p : TPoint;
begin
  Node := tv1.GetNodeAt(x, Y);
  if Node <> nil then
  begin
    if Node.IsFirstNode then
      if GetChecked(Node) then
        setTVSelected(tv1, True)
      else
        setTVSelected(tv1, False)
    else  if Node.HasChildren then
      if GetChecked(Node) then
        setTNSelected(Node, True)
      else
        setTNSelected(Node, False);
     if not Node.IsFirstNode then   SelectNode(tv1.Selected);

  end;
end;


procedure TForm1.ReadNode(Element: IXMLDOMElement; TreeNode: TTreeNode);
var
  NodeList: IXMLDOMNodeList;
  I, nId: Integer;
  ChildElement: IXMLDOMElement;
  NewTreeNode: TTreeNode;
begin
  TreeNode.DeleteChildren;
  NodeList := Element.selectNodes( ClasssAttr );
  for I := 0 to NodeList.length - 1 do
  begin
    ChildElement := NodeList.item[I] as IXMLDOMElement;
    NewTreeNode := tv1.Items.AddChild( TreeNode, ChildElement.getAttribute( ClassNameAttr ));
    nId := ChildElement.getAttribute( ClassIDAttr );
    NewTreeNode.Data := Pointer(nId);
    NewTreeNode.ImageIndex := CLASS_IMAGEINDEX;
    NewTreeNode.SelectedIndex := CLASS_IMAGEINDEX;
    ReadNode( ChildElement, NewTreeNode );
  end;

  NodeList := Element.selectNodes( ServerAttr );
  for I := 0 to NodeList.length - 1 do
  begin
    ChildElement := NodeList.item[I] as IXMLDOMElement;
    nId  := ChildElement.getAttribute( ServerIdAttr );
    NewTreeNode := tv1.Items.AddChild( TreeNode, ChildElement.getAttribute( ServerNameAttr ));
    nId := ChildElement.getAttribute( ServerIdAttr );
    NewTreeNode.Data := Pointer(nId);
    NewTreeNode.ImageIndex := Server_ImageIndex;
    NewTreeNode.SelectedIndex := Server_ImageIndex;
  end;


end;




procedure TForm1.LoadConfig;
var
  Section: string;
  Ident: string;
  x : TIniFile;
begin
  with TIniFile.Create(sConfigName) do
  begin
    Section := '默认设置';
    Ident := '用户名';
    if not ValueExists(Section,Ident) then  WriteString(Section,Ident,CUM_USERNAME);
    UM_USERNAME := ReadString(Section,Ident,CUM_USERNAME);

    Ident := '密码';
    if not ValueExists(Section,Ident) then  WriteString(Section,Ident,CUM_PASSWORD);
    UM_PASSWORD := ReadString(Section,Ident,CUM_PASSWORD);

    Ident := '数据库';
    if not ValueExists(Section,Ident) then  WriteString(Section,Ident,CSS_DataBase);
    SS_DBDataBase := ReadString(Section,Ident,CSS_DataBase);

    Free;
  end;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin
 LoadConfig;
 setCheckStyle(tv1);
 if not FileExists(xmlFileName) then
  CreateNewFile(xmlFileName)
 else
  Open(xmlFileName);
 FBaseTreeNode := tv1.Items[0];
  tmr1.Enabled := False;

end;






function TForm1.ConnectionMysql(var TargetSC:TSQLConnection; sHostName, sdb: string):boolean;
begin
  try
    TargetSC.Connected := False;
    targetsc.DriverName := 'MySQL';
    targetsc.GetDriverFunc := 'getSQLDriverMYSQL';
    TargetSC.LibraryName := 'dbxmys.dll';
    targetsc.VendorLib := 'LIBMYSQL.dll';
    TargetSC.Params.Clear;
    TargetSC.Params.Append('HostName='+sHostName);
//    TargetSC.Params.Append('Database=' + SS_DBDataBase);
    TargetSC.Params.Append('Database=' + sdb);
    TargetSC.Params.Append('User_Name=' + UM_USERNAME);
    TargetSC.Params.Append('Password=' + UM_PASSWORD);
    TargetSC.Params.Append('ServerCharset=utf-8');
    TargetSC.Connected := True;
//    redt1.Lines.Add(msgConnect)
    TargetSC.KeepConnection := true;
    result := true;
  except
   on e:exception do
   begin
    showmessage(e.Message);
    result := false;
   end;
  end;
end;

procedure TForm1.actDelnode1Click(Sender: TObject);
var
  Node: IXMLDOMNode;
begin
  if tv1.Selected.ImageIndex = Parent_imageIndex  then exit;
  if (tv1.Selected <> nil) then
  if Application.MessageBox( '确实要删除选顶的项目吗?', MesssageCaption, MB_YESNOCANCEL or MB_ICONQUESTION or MB_TASKMODAL) = ID_YES then
  begin
    Node := GetDOMNode( tv1.Selected );
    if Node <> nil then
    begin
      Node.parentNode.removeChild( Node );
      tv1.Selected.Delete();
      actsaveExecute(nil);
    end;
  end;
end;

procedure TForm1.actNewCLassExecute(Sender: TObject);
const
  sDefServerName = '新建分类';
var
  Element: IXMLDOMElement;
  TreeNode: TTreeNode;
  nId: Integer;
begin
  nId := AllocAutoIncrementId();
  Element := FXML.createElement(ClasssAttr);
  //设置默认值
  Element.setAttribute(ClassIDAttr, nId);
  Element.setAttribute(ClassNameAttr, sDefServerName);
  (FBaseNode as IXMLDOMElement).appendChild(Element);

  TreeNode := FBaseTreeNode;
  TreeNode := tv1.Items.AddChild(TreeNode, sDefServerName);
  TreeNode.Data := Pointer(nId);
  TreeNode.ImageIndex := Class_ImageIndex;
  TreeNode.SelectedIndex := Class_ImageIndex;
  tv1.Selected := TreeNode;
  actsaveExecute(nil);
end;


function TForm1.GetDOMNode(TreeNode: TTreeNode): IXMLDOMNode;
var
  sQueryStr: string;
  nId: Integer;
begin
  Result := nil;

  if TreeNode<>nil then
  begin
     sQueryStr := '';
    while TreeNode <> nil do
    begin
        nId := Integer(TreeNode.Data);
        case TreeNode.ImageIndex of
          Server_ImageIndex:begin       //用来区分级别的  xml的结构 见上....
            sQueryStr := ServerAttr
              + '[@' + ServerIdAttr + '=''' + IntToStr(nId) + ''']'
              + '/' + sQueryStr;
          end;
          Class_ImageIndex:
          begin
            sQueryStr := ClasssAttr
              + '[@' + ClassIDAttr + '=''' + IntToStr(nId) + ''']'
              + '/' + sQueryStr;
          end;
          else break;
        end;
        TreeNode := TreeNode.Parent;
    end;
  end;

  Result := FBaseNode;
  if (Result <> nil) and (sQueryStr <> '') then
  begin
    Delete( sQueryStr, Length(sQueryStr), 1 );
    Result := Result.selectSingleNode( sQueryStr );
  end;
end;

procedure TForm1.lbledt1Change(Sender: TObject);
begin
 if CurrentElement <> nil then
  btnsave.Enabled := True;
end;

procedure TForm1.actNewFtpExecute(Sender: TObject);
const
  sDefServerName = '新建服务器';
var
  Element: IXMLDOMElement;
  DOMNode: IXMLDOMNode;
  TreeNode: TTreeNode;
  nId: Integer;
begin
  // 在选择了分类 的时候才允许新建服务器
  if tv1.Selected.ImageIndex <> Class_ImageIndex then   Exit;
    DOMNode := GetDOMNode( tv1.Selected );
  if DOMNode = nil then Exit;



  nId := AllocAutoIncrementId();
  Element := FXML.createElement(ServerAttr);
  //设置默认值
  Element.setAttribute(ServerIdAttr, nId);
  Element.setAttribute(ServerNameAttr, lbledt1.Text);
  Element.setAttribute(ServerIPAttr, lbledt2.Text);
  Element.setAttribute(ServerDBAttr, SS_DBDataBase);


  DOMNode.appendChild(Element);

  TreeNode := tv1.Selected;

  TreeNode := tv1.Items.AddChild(TreeNode, lbledt1.Text);
  TreeNode.Data := Pointer(nId);
  TreeNode.ImageIndex := Server_ImageIndex;
  TreeNode.SelectedIndex := Server_ImageIndex;
  tv1.Selected := TreeNode;
  TreeNode.Parent.Expanded := true;
  actsaveExecute(nil);
end;


procedure TForm1.actsaveExecute(Sender: TObject);
begin
  inherited SaveDocument;
    btnsave.Enabled := False;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
 ConnectionMysql(con1,'192.168.0.203',SS_DBDataBase);
 if con1.Connected = true then  ShowMessage('good');



end;



procedure TForm1.btn2Click(Sender: TObject);

begin
 btn2.Enabled := false;
 tmr1.Enabled := False;
 tmr1.Interval := se1.Value * 60 * 1000;
 tmr1.Enabled := True;

end;

procedure TForm1.btn3Click(Sender: TObject);
begin
 actNewFtpExecute(nil);
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
 tmr1.Enabled := False;
 btn2.Enabled := True;
end;

procedure TForm1.SaveNoad(ANode: TTreeNode);
begin

  if Assigned(ANode) then
  begin
    if ANode.ImageIndex <> Server_ImageIndex then Exit;
    CurrentElement.setAttribute(ServerNameAttr, lbledt1.Text);
    CurrentElement.setAttribute(ServerIPAttr, lbledt2.Text);

    ANode.Text := lbledt1.Text;
  end;
end;


procedure TForm1.btnsaveClick(Sender: TObject);
begin
  SaveNoad(tv1.Selected);
  actsaveExecute(nil);
end;

initialization
 begin
//   UM_USERNAME := CUM_USERNAME;
//   SS_DBDataBase := CSS_DBDataBase;
//   UM_PASSWORD := CUM_PASSWORD;

 end;

end.
