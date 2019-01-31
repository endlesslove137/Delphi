 {**************--===ION Tek===--****************}
 { Translator engine unit                        }
 {***********************************************}
unit Translator;

interface

uses
  Forms, Windows, Classes, TypInfo, StdCtrls, ComCtrls, ExtCtrls,
  Controls, Menus, {LocalizerFrm,} Dialogs;

function TranslateMsg(const Msg: string): PChar;
procedure LoadLanguage(FormInstance: TForm);
procedure TranslateForm(FormInstance: TForm);
(*
procedure DumpLanguage(FormInstance: TForm; const FileName: string;
  WriteMode: word);
procedure LocalizerMode(FormInstance: TForm; Enable: boolean);
*)

implementation

uses
  SysUtils,
  Globals, Shared,
  MainFrm;

type
  TTokenKind = (tkScoper, tkProperty, tkData);

  TToken = record
    Data: string;
    Kind: TTokenKind;
  end;
  TTokens = array of TToken;

(*
  // This is a dummy container used to handle popup forms in
  // localization mode
  TDummyContainer = class
  public
    procedure LocalizationMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  end;
*)

 // Does the translation of predefined messages (declared as
 // msg[xxx]=??? in .lng file)
function TranslateMsg(const Msg: string): PChar;
var
  i: integer;
begin
  for i := 1 to High(EngMsgs) do
  begin
    if (Msg = EngMsgs[i]) and (Messages[i] <> '') then
    begin
      Result := PChar(Messages[i]);
      break;
    end
    else begin
      Result := PChar(Msg);
    end;
  end;
end;

procedure AddMessage(Msg: string);

  function RemoveQuotes(const InStr: string): string;
  begin
    if (InStr <> '') and (InStr[1] in ['"', '''']) then
    begin
      Result := copy(InStr, 2, length(InStr) - 2);
    end
    else begin
      Result := InStr;
    end;
  end;

var
  posit, cut: integer;
begin
  posit := pos('[', Msg) + 1;
  posit := StrToInt(Copy(Msg, posit, 3));
  cut   := pos('=', Msg);
  Delete(Msg, 1, cut);
  Messages[posit] := RemoveQuotes(Msg);
end;

procedure SetProperty(const Tokens: TTokens);
var
  i:     integer;
  comp:  TComponent;
  Prop:  string;
  Value: string;
begin
  comp := Application.FindComponent(Tokens[0].Data);
  if comp <> nil then
  begin
    for i := 1 to high(Tokens) do
    begin
      case Tokens[i].Kind of
        tkScoper:
        begin
          if comp <> nil then
          begin
            comp := comp.FindComponent(Tokens[i].Data);
          end;
        end;
        tkProperty:
        begin
          Prop := Tokens[i].Data;
        end;
        tkData:
        begin
          Value := Tokens[i].Data;
        end;
      end;
    end;
  end;
  if (comp <> nil) and (comp is TComboBox) then
  begin
    if lowercase(Prop) = 'hint' then
    begin
      TComboBox(comp).Hint := Value;
    end
    else begin
      TComboBox(comp).Items[StrToInt(Prop)] := Value;
    end;
  end
  else begin
    if pos('mnuhistory', lowercase(Tokens[1].Data)) <> 0 then
    begin
      MainForm.mnuHistory.Items[0].Caption := Value;
    end;
  end;
  if comp <> nil then
  begin
    SetStringProperty(comp, Prop, Value);
  end;
end;

procedure ParseLine(const Line: string);

  function Tokenize(const InStr: string): TTokens;
  var
    i:     integer;
    level: integer;
    tKind: TTokenKind;
  begin
    level := 0;
    SetLength(Result, 1);
    tKind := tkScoper;
    for i := 1 to length(InStr) do
    begin
      if (tKind = tkScoper) and (InStr[i] = '.') then
      begin
        Inc(level);
        SetLength(Result, level + 1);
        Result[level].Kind := tKind;
      end
      else begin
        if (tKind = tkScoper) and (InStr[i] = '=') then
        begin
          Inc(level);
          SetLength(Result, level + 1);
          tKind := tkData;
          Result[level].Kind := tKind;
          Result[level - 1].Kind := tkProperty;
        end
        else begin
          if (tKind = tkData) and (InStr[i] in ['"', '''']) then
          begin
            //Do Nothing
          end
          else begin
            Result[level].Data := Result[level].Data + InStr[i];
          end;
        end;
      end;
    end;
  end;

var
  tmp: TTokens;
begin
  tmp := Tokenize(Line);
  SetProperty(tmp);
end;

// Loads the file and scans strings one by one
procedure LoadFile(const FileName: string; FormInstance: TForm);
type
  TTokenKind = (tkUnknown, tkComment, tkMessage, tkTranslation);

  function GetTokenKind(Str: string): TTokenKind;
  begin
    Result := tkUnknown;
    Str    := trim(Str);
    if Str <> '' then
    begin
      if (copy(Str, 1, 2) = '//') or (Str[1] = ';') then
      begin
        Result := tkComment;
      end
      else begin
        if copy(Str, 1, 4) = 'msg[' then
        begin
          Result := tkMessage;
        end
        else begin
          if pos('=', Str) <> 0 then
          begin
            Result := tkTranslation;
          end;
        end;
      end;
    end;
  end;

var
  f:    textfile;
  FormName: string;
  temp: string;
begin
  FormName := FormInstance.Name;
  if FileExists(FileName) then
  begin
    assignfile(f, FileName);
    reset(f);
    while not EOF(f) do
    begin
      readln(f, temp);
      case GetTokenKind(temp) of
        tkTranslation:
        begin
          if pos(FormName, temp) <> 0 then
          begin
            ParseLine(temp);
          end;
        end;
        tkMessage:
        begin
          AddMessage(temp);
        end;
      end;
    end;
    closefile(f);
  end;
end;

procedure LoadLanguage(FormInstance: TForm);
begin
  SetCurrentDir(WorkDir);
  LoadFile(LangFile + '.lng', FormInstance); //Load .lng file for processing
end;

procedure TranslateForm(FormInstance: TForm);
//Parses a text file
  procedure ParseLine(InStr: string; out Form, Component, Prop, Value: string);
  var
    posit: integer;
  begin
    posit := pos('.', InStr);
    Form  := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(InStr, 1, posit);
    posit     := pos('.', InStr);
    Component := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(InStr, 1, posit);
    posit := (pos('=', InStr));
    Prop  := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(Instr, 1, posit);
    posit := (pos('=', InStr));
    Delete(InStr, posit, 1);
    Value := Trim(InStr);
  end;

var
  f:     textfile;
  Line, Temp: string;
  Form, Component, Prop, Value: string;
  CompC: TComponent;
  Index: integer;
begin
  assignfile(f, WorkDir + LangFile + '.lng');
  reset(f);
  while not EOF(f) do
  begin
    readln(f, Line);
    Temp := copy(Line, 1, length(FormInstance.Name));
    if Temp = FormInstance.Name then
    begin
      ParseLine(Line, Form, Component, Prop, Value);
      if not (FormInstance = nil) then
      begin
        Compc := FormInstance.FindComponent(Component);
        if CompC <> nil then
        begin
          if CompC is TComboBox then
          begin
            if Prop = 'hint' then
            begin
              TComboBox(CompC).Hint := Value;
            end
            else begin
              Index := StrToInt(Prop);
              TComboBox(CompC).Items[Index] := Value;
            end;
          end
          else begin
            SetStringProperty(CompC, Prop, Value);
          end;
        end;
      end;
    end;
  end;
  closefile(f);
end;

(*
// Dumps all form component's captions and hints into a language file
procedure DumpLanguage(FormInstance: TForm; const FileName: string;
  WriteMode: word);
var
  fs: TFileStream;

  procedure DumpComponent(Component: TComponent;
  const Properties: array of string);
  var
    i:   integer;
    str: string;
    tmp: string;
  begin
    for i := 0 to high(Properties) do
    begin
      str := GetComponentTree(Component);
      tmp := GetStringProperty(Component, Properties[i]);
      if tmp <> '' then
      begin
        str := #13#10 + str + '.' + Properties[i] + '=' + tmp;
        fs.WriteBuffer(str[1], length(str));
      end;
    end;
  end;

var
  i: integer;
  Comment: string;
begin
  fs := TFileStream.Create(FileName, WriteMode);
  try
    fs.Seek(0, soFromEnd);
    Comment := #13#10 + chr(VK_TAB) + '// ' + FormInstance.Name;
    fs.WriteBuffer(Comment[1], length(comment));
    for i := 0 to FormInstance.ComponentCount - 1 do
    begin
      DumpComponent(FormInstance.Components[i], ['caption', 'hint']);
    end;
  finally
    FreeAndNil(fs);
  end;
end;

// When we go to localizer mode we create a context menu
type
  TControlFriend = class(TControl);

procedure LocalizerMode(FormInstance: TForm; Enable: boolean);
var
  Dummy: TDummyContainer;

  procedure SetComponentPopup(Component: TComponent);
  begin
    // first let's see if the component has a caption or a hint properties
    if PropertyExists(Component, 'caption') or
      PropertyExists(Component, 'hint') then
    begin
      // now let's see if our component is a TControl descendant and actually
      // has an OnMouseUp event catch
      if Component is TControl then
      begin
        TControlFriend(Component).OnMouseUp := Dummy.LocalizationMouseUp;
      end;
    end;
  end;

var
  i: integer;
begin
  if Enable = True then
  begin
    Dummy := TDummyContainer.Create();
    for i := 0 to FormInstance.ComponentCount - 1 do
    begin
      SetComponentPopup(FormInstance.Components[i]);
    end;
  end
  else begin

  end;
end;

{ TDummyContainer }

procedure TDummyContainer.LocalizationMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);

  function GetControlProps(Control: TControl): TComponentProperties;
  var
    i: integer;
  begin
    Result.Name := GetComponentTree(Control);
    if Control is TComboBox then
    begin
      // a combobox needs special treatment
      i := TComboBox(Control).Items.Count;
      SetLength(Result.Properties, i + 1);
      Result.Properties[i].Name  := 'Hint';
      Result.Properties[i].Value := GetStringProperty(Control, 'Hint');
      for i := 0 to i - 1 do
      begin
        Result.Properties[i].Name  := IntToStr(i);
        Result.Properties[i].Value := TComboBox(Control).Items[i];
      end;
    end
    else begin
      if (Control is TPanel) and (TPanel(Control).Parent is TTabSheet) and
        (TPanel(Control).Align = alClient) then
      begin
        // if the control is a panel and has a TabSheet parent and an
        // alClient alignment, then we redirect it's click to the parent sheet
        SetLength(Result.Properties, 2);
        Result.Properties[0].Name  := 'Caption';
        Result.Properties[0].Value :=
          GetStringProperty(Control.Parent, 'Caption');
        Result.Properties[1].Name  := 'Hint';
        Result.Properties[1].Value :=
          GetStringProperty(Control.Parent, 'Hint');
      end
      else begin
        // as for the rest of controls, we are only allowing to edit their
        // captions and hints
        i := 0;
        if PropertyExists(Control, 'Caption') then
        begin
          Inc(i);
          SetLength(Result.Properties, i);
          Result.Properties[i - 1].Name  := 'Caption';
          Result.Properties[i - 1].Value :=
            GetStringProperty(Control, 'Caption');
        end;
        if PropertyExists(Control, 'Hint') then
        begin
          Inc(i);
          SetLength(Result.Properties, i);
          Result.Properties[i - 1].Name  := 'Hint';
          Result.Properties[i - 1].Value := GetStringProperty(Control, 'Hint');
        end;
      end;
    end;
  end;

  procedure SetControlProps(Control: TControl; Props: TComponentProperties);
  var
    i: integer;
  begin
    if Control is TComboBox then
    begin
      for i := 0 to high(Props.Properties) do
      begin
        if IsNumeric(Props.Properties[i].Name) then
        begin
          TComboBox(Control).Items[StrToInt(Props.Properties[i].Name)] :=
            Props.Properties[i].Value;
        end
        else begin
          SetStringProperty(Control, Props.Properties[i].Name,
            Props.Properties[i].Value);
        end;
      end;
    end
    else begin
      if (Control is TPanel) and (TPanel(Control).Parent is TTabSheet) and
        (TPanel(Control).Align = alClient) then
      begin
        for i := 0 to high(Props.Properties) do
        begin
          SetStringProperty(Control.Parent, Props.Properties[i].Name,
            Props.Properties[i].Value);
        end;
      end
      else begin
        for i := 0 to high(Props.Properties) do
        begin
          SetStringProperty(Control, Props.Properties[i].Name,
            Props.Properties[i].Value);
        end;
      end;
    end;
  end;

var
  Localizer: TLocalizerForm;
begin
  if Button = mbRight then
  begin
    Localizer := TLocalizerForm.Create(nil);
    try
      Localizer.FControl := GetControlProps(TControl(Sender));
      Localizer.ShowModal();
      SetControlProps(TControl(Sender), Localizer.FControl);
    finally
      Localizer.Free()
    end;
  end;
end;
*)

end.


