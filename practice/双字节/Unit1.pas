unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,uordersystem, ComCtrls;

type
  TArr = array of TPoint;
  PArr = ^TArr;
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    lbledt1: TLabeledEdit;
    lbledt2: TLabeledEdit;
    lbledt3: TLabeledEdit;
    tv1: TTreeView;
    btn5: TButton;
    btn2: TButton;
    btn1: TButton;
    btn6: TButton;
    btn4: TButton;
    btn3: TButton;
    lbledt4: TLabeledEdit;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btn10: TButton;
    procedure btn10Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  arr1, arr2, arr3 : array of tpoint;


implementation

{$R *.dfm}

procedure TForm1.btn10Click(Sender: TObject);
var
  l_nSize: Cardinal;
begin
  if (GetProcessMemorySize1('IWDataStat.exe', l_nSize)) then
    ShowMessage('Size: ' + IntToStr(l_nSize div 1024) + ' Kbyte')
  else
    ShowMessage('Error');
end;

procedure TForm1.btn1Click(Sender: TObject);
var
 sUn: string;
 pi: PINT;
 sAn: AnsiString;
begin
 sun := lbledt3.Text;
 pi := @sUn[1];
 lbledt1.Text := IntToHex(Pi^,4);

 sAn := lbledt3.Text;
 pi := @sAn[1];
 lbledt2.Text := IntToHex(Pi^,4);


end;

procedure TForm1.btn2Click(Sender: TObject);
var
 p1,p2 :ppchar;
begin
 p1^ := '2';
 p2 := p1;
 showmessage(p2^);
end;


// 将字符串赋值到无类型的指针上面
procedure StrtoPointer(targetP: Pointer; SourStr:string);
var
 size:integer;
begin
 size := ((length(sourstr) + 1) * sizeof(char));
 targetP := getmemory(size);
 zeromemory(targetp, size);
 copymemory(targetp, @sourstr[1], size);
 showmessage(pchar(targetp));


end;



procedure TForm1.btn3Click(Sender: TObject);
begin
  GetCurWindow;
end;
procedure TForm1.btn4Click(Sender: TObject);
begin
//  StrtoPointer();
end;

procedure TForm1.btn5Click(Sender: TObject);
var
 i: integer;
begin
 setlength(arr1,1);
 setlength(arr2,2);
 setlength(arr3,3);

 for i := 0 to length(arr1) - 1 do
 begin
  arr1[i].X := i + 1;
  arr1[i].y := i + 4;
 end;

 for i := 0 to length(arr2) - 1 do
 begin
  arr2[i].X := i + 2;
  arr2[i].y := i + 5;
 end;

 for i := 0 to length(arr3) - 1 do
 begin
  arr3[i].X := i + 3;
  arr3[i].y := i + 6;
 end;

 tv1.Items.Clear;
 tv1.Items.AddChildObject(nil,'node1',arr1);
 tv1.Items.AddChildObject(nil,'node2',arr2);
 tv1.Items.AddChildObject(nil,'node3',arr3);



end;



procedure DelArrItem(tagetArray: Parr; index: integer);
var
 count: integer;
begin
 count := length(tagetArray^);
 if (count = 0) or (index > count) or (index < 0) then  exit;
 move(tagetarray^[index + 1],tagetarray^[index],(Count-Index)* SizeOf(tagetarray^[0]));
 setlength(tagetarray^, count -1);

end;

procedure TForm1.btn6Click(Sender: TObject);
var
 ta:tarr;
begin
 setlength(ta, 3);
 ta[0].X := 1; ta[0].Y :=4;
 ta[2].X := 2; ta[2].Y :=5;
 ta[3].X := 3; ta[3].Y :=6;

end;
procedure TForm1.btn7Click(Sender: TObject);
begin
//   StopService(lbledt4.Text);
end;

function getcurrentmemuse: cardinal;
begin 
result := getprocessmemuse(getcurrentprocessid); 
end; 

procedure TForm1.btn8Click(Sender: TObject);
var
str,str2:string;
begin
if (GetProcessMemorySize('IWDataStat.exe',str,str2)) then
 begin
    ShowMessage('进程: '+str2+' :当前内存使用:'+ str +'K');
 end;
end;


procedure TForm1.btn9Click(Sender: TObject);
begin
 ShowMessage(IntToStr(getcurrentmemuse div 1024));
end;

end.
