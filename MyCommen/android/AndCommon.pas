unit AndCommon;

interface
uses
  Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, FMX.Helpers.Android, Androidapi.JNI.Net;


procedure Call_URI(const AAction : JString;const AURI: string);


implementation




procedure Call_URI(const AAction : JString;const AURI: string);
var
  uri: Jnet_Uri;
  Intent: JIntent;
begin
  uri := StrToJURI(AURI);
  Intent := TJIntent.JavaClass.init(AAction, uri);
  {Intent.putExtra()
  如果是要发短信等复杂的应用,需要传递各种其他的参数.要用到Intent.putExtra()传递多个参数.
  这里只封装最简单的,具体Intent.putExtra()的用法,可以查询Java的资料.大把的
  }
  SharedActivityContext.startActivity(Intent);

//使用例子:
//打电话
//Call_URI(TJIntent.JavaClass.ACTION_CALL, 'tel:137114553XX');
////打开地图显示某个坐标点
//Call_URI(TJIntent.JavaClass.ACTION_VIEW, 'geo:38.899533,-77.036476');
////发送电子邮件
// Call_URI(TJIntent.JavaClass.ACTION_SENDTO, 'mailto:wr960204@126.com');
////播放音乐
//Call_URI(TJIntent.JavaClass.ACTION_VIEW, 'file:///sdcard/download/最炫民族风.mp3');

end;


end.
