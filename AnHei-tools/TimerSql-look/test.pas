unit test;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP;
const
  Url='http://www.sergeaura.net/TGP/';  //下载图片的网站地址
  OffI=5; //目录个数
  OffJ=16;  //每个目录下的最大图片数
  girlPic='C:\girlPic\';  //保存在本地的路径
  maxThread=100;        //最大线程数目
//线程类
type
  TGetMM = class(TThread)
  private
   procedure decTcount;
   procedure incTcount;
  protected
    FMMUrl:string;
    FDestPath:string;
    FSubJ:string;
    procedure Execute;override;
  public
    constructor Create(MMUrl,DestPath,SubJ:string);
  end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    RGetMM:TThread;
    procedure GetMMThread(MMUrl,DestPath,SubJ:string);
  public
    { Public declarations }
  end;
var
  Form1: TForm1;
  flag:boolean;
  tcount:integer; //用来控制当前下载线程用
implementation
{$R *.dfm}
//下载过程
procedure TForm1.Button1Click(Sender: TObject);
var
  i,j:integer;
  SubI,SubJ,CurUrl,DestPath:string;
  strm:TMemoryStream;
begin
  tcount:=0;
  memo1.Lines.Clear;
  //建立目录
  if not DirectoryExists(girlPic) then
    MkDir(girlPic);
  try
    strm :=TMemoryStream.Create;
    for I:=strtoint(edit1.text) to strtoint(edit2.text) do
    begin
      for j:=1 to OffJ do
      begin
        flag:=false;
        if (i<10) then
          SubI:='00'+IntToStr(i)
        else if (i>9) and (i<100) then
          SubI:='0'+inttostr(i)
        else SubI:=inttostr(i);
        if (j>9) then
          SubJ:=inttostr(j)
        else SubJ:='0'+inttostr(j);
        CurUrl:=Url+SubI+'/images/';
        DestPath:=girlPic+SubI+'\';
        if not DirectoryExists(DestPath) then
          ForceDirectories(DestPath);
        //使用线程，速度能提高N倍以上
        if CheckBox1.Checked then
        begin
         while flag=false do
         begin
           if tcount<50 then
            begin
             GetMMThread(CurUrl,DestPath,SubJ);
             flag:=true;
            end;
            label1.Caption:=inttostr(tcount);
            application.ProcessMessages;
         end;
          //sleep(500);
        end else
        //不使用线程
        begin
          try
            strm.Clear;
            IdHTTP1.Get(CurUrl+SubJ+'.jpg',strm);
            strm.SaveToFile(DestPath+SubJ+'.jpg');
            Memo1.Lines.Add(CurUrl+' Download OK ！');
            strm.Clear;
            IdHTTP1.Get(CurUrl+'tn_'+SubJ+'.jpg',strm);
            strm.SaveToFile(DestPath+'tn_'+SubJ+'.jpg');
            Memo1.Lines.Add(CurUrl+' Download OK ！');
          except
            Memo1.Lines.Add(CurUrl+' Download Error ！');
          end;
        end;
      end;
    end;
    Memo1.Lines.Add('All OK！');
  finally
    strm.Free;
  end;
end;
procedure TForm1.Button2Click(Sender: TObject);
 var x:TMultiReadExclusiveWriteSynchronizer;
begin
  Close;
  x:=TMultiReadExclusiveWriteSynchronizer.Create;
  x.BeginRead;
end;
{ TGetMM }
constructor TGetMM.Create(MMUrl,DestPath,SubJ: string);
begin
  FMMUrl :=MMUrl;
  FDestPath :=DestPath;
  FSubJ :=SubJ;
  inherited Create(False);
end;
procedure TGetMM.decTcount;
 begin
  dec(tcount);
 end;
procedure TGetMM.incTcount;
 begin
  inc(tcount);
 end;
procedure TGetMM.Execute;
var
  strm:TMemoryStream;
  IdGetMM: TIdHTTP;
  DestFile:string;
begin
  inc(tcount);
  //synchronize(incTcount);
  try
    //inc(tcount);
    strm :=TMemoryStream.Create;
    IdGetMM :=TIdHTTP.Create(nil);
    try
      DestFile :=FDestPath+FSubJ+'.jpg';
      if Not FileExists(DestFile) then
      begin
        strm.Clear;
        IdGetMM.Get(FMMUrl+FSubJ+'.jpg',strm);
        strm.SaveToFile(DestFile);
      end;
      DestFile :=FDestPath+'tn_'+FSubJ+'.jpg';
      if not FileExists(DestFile) then
      begin
        strm.Clear;
        IdGetMM.Get(FMMUrl+'tn_'+FSubJ+'.jpg',strm);
        strm.SaveToFile(DestFile);
      end;
    except
    end;
  finally
   // dec(tcount);
    strm.Free;
    IdGetMM.Free;
  end;
  dec(tcount);
  //synchronize(dectcount);
end;
procedure TForm1.GetMMThread(MMUrl, DestPath, SubJ: string);
begin
  RGetMM :=TGetMM.Create(MMUrl,DestPath,SubJ);
end;
end.
