unit wwMap;

interface

uses
  Windows, SysUtils, Classes;

const
  //地图坐标的像素大小
  MapCellSize : TSize = ( cx: 64; cy: 32; );   
  MapFileHeaderIdent = $00504D57; //地图文件头标志

  MapFileVersion_100128 = $000A011C;    
  MapFileVersion_100302 = $000A0302;
  MapFileVersion_Current = MapFileVersion_100302;

  MAPFLAG_UNMOVEABLE  = $8000;  //不可移动标记
  MAPFLAG_HIDDENAREA  = $4000;  //遮挡区域

type
  (*  地图文件头  *)
  TWWMapFileHeader = record
    dwIdent: DWord; //文件头标识，固定为0x00504D57
    dwVersion: DWord; //文件版本，固定为0x000A011C
    nMapWidth: Integer;//地图宽度
    nMapHeight: Integer;//地图高度
    btReseve: array [1..48] of Byte;
  end;

  (*  地图坐标数据  *)
  PWWMapCell = ^TWWMapCell;
  TWWMapCell = record
    wBkImg: Word;
    wFtImg: Word;
    wFlag: Word;
    btObjRoot: Byte;
    btReseve: array [1..1] of Byte;
  end;

  (*  地图行数据   *)
  PWWMapRow = ^TWWMapRow;
  TWWMapRow = array [0..0] of TWWMapCell;
               
  (* 以下定义是地图类的定义，不属于通用范畴 *)   
  TWWMapCopyRectFlags = set of (crEraseSource, crRecalcSourceRect,crRecalcDestRect);

  TWWMap = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FCells: array of TWWMapCell;
  private
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    function GetMapRow(Index: Integer): PWWMapRow;
    function GetMapCell(nCol, nRow: Integer): TWWMapCell;
    procedure SetMapCell(nCol, nRow: Integer; const Value: TWWMapCell);        
    procedure OutOfWidth(nCol: Integer);
    procedure OutOfHeight(nRow: Integer);
  public
    constructor Create();virtual;
    destructor Destroy();override;
    procedure SetSize(const nWidth, nHeight: Integer);    
    procedure Assign(AMap: TWWMap);virtual;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure NewMap(const ALength, AHeight: Integer);
    procedure Clear();
    procedure EraseRect(Rect: TRect);
    procedure CheckRect(Rect: TRect);
    procedure MoveRange(Rect: TRect; MoveCoord: TPoint);
    procedure CopyRect(SrcMap: TWWMap; SrcCoord: TPoint; DestRect: TRect;
      Flags: TWWMapCopyRectFlags = []);

    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Rows[nRow: Integer]: PWWMapRow read GetMapRow;
    property Cells[nCol, nRow: Integer]: TWWMapCell read GetMapCell write SetMapCell;
  end;

implementation

uses zlib;

{ TWWMap }

procedure TWWMap.Assign(AMap: TWWMap);
begin
  SetSize(AMap.Width, AMap.Height);
  Move(AMap.FCells[0], FCells[0], AMap.Width * AMap.Height * sizeof(FCells[0]));
end;

procedure TWWMap.Clear;
begin
  FillChar( FCells[0], sizeof(FCells[0]) * System.Length(FCells), 0);
end;

procedure TWWMap.CopyRect(SrcMap: TWWMap; SrcCoord: TPoint; DestRect: TRect;
  Flags: TWWMapCopyRectFlags);
var
  Data: array of TWWMapCell;
  RectSize: TSize;
  procedure BackupFromSrc();
  var
    pSrc, pDest: PWWMapCell;     
    dwSizeCopy: DWord;
    I, SrcIncrement: Integer;
  begin
    pSrc := @SrcMap.Rows[SrcCoord.Y]^[SrcCoord.X];
    pDest := @Data[0];  
    
    dwSizeCopy := RectSize.cx * sizeof(pSrc^);
    SrcIncrement := SrcMap.FWidth;
    for I := DestRect.Top to DestRect.Bottom do
    begin
      Move( pSrc^, pDest^, dwSizeCopy );
      Inc( pSrc, SrcIncrement );
      Inc( pDest, RectSize.cx );
    end;
  end;   
  procedure CopyFromBackup();
  var
    pSrc, pDest: PWWMapCell;
    dwSizeCopy: DWord;
    I: Integer;
  begin
    pSrc := @Data[0];  
    pDest := @Self.Rows[DestRect.Top]^[DestRect.Left];

    dwSizeCopy := RectSize.cx * sizeof(pSrc^);
    for I := DestRect.Top to DestRect.Bottom do
    begin
      Move( pSrc^, pDest^, dwSizeCopy );
      Inc( pSrc, RectSize.cx );
      Inc( pDest, Self.FWidth );
    end;
  end;
begin
  OutOfHeight(DestRect.Top);
  OutOfWidth(DestRect.Left);
  if crRecalcSourceRect in Flags then
  begin
    if DestRect.Right >= FWidth then
      DestRect.Right := FWidth - 1;
    if DestRect.Bottom >= FHeight then
      DestRect.Bottom := FHeight - 1;
  end;                         
  OutOfWidth(DestRect.Right);
  OutOfHeight(DestRect.Bottom);
  
  RectSize.cx := (DestRect.Right - DestRect.Left) + 1;
  RectSize.cy := (DestRect.Bottom - DestRect.Top) + 1;
  
  SrcMap.OutOfWidth(SrcCoord.X);
  SrcMap.OutOfHeight(SrcCoord.Y);
  if crRecalcDestRect in Flags then
  begin
    if SrcCoord.X + RectSize.cx > SrcMap.Width then
    begin
      RectSize.cx := SrcMap.Width - SrcCoord.X;
      DestRect.Right := DestRect.Left + RectSize.cx - 1;
    end;
    if SrcCoord.Y + RectSize.cy > SrcMap.Height then
    begin
      RectSize.cy := SrcMap.Height - SrcCoord.Y;
      DestRect.Bottom := DestRect.Top + RectSize.cy - 1;
    end;
  end;
  SrcMap.OutOfWidth(SrcCoord.X + RectSize.cx - 1);
  SrcMap.OutOfHeight(SrcCoord.Y + RectSize.cy - 1);
                      
  Setlength(Data, RectSize.cx * RectSize.cy);
  try
    BackupFromSrc();
    if crEraseSource in Flags then
    begin
      SrcMap.EraseRect(Bounds(SrcCoord.X, SrcCoord.Y, RectSize.cx - 1, RectSize.cy - 1));
    end;
    CopyFromBackup();
  finally
    Setlength( Data, 0 );
  end;
end;

constructor TWWMap.Create;
begin

end;

destructor TWWMap.Destroy;
begin
  SetLength(FCells, 0);
  inherited;
end;

procedure TWWMap.EraseRect(Rect: TRect);
var
  pCell: PWWMapCell;
  dwSizeFill: DWord;
begin
  OutOfHeight(Rect.Top);
  OutOfWidth(Rect.Left);
  OutOfHeight(Rect.Bottom);
  OutOfWidth(Rect.Right);

  pCell := @Rows[Rect.Top]^[Rect.Left];
  dwSizeFill := (Rect.Right - Rect.Left + 1) * sizeof(pCell^);
  while Rect.Top <= Rect.Bottom do
  begin
    ZeroMemory( pCell, dwSizeFill );
    Inc( pCell, FWidth );
    Inc( Rect.Top );
  end;
end;

function TWWMap.GetMapCell(nCol, nRow: Integer): TWWMapCell;
begin
  OutOfWidth(nCol);
  Result := Rows[nRow]^[nCol];
end;

function TWWMap.GetMapRow(Index: Integer): PWWMapRow;
begin
  OutOfHeight(Index);
  Result := @FCells[FWidth * Index];
end;

procedure TWWMap.LoadFromFile(const AFileName: string);
var
  Stm: TStream;
begin
  Stm := TFileStream.Create(AFileName, fmShareDenyNone);
  try
    LoadFromStream( Stm );
  finally
    Stm.Free;
  end;
end;

procedure TWWMap.LoadFromStream(Stream: TStream);
var
  Hdr: TWWMapFileHeader;
  DeStm: TDecompressionStream;
begin
  Stream.Read(Hdr, sizeof(Hdr));
  if Hdr.dwIdent <> MapFileHeaderIdent then
    Raise Exception.Create('非有效地图文件');
  if Hdr.dwVersion <> MapFileVersion_Current then
    Raise Exception.Create('地图文件版本过期');
  
  NewMap(Hdr.nMapWidth, Hdr.nMapHeight);

  DeStm := TDecompressionStream.Create(Stream);
  try
    DeStm.Read(FCells[0], sizeof(FCells[0]) * System.Length(FCells));
  finally
    DeStm.Free;
  end;
end;

procedure TWWMap.MoveRange(Rect: TRect; MoveCoord: TPoint);
var
  StartCoord: TPoint;
begin
  StartCoord := Rect.TopLeft;
  Inc( Rect.Left, MoveCoord.X );
  Inc( Rect.Right, MoveCoord.X );    
  Inc( Rect.Top, MoveCoord.Y );
  Inc( Rect.Bottom, MoveCoord.Y );
  CopyRect(Self, StartCoord, Rect, [crEraseSource, crRecalcSourceRect, crRecalcDestRect] );
end;

procedure TWWMap.NewMap(const ALength, AHeight: Integer);
begin
  FWidth := ALength;
  FHeight := AHeight;
  Setlength( FCells, 0 );
  Setlength( FCells, ALength * AHeight );
end;

procedure TWWMap.SaveToFile(const AFileName: string);
var
  stm: TStream;
begin
  stm := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream( stm );
  finally
    stm.Free;
  end;
end;

procedure TWWMap.SaveToStream(Stream: TStream);
var
  Hdr: TWWMapFileHeader;
  CmprStm: TCompressionStream;
begin
  FillChar( Hdr, sizeof(Hdr), 0 );
  Hdr.dwIdent := MapFileHeaderIdent;
  Hdr.dwVersion := MapFileVersion_Current;
  Hdr.nMapWidth := FWidth;
  Hdr.nMapHeight := FHeight;
  
  Stream.Write(Hdr, sizeof(Hdr));
  CmprStm := TCompressionStream.Create(clMax, Stream);
  try
    CmprStm.Write(FCells[0], sizeof(FCells[0]) * System.Length(FCells));
  finally
    CmprStm.Free;
  end;
end;

procedure TWWMap.SetHeight(const Value: Integer);
begin
  if FHeight <> Value then
  begin
    SetSize(FWidth, Value);
  end;
end;

procedure TWWMap.SetMapCell(nCol, nRow: Integer; const Value: TWWMapCell);
begin
  OutOfWidth(nCol);
  Rows[nRow]^[nCol] := Value;
end;

procedure TWWMap.SetSize(const nWidth, nHeight: Integer);
var
  NewCells: array of TWWMapCell;
  pSrc, pDest: PWWMapCell;
  I, nSizeCopy, nCopyHeight: Integer;
begin
  SetLength(NewCells, nWidth * nHeight);
  try              
    if (FWidth > 0) and (FHeight > 0) then
    begin
      pSrc := @FCells[0];
      pDest := @NewCells[0];
      
      if nWidth > FWidth then
        nSizeCopy := sizeof(pSrc^) * FWidth
      else nSizeCopy := sizeof(pSrc^) * nWidth;
      if nHeight > FHeight then
        nCopyHeight := FHeight
      else nCopyHeight := nHeight;

      for I := 0 to nCopyHeight - 1 do
      begin
        Move( pSrc^, pDest^, nSizeCopy );
        Inc( pSrc, FWidth );
        Inc( pDest, nWidth );
      end;
    end;

    pSrc := Pointer(FCells);
    Pointer(FCells) := Pointer(NewCells);
    Pointer(NewCells) := pSrc;
    FWidth := nWidth;
    FHeight := nHeight;
  finally
    SetLength(NewCells, 0);
  end;
end;

procedure TWWMap.OutOfHeight(nRow: Integer);
begin
  if (nRow < 0) or (nRow > FHeight) then
    raise Exception.CreateFmt('超出地图高度 %d', [nRow]);
end;

procedure TWWMap.OutOfWidth(nCol: Integer);
begin
  if (nCol < 0) or (nCol > FWidth) then
    raise Exception.CreateFmt('超出地图宽度 %d', [nCol]);
end;

procedure TWWMap.CheckRect(Rect: TRect);
begin
  OutOfHeight(Rect.Top);
  OutOfWidth(Rect.Left);
  OutOfHeight(Rect.Bottom);
  OutOfWidth(Rect.Right);
end;

procedure TWWMap.SetWidth(const Value: Integer);
begin   
  if FWidth <> Value then
  begin
    SetSize(Value, FHeight);
  end;
end;

end.
