unit ZipArchive;

interface

uses
  Windows, SysUtils, classes;

const
(*  文件头标记定义   *)
  ZHI_LOCALHEADER       = $04034B50;  //局部文件头标记      
  ZHI_DATADESCRIPTION   = $08074B50;  //数据描述段标记    
  ZHI_CENTRALDIRECTORY  = $02014B50;  //文件目录区标记
  ZHI_ENDDIRECTORY      = $06054B50;  //文件目录区结束标记

(*  全局标志位定义   *)
  ZMASK_DATADESC        = $0008;    //包含数据描述段

(*  压缩方式定义  *)
  ZCM_Stored          = 0;    //No compression used
  ZCM_Shrunk          = 1;    //LZW, 8K buffer, 9-13 bits with partial clearing
  ZCM_Reduced_1       = 2;    //Probalistic compression, L(X) = lower 7 bits
  ZCM_Reduced_2       = 3;    //Probalistic compression, L(X) = lower 6 bits
  ZCM_Reduced_3       = 4;    //Probalistic compression, L(X) = lower 5 bits
  ZCM_Reduced_4       = 5;    //Probalistic compression, L(X) = lower 4 bits
  ZCM_Imploded_1      = 6;    //2 Shanno-Fano trees, 4K sliding dictionary
  ZCM_Imploded_2      = 7;    //3 Shanno-Fano trees, 4K sliding dictionary
  ZCM_Imploded_3      = 8;    //2 Shanno-Fano trees, 8K sliding dictionary
  ZCM_Imploded_4      = 9;    //3 Shanno-Fano trees, 8K sliding dictionary  Deflate64

type
(*  文件头标记   *)
  TZIPHeaderIdent = packed record
    case Integer of
      0:(uIdent: UINT);
      1:(sIdent: array [0..3] of Char);
  end;

(*  局部文件信息  *)
  TZIPLocalFileInfo = packed record  
    wDecmprPKWareVer  : Word;             //解压文件所需 pkware 版本
    wGlobalMasks      : Word;             //全局方式位标记
    wCompressType     : Word;             //压缩方式
    wLastModTime      : Word;             //最后修改文件时间
    wLastModDate      : Word;             //最后修改文件日期
    CRC32             : DWORD;            //CRC-32校验
    dwCompressedSize  : DWORD;            //压缩后尺寸
    dwUncompressedSize: DWORD;            //未压缩尺寸
    wFileNameSize     : Word;             //文件名长度
    wExtendRecordSize : Word;             //扩展记录长度
  end;
  
(*  局部文件头   *)
  TZIPLocalHeader = packed record
    Ident             : TZIPHeaderIdent;  //文件头标记:0x04034b50
    FileInfo          : TZIPLocalFileInfo;//文件信息     
  end;       
  //文件名                       （不定长度）
  //扩展字段                     （不定长度）
  PZIPLocalHeader = ^TZIPLocalHeader;

(*  数据描述符   *)
{
  这个数据描述符只在全局方式位标记的第３位设为１时才存在（见后详解），
  紧接在压缩数据的最后一个字节后。这个数据描述符只用在不能对输出的ZIP
  文件进行检索时使用。例如：在一个不能检索的驱动器（如：磁带机上）上
  的ZIP文件中。如果是磁盘上的ZIP文件一般没有这个数据描述符。
}
  TZIPDataDescriptor = packed record
    Ident             : TZIPHeaderIdent;  //文件头标记:0x08074b50
    CRC32             : DWORD;            //CRC-32校验
    dwCompressedSize  : DWord;            //压缩后尺寸
    dwUncompressedSize: DWord;            //未压缩尺寸
  end;
  PZIPDataDescriptor = ^TZIPDataDescriptor;

(*  文件目录区   *)
  TZIPCentralDirectory = packed record      
    Ident             : TZIPHeaderIdent;  //文件头标记:0x02014b50
    wCmprPKWareVer    : Word;             //压缩使用的　pkware 版本
    FileInfo          : TZIPLocalFileInfo;//文件信息
    wFileCommentSize  : Word;             //文件注释长度
    wDiskStart        : Word;             //磁盘开始号
    wInternalAttribute: Word;             //内部文件属性
    dwExternalAttribute:DWORD;            //外部文件属性
    dwLocalHeaderOffset:DWORD;            //局部头部偏移量
  end;
  //文件名                       （不定长度）
  //扩展字段                     （不定长度）
  //文件注释                     （不定长度）
  PZIPCentralDirectory = ^TZIPCentralDirectory;

(*  文件目录结束标志  *)
  TZIPEndDirectory = packed record
    Ident                 : TZIPHeaderIdent;  //文件头标记:0x06054b50
    wCurrentDiskNo        : Word;             //当前磁盘编号
    wDirectoryStartDiskNo : Word;             //目录区开始磁盘编号
    wCurrentDiskLocalCount: Word;             //本磁盘上纪录总数
    wDirectoryCount       : Word;             //目录区中纪录总数
    wDirectorySize        : DWORD;            //目录区尺寸大小
    wDirectoryOffset      : DWORD;            //目录区对第一张磁盘的偏移量
    wZIPCommentSize       : Word;             //ZIP 文件注释长度
  end;
  //ZIP 文件注释                   （不定长度）
  PZIPEndDirectory = ^TZIPEndDirectory;


(*  ZIP档案文件使用封装类  *)  
  TArchiveOperationType = ( aoNone, aoAdd, aoDel, aoRename );

  EZIPStreamEOF = class (Exception)
  public
    constructor Create();
  end;

  EInvalidZIPHeader = class (Exception)
  public
    constructor Create(dwIdent: DWord);
  end;

  EZIPFileCRCError = class (Exception)
  public
    constructor Create(sFileName: string);
  end;

  EZIPFileSizeCheckError = class (Exception)
  public
    constructor Create(sFileName: string);
  end;

  EZIPDirectoryValidataError = class (Exception)
  public
    constructor Create();
  end;

  EZIPUndefinedCompressMethod = class (Exception)
  public
    constructor Create(nMethod: Integer);
  end;

  EInvalidZIPFileOperate = class (Exception)
  public
    constructor Create();
  end;

  EOutOfZIPDataSize = class (Exception)
  public
    constructor Create(DataSize: Integer);
  end;

  EInvalidZLibCompressLevel = class (Exception)
  public
    constructor Create(CompressLevel: Integer);
  end;

  EZIPLocalFileExists = class (Exception)
  public
    constructor Create(sFileName: string);
  end;

  EZIPLocalFileNotExists = class (Exception)
  public
    constructor Create(sFileName: string);
  end;

  EZIPOperationNotSupport = class (Exception)
  public
    constructor Create();
  end;

  EZIPArchiveOperationNotFlushed = class (Exception)
  public
    constructor Create(opType: TArchiveOperationType);
  end;
                            
  TCustomZIPLocalFile = class;
  TCustomZIPArchiver = class;
                                                                            
  TZIPWorkStart = procedure (Sender: TObject; MaxProgress: Int64) of Object;
  TZIPWorkProgress = procedure (Sender: TObject; Progress: Int64) of Object;
  TZIPWorkComplete = TNotifyEvent;
  TZIPFileWorkStart = procedure (Sender: TObject; AFile: TCustomZIPLocalFile;
    MaxProgress: Int64) of Object;
  TZIPFileWorkProgress = procedure (Sender: TObject; AFile: TCustomZIPLocalFile;
    Progress: Int64) of Object;
  TZIPFileWorkComplete = procedure (Sender: TObject; AFile: TCustomZIPLocalFile) of Object;


  TCustomZIPLocalFile = class
  private
    m_ZIPArchiver: TCustomZIPArchiver;
    m_LocalHeader: TZIPLocalHeader;
    m_Directory  : TZIPCentralDirectory;
    m_sFileName  : string;
    m_pExtendData: Pointer;
    m_sComment: string;
    m_nCompressLevel: Integer;
    m_dwDataOffset: DWord;
    constructor CreateFromDirectory(AZIPArchiver: TCustomZIPArchiver;
      pDirectory: PZIPCentralDirectory);
    function GetLastModDateTime: TDateTime;
    procedure RestoreToStream(ToStream: TStream; Size: Int64);
    procedure DecompressZLIBToStream(strmHdr: Word; ToStream: TStream);
    class function GetZlibStreamHeader(CompMode: integer): word; static;
    class function GetZlibInBlockSize(CompMode: integer): word; static;
    function GetIsFloder: Boolean;
    function GetLastModFileDateTime: TFileTime;
    function GetCompressLevel: Integer;
    function GetCompressionRate: Single;    
    function GetUsingDataDesc: Boolean;     
    procedure SetFileName(const Value: string);
    function CopyToStream(ToStream: TStream): Integer;
  public
    constructor Create(AZIPArchiver: TCustomZIPArchiver);virtual;
    destructor Destroy();override;

    procedure SetExtendData(const Data; const DataSize: Integer);virtual;
    procedure SetCompressLevel(const Value: Integer);virtual;
    procedure SetUsingDataDesc(const Value: Boolean);virtual;
    procedure SetComment(const Value: string);virtual;

    procedure Decompress(ToStream: TStream);
    procedure Extract(BaseDir: string);
    procedure ExtractTo(const sFileName: string);

    property DecompressPKWareVersion: Word read m_LocalHeader.FileInfo.wDecmprPKWareVer;
    property GlobalMasks: Word read m_LocalHeader.FileInfo.wGlobalMasks;
    property CompressType: Word read m_LocalHeader.FileInfo.wCompressType;
    property LastModDateTime: TDateTime read GetLastModDateTime;
    property LastModFileDateTime: TFileTime read GetLastModFileDateTime;
    property CRC: DWord read m_LocalHeader.FileInfo.CRC32;
    property CompressedSize: DWord read m_LocalHeader.FileInfo.dwCompressedSize;
    property UncompressedSize: DWord read m_LocalHeader.FileInfo.dwUncompressedSize;
    property ExtendDataSize: Word read m_LocalHeader.FileInfo.wExtendRecordSize;
    property UsingDataDesc: Boolean read GetUsingDataDesc write SetUsingDataDesc;

    property CommentSize: Word read m_Directory.wFileCommentSize;
    property DiskStart: Word read m_Directory.wDiskStart;
    property InternalAttribute: Word read m_Directory.wInternalAttribute;
    property ExternalAttribute: DWord read m_Directory.dwExternalAttribute;

    property FileName: string read m_sFileName write SetFileName;
    property ExtendData: Pointer read m_pExtendData;
    property Comment: string read m_sComment write SetComment;
    property IsFloder: Boolean read GetIsFloder;
    property CompressLevel: Integer read GetCompressLevel write SetCompressLevel;
    property CompressionRate: Single read GetCompressionRate;
  end;

  TAddZIPLocalFile = class(TCustomZIPLocalFile)
  private
    m_nLocalFileSize: Int64;
    m_sSourceFileName: string;
    procedure MakeFileInfo();
    procedure CompressFileToStream(ToStream: TStream);
    procedure StoreStreamToStream(SrcStream, ToStream: TStream; SrcSize: Int64);
    procedure ZLIBCompressStreamToStream(SrcStream, ToStream: TStream; SrcSize: Int64);
  public
    constructor Create(AZIPArchiver: TCustomZIPArchiver);override;
    procedure SetExtendData(const Data; const DataSize: Integer);override;
    procedure SetCompressLevel(const Value: Integer);override;
    procedure SetUsingDataDesc(const Value: Boolean);override;
    procedure SetComment(const Value: string);override;

    property SourceFileName: string read m_sSourceFileName;
  end;

  TCustomZIPArchiver = class
  private
    m_DirectoryList: TStrings;
    m_WaitFlushFiles: TStrings;
    m_Stream: TStream;
    m_sComment: string;
    m_dwDirectoryOffset: DWord;
    m_btFlushType: TArchiveOperationType;
    m_nDataStart: Int64;
    m_nDataEnd: Int64;
    m_nWorkMax: Int64;
    m_nWorkProgress: Int64;
    m_OnWorkStart: TZIPWorkStart;
    m_OnWorkProgress: TZIPWorkProgress;
    m_OnWorkComplete: TZIPWorkComplete;
    m_OnFileWorkStart: TZIPFileWorkStart;
    m_OnFileWorkProgress: TZIPFileWorkProgress;
    m_OnFileWorkComplete: TZIPFileWorkComplete;
  private
    procedure CleanFiles(FileList: TStrings);
    procedure ResetArchive();
    function ReadString(const ALength: Integer): string;
    procedure ReadStream(var Buf; const Size: Int64);overload;
    class procedure ReadStream(AStream: TStream; var Buf; const Size: Int64);overload;
    procedure AllocAndRead(var p: Pointer; Size: Int64);     
    procedure ReadArchive(const StartPosition: Int64 = -1);
    function GetFile(Index: Integer): TCustomZIPLocalFile;
    function GetFileCount: Integer;
    function GetFileByName(FileList: TStrings; sFileName: string; pIndex: PInteger = nil): TCustomZIPLocalFile;overload;
    procedure RewriteDirectorys(ToStream: TStream);
    procedure OperationNotFlushed(opType: TArchiveOperationType);
    function CreateTempStream(): TStream;virtual;
    procedure FreeTempStream(AStream: TStream);virtual;
    procedure CopyBackDataFromTempStream(var TempStream: TStream);virtual;
    procedure CalcProgressMax(opType: TArchiveOperationType);
    procedure ReadyForAdd();virtual;
    procedure EndForAdd();virtual;
    function FlushAddFiles():Integer;
    function FlushDelFiles():Integer;
    function FlushRenameFiles():Integer;
  private                                                  
    procedure WorkStart(MaxProgress: Int64);
    procedure WorkProgress(Progress: Int64);
    procedure WorkComplete();
    procedure InrementTotalProgress(const IncValue: Int64);
    procedure FileWorkStart(AFile: TCustomZIPLocalFile; MaxProgress: Int64);
    procedure FileWorkProgress(AFile: TCustomZIPLocalFile; Progress: Int64);
    procedure FileWorkComplete(AFile: TCustomZIPLocalFile);
  public
    constructor Create();virtual;
    destructor Destroy();override;

    function GetFileByName(sFileName: string): TCustomZIPLocalFile;overload;
    function AddFile(sSourceFile, sLocalFile: string):TAddZIPLocalFile;
    procedure DeleteFile(sLocalFile: string);
    procedure RenameFile(sLocalFile, sNewFile: string);
    function FlushChanges():Integer;
    procedure SetStream(AStream: TStream);virtual;
    procedure Extract(BaseDir: string);

    property FileCount: Integer read GetFileCount;
    property Files[Index: Integer]: TCustomZIPLocalFile read GetFile;

    property Comment: string read m_sComment;

    property OnWorkStart: TZIPWorkStart read m_OnWorkStart write m_OnWorkStart;
    property OnWorkProgress: TZIPWorkProgress read m_OnWorkProgress write m_OnWorkProgress;
    property OnWorkComplete: TZIPWorkComplete read m_OnWorkComplete write m_OnWorkComplete;
    property OnFileWorkStart: TZIPFileWorkStart read m_OnFileWorkStart write m_OnFileWorkStart;
    property OnFileWorkProgress: TZIPFileWorkProgress read m_OnFileWorkProgress write m_OnFileWorkProgress;
    property OnFileWorkComplete: TZIPFileWorkComplete read m_OnFileWorkComplete write m_OnFileWorkComplete;
  end;

  TStreamZIPArchive = class(TCustomZIPArchiver)
  public
    procedure SetStream(AStream: TStream);override;
  end;

  TMemoryZIPArchive = class(TCustomZIPArchiver)
  private
    function CreateTempStream(): TStream;override;
    procedure CopyBackDataFromTempStream(var TempStream: TStream);override;
  public        
    constructor Create();override;
    destructor Destroy();override;

    procedure SetStream(AStream: TStream);override;

    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(const FileName: string);
  end;

  TFileZIPArchive = class (TCustomZIPArchiver)
  private
    m_sFileName: string;
    m_sTempFileName: string;
    procedure SetFileName(const Value: string);
    function CreateTempStream(): TStream;override;
    procedure FreeTempStream(AStream: TStream);override;
    procedure CopyBackDataFromTempStream(var TempStream: TStream);override;
    procedure ReadyForAdd();override;
    procedure EndForAdd();override;
    procedure GetTempFileName;
  public        
    constructor Create();override;
    destructor Destroy();override;

    procedure SetStream(AStream: TStream);override;

    property FileName: string read m_sFileName write SetFileName;
  end;

implementation

uses DateUtils, ZLib, ZLibConst, FuncUtil, CRC;

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create('ZLIB Compress Error: ' + IntToStr(code)); //!!
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create('ZLIB Decompress Error: ' + IntToStr(code));  //!!
end;

{ TZIPLocalFile }

function TCustomZIPLocalFile.CopyToStream(ToStream: TStream): Integer;
var
  DataDesc: TZIPDataDescriptor;
begin
  Result := 0;
  Result := Result + ToStream.Write(m_LocalHeader, sizeof(m_LocalHeader));
  Result := Result + ToStream.Write(m_sFileName[1], m_LocalHeader.FileInfo.wFileNameSize);
  Result := Result + ToStream.Write(m_pExtendData^, m_LocalHeader.FileInfo.wExtendRecordSize);

  m_ZIPArchiver.m_Stream.Position := m_dwDataOffset + m_ZIPArchiver.m_nDataStart;

  if m_LocalHeader.FileInfo.dwCompressedSize > 0 then
  begin
    Result := Result + ToStream.CopyFrom(m_ZIPArchiver.m_Stream, m_LocalHeader.FileInfo.dwCompressedSize);
  end;

  if UsingDataDesc then
  begin
    DataDesc.Ident.uIdent := ZHI_DATADESCRIPTION;
    DataDesc.CRC32 := m_LocalHeader.FileInfo.CRC32;
    DataDesc.dwCompressedSize := m_LocalHeader.FileInfo.dwCompressedSize;
    DataDesc.dwUncompressedSize := m_LocalHeader.FileInfo.dwUncompressedSize;
    Result := Result + ToStream.Write(DataDesc, sizeof(DataDesc));
  end;
end;

constructor TCustomZIPLocalFile.Create(AZIPArchiver: TCustomZIPArchiver);
begin
  m_ZIPArchiver := AZIPArchiver;
end;

constructor TCustomZIPLocalFile.CreateFromDirectory(AZIPArchiver: TCustomZIPArchiver;
  pDirectory: PZIPCentralDirectory);
var
  nDirSegOffset: Int64;
begin
  Create(AZIPArchiver);

  nDirSegOffset := AZIPArchiver.m_Stream.Position - sizeof(pDirectory^);
  m_Directory := pDirectory^;
  m_sFileName := AZIPArchiver.ReadString(pDirectory^.FileInfo.wFileNameSize);
//  if pDirectory^.wExtendRecordSize > 0 then
//  begin
//    AZIPArchiver.AllocAndRead( m_pDirectoryExtendData, pDirectory^.wExtendRecordSize );
//  end;
  if pDirectory^.wFileCommentSize > 0 then
  begin
    m_sComment := AZIPArchiver.ReadString( pDirectory^.wFileCommentSize );
  end;

  AZIPArchiver.m_Stream.Position := m_ZIPArchiver.m_nDataStart + pDirectory^.dwLocalHeaderOffset;
  AZIPArchiver.ReadStream(m_LocalHeader, sizeof(m_LocalHeader));
  if m_LocalHeader.Ident.uIdent <> ZHI_LOCALHEADER then
  begin
    Raise EInvalidZIPHeader.Create(m_LocalHeader.Ident.uIdent);
  end;

  if not CompareMem(@m_LocalHeader.FileInfo, @pDirectory^.FileInfo, sizeof(m_LocalHeader.FileInfo)) then
  begin
    Raise EZIPDirectoryValidataError.Create();
    asm
      lea eax, self
      lea ebx, pDirectory
    end;
  end;

  m_sFileName := AZIPArchiver.ReadString(m_LocalHeader.FileInfo.wFileNameSize);
  m_sFileName := ArrangeFileName(m_sFileName, '/');
  if m_LocalHeader.FileInfo.wExtendRecordSize > 0 then
  begin
    AZIPArchiver.AllocAndRead( m_pExtendData, m_LocalHeader.FileInfo.wExtendRecordSize );
  end;
  m_dwDataOffset := AZIPArchiver.m_Stream.Position - AZIPArchiver.m_nDataStart;

  AZIPArchiver.m_Stream.Position := nDirSegOffset + sizeof(pDirectory^)
    + pDirectory^.FileInfo.wFileNameSize + pDirectory^.FileInfo.wExtendRecordSize
    + pDirectory^.wFileCommentSize;
end;

procedure TCustomZIPLocalFile.Decompress(ToStream: TStream);
begin
  m_ZIPArchiver.m_Stream.Position := m_ZIPArchiver.m_nDataStart
    + m_Directory.dwLocalHeaderOffset + sizeof(m_LocalHeader)
    + m_LocalHeader.FileInfo.wFileNameSize
    + m_LocalHeader.FileInfo.wExtendRecordSize;

  case m_LocalHeader.FileInfo.wCompressType of
    //No compression used
    ZCM_Stored: begin
      RestoreToStream(ToStream, m_LocalHeader.FileInfo.dwUncompressedSize);
    end;
    //LZW, 8K buffer, 9-13 bits with partial clearing
    ZCM_Shrunk,
    //Probalistic compression, L(X) = lower 7 bits
    ZCM_Reduced_1,
    //Probalistic compression, L(X) = lower 6 bits
    ZCM_Reduced_2,
    //Probalistic compression, L(X) = lower 5 bits
    ZCM_Reduced_3,
    //Probalistic compression, L(X) = lower 4 bits
    ZCM_Reduced_4,
    //2 Shanno-Fano trees, 4K sliding dictionary
    ZCM_Imploded_1,
    //3 Shanno-Fano trees, 4K sliding dictionary
    ZCM_Imploded_2,
    //2 Shanno-Fano trees, 8K sliding dictionary
    ZCM_Imploded_3,
    //3 Shanno-Fano trees, 8K sliding dictionary
    ZCM_Imploded_4: DecompressZLIBToStream( GetZlibStreamHeader(m_LocalHeader.FileInfo.wCompressType), ToStream );
    else Raise EZIPUndefinedCompressMethod.Create( m_LocalHeader.FileInfo.wCompressType );
  end;
end;

class function TCustomZIPLocalFile.GetZlibInBlockSize(CompMode: integer): word;
begin           
  Result := 8192;
  case CompMode of
    ZCM_Stored: Result := 0;
    ZCM_Shrunk: Result := 8192;
    ZCM_Reduced_1: Result := 8192;
    ZCM_Reduced_2: Result := 8192;
    ZCM_Reduced_3: Result := 8192;
    ZCM_Reduced_4: Result := 8192;
    ZCM_Imploded_1: Result := 4096;
    ZCM_Imploded_2: Result := 4096;
    ZCM_Imploded_3: Result := 8192;
    ZCM_Imploded_4: Result := 8192;
  end;
end;

class function TCustomZIPLocalFile.GetZlibStreamHeader(CompMode: integer): Word;
begin
  Result := 0;
  case CompMode of
    0, 7, 8, 9: Result := $DA78;
    1, 2: Result := $0178;
    3, 4: Result := $5E78;
    5, 6: Result := $9C78;
  end;
end;

procedure TCustomZIPLocalFile.RestoreToStream(ToStream: TStream; Size: Int64);
var
  crc: LongWord;
  Buf: array [0..8191] of Char;
  nSizeToRead: Int64;
begin
  crc := $FFFFFFFF;
  while Size > 0 do
  begin
    if Size > sizeof(Buf) then
      nSizeToRead := sizeof(Buf)
    else nSizeToRead := Size;
    m_ZIPArchiver.ReadStream(Buf[0], nSizeToRead);
    Dec( Size, nSizeToRead );
    crc := CRC32(crc, @Buf[0], nSizeToRead);
    ToStream.Write(Buf[0], nSizeToRead);
  end;
  if m_LocalHeader.FileInfo.CRC32 <> not crc then
    Raise EZIPFileCRCError.Create(m_sFileName);
end;

procedure TCustomZIPLocalFile.SetComment(const Value: string);
begin
  Raise EInvalidZIPFileOperate.Create();
end;

procedure TCustomZIPLocalFile.SetCompressLevel(const Value: Integer);
begin
  Raise EInvalidZIPFileOperate.Create();
end;

procedure TCustomZIPLocalFile.SetExtendData(const Data;
  const DataSize: Integer);
begin
  Raise EInvalidZIPFileOperate.Create();
end;

procedure TCustomZIPLocalFile.SetFileName(const Value: string);
var
  ALength: Integer;
begin
  ALength := Length(Value);
  if (ALength = 0) or (ALength > High(m_LocalHeader.FileInfo.wFileNameSize)) then
    Raise EOutOfZIPDataSize.Create( ALength );
  m_sFileName := Value;
  m_LocalHeader.FileInfo.wFileNameSize := ALength;    
  m_Directory.FileInfo.wFileNameSize := ALength;
end;

procedure TCustomZIPLocalFile.SetUsingDataDesc(const Value: Boolean);
begin
  Raise EInvalidZIPFileOperate.Create();
end;

procedure TCustomZIPLocalFile.DecompressZLIBToStream(strmHdr: Word; ToStream: TStream);
const                        
  InBufferSize = 1024 * 64;
  DeBufferSize = 1024 * 1024;
var
  strm: TZStreamRec;
  pInBuffer, pDeBuffer: PChar;
  nSize, nBytesToRead, nTotalOut, nTotalReaded: Int64;
  crc: LongWord;
begin
  GetMem( pInBuffer, DeBufferSize + InBufferSize );
  pDeBuffer := pInBuffer + InBufferSize;
  try
    //首先需要根据压缩类型还原压缩数据头
    FillChar(strm, sizeof(strm), 0);
    strm.zalloc := zlibAllocMem;
    strm.zfree := zlibFreeMem;
    strm.next_in := @strmHdr;
    strm.avail_in := sizeof(strmHdr);
    strm.next_out := pDeBuffer;
    strm.avail_out := DeBufferSize;

    DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
    try               
      DCheck(inflate(strm, Z_NO_FLUSH));

      crc := $FFFFFFFF;
      nTotalReaded := 0;
      strm.avail_in := 0;
      
      nSize := CompressedSize;
      nTotalOut := 0;
      while True do   
      begin                        
        if strm.avail_in = 0 then
        begin
          if nSize <= 0 then break;
          if nSize > InBufferSize then
            nBytesToRead := InBufferSize
          else nBytesToRead := nSize;
          m_ZIPArchiver.ReadStream(pInBuffer^, nBytesToRead);
          Dec( nSize, nBytesToRead );
          Inc( nTotalReaded, nBytesToRead );
          strm.next_in := pInBuffer;
          strm.avail_in := nBytesToRead;
          m_ZIPArchiver.InrementTotalProgress(nBytesToRead);
        end;                        
        strm.next_out := pDeBuffer;
        strm.avail_out := DeBufferSize;
        DCheck(inflate(strm, Z_NO_FLUSH));
        
        ToStream.Write(pDeBuffer^, strm.total_out - nTotalOut);  
        crc := CRC32(crc, pDeBuffer, strm.total_out - nTotalOut);
        nTotalOut := strm.total_out;
        m_ZIPArchiver.FileWorkProgress(Self, nTotalReaded);
      end;
      if m_LocalHeader.FileInfo.CRC32 <> not crc  then
        Raise EZIPFileCRCError.Create(m_sFileName);
    finally
      DCheck(inflateEnd(strm));
    end;
  finally
    FreeMem( pInBuffer );
  end;
end;

destructor TCustomZIPLocalFile.Destroy;
begin
  ReallocMem( m_pExtendData, 0 );
  //ReallocMem( m_pDirectoryExtendData, 0 );
  inherited;
end;

procedure TCustomZIPLocalFile.Extract(BaseDir: string);
begin
  StepCreateFloders( BaseDir, FuncUtil.ExtRactFilePath(m_sFileName) );
  ExtractTo( BaseDir + '\' + m_sFileName );
end;

procedure TCustomZIPLocalFile.ExtractTo(const sFileName: string);
var
  Stream: THandleStream;
  modfileTime: TFileTime;
begin
  modfileTime := LastModFileDateTime;
  if not IsFloder then
  begin
    Stream := TFileStream.Create(sFileName, fmCreate);
    try
      Decompress(Stream);
      SetFileTime(Stream.Handle, nil, nil, @modfileTime);
    finally
      Stream.Free;
    end;
  end
  else begin
    CreateDir(sFileName);
    SetDirectoryModTime( sFileName, modfileTime );
  end;
  SetFileAttributes(PChar(sFileName), m_Directory.dwExternalAttribute);
end;

function TCustomZIPLocalFile.GetCompressionRate: Single;
begin
  if m_LocalHeader.FileInfo.dwUncompressedSize = 0 then
    Result := 0
  else Result := UncompressedSize / CompressedSize * 100;
end;

function TCustomZIPLocalFile.GetCompressLevel: Integer;
begin
  Result := m_nCompressLevel;
end;

function TCustomZIPLocalFile.GetIsFloder: Boolean;
begin
  Result := m_Directory.dwExternalAttribute and faDirectory <> 0;
end;

function TCustomZIPLocalFile.GetLastModDateTime: TDateTime;
var
  ft: TFileTime;
  SysTime: TSystemTime;
begin
  ft := GetLastModFileDateTime();
  FileTimeToSystemTime(ft, SysTime);
  Result := EncodeDateTime(SysTime.wYear, SysTime.wMonth, SysTime.wDay,
    SysTime.wHour, SysTime.wMonth, SysTime.wSecond, SysTime.wMilliseconds);
end;

function TCustomZIPLocalFile.GetLastModFileDateTime: TFileTime;
var
  ft: TFileTime;
begin
  DosDateTimeToFileTime(m_LocalHeader.FileInfo.wLastModDate,
    m_LocalHeader.FileInfo.wLastModTime, ft);
  FileTimeToLocalFileTime(ft, Result);
end;

function TCustomZIPLocalFile.GetUsingDataDesc: Boolean;
begin
  Result := m_LocalHeader.FileInfo.wGlobalMasks and ZMASK_DATADESC <> 0;
end;

{ TCustomZIPArchive }

function TCustomZIPArchiver.AddFile(sSourceFile,
  sLocalFile: string): TAddZIPLocalFile;
begin
  OperationNotFlushed(aoAdd);

  sLocalFile := ArrangeFileName(sLocalFile, '/');
  if (GetFileByName( m_DirectoryList, sLocalFile ) <> nil)
  or (GetFileByName( m_WaitFlushFiles, sLocalFile ) <> nil) then
  begin
    Raise EZIPLocalFileExists.Create(sLocalFile);
  end;
      
  Result := TAddZIPLocalFile.Create(Self);
  Result.m_sSourceFileName := ExpandFileName(sSourceFile);
  Result.FileName := sLocalFile;
  Result.m_nLocalFileSize := GetFileSize(Result.m_sSourceFileName);
  m_WaitFlushFiles.AddObject( sLocalFile, Result );
  m_btFlushType := aoAdd;
end;

procedure TCustomZIPArchiver.AllocAndRead(var p: Pointer; Size: Int64);
begin
  ReallocMem( p, Size );
  ReadStream( p^, Size );
end;

procedure TCustomZIPArchiver.CalcProgressMax(opType: TArchiveOperationType);
var
  I: Integer;
begin
  m_nWorkMax := 0;
  m_nWorkProgress := 0;
  case opType of
    aoNone: ;
    aoAdd: begin
      for I := 0 to m_WaitFlushFiles.Count - 1 do
      begin
        Inc(m_nWorkMax,
          TAddZIPLocalFile(m_WaitFlushFiles.Objects[I]).m_nLocalFileSize);
      end;
    end;
    aoDel: ;
    aoRename: ;
  end;
end;

procedure TCustomZIPArchiver.CleanFiles;
var
  I: Integer;
begin
  try
    for I := 0 to FileList.Count - 1 do
    begin
      TObject(FileList.Objects[I]).Free;
    end;
  finally
    FileList.Clear();
  end;
end;

constructor TCustomZIPArchiver.Create();
begin
  m_DirectoryList := TStringList.Create;
  TStringList(m_DirectoryList).Sorted := True;
  m_WaitFlushFiles := TStringList.Create;
  TStringList(m_WaitFlushFiles).Sorted := True;
end;

function TCustomZIPArchiver.CreateTempStream: TStream;
begin
  Raise EZIPOperationNotSupport.Create;
end;

procedure TCustomZIPArchiver.DeleteFile(sLocalFile: string);
var
  LocalFile: TCustomZIPLocalFile;
  nIndex: Integer;
begin
  OperationNotFlushed( aoDel );

  sLocalFile := ArrangeFileName(sLocalFile, '/');
  LocalFile := GetFileByName(m_DirectoryList, sLocalFile, @nIndex);
  if LocalFile = nil then Raise EZIPLocalFileNotExists.Create(sLocalFile);
  m_DirectoryList.Delete(nIndex);
  m_WaitFlushFiles.AddObject(LocalFile.FileName, LocalFile);
  m_btFlushType := aoDel;
end;

destructor TCustomZIPArchiver.Destroy;
begin
  ResetArchive();
  m_DirectoryList.Free;
  m_WaitFlushFiles.Free;
  inherited;
end;

procedure TCustomZIPArchiver.EndForAdd;
begin

end;

procedure TCustomZIPArchiver.Extract(BaseDir: string);
var
  I: Integer;
begin
  if m_btFlushType <> aoNone then
  begin
    Raise Exception.Create('Operation is not flushed');
  end;

  m_nWorkMax := 0;
  m_nWorkProgress := 0;
  WorkStart( m_nWorkMax );
  for I := 0 to m_DirectoryList.Count - 1 do
  begin
    Inc( m_nWorkMax, TCustomZIPLocalFile(m_DirectoryList.Objects[I]).CompressedSize ); 
  end;
  for I := 0 to m_DirectoryList.Count - 1 do
  begin
    TCustomZIPLocalFile(m_DirectoryList.Objects[I]).Extract(BaseDir);
  end;
  WorkComplete();
end;

procedure TCustomZIPArchiver.CopyBackDataFromTempStream(var TempStream: TStream);
begin
  m_Stream.Position := m_nDataStart;
  m_Stream.CopyFrom(TempStream, TempStream.Size);
end;

procedure TCustomZIPArchiver.FileWorkComplete(AFile: TCustomZIPLocalFile);
begin
  if @m_OnFileWorkComplete <> nil then
    m_OnFileWorkComplete( Self, AFile );
end;

procedure TCustomZIPArchiver.FileWorkProgress(AFile: TCustomZIPLocalFile;
  Progress: Int64);
begin
  if @m_OnFileWorkProgress <> nil then
    m_OnFileWorkProgress( Self, AFile, Progress );
end;

procedure TCustomZIPArchiver.FileWorkStart(AFile: TCustomZIPLocalFile;
  MaxProgress: Int64);
begin
  if @m_OnFileWorkStart <> nil then
    m_OnFileWorkStart( Self, AFile, MaxProgress );
end;

function TCustomZIPArchiver.FlushAddFiles: Integer;
var
  I: Integer;
  AddFile: TAddZIPLocalFile;
begin
  Result := 0;
  ReadyForAdd();
  m_Stream.Position := m_dwDirectoryOffset + m_nDataStart;
  for I := 0 to m_WaitFlushFiles.Count - 1 do
  begin
    AddFile := TAddZIPLocalFile(m_WaitFlushFiles.Objects[I]);
    AddFile.m_Directory.dwLocalHeaderOffset := m_Stream.Position - m_nDataStart;
    AddFile.m_dwDataOffset := m_Stream.Position + sizeof(AddFile.m_LocalHeader)
      + AddFile.m_LocalHeader.FileInfo.wFileNameSize
      + AddFile.m_LocalHeader.FileInfo.wExtendRecordSize;;
    AddFile.CompressFileToStream(m_Stream);
    Inc( Result );
  end;
  m_dwDirectoryOffset := m_Stream.Position - m_nDataStart;
  m_DirectoryList.AddStrings(m_WaitFlushFiles);
  m_WaitFlushFiles.Clear;
  RewriteDirectorys(m_Stream);
  EndForAdd();
  m_nDataEnd := m_Stream.Position;
end;

function TCustomZIPArchiver.FlushChanges: Integer;
begin
  Result := 0;
  if m_btFlushType = aoNone then Exit;

  CalcProgressMax( aoAdd );
  WorkStart( m_nWorkMax );
  
  case m_btFlushType of
    aoNone: ;
    aoAdd: FlushAddFiles();
    aoDel: FlushDelFiles();
    aoRename: FlushRenameFiles();
  end;
  m_btFlushType := aoNone;
  
  WorkComplete();
end;

function TCustomZIPArchiver.FlushDelFiles: Integer;
var
  I: Integer;
  LocalFole: TCustomZIPLocalFile;
  TempStream: TStream;
  nStartPos, nOffSet, nNextOffset: Int64;
begin
  Result := 0;

  for I := 0 to m_WaitFlushFiles.Count - 1 do
  begin
    LocalFole := TCustomZIPLocalFile(m_WaitFlushFiles.Objects[I]);
    LocalFole.Free;
    Inc( Result );
  end;
  m_WaitFlushFiles.Clear;
                          
  TempStream := CreateTempStream();
  nStartPos := TempStream.Position;
  nNextOffset := 0;
  try
    for I := 0 to m_DirectoryList.Count - 1 do
    begin             
      nOffSet := nNextOffset;
      LocalFole := TCustomZIPLocalFile(m_DirectoryList.Objects[I]);
      nNextOffset := nOffSet + LocalFole.CopyToStream(TempStream);
      LocalFole.m_Directory.dwLocalHeaderOffset := nOffSet;
    end;

    RewriteDirectorys(TempStream);
    
    m_nDataStart := nStartPos;
    m_nDataEnd := TempStream.Position;
    CopyBackDataFromTempStream(TempStream);
  finally
    FreeTempStream(TempStream);
  end;
end;

function TCustomZIPArchiver.FlushRenameFiles: Integer;
begin
  Result := m_WaitFlushFiles.Count;
  m_DirectoryList.AddStrings(m_WaitFlushFiles);
  m_WaitFlushFiles.Clear;
  FlushDelFiles();
end;

procedure TCustomZIPArchiver.FreeTempStream(AStream: TStream);
begin
  AStream.Free;
end;

function TCustomZIPArchiver.GetFile(Index: Integer): TCustomZIPLocalFile;
begin
  Result := TCustomZIPLocalFile(m_DirectoryList.Objects[Index]);
end;

function TCustomZIPArchiver.GetFileByName(FileList: TStrings;
  sFileName: string; pIndex: PInteger): TCustomZIPLocalFile;
var
  nIdx: Integer;
begin
  nIdx := FileList.IndexOf(sFileName);
  if nIdx < 0 then
    Result := nil
  else begin
    Result := TCustomZIPLocalFile(FileList.Objects[nIdx]);
    if pIndex <> nil then
      pIndex^ := nIdx;
  end;
end;


function TCustomZIPArchiver.GetFileByName(
  sFileName: string): TCustomZIPLocalFile;
begin
  Result := GetFileByName( m_DirectoryList, ArrangeFileName(sFileName, '/') );
end;

function TCustomZIPArchiver.GetFileCount: Integer;
begin
  Result := m_DirectoryList.Count;
end;

procedure TCustomZIPArchiver.InrementTotalProgress(const IncValue: Int64);
begin
  Inc( m_nWorkProgress, IncValue );
  WorkProgress( m_nWorkProgress );
end;

procedure TCustomZIPArchiver.OperationNotFlushed(opType: TArchiveOperationType);
begin
  if (m_btFlushType <> aoNone) and (m_btFlushType <> opType) then
    Raise EZIPArchiveOperationNotFlushed.Create(opType);
end;

procedure TCustomZIPArchiver.ReadArchive;
var
  Ident: TZIPHeaderIdent;
  LocalFile: TCustomZIPLocalFile;
  localHead: TZIPLocalHeader;
  dataDesc: TZIPDataDescriptor;
  dirHeaad: TZIPCentralDirectory;
  endDirHead: TZIPEndDirectory;
  sFileName: string;
  nBytesToRead: Int64;
begin
  ResetArchive();
  if StartPosition <> -1 then
  begin
    m_Stream.Position := StartPosition;
  end;
  m_nDataStart := m_Stream.Position;
  while True do
  begin
    ReadStream( Ident, sizeof(Ident) );
    
    case Ident.uIdent of
      //文件区
      ZHI_LOCALHEADER:begin
        localHead.Ident := Ident;
        nBytesToRead := sizeof(localHead) - sizeof(Ident);
        ReadStream( Pointer(Integer(@localHead) + sizeof(Ident))^, nBytesToRead );
        nBytesToRead := localHead.FileInfo.wFileNameSize
          + localHead.FileInfo.wExtendRecordSize
          + localHead.FileInfo.dwCompressedSize;
        m_Stream.Seek(nBytesToRead, soFromCurrent);
        //如果$8位被置，则读取数据描述段
        if localHead.FileInfo.wGlobalMasks and $8 <> 0 then
        begin
          ReadStream(dataDesc, sizeof(dataDesc));
          if dataDesc.Ident.uIdent <> ZHI_DATADESCRIPTION then
            raise EInvalidZIPHeader.Create(Ident.uIdent);
          if dataDesc.CRC32 <> localHead.FileInfo.CRC32 then
            Raise EZIPFileCRCError.Create( sFileName );
          if (dataDesc.dwCompressedSize <> localHead.FileInfo.dwCompressedSize)
          or (dataDesc.dwUncompressedSize <> localHead.FileInfo.dwUncompressedSize) then
            Raise EZIPFileSizeCheckError.Create( sFileName );
        end;
      end;
      //目录区
      ZHI_CENTRALDIRECTORY:begin
        if m_dwDirectoryOffset = 0 then
        begin
          m_dwDirectoryOffset := m_Stream.Position - sizeof(Ident) - m_nDataStart;
        end;
        dirHeaad.Ident := Ident;
        nBytesToRead := sizeof(dirHeaad) - sizeof(Ident);
        ReadStream(Pointer(Integer(@dirHeaad) + sizeof(Ident))^, nBytesToRead);
        LocalFile := TCustomZIPLocalFile.CreateFromDirectory(Self, @dirHeaad);
        m_DirectoryList.AddObject(LocalFile.FileName, LocalFile);
      end;
      //目录结束标记
      ZHI_ENDDIRECTORY:begin
        endDirHead.Ident := Ident;
        nBytesToRead := sizeof(endDirHead) - sizeof(Ident);
        ReadStream(Pointer(Integer(@endDirHead) + sizeof(Ident))^, nBytesToRead);
        if endDirHead.wZIPCommentSize > 0 then
        begin
          m_sComment := ReadString( endDirHead.wZIPCommentSize );
        end;
        break;
      end;
      else Raise EInvalidZIPHeader.Create(Ident.uIdent);
    end;
  end;
  m_nDataEnd := m_Stream.Position;
end;

class procedure TCustomZIPArchiver.ReadStream(AStream: TStream; var Buf;
  const Size: Int64);
begin
  if AStream.Read( Buf, Size ) <> Size then
    Raise EZIPStreamEOF.Create;
end;

function TCustomZIPArchiver.ReadString(const ALength: Integer): string;
begin
  SetLength( Result, ALength );
  ReadStream( Result[1], ALength );
end;

procedure TCustomZIPArchiver.ReadyForAdd;
begin

end;

procedure TCustomZIPArchiver.RenameFile(sLocalFile, sNewFile: string);
var
  LocalFile: TCustomZIPLocalFile;
  nIndex: Integer;
begin 
  OperationNotFlushed( aoRename );

  sLocalFile := ArrangeFileName(sLocalFile, '/');
  sNewFile := ArrangeFileName(sNewFile, '/');
  if sNewFile = sLocalFile then Exit;

  LocalFile := GetFileByName(m_DirectoryList, sLocalFile, @nIndex);
  if LocalFile = nil then Raise EZIPLocalFileNotExists.Create(sLocalFile);
  if GetFileByName(sNewFile) <> nil then EZIPLocalFileExists.Create(sNewFile);
  LocalFile.FileName := sNewFile;
  m_DirectoryList.Delete(nIndex);
  m_WaitFlushFiles.AddObject(sNewFile, LocalFile);
  m_btFlushType := aoRename;
end;

procedure TCustomZIPArchiver.ResetArchive;
begin
  CleanFiles(m_DirectoryList);
  CleanFiles(m_WaitFlushFiles);
end;

procedure TCustomZIPArchiver.RewriteDirectorys(ToStream: TStream);
var
  LocalFile: TCustomZIPLocalFile;
  I: Integer;
  nDirSize: Int64;
  endDir: TZIPEndDirectory;
begin
  nDirSize := 0;
  m_dwDirectoryOffset := ToStream.Position - m_nDataStart;
  for I := 0 to m_DirectoryList.Count - 1 do
  begin
    LocalFile := TCustomZIPLocalFile(m_DirectoryList.Objects[I]);
    nDirSize := nDirSize + ToStream.Write(LocalFile.m_Directory, sizeof(LocalFile.m_Directory));
    nDirSize := nDirSize + ToStream.Write(LocalFile.m_sFileName[1], Length(LocalFile.m_sFileName));
    nDirSize := nDirSize + ToStream.Write(LocalFile.m_pExtendData^, LocalFile.m_LocalHeader.FileInfo.wExtendRecordSize);
    nDirSize := nDirSize + ToStream.Write(LocalFile.m_sComment[1], LocalFile.m_Directory.wFileCommentSize);
  end;
  FillChar( endDir, sizeof(endDir), 0 );
  endDir.Ident.uIdent := ZHI_ENDDIRECTORY;
  endDir.wCurrentDiskNo := 0;
  endDir.wDirectoryStartDiskNo := 0;
  endDir.wCurrentDiskLocalCount := m_DirectoryList.Count;
  endDir.wDirectoryCount := m_DirectoryList.Count;
  endDir.wDirectorySize := nDirSize;
  endDir.wDirectoryOffset := m_dwDirectoryOffset;
  endDir.wZIPCommentSize := Length(m_sComment);
  ToStream.Write(endDir, sizeof(endDir));
  ToStream.Write(m_sComment[1], endDir.wZIPCommentSize);
end;

procedure TCustomZIPArchiver.SetStream(AStream: TStream);
begin
  m_Stream := AStream;  
  m_nDataStart := m_Stream.Position;
end;

procedure TCustomZIPArchiver.WorkComplete;
begin
  if @m_OnWorkComplete <> nil then
    m_OnWorkComplete( Self );
end;

procedure TCustomZIPArchiver.WorkProgress(Progress: Int64);
begin
  if @m_OnWorkProgress <> nil then
    m_OnWorkProgress( Self, Progress );
end;

procedure TCustomZIPArchiver.WorkStart(MaxProgress: Int64);
begin
  if @m_OnWorkStart <> nil then
    m_OnWorkStart( Self, MaxProgress );
end;

procedure TCustomZIPArchiver.ReadStream(var Buf; const Size: Int64);
begin
  if m_Stream.Read( Buf, Size ) <> Size then
    Raise EZIPStreamEOF.Create;
end;

{ EZIPStreamEOF }

constructor EZIPStreamEOF.Create;
begin
  Inherited Create('Out Of ZIP Stream');
end;

{ EInvalidZIPHeader }

constructor EInvalidZIPHeader.Create;
begin
  Inherited CreateFmt('Invalid ZIP Header Ident: %X', [dwIdent]);
end;

{ EZIPFileCRCError }

constructor EZIPFileCRCError.Create(sFileName: string);
begin
  Inherited Create( 'CRC Error: ' + sFileName );
end;

{ EZIPFileSizeCheckError }

constructor EZIPFileSizeCheckError.Create;
begin
  Inherited Create( 'File Size Check Error: ' + sFileName );
end;

{ EZIPDirectoryValidataError }

constructor EZIPDirectoryValidataError.Create();
begin
  Inherited Create('ZIP Directory Record Validata Error');
end;

{ EZIPUndefinedCompressMethod }

constructor EZIPUndefinedCompressMethod.Create(nMethod: Integer);
begin
  Inherited CreateFmt('Undefined Compress Method: %X', [nMethod]);
end;

{ TAddZIPLocalFile }

procedure TAddZIPLocalFile.CompressFileToStream(ToStream: TStream);
var
  SrcStream: THandleStream;
  DataDesc: TZIPDataDescriptor;
  nSize, nStartPos, nStreamPos: Int64;
  boIsFloder: Boolean;
begin
  m_Directory.wCmprPKWareVer := 20;
  
  MakeFileInfo();
  boIsFloder := IsFloder;

  nStartPos := ToStream.Position;
  if not boIsFloder then
  begin
    SrcStream := TFileStream.Create(m_sSourceFileName, fmShareDenyWrite);
    m_LocalHeader.FileInfo.dwUncompressedSize := SrcStream.Size;
  end
  else SrcStream := nil;

  try
    nSize := sizeof(m_LocalHeader)
      + m_LocalHeader.FileInfo.wFileNameSize
      + m_LocalHeader.FileInfo.wExtendRecordSize;
    ToStream.Seek(nSize, soFromCurrent);

    if not boIsFloder then
    begin
      m_ZIPArchiver.FileWorkStart( Self, SrcStream.Size );
      //开始压缩数据流
      if CompressLevel = Z_NO_COMPRESSION then
        StoreStreamToStream( SrcStream, ToStream, SrcStream.Size )
      else ZLIBCompressStreamToStream( SrcStream, ToStream, SrcStream.Size );
      m_ZIPArchiver.FileWorkComplete( Self );
    end;
    
    //输入数据描述段
    if UsingDataDesc then
    begin
      DataDesc.Ident.uIdent := ZHI_DATADESCRIPTION;
      DataDesc.CRC32 := m_LocalHeader.FileInfo.CRC32;
      DataDesc.dwCompressedSize := m_LocalHeader.FileInfo.dwCompressedSize;
      DataDesc.dwUncompressedSize := m_LocalHeader.FileInfo.dwUncompressedSize;
      ToStream.Write(DataDesc, sizeof(DataDesc));
    end;
    nStreamPos := ToStream.Position;
    //写入局部文件段
    ToStream.Position := nStartPos;
    ToStream.Write(m_LocalHeader, sizeof(m_LocalHeader));
    ToStream.Write(m_sFileName[1], m_LocalHeader.FileInfo.wFileNameSize);
    ToStream.Write(m_pExtendData^, m_LocalHeader.FileInfo.wExtendRecordSize);
    //将流的指针恢复到数据段末尾 
    ToStream.Position := nStreamPos;
  finally
    SrcStream.Free;
  end;
  m_Directory.FileInfo := m_LocalHeader.FileInfo;
end;

procedure TAddZIPLocalFile.ZLIBCompressStreamToStream(
  SrcStream, ToStream: TStream; SrcSize: Int64);
const
  MaxInBufferSize  = 8192;
  MaxOutBufferSize = MaxInBufferSize * 2;
var
  strm: TZStreamRec;
  pInBuffer, pOutBuffer: PChar;
  nFlush: Integer;
  crc: LongWord;
  nInBlockSize, nTotalOut, nSizeOut, nSizeToRead, nTotalReaded: Int64;
begin
  FillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  GetMem( pInBuffer, MaxInBufferSize + MaxOutBufferSize );
  pOutBuffer := pInBuffer + MaxInBufferSize;
  try
    strm.next_out := pOutBuffer;
    strm.avail_out := MaxOutBufferSize;
    strm.next_out := pOutBuffer;
    strm.avail_out := MaxOutBufferSize;
    CCheck(deflateInit_(strm, CompressLevel, zlib_version, sizeof(strm)));
    
    nInBlockSize := GetZlibInBlockSize(CompressLevel);
    crc := $FFFFFFFF;
    nTotalReaded := 0;
    try
      strm.avail_in := 0;
      nTotalOut := 0;
      nFlush := Z_SYNC_FLUSH;
      while True do
      begin
        if strm.avail_in = 0 then
        begin
          if SrcSize <= 0 then break;
          if SrcSize > nInBlockSize then
            nSizeToRead := nInBlockSize
          else nSizeToRead := SrcSize;
          m_ZIPArchiver.ReadStream(SrcStream, pInBuffer^, nSizeToRead);
          strm.avail_in := nSizeToRead;
          Dec( SrcSize, nSizeToRead );
          Inc( nTotalReaded, nSizeToRead );
          if SrcSize <= 0 then nFlush := Z_FINISH;
          strm.next_in := pInBuffer;
          crc := CRC32(crc, pInBuffer, strm.avail_in);     
          m_ZIPArchiver.InrementTotalProgress( nSizeToRead );
        end;
        CCheck(deflate(strm, nFlush));
        //第一次写入数据的时候需要跳过zlib压缩后的前2个标志字节
        nSizeOut := strm.total_out - nTotalOut - 2;
        if nSizeOut > 0 then
        begin            
          //第一次写入数据的时候需要跳过zlib压缩后的前2个标志字节
          if nTotalOut = 0 then
            ToStream.Write(Pointer(pOutBuffer + 2)^, nSizeOut)
          else ToStream.Write(pOutBuffer^, nSizeOut);
          Inc(nTotalOut, nSizeOut);
          Inc( m_LocalHeader.FileInfo.dwCompressedSize, nSizeOut ); 
          strm.next_out := pOutBuffer;
          strm.avail_out := MaxOutBufferSize;     
          m_ZIPArchiver.FileWorkProgress( Self, nTotalReaded );
        end;
      end;
    finally
      CCheck(deflateEnd(strm));
    end;
    m_LocalHeader.FileInfo.CRC32 := not crc;
  finally
    FreeMem( pInBuffer );
  end;
end;

procedure TAddZIPLocalFile.StoreStreamToStream(SrcStream, ToStream: TStream;
  SrcSize: Int64);
var
  Buf: array [0..8191] of Char;
  nSizeToRead, nTotalReaded: Int64;
  crc: LongWord;
begin
  crc := $FFFFFFFF;
  nTotalReaded := 0;
  while SrcSize > 0 do
  begin
    if SrcSize > sizeof(Buf) then
      nSizeToRead := sizeof(Buf)
    else nSizeToRead := SrcSize;
    m_ZIPArchiver.ReadStream( SrcStream, Buf[0], nSizeToRead) ;
    Dec( SrcSize, nSizeToRead );
    Inc( nTotalReaded, nSizeToRead );
    crc := CRC32(crc, @Buf[0], nSizeToRead);
    ToStream.Write(Buf[0], nSizeToRead);
    Inc(m_LocalHeader.FileInfo.dwCompressedSize, nSizeToRead);

    m_ZIPArchiver.FileWorkProgress( Self, nTotalReaded );
    m_ZIPArchiver.InrementTotalProgress( nSizeToRead );
  end;
  m_LocalHeader.FileInfo.CRC32 := not crc;
end;

constructor TAddZIPLocalFile.Create(AZIPArchiver: TCustomZIPArchiver);
begin
  inherited Create(AZIPArchiver);
  SetCompressLevel( Z_DEFAULT_COMPRESSION );
  m_LocalHeader.Ident.uIdent := ZHI_LOCALHEADER;
  m_Directory.Ident.uIdent := ZHI_CENTRALDIRECTORY;
end;

procedure TAddZIPLocalFile.MakeFileInfo;
var
  FileTime: TFileTime;
  FileAttrData: WIN32_FILE_ATTRIBUTE_DATA;
begin
  if GetFileAttributesEx(PChar(m_sSourceFileName), GetFileExInfoStandard, @FileAttrData) then
  begin
    m_Directory.dwExternalAttribute := FileAttrData.dwFileAttributes;
    LocalFileTimeToFileTime(FileAttrData.ftLastWriteTime, FileTime);
    FileTimeToDosDateTime(FileTime, m_LocalHeader.FileInfo.wLastModDate,
      m_LocalHeader.FileInfo.wLastModTime);     
    m_LocalHeader.FileInfo.dwUncompressedSize := FileAttrData.nFileSizeLow;
  end;
  m_LocalHeader.FileInfo.wDecmprPKWareVer := 20;
  m_LocalHeader.FileInfo.CRC32 := 0;
  m_LocalHeader.FileInfo.dwCompressedSize := 0;
  m_LocalHeader.FileInfo.wFileNameSize := Length(m_sFileName);
  m_LocalHeader.FileInfo.wCompressType := CompressLevel;
end;

procedure TAddZIPLocalFile.SetComment(const Value: string);

var
  ALength: Integer;
begin
  ALength := Length(Value);
  if (ALength = 0) or (ALength > High(m_LocalHeader.FileInfo.wFileNameSize)) then
    Raise EOutOfZIPDataSize.Create( ALength );
  m_sComment := Value;
  m_Directory.wFileCommentSize := ALength;
end;

procedure TAddZIPLocalFile.SetCompressLevel(const Value: Integer);
begin
  if (Value < -1) or (Value > 9) then
    Raise EInvalidZLibCompressLevel.Create(Value);
  m_nCompressLevel := Value;
end;

procedure TAddZIPLocalFile.SetExtendData(const Data; const DataSize: Integer);
begin
  if DataSize > High(m_LocalHeader.FileInfo.wExtendRecordSize) then
    Raise EOutOfZIPDataSize.Create( DataSize );
  ReallocMem( m_pExtendData, DataSize );
  Move( Data, m_pExtendData^, DataSize );
  m_LocalHeader.FileInfo.wExtendRecordSize := DataSize;
  m_Directory.FileInfo.wExtendRecordSize := DataSize;
end;

procedure TAddZIPLocalFile.SetUsingDataDesc(const Value: Boolean);
begin
  if Value then
  begin
    if m_LocalHeader.FileInfo.wGlobalMasks and ZMASK_DATADESC <> 0 then
      m_LocalHeader.FileInfo.wGlobalMasks := m_LocalHeader.FileInfo.wGlobalMasks and (not ZMASK_DATADESC);
  end
  else begin
    m_LocalHeader.FileInfo.wGlobalMasks := m_LocalHeader.FileInfo.wGlobalMasks or ZMASK_DATADESC;
  end;
end;

{ EInvalidZIPFileOperate }

constructor EInvalidZIPFileOperate.Create;
begin
  Inherited Create('Invalid ZIP Local File Operation');
end;

{ EOutOfZIPDataSize }

constructor EOutOfZIPDataSize.Create(DataSize: Integer);
begin
  Inherited CreateFmt('Out Of ZIP Data Size:%d', [DataSize]);
end;

{ EInvalidZLibCompressLevel }

constructor EInvalidZLibCompressLevel.Create(CompressLevel: Integer);
begin
  Inherited CreateFmt('Invalid ZLib Compress Level:%d', [CompressLevel]);
end;

{ EZIPLocalFileExists }

constructor EZIPLocalFileExists.Create(sFileName: string);
begin
  Inherited CreateFmt('ZIP Local File Exists: %s', [sFileName]);
end;

{ TMemoryZIPArchive }

procedure TMemoryZIPArchive.CopyBackDataFromTempStream(var TempStream: TStream);
var
  aStream: TStream;
begin
  aStream := m_Stream;
  m_Stream := TempStream;
  TempStream := aStream;
  ResetArchive();
  ReadArchive(0);
end;

constructor TMemoryZIPArchive.Create;
begin                                 
  inherited Create;
  m_Stream := TMemoryStream.Create;
end;

function TMemoryZIPArchive.CreateTempStream: TStream;
begin
  Result := TMemoryStream.Create;
end;

destructor TMemoryZIPArchive.Destroy;
begin
  m_Stream.Free;
  inherited;
end;

procedure TMemoryZIPArchive.LoadFromFile(const FileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(FileName, fmShareDenyWrite);
  try
    LoadFromStream( AStream );
  finally
    AStream.Free;
  end;
end;

procedure TMemoryZIPArchive.LoadFromStream(AStream: TStream);
begin
  ResetArchive();
  TMemoryStream(m_Stream).LoadFromStream(AStream);
  ReadArchive(0);
end;

procedure TMemoryZIPArchive.SaveToFile(const FileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream( AStream );
  finally
    AStream.Free;
  end;
end;

procedure TMemoryZIPArchive.SaveToStream(AStream: TStream);
begin
  AStream.Write(TMemoryStream(m_Stream).Memory^, m_nDataEnd - m_nDataStart);
end;

procedure TMemoryZIPArchive.SetStream(AStream: TStream);
begin
  Raise EInvalidOperation.Create('Invalid MemoryZIPArchive Operation');
end;

{ TFileZIPArchive }

procedure TFileZIPArchive.CopyBackDataFromTempStream(var TempStream: TStream);
begin   
  m_Stream.Free;
  m_Stream := nil;
  if not SysUtils.DeleteFile(m_sFileName) then
    Raise Exception.Create('Can not Delete File: ' + m_sFileName);
  TempStream.Free;
  TempStream := nil;
  if not SysUtils.RenameFile(m_sTempFileName, m_sFileName) then
    Raise Exception.Create('Can not Move File: ' + m_sTempFileName);
  m_Stream := TFileStream.Create(m_sFileName, fmShareDenyNone);
  ResetArchive();
  ReadArchive();
end;

constructor TFileZIPArchive.Create;
begin
  inherited Create;

end;

function TFileZIPArchive.CreateTempStream: TStream;
begin
  GetTempFileName();
  Result := TFileStream.Create(m_sTempFileName, fmCreate);
end;

destructor TFileZIPArchive.Destroy;
begin
  m_Stream.Free;
  inherited;
end;

procedure TFileZIPArchive.EndForAdd;
var
  aStream: TStream;
begin
  aStream := nil;
  CopyBackDataFromTempStream( aStream );
end;

procedure TFileZIPArchive.FreeTempStream(AStream: TStream);
begin
  inherited;
  SysUtils.DeleteFile(m_sTempFileName);
end;

procedure TFileZIPArchive.ReadyForAdd;
begin
  GetTempFileName();
  if not CopyFile( PChar(m_sFileName), PChar(m_sTempFileName), False ) then 
    Raise Exception.Create('Can not Copy File: ' + m_sFileName);
  m_Stream.Free;
  m_Stream := nil;
  m_Stream := TFileStream.Create(m_sTempFileName, fmOpenReadWrite);
end;

procedure TFileZIPArchive.SetFileName(const Value: string);
var
  NewStream, OldStream: TStream;
begin
  if m_sFileName = Value then Exit;
  OldStream := m_Stream;
  NewStream := TFileStream.Create(Value, fmShareDenyWrite);
  try
    ResetArchive();
    m_Stream := NewStream;
    ReadArchive();
    NewStream := OldStream;
    OldStream := m_Stream;
    m_sFileName := Value;
  finally
    m_Stream := OldStream;
    NewStream.Free;
  end;
end;

procedure TFileZIPArchive.SetStream(AStream: TStream);
begin
  Raise EInvalidOperation.Create('Invalid MemoryZIPArchive Operation');
end;

procedure TFileZIPArchive.GetTempFileName;
begin
  m_sTempFileName := m_sFileName;
  repeat
    m_sTempFileName := m_sTempFileName + '_';
  until not FileExists(m_sTempFileName);
end;

{ EZIPArchiveOperationNotFlushed }

constructor EZIPArchiveOperationNotFlushed.Create(
  opType: TArchiveOperationType);
const
  OpTypeStr: array [TArchiveOperationType] of string
  = ( 'None', 'Add', 'Delete', 'Rename' );
begin
  Inherited CreateFmt('ZIP Archive Operation Not Flushed : %s', [OpTypeStr[opType]]);
end;

{ EZIPLocalFileNotExists }

constructor EZIPLocalFileNotExists.Create(sFileName: string);
begin
  Inherited CreateFmt('ZIP Local File Not Exists: %s', [sFileName]);
end;

{ EZIPOperationNotSupport }

constructor EZIPOperationNotSupport.Create;
begin
  Inherited Create( 'Operation Not Support' );
end;

{ TStreamZIPArchive }

procedure TStreamZIPArchive.SetStream(AStream: TStream);
begin
  inherited;
  if AStream.Position < AStream.Size then
  begin
    ReadArchive();
  end
  else begin
    ResetArchive();      
    m_nDataStart := m_Stream.Position;
  end;
end;

end.
