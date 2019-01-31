/**************************************************************************\
*
* Module Name:
*
*   GdipGpStubs.h       
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef BCGdipGpStubsHPP
#pragma option push -b -a8 -pc -A- /*P_O_Push*/
#define BCGdipGpStubsHPP

//---------------------------------------------------------------------------
// Private GDI+ classes for internal type checking
//---------------------------------------------------------------------------
class GpNative {};
typedef GpNative  GpGraphics;

typedef GpNative  GpBrush;
typedef GpNative  GpTexture;
typedef GpNative  GpSolidFill;
typedef GpNative  GpLineGradient;
typedef GpNative  GpPathGradient;
typedef GpNative  GpHatch;

typedef GpNative  GpPen;
typedef GpNative  GpCustomLineCap;
typedef GpNative  GpAdjustableArrowCap;

typedef GpNative  GpImage;
typedef GpNative  GpBitmap;
typedef GpNative  GpMetafile;
typedef GpNative  GpImageAttributes;

typedef GpNative  GpPath;
typedef GpNative  GpRegion;
typedef GpNative  GpPathIterator;

typedef GpNative  GpFontFamily;
typedef GpNative  GpFont;
typedef GpNative  GpStringFormat;
typedef GpNative  GpFontCollection;
typedef GpNative  GpInstalledFontCollection;
typedef GpNative  GpPrivateFontCollection;

typedef GpNative  GpCachedBitmap;
typedef GpNative  GpMatrix;

typedef Status GpStatus;
typedef FillMode GpFillMode;
typedef WrapMode GpWrapMode;
typedef Unit GpUnit;
typedef CoordinateSpace GpCoordinateSpace;

typedef PointF GpPointF;
typedef Point GpPoint;
typedef RectF GpRectF;
typedef Rect GpRect;
typedef SizeF GpSizeF;
typedef Size GpSize;

typedef HatchStyle GpHatchStyle;
typedef DashStyle GpDashStyle;
typedef LineCap GpLineCap;
typedef DashCap GpDashCap;


typedef PenAlignment GpPenAlignment;

typedef LineJoin GpLineJoin;
typedef PenType GpPenType;

//typedef Matrix GpMatrix;
typedef BrushType GpBrushType;
typedef MatrixOrder GpMatrixOrder;
typedef FlushIntention GpFlushIntention;
typedef PathData GpPathData;

#pragma option pop /*P_O_Pop*/
#endif  // !_GDIPLUSGPSTUBS.HPP

