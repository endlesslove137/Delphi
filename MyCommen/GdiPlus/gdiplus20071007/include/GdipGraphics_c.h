/**************************************************************************\
*
* Module Name:
*
*   GdipGraphics_c.h
*
* Abstract:
*
*   GDI+ Graphics function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPGRAPHICS_C_H
#define __GDIPGRAPHICS_C_H

FORCEINLINE
PGpGraphics	GraphicsFromDC(HDC hdc)
{
    PGpGraphics graphics;
	return GdipCreateFromHDC(hdc, &graphics) == Ok? graphics : NULL;
}


FORCEINLINE
PGpGraphics	GraphicsFromDeviceDC(HDC hdc, HANDLE hdevice)
{
    PGpGraphics graphics;
	return GdipCreateFromHDC2(hdc, hdevice, &graphics) == Ok? graphics : NULL;
}

FORCEINLINE
PGpGraphics	GraphicsFromHWND(HWND hwnd, BOOL icm)
{
    PGpGraphics graphics;
	Status status;
	if (icm) status = GdipCreateFromHWNDICM(hwnd, &graphics);
	else status = GdipCreateFromHWND(hwnd, &graphics);
	return status == Ok? graphics : NULL;
}

FORCEINLINE
PGpGraphics	GraphicsFromImage(PGpImage image)
{
    PGpGraphics graphics;
	return GdipGetImageGraphicsContext(image, &graphics) == Ok? graphics : NULL;
}

FORCEINLINE
PGpGraphics	GraphicsCreate(HDC hdc)
{
	return GraphicsFromDC(hdc);
}

FORCEINLINE
Status GraphicsDelete(PGpGraphics graphics)
{
	return GdipDeleteGraphics(graphics);
}

/* default intention = FlushIntentionFlush */
FORCEINLINE
Status GraphicsFlush(PGpGraphics graphics, FlushIntention intention)
{
	return GdipFlush(graphics, intention);
}

    //------------------------------------------------------------------------
    // GDI Interop methods
    //------------------------------------------------------------------------

	// Locks the graphics until ReleaseDC is called
FORCEINLINE
HDC GraphicsGetHDC(PGpGraphics graphics)
{
	HDC hdc;
	return GdipGetDC(graphics, &hdc) == Ok? hdc : NULL;
}

FORCEINLINE
Status GraphicsReleaseHDC(PGpGraphics graphics, HDC hdc)
{
	return GdipReleaseDC(graphics, hdc);
}

    //------------------------------------------------------------------------
    // Rendering modes
    //------------------------------------------------------------------------

FORCEINLINE
Status GraphicsSetRenderingOrigin(PGpGraphics graphics, INT x, INT y)
{
	return GdipSetRenderingOrigin(graphics, x, y);
}

FORCEINLINE
Status GraphicsGetRenderingOrigin(PGpGraphics graphics, INT *x, INT *y)
{
	return GdipGetRenderingOrigin(graphics, x, y);
}

FORCEINLINE
Status GraphicsSetCompositingMode(PGpGraphics graphics, CompositingMode compositingMode)
{
	return GdipSetCompositingMode(graphics, compositingMode);
}

FORCEINLINE
CompositingMode GraphicsGetCompositingMode(PGpGraphics graphics)
{
	CompositingMode mode;
	GdipGetCompositingMode(graphics, &mode);
	return mode;
}

FORCEINLINE
Status GraphicsSetCompositingQuality(PGpGraphics graphics,
	CompositingQuality compositingQuality)
{
	return GdipSetCompositingQuality(graphics, compositingQuality);
}

FORCEINLINE
CompositingQuality GraphicsGetCompositingQuality(PGpGraphics graphics)
{
	CompositingQuality quality;
	GdipGetCompositingQuality(graphics, &quality);
	return quality;
}

FORCEINLINE
Status GraphicsSetTextRenderingHint(PGpGraphics graphics, TextRenderingHint newMode)
{
	return GdipSetTextRenderingHint(graphics, newMode);
}

FORCEINLINE
TextRenderingHint GraphicsGetTextRenderingHint(PGpGraphics graphics)
{
	TextRenderingHint hint;
	GdipGetTextRenderingHint(graphics, &hint);
	return hint;
}

FORCEINLINE
Status GraphicsSetTextContrast(PGpGraphics graphics, UINT contrast)
{
	return GdipSetTextContrast(graphics, contrast);
}

FORCEINLINE
UINT GraphicsGetTextContrast(PGpGraphics graphics)
{
	UINT contrast;
	GdipGetTextContrast(graphics, &contrast);
	return contrast;
}

FORCEINLINE
InterpolationMode GraphicsGetInterpolationMode(PGpGraphics graphics)
{
	InterpolationMode mode;
	return GdipGetInterpolationMode(graphics, &mode) == Ok?
		mode : InterpolationModeInvalid;
}

FORCEINLINE
Status GraphicsSetInterpolationMode(PGpGraphics graphics, InterpolationMode interpolationMode)
{
	return GdipSetInterpolationMode(graphics, interpolationMode);
}

FORCEINLINE
SmoothingMode GraphicsGetSmoothingMode(PGpGraphics graphics)
{
	SmoothingMode smoothingMode;
	return GdipGetSmoothingMode(graphics, &smoothingMode) == Ok?
		smoothingMode : SmoothingModeInvalid;
}

FORCEINLINE
Status GraphicsSetSmoothingMode(PGpGraphics graphics, SmoothingMode smoothingMode)
{
	return GdipSetSmoothingMode(graphics, smoothingMode);
}

FORCEINLINE
PixelOffsetMode Graphics(PGpGraphics graphics)
{
	PixelOffsetMode pixelOffsetMode;
	return GdipGetPixelOffsetMode(graphics, &pixelOffsetMode) == Ok?
		pixelOffsetMode : PixelOffsetModeInvalid;
}

FORCEINLINE
Status GraphicsSetPixelOffsetMode(PGpGraphics graphics, PixelOffsetMode pixelOffsetMode)
{
	return GdipSetPixelOffsetMode(graphics, pixelOffsetMode);
}

    //------------------------------------------------------------------------
    // Manipulate current world transform
    //------------------------------------------------------------------------

FORCEINLINE
Status GraphicsSetTransform(PGpGraphics graphics, const PGpMatrix matrix)
{
	return GdipSetWorldTransform(graphics, matrix);
}

FORCEINLINE
Status GraphicsResetTransform(PGpGraphics graphics)
{
	return GdipResetWorldTransform(graphics);
}

FORCEINLINE
Status GraphicsMultiply(PGpGraphics graphics, const PGpMatrix matrix, MatrixOrder order)
{
	return GdipMultiplyWorldTransform(graphics, matrix, order);
}

FORCEINLINE
Status GraphicsTranslate(PGpGraphics graphics, REAL dx, REAL dy, MatrixOrder order)
{
	return GdipTranslateWorldTransform(graphics, dx, dy, order);
}

FORCEINLINE
Status GraphicsScale(PGpGraphics graphics, REAL sx, REAL sy, MatrixOrder order)
{
	return GdipScaleWorldTransform(graphics, sx, sy, order);
}

FORCEINLINE
Status GraphicsRotate(PGpGraphics graphics, REAL angle, MatrixOrder order)
{
	return GdipRotateWorldTransform(graphics, angle, order);
}

FORCEINLINE
Status GraphicsGetTransform(PGpGraphics graphics, PGpMatrix matrix)
{
	return GdipGetWorldTransform(graphics, matrix);
}

FORCEINLINE
Status GraphicsSetPageUnit(PGpGraphics graphics, Unit unit)
{
	return GdipSetPageUnit(graphics, unit);
}

FORCEINLINE
Status GraphicsSetPageScale(PGpGraphics graphics, REAL scale)
{
	return GdipSetPageScale(graphics, scale);
}

FORCEINLINE
Unit GraphicsGetPageUnit(PGpGraphics graphics)
{
	Unit unit;
	GdipGetPageUnit(graphics, &unit);
	return unit;
}

FORCEINLINE
REAL GraphicsGetPageScale(PGpGraphics graphics)
{
	REAL scale;
	return GdipGetPageScale(graphics, &scale)== Ok? scale : 0;
}

FORCEINLINE
REAL GraphicsGetDpiX(PGpGraphics graphics)
{
	REAL dpi;
	return GdipGetDpiX(graphics, &dpi) == Ok? dpi : 0;
}

FORCEINLINE
REAL GraphicsGetDpiY(PGpGraphics graphics)
{
	REAL dpi;
	return GdipGetDpiY(graphics, &dpi) == Ok? dpi : 0;
}

FORCEINLINE
Status GraphicsTransformPointsF(PGpGraphics graphics, CoordinateSpace destSpace,
	CoordinateSpace srcSpace, PPointF pts, INT count)
{
	return GdipTransformPoints(graphics, destSpace, srcSpace, pts, count);
}

FORCEINLINE
Status GraphicsTransformPoints(PGpGraphics graphics, CoordinateSpace destSpace,
	CoordinateSpace srcSpace, PPoint pts, INT count)
{
	return GdipTransformPointsI(graphics, destSpace, srcSpace, pts, count);
}

    //------------------------------------------------------------------------
    // GetNearestColor (for <= 8bpp surfaces).  Note: Alpha is ignored.
	//------------------------------------------------------------------------
FORCEINLINE
ARGB GraphicsGetNearestColor(PGpGraphics graphics)
{
	ARGB color;
	return GdipGetNearestColor(graphics, &color) == Ok? color : 0;
}

FORCEINLINE
Status GraphicsDrawLineF(PGpGraphics graphics, const PGpPen pen,
	REAL x1, REAL y1, REAL x2, REAL y2)
{
	return GdipDrawLine(graphics, pen, x1, y1, x2, y2);
}

FORCEINLINE
Status GraphicsDrawLine(PGpGraphics graphics, const PGpPen pen,
	INT x1, INT y1, INT x2, INT y2)
{
	return GdipDrawLineI(graphics, pen, x1, y1, x2, y2);
}

FORCEINLINE
Status GraphicsDrawLinesF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count)
{
	return GdipDrawLines(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawLines(PGpGraphics graphics,const PGpPen pen,
	const PPoint points, INT count)
{
	return GdipDrawLinesI(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawArcF(PGpGraphics graphics, const PGpPen pen,
	REAL x, REAL y, REAL width, REAL height, REAL startAngle, REAL sweepAngle)
{
	return GdipDrawArc(graphics, pen, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsDrawArc(PGpGraphics graphics, const PGpPen pen,
	INT x, INT y, INT width, INT height, REAL startAngle, REAL sweepAngle)
{
	return GdipDrawArcI(graphics, pen, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsDrawBezierF(PGpGraphics graphics, const PGpPen pen,
	REAL x1, REAL y1, REAL x2, REAL y2, REAL x3, REAL y3, REAL x4, REAL y4)
{
	return GdipDrawBezier(graphics, pen, x1, y1, x2, y2, x3, y3, x4, y4);
}

FORCEINLINE
Status GraphicsDrawBezier(PGpGraphics graphics, const PGpPen pen,
	INT x1, INT y1, INT x2, INT y2, INT x3, INT y3, INT x4, INT y4)
{
	return GdipDrawBezierI(graphics, pen, x1, y1, x2, y2, x3, y3, x4, y4);
}

FORCEINLINE
Status GraphicsDrawBeziersF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count)
{
	return GdipDrawBeziers(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawBeziers(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count)
{
	return GdipDrawBeziersI(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawRectangleF(PGpGraphics graphics, const PGpPen pen,
	REAL x, REAL y, REAL width, REAL height)
{
	return GdipDrawRectangle(graphics, pen, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawRectangle(PGpGraphics graphics, const PGpPen pen,
	INT x, INT y, INT width, INT height)
{
	return GdipDrawRectangleI(graphics, pen, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawRectanglesF(PGpGraphics graphics, const PGpPen pen,
	const PRectF rects, INT count)
{
	return GdipDrawRectangles(graphics, pen, rects, count);
}

FORCEINLINE
Status GraphicsDrawRectangles(PGpGraphics graphics, const PGpPen pen,
	const PRect rects, INT count)
{
	return GdipDrawRectanglesI(graphics, pen, rects, count);
}

FORCEINLINE
Status GraphicsDrawEllipseF(PGpGraphics graphics, const PGpPen pen,
	REAL x, REAL y, REAL width, REAL height)
{
	return GdipDrawEllipse(graphics, pen, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawEllipse(PGpGraphics graphics, const PGpPen pen,
	INT x, INT y, INT width, INT height)
{
	return GdipDrawEllipseI(graphics, pen, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawPieF(PGpGraphics graphics, const PGpPen pen,
	REAL x, REAL y, REAL width, REAL height, REAL startAngle, REAL sweepAngle)
{
	return GdipDrawPie(graphics, pen, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsDrawPie(PGpGraphics graphics, const PGpPen pen,
	INT x, INT y, INT width, INT height, REAL startAngle, REAL sweepAngle)
{
	return GdipDrawPieI(graphics, pen, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsDrawPolygonF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count)
{
	return GdipDrawPolygon(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawPolygon(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count)
{
	return GdipDrawPolygonI(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawPath(PGpGraphics graphics, const PGpPen pen, const PGpPath path)
{
	return GdipDrawPath(graphics, pen, path);
}

FORCEINLINE
Status GraphicsDrawCurveF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count)
{
	return GdipDrawCurve(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawCurve(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count)
{
	return GdipDrawCurveI(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawCurveTensionF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count, REAL tension)
{
	return GdipDrawCurve2(graphics, pen, points, count, tension);
}

FORCEINLINE
Status GraphicsDrawCurveTension(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count, REAL tension)
{
	return GdipDrawCurve2I(graphics, pen, points, count, tension);
}

FORCEINLINE
Status GraphicsDrawCurveNumBerF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count, INT offset, INT numberOfSegments, REAL tension)
{
	return GdipDrawCurve3(graphics, pen, points, count, offset, numberOfSegments, tension);
}

FORCEINLINE
Status GraphicsDrawCurveNumBer(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count, INT offset, INT numberOfSegments, REAL tension)
{
	return GdipDrawCurve3I(graphics, pen, points, count, offset, numberOfSegments, tension);
}

FORCEINLINE
Status GraphicsDrawClosedCurveF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count)
{
	return GdipDrawClosedCurve(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawClosedCurve(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count)
{
	return GdipDrawClosedCurveI(graphics, pen, points, count);
}

FORCEINLINE
Status GraphicsDrawClosedCurveTensionF(PGpGraphics graphics, const PGpPen pen,
	const PPointF points, INT count, REAL tension)
{
	return GdipDrawClosedCurve2(graphics, pen, points, count, tension);
}

FORCEINLINE
Status GraphicsDrawClosedCurveTension(PGpGraphics graphics, const PGpPen pen,
	const PPoint points, INT count, REAL tension)
{
	return GdipDrawClosedCurve2I(graphics, pen, points, count, tension);
}

FORCEINLINE
Status GraphicsClear(PGpGraphics graphics, ARGB color)
{
	return GdipGraphicsClear(graphics, color);
}

FORCEINLINE
Status GraphicsFillRectangleF(PGpGraphics graphics, const PGpBrush brush,
	REAL x, REAL y, REAL width, REAL height)
{
	return GdipFillRectangle(graphics, brush, x, y, width, height);
}

FORCEINLINE
Status GraphicsFillRectangle(PGpGraphics graphics, const PGpBrush brush,
	INT x, INT y, INT width, INT height)
{
	return GdipFillRectangleI(graphics, brush, x, y, width, height);
}

FORCEINLINE
Status GraphicsFillRectanglesF(PGpGraphics graphics, const PGpBrush brush,
	const PRectF rects, INT count)
{
	return GdipFillRectangles(graphics, brush, rects, count);
}

FORCEINLINE
Status GraphicsFillRectangles(PGpGraphics graphics, const PGpBrush brush,
	const PRect rects, INT count)
{
	return GdipFillRectanglesI(graphics, brush, rects, count);
}

/* default fillMode = FillModeAlternate */
FORCEINLINE
Status GraphicsFillPolygonF(PGpGraphics graphics, const PGpBrush brush,
	const PPointF points, INT count, FillMode fillMode)
{
	return GdipFillPolygon(graphics, brush, points, count, fillMode);
}

FORCEINLINE
Status GraphicsFillPolygon(PGpGraphics graphics, const PGpBrush brush,
	const PPoint points, INT count, FillMode fillMode)
{
	return GdipFillPolygonI(graphics, brush, points, count, fillMode);
}

FORCEINLINE
Status GraphicsFillEllipseF(PGpGraphics graphics, const PGpBrush brush,
	REAL x, REAL y, REAL width, REAL height)
{
	return GdipFillEllipse(graphics, brush, x, y, width, height);
}

FORCEINLINE
Status GraphicsFillEllipse(PGpGraphics graphics, const PGpBrush brush,
	INT x, INT y, INT width, INT height)
{
	return GdipFillEllipseI(graphics, brush, x, y, width, height);
}

FORCEINLINE
Status GraphicsFillPieF(PGpGraphics graphics, const PGpBrush brush,
	REAL x, REAL y, REAL width, REAL height, REAL startAngle, REAL sweepAngle)
{
	return GdipFillPie(graphics, brush, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsFillPie(PGpGraphics graphics, const PGpBrush brush,
	INT x, INT y, INT width, INT height, REAL startAngle, REAL sweepAngle)
{
	return GdipFillPieI(graphics, brush, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status GraphicsFillPath(PGpGraphics graphics, const PGpBrush brush, PGpPath path)
{
	return GdipFillPath(graphics, brush, path);
}

FORCEINLINE
Status GraphicsFillClosedCurveF(PGpGraphics graphics,
	const PGpBrush brush, const PPointF points, INT count)
{
	return GdipFillClosedCurve(graphics, brush, points, count);
}

FORCEINLINE
Status GraphicsFillClosedCurve(PGpGraphics graphics,
	const PGpBrush brush, const PPoint points, INT count)
{
	return GdipFillClosedCurveI(graphics, brush, points, count);
}

FORCEINLINE
Status GraphicsFillClosedCurveTensionF(PGpGraphics graphics, const PGpBrush brush,
	const PPointF points, INT count, FillMode fillMode, REAL tension)
{
	return GdipFillClosedCurve2(graphics, brush, points, count, tension, fillMode);
}

FORCEINLINE
Status GraphicsFillClosedCurveTension(PGpGraphics graphics, const PGpBrush brush,
	const PPoint points, INT count, FillMode fillMode, REAL tension)
{
	return GdipFillClosedCurve2I(graphics, brush, points, count, tension, fillMode);
}

FORCEINLINE
Status GraphicsFillRegion(PGpGraphics graphics, const PGpBrush brush, const PGpRegion region)
{
	return GdipFillRegion(graphics, brush, region);
}

FORCEINLINE
Status GraphicsDrawStringXY(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, const PGpBrush brush, REAL x, REAL y)
{
	RectF rect;
	rect = MakeRectF(x, y, 0.0f, 0.0f);
	return GdipDrawString(graphics, string, lstrlenW(string), font, &rect, NULL, brush);
}

FORCEINLINE
Status GraphicsDrawString(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, const PGpBrush brush,
	const PRectF layoutRect, const PGpStrFormat stringFormat)
{
	return GdipDrawString(graphics, string, lstrlenW(string),
		font, layoutRect, stringFormat, brush);
}

FORCEINLINE
Status GraphicsMeasureStringOrigin(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, REAL originX, REAL originY,
	const PGpStrFormat stringFormat, PRectF boundingBox)
{
	RectF layoutRect;
	layoutRect = MakeRectF(originX, originY, 0.0f, 0.0f);
	return GdipMeasureString(graphics, string, lstrlenW(string),
		font, &layoutRect, stringFormat, boundingBox, NULL, NULL);
}

FORCEINLINE
Status GraphicsMeasureStringSize(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, REAL width, REAL height,
	const PGpStrFormat stringFormat,
	PRectF boundingBox, INT *codepointsFitted, INT *linesFilled)
{
	RectF layoutRect;
	layoutRect = MakeRectF(0.0f, 0.0f, width, height);
	return GdipMeasureString(graphics, string, lstrlenW(string), font, &layoutRect,
		stringFormat, boundingBox, codepointsFitted, linesFilled);
}

FORCEINLINE
Status GraphicsMeasureString(PGpGraphics graphics,
	const WCHAR *string, const PGpFont font, PRectF boundingBox)
{
	return GraphicsMeasureStringSize(graphics, string,
		font, 0.0f, 0.0f, NULL, boundingBox, NULL, NULL);
}

FORCEINLINE
Status GraphicsMeasureStringRect(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, PRectF layoutRect,
	const PGpStrFormat stringFormat, PRectF boundingBox)
{
	return GdipMeasureString(graphics, string, lstrlenW(string),
		font, layoutRect, stringFormat, boundingBox, NULL, NULL);
}

FORCEINLINE
Status GraphicsMeasureCharacterRanges(PGpGraphics graphics, const WCHAR *string,
	const PGpFont font, const PRectF layoutRect,
	const PGpStrFormat stringFormat, INT regionCount, PGpRegion *regions)
{
	return GdipMeasureCharacterRanges(graphics, string, lstrlenW(string), font,
		layoutRect, stringFormat, regionCount, regions);
}

FORCEINLINE
Status GraphicsDrawDriverString(PGpGraphics graphics, const UINT16 *text,
	INT length, const PGpFont font, const PGpBrush brush,
	const PPointF positions, INT flags, const PGpMatrix matrix)
{
	return GdipDrawDriverString(graphics, text, length, font, brush,
		positions, flags, matrix);
}

FORCEINLINE
Status GraphicsMeasureDriverString(PGpGraphics graphics, const UINT16 *text,
	INT length, const PGpFont font, const PPointF positions,
	INT flags, const PGpMatrix matrix, PRectF boundingBox)
{
	return GdipMeasureDriverString(graphics, text, length, font,
		positions, flags, matrix, boundingBox);
}

    // Draw a cached bitmap on this graphics destination offset by
    // x, y. Note this will fail with WrongState if the CachedBitmap
    // native format differs from this Graphics.

FORCEINLINE
Status GraphicsDrawCachedBitmap(PGpGraphics graphics, PGpCachedBitmap cb, INT x, INT y)
{
	return GdipDrawCachedBitmap(graphics, cb, x, y);
}

FORCEINLINE
Status GraphicsDrawImageXYF(PGpGraphics graphics, PGpImage image, REAL x, REAL y)
{
	return GdipDrawImage(graphics, image, x, y);
}

FORCEINLINE
Status GraphicsDrawImageXY(PGpGraphics graphics, PGpImage image, INT x, INT y)
{
	return GdipDrawImageI(graphics, image, x, y);
}

FORCEINLINE
Status GraphicsDrawImageF(PGpGraphics graphics, PGpImage image,
	REAL x, REAL y, REAL width, REAL height)
{
	return GdipDrawImageRect(graphics, image, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawImage(PGpGraphics graphics, PGpImage image,
	INT x, INT y, INT width, INT height)
{
	return GdipDrawImageRectI(graphics, image, x, y, width, height);
}

FORCEINLINE
Status GraphicsDrawImagePointsF(PGpGraphics graphics, PGpImage image,
	const PPointF destPoints, INT count)
{
	if (count != 3 && count != 4)
		return InvalidParameter;
	return GdipDrawImagePoints(graphics, image, destPoints, count);
}

FORCEINLINE
Status GraphicsDrawImagePoints(PGpGraphics graphics, PGpImage image,
	const PPoint destPoints, INT count)
{
	if (count != 3 && count != 4)
		return InvalidParameter;
	return GdipDrawImagePointsI(graphics, image, destPoints, count);
}

FORCEINLINE
Status GraphicsDrawImageRectXYF(PGpGraphics graphics, PGpImage image,
	REAL x, REAL y, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, IN Unit srcUnit)
{
	return GdipDrawImagePointRect(graphics, image,
		x, y, srcx, srcy, srcwidth, srcheight, srcUnit);
}

FORCEINLINE
Status GraphicsDrawImageRectXY(PGpGraphics graphics, PGpImage image,
	INT x, INT y, INT srcx, INT srcy, INT srcwidth, INT srcheight, IN Unit srcUnit)
{
	return GdipDrawImagePointRectI(graphics, image,
		x, y, srcx, srcy, srcwidth, srcheight, srcUnit);
}

FORCEINLINE
Status GraphicsDrawImageAbortF(PGpGraphics graphics, PGpImage image,
	const PRectF destRect, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight,
	Unit srcUnit, PGpImageAttr imageAttributes,
	DrawImageAbort callback, VOID* callbackData)
{
	return GdipDrawImageRectRect(graphics, image,
		destRect->X, destRect->Y, destRect->Width, destRect->Height,
		srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData);
}

FORCEINLINE
Status GraphicsDrawImageAbort(PGpGraphics graphics, PGpImage image,
	const PRect destRect, INT srcx, INT srcy, INT srcwidth, INT srcheight,
	Unit srcUnit, const PGpImageAttr imageAttributes,
	DrawImageAbort callback, VOID* callbackData)
{
	return GdipDrawImageRectRectI(graphics, image,
		destRect->X, destRect->Y, destRect->Width, destRect->Height,
		srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData);
}

FORCEINLINE
Status GraphicsDrawImageRectRectF(PGpGraphics graphics, PGpImage image,
	const PRectF destRect, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight,
	Unit srcUnit, const PGpImageAttr imageAttributes)
{
	return GraphicsDrawImageAbortF(graphics, image, destRect, srcx, srcy,
		srcwidth, srcheight, srcUnit, imageAttributes, NULL, NULL);
}

FORCEINLINE
Status GraphicsDrawImageRectRect(PGpGraphics graphics, PGpImage image,
	const PRect destRect, INT srcx, INT srcy, INT srcwidth, INT srcheight,
	Unit srcUnit, const PGpImageAttr ImageAttributes)
{
	return GraphicsDrawImageAbort(graphics, image, destRect, srcx, srcy,
		srcwidth, srcheight, srcUnit, ImageAttributes, NULL, NULL);
}

FORCEINLINE
Status GraphicsDrawImagePointsAbortF(PGpGraphics graphics, PGpImage image,
	const PPointF destPoints, INT count,
	REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, Unit srcUnit,
	const PGpImageAttr imageAttributes,
	DrawImageAbort callback, VOID* callbackData)
{
	return GdipDrawImagePointsRect(graphics, image, destPoints, count,
		srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData);
}

FORCEINLINE
Status GraphicsDrawImagePointsAbort(PGpGraphics graphics, PGpImage image,
	const PPoint destPoints, INT count,
	INT srcx, INT srcy, INT srcwidth, INT srcheight, Unit srcUnit,
	const PGpImageAttr imageAttributes,
	DrawImageAbort callback, VOID* callbackData)
{
	return GdipDrawImagePointsRectI(graphics, image, destPoints, count,
		srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData);
}

	// The following methods are for playing an EMF+ to a graphics
	// via the enumeration interface.  Each record of the EMF+ is
	// sent to the callback (along with the callbackData).  Then
	// the callback can invoke the Metafile::PlayRecord method
	// to play the particular record.

FORCEINLINE
Status GraphicsEnumerateMetafileF(PGpGraphics graphics, const PGpMetafile metafile,
	const PPointF destPoint, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestPoint(graphics, metafile, destPoint,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafile(PGpGraphics graphics, const PGpMetafile metafile,
	const PPoint destPoint, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestPointI(graphics, metafile, destPoint,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafileRectF(PGpGraphics graphics, const PGpMetafile metafile,
	const PRectF destRect, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestRect(graphics, metafile, destRect,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafileRect(PGpGraphics graphics, const PGpMetafile metafile,
	const PRect destRect, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestRectI(graphics, metafile, destRect,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePointsF(PGpGraphics graphics, const PGpMetafile metafile,
	const PPointF destPoints, INT count, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestPoints(graphics, metafile, destPoints, count,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePoints(PGpGraphics graphics, const PGpMetafile metafile,
	const PPoint destPoints, INT count, EnumerateMetafileProc callback,
	VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileDestPointsI(graphics, metafile, destPoints, count,
		callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePointRectF(PGpGraphics graphics, const PGpMetafile metafile,
	const PPointF destPoint, const PRectF srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestPoint(graphics, metafile, destPoint,
		srcRect, srcUnit, callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePointRect(PGpGraphics graphics, const PGpMetafile metafile,
	const PPoint destPoint, const PRect srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestPointI(graphics, metafile, destPoint,
		srcRect, srcUnit, callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafileRectRectF(PGpGraphics graphics, const PGpMetafile metafile,
	const PRectF destRect, const PRectF srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestRect(graphics, metafile, destRect,
		srcRect, srcUnit, callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafileRectRect(PGpGraphics graphics, const PGpMetafile metafile,
	const PRect destRect, const PRect srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestRectI(graphics, metafile, destRect,
		srcRect, srcUnit, callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePointsRectF(PGpGraphics graphics, const PGpMetafile metafile,
	const PPointF destPoints, INT count, const PRectF srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestPoints(graphics, metafile, destPoints,
		count, srcRect, srcUnit, callback, callbackData, imageAttributes);
}

FORCEINLINE
Status GraphicsEnumerateMetafilePointsRect(PGpGraphics graphics, const PGpMetafile metafile,
	const PPoint destPoints, INT count, const PRect srcRect, Unit srcUnit,
	EnumerateMetafileProc callback, VOID* callbackData, const PGpImageAttr imageAttributes)
{
	return GdipEnumerateMetafileSrcRectDestPointsI(graphics, metafile, destPoints,
		count, srcRect, srcUnit, callback, callbackData, imageAttributes);
}

/* All default combineMode = CombineModeReplace */

FORCEINLINE
Status GraphicsSetClipGraphics(PGpGraphics graphics,
	const PGpGraphics g, CombineMode combineMode)
{
	return GdipSetClipGraphics(graphics, g, combineMode);
}

FORCEINLINE
Status GraphicsSetClipRectF(PGpGraphics graphics,
	const PRectF rect, CombineMode combineMode)
{
	return GdipSetClipRect(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, combineMode);
}

FORCEINLINE
Status GraphicsSetClipRect(PGpGraphics graphics,
	const PRect rect, CombineMode combineMode)
{
	return GdipSetClipRectI(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, combineMode);
}

FORCEINLINE
Status GraphicsSetClipPath(PGpGraphics graphics,
	const PGpPath path, CombineMode combineMode)
{
	return GdipSetClipPath(graphics, path, combineMode);
}

FORCEINLINE
Status GraphicsSetClipRegion(PGpGraphics graphics,
	const PGpRegion region, CombineMode combineMode)
{
	return GdipSetClipRegion(graphics, region, combineMode);
}

    // This is different than the other SetClip methods because it assumes
    // that the HRGN is already in device units, so it doesn't transform
    // the coordinates in the HRGN.

FORCEINLINE
Status GraphicsSetClipHRGN(PGpGraphics graphics, HRGN hRgn, CombineMode combineMode)
{
	return GdipSetClipHrgn(graphics, hRgn, combineMode);
}

FORCEINLINE
Status GraphicsIntersectClipRectF(PGpGraphics graphics, const PRectF rect)
{
	return GdipSetClipRect(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, CombineModeIntersect);
}

FORCEINLINE
Status GraphicsIntersectClipRect(PGpGraphics graphics, const PRect rect)
{
	return GdipSetClipRectI(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, CombineModeIntersect);
}

FORCEINLINE
Status GraphicsIntersectClipRegion(PGpGraphics graphics, const PGpRegion region)
{
	return GdipSetClipRegion(graphics, region, CombineModeIntersect);
}

FORCEINLINE
Status GraphicsExcludeClipRectF(PGpGraphics graphics, const PRectF rect)
{
	return GdipSetClipRect(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, CombineModeExclude);
}

FORCEINLINE
Status GraphicsExcludeClipRect(PGpGraphics graphics, const PRect rect)
{
	return GdipSetClipRectI(graphics,
		rect->X, rect->Y, rect->Width, rect->Height, CombineModeExclude);
}

FORCEINLINE
Status GraphicsExcludeClipRegion(PGpGraphics graphics, const PGpRegion region)
{
	return GdipSetClipRegion(graphics, region, CombineModeExclude);
}

FORCEINLINE
Status GraphicsResetClip(PGpGraphics graphics)
{
	return GdipResetClip(graphics);
}

FORCEINLINE
Status GraphicsTranslateClipF(PGpGraphics graphics, REAL dx, REAL dy)
{
	return GdipTranslateClip(graphics, dx, dy);
}

FORCEINLINE
Status GraphicsTranslateClip(PGpGraphics graphics, INT dx, INT dy)
{
	return GdipTranslateClipI(graphics, dx, dy);
}

FORCEINLINE
Status GraphicsGetClip(PGpGraphics graphics, PGpRegion region)
{
	return GdipGetClip(graphics, region);
}

FORCEINLINE
Status GraphicsGetClipBoundsF(PGpGraphics graphics, PRectF rect)
{
	return GdipGetClipBounds(graphics, rect);
}

FORCEINLINE
Status GraphicsGetClipBounds(PGpGraphics graphics, PRect rect)
{
	return GdipGetClipBoundsI(graphics, rect);
}

FORCEINLINE
BOOL GraphicsIsClipEmpty(PGpGraphics graphics)
{
	BOOL value;
	return GdipIsClipEmpty(graphics, &value) == Ok? value : FALSE;
}

FORCEINLINE
Status GraphicsGetVisibleClipBoundsF(PGpGraphics graphics, PRectF rect)
{
	return GdipGetVisibleClipBounds(graphics, rect);
}

FORCEINLINE
Status GraphicsGetVisibleClipBounds(PGpGraphics graphics, PRect rect)
{
	return GdipGetVisibleClipBoundsI(graphics, rect);
}

FORCEINLINE
BOOL GraphicsIsVisibleClipEmpty(PGpGraphics graphics)
{
	BOOL value;
	return GdipIsVisibleClipEmpty(graphics, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL GraphicsIsVisible(PGpGraphics graphics, INT x, INT y)
{
	BOOL value;
	return GdipIsVisiblePointI(graphics, x, y, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL GraphicsIsVisibleBounds(PGpGraphics graphics, INT x, INT y, INT width, INT height)
{
	BOOL value;
	return GdipIsVisibleRectI(graphics, x, y, width, height, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL GraphicsIsVisibleF(PGpGraphics graphics, REAL x, REAL y)
{
	BOOL value;
	return GdipIsVisiblePoint(graphics, x, y, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL GraphicsIsVisibleBoundsF(PGpGraphics graphics, REAL x, REAL y, REAL width, REAL height)
{
	BOOL value;
	return GdipIsVisibleRect(graphics, x, y, width, height, &value) == Ok? value : FALSE;
}

FORCEINLINE
GraphicsState GraphicsSave(PGpGraphics graphics)
{
	GraphicsState state;
	GdipSaveGraphics(graphics, &state);
	return state;
}

FORCEINLINE
Status GraphicsRestore(PGpGraphics graphics, GraphicsState gstate)
{
	return GdipRestoreGraphics(graphics, gstate);
}

FORCEINLINE
GraphicsContainer GraphicsBeginContainerRectF(PGpGraphics graphics,
	const PRectF dstrect, const PRectF srcrect, Unit unit)
{
	GraphicsContainer value;
	GdipBeginContainer(graphics, dstrect, srcrect, unit, &value);
	return value;
}

FORCEINLINE
GraphicsContainer GraphicsBeginContainerRect(PGpGraphics graphics,
	const PRect dstrect, const PRect srcrect, Unit unit)
{
	GraphicsContainer value;
	GdipBeginContainerI(graphics, dstrect, srcrect, unit, &value);
	return value;
}

FORCEINLINE
GraphicsContainer GraphicsBeginContainer(PGpGraphics graphics)
{
	GraphicsContainer value;
	GdipBeginContainer2(graphics, &value);
	return value;
}

FORCEINLINE
Status GraphicsEndContainer(PGpGraphics graphics, GraphicsContainer state)
{
	return GdipEndContainer(graphics, state);
}

	// Only valid when recording metafiles.
FORCEINLINE
Status GraphicsAddMetafileComment(PGpGraphics graphics,
	const BYTE* data, UINT sizeData)
{
	return GdipComment(graphics, sizeData, data);
}

FORCEINLINE
HPALETTE GraphicsGetHalftonePalette(VOID)
{
	return GdipCreateHalftonePalette();
}

#endif

