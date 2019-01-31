unit uExportXls;

interface 

uses 
 DB,Classes, Windows, WinSock; 

var 
 CXlsBof: array[0..5] of Word = ($809, 8, 0, $10, 0, 0); 
 CXlsEof: array[0..1] of Word = ($0A, 00); 
 CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0); 
 CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0); 
 CXlsRk: array[0..4] of Word = ($27E, 10, 0, 0, 0); 
 CXlsBlank: array[0..4] of Word = ($201, 6, 0, 0, $17); 

type 
 TFldRec = record 
   Title: string; 
   Width: Integer; 
 end; 

 ExportXls = class(TObject) 
 Private 
   FCol: word; 
   FRow: word; 
   FDataSet: TDataSet; 
   Stream: TStream; 
   FWillWriteHead: boolean; 
   FBookMark: TBookmark; 
   procedure IncColRow; 
   procedure WriteBlankCell; 
   procedure WriteFloatCell(const AValue: Double); 
   procedure WriteIntegerCell(const AValue: Integer); 
   procedure WriteStringCell(const AValue: string); 
   procedure WritePrefix; 
   procedure WriteSuffix; 
   procedure WriteTitle; 
   procedure WriteDataCell; 

   procedure Save2Stream(aStream: TStream); 
 Public 
   procedure SaveToXlsFile(FileName: string; WillWriteHead: Boolean); 
   constructor Create(aDataSet: TDataSet); 
 end; 
procedure ExportToXls(const FileName: string; DataSet: TDataSet);// Boolean; 
implementation 

uses SysUtils, ConfigINI, fMain; 

procedure ExportToXls(const FileName: string; DataSet: TDataSet);// Boolean; 
begin 
 //if DataSet.Active then 
// Result := False; 
 with ExportXls.Create(DataSet) do 
 try 
   SaveToXlsFile(FileName, True); 
//  Result := True; 
 finally 
   Free; 
 end; 
end; 

constructor ExportXls.Create(aDataSet: TDataSet); 
begin 
 inherited Create; 
 FDataSet := aDataSet; 
end; 

procedure ExportXls.IncColRow; 
begin 
 if FCol = FDataSet.FieldCount - 1 then 
 begin 
   Inc(FRow); 
   FCol := 0; 
 end 
 else 
   Inc(FCol); 
end; 

procedure ExportXls.WriteBlankCell; 
begin 
 CXlsBlank[2] := FRow; 
 CXlsBlank[3] := FCol; 
 Stream.WriteBuffer(CXlsBlank, SizeOf(CXlsBlank)); 
 IncColRow; 
end; 

procedure ExportXls.WriteFloatCell(const AValue: Double); 
begin 
 CXlsNumber[2] := FRow; 
 CXlsNumber[3] := FCol; 
 Stream.WriteBuffer(CXlsNumber, SizeOf(CXlsNumber)); 
 Stream.WriteBuffer(AValue, 8); 
 IncColRow; 
end; 

procedure ExportXls.WriteIntegerCell(const AValue: Integer); 
var 
 V: Integer; 
begin 
 CXlsRk[2] := FRow; 
 CXlsRk[3] := FCol; 
 Stream.WriteBuffer(CXlsRk, SizeOf(CXlsRk)); 
 V := (AValue shl 2) or 2; 
 Stream.WriteBuffer(V, 4); 
 IncColRow; 
end; 

procedure ExportXls.WriteStringCell(const AValue: string); 
var 
 L: Word; 
begin 
 L := Length(AValue); 
 CXlsLabel[1] := 8 + L; 
 CXlsLabel[2] := FRow; 
 CXlsLabel[3] := FCol; 
 CXlsLabel[5] := L; 
 Stream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel)); 
 Stream.WriteBuffer(Pointer(AValue)^, L); 
 IncColRow; 
end; 

procedure ExportXls.WritePrefix; 
begin 
 Stream.WriteBuffer(CXlsBof, SizeOf(CXlsBof)); 
end; 

procedure ExportXls.WriteSuffix; 
begin 
 Stream.WriteBuffer(CXlsEof, SizeOf(CXlsEof)); 
end; 

procedure ExportXls.WriteTitle; 
var 
 n: word; 
begin 
 for n := 0 to FDataSet.FieldCount - 1 do 
   WriteStringCell(FDataSet.Fields[n].DisplayLabel); //œ‘ æ±Í«©√˚ 
end; 

procedure ExportXls.WriteDataCell; 
var 
 Idx: word; 
begin 
 WritePrefix; 
 if FWillWriteHead then 
   WriteTitle; 
 FDataSet.DisableControls; 
 FBookMark := FDataSet.GetBookmark; 
 FDataSet.First; 
 while not FDataSet.Eof do 
 begin 
   for Idx := 0 to FDataSet.FieldCount - 1 do 
   begin 
     if FDataSet.Fields[Idx].IsNull then 
       WriteBlankCell 
     else 
     begin 
       case FDataSet.Fields[Idx].DataType of 
         ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:
           WriteIntegerCell(FDataSet.Fields[Idx].AsInteger);
         ftFloat, ftCurrency, ftBCD: 
           WriteFloatCell(FDataSet.Fields[Idx].AsFloat); 
       else
         if Assigned(FDataSet.Fields[Idx].OnGetText) then 
           WriteStringCell(FDataSet.Fields[Idx].Text) 
         else
           if FDataSet.Fields[Idx].FieldName = 'IntIP' then
           begin
             WriteStringCell(inet_ntoa(in_addr(FDataSet.Fields[Idx].AsInteger)));
           end
           else begin
             WriteStringCell(frmMain.ConvertStrFormat(FDataSet.Fields[Idx].AsString));
           end;
       end; 
     end; 
   end; 
   FDataSet.Next;
 end; 
 WriteSuffix; 
 if FDataSet.BookmarkValid(FBookMark) then 
   FDataSet.GotoBookmark(FBookMark); 
 FDataSet.EnableControls; 
end; 

procedure ExportXls.Save2Stream(aStream: TStream); 
begin 
  FCol := 0;
  FRow := 0;
  Stream := aStream;
  WriteDataCell; 
end; 

procedure ExportXls.SaveToXlsFile(FileName: string; WillWriteHead: Boolean); 
var 
 aFileStream: TFileStream; 
begin 
 FWillWriteHead := WillWriteHead; 
 if FileExists(FileName) then 
   DeleteFile(FileName); 
 aFileStream := TFileStream.Create(FileName, fmCreate); 
 try 
   Save2Stream(aFileStream); 
 finally 
   aFileStream.Free; 
 end; 
end; 

end. 
