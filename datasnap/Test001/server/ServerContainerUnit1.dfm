object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 317
  Width = 447
  object DSServer1: TDSServer
    Left = 96
    Top = 11
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    Filters = <
      item
        FilterId = 'PC1'
        Properties.Strings = (
          'Key=xT5GitwxrezyMERb')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end>
    AuthenticationManager = DSAuthenticationManager1
    Left = 96
    Top = 73
  end
  object DSHTTPService1: TDSHTTPService
    HttpPort = 8080
    Server = DSServer1
    Filters = <
      item
        FilterId = 'PC1'
        Properties.Strings = (
          'Key=81XXwWCgf4UxeBYi')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end>
    AuthenticationManager = DSAuthenticationManager1
    Left = 96
    Top = 135
  end
  object DSAuthenticationManager1: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManager1UserAuthenticate
    OnUserAuthorize = DSAuthenticationManager1UserAuthorize
    Roles = <
      item
        DeniedRoles.Strings = (
          'Guest')
        ApplyTo.Strings = (
          'TServerMethods1')
      end>
    Left = 96
    Top = 197
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 200
    Top = 11
  end
  object DSHTTPServiceProxyDispatcher1: TDSHTTPServiceProxyDispatcher
    Service = DSHTTPService1
    WebFileExtensions = <
      item
        MimeType = 'application/x-zip-compressed'
        Extensions = 'zip'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '\proxy\*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\proxy\*\*'
      end>
    DSProxyGenerator = DSProxyGenerator1
    Left = 312
    Top = 160
  end
  object DSProxyGenerator1: TDSProxyGenerator
    MetaDataProvider = DSServerMetaDataProvider1
    TargetUnitName = 'ServerFunctions.js'
    TargetDirectory = 'js'
    Writer = 'Java Script REST'
    Left = 320
    Top = 96
  end
  object DSServerMetaDataProvider1: TDSServerMetaDataProvider
    Server = DSServer1
    Left = 320
    Top = 40
  end
  object DSHTTPServiceFileDispatcher1: TDSHTTPServiceFileDispatcher
    Service = DSHTTPService1
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    Left = 312
    Top = 216
  end
end
