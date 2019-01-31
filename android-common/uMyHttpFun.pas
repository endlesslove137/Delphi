unit uMyHttpFun;

interface
uses
  System.SysUtils, System.Classes, Data.Cloud.CloudAPI;

  function Base64Encode(const convertStr:String):String;
  function Base64Decode(const convertStr:String):String;
  function UrlParams(const AParam, AUrl:string):string;
implementation
{
  作用：Base64Encode函数定义
  参数：转换字符串
  返回: base64字符串
}
function Base64Encode(const convertStr:String):String;
begin
  if (convertStr='') then begin  //转换为空，退出
    result:= '';
    exit;
  end;

  result:= Encode64(convertStr);
end;

{
  作用：Base64Decode函数定义
  参数：base64字符串
  返回: 原字符串
}
function Base64Decode(const convertStr:String):String;
begin
  if (convertStr='') then begin  //转换为空，退出
    result:= '';
    exit;
  end;

  result:= Decode64(convertStr);
end;


{
  作用：获取URL参数
  参数：AUrl地址， ALocalPath本要文件路径
  返回: 无
}
function UrlParams(const AParam, AUrl:string):string;
var
  p:Integer;
begin
  Result := '';
  p := Pos(AParam,AUrl);
  if P > 0 then begin
    Inc(p, Length(AParam));
    while (p<=length(AUrl)) and (AUrl[p]<>'&') do begin
      Result := Result + AUrl[p];
      Inc(p);
    end;
  end;
  //如果参数为空，则返回url
  if Result='' then Result := AUrl;
end;

end.
