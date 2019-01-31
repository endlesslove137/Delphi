/**************************************************************************\
*
* Module Name:
*
*   GdipGpStubs_c.h
*
* Abstract:
*
*   Private GDI+ header file.
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPGPSTUBS_C_H
#define __GDIPGPSTUBS_C_H

//---------------------------------------------------------------------------
// Private GDI+ classes for internal type checking
//---------------------------------------------------------------------------
typedef void GpNative;

typedef GpNative 	GpGraphics,			*PGpGraphics, PGpCanvas;

typedef GpNative 	GpBrush,			*PGpBrush;
typedef GpBrush 	GpTexture,			*PGpTextureBrush, *PGpTexture;
typedef GpBrush 	GpSolidFill, 		*PGpSolidBrush, *PGpSolidFill;
typedef GpBrush 	GpLineGradient,		*PGpLineBrush, *PGpLineGradient;
typedef GpBrush 	GpPathGradient,		*PGpPathBrush, *PGpPathGradient;
typedef GpBrush 	GpHatch,			*PGpHatchBrush, *PGpHatch;

typedef GpNative 	GpPen,				*PGpPen;
typedef GpNative 	GpCustomLineCap,	*PGpCustomCap, *PGpCustomLineCap;
typedef GpCustomLineCap GpAdjustableArrowCap, *PGpArrowCap, *PGpAdjustableArrowCap;

typedef GpNative    GpImage,			*PGpImage;
typedef GpImage     GpBitmap,			*PGpBitmap;
typedef GpImage     GpMetafile,			*PGpMetafile;
typedef GpNative    GpImageAttributes,	*PGpImageAttr, *PGpImageAttributes;

typedef GpNative    GpPath,				*PGpPath, *PGpGraphicsPath;
typedef GpNative    GpRegion,			*PGpRegion;
typedef GpNative    GpPathIterator,		*PGpPathIterator;

typedef GpNative    GpFontFamily,		*PGpFontFamily;
typedef GpNative    GpFont,				*PGpFont;
typedef GpNative    GpStringFormat,		*PGpStrFormat, *PGpStringFormat;
typedef GpNative    GpFontCollection,	*PGpFontCollection;
typedef GpFontCollection GpInstalledFontCollection,	*PGpInstalledFontCollection;
typedef GpFontCollection GpPrivateFontCollection,	*PGpPrivateFontCollection;
typedef GpNative    GpMatrix,			*PGpMatrix;
typedef GpNative 	GpCachedBitmap,		*PGpCachedBitmap;

typedef Status 			GpStatus, *PStatus;
typedef FillMode 		GpFillMode, *PFillMode;
typedef WrapMode 		GpWrapMode, *PWrapMode;
typedef Unit 			GpUnit, *PUnit;
typedef CoordinateSpace GpCoordinateSpace, *PCoordinateSpace;
typedef PointF 			GpPointF, *PPointF;
typedef Point 			GpPoint, *PPoint;
typedef RectF 			GpRectF, *PRectF;
typedef Rect 			GpRect, *PRect;
typedef SizeF 			GpSizeF, *PSizeF;
typedef Size 			GpSize, *PSize;
typedef HatchStyle 		GpHatchStyle, *PHatchStyle;
typedef DashStyle 		GpDashStyle, *PDashStyle;
typedef LineCap 		GpLineCap, *PLineCap;
typedef DashCap 		GpDashCap, *PDashCap;

typedef PenAlignment 	GpPenAlignment, *PPenAlignment;

typedef LineJoin    	GpLineJoin, *PLineJoin;
typedef PenType     	GpPenType, *PPenType;

typedef BrushType   	GpBrushType, *PBrushType;
typedef MatrixOrder 	GpMatrixOrder, *PMatrixOrder;
typedef FlushIntention 	GpFlushIntention, *PFlushIntention;
typedef PathData    	GpPathData, *PPathData;

#endif  // !_GDIPGPSTUBS_C.H

