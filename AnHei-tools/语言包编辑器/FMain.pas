unit FMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ExtCtrls, Menus, StdCtrls, RzButton, clipbrd;

const
 LangResult = 'LangToStr(%s); //%s';
 CnLangFile = 'D:\mine\百度网盘\我的文档\work\program\521g\idgp\AnHei\!SC\tools\IWStat\Lang\Chinese.xml';

type
  TForm1 = class(TForm)
    grp1: TGroupBox;
    pnl1: TPanel;
    ListViewSetDesc: TRzListView;
    OpenDialog: TOpenDialog;
    ButtonFilterDel: TRzButton;
    ButtonFilterAdd: TRzButton;
    ButtonFilterChg: TRzButton;
    Edit2: TEdit;
    Edit1: TEdit;
    lbl2: TLabel;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    procedure pnl1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewSetDescClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonFilterChgClick(Sender: TObject);
    procedure ButtonFilterAddClick(Sender: TObject);
    procedure ButtonFilterDelClick(Sender: TObject);
  private
    { Private declarations }
     sFileName :string;
     procedure RefListViewBindItem;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses IWLang;

{$R *.dfm}

procedure TForm1.ButtonFilterAddClick(Sender: TObject);
var
  pli: PTLangInfo;
  sTemp: string;
begin
  if Edit2.Text = '' then begin
    Application.MessageBox('请输入标题信息！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  New(pli);
  pli.idx := Alang.ilist.Count + 1;
  pli.CaptionName := Edit2.Text;

  if not Alang.AddXml(pli, sFileName) then
  begin
    sTemp := inttostr(Alang.FindEx(Edit2.Text));
    Application.MessageBox(PChar('当前信息已存在，编号：'+ sTemp), '提示信息', MB_ICONQUESTION);
    clipboard().AsText := Format(LangResult, [sTemp, Edit2.Text]);
  end else
  begin
   Edit1.Text := inttostr(pli.idx);
   clipboard().AsText := Format(LangResult, [Edit1.Text, Edit2.Text]);
  end;
  lbl4.Caption := inttostr(Alang.ilist.Count);

  RefListViewbindItem;
end;

procedure TForm1.ButtonFilterChgClick(Sender: TObject);
var
  nlist: TListItem;
  pli: PTLangInfo;
begin
  if Edit1.Text = '' then begin
    Application.MessageBox('请输入编号！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  if Edit2.Text = '' then begin
    Application.MessageBox('请输入标题信息！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  nlist := ListViewSetDesc.Selected;
  if nlist = nil then Exit;
  pli := PTLangInfo(nlist.SubItems.Objects[0]);
  if pli = nil then Exit;
  pli.idx := StrToInt(Edit1.Text);
  pli.CaptionName := Edit2.Text;
  Alang.ChgXml(pli, sFileName);
  RefListViewbindItem;
  ButtonFilterChg.Enabled := False;
  clipboard().AsText := Format(LangResult, [Edit1.Text, Edit2.Text]);


end;

procedure TForm1.ButtonFilterDelClick(Sender: TObject);
var
  nlist: TListItem;
  pli: PTLangInfo;
begin
  nlist := ListViewSetDesc.Selected;
  if nlist = nil then Exit;
  pli := PTLangInfo(nlist.SubItems.Objects[0]);
  if pli = nil then Exit;
  pli.idx := StrToInt(Edit1.Text);
  Alang.DelXML(pli.idx, sFileName);
  RefListViewbindItem;
  ButtonFilterDel.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Alang := TLangFile.Create;

//    sFileName := ExtractFileName(OpenDialog.FileName);
    sFileName := CnLangFile;
    Alang.LoadLangFile(sFileName);
    lbl4.Caption := inttostr(Alang.ilist.Count);
    RefListViewBindItem;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Alang.Free;
end;

procedure TForm1.ListViewSetDescClick(Sender: TObject);
var
  nlist: TListItem;
  pli: PTLangInfo;
begin
  ButtonFilterChg.Enabled := False;
  ButtonFilterDel.Enabled := False;
  nlist := ListViewSetDesc.Selected;
  if nlist = nil then Exit;
  pli := PTLangInfo(nlist.SubItems.Objects[0]);
  if pli = nil then Exit;

  Edit1.Text := IntToStr(pli.idx);
  Edit2.Text := pli.CaptionName;

  ButtonFilterChg.Enabled := True;
  ButtonFilterDel.Enabled := True;
end;

procedure TForm1.pnl1Click(Sender: TObject);
begin
//"D:\mine\百度网盘\我的文档\work\program\521g\idgp\AnHei\!SC\tools\IWStat\Lang\Chinese.xml"
  OpenDialog.FileName := CnLangFile;

  if OpenDialog.Execute then
  begin
//    sFileName := ExtractFileName(OpenDialog.FileName);
    sFileName := OpenDialog.FileName;
    Alang.LoadLangFile(sFileName);
    lbl4.Caption := inttostr(Alang.ilist.Count);
    RefListViewBindItem;
  end;
end;

procedure TForm1.RefListViewBindItem;
var
  I: Integer;
  nlist: TListItem;
  pli: PTLangInfo;
begin
  ListViewSetDesc.Items.Clear;
  for I := 0 to Alang.ilist.Count - 1 do begin
    pli:= PTLangInfo(Alang.ilist.Items[I]);

    nlist := ListViewSetDesc.Items.Add;
    nlist.Caption := IntToStr(pli.idx);
    nlist.SubItems.AddObject(pli.CaptionName, TObject(pli));
    nlist.Data := pli;
  end;
end;

end.
