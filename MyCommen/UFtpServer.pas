
{*******************************************************}
{                                                       }
{       系统名称 FTP服务器类                            }
{       版权所有  仙海网络                              }
{       单元名称 UFTPServer.pas                         }
{       单元功能 在Delphi 2006下TIdFTPServerFTP服务器   }
{                                                       }
{*******************************************************}

unit UFtpServer;

interface
uses
  Classes,  Windows, stdctrls, Sysutils, IdContext,IdFTPListOutput,Dialogs, ExtCtrls,Math,
  IdCommandHandlers, IdFTPList,  IdFTPServer,  Idtcpserver,sevenzip, StrUtils,
  IdSocketHandle,IdCmdTCPServer,  Idglobal, IdComponent, IdHashCRC, IdStack,IdGlobalProtocols;

const
    bakeupPath = '.\Bake\%s';
    strLocalIP = ' ';
    MesssageCaption = '仙海网络 温馨提醒';
    msgDftBanner      = '220 ICS FTP Server ready.';
    msgTooMuchClients = '421 Too many users connected.';
    msgCmdUnknown     = '500 ''%s'': command not understood.';
    msgLoginFailed    = '530 Login incorrect.';
    msgNotLogged      = '530 Please login with USER and PASS.';
    msgNoUser         = '503 Login with USER first.';
    msgLogged         = '230 User %s logged in.';
    msgPassRequired   = '331 Password required for %s.';
    msgCWDSuccess     = '250 CWD command successful. "%s" is current directory.';
    msgCWDFailed      = '501 CWD failed. %s';
    msgPWDSuccess     = '257 "%s" is current directory.';
    msgQuit           = '221 Goodbye.';
    msgPortSuccess    = '200 Port command successful.';
    msgPortFailed     = '501 Invalid PORT command.';
    msgStorDisabled   = '501 Permission Denied'; {'500 Cannot STOR.';}
    msgStorSuccess    = '150 Opening data connection for %s.';
    msgStorFailed     = '501 Cannot STOR. %s';
    msgStorAborted    = '426 Connection closed; %s.';
    msgStorOk         = '226 File received ok';
    msgStorError      = '426 Connection closed; transfer aborted. Error #%d';
    msgRetrDisabled   = '500 Cannot RETR.';
    msgRetrSuccess    = '150 Opening data connection for %s.';
    msgRetrFailed     = '501 Cannot RETR. %s';
    msgRetrAborted    = '426 Connection closed; %s.';
    msgRetrOk         = '226 File sent ok';
    msgRetrError      = '426 Connection closed; transfer aborted. Error #%d';
    msgSystem         = '215 UNIX Type: L8 Internet Component Suite';
    msgDirOpen        = '150 Opening data connection for directory list.';
    msgDirFailed      = '451 Failed: %s.';
    msgTypeOk         = '200 Type set to %s.';
    msgTypeFailed     = '500 ''TYPE %s'': command not understood.';
    msgDeleNotExists  = '550 ''%s'': no such file or directory.';
    msgDeleOk         = '250 File ''%s'' deleted.';
    msgDeleFailed     = '450 File ''%s'' can''t be deleted.';
    msgDeleSyntax     = '501 Syntax error in parameter.';
    msgDeleDisabled   = '500 Cannot DELE.';
    msgRnfrNotExists  = '550 ''%s'': no such file or directory.';
    msgRnfrSyntax     = '501 Syntax error is parameter.';
    msgRnfrOk         = '350 File exists, ready for destination name.';
    msgRntoNotExists  = '550 ''%s'': no such file or directory.';
    msgRntoAlready    = '553 ''%s'': file already exists.';
    msgRntoOk         = '250 File ''%s'' renamed to ''%s''.';
    msgRntoFailed     = '450 File ''%s'' can''t be renamed.';
    msgRntoSyntax     = '501 Syntax error in parameter.';
    msgMkdOk          = '257 ''%s'': directory created.';
    msgMkdAlready     = '550 ''%s'': file or directory already exists.';
    msgMkdFailed      = '550 ''%s'': can''t create directory.';
    msgMkdSyntax      = '501 Syntax error in parameter.';
    msgRmdOk          = '250 ''%s'': directory removed.';
    msgRmdNotExists   = '550 ''%s'': no such directory.';
    msgRmdFailed      = '550 ''%s'': can''t remove directory.';
    msgRmdSyntax      = '501 Syntax error in parameter.';
    msgNoopOk         = '200 Ok. Parameter was ''%s''.';
    msgAborOk         = '225 ABOR command successful.';
    msgPasvLocal      = '227 Entering Passive Mode (127,0,0,1,%d,%d).';
    msgPasvRemote     = '227 Entering Passive Mode (%d,%d,%d,%d,%d,%d).';
    msgPasvExcept     = '500 PASV exception: ''%s''.';
    msgSizeOk         = '213 %d';
    msgSizeFailed     = '550 Command failed: %s.';
    msgSizeSyntax     = '501 Syntax error in parameter.';
    msgRestOk         = '350 REST supported. Ready to resume at byte offset %d.';
    msgRestZero       = '501 Required byte offset parameter bad or missing.';
    msgRestFailed     = '501 Syntax error in parameter: %s.';
    msgAppeFailed     = '550 APPE failed.';
    msgAppeSuccess    = '150 Opening data connection for %s (append).';
    msgAppeDisabled   = '500 Cannot APPE.';
    msgAppeAborted    = '426 Connection closed; %s.';
    msgAppeOk         = '226 File received ok';
    msgAppeError      = '426 Connection closed; transfer aborted. Error #%d';
    msgAppeReady      = '150 APPE supported.  Ready to append file "%s" at offset %d.';
    msgStruOk         = '200 Ok. STRU parameter ''%s'' ignored.';


{-------------------------------------------------------------------------------
  功能:  自定义消息，方便与窗体进行消息传递
-------------------------------------------------------------------------------}
  type
    TFtpNotifyEvent = procedure (ADatetime: TDateTime;AUserIP, AEventMessage: string) of object;

{-------------------------------------------------------------------------------
  功能:  FTP服务器类
-------------------------------------------------------------------------------}
  type
  TFTPServer = class
  private
    FUserName,FUserPassword,FBorrowDirectory: string;
    FBorrowPort: Integer;
    IdFTPServer: TIdFTPServer;
    UncompressTimer: TTimer;
    FOnFtpNotifyEvent: TFtpNotifyEvent;
    FUncompressPathListbox: tlistbox;
    FUncompressCode  : Integer;             //解压状态返回值 17：解压成功 71：解压失败  13：部分成功  31：部分成功
    FUncompressFile, FUncompressPathSubStr, FUncompressPath : string;        // 解压文件夹包括的字符
    FUncompressPathList : TStringList;
    procedure IdFTPServer1UserLogin( ASender: TIdFTPServerContext; const AUsername, APassword: string; var AAuthenticated: Boolean ) ;
    procedure IdFTPServer1ListDirectory(ASender: TIdFTPServerContext; const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,ASwitches: string);
    procedure IdFTPServer1RenameFile( ASender: TIdFTPServerContext; const ARenameFromFile, ARenameToFile: string ) ;
    procedure IdFTPServer1RetrieveFile( ASender: TIdFTPServerContext; const AFilename: string; var VStream: TStream ) ;
    procedure IdFTPServer1StoreFile( ASender: TIdFTPServerContext; const AFilename: string; AAppend: Boolean; var VStream: TStream ) ;
    procedure IdFTPServer1RemoveDirectory( ASender: TIdFTPServerContext; var VDirectory: string ) ;
    procedure IdFTPServer1MakeDirectory( ASender: TIdFTPServerContext; var VDirectory: string ) ;
    procedure IdFTPServer1GetFileSize( ASender: TIdFTPServerContext; const AFilename: string; var VFileSize: Int64 ) ;
    procedure IdFTPServer1DeleteFile( ASender: TIdFTPServerContext; const APathname: string ) ;
    procedure IdFTPServer1ChangeDirectory( ASender: TIdFTPServerContext; var VDirectory: string ) ;
    procedure IdFTPServer1CommandXCRC( ASender: TIdCommand ) ;
    procedure IdFTPServer1CommandDecomPress( ASender: TIdCommand ) ;
    procedure IdFTPServer1DisConnect( AThread: TIdContext ) ;
    procedure IdFTPServerTimer(Sender: TObject);
    procedure SetUncompressPathSubStr(const Value: string);
  protected
    function TransLatePath( const APathname, homeDir: string ) : string;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Run;
    procedure Stop;
    function GetBindingIP():string;
    property UserName: string read FUserName write FUserName;
    property UserPassword: string read FUserPassword write FUserPassword;
    property BorrowDirectory: string read FBorrowDirectory write FBorrowDirectory;
    property BorrowPort: Integer read FBorrowPort write FBorrowPort;
    property OnFtpNotifyEvent: TFtpNotifyEvent read FOnFtpNotifyEvent write FOnFtpNotifyEvent;
    property UncompressPathSubStr: string read FUncompressPathSubStr write SetUncompressPathSubStr;
    property UncompressFile: string read FUncompressFile write FUncompressFile;
    property UncompressPathList: Tstringlist read FUncompressPathList write FUncompressPathList;
    property UncompressPath: string read FUncompressPath write FUncompressPath;
    property UncompressPathListbox: tlistbox read FUncompressPathListbox write FUncompressPathListbox;


  end;


function GetnewFilename(targetFilename:string):string;
function newBakFilename(targetFilename, Subpath:string):string;

implementation
// uses FtpServer;


{-------------------------------------------------------------------------------
  过程名:    FindSomeDir
  功能:      在Folder里查找 名字包涵 FilterStr 的文件夹
  参数:      const path: string
  返回值:    Tstringlist
-------------------------------------------------------------------------------}
function FindSomeDir(folder: string; FilterStr: string): Tstringlist;
var
  sRec: TSearchRec;
  fr: Integer;
   sFolder: string;
begin
  Result:=Tstringlist.Create;
  try
    if RightStr(folder, 1) = '\' then
        sFolder := folder
    else
        sFolder := folder + '\';
    fr := FindFirst(sFolder + '*.*', faDirectory, sRec) ;
    while fr = 0 do
    begin
        if(sRec.Attr and faDirectory = faDirectory) and (sRec.Name<> '.')and(sRec.Name<>'..') then
           if AnsiContainsText(sRec.Name,FilterStr) then Result.Add(sFolder+sRec.Name + '\');
        fr:=FindNext(sRec);
    end;
    FindClose(sRec);
  except
    Result.Free;
  end;
end;


{ TFTPServer }

constructor TFTPServer.Create;
begin
  IdFTPServer := TIdFTPServer.Create(nil);
  with   IdFTPServer do
  begin
    DefaultPort := 21;
//    MaxConnections := 3;
//    UserAccounts := 1;
    AllowAnonymousLogin := True;
    AnonymousPassStrictCheck := True;
    DirFormat := ftpdfDOS;
    SystemType := 'Windows 9x/NT';
    UncompressPathSubStr := '';
    //  IdFTPServer.EmulateSystem := ftpsUNIX;
    OnChangeDirectory := IdFTPServer1ChangeDirectory;
    OnGetFileSize := IdFTPServer1GetFileSize;
    OnListDirectory := IdFTPServer1ListDirectory;
    OnUserLogin := IdFTPServer1UserLogin;
    OnRenameFile := IdFTPServer1RenameFile;
    OnDeleteFile := IdFTPServer1DeleteFile;
    OnRetrieveFile := IdFTPServer1RetrieveFile;
    OnStoreFile := IdFTPServer1StoreFile;
    OnMakeDirectory := IdFTPServer1MakeDirectory;
    OnRemoveDirectory := IdFTPServer1RemoveDirectory;
//    OnConnect := IdFTPFtpServerConnect;
//    onStatus:= IdFtpServerStatus;
    HelpReply.Text.Text := '帮助还未实现,如有问题请联系...';
    Greeting.Text.Text := '欢迎进入仙海网络FTP服务器';
    Greeting.NumericCode := 220;
    UncompressFile:= '';
//    FUncompressPathList := TStringList.Create;

//    with CommandHandlers.Add do
//    begin
//      Command := 'XCRC';   //可以迅速验证所下载的文档是否和源文档一样
//      OnCommand := IdFTPServer1CommandXCRC;
//    end;

    with CommandHandlers.Add do
    begin
      Command := 'DecomPress';   //可以迅速验证所下载的文档是否和源文档一样
      OnCommand := IdFTPServer1CommandDecomPress;
    end;
  end;

//  UncompressTimer := TTimer.Create(nil);
//  with UncompressTimer do
//  begin
//     Enabled := False;
//     OnTimer := IdFTPServerTimer;
//     Enabled := True;

//  end;
end;


procedure TFTPServer.IdFTPServerTimer(Sender: TObject);
var
 i : integer;
begin
 try
  if not IdFTPServer.Active then  IdFTPServer.Active := True;
 except
  on e: Exception do
  MessageBox(0,'服务器不能启动,请尝试重新启动本工具',MesssageCaption,MB_OK + MB_ICONERROR);

 end;
end;





{-------------------------------------------------------------------------------
  过程名:    CalculateCRC
  功能:      计算CRC
  参数:      const path: string
  返回值:    string
-------------------------------------------------------------------------------}
function CalculateCRC( const path: string ) : string;
var
  f: tfilestream;
  value: dword;
  IdHashCRC32: TIdHashCRC32;
begin
  IdHashCRC32 := nil;
  f := nil;
  try
    IdHashCRC32 := TIdHashCRC32.create;
    f := TFileStream.create( path, fmOpenRead or fmShareDenyWrite ) ;
    value := IdHashCRC32.HashValue( f ) ;
    result := inttohex( value, 8 ) ;
  finally
    f.free;
    IdHashCRC32.free;
  end;
end;



destructor TFTPServer.Destroy;
begin
  IdFTPServer.Free;
  UncompressTimer.Free;
//  if Assigned(FUncompressPathList) then  FUncompressPathList.Free;

  inherited destroy;
end;


function StartsWith( const str, substr: string ) : boolean;
begin
  result := copy( str, 1, length( substr ) ) = substr;
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.GetBindingIP
  功能:      获取绑定的IP地址        
  参数:      
  返回值:    string
-------------------------------------------------------------------------------}
function TFTPServer.GetBindingIP: string;
begin
   Result := GStack.LocalAddress;
end;

{-------------------------------------------------------------------------------
  过程名:    BackSlashToSlash
  功能:      反斜杠到斜杠
  参数:      const str: string
  返回值:    string
-------------------------------------------------------------------------------}
function BackSlashToSlash( const str: string ) : string;
var
  a: dword;
begin
  result := str;
  for a := 1 to length( result ) do
    if result[a] = '\' then
      result[a] := '/';
end;

{-------------------------------------------------------------------------------
  过程名:    SlashToBackSlash
  功能:      斜杠到反斜杠        
  参数:      const str: string
  返回值:    string
-------------------------------------------------------------------------------}
function SlashToBackSlash( const str: string ) : string;
var
  a: dword;
begin
  result := str;
  for a := 1 to length( result ) do
    if result[a] = '/' then
      result[a] := '\';
end;


{-------------------------------------------------------------------------------
  过程名:    TFTPServer.TransLatePath
  功能:      路径名称翻译
  参数:      const APathname, homeDir: string
  返回值:    string
-------------------------------------------------------------------------------}
function TFTPServer.TransLatePath( const APathname, homeDir: string ) : string;
var
  tmppath: string;
begin
  result := SlashToBackSlash(Utf8ToAnsi(homeDir) ) ;
  tmppath := SlashToBackSlash( Utf8ToAnsi(APathname) ) ;
  if homedir = '/' then
  begin
    result := tmppath;
    exit;
  end;

  if length( APathname ) = 0 then
    exit;
  if result[length( result ) ] = '\' then
    result := copy( result, 1, length( result ) - 1 ) ;
  if tmppath[1] <> '\' then
    result := result + '\';
  result := result + tmppath;
end;

{-------------------------------------------------------------------------------
  过程名:    GetNewDirectory
  功能:      得到新目录        
  参数:      old, action: string
  返回值:    string
-------------------------------------------------------------------------------}
function GetNewDirectory( old, action: string ) : string;
var
  a: integer;
begin
  if action = '../' then
  begin
    if old = '/' then
    begin
      result := old;
      exit;
    end;
    a := length( old ) - 1;
    while ( old[a] <> '\' ) and ( old[a] <> '/' ) do
      dec( a ) ;
    result := copy( old, 1, a ) ;
    exit;
  end;
  if ( action[1] = '/' ) or ( action[1] = '\' ) then
    result := action
  else
    result := old + action;
end;

function GetnewFilename(targetFilename:string):string;
var
 spath,sext,sname :string;
begin

 try
  spath := ExtractFilePath(targetFilename);
  sext  := ExtractFileExt(targetFilename);
  sname := ExtractFileName(targetFilename);
  sname := StringReplace(sname,sext,'',[rfReplaceAll]);
  sname := spath + sname + FormatDateTime('(yymmddhhmmss)',Now) + sext;
  result := sname;
 finally

 end;

end;



// 保存备份文件的新名字
// 功能返回一个新的文件名 格式为 备份路径 + 文件路径 + 文件名 +文件原后缀 + _bak时间戳
function newBakFilename(targetFilename, Subpath:string):string;
const
 bakext = '%S_bak%s';
var
 spath,sext,sextN,sname :string;
begin
 try

  spath := ExtractFilePath(targetFilename);
  sext  := ExtractFileExt(targetFilename);
  sname := ExtractFileName(targetFilename);
  sname := StringReplace(sname,sext,Format(bakext, [sext, FormatDateTime('(yymmddhhmmss)',Now)]),[rfReplaceAll]);
//  sname :=bakeupPath + spath + sname;
  sname :=Format(bakeupPath,[Subpath]) + spath + sname;

  result := sname;
//  ShowMessage(sname);
 finally

 end;

end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1ChangeDirectory
  功能:      允许服务器选择一个文件系统路径        
  参数:      ASender: TIdFTPServerThread; var VDirectory: string
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  VDirectory := GetNewDirectory( ASender.CurrentDir, VDirectory ) ;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'进入目录[' + Utf8ToAnsi(VDirectory) + ']');
end;

procedure TFTPServer.IdFTPServer1CommandDecomPress(ASender: TIdCommand);
var
 i, j : integer;
 bFaile : Boolean;
 oFilename,nFilename  : string;
 oldfilename, targetpath, newFilepath, NewFilename : string;
begin
 bFaile := true;
 try
   if Trim(UncompressFile)<>'' then
   begin
     with CreateInArchive(CLSID_CFormatRar) do
     begin
      try
       OpenFile(UncompressFile);
       if UncompressPathList.Count > 0  then
       begin
         bFaile := False;
         for I := 0 to UncompressPathList.Count - 1 do
         begin
          try  // 备份文件
           targetpath := UncompressPathList[i];
           for j := 0 to GetNumberOfItems - 1 do
           begin
             if ItemIsFolder[j] then  Continue;
             NewFilename := newBakFilename(ItemPath[j],StringReplace(targetpath,UncompressPath,'',[rfReplaceAll]));
             oldfilename := targetpath + ItemPath[j];
             newFilepath := ExtractFilePath(NewFilename);
             if FileExists(oldfilename) then
             begin
              if not DirectoryExists(newFilepath) then
              begin
                if ForceDirectories(newFilepath) then
                begin
                 CopyFile(PChar(oldfilename), PChar(NewFilename),True);
//                 ShowMessage(newFilepath + ' 不存在 已经新建备份');
                end else
                 ShowMessage('创建失败');
              end else
              begin
                 CopyFile(PChar(oldfilename), PChar(NewFilename),True);
//                 ShowMessage(newFilepath + ' 存在 已经备份');
              end;
             end;
           end;
           if Assigned(FOnFtpNotifyEvent) then
           OnFtpNotifyEvent(Now, strLocalIP, '【' + targetpath + '】  自动备份文件成功');
          except
           on e:Exception do
           begin
            if Assigned(FOnFtpNotifyEvent) then
            OnFtpNotifyEvent(Now, strLocalIP, '【' +  targetpath + '】  自动备份文件失败[' + e.Message + ']');
            bFaile := True;
           end;
          end; // 结束 备份
          try
            ExtractTo(UncompressPathList[i]);
            if Assigned(FOnFtpNotifyEvent) then
            OnFtpNotifyEvent(Now, strLocalIP,'解压文件成功[' + Utf8ToAnsi(UncompressFile) + '] ->>' + UncompressPathList[i]);
          except
           on e:Exception do
           begin
            if Assigned(FOnFtpNotifyEvent) then
            OnFtpNotifyEvent(Now, strLocalIP,'解压文件失败[' + e.Message + ']');
            bFaile := True;
           end;
          end;
         end;
       end
       else
       begin
          if Assigned(FOnFtpNotifyEvent) then
           OnFtpNotifyEvent(Now, strLocalIP,'解压文件失败 没有配置解压路径');
          ASender.Reply.SetReply( 731 , '文件解压失败');
          bFaile := True;
          exit;
       end;
      finally
       Close;
      end;   
     end;
    end;
 except
  bFaile := true;
 end;

 if bFaile then
   ASender.Reply.SetReply( 731 , '文件解压失败')
 else
 begin
    oFilename := UncompressFile;
    nFilename := GetnewFilename(oFilename);
    if RenameFile(oFilename,nFilename) then
    begin
      if Assigned(FOnFtpNotifyEvent) then  OnFtpNotifyEvent(Now, strLocalIP,'重命名文件成功')
    end
    else
      if Assigned(FOnFtpNotifyEvent) then OnFtpNotifyEvent(Now, strLocalIP,'重命名文件失败');
    UncompressFile := '';
    ASender.Reply.SetReply( 137 , '文件解压成功');
 end;

end;








procedure TFTPServer.IdFTPServer1CommandXCRC(ASender: TIdCommand);
var 
    s:   string; 
begin 
//    with   TIdFTPServerThread(   ASender.Thread   )   do
//    begin
//        if   Authenticated   then
//        begin
//            try
//                s   :=   ProcessPath(   CurrentDir,   ASender.UnparsedParams   )   ;
//                s   :=   TransLatePath(   s,   TIdFTPServerThread(   ASender.Thread   )   .HomeDir   )   ;
//                ASender.Reply.SetReply(   213,   CalculateCRC(   s   )   )   ;
//            except
//                ASender.Reply.SetReply(   500,   'file   error '   )   ;
//            end;
//        end;
//    end;
end;


{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1DeleteFile
  功能:      允许从服务器中删除的文件系统中的文件
  参数:      ASender: TIdFTPServerThread; const APathname: string
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1DeleteFile(ASender: TIdFTPServerContext;
  const APathname: string);
begin
  try
    DeleteFile( pchar( TransLatePath( ASender.CurrentDir + '/' + APathname, ASender.HomeDir ) ) ) ;
  except
    on e:Exception do
    begin
      if Assigned(FOnFtpNotifyEvent) then
        OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'删除文件[' + Utf8ToAnsi(APathname) + ']失败，原因是' + e.Message);
      Exit;
    end;
  end;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'删除文件[' + Utf8ToAnsi(APathname) + ']');
end;



{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1DisConnect
  功能:      失去网络连接        
  参数:      AThread: TIdPeerThread
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1DisConnect(AThread: TIdContext);
begin
  //
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1GetFileSize
  功能:      允许服务器检索在服务器文件系统的文件的大小        
  参数:      ASender: TIdFTPServerThread; const AFilename: string; var VFileSize: Int64
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
  const AFilename: string; var VFileSize: Int64);
var
 sFilename : string;
begin
  sFilename := TransLatePath( AFilename, ASender.HomeDir );
  VFileSize := FileSizeByName( sFilename ) ;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'获取文件' +sFilename +'大小');
end;



{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1ListDirectory
  功能:      允许服务器生成格式化的目录列表        
  参数:      ASender: TIdFTPServerThread; const APath: string; ADirectoryListing: TIdFTPListItems
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1ListDirectory(ASender: TIdFTPServerContext;
  const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,
  ASwitches: string);

  procedure AddlistItem( aDirectoryListing: TIdFTPListOutput; Filename: string; ItemType: TIdDirItemType; size: int64; date: tdatetime ) ;
  var
    listitem: TIdFTPListItem;
  begin
    listitem := aDirectoryListing.Add;
    listitem.ItemType := ItemType; //表示一个文件系统的属性集
    listitem.FileName := AnsiToUtf8(Filename);  //名称分配给目录中的列表项,这里防止了中文乱码
//    listitem.OwnerName := 'anonymous';//代表了用户拥有的文件或目录项的名称
//    listitem.GroupName := 'all';    //指定组名拥有的文件名称或目录条目
//    listitem.OwnerPermissions := 'rwx'; //拥有者权限，R读W写X执行
//    listitem.GroupPermissions := 'rwx'; //组拥有者权限
//    listitem.UserPermissions := 'rwx';  //用户权限，基于用户和组权限
    listitem.Size := size;
    listitem.ModifiedDate := date;
  end;

var
  f: tsearchrec;
  a: integer;
begin
//  ADirectoryListing.DirectoryName := apath;
  a := FindFirst( TransLatePath( apath, ASender.HomeDir ) + '*.*', faAnyFile, f ) ;
  while ( a = 0 ) do
  begin
    if ( f.Attr and faDirectory > 0 ) then
      AddlistItem( ADirectoryListing, f.Name, ditDirectory, f.size, FileDateToDateTime( f.Time ) )
    else
      AddlistItem( ADirectoryListing, f.Name, ditFile, f.size, FileDateToDateTime( f.Time ) ) ;
    a := FindNext( f ) ;
  end;

  FindClose( f ) ;
end;



{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1MakeDirectory
  功能:      允许服务器从服务器中创建一个新的子目录
  参数:      ASender: TIdFTPServerThread; var VDirectory: string
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  try
    MkDir( TransLatePath( VDirectory, ASender.HomeDir ) ) ;
  except
    on e:Exception do
    begin
      if Assigned(FOnFtpNotifyEvent) then
        OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'创建目录[' + Utf8ToAnsi(VDirectory) + ']失败，原因是' + e.Message);
      Exit;
    end;
  end;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'创建目录[' + Utf8ToAnsi(VDirectory) + ']');
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1RemoveDirectory
  功能:      允许服务器在服务器删除文件系统的目录        
  参数:      ASender: TIdFTPServerThread; var VDirectory: string
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1RemoveDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  try
    RmDir( TransLatePath( VDirectory, ASender.HomeDir ) ) ;
  except
    on e:Exception do
    begin
      if Assigned(FOnFtpNotifyEvent) then
        OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'删除目录[' + Utf8ToAnsi(VDirectory) + ']失败，原因是' + e.Message);
      Exit;
    end;
  end;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'删除目录[' + Utf8ToAnsi(VDirectory) + ']');
end;



{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1RenameFile
  功能:      允许服务器重命名服务器文件系统中的文件        
  参数:      ASender: TIdFTPServerThread; const ARenameFromFile, ARenameToFile: string
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1RenameFile(ASender: TIdFTPServerContext;
  const ARenameFromFile, ARenameToFile: string);
begin
  try
    if not MoveFile( pchar( TransLatePath( ARenameFromFile, ASender.HomeDir ) ) , pchar( TransLatePath( ARenameToFile, ASender.HomeDir ) ) ) then
      RaiseLastOSError;
  except
    on e:Exception do
    begin
      if Assigned(FOnFtpNotifyEvent) then
        OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'重命名文件[' + Utf8ToAnsi(ARenameFromFile) + ']失败，原因是' + e.Message);
      Exit;
    end;
  end;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'重命名文件[' + Utf8ToAnsi(ARenameFromFile) + ']为[' + Utf8ToAnsi(ARenameToFile) + ']');
end;


{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1RetrieveFile
  功能:      允许从服务器下载文件系统中的文件
  参数:      ASender: TIdFTPServerThread; const AFilename: string; var VStream: TStream
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1RetrieveFile(ASender: TIdFTPServerContext;
  const AFilename: string; var VStream: TStream);
begin
  VStream := TFileStream.Create( translatepath( AFilename, ASender.HomeDir ) , fmopenread or fmShareDenyWrite ) ;
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'下载文件[' + Utf8ToAnsi(AFilename) + ']');
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1StoreFile
  功能:      允许在服务器上传文件系统中的文件
  参数:      ASender: TIdFTPServerThread; const AFilename: string; AAppend: Boolean; var VStream: TStream
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
  const AFilename: string; AAppend: Boolean; var VStream: TStream);
var
 LocalFile : string;
begin


  LocalFile := translatepath( AFilename, ASender.HomeDir );
  if FileExists(LocalFile) and AAppend then
  begin
    VStream := TFileStream.create( LocalFile , fmOpenWrite or fmShareExclusive ) ;
    VStream.Seek( 0, soFromEnd ) ;
  end
  else
    VStream := TFileStream.create( LocalFile , fmCreate or fmShareExclusive ) ;

  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'上传文件[' + Utf8ToAnsi(AFilename) + ']');

   if SameText(ExtractFileExt(AFilename),'.rar') then
   begin
     // 每次解压之前都要重新搜索解压的目标路径（因为解压的路径名经常变动）
     UncompressPathSubStr := UncompressPathSubStr;
     if assigned(UncompressPathListbox) then
     begin
      UncompressPathListbox.Items.Assign(FUncompressPathList);

     end;
//     SendMessage(Formmain.handle,MsgRefresslist,0,0);
     UncompressFile :=  LocalFile;
//     UncompressTimer.Enabled := True;
   end;
end;



{-------------------------------------------------------------------------------
  过程名:    TFTPServer.IdFTPServer1UserLogin
  功能:      允许服务器执行一个客户端连接的用户帐户身份验证        
  参数:      ASender: TIdFTPServerThread; const AUsername, APassword: string; var AAuthenticated: Boolean
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
  const AUsername, APassword: string; var AAuthenticated: Boolean);
begin
//  ShowMessage('用户登录服务器');
//  Randomize;
//
  Sleep(RandomRange(1001,1117) + Random(100));
//  Sleep(Random(37) + Random(73) + Random(13));

  AAuthenticated := ( AUsername = UserName ) and ( APassword = UserPassword ) ;
  if not AAuthenticated then
    exit;
  ASender.HomeDir := AnsiToUtf8(BorrowDirectory);
  asender.currentdir := '/';
  if Assigned(FOnFtpNotifyEvent) then
    OnFtpNotifyEvent(Now, ASender.Connection.Socket.Binding.PeerIP,'用户登录服务器');
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.Run
  功能:      开启服务        
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
procedure TFTPServer.Run;
begin
  IdFTPServer.DefaultPort := BorrowPort;
  IdFTPServer.Active := True;
end;

{-------------------------------------------------------------------------------
  过程名:    TFTPServer.Stop
  功能:      关闭服务        
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}

procedure TFTPServer.SetUncompressPathSubStr(const Value: string);
begin
  FUncompressPathSubStr := Value;

  FUncompressPathList := FindSomeDir(FUncompressPath,FUncompressPathSubStr);
end;

procedure TFTPServer.Stop;
begin
  IdFTPServer.Active := False;
end;



end.
