/**************************************************************************\
*
* Module Name:
*
*   GdipPen_c.h
*
* Abstract:
*
*   GDI+ Pen function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/
#ifndef __GDIPPEN_C_H
#define __GDIPPEN_C_H

//--------------------------------------------------------------------------
// Pen class
//--------------------------------------------------------------------------

FORCEINLINE
PGpPen PenFromColor(ARGB color, REAL width)
{
    PGpPen pen;
	return GdipCreatePen1(color, width, UnitWorld, &pen) == Ok? pen : NULL;
}

FORCEINLINE
PGpPen PenFromBrush(const PGpBrush brush, REAL width)
{
    PGpPen pen;
	return GdipCreatePen2(brush, width, UnitWorld, &pen) == Ok? pen : NULL;
}

FORCEINLINE
PGpPen PenCreate(ARGB color)
{
	return PenFromColor(color, 1);
}

FORCEINLINE
PGpPen PenClone(const PGpPen source)
{
    PGpPen pen;
	return GdipClonePen(source, &pen) == Ok? pen : NULL;
}

FORCEINLINE
Status PenDelete(PGpPen pen)
{
	return GdipDeletePen(pen);
}

FORCEINLINE
Status PenSetWidth(PGpPen pen, REAL width)
{
	return GdipSetPenWidth(pen, width);
}

FORCEINLINE
REAL PenGetWidth(PGpPen pen)
{
	REAL width;
	GdipGetPenWidth(pen, &width);
	return width;
}
    
    // Set/get line caps: start, end, and dash

    // Line cap and join APIs by using LineCap and LineJoin enums.

FORCEINLINE
Status PenSetLineCap(PGpPen pen, LineCap startCap, LineCap endCap, DashCap dashCap)
{
	return GdipSetPenLineCap197819(pen, startCap, endCap, dashCap);
}

FORCEINLINE
Status PenSetStartCap(PGpPen pen, LineCap startCap)
{
	return GdipSetPenStartCap(pen, startCap);
}

FORCEINLINE
Status PenSetEndCap(PGpPen pen, LineCap endCap)
{
	return GdipSetPenEndCap(pen, endCap);
}

FORCEINLINE
Status PenSetDashCap(PGpPen pen, DashCap dashCap)
{
	return GdipSetPenDashCap197819(pen, dashCap);
}

FORCEINLINE
LineCap PenGetStartCap(PGpPen pen)
{
	LineCap lineCap;
	GdipGetPenStartCap(pen, &lineCap);
	return lineCap;
}

FORCEINLINE
LineCap PenGetEndCap(PGpPen pen)
{
	LineCap lineCap;
	GdipGetPenEndCap(pen, &lineCap);
	return lineCap;
}

FORCEINLINE
DashCap PenGetDashCap(PGpPen pen)
{
	DashCap dashCap;
	GdipGetPenDashCap197819(pen, &dashCap);
	return dashCap;
}

FORCEINLINE
Status PenSetLineJoin(PGpPen pen, LineJoin lineJoin)
{
	return GdipSetPenLineJoin(pen, lineJoin);
}

FORCEINLINE
LineJoin PenGetLineJoin(PGpPen pen)
{
	LineJoin lineJoin;
	GdipGetPenLineJoin(pen, &lineJoin);
	return lineJoin;
}

FORCEINLINE
Status PenSetCustomStartCap(PGpPen pen, const PGpCustomCap customCap)
{
	return GdipSetPenCustomStartCap(pen, customCap);
}

FORCEINLINE
Status PenGetCustomStartCap(PGpPen pen, PGpCustomCap customCap)
{
	return GdipGetPenCustomStartCap(pen, &customCap);
}

FORCEINLINE
Status PenSetCustomEndCap(PGpPen pen, const PGpCustomCap customCap)
{
	return GdipSetPenCustomEndCap(pen, customCap);
}

FORCEINLINE
Status PenGetCustomEndCap(PGpPen pen, PGpCustomCap customCap)
{
	return GdipGetPenCustomEndCap(pen, &customCap);
}

FORCEINLINE
Status PenSetMiterLimit(PGpPen pen, REAL miterLimit)
{
	return GdipSetPenMiterLimit(pen, miterLimit);
}

FORCEINLINE
REAL PenGetMiterLimit(PGpPen pen)
{
	REAL limit;
	GdipGetPenMiterLimit(pen, &limit);
	return limit;
}

FORCEINLINE
Status PenSetAlignment(PGpPen pen, PenAlignment penAlignment)
{
	return GdipSetPenMode(pen, penAlignment);
}

FORCEINLINE
PenAlignment PenGetAlignment(PGpPen pen)
{
	PenAlignment alignment;
	GdipGetPenMode(pen, &alignment);
	return alignment;
}

FORCEINLINE
Status PenSetTransform(PGpPen pen, const PGpMatrix matrix)
{
	return GdipSetPenTransform(pen, matrix);
}

FORCEINLINE
Status PenGetTransform(PGpPen pen, PGpMatrix matrix)
{
	return GdipGetPenTransform(pen, matrix);
}

FORCEINLINE
Status PenResetTransform(PGpPen pen)
{
	return GdipResetPenTransform(pen);
}

FORCEINLINE
Status PenMultiply(PGpPen pen, const PGpMatrix matrix, MatrixOrder order)
{
	return GdipMultiplyPenTransform(pen, matrix, order);
}

FORCEINLINE
Status PenTranslate(PGpPen pen, REAL dx, REAL dy, MatrixOrder order)
{
	return GdipTranslatePenTransform(pen, dx, dy, order);
}

FORCEINLINE
Status PenScale(PGpPen pen, REAL sx, REAL sy, MatrixOrder order)
{
	return GdipScalePenTransform(pen, sx, sy, order);
}

FORCEINLINE
Status PenRotate(PGpPen pen, REAL angle, MatrixOrder order)
{
	return GdipRotatePenTransform(pen, angle, order);
}

FORCEINLINE
PenType PenGetPenType(PGpPen pen)
{
	PenType type;
	GdipGetPenFillType(pen, &type);
	return type;
}

FORCEINLINE
Status PenSetColor(PGpPen pen, ARGB color)
{
	return GdipSetPenColor(pen, color);
}

FORCEINLINE
Status PenSetBrush(PGpPen pen, const PGpBrush brush)
{
	return GdipSetPenBrushFill(pen, brush);
}

FORCEINLINE
ARGB PenGetColor(PGpPen pen)
{
	ARGB color;
	if (PenGetPenType(pen) != PenTypeSolidColor)
		return 0;
	return GdipGetPenColor(pen, &color) == Ok? color : 0;
}

FORCEINLINE
PGpBrush PenGetBrush(PGpPen pen)
{
	PGpBrush brush;
	return GdipGetPenBrushFill(pen, &brush) == Ok? brush : NULL;
}

FORCEINLINE
DashStyle PenGetDashStyle(PGpPen pen)
{
	DashStyle style;
	GdipGetPenDashStyle(pen, &style);
	return style;
}

FORCEINLINE
Status PenSetDashStyle(PGpPen pen, DashStyle dashStyle)
{
	return GdipSetPenDashStyle(pen, dashStyle);
}

FORCEINLINE
REAL PenGetDashOffset(PGpPen pen)
{
	REAL offset;
	GdipGetPenDashOffset(pen, &offset);
	return offset;
}

FORCEINLINE
Status PenSetDashOffset(PGpPen pen, REAL dashOffset)
{
	return GdipSetPenDashOffset(pen, dashOffset);
}
    
FORCEINLINE
Status PenSetDashPattern(PGpPen pen, const PREAL dashArray, INT count)
{
	return GdipSetPenDashArray(pen, dashArray, count);
}

FORCEINLINE
INT PenGetDashPatternCount(PGpPen pen)
{
	INT count;
	return GdipGetPenDashCount(pen, &count) == Ok? count : 0;
}

FORCEINLINE
Status PenGetDashPattern(PGpPen pen, PREAL dashArray, INT count)
{
	return GdipGetPenDashArray(pen, dashArray, count);
}

FORCEINLINE
Status PenSetCompoundArray(PGpPen pen, const PREAL compoundArray, INT count)
{
	return GdipSetPenCompoundArray(pen, compoundArray, count);
}

FORCEINLINE
INT PenGetCompoundArrayCount(PGpPen pen)
{
	INT count;
	return GdipGetPenCompoundCount(pen, &count) == Ok? count : 0;
}

FORCEINLINE
Status PenGetCompoundArray(PGpPen pen, PREAL compoundArray, INT count)
{
	return GdipGetPenCompoundArray(pen, compoundArray, count);
}

#endif

