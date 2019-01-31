unit ServerINI;

interface

uses IniFiles, SysUtils, Classes;

type
  TServerINI = class(TObject)
  private
    procedure InitServerINI;
  public
    FConfigINI: TINIFile;
    SectionList: TStringList;
    constructor Create(FileName: string);
    destructor Destroy();override;
    procedure ReadSections;
  end;

var
  objServerINI: TServerINI;

implementation

{ TConfigINI }

constructor TServerINI.Create(FileName: string);
begin
  SectionList := TStringList.Create;
  FConfigINI := TINIFile.Create(FileName);
  if not FileExists(FileName) then InitServerINI;
  FConfigINI.ReadSections(SectionList);
end;

destructor TServerINI.Destroy;
begin
  FConfigINI.Free;
  SectionList.Free;
  inherited;
end;

procedure TServerINI.InitServerINI;
var
  Section,Ident: string;
begin
  Section := 'wyi全局统计';
  Ident := '会话服务器';
  FConfigINI.WriteString(Section,Ident,'115.238.101.179');
  Ident := '日志服务器';
  FConfigINI.WriteString(Section,Ident,'115.238.101.180');
  Section := '937全局统计';
  Ident := '会话服务器';
  FConfigINI.WriteString(Section,Ident,'59.34.148.97');
  Ident := '日志服务器';
  FConfigINI.WriteString(Section,Ident,'59.34.148.96');
end;

procedure TServerINI.ReadSections;
begin
  FConfigINI.ReadSections(SectionList);
end;

end.
