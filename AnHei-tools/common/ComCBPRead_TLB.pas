unit ComCBPRead_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2011-10-25 11:36:53 from Type Library described below.

// ************************************************************************  //
// Type Lib: F:\WorkSVN\tcgp\trunk\ZhanJiangII\tools\ComCBPRead\ComCBPRead.tlb (1)
// LIBID: {C66B0F2E-16B4-4EA9-8E19-FB53EAABE690}
// LCID: 0
// Helpfile: 
// HelpString: ComCBPRead Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ComCBPReadMajorVersion = 1;
  ComCBPReadMinorVersion = 0;

  LIBID_ComCBPRead: TGUID = '{C66B0F2E-16B4-4EA9-8E19-FB53EAABE690}';

  IID_ILuaField: TGUID = '{7FD5FF28-DC4D-4D95-A44D-32F5CE2C8EC5}';
  CLASS_LuaField: TGUID = '{3EAB4487-63E9-4ED8-9ED8-147B35CB5603}';
  IID_IComBinaryProperty: TGUID = '{63ED16AD-6285-444F-B8A9-AFB8726F8641}';
  CLASS_ComBinaryProperty: TGUID = '{BFA0557A-F20A-414E-A922-4BD46B6C4E3E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ILuaField = interface;
  IComBinaryProperty = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  LuaField = ILuaField;
  ComBinaryProperty = IComBinaryProperty;


// *********************************************************************//
// Interface: ILuaField
// Flags:     (256) OleAutomation
// GUID:      {7FD5FF28-DC4D-4D95-A44D-32F5CE2C8EC5}
// *********************************************************************//
  ILuaField = interface(IUnknown)
    ['{7FD5FF28-DC4D-4D95-A44D-32F5CE2C8EC5}']
    function SeriesText: WideString; stdcall;
    function GetTableValue: ILuaField; stdcall;
    function GetTableFieldCount: Integer; stdcall;
    function GetTableFieldIndex(Index: Integer): ILuaField; stdcall;
    function GetTableField(const Name: WideString): ILuaField; stdcall;
    function GetTableFieldExists(const Name: WideString): WordBool; stdcall;
    function GetName: WideString; stdcall;
    function Get_Number: Double; stdcall;
    procedure Set_Number(Value: Double); stdcall;
    function Get_Boolean: WordBool; stdcall;
    procedure Set_Boolean(Value: WordBool); stdcall;
    function Get_String_: WideString; stdcall;
    procedure Set_String_(const Value: WideString); stdcall;
    function Get_Integer: Integer; stdcall;
    procedure Set_Integer(iValue: Integer); stdcall;

    property AsString: WideString read Get_String_ write Set_String_;
    property AsBoolean: WordBool read Get_Boolean write Set_Boolean;
    property AsNumber: Double read Get_Number write Set_Number;
    property AsInteger: Integer read Get_Integer write Set_Integer;
    property AsTable: ILuaField read GetTableValue;
    property FieldCount: Integer read GetTableFieldCount;
    property FieldIndex[Index: Integer]: ILuaField read GetTableFieldIndex;
    property Fields[const Name: WideString]: ILuaField read GetTableField;
    property FieldExists[const Name: WideString]: WordBool read GetTableFieldExists;
    property Name: WideString read GetName;
  end;

// *********************************************************************//
// Interface: IComBinaryProperty
// Flags:     (256) OleAutomation
// GUID:      {63ED16AD-6285-444F-B8A9-AFB8726F8641}
// *********************************************************************//
  IComBinaryProperty = interface(IUnknown)
    ['{63ED16AD-6285-444F-B8A9-AFB8726F8641}']
    function LoadHttpCBP(const cbpFile: WideString): ILuaField; stdcall;
    function LoadCBPFile(const cbpFile: WideString): ILuaField; stdcall;
  end;

// *********************************************************************//
// The Class CoLuaField provides a Create and CreateRemote method to          
// create instances of the default interface ILuaField exposed by              
// the CoClass LuaField. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLuaField = class
    class function Create: ILuaField;
    class function CreateRemote(const MachineName: string): ILuaField;
  end;

// *********************************************************************//
// The Class CoComBinaryProperty provides a Create and CreateRemote method to          
// create instances of the default interface IComBinaryProperty exposed by              
// the CoClass ComBinaryProperty. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoComBinaryProperty = class
    class function Create: IComBinaryProperty;
    class function CreateRemote(const MachineName: string): IComBinaryProperty;
  end;

function CreateLocalComBinaryProperty(): IComBinaryProperty; stdcall;

implementation

uses ComObj;

function _CreateLocalComBinaryProperty: Pointer; stdcall;
  external 'ComCBPRead.dll' name 'CreateLocalComBinaryProperty';

class function CoLuaField.Create: ILuaField;
begin
  Result := CreateComObject(CLASS_LuaField) as ILuaField;
end;

class function CoLuaField.CreateRemote(const MachineName: string): ILuaField;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LuaField) as ILuaField;
end;

class function CoComBinaryProperty.Create: IComBinaryProperty;
begin
  Result := CreateComObject(CLASS_ComBinaryProperty) as IComBinaryProperty;
end;

class function CoComBinaryProperty.CreateRemote(const MachineName: string): IComBinaryProperty;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ComBinaryProperty) as IComBinaryProperty;
end;

function CreateLocalComBinaryProperty(): IComBinaryProperty; stdcall;
begin
  Result := IComBinaryProperty(_CreateLocalComBinaryProperty);
  Result._Release();
end;


end.
