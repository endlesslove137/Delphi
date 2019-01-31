unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask;

type
  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StaticText1: TStaticText;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    Timer2: TTimer;
    StaticText2: TStaticText;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  hWnd: Integer;   //记录窗口句柄的变量
  Pid:  Cardinal;   //记录进程PID的变量
  hProcess:  Thandle;   //记录进程句柄的变量
  Isrun :  	Boolean;    //记录是否访问了进程的变量
  nosize:  Thandle;       //用来填写实际写入长度
implementation

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);  //变身鬼武者的按钮按下
var
  res:boolean;  //用来记录修改内存成功的状态
  bians: Integer;
  Addr:Integer;
begin
if  Isrun then  //游戏运行了
  begin
      Addr:=$33FDFB4;// 变身鬼武者的内存地址 [十六进制]
      bians:= 600;  //需要修改的数据 [10进制]
      res:=WriteProcessMemory(hProcess,pointer(Addr),pointer(@bians),2,nosize);
      if res then
      begin
        StaticText1.Caption:='变身鬼武者成功';
      end
      else
        begin
          StaticText1.Caption:='变身鬼武者失败';
        end;
  end
  else
    begin
      StaticText1.Caption:='游戏还没有运行';
    end;

if checkbox1.Checked then  //如果选择框选中了
  begin
    timer2.Enabled:=true;   //就让时钟2生效
  end;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
var
Addr:Integer ;
juyao:array [1..8] of byte;
begin
//   (OX340D738, { 104, 1, 255, 136, 62, 62, 62, 62 });
Addr:=$340D738;  //修改剧药的内存地址
juyao[1]:= 104;
juyao[2]:= 1;
juyao[3]:= 255;
juyao[4]:= 136;
juyao[5]:=strtoint(Edit1.Text);
juyao[6]:=strtoint(Edit1.Text);
juyao[7]:=strtoint(Edit1.Text);
juyao[8]:=strtoint(Edit1.Text);
//需要写入的数据.后面4个数据分别是4个人的数量.

WriteProcessMemory(hProcess,pointer(Addr),pointer(@juyao),8,nosize);
// 写内存操作,这里故意丢弃了返回值.
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
if checkbox1.Checked=false then  //如果选择框取消选中
  begin
    timer2.Enabled:=false;   //就让时钟2失效
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);  //程序运行的时候
begin
Isrun:= false;


end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);  //检查编辑框输入的是否为整数
begin
if not(key in['0'..'9',#8])then  //不是整数取消写入
  begin
    key:=#0;
  end;
end;


procedure TForm2.Timer1Timer(Sender: TObject);    //第一个时钟控件获取窗口句柄
begin
   hWnd:=FindWindow('Direct3DWindowClass','oni3'); //获取窗口句柄
if  hWnd=0 then
  begin
    StaticText1.Caption:='游戏没有运行?';
  end
  else
    begin
      GetWindowThreadProcessId(hWnd,@Pid); //获取PID
      hProcess:=OpenProcess(PROCESS_ALL_ACCESS,FALSE,Pid); //获取进程句柄
      if  hProcess=0 then   //访问进程失败
        begin
          StaticText1.Caption:='打开游戏进程失败';
        end
        else
          begin
              StaticText1.Caption:='已经启动作弊器';
              Isrun:=true;  //表示作弊器已经获取游戏的进程句柄了.
              Timer1.Enabled:=False;
              //获取游戏进程句柄的任务结束了这个时钟控件不需要了.
          end;
    end;
end;

end.
