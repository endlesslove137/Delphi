unit Project1_TLB;

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
// File generated on 2013-11-07 11:07:48 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\mine\百度网盘\我的文档\work\program\delphi\practice\com\MemoDemo\Project1.tlb (1)
// LIBID: {708FFDBC-6290-4C3F-811F-E86BD189AC04}
// LCID: 0
// Helpfile: 
// HelpString: Project1 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
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
  Project1MajorVersion = 1;
  Project1MinorVersion = 0;

  LIBID_Project1: TGUID = '{708FFDBC-6290-4C3F-811F-E86BD189AC04}';

  IID_IMemoIntf: TGUID = '{51B051C6-D2A6-44B9-9140-86C6BBA6CD26}';
  CLASS_MemoIntf: TGUID = '{F7FFDBC0-8A4D-45F9-8600-F3F5BD5D7ADF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMemoIntf = interface;
  IMemoIntfDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MemoIntf = IMemoIntf;


// *********************************************************************//
// Interface: IMemoIntf
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51B051C6-D2A6-44B9-9140-86C6BBA6CD26}
// *********************************************************************//
  IMemoIntf = interface(IDispatch)
    ['{51B051C6-D2A6-44B9-9140-86C6BBA6CD26}']
    function Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    property Color: OLE_COLOR read Get_Color write Set_Color;
  end;

// *********************************************************************//
// DispIntf:  IMemoIntfDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51B051C6-D2A6-44B9-9140-86C6BBA6CD26}
// *********************************************************************//
  IMemoIntfDisp = dispinterface
    ['{51B051C6-D2A6-44B9-9140-86C6BBA6CD26}']
    property Color: OLE_COLOR dispid 201;
  end;

// *********************************************************************//
// The Class CoMemoIntf provides a Create and CreateRemote method to          
// create instances of the default interface IMemoIntf exposed by              
// the CoClass MemoIntf. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMemoIntf = class
    class function Create: IMemoIntf;
    class function CreateRemote(const MachineName: string): IMemoIntf;
  end;

implementation

uses ComObj;

class function CoMemoIntf.Create: IMemoIntf;
begin
  Result := CreateComObject(CLASS_MemoIntf) as IMemoIntf;
end;

class function CoMemoIntf.CreateRemote(const MachineName: string): IMemoIntf;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MemoIntf) as IMemoIntf;
end;

end.
