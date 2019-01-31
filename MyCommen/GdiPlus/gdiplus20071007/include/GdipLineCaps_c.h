/**************************************************************************\
*
* Module Name:
* 
*    GdipLineCaps_c.h
*
* Abstract:
*
*   GDI+ CustomLineCap function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPLINECAPS_C_H
#define __GDIPLINECAPS_C_H

FORCEINLINE
PGpCustomCap CustomCapCreate(const PGpPath fillPath,
	const PGpPath strokePath, LineCap baseCap, REAL baseInset)
{
    PGpCustomCap cap;
	return GdipCreateCustomLineCap(fillPath, strokePath,
		baseCap, baseInset, &cap) == Ok? cap : NULL;
}

FORCEINLINE
Status CustomCapDelete(PGpCustomCap cap)
{
	return GdipDeleteCustomLineCap(cap);
}

FORCEINLINE
Status CustomCapSetStrokeCaps(PGpCustomCap cap, LineCap startCap, LineCap endCap)
{
	return GdipSetCustomLineCapStrokeCaps(cap, startCap, endCap);
}

FORCEINLINE
Status CustomCapGetStrokeCaps(PGpCustomCap cap, PLineCap startCap, PLineCap endCap)
{
	return GdipGetCustomLineCapStrokeCaps(cap, startCap, endCap);
}

FORCEINLINE
Status CustomCapSetStrokeJoin(PGpCustomCap cap, LineJoin lineJoin)
{
	return GdipSetCustomLineCapStrokeJoin(cap, lineJoin);
}

FORCEINLINE
LineJoin CustomCapGetStrokeJoin(PGpCustomCap cap)
{
	LineJoin lineJoin;
	GdipGetCustomLineCapStrokeJoin(cap, &lineJoin);
	return lineJoin;
}

FORCEINLINE
Status CustomCapSetBaseCap(PGpCustomCap cap, LineCap baseCap)
{
	return GdipSetCustomLineCapBaseCap(cap, baseCap);
}

FORCEINLINE
LineCap CustomCapGetBaseCap(PGpCustomCap cap)
{
	LineCap lineCap;
	GdipGetCustomLineCapBaseCap(cap, &lineCap);
	return lineCap;
}

FORCEINLINE
Status CustomCapSetBaseInset(PGpCustomCap cap, REAL inset)
{
	return GdipSetCustomLineCapBaseInset(cap, inset);
}

FORCEINLINE
REAL CustomCapGetBaseInset(PGpCustomCap cap)
{
	REAL inset;
	return GdipGetCustomLineCapBaseInset(cap, &inset) == Ok? inset : 0;
}

FORCEINLINE
Status CustomCapSetWidthScale(PGpCustomCap cap, REAL widthScale)
{
	return GdipSetCustomLineCapWidthScale(cap, widthScale);
}

FORCEINLINE
REAL CustomCapGetWidthScale(PGpCustomCap cap)
{
	REAL widthScale;
	return GdipGetCustomLineCapWidthScale(cap, &widthScale) == Ok? widthScale : 0;
}

FORCEINLINE
PGpCustomCap CustomCapClone(const PGpCustomCap source)
{
	PGpCustomCap cap;
	return GdipCloneCustomLineCap(source, &cap) == Ok? cap : NULL;
}


FORCEINLINE
PGpArrowCap ArrowCapCreate(REAL height, REAL width, BOOL isFilled)
{
    PGpArrowCap cap;
	return GdipCreateAdjustableArrowCap(height, width, isFilled, &cap) == Ok? cap : NULL;
}

FORCEINLINE
Status ArrowCapSetHeight(PGpArrowCap cap, REAL height)
{
	return GdipSetAdjustableArrowCapHeight(cap, height);
}

FORCEINLINE
REAL ArrowCapGetHeight(PGpArrowCap cap)
{
	REAL height;
	return GdipGetAdjustableArrowCapHeight(cap, &height) == Ok? height : 0;
}

FORCEINLINE
Status ArrowCapSetWidth(PGpArrowCap cap, REAL width)
{
	return GdipSetAdjustableArrowCapWidth(cap, width);
}

FORCEINLINE
REAL ArrowCapGetWidth(PGpArrowCap cap)
{
	REAL width;
	return GdipGetAdjustableArrowCapWidth(cap, &width) == Ok? width : 0;
}

FORCEINLINE
Status ArrowCapSetMiddleInset(PGpArrowCap cap, REAL middleInset)
{
	return GdipSetAdjustableArrowCapMiddleInset(cap, middleInset);
}

FORCEINLINE
REAL ArrowCapGetMiddleInset(PGpArrowCap cap)
{
	REAL inset;
	return GdipGetAdjustableArrowCapMiddleInset(cap, &inset) == Ok? inset : 0;
}

FORCEINLINE
Status ArrowCapSetFillState(PGpArrowCap cap, BOOL isFilled)
{
	return GdipSetAdjustableArrowCapFillState(cap, isFilled);
}

FORCEINLINE
BOOL ArrowCapIsFilled(PGpArrowCap cap)
{
	BOOL value;
	return GdipGetAdjustableArrowCapFillState(cap, &value) == Ok? value : FALSE;
}

#define ArrowCapClone(source)	CustomCapClone(source)
#define ArrowCapDelete(cap)		CustomCapDelete(cap)

#endif

