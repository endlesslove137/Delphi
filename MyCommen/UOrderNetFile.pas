unit UOrderNetFile;

interface
uses
 IdHTTP, classes, sysutils;



function GetHttpXML(sHttp: string): string;

implementation
function GetHttpXML(sHttp: string): string;
var
  ResponseSteam: TStringStream;
  IdHttp: TIdHttp;
  hs: AnsiString;
begin
  Result := '';
  ResponseSteam := TStringStream.Create('',TEncoding.UTF8);
  IdHttp := TIdHttp.Create;
  IdHttp.HandleRedirects := True;
  try
    IdHttp.Get(sHttp,ResponseSteam);
    Result := ResponseSteam.DataString;
    SetLength(hs,3);
    ResponseSteam.Position := 0;
    ResponseSteam.Read(hs[1],3);
    if hs=#$EF#$BB#$BF then
    begin
      Result := ResponseSteam.ReadString(ResponseSteam.Size-3);
    end;
  finally
    IdHttp.Free;
    ResponseSteam.Free;
  end;
end;

end.

