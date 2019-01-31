/**************************************************************************\
*
* Module Name:
*
*   Gdiplus_c.h
*
* Abstract:
*
*   GDI+ public header file
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPLUS_C_H
#ifdef  __BORLANDC__
#pragma option push -b -a8 -pc -A- -w-inl -w-hid /*P_O_Push*/
#endif
#define __GDIPLUS_C_H

#ifdef __cplusplus
#error This GDI+ header files can only be a C compiler, can not use C++ Compiler.
#endif

typedef void IDirectDrawSurface7;

typedef signed   short	INT16;
typedef unsigned short	UINT16;

// Define the Current GDIPlus Version
#ifndef GDIPVER
#define GDIPVER 0x0100
#endif

#include <pshpack8.h>   // set structure packing to 8

#include "GdipEnums_c.h"
#include "GdipTypes_c.h"
#include "GdipInit_c.h"
#include "GdipPixelFormats_c.h"
#include "GdipColor_c.h"
#include "GdipMetaHeader_c.h"
#include "GdipImaging_c.h"
#include "GdipColorMatrix_c.h"
#include "GdipGpStubs_c.h"
#include "GdipFlat_c.h"

#include "GdipImageAttr_c.h"
#include "GdipMatrix_c.h"
#include "GdipBrush_c.h"
#include "GdipPen_c.h"
#include "GdipStringFormat_c.h"
#include "GdipPath_c.h"
#include "GdipLineCaps_c.h"
#include "GdipMetafile_c.h"
#include "GdipGraphics_c.h"
#include "GdipCachedBitmap_c.h"
#include "GdipRegion_c.h"
#include "GdipFontCollection_c.h"
#include "GdipFontFamily_c.h"
#include "GdipFont_c.h"
#include "GdipBitmap_c.h"
#include "GdipImageCode_c.h"

#include <poppack.h>    // pop structure packing back to previous state

#ifdef  __BORLANDC__
#pragma option pop /*P_O_Pop*/
#endif
#endif // !_GDIPLUS_HPP
