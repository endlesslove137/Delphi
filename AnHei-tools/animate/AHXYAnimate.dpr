program AHXYAnimate;

uses
  Vcl.Forms,
  windows,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
{ 关闭RTTI反射机制减少EXE文件尺寸 }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
