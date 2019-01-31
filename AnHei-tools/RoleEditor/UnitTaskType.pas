unit UnitTaskType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmTaskType = class(TForm)
    Edit1: TEdit;
    ListBox1: TListBox;
    Button1: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTaskType: TfrmTaskType;

implementation

uses UnitMain, UnitLangPackage;

{$R *.dfm}

procedure TfrmTaskType.btnAddClick(Sender: TObject);
var
  nID: Integer;
begin
  if (self.Edit1.Text <> '') and (self.ListBox1.Items.IndexOf(self.Edit1.Text) = -1) then
  begin
    nID := LanguagePackage.AddLangText(RoleLangCategoryId,Edit1.Text);
    self.ListBox1.Items.AddObject(Edit1.Text,TObject(nID));
  end;
end;

procedure TfrmTaskType.btnEditClick(Sender: TObject);
var
  nID: Integer;
begin
  if self.ListBox1.ItemIndex <> -1 then
  begin
    nID := Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    LanguagePackage.ReplaceLangText(RoleLangCategoryId,nID,Edit1.Text);
    ListBox1.Items.Strings[ListBox1.ItemIndex] := self.Edit1.Text;
  end;
end;

procedure TfrmTaskType.ListBox1Click(Sender: TObject);
begin
  if self.ListBox1.ItemIndex <> -1 then
  begin
    self.Edit1.Text := self.ListBox1.Items.Strings[self.ListBox1.ItemIndex];
  end;
end;

end.
