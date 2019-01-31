unit Main;

interface

uses
  Windows, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, RzPanel, StdCtrls, RzLabel, RzButton, RzRadChk,
  Mask, RzEdit, RzTabs,DB,UOrderSystem,
  cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ComObj, cxDropDownEdit, strutils,
  ADODB, DBGrids, RzDTP, IniFiles,
  UorderAccess,UOrderFile,UOrderExcel,UOrderString,cxShellTreeView, cxSplitter,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinsDefaultPainters, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, ShlObj, cxShellCommon, cxContainer, Grids,
  cxClasses, cxGridCustomView, ExtCtrls, Buttons, Menus;

type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;

  TfrmMain = class(TForm)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    RzGroupBox1: TRzGroupBox;
    RzLabel2: TRzLabel;
    RzButton1: TRzButton;
    RzGroupBox2: TRzGroupBox;
    TabSheet2: TRzTabSheet;
    odFile: TOpenDialog;
    RzGroupBox3: TRzGroupBox;
    chkFront: TRzCheckBox;
    odDataBase: TOpenDialog;
    grdCol: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    adoConn: TADOConnection;
    tblCol: TADOTable;
    tblField: TADOTable;
    tblsheet: TADOTable;
    qryCus: TADOQuery;
    tblSchema: TADOTable;
    dsCol: TDataSource;
    GroupBox1: TGroupBox;
    RzButton5: TRzButton;
    reHColEnd: TRzEdit;
    reHRowEnd: TRzEdit;
    RzButton3: TRzButton;
    reHColStart: TRzEdit;
    reHRowStart: TRzEdit;
    reDRowStart: TRzEdit;
    RzButton6: TRzButton;
    reDRowEnd: TRzEdit;
    RzButton7: TRzButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    RzButton9: TRzButton;
    RzButton20: TRzButton;
    RzButton19: TRzButton;
    pgBar: TProgressBar;
    RzButton15: TRzButton;
    RzButton2: TRzButton;
    RzButton8: TRzButton;
    TabSheet3: TRzTabSheet;
    ADOCommand1: TADOCommand;
    lblRow: TRzLabel;
    lblSheet: TRzLabel;
    dstemp: TDataSource;
    ADOtemp: TADOQuery;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    DBGrid1: TDBGrid;
    GroupBox5: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    tblWell: TADOTable;
    RzDateTimePicker1: TRzDateTimePicker;
    RzEdit11: TRzEdit;
    RzLabel15: TRzLabel;
    GroupBox6: TGroupBox;
    Button3: TButton;
    lblDelInfo: TRzLabel;
    Button5: TButton;
    Button4: TButton;
    TabSheet4: TRzTabSheet;
    GroupBox7: TGroupBox;
    cxShellTreeView1: TcxShellTreeView;
    ListBox1: TListBox;
    GroupBox8: TGroupBox;
    Button7: TButton;
    Button6: TButton;
    tblLog: TADOTable;
    Button8: TButton;
    cxSplitter1: TcxSplitter;
    cmbSchema: TComboBox;
    grdColSchemaNo: TcxGridDBColumn;
    grdColSheetName: TcxGridDBColumn;
    grdColHeadStartColumn: TcxGridDBColumn;
    grdColHeadEndColumn: TcxGridDBColumn;
    grdColHeadStartRow: TcxGridDBColumn;
    grdColHeadEndRow: TcxGridDBColumn;
    grdColDataStartColumn: TcxGridDBColumn;
    grdColDataEndColumn: TcxGridDBColumn;
    cxGrid3: TcxGrid;
    cxgrdbtblvw1: TcxGridDBTableView;
    grdColXLSColName: TcxGridDBColumn;
    grdColXLSColIdx: TcxGridDBColumn;
    grdColDBFieldDesc: TcxGridDBColumn;
    grdColDBFieldName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    RzButton17: TRzButton;
    RzButton16: TRzButton;
    reWellName: TEdit;
    lbl1: TLabel;
    adosheet: TADOQuery;
    dssheet: TDataSource;
    RzCheckBox1: TRzCheckBox;
    rzFilterString: TMemo;
    RzCheckBox2: TRzCheckBox;
    pnl1: TPanel;
    btn1: TSpeedButton;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    cbb1: TComboBox;
    edt1: TEdit;
    edt2: TEdit;
    RzButton24: TRzButton;
    ComboBox2: TComboBox;
    Label9: TLabel;
    tblCustData: TADOTable;
    tblColXLSColName: TWideStringField;
    tblColXLSColIdx: TIntegerField;
    tblColDBFieldDesc: TWideStringField;
    tblColDBFieldName: TWideStringField;
    tblColDataType: TWideStringField;
    cxgrdbtblvw1Column1: TcxGridDBColumn;
    btn2: TButton;
    MMsql: TMemo;
    pm1: TPopupMenu;
    Config1: TMenuItem;
    N1: TMenuItem;
    procedure RzButton1Click(Sender: TObject);
    procedure RzButton8Click(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
    procedure RzButton3Click(Sender: TObject);
    procedure RzButton4Click(Sender: TObject);
    procedure RzButton5Click(Sender: TObject);
    procedure RzButton6Click(Sender: TObject);
    procedure RzButton7Click(Sender: TObject);
    procedure chkFrontClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdColDBFieldDescPropertiesChange(Sender: TObject);
    procedure RzButton9Click(Sender: TObject);
    procedure RzButton14Click(Sender: TObject);
    procedure RzButton71Click(Sender: TObject);
    procedure RzButton15Click(Sender: TObject);
    procedure RzButton17Click(Sender: TObject);
    procedure RzButton16Click(Sender: TObject);
    procedure RzButton19Click(Sender: TObject);
    procedure RzButton20Click(Sender: TObject);
    procedure RzButton24Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cmbSchemaChange(Sender: TObject);
    procedure reHRowStartChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
   procedure DelGoOnData(var xIsGoOn:boolean);
    function StatisticialSheet(filename:string=''):Tstringlist;
    procedure Button8Click(Sender: TObject);
    procedure reHRowEndChange(Sender: TObject);
    procedure RzCheckBox1Click(Sender: TObject);
    procedure RzCheckBox2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure cxComboboxAddItems;
    procedure ComboBox2Change(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    isok,bNewSchema: boolean;
    sFileName: string;
    arrFieldMap: array of FieldMap;
    bStopFlag: boolean;
    procedure CloseExcel();
    function IsNumeric(AStr: string): boolean;
    function IsSchema(sheetname: string): Boolean;
    function ToDBC(input: String): WideString;
    function IsMBCSChar(const ch: Char): boolean;
    procedure log();
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
   schemaindex,TheRunRowNumber,fileindex,newtableIndex: integer;
  slWellName: TStringList;
  Myexcel:TExcel;
  myINI: TiniFile;
  xlsfilelist:tstringlist;
   GoOn,SingleSheet,IsNewTable,FindSingle:boolean;
   //如果程序正在处理文件而关闭,可能会造成数据冗余
   IsGoOn,Righttable:boolean;
   NewTablename:string;

implementation

{$R *.dfm}


procedure TfrmMain.DelGoOnData(var xIsGoOn:boolean);
var
 sql:string;
begin
  try
   if xIsGoOn then
  begin
   SQL := 'delete * from  '+ComboBox2.Text+' where inputdate=#'+trim(datetostr(frmmain.RzDateTimePicker1.Date))+'# and DEPNAME='+quotedstr(cmbSchema.Text);
   adocommand1.CommandText:=sql;
   adocommand1.Execute;
   xIsGoOn:=false;
  end else
   exit;
  except on E: Exception do
   Exit;
  end;
end;

procedure TfrmMain.log();
begin
    //记录日志
  if not tblLog.Active then tblLog.Open;
  tblLog.Append;
  tblLog.FieldByName('LogDate').AsDateTime:=now;
  tblLog.FieldByName('Opt').AsString:='获取数据';
  tblLog.FieldByName('SelDate').AsDateTime:=strtodate(formatdatetime('YYYY-MM-DD',RzDateTimePicker1.Date));
  tblLog.FieldByName('BookName').AsString:=sFileName;
  tblLog.FieldByName('SheetName').AsString:=lblSheet.Caption;
  tblLog.FieldByName('RowCount').AsInteger:=StrToInt(reDRowEnd.EditText)-strtoint(reDRowStart.EditText);
  tblLog.Post;
end;

procedure TfrmMain.N1Click(Sender: TObject);
var
 tempi:Integer;
begin
 tempi:=ListBox1.ItemIndex;
 while ListBox1.Items.Count-1>tempi do
       ListBox1.Items.Delete(ListBox1.Items.Count-1);
 myINI.Writeinteger('处理文件', '值', listbox1.Items.Count);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if assigned(myexcel) then myexcel.Close ;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//defalut is process one Excel  is MultiSheets on Excel
  IniDateFormat(true);
  Righttable:=false;
  GoOn:=false;
  SingleSheet:=False;
  cxgrdbtblvw1.OptionsView.ColumnAutoWidth := True;
   myINI := TiniFile.Create(ExtractFilePath(application.EXEName)
      + '\config.ini');
  RzEdit11.EditText := myINI.ReadString('整理人', '姓名', '');
 // ShowMessage(rzFilterString.text);
  rzFilterString.text:= myINI.ReadString('无效信息', '值', '');
  combobox2.Text:=myINI.ReadString('目标表名', '值','');
  cmbSchema.text := myINI.ReadString('方案', '值','');
  if myINI.ReadInteger('处理文件', '值',-1)>myINI.ReadInteger('已处理', '索引',-1)+1 then
  begin
   cxShellTreeView1.Path:= myINI.ReadString('文件夹', '路径', '');
  end;
  //
  RzButton24Click(self);
end;

procedure TfrmMain.grdColDBFieldDescPropertiesChange(Sender: TObject);
var
  curVal: string;
begin
  curVal := tblCol.FieldByName('DBFieldDesc').AsString;

  if curVal = '' then
  begin
    tblCol.Edit;
    tblCol.FieldByName('DBFieldName').AsString := '';
    tblCol.Post;
  end
  else
  if trim(curVal) = '新增' then
  begin
    pnl1.Visible:=true;
    tblCol.Edit;
    tblCol.FieldByName('DBFieldName').AsString := '';
    tblCol.Post;
  end
  else
  begin
    tblField.Filter := 'FieldDesc=''' + curVal + '''';
    tblField.Filtered := true;
    tblCol.Edit;
    tblCol.FieldByName('DBFieldName').AsString := tblField.FieldByName
      ('FieldName').AsString;
    tblCol.FieldByName('datatype').AsString := tblField.FieldByName
      ('datatype').AsString;
    tblCol.Post;
  end

end;

procedure TfrmMain.RzButton14Click(Sender: TObject);
begin
  exit;
  qryCus.SQL.Text := 'delete from WellBaseInfo';
  qryCus.ExecSQL;
//  tblData.Close;
//  tblData.Open;
end;

procedure TfrmMain.RzButton15Click(Sender: TObject);
var
  n,i: integer;
  isok: boolean;
begin
  // 自动匹配
  isok := true;
  tblField.Open;
  tblField.Filtered := false;
  tblCol.First;

  while not tblCol.eof do
  begin
    if tblField.Locate('XlsColName', tblCol.FieldByName('XlsColName').AsString,
      [loCaseInsensitive, loPartialKey]) then
    begin
      tblCol.Edit;
      tblCol.FieldByName('DBFieldDesc').AsString := tblField.FieldByName
        ('FieldDesc').AsString;
      tblCol.FieldByName('DBFieldName').AsString := tblField.FieldByName
        ('FieldName').AsString;
      tblCol.Post;
      tblCol.Next;
    end
    else
    begin
      if trim(tblCol.FieldByName('XlsColName').AsString) = '含水' then
        isok := true
      else
        isok := false;
      tblCol.Edit;
      tblCol.FieldByName('DBFieldDesc').AsString := '';
      tblCol.FieldByName('DBFieldName').AsString := '';
      tblCol.Post;
      tblCol.Next;
    end;
  end;

  //判断井名(可以是井名,也可以是新井名)是什么 匹配
  n:=0;
  tblCol.First;
  while not tblCol.eof do
  begin
    if trim(tblCol.FieldByName('DBFieldDesc').AsString)='井名' then
       n:=n+1;
      tblCol.Next;
  end;
  if n>=2 then
  begin
   if  tblcol.Locate('XlsColName','原',[loPartialKey])or tblcol.Locate('XlsColName','旧',[loPartialKey])or tblcol.Locate('XlsColName','老',[loPartialKey]) then
   begin
       if not tblcol.Locate('XlsColName','井名',[loPartialKey]) then  tblcol.Locate('XlsColName','井号',[loPartialKey]);
      tblCol.Edit;
      tblCol.FieldByName('DBFieldDesc').AsString := '井名';
      tblCol.FieldByName('DBFieldName').AsString := 'WELLNAME';
      tblCol.Post;
      tblCol.Next;
   end else
   begin
       if not tblcol.Locate('XlsColName','井名',[loPartialKey]) then  tblcol.Locate('XlsColName','井号',[loPartialKey]);
      tblCol.Edit;
      tblCol.FieldByName('DBFieldDesc').AsString := '旧井名';
      tblCol.FieldByName('DBFieldName').AsString := 'WELLNAMEA';
      tblCol.Post;
      tblCol.Next;
   end;
  end;

  if isok = false then
  begin
    showmessage('自动匹配未完成,请手动匹配');
            myINI.WriteString('未处理信息'+datetimetostr(now),'文件名称', sFileName);
  end
  else  //如果匹配完成就开始获取数据
 if GoOn then
 rzbutton2Click(self);
end;

procedure TfrmMain.RzButton16Click(Sender: TObject);
var
 tempi,iIdx: integer;
label Pre;
begin
   pre:
    if Myexcel.IslastSheet or FindSingle then Exit;
    Myexcel.NextSheet;
    lblSheet.Caption := Myexcel.SheetName;

    if SingleSheet then
    begin
      if GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'ProcessSheetName')<>Myexcel.SheetName then
      begin
       FindSingle:=false;
       goto Pre;
      end else
      begin
       FindSingle:=True;
      end;
    end else
    if GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'stopsheetname')=Myexcel.SheetName then
    begin
     Exit;
    end;
    Isschema(Myexcel.SheetName);
      if GoOn then
    Button3Click(self);


end;

procedure TfrmMain.RzButton17Click(Sender: TObject);

begin
  Myexcel.PreviousSheet;
  lblSheet.Caption := Myexcel.SheetName;
  Isschema(Myexcel.SheetName);
    if SingleSheet then
     if GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'ProcessSheetName')<>Myexcel.SheetName then
     begin
       FindSingle:=false;
     end else
     FindSingle:=true;

end;

procedure TfrmMain.RzButton19Click(Sender: TObject);
begin
  reDRowStart.EditText := inttostr(TheRunRowNumber);
  bStopFlag := true;
end;

procedure TfrmMain.RzButton1Click(Sender: TObject);
begin
  if (bNewSchema = false) and (cmbSchema.ItemIndex = -1) then
  begin
    showmessage('选择一个采油厂！');
    exit;
  end;
 if assigned(myexcel) then myexcel.Close ;
  myexcel:=texcel.create();
  lblSheet.Caption:=myexcel.sheetname;
  FindSingle:=False;
 try
    RzDateTimePicker1.Date:=getdate(myexcel.ExcelFileName);
    Isschema(Myexcel.SheetName);
    if GoOn then
    Button3Click(self);
    Self.Refresh;
  except on E:exception do
  begin
     ShowMessage(e.Message);
  end;
 end;
end;

procedure TfrmMain.RzButton20Click(Sender: TObject);
begin
  bStopFlag := false;
  RzButton2Click(self);
end;

procedure TfrmMain.RzButton24Click(Sender: TObject);
var
  sDBFileName: string;
  sFieldName: string;
begin
  // 关闭数据连接
  adoConn.Connected := false;
  tblCol.Close;
  tblSchema.Close;
  sDBFileName := ExtractFilePath(application.EXEName) + 'Data\Eirc2010.mdb';

  self.Caption := sDBFileName;
  adoConn.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Password="";' +
    'User ID=Admin;Data Source=' + sDBFileName + ';' +
    'Mode=Share Deny None;Extended Properties="";Persist Security Info=True;' +
    'Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";'
    +
    'Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;' + 'Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";' + 'Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;' + 'Jet OLEDB:Don''t Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;' + 'Jet OLEDB:SFP=False';
  adoConn.Connected := true;

  // 向油井名称字符串列表中添加井名称，放在内存中是为了提高查询速度
  ComboboxAddItems(tblSchema,'SchemaName',cmbSchema);
  ComboboxAddTablename(ADOtemp,ComboBox2);
  tblWell.Open;
  tbllog.Open;
  slWellName := TStringList.Create;
  tblWell.First;
  while not tblWell.eof do
  begin
    slWellName.add(tblWell.FieldByName('WellName').AsString);
    tblWell.Next;
  end;
  slWellName.Sort;
  tblWell.Close;

  // cxgrid列添加 fielddesc信息  －－－－－－－－
  cxComboboxAddItems();
  frmmain.Refresh;
  tblCol.Open;
end;

procedure TfrmMain.RzButton2Click(Sender: TObject);
var
  sIns, sVal, curValue, tmpCurValue, strAddress: string;
  tttt,En: string;
  iRow, iRowStart,icolend,icolstart, iRowEnd, iCol, iMcol, iPos, iCurSheet, ICHK, iSel: integer;
begin
 if not Righttable then
 begin
    if SingleSheet and (trim(ComboBox2.Text)<>'DBZhuShui') then
    begin
      if messagebox(self.Handle,'注水数据的要迁移到 DBZhuShui中','Are you sure?',MB_YESNO+MB_ICONQUESTION)=IDno then exit;
    end else
    if not singlesheet and (trim(ComboBox2.Text)<>'WellDayProd') then
    begin
      if messagebox(self.Handle,'液量数据的要迁移到 WellDayProd中','Are you sure?',MB_YESNO+MB_ICONQUESTION)=IDno then exit;
    end;
    Righttable:=true;
 end;




  if (trim(reHRowEnd.EditText) = '') or (trim(reHColStart.EditText) = '') or
    (trim(reHColEnd.EditText) = '') or (trim(reDRowStart.EditText) = '') or
    (trim(reDRowEnd.EditText) = '')
  // or (trim(reWellName.EditText)='')
    or (trim(reHRowStart.EditText) = '') then
  begin
    showmessage('行列地址信息不全');
    exit;
  end;
  if cmbSchema.ItemIndex = -1 then
  begin
    showmessage('选择一个大队！');
    exit;
  end;

    if Myexcel.IslastSheet  then Exit;
    if SingleSheet and (not FindSingle) then Exit;

    if (not SingleSheet) and (GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'stopsheetname')=Myexcel.SheetName) then
    begin
     Exit;
    end;
  // 刷新对照信息
  RzButton9Click(self);
  ComboBox2Change(Self);
 if (IsNewTable and (combobox2.Text=Newtablename)) then
 begin
  try
    craetetable(combobox2.Text,tblcol,adocommand1);
    tblCustData.TableName:=ComboBox2.Text;
    IsNewTable:=false;
  except on E: Exception do
    IsNewTable:=True;
  end;
 end
 else
 AlterTable(tblcol,tblCustData,adocommand1);

  tblCustData.Open;

  iRowStart := StrToInt(reDRowStart.EditText);
  iRowEnd := StrToInt(reDRowEnd.EditText);
  iColStart := StrToInt(reHColStart.EditText);
  iColEnd := StrToInt(reHColEnd.EditText);
  pgBar.Max :=iRowEnd - iRowStart;
  pgBar.Min := 0;
  pgBar.Position := 0;

  for icol :=arrFieldMap[0].ColIndex to length(arrFieldMap)-1 do
  Myexcel.teiLenFull(icol);


  try
  // 开始获取
  for iRow := iRowStart to iRowEnd do
  begin
   try

    lblRow.Caption:='正在获取'+inttostr(irow)+'行';
    application.ProcessMessages;
      sIns := 'INSERT INTO '+tblCustData.TableName+' (';
      sVal := ' VALUES (';

      ICHK := 0;
      iSel := 0;

      sIns := sIns + 'INPUTDATE';
      sVal := sVal + '''' + formatdatetime('YYYY-MM-DD',RzDateTimePicker1.Date) + '''';

      sIns := sIns + ',DEPNAME';
      sVal := sVal + ',''' + cmbSchema.Text + '''';

      sIns := sIns + ',USERNAME';
      sVal := sVal + ',''' + trim(RzEdit11.EditText) + '''';

      sIns := sIns + ',BiaoGeMingCheng';
      sVal := sVal + ',''' + trim(lblSheet.Caption) + '''';

      // 获取匹配的数据列数据
      for iCol := 0 to length(arrFieldMap) - 1 do
      begin
        application.ProcessMessages;
        // 如果是合并单元格，那么要进行处理
         curValue:=Myexcel.GetValue(iRow,arrFieldMap[iCol].ColIndex);
        // 如果是井名所在的列
        if (arrFieldMap[iCol].ColIndex = StrToInt(reWellName.Text)) then
        begin
         curValue:=Myexcel.GetValue(iRow,arrFieldMap[iCol].ColIndex,True);
          // 是否找到了匹配的标准井名
          if slWellName.Find(curValue, iPos) then
          begin
            sIns := sIns + ',WELLNAMEC';
            sVal := sVal + ',''' + curValue + '''';
            ICHK := 1;
          end
          else // 如果不匹配，那么
          begin
            tmpCurValue := curValue;
            // 将全角字符转换为半角字符
            tmpCurValue := ToDBC(tmpCurValue);
            if (rightstr(tmpCurValue, 1) = '#') or
              (rightstr(tmpCurValue, 1) = '井') then
            begin
              tmpCurValue := LeftStr(tmpCurValue, length(tmpCurValue) - 1);
            end;
            // 保存并显示整理后的油井名称
            sIns := sIns + ',WELLNAMEB';
            sVal := sVal + ',''' + tmpCurValue + '''';
            // 再次查找匹配井名
            if slWellName.Find(tmpCurValue, iPos) then
            begin
              sIns := sIns + ',WELLNAMEC';
              sVal := sVal + ',''' + tmpCurValue + '''';
              ICHK := 1;
            end
          end;
          //
          sIns := sIns + ',' + arrFieldMap[iCol].FieldName;
          if (curvalue='Null') or (curvalue='') then
           sVal := sVal + ','+ 'Null'
          else
           sVal := sVal + ',''' + curValue + '''';
        end
        else
        begin
          sIns := sIns + ',' + arrFieldMap[iCol].FieldName;
          case tblCustData.FieldByName(arrFieldMap[iCol].FieldName).DataType of
            ftWideString, ftString, ftDate:
              begin
                if (curvalue='Null') or (curvalue='') then
                 sVal := sVal + ','+ 'Null'
                else
                 sVal := sVal + ',''' + curValue + '''';
              end;
            ftCurrency, ftWord, ftFloat, ftSingle:
              begin
                if IsNumeric(curValue) = false then
                 sVal := sVal + ','+ 'Null'
                else
                sVal := sVal + ',' + FormatFloat('#0.000',
                  strtofloat(curValue));
              end;
            ftSmallint, ftLargeint, ftInteger:
              begin
                if IsNumeric(curValue) = false then
                  curValue := '0';
                sVal := sVal + ',' + curValue;
              end;
          else
            begin
              sVal := sVal + ',-1';
            end;
          end;
        end;

//          if (curvalue='Null') or (curvalue='') then
//           sVal := sVal + ','+ 'Null'
//          else
//           sVal := sVal + ',''' + curValue + '''';
      end;

      sIns := sIns + ',ICHK';
      sVal := sVal + ',' + inttostr(ICHK);

      sIns := sIns + ',iSel) ';
      sVal := sVal + ',' + inttostr(iSel) + ')';

      qryCus.SQL.Text := sIns + ' ' + sVal;
      qryCus.ExecSQL;
      pgBar.Position := pgBar.Position + 1;
   except
      en:=en+'; '+inttostr(irow)+'行'+inttostr(icol)+'列';
     // showmessage(inttostr(irow)+'行'+inttostr(icol)+'列');
      pgBar.Position := pgBar.Position + 1;
      Continue;
   end;
  end;
  //nest sheet
   pgBar.Position := 0;
    if SingleSheet then FindSingle:=True;
    if GoOn then
   rzbutton16Click(self) ;
 except
  on e:exception  do
  begin
    myINI.WriteString('未处理信息(获取数据时出错)'+datetimetostr(now),'文件名称', sFileName+myexcel.SheetName+en);
  end;
 end;
end;

procedure TfrmMain.RzButton3Click(Sender: TObject);
begin
  reHRowStart.EditText := IntToStr(Myexcel.currow);
  reHColStart.EditText := IntToStr(Myexcel.curcol);
end;

procedure TfrmMain.RzButton4Click(Sender: TObject);
begin

  // grddata.ClearItems;
  //grdData.ApplyBestFit();
end;

procedure TfrmMain.RzButton5Click(Sender: TObject);
begin
  reHRowEnd.EditText := IntToStr(myexcel.currow(true));
  reHColEnd.EditText := IntToStr(Myexcel.curcol(true));
end;

procedure TfrmMain.RzButton6Click(Sender: TObject);
begin
  reDRowStart.EditText :=IntToStr(myexcel.currow);
  //删除无效数据
//   button3click(self);
//  //获取表头
//   rzbutton8click(self);
end;

procedure TfrmMain.RzButton71Click(Sender: TObject);
begin
  reWellName.Text := inttostr(myexcel.curcol(True));
end;

procedure TfrmMain.RzButton7Click(Sender: TObject);
begin
  reDRowEnd.EditText := inttostr(myexcel.currow(True));
end;

procedure TfrmMain.RzButton8Click(Sender: TObject);
var
  ci, thei, num, numind, iRow, iCol: integer;
  strAddr: string;
  mhs, hs, ts, cs, SQL: WideString;
  i: integer;
begin
  if (trim(reHRowEnd.EditText) = '') or (trim(reHColStart.EditText) = '') or
    (trim(reHColEnd.EditText) = '') or (trim(reDRowStart.EditText) = '')
    then
  begin
    showmessage('行列地址信息不全');
    exit;
  end;
  // 删除tblcol中的其它数据防止多次运行带来的数据冗余
  SQL := 'delete *from MapCol';
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;
  tblCol.Close;
  tblCol.Open;
  tblCol.Edit;

  // 读取字段
 Myexcel.GetHeader(StrToInt(reHRowStart.Text),StrToInt(reHColStart.Text),StrToInt(reHRowEnd.Text),StrToInt(reHColEnd.Text),tblcol);
  // 自动匹配列
 //RzButton15Click(self);
  AutoMatch(tblField,tblCol);
 if GoOn then
 rzbutton2Click(self);
end;

procedure TfrmMain.btn1Click(Sender: TObject);
var
 TDT:string;
begin
  if AppendCompare(edt2.Text,edt1.Text,cbb1.text,adocommand1) then
  begin
   cxComboboxAddItems();
   pnl1.Visible:=false;
   tblCol.edit;
   tblCol.FieldByName('dbfielddesc').Value:=edt1.Text;
    if cbb1.Text='数字' then  TDT:='float'
  else if cbb1.Text='日期' then  TDT:='datetime'
  else if cbb1.Text='文字' then  TDT:='varchar(150)';
   tblCol.FieldByName('dbfieldname').Value:=edt2.Text;
   tblCol.FieldByName('datatype').Value:=TDT;

   tblCol.Post;
  end else
   exit;end;

procedure TfrmMain.btn2Click(Sender: TObject);
begin
   if (IsNewTable and (combobox2.Text=Newtablename)) then
 begin
  IsNewTable:=false;
  showmessage('是新表');
 end
 else
  showmessage('不是新表');
end;

procedure TfrmMain.btn3Click(Sender: TObject);
begin
  ADOtemp.Edit;
  ADOtemp.Delete;
  ADOtemp.Post;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
 sql:string;
begin

  ADOtemp.Close;
  ADOtemp.SQL.Clear;
  ADOtemp.SQL.add(MMsql.Text);
  ADOtemp.Open;
 // adotemp.ApplyBestFit();
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  sFieldName,SQL: string;

begin
//  //备份对照表
//  SQL := 'delete * from comparefieldsBackup';
//  ADOCommand1.CommandText := SQL;
//  ADOCommand1.Execute;
//  SQL := 'insert into comparefieldsBackup select * from comparefields';
//  ADOCommand1.CommandText := SQL;
//  ADOCommand1.Execute;
//
  SQL := MMsql.Text;

  tblField.Filtered:=false;

  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;
  RzButton24Click(self);

  showmessage('i do');

end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  iSheet: integer;
begin
    if  not SingleSheet then
　　if GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'stopsheetname')=Myexcel.SheetName then
      exit;
    if cmbSchema.ItemIndex=-1 then
    begin
    showmessage('选择一个方案！');
    Exit;
    end;
    if trim(rzFilterString.text)='' then
    begin
    showmessage('没有输入过滤条件！');
    Exit;
    end;
    Isschema(Myexcel.SheetName);
    lblDelInfo.Caption:='开始清除...';
    if reDRowStart.Text<>'Null' then
    begin
      myexcel.showall:=true;
      myexcel.ShowAllRC:=true;
      myexcel.DelSpecialRow(trim(rzFilterString.text),0,StrToInt(reDRowStart.Text));
      reDRowEnd.EditText :=inttostr(myexcel.maxrow);
      lblDelInfo.Caption:='清除完毕！';
      //获取表头信息
      if GoOn then
      RzButton8Click(self);
    end else
    ShowMessage('请制定表头信息');
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  myINI.WriteString('整理人', '姓名', RzEdit11.EditText);
  myINI.WriteString('无效信息', '值', stringreplace(rzFilterString.text,' ','',[rfreplaceall]));
  myINI.WriteString('目标表名', '值', combobox2.Text);
  myINI.WriteString('方案','值',cmbSchema.text);

  if  (trim(reHRowEnd.EditText) = '')
   or (trim(reHColStart.EditText) = '')
   or (trim(reHColEnd.EditText) = '')
   or (trim(reHRowStart.EditText) = '') then
  begin
    showmessage('行列地址信息不全');
    exit;
  end;

  cmbSchemaChange(Self);

  if tblsheet.Active=False then tblsheet.Open;
  tblsheet.Append;
  tblsheet.FieldByName('HeadStartRow').Value:=reHRowStart.Text;
  tblsheet.FieldByName('HeadEndRow').Value:=reHRowEnd.Text;
  tblsheet.FieldByName('HeadEndColumn').Value:=reHColEnd.Text;
  tblsheet.FieldByName('HeadStartColumn').Value:=reHColStart.Text;
  tblsheet.FieldByName('Sheetname').Value:=Myexcel.SheetName;
  tblsheet.FieldByName('schemano').Value:=schemaindex;
  tblsheet.Post;


end;

procedure TfrmMain.Button5Click(Sender: TObject);
var
  SQL: string;

begin

  //通过审核的
  SQL := 'INSERT INTO WellDayProdComp SELECT * FROM WellDayProd WHERE WellDayProd.ICHK=True';
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;

  //没有通过审核的
  SQL := 'INSERT INTO WellDayProdNoComp SELECT * FROM WellDayProd WHERE WellDayProd.ICHK=False';
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;

  //删除表中的数据
  SQL := 'DELETE FROM WellDayProd';
  ADOCommand1.CommandText := SQL;
  ADOCommand1.Execute;

  showmessage('i do');

end;

procedure TfrmMain.Button6Click(Sender: TObject);
var
 sql:string;
begin
 listbox1.Items:=MakeFileList(cxShellTreeView1.Path,'.xls');
  if myINI.ReadString('文件夹', '路径', '')<>cxShellTreeView1.Path then
  begin
    myINI.WriteString('文件夹', '路径', cxShellTreeView1.Path);
    myINI.Writeinteger('处理文件', '值', listbox1.Items.Count);
        fileindex:=0;
    IsGoOn:=false;
  end else
  begin
   if myINI.ReadInteger('处理文件', '值',-1)>myINI.ReadInteger('已处理', '索引',-1)+1 then
   begin
    fileindex:=myINI.ReadInteger('已处理', '索引',-1)+1;
    IsGoOn:=true;
   end
   else
    fileindex:=0;
  end;
//  (sender as tbutton).Enabled:=false;
 if listbox1.Items.Count<1 then
    Button7.Enabled:=false else
    button7.Enabled:=true;
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
 NameL,ci,n,ifile:integer;
 fname:string;
begin
  GoOn:=True;
  if listbox1.Items.Count<1 then exit;
     n:=0;
    for iFile := fileindex to listbox1.Items.Count - 1 do
    begin
     self.Caption:='正在处理'+inttostr(listbox1.Items.Count)+'中的第'+inttostr(ifile+1)+'个文件';
     if cmbSchema.ItemIndex = -1 then
     begin
      showmessage('选择一个采油厂！');
      exit;
     end;
     sFileName := listbox1.Items.Strings[ifile];
    listbox1.Selected[ifile]:=true;
    if assigned(myexcel) then myexcel.Close ;
    myexcel:=texcel.create(sFileName);
    lblSheet.Caption:=myexcel.sheetname;
    application.ProcessMessages;
    try
      RzDateTimePicker1.Date:=getdate(myexcel.ExcelFileName);
      Isschema(Myexcel.SheetName);
      //删除无效信息
      DelGoOnData(IsGoOn);
    if SingleSheet then
    begin
      FindSingle:=False;
      if GetValueByOtherField(tblSchema,'schemano',IntToStr(schemaindex),'ProcessSheetName')<>Myexcel.SheetName then
       RzButton16Click(self);
    end else
    Button3Click(Self);
    except on e:exception do
    begin
      showmessage(e.Message);
      myINI.WriteString('未处理信息(获取时间错误)'+datetimetostr(now),'文件名称', sFileName+myexcel.SheetName);
      continue;
    end;
    end;
      n:=n+1;
      myINI.WriteInteger('已处理', '索引',ifile);
  end;
  showmessage('处理了'+inttostr(listbox1.Items.Count)+'中的'+inttostr(n)+'个文件  '+'没有处理的文件请查看.ini文件');;
  button7.Enabled:=true;
  button6.Enabled:=true;
  listbox1.Items.Clear;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
begin
    StatisticialSheet;
end;

procedure TfrmMain.chkFrontClick(Sender: TObject);
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

procedure TfrmMain.CloseExcel();
begin
  // 如果打开了Excel，那么退出的时候要关闭文档和程序。
  if not VarIsEmpty(ExcelApp) then
  begin
    try
    //放弃存盘
      ExcelApp.ActiveWorkBook.Saved := true;
      ExcelApp.DisplayAlerts := true;
      ExcelApp.WorkBooks.Close;
      ExcelApp.quit;
      ExcelApp := Unassigned;
      VarClear(ExcelApp);
    except
      on e: exception do
        showmessage(e.message);
    end;
  end;

end;

procedure TfrmMain.cmbSchemaChange(Sender: TObject);
var
 sql:string;
begin
  schemaindex:=GetValueByOtherField(tblSchema,'SchemaName',cmbSchema.text,'SchemaNo');
  sql:='select * from mapsheets where schemano='+inttostr(schemaindex);
  if  adosheet.Active then adosheet.Close;
   adosheet.SQL.Clear;
   adosheet.SQL.Add(sql);
   adosheet.Open;
end;

procedure TfrmMain.ComboBox2Change(Sender: TObject);
var
 i:Integer;
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
   newtableIndex:=ComboBox2.Items.Count-1;
   ComboBox2.ItemIndex:=newtableIndex;
    end
   else if trim(combobox2.Text)<>'' then
   begin
     tblCustData.Close;
     tblCustData.TableName:=combobox2.Text;
   end;

end;

procedure TfrmMain.Config1Click(Sender: TObject);
begin
 fileindex:=listbox1.ItemIndex;
end;

procedure TfrmMain.cxComboboxAddItems;
var
  sDBFileName: string;
  sFieldName: string;
begin
  tblField.Close;
if not tblField.Active then tblField.Open;
  tblField.First;
  (grdColDBFieldDesc.Properties as TcxComboBoxProperties).Items.Clear;
  (grdColDBFieldDesc.Properties as TcxComboBoxProperties).Items.add('');
  while not tblField.eof do
  begin
    if (trim(tblField.FieldByName('xlscolname').AsString) = '') then
    begin
      sFieldName := tblField.FieldByName('fielddesc').AsString;
      (grdColDBFieldDesc.Properties as TcxComboBoxProperties)
      .Items.add(sFieldName);
    end;
    tblField.Next;
  end;
  (grdColDBFieldDesc.Properties as TcxComboBoxProperties).Items.Add('新增');
end;

// 判断是否数字
function TfrmMain.IsNumeric(AStr: string): boolean;
var
  Value: Double;
  Code: integer;
begin
  Val(AStr, Value, Code);
  Result := Code = 0;
end;

function TfrmMain.IsSchema(sheetname: string): Boolean;
begin

 cmbSchemaChange(self);
 try
  reHRowStart.Text:=GetValueByOtherField(adosheet,'SheetName',Myexcel.SheetName,'HeadStartRow');
  reHColStart.Text:=GetValueByOtherField(adosheet,'SheetName',Myexcel.SheetName,'HeadStartColumn');
  reHRowEnd.Text:=GetValueByOtherField(adosheet,'SheetName',Myexcel.SheetName,'HeadEndRow');
  reHColEnd.Text:=GetValueByOtherField(adosheet,'SheetName',Myexcel.SheetName,'HeadEndColumn');
  result:=True;
 except
  result:=False;
  showmessage('请手动获取行列信息');
 end;

 if reHRowStart.Text='Null' then
  Result:=False
 else
  Result:=true;




end;

procedure TfrmMain.reHRowEndChange(Sender: TObject);
begin
 try
   if reDRowStart.Text<>'Null'then
   reDRowStart.Text:=IntToStr(StrToInt(reHRowEnd.Text)+1);
 except on E: Exception do
   Exit;
 end;
end;

procedure TfrmMain.reHRowStartChange(Sender: TObject);
begin
  try
     if reHRowStart.Text<>'Null' then
      if StrToInt(reHRowStart.Text) = 1 then
      begin
        reHRowStart.Text := '2';
      end;
  except on E: Exception do
    Exit;
  end;
end;

procedure TfrmMain.RzButton9Click(Sender: TObject);
var
  i: integer;
begin
  if cmbSchema.ItemIndex = -1 then
  begin
    showmessage('选择一个采油厂！');
    exit;
  end;
  if tblCol.IsEmpty then
    exit;
  tblCol.First;
  tblField.Close;
  tblField.Open;
  while not tblCol.eof do
  begin
    if tblCol.FieldByName('DBFieldDesc').AsString = '旧井名' then
      reWellName.Text := tblCol.FieldByName('XlsColIdx').Value;
   if not tblField.Locate('XlsColName;FieldDesc',
      vararrayof([tblCol.FieldByName('XlsColName').Value,
        tblCol.FieldByName('DBFieldDesc').Value]), [loCaseInsensitive]) then
    begin
      if (trim(tblCol.FieldByName('DBFieldDesc').AsString) <> '') and
        (trim(tblCol.FieldByName('XlsColName').AsString) <> '') then
      begin
        tblField.Append;
        tblField.FieldByName('XlsColName').AsString := tblCol.FieldByName
          ('XlsColName').AsString;
        tblField.FieldByName('FieldDesc').AsString := tblCol.FieldByName
          ('DBFieldDesc').AsString;
        tblField.FieldByName('FieldName').AsString := tblCol.FieldByName
          ('DBFieldName').AsString;
        tblField.FieldByName('DataType').AsString := tblCol.FieldByName
          ('DataType').AsString;
        tblField.Post;
      end;
    end;
    tblCol.Next;
  end;

  setlength(arrFieldMap, 0);
  // 建立数据列数组和对应的字段名数组
  tblCol.First;
  i := 0;
  while not tblCol.eof do
  begin
    if trim(tblCol.FieldByName('DBFieldName').AsString) <> '' then
    begin
      setlength(arrFieldMap, length(arrFieldMap) + 1);
      arrFieldMap[i].FieldName := tblCol.FieldByName('DBFieldName').AsString;
      arrFieldMap[i].ColIndex := tblCol.FieldByName('XLSColIdx').AsInteger;
      i := i + 1;
    end;
    tblCol.Next;
  end;

end;

procedure TfrmMain.RzCheckBox1Click(Sender: TObject);
begin
  GoOn:=RzCheckBox1.Checked;
end;

procedure TfrmMain.RzCheckBox2Click(Sender: TObject);
begin
 SingleSheet:=RzCheckBox2.Checked;
 
end;

function TfrmMain.StatisticialSheet(filename: string): Tstringlist;
begin

end;

// 全角转换为半角
procedure TfrmMain.Timer1Timer(Sender: TObject);
var
   name:string;
   i,count:integer;
begin
     if (bNewSchema = false) and (cmbSchema.ItemIndex = -1) then
  begin
    showmessage('选择一个采油厂！');
    exit;
  end;
    reHRowstart.EditText:='3';
    reHRowEnd.EditText:='4';
     reHColStart.EditText:='1';
    reHColEnd.EditText:='20';
     reDRowStart.EditText:='5';
 //   reDRowEnd.EditText:='';
  i:=0;
  count:=xlsfilelist.Count;
      if True then

     sFileName :=xlsfilelist.Strings[i];
   RzGroupBox1.Caption := '方案--' + sFileName;
   if sFileName = '' then
     exit;
   try
     begin
        ExcelApp := CreateOleObject('Excel.Application');
       ExcelApp.WorkBooks.Open(sFileName);
       ExcelApp.WorkSheets[1].Activate;
       lblSheet.Caption := ExcelApp.ActiveSheet.Name;
     end;
   except
     exit;
   end;
   RzButton16.Tag := ExcelApp.WorkSheets.Count;
   RzButton17.Tag := 1;
  try
    name:=ExtractFilename(odFile.FileName);
    name:=stringreplace(name,'.xls','',[rfreplaceall]);
    RzDateTimePicker1.Date:=strtodate(name);
    reDrowstart.EditText:='5';
    rzbutton6click(self);
  except on exception do
  begin
      myINI.WriteString(inttostr(count), '文件名',sFileName );
        CloseExcel();
  end;

 end;



end;


function TfrmMain.ToDBC(input: String): WideString;
var
  c: WideString;
  i: integer;
begin
  c := input;
  for i := 1 to length(input) do
  begin
    if (Ord(c[i]) = 12288) then
    begin
      c[i] := chr(32);
      Continue;
    end;
    if (Ord(c[i]) > 65280) and (Ord(c[i]) < 65375) then
      c[i] := WideChar(chr(Ord(c[i]) - 65248));
    if (Ord(c[i]) = 10005) or (c[i] = '*') or (Ord(c[i]) = 215) then
    begin
      c[i] := 'x';
    end;
  end;
  Result := c;
end;

// 判断字符是否汉字
function TfrmMain.IsMBCSChar(const ch: Char): boolean;
begin
  // Result := (ByteType(ch, 1) <> mbSingleByte);
  Result := (Word(ch) >= $3447) and (Word(ch) <= $FA29);
end;

end.
