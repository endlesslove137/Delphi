unit UnitRoleRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmRoleRelation = class(TForm)
    TreeView1: TTreeView;
    Button1: TButton;
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
    function IsDeepChildNode(ParentNode, ChildNode: TTreeNode): Boolean;
  public
    { Public declarations }
  end;



implementation

uses UnitMain, msxml;

{$R *.dfm}

function TfrmRoleRelation.IsDeepChildNode(ParentNode, ChildNode: TTreeNode): Boolean;
begin
  Result := False;
  while ChildNode.Parent <> nil do
  begin
    if ChildNode.Parent = ParentNode then
    begin
      Result := True;
      break;
    end;
    ChildNode := ChildNode.Parent;
  end;
end;

procedure TfrmRoleRelation.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SrcNode, TargetNode: TTreeNode;
  SrcRole, TargetRole: IXMLDOMNode;
begin
  SrcNode := TreeView1.Selected;
  TargetNode := TreeView1.GetNodeAt( X, Y );

  if (TargetNode = nil) or (SrcNode = TargetNode) or (SrcNode.Parent = TargetNode) then Exit;

  if Application.MessageBox( '你确实要改变此任务（包括其子任务）的继承关系吗？', '提示', MB_YESNOCANCEL or MB_ICONQUESTION ) <> ID_YES then Exit;

  SrcRole := frmMain.GetRoleNodeById( Integer(SrcNode.Data) );
  TargetRole := frmMain.GetRoleNodeById( Integer(TargetNode.Data) );
  if TargetRole <> nil then
  begin
    with SrcRole as IXMLDOMElement do
    begin
      setAttribute( RoleInheritedAtbName, Integer(TargetNode.Data) );
    end;
     
    SrcNode.MoveTo( TargetNode, naAddChild ); 
    frmMain.SaveRoleFile();
  end;
end;

procedure TfrmRoleRelation.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  SrcNode, TargetNode: TTreeNode;
begin
  SrcNode := TreeView1.Selected;
  TargetNode := TreeView1.GetNodeAt( X, Y );

  if (TargetNode = nil) or (SrcNode = TargetNode) then
  begin
    Accept := False;
    Exit;
  end;

  if IsDeepChildNode( SrcNode, TargetNode ) then
  begin
    Accept := False;
    Exit;
  end;
end;

procedure TfrmRoleRelation.TreeView1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  S: string;
  I: Integer;
begin
  if (Key = Ord('f') - 32) and (Shift = [ssCtrl]) then
  begin
    if InputQuery( '查找任务id', '任务id    ', S ) then
    begin
      S := '(' + S + ')';
      for I := 0 to TreeView1.Items.Count - 1 do
      begin
        if Pos( S, TreeView1.Items[I].Text ) > 0 then
        begin
          TreeView1.Selected := TreeView1.Items[I];
          Exit;
        end;       
      end;
      ShowMessage( '没有找到任务。' );
    end;
  end;
end;

end.
