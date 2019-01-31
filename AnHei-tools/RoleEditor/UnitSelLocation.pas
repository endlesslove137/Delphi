unit UnitSelLocation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, UnitMain;

type
  TfrmSelLocation = class(TForm)
    Label1: TLabel;
    ListView1: TListView;
    Button1: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function SelectLocation(MapList: TList; MonList: TList;
      out Map: TRoleEnvir; out Mon: TEnvirMonster): Boolean;
  end;

var
  frmSelLocation: TfrmSelLocation;

implementation

{$R *.dfm}

{ TForm10 }

procedure TfrmSelLocation.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TfrmSelLocation.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    Button1.Click;
end;

procedure TfrmSelLocation.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  Button1.Enabled := Selected;
end;

class function TfrmSelLocation.SelectLocation(MapList, MonList: TList;
  out Map: TRoleEnvir; out Mon: TEnvirMonster): Boolean;
var
  I: Integer;
  AMap: TRoleEnvir;
  AMon: TEnvirMonster;
begin
  Result := False;
  if MapList.Count <= 0 then Exit;

  with TfrmSelLocation.Create(Application) do
  begin
    try
      for I := 0 to MapList.Count - 1 do
      begin              
        AMap := MapList[I];
        AMon := MonList[I];
        with ListView1.Items.Add do
        begin
          Caption := AMap.MapName;
          Data := AMap;
          SubItems.AddObject(AMon.Name, AMon);
          SubItems.Add(IntToStr(AMon.Position.X) + ':' + IntToStr(AMon.Position.Y));
        end;
      end;
      ListView1.Selected := ListView1.Items[0];
      Button1.Enabled := True;
      if ShowModal() = mrOK then
      begin
        Map := ListView1.Selected.Data;
        Mon := TEnvirMonster(ListView1.Selected.SubItems.Objects[0]);
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;

end.
