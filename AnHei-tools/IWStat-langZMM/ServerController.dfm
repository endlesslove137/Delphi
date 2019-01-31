object IWServerController: TIWServerController
  OldCreateOrder = False
  OnCreate = IWServerControllerBaseCreate
  OnDestroy = IWServerControllerBaseDestroy
  AuthBeforeNewSession = False
  AppName = 'IWDataStat'
  CharSet = 'UTF-8'
  CacheExpiry = 120
  ComInitialization = ciMultiThreaded
  Compression.Enabled = False
  Compression.Level = 6
  Description = 'LhzsDataManager'
  DebugHTML = False
  DisplayName = 'IntraWeb (VCL for the Web) Application'
  Log = loNone
  EnableImageToolbar = False
  ExceptionDisplayMode = smAlert
  HistoryEnabled = False
  InternalFilesURL = '/'
  JavascriptDebug = False
  PageTransitions = False
  Port = 89
  RedirectMsgDelay = 0
  ServerResizeTimeout = 0
  ShowLoadingAnimation = True
  SessionTimeout = 20
  SSLOptions.NonSSLRequest = nsAccept
  SSLOptions.Port = 0
  SSLOptions.SSLVersion = sslv3
  Version = '11.0.58'
  OnCloseSession = IWServerControllerBaseCloseSession
  OnNewSession = IWServerControllerBaseNewSession
  OnBackButton = IWServerControllerBaseBackButton
  OnAfterRender = IWServerControllerBaseAfterRender
  AllowIE6 = False
  Height = 624
  Width = 499
  object TimerAutoRun: TTimer
    OnTimer = TimerAutoRunTimer
    Left = 378
    Top = 130
  end
  object IdHTTPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 95
    AutoStartSession = True
    SessionTimeOut = 60000
    Left = 308
    Top = 12
  end
  object TimerAutoUpdate: TTimer
    Interval = 1800000
    OnTimer = TimerAutoUpdateTimer
    Left = 77
    Top = 10
  end
  object TimerNoticeRun: TTimer
    Enabled = False
    OnTimer = TimerNoticeRunTimer
    Left = 19
    Top = 10
  end
  object SQLConnectionRAuto: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 127
    Top = 67
  end
  object quRobotInfo: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRAuto
    Left = 359
    Top = 67
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = SendTimerTimer
    Left = 193
    Top = 10
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerStartTimer
    Left = 135
    Top = 10
  end
  object ASumTime1: TTimer
    Interval = 600000
    OnTimer = ASumTime1Timer
    Left = 251
    Top = 10
  end
  object SQLConnectionASumMoney: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 11
    Top = 67
  end
  object quASumMoney: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionASumMoney
    Left = 417
    Top = 67
  end
  object SQLConnectionASumOL: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 69
    Top = 67
  end
  object quASumOL: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionASumOL
    Left = 301
    Top = 67
  end
  object quASumchg: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionASumChg
    Left = 243
    Top = 67
  end
  object SQLConnectionASumChg: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 185
    Top = 67
  end
end
