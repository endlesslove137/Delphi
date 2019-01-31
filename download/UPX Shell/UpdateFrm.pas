Unit UpdateFrm;
Interface
Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, WinInet, Translator, Globals, Shared;
Type
  TUpdateForm = Class(TForm)
    grpProgress: TGroupBox;
    lblStatus: TLabel;
    grpUpdateInfo: TGroupBox;
    lblReleaseCap: TLabel;
    lblBuildCap: TLabel;
    lblRelease: TLabel;
    lblBuild: TLabel;
    lblDateCap: TLabel;
    lblDate: TLabel;
    lblSizeCap: TLabel;
    lblSize: TLabel;
    btnOk: TButton;
    memNews: TMemo;
    lblNews: TLabel;
    grpDownload: TGroupBox;
    lblDownload: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormActivate(Sender: TObject);
    Procedure DownloadClick(Sender: TObject);
  Private
    FUpdateUrl: String; //Holds update file url (.txt)
    FLocalName: String; //Local name to save update file
    FUpdateDownload: String; //Holds program update file url (.exe)
    Procedure CheckForUpdate;
    Procedure Error(Sender: TObject);
    Procedure UpdateDone(Sender: TObject; FileName: String; FileSize: Integer);
  Public
    Constructor Create(AOwner: TComponent; Url, LocalName: String); Reintroduce;
  End;
Const
  UpdateHeader = '<ION Tek update file>';
Var
  UpdateForm: TUpdateForm;
Implementation
{$R *.dfm}
{ The following stuff is a rip from HTTPGET component by UtilMind.
  I don't claim it to be my own, though it's not official release
  stuff neither:) It's just an adoption of HTTPGET to my needs,
  which is permitted by author:)) Also I don't add the rip from GNU
  Public License as it's of no use:), though HTTPGET author asked
  to do so=)
}
Type
  TOnProgressEvent = Procedure(Sender: TObject; TotalSize, Received: Integer) Of Object;
  TOnDoneFileEvent = Procedure(Sender: TObject; FileName: String; FileSize: Integer) Of
    Object;
  TOnDoneStringEvent = Procedure(Sender: TObject; Result: String) Of Object;
  THTTPGetThread = Class(TThread)
  Private
    FTAcceptTypes,
      FTAgent,
      FTURL,
      FTFileName,
      FTStringResult,
      FTUserName,
      FTPassword,
      FTPostQuery,
      FTReferer: String;
    FTBinaryData,
      FTUseCache: Boolean;
    FTResult: Boolean;
    FTFileSize: Integer;
    FTToFile: Boolean;
    BytesToRead, BytesReaded: DWord;
    FTProgress: TOnProgressEvent;
    Procedure UpdateProgress;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(aAcceptTypes, aAgent, aURL, aFileName, aUserName,
      aPassword, aPostQuery, aReferer: String;
      aBinaryData, aUseCache: Boolean; aProgress: TOnProgressEvent;
      aToFile: Boolean);
  End;
  THTTPGet = Class(TComponent)
  Private
    FAcceptTypes: String;
    FAgent: String;
    FBinaryData: Boolean;
    FURL: String;
    FUseCache: Boolean;
    FFileName: String;
    FUserName: String;
    FPassword: String;
    FPostQuery: String;
    FReferer: String;
    FWaitThread: Boolean;
    FThread: THTTPGetThread;
    FError: TNotifyEvent;
    FResult: Boolean;
    FProgress: TOnProgressEvent;
    FDoneFile: TOnDoneFileEvent;
    FDoneString: TOnDoneStringEvent;
    Procedure ThreadDone(Sender: TObject);
  Public
    Constructor Create(aOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure GetFile;
    Procedure GetString;
    Procedure Abort;
  Published
    Property AcceptTypes: String Read FAcceptTypes Write FAcceptTypes;
    Property Agent: String Read FAgent Write FAgent;
    Property BinaryData: Boolean Read FBinaryData Write FBinaryData;
    Property URL: String Read FURL Write FURL;
    Property UseCache: Boolean Read FUseCache Write FUseCache;
    Property FileName: String Read FFileName Write FFileName;
    Property UserName: String Read FUserName Write FUserName;
    Property Password: String Read FPassword Write FPassword;
    Property PostQuery: String Read FPostQuery Write FPostQuery;
    Property Referer: String Read FReferer Write FReferer;
    Property WaitThread: Boolean Read FWaitThread Write FWaitThread;
    Property OnProgress: TOnProgressEvent Read FProgress Write FProgress;
    Property OnDoneFile: TOnDoneFileEvent Read FDoneFile Write FDoneFile;
    Property OnDoneString: TOnDoneStringEvent Read FDoneString Write FDoneString;
    Property OnError: TNotifyEvent Read FError Write FError;
  End;
Constructor THTTPGetThread.Create(aAcceptTypes, aAgent, aURL, aFileName,
  aUserName, aPassword, aPostQuery, aReferer: String;
  aBinaryData, aUseCache: Boolean; aProgress: TOnProgressEvent; aToFile: Boolean);
Begin
  FreeOnTerminate := True;
  Inherited Create(True);
  FTAcceptTypes := aAcceptTypes;
  FTAgent := aAgent;
  FTURL := aURL;
  FTFileName := aFileName;
  FTUserName := aUserName;
  FTPassword := aPassword;
  FTPostQuery := aPostQuery;
  FTReferer := aReferer;
  FTProgress := aProgress;
  FTBinaryData := aBinaryData;
  FTUseCache := aUseCache;
  FTToFile := aToFile;
  Resume;
End;
Procedure THTTPGetThread.UpdateProgress;
Begin
  FTProgress(Self, FTFileSize, BytesReaded);
End;
Procedure THTTPGetThread.Execute;
Var
  hSession, hConnect, hRequest: hInternet;
  HostName, FileName: String;
  f: File;
  Buf: Pointer;
  dwBufLen, dwIndex: DWord;
  Data: Array[0..$400] Of Char;
  TempStr: String;
  RequestMethod: PChar;
  InternetFlag: DWord;
  AcceptType: LPStr;
  Procedure ParseURL(URL: String; Var HostName, FileName: String);
    Procedure ReplaceChar(c1, c2: Char; Var St: String);
    Var
      p: Integer;
    Begin
      While True Do
      Begin
        p := Pos(c1, St);
        If p = 0 Then
          Break
        Else
          St[p] := c2;
      End;
    End;
  Var
    i: Integer;
  Begin
    If Pos('http://', LowerCase(URL)) <> 0 Then
      System.Delete(URL, 1, 7);
    i := Pos('/', URL);
    HostName := Copy(URL, 1, i);
    FileName := Copy(URL, i, Length(URL) - i + 1);
    If (Length(HostName) > 0) And (HostName[Length(HostName)] = '/') Then
      SetLength(HostName, Length(HostName) - 1);
  End;
  Procedure CloseHandles;
  Begin
    InternetCloseHandle(hRequest);
    InternetCloseHandle(hConnect);
    InternetCloseHandle(hSession);
  End;
Begin
  Try
    ParseURL(FTURL, HostName, FileName);
    If Terminated Then
    Begin
      FTResult := False;
      Exit;
    End;
    If FTAgent <> '' Then
      hSession := InternetOpen(PChar(FTAgent),
        INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0)
    Else
      hSession := InternetOpen(Nil,
        INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0);
    hConnect := InternetConnect(hSession, PChar(HostName),
      INTERNET_DEFAULT_HTTP_PORT, PChar(FTUserName), PChar(FTPassword),
      INTERNET_SERVICE_HTTP, 0, 0);
    If FTPostQuery = '' Then
      RequestMethod := 'GET'
    Else
      RequestMethod := 'POST';
    If FTUseCache Then
      InternetFlag := 0
    Else
      InternetFlag := INTERNET_FLAG_RELOAD;
    AcceptType := PChar('Accept: ' + FTAcceptTypes);
    hRequest := HttpOpenRequest(hConnect, RequestMethod, PChar(FileName), 'HTTP/1.0',
      PChar(FTReferer), @AcceptType, InternetFlag, 0);
    If FTPostQuery = '' Then
      HttpSendRequest(hRequest, Nil, 0, Nil, 0)
    Else
      HttpSendRequest(hRequest, 'Content-Type: application/x-www-form-urlencoded', 47,
        PChar(FTPostQuery), Length(FTPostQuery));
    If Terminated Then
    Begin
      CloseHandles;
      FTResult := False;
      Exit;
    End;
    dwIndex := 0;
    dwBufLen := 1024;
    GetMem(Buf, dwBufLen);
    FTResult := HttpQueryInfo(hRequest, HTTP_QUERY_CONTENT_LENGTH,
      Buf, dwBufLen, dwIndex);
    If Terminated Then
    Begin
      FreeMem(Buf);
      CloseHandles;
      FTResult := False;
      Exit;
    End;
    If FTResult Or Not FTBinaryData Then
    Begin
      If FTResult Then
        FTFileSize := StrToInt(StrPas(Buf));
      BytesReaded := 0;
      If FTToFile Then
      Begin
        AssignFile(f, FTFileName);
        Rewrite(f, 1);
      End
      Else
        FTStringResult := '';
      While True Do
      Begin
        If Terminated Then
        Begin
          If FTToFile Then CloseFile(f);
          FreeMem(Buf);
          CloseHandles;
          FTResult := False;
          Exit;
        End;
        If Not InternetReadFile(hRequest, @Data, SizeOf(Data), BytesToRead) Then
          Break
        Else
          If BytesToRead = 0 Then
            Break
          Else
          Begin
            If FTToFile Then
              BlockWrite(f, Data, BytesToRead)
            Else
            Begin
              TempStr := Data;
              SetLength(TempStr, BytesToRead);
              FTStringResult := FTStringResult + TempStr;
            End;
            inc(BytesReaded, BytesToRead);
            If Assigned(FTProgress) Then
              Synchronize(UpdateProgress);
          End;
      End;
      If FTToFile Then
        FTResult := FTFileSize = Integer(BytesReaded)
      Else
      Begin
        SetLength(FTStringResult, BytesReaded);
        FTResult := BytesReaded <> 0;
      End;
      If FTToFile Then CloseFile(f);
    End;
    FreeMem(Buf);
    CloseHandles;
  Except
  End;
End;
// HTTPGet
Constructor THTTPGet.Create(aOwner: TComponent);
Begin
  Inherited Create(aOwner);
  FAcceptTypes := '*/*';
  FAgent := 'UPX Shell 3.x update service';
End;
Destructor THTTPGet.Destroy;
Begin
  Abort;
  Inherited Destroy;
End;
Procedure THTTPGet.GetFile;
Var
  Msg: TMsg;
Begin
  If Not Assigned(FThread) Then
  Begin
    FThread := THTTPGetThread.Create(FAcceptTypes, FAgent, FURL, FFileName,
      FUserName, FPassword, FPostQuery, FReferer,
      FBinaryData, FUseCache, FProgress, True);
    FThread.OnTerminate := ThreadDone;
    If FWaitThread Then
      While Assigned(FThread) Do
        While PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Do
        Begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        End;
  End
End;
Procedure THTTPGet.GetString;
Var
  Msg: TMsg;
Begin
  If Not Assigned(FThread) Then
  Begin
    FThread := THTTPGetThread.Create(FAcceptTypes, FAgent, FURL, FFileName,
      FUserName, FPassword, FPostQuery, FReferer,
      FBinaryData, FUseCache, FProgress, False);
    FThread.OnTerminate := ThreadDone;
    If FWaitThread Then
      While Assigned(FThread) Do
        While PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Do
        Begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        End;
  End
End;
Procedure THTTPGet.Abort;
Begin
  If Assigned(FThread) Then
  Begin
    FThread.Terminate;
    FThread.FTResult := False;
  End;
End;
Procedure THTTPGet.ThreadDone(Sender: TObject);
Begin
  FResult := FThread.FTResult;
  If FResult Then
    If FThread.FTToFile Then
      If Assigned(FDoneFile) Then
        FDoneFile(Self, FThread.FTFileName, FThread.FTFileSize)
      Else
    Else
      If Assigned(FDoneString) Then
        FDoneString(Self, FThread.FTStringResult)
      Else
    Else
      If Assigned(FError) Then FError(Self);
      FThread := Nil;
End;
{ The end of HTTPGET stuff }
{========================================================================}
Var
  HttpGet: THttpGet;
Constructor TUpdateForm.Create(AOwner: TComponent; Url, LocalName: String);
Begin
  Inherited Create(AOwner);
  FUpdateUrl := Url;
  FLocalName := LocalName;
End;
Procedure TUpdateForm.Error(Sender: TObject);
Begin
  UpdateForm.lblStatus.Caption := TranslateMsg('...update failed :-(');
  beep;
  Application.MessageBox(TranslateMsg('Could not connect to update server!'),
    TranslateMsg('Error'), MB_OK + MB_ICONERROR);
End;
Procedure ParseFile(FileName: String);
Var
  News: Boolean;
  Procedure RemoveTags(Var Str: String);
  Var
    posit: Integer;
  Begin
    posit := pos('<', Str);
    If posit <> 0 Then
    Begin
      Delete(Str, 1, posit);
      posit := pos('>', Str);
      If posit <> 0 Then Delete(Str, posit, length(str));
    End;
  End;
  Procedure ParseLine(Str: String);
  Begin
    If pos('Name', Str) <> 0 Then
    Begin
      Delete(str, 1, 4);
      UpdateForm.grpUpdateInfo.Caption := UpdateForm.grpUpdateInfo.Caption + Str;
    End
    Else
      If pos('Release', Str) <> 0 Then
      Begin
        Delete(str, 1, 8);
        UpdateForm.lblRelease.Caption := Str;
      End
      Else
        If pos('Build', Str) <> 0 Then
        Begin
          Delete(str, 1, 6);
          UpdateForm.lblBuild.Caption := Str;
        End
        Else
          If pos('Date', Str) <> 0 Then
          Begin
            Delete(str, 1, 5);
            UpdateForm.lblDate.Caption := Str;
          End
          Else
            If pos('Size', Str) <> 0 Then
            Begin
              Delete(str, 1, 5);
              UpdateForm.lblSize.Caption := Str;
            End
            Else
              If str = 'News' Then
              Begin
                News := True;
                UpdateForm.memNews.Clear;
              End
              Else
                If News Then
                Begin
                  If Not (str = '/News') Then
                    UpdateForm.memNews.Lines.Add(Str)
                  Else
                    News := False;
                End
                Else
                  If pos('Download', Str) <> 0 Then
                  Begin
                    Delete(str, 1, 9);
                    UpdateForm.FUpdateDownload := str;
                    UpdateForm.lblDownload.Caption := Str;
                    UpdateForm.lblDownload.Cursor := crHandPoint;
                  End;
  End;
  Procedure CheckIfNew;
  Var
    Release, Major, Minor, Build: Integer;
    NRelease, NMajor, NMinor, NBuild: Integer;
    posit: Integer;
    temp: String;
  Begin
    Temp := UpdateForm.lblRelease.Caption;
    posit := pos('.', temp);
    NRelease := StrToInt(copy(temp, 1, posit - 1));
    Delete(temp, 1, posit);
    posit := pos('.', temp);
    NMajor := StrToInt(copy(temp, 1, posit - 1));
    Delete(temp, 1, posit);
    NMinor := StrToInt(temp);
    NBuild := StrToInt(UpdateForm.lblBuild.Caption);
    Temp := GetBuild(biFull);
    ;
    posit := pos('.', temp);
    Release := StrToInt(copy(temp, 1, posit - 1));
    Delete(temp, 1, posit);
    posit := pos('.', temp);
    Major := StrToInt(copy(temp, 1, posit - 1));
    Delete(temp, 1, posit);
    posit := pos('.', temp);
    Minor := StrToInt(copy(temp, 1, posit - 1));
    Delete(temp, 1, posit);
    Build := StrToInt(temp);
    If (NBuild > Build) Or (NMinor > Minor) Or
      (NMajor > Major) Or (NRelease > Release) Then
    Begin
      UpdateForm.lblDownload.Cursor := crHandPoint;
      UpdateForm.lblDownload.OnClick := UpdateForm.DownloadClick;
      UpdateForm.lblStatus.Caption := TranslateMsg('...update found');
      Application.MessageBox(TranslateMsg('Updated version of product found!'),
        TranslateMsg('Confirmation'), MB_OK + MB_ICONEXCLAMATION);
    End
    Else
      UpdateForm.lblStatus.Caption := TranslateMsg('...no updates found');
  End;
Var
  f: textfile;
  temp: String;
Begin
  News := False;
  AssignFile(f, FileName);
  reset(f);
  ReadLn(f, temp);
  If temp = UpdateHeader Then
  Begin
    While Not EOF(f) Do
    Begin
      ReadLn(f, temp);
      RemoveTags(temp);
      ParseLine(temp);
    End;
  End
  Else
  Begin
    UpdateForm.lblStatus.Caption := TranslateMsg('...update failed :-(');
    beep;
    Application.MessageBox(TranslateMsg('Could not connect to update server!'),
      TranslateMsg('Error'), MB_OK + MB_ICONERROR);
  End;
  CloseFile(f);
  CheckIfNew;
End;
Procedure TUpdateForm.UpdateDone(Sender: TObject; FileName: String; FileSize: Integer);
Begin
  If FileSize = 0 Then
  Begin
    UpdateForm.lblStatus.Caption := TranslateMsg('...update failed :-(');
    beep;
    Application.MessageBox(TranslateMsg('Could not connect to update server!'),
      TranslateMsg('Error'), MB_OK + MB_ICONERROR);
  End
  Else
  Begin
    lblStatus.Caption := TranslateMsg('Parsing update file...');
    ParseFile(FLocalName);
  End;
  btnOk.Enabled := True;
End;
Procedure TUpdateForm.CheckForUpdate;
Begin
  lblStatus.Caption := TranslateMsg('Retrieving update information...');
  HttpGet := THttpGet.Create(UpdateForm);
  HttpGet.URL := FUpdateUrl;
  HttpGet.FileName := FLocalName;
  HttpGet.OnError := Error;
  HttpGet.OnDoneFile := UpdateDone;
  HttpGet.GetFile;
End;
Procedure TUpdateForm.FormCreate(Sender: TObject);
Var
  Save: LongInt;
Begin
  //The following code removes the form caption bar
  If BorderStyle = bsNone Then Exit;
  Save := GetWindowLong(Handle, GWL_STYLE);
  If (Save And WS_CAPTION) = WS_CAPTION Then
  Begin
    Case BorderStyle Of
      bsSingle, bsSizeable: SetWindowLong(Handle, GWL_STYLE,
          Save And (Not WS_CAPTION) Or WS_BORDER);
      bsDialog: SetWindowLong(Handle, GWL_STYLE,
          Save And (Not WS_CAPTION) Or DS_MODALFRAME Or WS_DLGFRAME);
    End;
    Height := Height - GetSystemMetrics(SM_CYCAPTION);
    Refresh;
  End;
  Application.ProcessMessages;
  memNews.Clear;
  memNews.Lines.Add(TranslateMsg('N/A'));
  CheckForUpdate;
End;
Procedure TUpdateForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  HttpGet.Free;
  DeleteFile(FLocalName);
End;
Procedure TUpdateForm.FormActivate(Sender: TObject);
Begin
  TranslateForm(UpdateForm);
End;
Procedure TUpdateForm.DownloadClick(Sender: TObject);
Begin
  ShellExecute(GetDesktopWindow(), 'open', PChar(FUpdateDownload), Nil, Nil, SW_SHOWNORMAL);
End;
End.

