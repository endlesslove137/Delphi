object CommandsForm: TCommandsForm
  Left = 289
  Top = 105
  BorderStyle = bsToolWindow
  Caption = 'UPX Commands'
  ClientHeight = 333
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmoCommands: TMemo
    Left = 0
    Top = 0
    Width = 549
    Height = 333
    Cursor = crArrow
    Align = alClient
    BorderStyle = bsNone
    Color = cl3DLight
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Version 1.25'
      'Commands:'
      '  -1     compress faster                   -9    compress better'
      '  --best compress best (can be very slow for big files)'
      
        '  -d     decompress                        -l    list compressed' +
        ' file'
      
        '  -t     test compressed file              -V    display version' +
        ' number'
      
        '  -h     give this help                    -L    display softwar' +
        'e license'
      ''
      'Options:'
      '  -q     be quiet                          -v    be verbose'
      '  -oFILE write output to `FILE'#39
      '  -f     force compression of suspicious files'
      '  --no-color, --mono, --color, --no-progress   change look'
      ''
      'Backup options:'
      '  -k, --backup        keep backup files'
      '  --no-backup         no backup files [default]'
      ''
      'Overlay options:'
      
        '  --overlay=copy      copy any extra data attached to the file [' +
        'default]'
      
        '  --overlay=strip     strip any extra data attached to the file ' +
        '[dangerous]'
      '  --overlay=skip      don'#39't compress a file with an overlay'
      ''
      'Options for dos/com:'
      '  --8086              make compressed com work on any 8086'
      ''
      'Options for dos/exe:'
      '  --8086              make compressed exe work on any 8086'
      '  --no-reloc          put no relocations in to the exe header'
      ''
      'Options for dos/sys:'
      '  --8086              make compressed sys work on any 8086'
      ''
      'Options for djgpp2/coff:'
      '  --coff              produce COFF output [default: EXE]'
      ''
      'Options for watcom/le:'
      '  --le                produce LE output [default: EXE]'
      ''
      'Options for win32/pe & rtm32/pe:'
      '  --compress-exports=0    do not compress the export section'
      '  --compress-exports=1    compress the export section [default]'
      '  --compress-icons=0      do not compress any icons'
      '  --compress-icons=1      compress all but the first icon'
      
        '  --compress-icons=2      compress all but the first icon direct' +
        'ory '
      '[default]'
      '  --compress-resources=0  do not compress any resources at all'
      '  --strip-relocs=0        do not strip relocations'
      '  --strip-relocs=1        strip relocations [default]'
      ''
      '  file.. executables to (de)compress'
      ''
      
        'This version supports: dos/exe, dos/com, dos/sys, djgpp2/coff, w' +
        'atcom/le,'
      
        '                       win32/pe, rtm32/pe, tmt/adam, atari/tos, ' +
        'linux/386'
      ''
      
        'UPX comes with ABSOLUTELY NO WARRANTY; for details type `upx -L'#39 +
        '.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
end
