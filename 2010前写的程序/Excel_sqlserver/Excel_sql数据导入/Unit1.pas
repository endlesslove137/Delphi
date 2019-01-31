unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzTabs, ComCtrls, Keyboard, Grids, Outline,
  DirOutln, RzSplit, RzPanel, RzGroupBar, Mask, RzEdit, RzButton, RzDTP,
  RzRadChk, RzCmboBx, RzLabel, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, DBCtrls, Buttons, DBGrids, ValEdit,
  ADODB,shellapi, cxDropDownEdit,strutils,comobj,inifiles, WinSkinData,
  WinSkinStore, Menus;

type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;
  TForm1 = class(TForm)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    RzLabel2: TRzLabel;
    RzLabel15: TRzLabel;
    RzButton1: TRzButton;
    chkFront: TRzCheckBox;
    RzButton18: TRzButton;
    RzDateTimePicker1: TRzDateTimePicker;
    RzEdit11: TRzEdit;
    EdtScheme: TEdit;
    Label3: TLabel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    XlsColName: TcxGridDBColumn;
    XlsColIndex: TcxGridDBColumn;
    FieldDesc: TcxGridDBColumn;
    FieldName: TcxGridDBColumn;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    reHColEnd: TRzEdit;
    reHColStart: TRzEdit;
    reHRowEnd: TRzEdit;
    reHRowStart: TRzEdit;
    RzButton3: TRzButton;
    RzButton5: TRzButton;
    GroupBox6: TGroupBox;
    lblDelInfo: TRzLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    Button3: TButton;
    reWellName: TRzEdit;
    RzButton10: TRzButton;
    RzButton71: TRzButton;
    RzCheckBox2: TRzCheckBox;
    RzCheckBox3: TRzCheckBox;
    RzEdit8: TRzEdit;
    rzFilterString: TRzRichEdit;
    GroupBox4: TGroupBox;
    lblRow: TRzLabel;
    RzButton9: TRzButton;
    RzButton23: TRzButton;
    reInfo3: TRzEdit;
    RzButton22: TRzButton;
    reInfo2: TRzEdit;
    RzButton21: TRzButton;
    reInfo1: TRzEdit;
    pgBar: TProgressBar;
    RzButton15: TRzButton;
    RzButton2: TRzButton;
    RzButton8: TRzButton;
    RzButton17: TRzButton;
    RzButton16: TRzButton;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Label7: TLabel;
    lblSheet: TRzLabel;
    Label8: TLabel;
    GroupBox5: TGroupBox;
    RzButton7: TRzButton;
    reDRowEnd: TRzEdit;
    RzButton6: TRzButton;
    reDRowStart: TRzEdit;
    CheckBox1: TCheckBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    GroupBox9: TGroupBox;
    DBGrid1: TDBGrid;
    AdoTemp: TADOQuery;
    ADOConnection1: TADOConnection;
    ADOCommand1: TADOCommand;
    Memo1: TMemo;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    DataSource1: TDataSource;
    ComboBox1: TComboBox;
    Label10: TLabel;
    GroupBox10: TGroupBox;
    Button4: TButton;
    DataType: TcxGridDBColumn;
    Comparefields: TADOQuery;
    MapCol: TADOQuery;
    dsgrid: TDataSource;
    odFile: TOpenDialog;
    Panel3: TPanel;
    ComboBox2: TComboBox;
    Label9: TLabel;
    Button6: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    datainsert: TADOTable;
    MapColXLSColName: TWideStringField;
    MapColXLSColIdx: TIntegerField;
    MapColDBFieldDesc: TWideStringField;
    MapColDBFieldName: TWideStringField;
    MapColdatatype: TStringField;
    CheckBox2: TCheckBox;
    TabSheet5: TRzTabSheet;
    RzEdit1: TRzEdit;
    RzEdit2: TRzEdit;
    Label11: TLabel;
    Label12: TLabel;
    RzEdit3: TRzEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Well: TADOQuery;
    WellJingHao: TStringField;
    WellCaiYouDui: TStringField;
    WellJingQuYu: TStringField;
    WellWELLNAME: TStringField;
    WellJingLeiXing: TStringField;
    WellBiaoGeMingCheng: TStringField;
    WellInputDate: TDateTimeField;
    WellSchemaName: TStringField;
    WellInputUser: TStringField;
    PopupMenu1: TPopupMenu;
    xp1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GroupBox11: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure chkFrontClick(Sender: TObject);
    procedure RzButton3Click(Sender: TObject);
    procedure RzButton5Click(Sender: TObject);
    procedure RzButton8Click(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FieldDescPropertiesChange(Sender: TObject);
    procedure cxComboboxAddItems();
    procedure RzButton17Click(Sender: TObject);
    procedure RzButton16Click(Sender: TObject);
    procedure RzButton6Click(Sender: TObject);
    procedure RzButton7Click(Sender: TObject);
    procedure RzButton10Click(Sender: TObject);
    procedure RzButton71Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure xp1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RzButton18Click(Sender: TObject);
  private
    ExcelApp: Variant;
    myINI: TiniFile;
    IsNewTable,IsThansactHid: boolean;
    NewTableName,sFileName: string;
    arrFieldMap: array of FieldMap;
   procedure DeleteNoUseData;
   procedure RefreshCompare();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  welllist:tstringlist;
implementation
   uses upublic;
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
ExcelApp.ActiveSheet.cells[1,4].Value:='test';
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
 sL:string;
begin
  sl:=vartostr(ExcelApp.ActiveSheet.Range['$A$1'].CurrentRegion.Address);
  if sl='' then showmessage('空的')else

  showmessage(sl);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 sqlS:string;
begin
  sqls:=memo1.Text;
  ADOtemp.Close;
  ADOtemp.SQL.Clear;
  ADOtemp.SQL.add(sqls);
  ADOtemp.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  sFieldName,SQL: string;

begin
  SQL :=memo1.Text;
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;
  showmessage('I do');
end;


procedure TForm1.Button3Click(Sender: TObject);
var
  iSheet: integer;
begin
    if VarIsEmpty(ExcelApp) then
    begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！', MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
    end;
    if trim(edtscheme.Text)='' then
    begin
    showmessage('输入一个方案！');
    Exit;
    end;
    if trim(rzFilterString.text)='' then
    begin
    showmessage('没有输入过滤条件！');
    Exit;
    end;
    if trim(reWellName.EditText)='' then
    begin
    showmessage('没有选择判定空行列！');
    Exit;
    end;
    lblDelInfo.Caption:='开始清除...';
    DeleteNoUseData;
    lblDelInfo.Caption:='清除完毕！';
end;

//刷新对照,并更新对照表的内容
procedure tform1.RefreshCompare();
var
  i: integer;
begin
  if MapCol.IsEmpty then
    exit;
  MapCol.First;
  Comparefields.Close;
  Comparefields.Open;
  while not MapCol.eof do
  begin
    if MapCol.FieldByName('DBFieldName').AsString = '井名' then
      reWellName.EditText := MapCol.FieldByName('XlsColIdx').Value;
   if not Comparefields.Locate('XlsColName;FieldDesc',vararrayof([MapCol.FieldByName('XlsColName').Value,
        MapCol.FieldByName('DBFieldDesc').Value]), [loCaseInsensitive]) then
    begin
      if (trim(MapCol.FieldByName('DBFieldDesc').AsString) <> '') and
        (trim(MapCol.FieldByName('XlsColName').AsString) <> '') then
      begin
        Comparefields.Append;
        Comparefields.FieldByName('XlsColName').AsString := MapCol.FieldByName
          ('XlsColName').AsString;
        Comparefields.FieldByName('FieldDesc').AsString := MapCol.FieldByName
          ('DBFieldDesc').AsString;
        Comparefields.FieldByName('FieldName').AsString := MapCol.FieldByName
          ('DBFieldName').AsString;
        Comparefields.FieldByName('Datatype').AsString := MapCol.FieldByName
          ('Datatype').AsString;
        Comparefields.Post;
      end;
    end;
    MapCol.Next;
  end;

  setlength(arrFieldMap, 0);
  // 建立数据列数组和对应的字段名数组
  MapCol.First;
  i := 0;
  while not MapCol.eof do
  begin
    if trim(MapCol.FieldByName('DBFieldName').AsString) <> '' then
    begin
      setlength(arrFieldMap, length(arrFieldMap) + 1);
      arrFieldMap[i].FieldName := MapCol.FieldByName('DBFieldName').AsString;
      arrFieldMap[i].ColIndex := MapCol.FieldByName('XLSColIdx').AsInteger;
      i := i + 1;
    end;
    MapCol.Next;
  end;

end;


//删除无效数据
procedure Tform1.DeleteNoUseData;
var
  tmpCurValue,tmp2CurValue: string;
  temprow,tempcount,tempi,i: Integer;
  iRow, iCol, iLst, iWellNameCol, iRowCount: integer;
  rowend, sCellVal, sDataAddress: string;
  spltStringList: TStringList;
  iFound: boolean;
   strAddress:variant;
begin
  // 分割关键字字符串
  spltStringList := SplitString(rzFilterString.Text, '#');
  // 需要处理的列
  i := StrToInt(RzEdit8.EditText);
  iWellNameCol := StrToInt(reWellName.EditText);
  // 在数据判断列上根据关键字判断，删除无效数据。  这里只是设置标志位，在下一个循环中根据标志位删除
  iRowCount := ExcelApp.ActiveSheet.UsedRange.Rows.Count;

  iRow := StrToInt(reDRowStart.EditText);
  for icol := 1 to i do
  begin
      while iRow <= iRowCount do
      begin
       application.ProcessMessages;
    // 获取单元格数据
       sCellVal := ExcelApp.ActiveSheet.cells[iRow, iCol].Value;
       iFound := false;

    // 根据井名列是不是为空来判断是不是空行
      if  true  then
      begin
       try
        tmpCurValue := ExcelApp.ActiveSheet.cells[iRow, iWellNameCol].Value;
        tmpCurValue := ToDBC(tmpCurValue);
      //  tmp2CurValue := ExcelApp.ActiveSheet.cells[iRow,2].Value;
      //  tmp2CurValue := ToDBC(tmp2CurValue);
       except  on exception   do
       begin
        tmpCurValue:='';
     //   tmp2CurValue:='';
       end;
     end;     //若井名列为空就删除行      and (trim(tmp2CurValue) = '')
      if (trim(tmpCurValue) = '') then
      begin
        ExcelApp.ActiveSheet.Rows[iRow].DELETE;
        iRowCount := iRowCount - 1;
        Continue;
      end
      //若井名列不为空,那么有对照的也删
      else
      begin
        for iLst := 0 to spltStringList.Count - 1 do
        begin
          if (pos(spltStringList.Strings[iLst],ExcelApp.ActiveSheet.cells[iRow,iWellNameCol].Value) > 0)
           or (pos(spltStringList.Strings[iLst],ExcelApp.ActiveSheet.cells[iRow,2].Value) > 0)
           or (pos(spltStringList.Strings[iLst],ExcelApp.ActiveSheet.cells[iRow,1].Value) > 0)
           then
          begin
            ExcelApp.ActiveSheet.Rows[iRow].DELETE;
            iRowCount := iRowCount - 1;
            iFound := true;
            break;
          end;
        end;
   end;
    end;
        if ifound then  continue else
    for iLst := 0 to spltStringList.Count - 1 do
    begin
      if (pos(spltStringList.Strings[iLst], sCellVal) > 0)then // or (trim(ExcelApp.ActiveSheet.cells[iRow,iWellNameCol].Value)='') then
      begin
        ExcelApp.ActiveSheet.Rows[iRow].DELETE;
        iRowCount := iRowCount - 1;
        iFound := true;
        break;
      end;
    end;
    if not iFound then
      iRow := iRow + 1;
  end;
  // 需要自动获取数据结束行
  if RzCheckBox2.Checked then
  begin
    // 获取有数据的结束行
    sDataAddress := ExcelApp.ActiveSheet.Range['$A$1'].CurrentRegion.Address;
    // 数据起始行
    rowend := rightstr(sDataAddress, length(sDataAddress) - pos(':',sDataAddress));
    rowend := rightstr(rowend, length(rowend) - 1);
    rowend := rightstr(rowend, length(rowend) - pos('$', rowend));
    reDRowEnd.EditText := rowend;
  end;

  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  myINI.WriteString('整理人', '姓名', RzEdit11.EditText);
  myINI.WriteString('无效信息', '值', stringreplace(rzFilterString.text,' ','',[rfreplaceall]));
  myINI.WriteString('方案', '名称', EdtScheme.Text);
  myINI.WriteString('表名', '名称', combobox2.Text);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 SkinData1.LoadFromCollection(SkinStore1,3)
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 DropTable(combobox2.Text,adocommand1);
  upublic.ComboboxAddTablename(adotemp,combobox2);
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  IsThansactHid:=checkbox2.Checked;
end;

procedure TForm1.chkFrontClick(Sender: TObject);
begin
  if chkFront.Checked then
  begin
    SetWindowPos(self.Handle, HWND_TOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  end
  else
  begin
    SetWindowPos(self.Handle, HWND_NOTOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var
 i:integer;
begin
   if (combobox2.Text='新增一个表') then
   begin
       SetWindowPos(self.Handle, HWND_NOTOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);

     IsNewTable:=false;
     NewTablename:=inputbox('输入框','新表名(:表名中间不能有空格)','');
     if trim(NewTableName)=''then
     begin
      showmessage('新的表名不能为空');
      exit;
     end;
     i:=1;
     while i<=combobox2.Items.Count do
     begin
       if Uppercase(trim(NewTableName))=Uppercase(combobox2.Items[i]) then
       begin
         showmessage('表已存在');
         exit;
       end else
       i:=i+1;
     end;
   IsNewTable:=true;
   combobox2.Items.Add(NewTableName);
   ComboBox2.ItemIndex:=ComboBox2.Items.Count
    end
   else if trim(combobox2.Text)<>'' then
   begin
     datainsert.Close;
     datainsert.TableName:=combobox2.Text;
   end;
       SetWindowPos(self.Handle, HWND_TOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);

end;

procedure TForm1.FieldDescPropertiesChange(Sender: TObject);
var
  curVal: string;
begin
  curVal := mapcol.FieldByName('DBFieldDesc').AsString;
  if curVal = '' then
  begin
    mapcol.Edit;
    mapcol.FieldByName('DBFieldName').AsString := '';
    mapcol.Post;
  end
  else
  if trim(curVal) = '新增' then
  begin
    panel1.Visible:=true;
    mapcol.Edit;
    mapcol.FieldByName('DBFieldName').AsString := '';
    mapcol.Post;
  end
  else
  begin
    Comparefields.Filter := 'FieldDesc=''' + curVal + '''';
    Comparefields.Filtered := true;
    mapcol.Edit;
    mapcol.FieldByName('DBFieldName').AsString := Comparefields.FieldByName
      ('FieldName').AsString;
    mapcol.FieldByName('datatype').AsString := Comparefields.FieldByName
      ('datatype').AsString;
    mapcol.Post;
  end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if messagebox(handle,'选取消会使这次的操作全部做废','操作是否存盘?',MB_iconwarning+mb_okcancel)=idok then
 begin
   adocommand1.CommandText:='commit transaction';
   adocommand1.Execute;
   closeexcel();
 end else
 begin
   adocommand1.CommandText:='rollback transaction';
   adocommand1.Execute;
   closeexcel();
 end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 try
    adoconnection1.Close;
    adoconnection1.ConnectionString:='FILE NAME='+GetCurrentDir+'\11sql.udl';
    adoconnection1.Open();
   myINI := TiniFile.Create(ExtractFilePath(application.EXEName)
      + '\config.ini');
   adocommand1.CommandText:='begin transaction';
   adocommand1.Execute;
 except on exception do
 begin
  if  messagebox(handle,'172.20.0.11上的SQLSERVER连接有变','远程连接出错',MB_ICONWARNING+MB_OKCANCEL)=idok then
  ShellExecute(Application.Handle, 'OPEN', PChar(GetCurrentDir+'\11sql.udl'),'', '', SW_SHOWNORMAL)
  else
  application.Terminate;
  application.Terminate;
 end;
 end;
   rzpagecontrol1.ActivePageIndex:=0;
end;


procedure TForm1.RzButton10Click(Sender: TObject);
var
  iRow: integer;
  strAddress: string;
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  iRow := ExcelApp.ActiveCell.Column;

  // 如果是合并的单元格，那么就要进行拆分
  // 默认的合并单元格的地址是合并区域左上角的单元格地址
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address]
      .MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,
      length(strAddress));
    // showmessage(strAddress);
    iRow := ExcelApp.ActiveSheet.Range[strAddress].column;
  end;
  RzEdit8.EditText := inttostr(iRow);
end;


procedure TForm1.RzButton16Click(Sender: TObject);
begin
  if rzbutton17.Tag=rzbutton16.Tag then exit;
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  rzbutton17.Tag:= rzbutton17.Tag+1;
  ExcelApp.WorkSheets[rzbutton17.tag].Activate;
  lblSheet.Caption := ExcelApp.WorkSheets[rzbutton17.Tag].Name;

end;

procedure TForm1.RzButton17Click(Sender: TObject);
begin
  if rzbutton17.Tag=1 then exit;
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  rzbutton17.Tag:= rzbutton17.Tag-1;
  ExcelApp.WorkSheets[rzbutton17.tag].Activate;
  lblSheet.Caption := ExcelApp.WorkSheets[rzbutton17.Tag].Name;

end;

procedure TForm1.RzButton1Click(Sender: TObject);
begin
  IsThansactHid:=true;//在默认情况下处理隐藏的行和列\
  CloseExcel();
  odFile.Options := [ofHideReadOnly, ofEnableSizing];
  odFile.InitialDir := 'C:\Documents and Settings\Administrator\桌面\0普查验收电子版-定稿';
  if not odFile.Execute() then
    exit;
  sFileName := odFile.FileName;
  GroupBox11.Caption := '方案--' + sFileName;
  if sFileName = '' then
    exit;
  try
    begin
    if varisempty(ExcelApp) then
      ExcelApp := CreateOleObject('Excel.Application');  //
      ExcelApp.WorkBooks.Open(sFileName);
      ExcelApp.WorkSheets[1].Activate;
      lblSheet.Caption := ExcelApp.ActiveSheet.Name;
    end;
  except
    exit;
  end;
  //16放的是总数, 17放的是当前的sheet索引
  RzButton16.Tag := ExcelApp.WorkSheets.Count;
  RzButton17.Tag := 1;
  ExcelApp.Visible := true;
 try
    RzDateTimePicker1.Date:=getdate(sFileName);
   except on exception do
  begin
     showmessage('自动获致时间出错,请手动选择');
     RzDateTimePicker1.Date:=date;
  end;
 end;
 cxComboboxAddItems();
 //
// SetStringListByFieldName(welllist,well,'wellname');
 upublic.ComboboxAddTablename(adotemp,combobox2);
  RzEdit11.EditText := myINI.ReadString('整理人', '姓名', '');
 // rzFilterString.text:=stringreplace(myINI.ReadString('无效信息', '值', ''),' ',[rfreplaceall]);
  rzFilterString.text:=stringreplace(myINI.ReadString('无效信息', '值', ''),' ','',[rfreplaceall]);
  EdtScheme.Text := myINI.ReadString('方案', '名称', '');
  combobox2.Text := myINI.ReadString('表名', '名称', '');
end;

procedure TForm1.RzButton2Click(Sender: TObject);
var
  ISsc,ISzS,isjh,isyjjh,iszsjz:boolean;
  sIns, sVal, curValue, tmpCurValue, strAddress, strAddr,mhs,syjjh,szsjz,syjbh,szsbh: string;
  sJH, tttt: string;
  iRow, iRowStart, iRowEnd, iCol, iMcol, iPos, iCurSheet, ICHK, iSel,IJH,IZT,ii,iyjjh,izsjz: integer;
  id:tdate;
begin
  if(trim(reHRowEnd.EditText) = '') or (trim(reHColStart.EditText) = '') or
  (trim(reHColEnd.EditText) = '') or (trim(reDRowStart.EditText) = '') or
  (trim(reDRowEnd.EditText) = '') or (trim(reHRowStart.EditText) = '') then
  begin
    showmessage('行列地址信息不全');
    exit;
  end;

   if strtoint(reDRowStart.EditText)<=strtoint(reHRowEnd.EditText) then
  begin
    showmessage('数据起始行应该大于表头的结束行');
    exit;
  end;

  if strtoint(reDRowStart.EditText)>strtoint(reDRowEnd.EditText) then
  begin
    showmessage('数据结束行应该大于等于数据起始行');
    exit;
  end;

  if (trim(edtscheme.text)='') or (trim(rzedit11.text)='') then
  begin
    showmessage('请输入方案');
    exit;
  end;

  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;

 //刷新对照信息
 RefreshCompare();
 ComboBox2Change(self);
 if (IsNewTable and (combobox2.Text=Newtablename)) then
 begin
  craetetable(combobox2.Text,mapcol,adocommand1);
  IsNewTable:=false;
  datainsert.TableName:=newtablename;
  if not datainsert.Active then  datainsert.Open;
 end
 else
 AlterTable(Mapcol,datainsert,adocommand1);
//(*
  iRowStart := StrToInt(reDRowStart.EditText);
  iRowEnd := StrToInt(reDRowEnd.EditText);
  pgBar.Max :=iRowEnd - iRowStart;
  pgBar.Min := 0;
  pgBar.Position := 0;
  try
   for iRow := iRowStart to iRowEnd do
   begin
    lblRow.Caption:='正在获取第'+inttostr(iRow)+'行数据...';
    application.ProcessMessages;

    sIns := 'INSERT INTO '+datainsert.TableName+'(';
    sVal := ' VALUES (';

    sIns := sIns + 'INPUTDATE';
    sVal := sVal + '''' + formatdatetime('YYYY-MM-DD',RzDateTimePicker1.Date) + '''';

    sIns := sIns + ',InputUser';
    sVal := sVal + ',''' + trim(RzEdit11.EditText) + '''';

    sIns := sIns + ',SchemaName';
    sVal := sVal + ',''' + trim(edtscheme.Text) + '''';

    sIns := sIns + ',BiaoGeMingCheng';
    sVal := sVal + ',''' + trim(lblSheet.Caption) + '''';
    if not IsThansactHid then
    begin
      if not ExcelApp.ActiveSheet.rows[irow].Hidden = true then
      begin
    for iCol := 0 to length(arrFieldMap) - 1 do
    begin
      application.ProcessMessages;
      // 如果是合并单元格，那么要进行处理
      if ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].MergeCells = true then
      begin
        strAddress := ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex].MergeArea.Address;// 获取合并区域的地址
        strAddress := LeftStr(strAddress, pos(':', strAddress) - 1);        // 分割地址
        iMcol := ExcelApp.ActiveSheet.Range[strAddress].Column;
        curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow, iMcol].Value);
          mhs := trim(ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].Value);
          strAddr := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].Address].MergeArea.Address;
          ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].MergeCells := false;
           ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := mhs;
          mhs := '';

      end else
      try
        curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex].Value);
      except
        curValue := 'null';
      end;

       // 如果是井名所在的列(有的井名列并不是合并的单元格,所以要分开处理)
      if (arrFieldMap[iCol].FieldName ='WELLNAME') then
      begin

        if trim(curValue) = '' then                     // 如果获取的是空名称，那么获取前面一个单元格的数据
        begin
          if (arrFieldMap[iCol].ColIndex - 1) <= 0 then  // 如果前一个单元格的索引无效，那么这个单元格的值就设置为-1
            curValue := 'null'
          else
            curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex - 1].Value);
        end;

   //对井名进行处理

        tmpCurValue := curValue;
        tmpCurValue := ToDBC(tmpCurValue);//将全角转为半角
        if (rightstr(tmpCurValue, 1) = '#') or (rightstr(tmpCurValue, 1) = '井') then// 如果最后一个字符是 # 字符或者 井 字，那么要删除
        tmpCurValue := LeftStr(tmpCurValue, length(tmpCurValue) - 1);
        curValue:=tmpCurValue;
      end;

       sIns := sIns + ',' + arrFieldMap[iCol].FieldName;
      //对相应的字段类型进行相应的处理
      case datainsert.FieldByName(arrFieldMap[iCol].FieldName).DataType of
        ftWideString, ftString:
          begin
            sVal := sVal + ',''' + curValue + '''';

          end;
           ftDatetime,ftDate:
          begin
              try
                id:=GetDate(curvalue);
                sVal := sVal + ',''' + curValue + '''';
              except on exception do
                  begin
                      curvalue:='null';
                      sVal := sVal + ',' + curValue;
                  end;
              end;
          end;
        ftCurrency, ftWord, ftFloat:    // , ftSingle
          begin
            if IsNumeric(curValue) = true then
            begin
            sVal := sVal + ',' + FormatFloat('#0.000',
              strtofloat(curValue));
            end else
            begin
              curValue := 'null';
              sVal := sVal + ',' + curValue;
            end;
          end;
        ftSmallint, ftLargeint, ftInteger:
          begin
            if IsNumeric(curValue) = false then
              curValue := '0';
            sVal := sVal + ',' + curValue;
          end;
        else
          begin
            sVal := sVal + ',null';
          end;
      end;

    end; //arrayfieldMap循环结束

      end;
    end
    else //如果用户选择了处理隐藏的行列那么就全部处理
    begin
        for iCol := 0 to length(arrFieldMap) - 1 do
    begin
      application.ProcessMessages;
      // 如果是合并单元格，那么要进行处理
      if ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].MergeCells = true then
      begin
        strAddress := ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex].MergeArea.Address;// 获取合并区域的地址
        strAddress := LeftStr(strAddress, pos(':', strAddress) - 1);        // 分割地址
        iMcol := ExcelApp.ActiveSheet.Range[strAddress].Column;
        curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow, iMcol].Value);
          mhs := trim(ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].Value);
          strAddr := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].Address].MergeArea.Address;
          ExcelApp.ActiveSheet.cells[iRow, arrFieldMap[iCol].ColIndex].MergeCells := false;
           ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := mhs;
          mhs := '';

      end else
      try
        curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex].Value);
      except
        curValue := 'null';
      end;

       // 如果是井名所在的列(有的井名列并不是合并的单元格,所以要分开处理)
      if (arrFieldMap[iCol].FieldName ='WELLNAME') then
      begin

        if trim(curValue) = '' then                     // 如果获取的是空名称，那么获取前面一个单元格的数据
        begin
          if (arrFieldMap[iCol].ColIndex - 1) <= 0 then  // 如果前一个单元格的索引无效，那么这个单元格的值就设置为-1
            curValue := 'null'
          else
            curValue := vartostr(ExcelApp.ActiveSheet.cells[iRow,arrFieldMap[iCol].ColIndex - 1].Value);
        end;

   //对井名进行处理

        tmpCurValue := curValue;
        tmpCurValue := ToDBC(tmpCurValue);//将全角转为半角
        if (rightstr(tmpCurValue, 1) = '#') or (rightstr(tmpCurValue, 1) = '井') then// 如果最后一个字符是 # 字符或者 井 字，那么要删除
        tmpCurValue := LeftStr(tmpCurValue, length(tmpCurValue) - 1);
        curValue:=tmpCurValue;
      end;

       sIns := sIns + ',' + arrFieldMap[iCol].FieldName;
      //对相应的字段类型进行相应的处理
      case datainsert.FieldByName(arrFieldMap[iCol].FieldName).DataType of
        ftWideString, ftString:
          begin
            sVal := sVal + ',''' + curValue + '''';

          end;
           ftDatetime,ftDate:
          begin
              try
                id:=GetDate(curvalue);
                sVal := sVal + ',''' + curValue + '''';
              except on exception do
                  begin
                      curvalue:='null';
                      sVal := sVal + ',' + curValue;
                  end;
              end;
          end;
        ftCurrency, ftWord, ftFloat:   // , ftSingle
          begin
            if IsNumeric(curValue) = true then
            begin
            sVal := sVal + ',' + FormatFloat('#0.000',
              strtofloat(curValue));
            end else
            begin
              curValue := 'null';
              sVal := sVal + ',' + curValue;
            end;
          end;
        ftSmallint, ftLargeint, ftInteger:
          begin
            if IsNumeric(curValue) = false then
              curValue := '0';
            sVal := sVal + ',' + curValue;
          end;
        else
          begin
            sVal := sVal + ',null';
          end;
      end;
    end; //arrayfieldMap循环结束

    end;
    sIns:= sIns+')';
    sVal:= sVal+')';
   adocommand1.CommandText := sIns + ' ' + sVal;
   adocommand1.Execute;
   pgBar.Position := pgBar.Position + 1;

   end;  //行循环结束

   //操作多个excel时用户有时会忽略了重新获取信息所以要将信息清空
  // (*
   reHRowEnd.Clear  ;
   reHColStart.Clear;
   reHColEnd.Clear  ;
   reDRowStart.Clear;
   reDRowEnd.Clear  ;
   reHRowStart.Clear;
  // *)

   showmessage('数据转移已完成');
  except on e:exception do
  begin
   showmessage(e.Message);
   myINI.WriteString('未处理信息(获取数据时出错)'+datetimetostr(now),'文件名称', sFileName);
  end;
 end;
  pgBar.Position := 0;
//*)
end;


procedure tform1.cxComboboxAddItems();
var
  sDBFileName: string;
  sFieldName: string;
begin
  comparefields.Close;
if not comparefields.Active then comparefields.Open;
  comparefields.First;
  (FieldDesc.Properties as TcxComboBoxProperties).Items.Clear;
  (FieldDesc.Properties as TcxComboBoxProperties).Items.add('');
  while not comparefields.eof do
  begin
    if (trim(comparefields.FieldByName('xlscolname').AsString) = '') then
    begin
      sFieldName := comparefields.FieldByName('fielddesc').AsString;
      (FieldDesc.Properties as TcxComboBoxProperties).Items.add(sFieldName);
    end;
    comparefields.Next;
  end;
  (FieldDesc.Properties as TcxComboBoxProperties).Items.Add('新增');
end;

procedure TForm1.RzButton18Click(Sender: TObject);
begin
CloseExcel;
end;

procedure TForm1.RzButton3Click(Sender: TObject);
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  reHRowStart.EditText := ExcelApp.ActiveCell.Row;
  reHColStart.EditText := ExcelApp.ActiveCell.Column;
end;

procedure TForm1.RzButton5Click(Sender: TObject);
var
  iRow, iCol: integer;
  strAddress: string;
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  // 如果是合并的单元格，那么就要进行拆分
  // 默认的合并单元格的地址是合并区域左上角的单元格地址
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address].MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,length(strAddress));
    // showmessage(strAddress);
    iRow := ExcelApp.ActiveSheet.Range[strAddress].Row;
    iCol := ExcelApp.ActiveSheet.Range[strAddress].Column;
    reHRowEnd.EditText := inttostr(iRow);
    reHColEnd.EditText := inttostr(iCol);
  end else
  begin
  reHRowEnd.EditText := ExcelApp.ActiveCell.Row;
  reHColEnd.EditText := ExcelApp.ActiveCell.Column;
  end;



  if iRow < StrToInt(reHRowStart.EditText) then
  begin
    showmessage('表头选择错误，结束行小于起始行。请重新选择');
    reHRowEnd.EditText := '';
    exit;
  end;
  if iCol < StrToInt(reHColStart.EditText) then
  begin
    showmessage('表头选择错误，结束列小于起始列。请重新选择');
    reHColEnd.EditText := '';
    exit;
  end;
end;


procedure TForm1.RzButton6Click(Sender: TObject);
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  reDRowStart.EditText := ExcelApp.ActiveCell.Row;

end;


procedure TForm1.RzButton71Click(Sender: TObject);
var
  iColumn: integer;
  strAddress: string;
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  iColumn := ExcelApp.ActiveCell.Column;

  // 如果是合并的单元格，那么就要进行拆分
  // 默认的合并单元格的地址是合并区域左上角的单元格地址
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address]
      .MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,
      length(strAddress));
    // showmessage(strAddress);
    iColumn := ExcelApp.ActiveSheet.Range[strAddress].Column;
  end;
  reWellName.EditText := inttostr(iColumn);
end;


procedure TForm1.RzButton7Click(Sender: TObject);
var
 irow:integer;
 straddress:string;
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address].MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,length(strAddress));
    // showmessage(strAddress);
    iRow := ExcelApp.ActiveSheet.Range[strAddress].Row;
    reDRowend.EditText := ExcelApp.ActiveCell.Row;
  end else
    reDRowend.EditText := ExcelApp.ActiveCell.Row;

 end;


procedure TForm1.RzButton8Click(Sender: TObject);
var
  tempi,tempi2:integer;
  ci, thei, num, numind, iRow, iCol: integer;
  strAddr: string;
  mhs, hs, ts, cs, SQL: WideString;
  i: integer;
begin
  if (trim(reHRowEnd.EditText) = '')
    or (trim(reHColStart.EditText) = '')
    or  (trim(reHColEnd.EditText) = '')
    or (trim(reHRowStart.EditText) = '') then
  begin
    showmessage('行列地址信息不全');
    exit;
  end;

  if (trim(EdtScheme.text)='') then
  begin
    showmessage('请输入方案！');
    exit;
  end;

  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, '没有打开文件或者文件已经被关闭，请打开或重新打开文件！', '错误！',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;

  // 删除MapCol中的其它数据防止多次运行带来的数据冗余
  SQL := 'delete MapCol';
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;
  MapCol.Close;
  MapCol.Open;
  MapCol.Edit;

  // 读取字段

  for iCol := StrToInt(reHColStart.EditText) to StrToInt(reHColEnd.EditText) do
  begin
      hs := '';
      ts := '';
      cs := '';
    if not IsThansactHid then   //不处理隐藏的行列
    begin
     if not ExcelApp.ActiveSheet.columns[iCol].Hidden = true then
      begin
        for iRow := StrToInt(reHRowStart.EditText) to StrToInt
          (reHRowEnd.EditText) do
        begin
          application.ProcessMessages;
          // 如果单元格是合并的，则取消合并，填充合并前的值
          // Range("A1:F14").Select
          // Selection.FormulaR1C1 = "a"
          //
          if ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells = true then
          begin
            if IsNumeric(ExcelApp.ActiveSheet.cells[iRow, iCol].Value) then
              mhs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value)
                )
            else
              mhs := trim(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);

            strAddr := ExcelApp.ActiveSheet.Range
              [ExcelApp.ActiveSheet.cells[iRow, iCol].Address].MergeArea.Address;
            // strEAddr:=rightstr(strSAddr,pos(':',strSAddr)-1);
            // strSAddr:=leftstr(strSAddr,pos(':',strSAddr)-1);
            ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells := false;
             ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := mhs;
            mhs := '';
          end;
          cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
          cs := trim(cs);
          if cs = '' then
          begin
            ExcelApp.ActiveSheet.cells[iRow, iCol].Value :=
              ExcelApp.ActiveSheet.cells[iRow - 1, iCol].Value;
            cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
            cs := trim(cs);
          end;
          // 将全角转换为半角
          cs := ToDBC(cs);
          if ts <> cs then
          begin
            ts := cs;
            if IsNumeric(cs) then
            begin
              if hs = '' then
              begin
                hs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                    iCol].Value));
              end
              else
                hs := hs + '|' + trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                    iCol].Value));
            end
            else if hs = '' then
            begin
              hs := trim(cs);
            end
            else
              hs := hs + '|' + trim(cs);
          end;
         // pgBar.Position := pgBar.Position + 1;
          application.ProcessMessages;
        end;

        // 处理非汉字的非x,y
        ci := 1;
        thei := length(hs);
        while ci <= thei do
        begin
          if not((Word(hs[ci]) >= $3447) and (Word(hs[ci]) <= $FA29)) then
          begin
            // showmessage(inttostr(i)+'不是');
            if (uppercase(hs[ci])='T') or (uppercase(hs[ci]) = 'X')or (uppercase(hs[ci]) = 'Y')or (uppercase(hs[ci]) = 'H') or
              (uppercase(hs[ci]) = 'M') or (hs[ci] = '3') then
            begin
              // showmessage(inttostr(i)+ch[i]);
            end
            else
              hs := Stringreplace(hs, hs[ci], ' ', [rfreplaceall]);
            ci := ci + 1;
          end
          else
            ci := ci + 1;
        end;

        hs := Stringreplace(hs, ' ', '', [rfreplaceall]);
        hs := Stringreplace(hs, '管理及运行状态', '', [rfreplaceall]);
        hs := Stringreplace(hs, '注水井日生产情况单位方', '', [rfreplaceall]);
        hs := Stringreplace(hs, '管理及运行情况', '', [rfreplaceall]);
        hs := Stringreplace(hs, '基础数据', '', [rfreplaceall]);
        hs := Stringreplace(hs, '其中', '', [rfreplaceall]);
        if trim(hs)<>'' then
        begin
         MapCol.Append;
         MapCol.FieldByName('xlscolidx').AsInteger := iCol;
        MapCol.FieldByName('XLSColName').AsString := hs;
        MapCol.Post;
        application.ProcessMessages;
        end;
      end;
    end
    else
    begin
        for iRow := StrToInt(reHRowStart.EditText) to StrToInt
          (reHRowEnd.EditText) do
        begin
          application.ProcessMessages;
          // 如果单元格是合并的，则取消合并，填充合并前的值
          // Range("A1:F14").Select
          // Selection.FormulaR1C1 = "a"
          //
          if ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells = true then
          begin
            if IsNumeric(ExcelApp.ActiveSheet.cells[iRow, iCol].Value) then
              mhs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value)
                )
            else
              mhs := trim(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);

            strAddr := ExcelApp.ActiveSheet.Range
              [ExcelApp.ActiveSheet.cells[iRow, iCol].Address].MergeArea.Address;
            // strEAddr:=rightstr(strSAddr,pos(':',strSAddr)-1);
            // strSAddr:=leftstr(strSAddr,pos(':',strSAddr)-1);
            ExcelApp.ActiveSheet.cells[iRow, iCol].MergeCells := false;
             ExcelApp.ActiveSheet.Range[strAddr].FormulaR1C1 := mhs;
            mhs := '';
          end;
          cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
          cs := trim(cs);
          if cs = '' then
          begin
            ExcelApp.ActiveSheet.cells[iRow, iCol].Value :=
              ExcelApp.ActiveSheet.cells[iRow - 1, iCol].Value;
            cs := vartostr(ExcelApp.ActiveSheet.cells[iRow, iCol].Value);
            cs := trim(cs);
          end;
          // 将全角转换为半角
          cs := ToDBC(cs);
          if ts <> cs then
          begin
            ts := cs;
            if IsNumeric(cs) then
            begin
              if hs = '' then
              begin
                hs := trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                    iCol].Value));
              end
              else
                hs := hs + '|' + trim(FloatToStr(ExcelApp.ActiveSheet.cells[iRow,
                    iCol].Value));
            end
            else if hs = '' then
            begin
              hs := trim(cs);
            end
            else
              hs := hs + '|' + trim(cs);
          end;
         // pgBar.Position := pgBar.Position + 1;
          application.ProcessMessages;
        end;

        // 处理非汉字的非x,y
        ci := 1;
        thei := length(hs);
        while ci <= thei do
        begin
          if not((Word(hs[ci]) >= $3447) and (Word(hs[ci]) <= $FA29)) then
          begin
            // showmessage(inttostr(i)+'不是');
            if (uppercase(hs[ci])='T') or (uppercase(hs[ci]) = 'X')or (uppercase(hs[ci]) = 'Y')or (uppercase(hs[ci]) = 'H') or
              (uppercase(hs[ci]) = 'M') or (hs[ci] = '3') then
            begin
              // showmessage(inttostr(i)+ch[i]);
            end
            else
              hs := Stringreplace(hs, hs[ci], ' ', [rfreplaceall]);
            ci := ci + 1;
          end
          else
            ci := ci + 1;
        end;
        //默认处理的无效信息
        hs := Stringreplace(hs, ' ', '', [rfreplaceall]);
        hs := Stringreplace(hs, '管理及运行状态', '', [rfreplaceall]);
        hs := Stringreplace(hs, '注水井日生产情况单位方', '', [rfreplaceall]);
        hs := Stringreplace(hs, '管理及运行情况', '', [rfreplaceall]);
        hs := Stringreplace(hs, '基础数据', '', [rfreplaceall]);
        hs := Stringreplace(hs, '其中', '', [rfreplaceall]);
        if trim(hs)<>'' then
        begin
         MapCol.Append;
         MapCol.FieldByName('xlscolidx').AsInteger := iCol;
         MapCol.FieldByName('XLSColName').AsString := hs;
         MapCol.Post;
         application.ProcessMessages;
        end;
    end;

   end;
 MapCol.Close;
 MapCol.Open;
 AutoMatch(comparefields,mapcol);
 RefreshCompare();


end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
 TDT:string;
begin
  if AppendCompare(edit2.Text,edit1.Text,combobox1.text,adocommand1) then
  begin
   cxComboboxAddItems();
   panel1.Visible:=false;
   mapcol.edit;
   mapcol.FieldByName('dbfielddesc').Value:=edit1.Text;
    if combobox1.Text='数字' then  TDT:='float'
  else if combobox1.Text='日期' then  TDT:='datetime'
  else if combobox1.Text='文字' then  TDT:='varchar(150)';
   mapcol.FieldByName('dbfieldname').Value:=edit2.Text;
   mapcol.FieldByName('datatype').Value:=TDT;

   mapcol.Post;
  end else
   exit;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'OPEN', PChar(GetCurrentDir+'\11sql.udl'),'', '', SW_SHOWNORMAL);
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 try
    adoconnection1.Close;
    adoconnection1.Open();
    showmessage('配置完成');
 except on exception do
  if  messagebox(handle,'172.20.0.11上的SQLSERVER连接有变','远程连接出错',MB_ICONWARNING+MB_OKCANCEL)=idok then
  ShellExecute(Application.Handle, 'OPEN', PChar(GetCurrentDir+'\11sql.udl'),'', '', SW_SHOWNORMAL);

 end;
end;

procedure TForm1.xp1Click(Sender: TObject);
begin
 SkinData1.LoadFromCollection(SkinStore1,(sender as tmenuitem).Tag);
end;

end.
