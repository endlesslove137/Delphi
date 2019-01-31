unit ConfigINI;

interface

uses IniFiles;

type
  TConfigINI = class(TObject)
  private
    FConfigINI: TINIFile;
  public
    sHostName: string;
    iPort: Integer;
    sDBUser: string;
    sDBPass: string;
    sDataBase: string;
    sSQLFile: string;
    sSQLPass: string;
    iServer: string;
    iServerEx: Integer;
    iRule: Integer;
    constructor Create(FileName: string);
    destructor Destroy;override;
  end;

var
  objINI: TConfigINI;

implementation

{ TConfigINI }

constructor TConfigINI.Create(FileName: string);
var
  Section,Ident: string;
begin
  FConfigINI := TINIFile.Create(FileName);
  Section := '基本设置';
  Ident := 'Mysql地址';
  sHostName := FConfigINI.ReadString(Section,Ident,'localhost');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sHostName);
  Ident := 'Mysql端口';
  iPort := FConfigINI.ReadInteger(Section,Ident,3306);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iPort);
  Ident := '登录用户';
  sDBUser := FConfigINI.ReadString(Section,Ident,'root');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDBUser);
  Ident := '登录密码';
  sDBPass := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDBPass);
  Ident := '数据库';
  sDataBase := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDataBase);
  Ident := '脚本文件';
  sSQLFile := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sSQLFile);
  Ident := '脚本文件密码';
  sSQLPass := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sSQLPass);
  Ident := '服务器ID';
  iServer := FConfigINI.ReadString(Section,Ident,'0');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,iServer);
  Ident := '别名ID';
  iServerEx := FConfigINI.ReadInteger(Section,Ident,0);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iServerEx);
  Ident := '操作类型';
  iRule := FConfigINI.ReadInteger(Section,Ident,0);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iRule);
end;

destructor TConfigINI.Destroy;
begin
  FConfigINI.Free;
  inherited Destroy;
end;

end.

