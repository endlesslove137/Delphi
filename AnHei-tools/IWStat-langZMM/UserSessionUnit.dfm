object IWUserSession: TIWUserSession
  OldCreateOrder = False
  OnDestroy = IWUserSessionBaseDestroy
  Height = 587
  Width = 711
  object SQLConnectionLog: TSQLConnection
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
    Left = 45
    Top = 10
  end
  object quOnlineCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 120
    Top = 56
  end
  object SQLConnectionRole: TSQLConnection
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
    Left = 48
    Top = 312
  end
  object quConsume: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 178
    Top = 56
  end
  object quCommon: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 584
    Top = 8
  end
  object quCountryCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 120
    Top = 360
  end
  object quRoleCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 523
    Top = 310
  end
  object quRoleLevel: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 468
    Top = 312
  end
  object quLevelRole: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 294
    Top = 360
  end
  object quLoginCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 642
    Top = 8
  end
  object quAccountCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 352
    Top = 56
  end
  object SQLConnectionSession: TSQLConnection
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
    Left = 40
    Top = 424
  end
  object quUserCount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 526
    Top = 416
  end
  object quAccountLoss: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 410
    Top = 56
  end
  object quPay: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 468
    Top = 416
  end
  object quPayOrder: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 584
    Top = 416
  end
  object quUserConsume: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 236
    Top = 56
  end
  object quUserConsumeOrder: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 294
    Top = 56
  end
  object quGlobalOnline: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 236
    Top = 8
  end
  object quGlobalPay: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 120
    Top = 464
  end
  object quHumLog: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 294
    Top = 8
  end
  object quLoginLog: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 178
    Top = 104
  end
  object quItemTrace: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 120
    Top = 8
  end
  object quCurOnline: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 178
    Top = 8
  end
  object quShop: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 468
    Top = 8
  end
  object quWebGrid: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 236
    Top = 360
  end
  object quLoss: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 178
    Top = 360
  end
  object quItems: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 236
    Top = 312
  end
  object quRole: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 178
    Top = 312
  end
  object quRoleStayTime: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 642
    Top = 416
  end
  object quCreateAccount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 120
    Top = 312
  end
  object quAccountType: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 410
    Top = 312
  end
  object quSCommon: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 411
    Top = 414
  end
  object quPayUser: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 178
    Top = 416
  end
  object quPayAllUser: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 120
    Top = 416
  end
  object quRoleAction: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 526
    Top = 8
  end
  object quAcross: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 352
    Top = 8
  end
  object quActivityItem: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 236
    Top = 416
  end
  object quReputeShop: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 410
    Top = 8
  end
  object quAvgOnline: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 468
    Top = 104
  end
  object quGlobalAccount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 352
    Top = 416
  end
  object quGiftLog: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 294
    Top = 416
  end
  object SQLConnectionTest: TSQLConnection
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
    Left = 40
    Top = 520
  end
  object quTest: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionTest
    Left = 120
    Top = 520
  end
  object quLoginStatus: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 526
    Top = 104
  end
  object quActivityRItem: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 352
    Top = 312
  end
  object quOperateLog: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 352
    Top = 104
  end
  object quBugInfo: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 410
    Top = 104
  end
  object quSeedGold: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 120
    Top = 152
  end
  object quDmkjGold: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 178
    Top = 152
  end
  object quInsiderAccount: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 584
    Top = 104
  end
  object quExrtGoldTotal: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 642
    Top = 104
  end
  object quMapOnline: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 584
    Top = 56
  end
  object quHumDie: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 642
    Top = 56
  end
  object quCopytrack: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 468
    Top = 56
  end
  object quMondie: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 526
    Top = 56
  end
  object quMonKillhum: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 236
    Top = 104
  end
  object quExrtHonourTotal: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 294
    Top = 104
  end
  object quAccountAgain: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 120
    Top = 104
  end
  object quUserInfo: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionRole
    Left = 294
    Top = 312
  end
  object SQLConnectionLocalLog: TSQLConnection
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
    Left = 53
    Top = 218
  end
  object quHumLogEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 290
    Top = 218
  end
  object quItemTraceEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 348
    Top = 218
  end
  object quExrtGoldTotalEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 405
    Top = 218
  end
  object quMondieEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 118
    Top = 218
  end
  object quHumDieEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 174
    Top = 218
  end
  object quMapOnlineEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 232
    Top = 218
  end
  object quCopytrackEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 456
    Top = 219
  end
  object quMonKillhumEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 514
    Top = 219
  end
  object quCommonEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 572
    Top = 219
  end
  object quRobotInfo: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 237
    Top = 153
  end
  object quVaser: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionSession
    Left = 185
    Top = 468
  end
  object quConsumeEx: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLocalLog
    Left = 630
    Top = 219
  end
  object quASunPay: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectionLog
    Left = 295
    Top = 153
  end
end
