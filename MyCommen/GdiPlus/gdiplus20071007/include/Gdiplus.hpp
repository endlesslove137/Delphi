/**************************************************************************\
*
* Module Name:
*
*   Gdiplus.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdiplusHPP
#define GdiplusHPP

#if	!defined(__BCPLUSPLUS__) || !defined(INC_VCL)
#error Do not include this file directly. The Gdiplus for Borland VCL
#endif

struct IDirectDrawSurface7;

typedef signed   short  INT16;
typedef unsigned short  UINT16;

// Define the Current GDIPlus Version
#ifndef GDIPVER
#define GDIPVER 0x0100
#endif

#define	__GDIPLUS_VCL

#include <pshpack8.h>   // set structure packing to 8

namespace Gdiplus
{
	namespace GdiplusSys
	{
		#include "GdiplusMem.h"
		#include "GdiplusEnums.h"
		#include "GdipTypes.h"			//
		#include "GdiplusInit.h"
		#include "GdiplusPixelFormats.h"
		#include "GdipColor.h"          //
		#include "GdiplusMetaHeader.h"
		#include "GdiplusImaging.h"
		#include "GdiplusColorMatrix.h"
		#include "GdipGpStubs.h"      	//
		#include "GdiplusFlat.h"
	};
	using namespace GdiplusSys;

	#include "GdipBase.hpp"
	#include "GdipHeaders.hpp"
	#include "GdipImageAttributes.hpp"
	#include "GdipMatrix.hpp"
	#include "GdipBrush.hpp"
	#include "GdipPen.hpp"
	#include "GdipStringFormat.hpp"
	#include "GdipPath.hpp"
	#include "GdipLineCaps.hpp"
	#include "GdipMetafile.hpp"
	#include "GdipGraphics.hpp"
	#include "GdipCachedBitmap.hpp"
	#include "GdipRegion.hpp"
	#include "GdipFontCollection.hpp"
	#include "GdipFontFamily.hpp"
	#include "GdipFont.hpp"
    #include "GdipBitmap.hpp"
	#include "GdipImageCodec.hpp"
    #include "GdipObjs.hpp"
}; // namespace Gdiplus
using namespace Gdiplus;

#include <poppack.h>    // pop structure packing back to previous state

#endif
