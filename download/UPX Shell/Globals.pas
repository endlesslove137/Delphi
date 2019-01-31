 {**************--===ION Tek===--****************}
 { Global constants, variables and types unit    }
 {***********************************************}
unit Globals;

interface

const
  //Contains original english messages
  MsgCount = 43;
  EngMsgs: array[1..MsgCount] of string = (
    'Could not access file. It may be allready open',
    'The file attribute is set to ReadOnly. To proceed it must be unset. Continue?',
    'Best',
    'This file doesn''t seem to be packed. Run the Scrambler?',
    ' (in ',
    ' seconds)',
    'decompress',
    'compress',
    'There is nothing to ',
    'N/A',
    'No directory selected',
    '...update failed :-(',
    'Could not connect to update server!',
    'Updated version of product found!',
    'Parsing update file...',
    'Retrieving update information...',
    'File successfully compressed',
    'File successfully decompressed',
    'File compressed with warnings',
    'File decompressed with warnings',
    'Errors occured. File not compressed',
    'Errors occured. File not decompressed',
    ' & tested',
    ' & tested w/warnings',
    ' & test failed',
    'UPX returned following error: ',
    ' & scrambled',
    '...update found',
    '...no updates found',
    'OK',
    'Failed',
    'Skip',
    'File Name',
    'Folder',
    'Size',
    'Packed',
    'Result',
    'Error',
    'Confirmation',
    'Select directory to compress:',
    'This file is now Scrambled!',
    'This file has NOT been scrambled!',
    'Compress with UPX'
    );

type
  // The global configuration type
  TConfig = record
    DebugMode: boolean;     // Are we in debug mode?
    LocalizerMode: boolean; // Translation editor's mode
  end;

var
  Config:    TConfig;     // Holds the global application configuration
  GlobFileName: string;   //Holds the opened file name
  WorkDir:   string;      //Holds the working directory of UPX Shell
  LangFile:  string;      //Holds the current language file name
  Extension: integer = 1; //Contains OpenDialog last selected extension
  FileSize:  integer;     //Contains file size for ratio calculation
  Busy:      boolean = False; //Set when compressing or scrambling files
  hStdOut:   THandle;     //Contains handle to standard console output
  UpxExist:  boolean;     //Set if there is an external version of UPX
  UpsExist:  boolean;     //The same but for scrambler
  CompressionResult: boolean = False; // Result of the compress operation
  Messages:  array[1..MsgCount] of string;
  //Contains translated versions of messages
  sUPXVersion: string; //Contains the UPXVersion the file is compressed with
  bStdUPXVersion: byte;
//Contains the default UPXVersion selected 1=v1.25 2=v1.93

type
  TKeyType = (ktString, ktInteger, ktBoolean); //Passed to ReadKey and StoreKey

  TRegValue = record //This one is returned by ReadKey and passed to StoreKey
    Str: string;
    Int: integer;
    Bool: boolean;
  end;
  //The following is used to get UPX Shell build info
  TBuildInfo = (biFull, biNoBuild, biMajor, biMinor, biRelease,
    biBuild, biCute);
  TLine      = array[0..500] of char;     //Used in getting the DOS line
  TExtractDelete = (edExtract, edDelete); //Used for ExtractUPX()
  TCompDecomp = (cdCompress, cdDecompress);
  //Passed to CompressFile() and holds
  // whether to compress or decompress the file
  TCompResult = (crSuccess, crWarning, crError); //Passed to SetStatus()

  TToken = record
    Token: ShortString;
    Value: ShortString;
  end;
  TTokenStr = array of TToken;

  TComponentProperty = record
    Name: string;
    Value: string;
  end;
  TComponentProperties = record
    Name: string;
    Properties: array of TComponentProperty;
  end;

  {Global Proecedures}
  procedure RegisterExtensions(const InArr: array of string; const FilePath, Key: string);
  procedure UnRegisterExtensions(const InArr: array of string; const KillPath: string; Key2Kill: string);
  procedure IntergrateContext(const LangChange: Boolean = false);

implementation

uses
  Windows, SysUtils, Registry,
  Translator,
  MainFrm, SetupFrm;

procedure IntergrateContext(const LangChange: Boolean = false);
const
  KeyPath   = '\Shell';
  //ActionKey = '\Compress with UPX';
  //FullKey   = KeyPath + ActionKey + '\Command';
var
  Path: string;
  ActionKey: string;
  OldActionKey: string;
  FullKey: string;
  reg: TRegistry;
begin
  Path := workdir + 'UPXShell.exe "%L"';
  ActionKey := '\' + Trim(TranslateMsg('Compress with UPX'));
  FullKey := KeyPath + ActionKey + '\Command';

  if SetupForm.chkIntegrate.Checked then
  begin
    //Check if the language has been changed and remove the old ActionKey first.
    if LangChange then
    begin
      reg := TRegistry.Create;
      try
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('Software\ION Tek\UPX Shell\3.x', False);
        if reg.ValueExists('OldContext') then
        begin
          OldActionKey := '\' + Trim(reg.ReadString('OldContext'));
        end;
      finally
        Reg.CloseKey;
        FreeAndNil(reg);
      end;
      UnRegisterExtensions(['.bpl', '.com', '.dll', '.dpl', '.exe', '.ocx', '.scr',
        '.sys', '.acm', '.ax'], KeyPath, OldActionKey);
    end;

    //Add the (new) ActionKey to the registry.
    RegisterExtensions(['.bpl', '.com', '.dll', '.dpl', '.exe', '.ocx', '.scr',
      '.sys', '.acm', '.ax'], Path, FullKey);
  end
  else begin
    UnRegisterExtensions(['.bpl', '.com', '.dll', '.dpl', '.exe', '.ocx', '.scr',
      '.sys', '.acm', '.ax'], KeyPath, ActionKey);
  end;
end;

procedure RegisterExtensions(const InArr: array of string;
  const FilePath, Key: string);
var
  reg: TRegistry;
  i:   integer;
  def: string;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    for i := high(InArr) downto 0 do
    begin
      reg.OpenKey(InArr[i], True);
      def := reg.ReadString('');
      reg.CloseKey;
      if def = '' then
      begin
        def := copy(InArr[i], 2, 3) + 'file';
      end;
      reg.OpenKey(def + Key, True);
      reg.WriteString('', FilePath);
      reg.CloseKey;
    end;
  finally
    FreeAndNil(reg);
  end;
end;

procedure UnRegisterExtensions(const InArr: array of string;
  const KillPath: string; Key2Kill: string);
var
  reg: TRegistry;
  i:   integer;
  def: string;
begin
  Delete(Key2Kill, 1, 1);
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    for i := high(InArr) downto 0 do
    begin
      reg.OpenKey(InArr[i], True);
      def := reg.ReadString('');
      reg.CloseKey;
      if def <> '' then
      begin
        reg.OpenKey(def + KillPath, False);
        reg.DeleteKey(Key2Kill);
        reg.CloseKey;
      end;
    end;
  finally
    FreeAndNil(reg);
  end;
end;


end.

