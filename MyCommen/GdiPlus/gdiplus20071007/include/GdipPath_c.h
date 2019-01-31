/**************************************************************************\
*
* Module Name:
*
*   GdipPath_c.h
*
* Abstract:
*
*   GDI+ Graphics Path function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPPATH_C_H
#define __GDIPPATH_C_H

/* All default fillMode = FillModeAlternate */
FORCEINLINE
PGpPath	PathFromFillMode(FillMode fillMode)
{
    PGpPath path;
	return GdipCreatePath(fillMode, &path) == Ok? path : NULL;
}

FORCEINLINE
PGpPath	PathCreate(VOID)
{
	return PathFromFillMode(FillModeAlternate);
}

FORCEINLINE
PGpPath	PathFromDataF(const PPointF points, const BYTE* types, INT count, FillMode fillMode)
{
    PGpPath path;
	return GdipCreatePath2(points, types, count, fillMode, &path) == Ok? path : NULL;
}

FORCEINLINE
PGpPath	PathFromData(const PPoint points, const BYTE* types, INT count, FillMode fillMode)
{
    PGpPath path;
	return GdipCreatePath2I(points, types, count, fillMode, &path) == Ok? path : NULL;
}

FORCEINLINE
Status PathDelete(PGpPath path)
{
	return GdipDeletePath(path);
}

FORCEINLINE
PGpPath	PathClone(const PGpPath source)
{
    PGpPath path;
	return GdipClonePath(source, &path) == Ok? path : NULL;
}

	// Reset the path object to empty (and fill mode to FillModeAlternate)

FORCEINLINE
Status PathReset(PGpPath path)
{
	return GdipResetPath(path);
}

FORCEINLINE
FillMode PathGetFillMode(PGpPath path)
{
	FillMode fillMode;
	return GdipGetPathFillMode(path, &fillMode) == Ok? fillMode : FillModeAlternate;
}

FORCEINLINE
Status PathSetFillMode(PGpPath path, FillMode fillmode)
{
	return GdipSetPathFillMode(path, fillmode);
}

/* 返回路径数据结构指针，出错返回NULL。用户不必处理返回指针的内存
   注意：每次调用原数据结构内容会被覆盖，如需保留原数据则应作拷贝 */
FORCEINLINE
PPathData PathGetPathData(PGpPath path)
{
	PPathData data;
	INT count;
	GdipGetPointCount(path, &count);
	if ((data = AllocPathData(count)) == NULL)
		return NULL;
	if (count <= 0) return data;
	return GdipGetPathData(path, data) == Ok? data : NULL;
}

FORCEINLINE
Status PathStartFigure(PGpPath path)
{
	return GdipStartPathFigure(path);
}

FORCEINLINE
Status PathCloseFigure(PGpPath path)
{
	return GdipClosePathFigure(path);
}

FORCEINLINE
Status PathCloseAllFigures(PGpPath path)
{
	return GdipClosePathFigures(path);
}

FORCEINLINE
Status PathSetMarker(PGpPath path)
{
	return GdipSetPathMarker(path);
}

FORCEINLINE
Status PathClearMarkers(PGpPath path)
{
	return GdipClearPathMarkers(path);
}

FORCEINLINE
Status PathReverse(PGpPath path)
{
	return GdipReversePath(path);
}

FORCEINLINE
Status PathGetLastPoint(PGpPath path, PPointF lastPoint)
{
	return GdipGetPathLastPoint(path, lastPoint);
}

FORCEINLINE
Status PathAddLineF(PGpPath path, IN REAL x1, REAL y1, REAL x2, REAL y2)
{
	return GdipAddPathLine(path, x1, y1, x2, y2);
}

FORCEINLINE
Status PathAddLinesF(PGpPath path, const PPointF points, INT count)
{
	return GdipAddPathLine2(path, points, count);
}

FORCEINLINE
Status PathAddLine(PGpPath path, INT x1, INT y1, INT x2, INT y2)
{
	return GdipAddPathLineI(path, x1, y1, x2, y2);
}

FORCEINLINE
Status PathAddLines(PGpPath path, const PPoint points, INT count)
{
	return GdipAddPathLine2I(path, points, count);
}

FORCEINLINE
Status PathAddArcF(PGpPath path, REAL x, REAL y,
	REAL width, REAL height, REAL startAngle, REAL sweepAngle)
{
	return GdipAddPathArc(path, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status PathAddArc(PGpPath path, INT x, INT y,
	INT width, INT height, REAL startAngle, REAL sweepAngle)
{
	return GdipAddPathArcI(path, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status PathAddBezierF(PGpPath path, REAL x1, REAL y1, REAL x2, REAL y2,
	REAL x3, REAL y3, REAL x4, REAL y4)
{
	return GdipAddPathBezier(path, x1, y1, x2, y2, x3, y3, x4, y4);
}

FORCEINLINE
Status PathAddBeziersF(PGpPath path, const PPointF points, INT count)
{
	return GdipAddPathBeziers(path, points, count);
}

FORCEINLINE
Status PathAddBezier(PGpPath path, INT x1, INT y1, INT x2, INT y2,
	INT x3, INT y3, INT x4, INT y4)
{
	return GdipAddPathBezierI(path, x1, y1, x2, y2, x3, y3, x4, y4);
}

FORCEINLINE
Status PathAddBeziers(PGpPath path, const PPoint points, INT count)
{
	return GdipAddPathBeziersI(path, points, count);
}

FORCEINLINE
Status PathAddCurveF(PGpPath path, const PPointF points, INT count)
{
	return GdipAddPathCurve(path, points, count);
}

FORCEINLINE
Status PathAddCurveTensionF(PGpPath path, const PPointF points, INT count, REAL tension)
{
	return GdipAddPathCurve2(path, points, count, tension);
}

FORCEINLINE
Status PathAddCurveNumberF(PGpPath path, const PPointF points, INT count,
	INT offset, INT numberOfSegments, REAL tension)
{
	return GdipAddPathCurve3(path, points, count, offset, numberOfSegments, tension);
}

FORCEINLINE
Status PathAddCurve(PGpPath path, const PPoint points, INT count)
{
	return GdipAddPathCurveI(path, points, count);
}

FORCEINLINE
Status PathAddCurveTension(PGpPath path, const PPoint points, INT count, REAL tension)
{
	return GdipAddPathCurve2I(path, points, count, tension);
}

FORCEINLINE
Status PathAddCurveNumber(PGpPath path, const PPoint points, INT count,
	INT offset, INT numberOfSegments, REAL tension)
{
	return GdipAddPathCurve3I(path, points, count, offset, numberOfSegments, tension);
}

FORCEINLINE
Status PathAddClosedCurveF(PGpPath path, const PPointF points, INT count)
{
	return GdipAddPathClosedCurve(path, points, count);
}

FORCEINLINE
Status PathAddClosedCurveTensionF(PGpPath path, const PPointF points, INT count, REAL tension)
{
	return GdipAddPathClosedCurve2(path, points, count, tension);
}

FORCEINLINE
Status PathAddClosedCurve(PGpPath path, const PPoint points, INT count)
{
	return GdipAddPathClosedCurveI(path, points, count);
}

FORCEINLINE
Status PathAddClosedCurveTension(PGpPath path, const PPoint points, INT count, REAL tension)
{
	return GdipAddPathClosedCurve2I(path, points, count, tension);
}

FORCEINLINE
Status PathAddRectangleF(PGpPath path, REAL x, REAL y, REAL width, REAL height)
{
	return GdipAddPathRectangle(path, x, y, width, height);
}

FORCEINLINE
Status PathAddRectanglesF(PGpPath path, const PRectF rects, INT count)
{
	return GdipAddPathRectangles(path, rects, count);
}

FORCEINLINE
Status PathAddRectangle(PGpPath path, INT x, INT y, INT width, INT height)
{
	return GdipAddPathRectangleI(path, x, y, width, height);
}

FORCEINLINE
Status PathAddRectangles(PGpPath path, const PRect rects, INT count)
{
	return GdipAddPathRectanglesI(path, rects, count);
}

FORCEINLINE
Status PathAddEllipseF(PGpPath path, REAL x, REAL y, REAL width, REAL height)
{
	return GdipAddPathEllipse(path, x, y, width, height);
}

FORCEINLINE
Status PathAddEllipse(PGpPath path, INT x, INT y, INT width, INT height)
{
	return GdipAddPathEllipseI(path, x, y, width, height);
}

FORCEINLINE
Status PathAddPieF(PGpPath path, IN REAL x, REAL y,
	REAL width, REAL height, REAL startAngle, REAL sweepAngle)
{
	return GdipAddPathPie(path, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status PathAddPie(PGpPath path, INT x, INT y,
	INT width, INT height, REAL startAngle, REAL sweepAngle)
{
	return GdipAddPathPieI(path, x, y, width, height, startAngle, sweepAngle);
}

FORCEINLINE
Status PathAddPolygonF(PGpPath path, const PPointF points, INT count)
{
	return GdipAddPathPolygon(path, points, count);
}

FORCEINLINE
Status PathAddPolygon(PGpPath path, const PPoint points, INT count)
{
	return GdipAddPathPolygonI(path, points, count);
}

FORCEINLINE
Status PathAddPath(PGpPath path, const PGpPath addingPath, BOOL connect)
{
	return GdipAddPathPath(path, addingPath, connect);
}

FORCEINLINE
Status PathAddStringF(PGpPath path, const WCHAR *string,
	const PGpFontFamily family, INT style, REAL emSize,
	const PRectF layoutRect, const PGpStrFormat format)
{
	return GdipAddPathString(path, string, lstrlenW(string),
		family, style, emSize, layoutRect, format);
}

FORCEINLINE
Status PathAddString(PGpPath path, const WCHAR *string,
	const PGpFontFamily family, INT style, REAL emSize,
	const PRect layoutRect, const PGpStrFormat format)
{
	return GdipAddPathStringI(path, string, lstrlenW(string),
		family, style, emSize, layoutRect, format);
}

FORCEINLINE
Status PathTransform(PGpPath path, const PGpMatrix matrix)
{
	return GdipTransformPath(path, matrix);
}

    // This is not always the tightest bounds.

FORCEINLINE
Status PathGetBoundsF(PGpPath path, PRectF bounds, const PGpMatrix matrix, const PGpPen pen)
{
	return GdipGetPathWorldBounds(path, bounds, matrix, pen);
}

FORCEINLINE
Status PathGetBounds(PGpPath path, PRect bounds, const PGpMatrix matrix, const PGpPen pen)
{
	return GdipGetPathWorldBoundsI(path, bounds, matrix, pen);
}

    // Once flattened, the resultant path is made of line segments and
    // the original path information is lost.  When matrix is NULL the
    // identity matrix is assumed.

/* default flatness = FlatnessDefault */
FORCEINLINE
Status PathFlatten(PGpPath path, const PGpMatrix matrix, REAL flatness)
{
	return GdipFlattenPath(path, matrix, flatness);
}

FORCEINLINE
Status PathWiden(PGpPath path, const PGpPen pen, const PGpMatrix matrix, REAL flatness)
{
	return GdipWidenPath(path, pen, matrix, flatness);
}

FORCEINLINE
Status PathOutline(PGpPath path, PGpMatrix matrix, REAL flatness)
{
	return GdipWindingModeOutline(path, matrix, flatness);
}
    
    // Once this is called, the resultant path is made of line segments and
    // the original path information is lost.  When matrix is NULL, the 
    // identity matrix is assumed.

/* default warpMode = WarpModePerspective */
FORCEINLINE
Status PathWarp(PGpPath path, const PPointF destPoints, INT count,
	const PRectF srcRect, const PGpMatrix matrix, WarpMode warpMode, REAL flatness)
{
	return GdipWarpPath(path, matrix, destPoints, count,
		srcRect->X, srcRect->Y, srcRect->Width, srcRect->Height, warpMode, flatness);
}

FORCEINLINE
INT PathGetPointCount(PGpPath path)
{
	INT count;
	return GdipGetPointCount(path, &count) == Ok? count : 0;
}

/*  没写GetPathTypes和GetPathPoints函数，其功能可使用PathGetPathData */

FORCEINLINE
BOOL PathIsVisibleF(PGpPath path, REAL x, REAL y, PGpGraphics g)
{
	BOOL value;
	return GdipIsVisiblePathPoint(path, x, y, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL PathIsVisible(PGpPath path, INT x, INT y, PGpGraphics g)
{
	BOOL value;
	return GdipIsVisiblePathPointI(path, x, y, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL PathIsOutlineVisibleF(PGpPath path, REAL x, REAL y, const PGpPen pen, const PGpGraphics g)
{
	BOOL value;
	return GdipIsOutlineVisiblePathPoint(path, x, y, pen, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL PathIsOutlineVisible(PGpPath path, INT x, INT y, const PGpPen pen, const PGpGraphics g)
{
	BOOL value;
	return GdipIsOutlineVisiblePathPointI(path, x, y, pen, g, &value) == Ok? value : FALSE;
}

//--------------------------------------------------------------------------
// GraphisPathIterator class
//--------------------------------------------------------------------------

FORCEINLINE
PGpPathIterator PathIteratorCreate(const PGpPath path)
{
    PGpPathIterator iterator;
	return GdipCreatePathIter(&iterator, path) == Ok? iterator : NULL;
}

FORCEINLINE
Status PathIteratorDelete(PGpPathIterator iterator)
{
	return GdipDeletePathIter(iterator);
}

FORCEINLINE
INT PathIteratorNextSub(PGpPathIterator iterator,
	INT* startIndex, INT* endIndex, BOOL* isClosed)
{
	INT count;
	return GdipPathIterNextSubpath(iterator, &count,
		startIndex, endIndex, isClosed) == Ok? count : 0;
}

FORCEINLINE
INT PathIteratorNextSubpath(PGpPathIterator iterator, const PGpPath path, BOOL* isClosed)
{
	INT count;
	return GdipPathIterNextSubpathPath(iterator, &count,
		path, isClosed) == Ok? count : 0;
}

FORCEINLINE
INT PathIteratorNextPathType(PGpPathIterator iterator,
	BYTE* pathType, INT* startIndex, INT* endIndex)
{
	INT count;
	return GdipPathIterNextPathType(iterator, &count,
		pathType, startIndex, endIndex) == Ok? count : 0;
}

FORCEINLINE
INT PathIteratorNextMarker(PGpPathIterator iterator, INT* startIndex, INT* endIndex)
{
	INT count;
	return GdipPathIterNextMarker(iterator, &count,
		startIndex, endIndex) == Ok? count : 0;
}


FORCEINLINE
INT PathIteratorNextMarkerPath(PGpPathIterator iterator, PGpPath path)
{
	INT count;
	return GdipPathIterNextMarkerPath(iterator, &count, path) == Ok? count : 0;
}

FORCEINLINE
INT PathIteratorGetCount(PGpPathIterator iterator)
{
	INT count;
	return GdipPathIterGetCount(iterator, &count) == Ok? count : 0;
}

FORCEINLINE
INT PathIteratorGetSubpathCount(PGpPathIterator iterator)
{
	INT count;
	return GdipPathIterGetSubpathCount(iterator, &count) == Ok? count : 0;
}

FORCEINLINE
BOOL PathIteratorHasCurve(PGpPathIterator iterator)
{
	BOOL value;
	return GdipPathIterHasCurve(iterator, &value) == Ok? value : FALSE;
}

FORCEINLINE
Status PathIteratorRewind(PGpPathIterator iterator)
{
	return GdipPathIterRewind(iterator);
}

FORCEINLINE
INT PathIteratorEnumerate(PGpPathIterator iterator,
	PPointF points, BYTE *types, INT count)
{
	INT _count;
	return GdipPathIterEnumerate(iterator, &_count,
		points, types, count) == Ok? _count : 0;
}

FORCEINLINE
INT PathIteratorCopyData(PGpPathIterator iterator, PPointF points,
	BYTE* types, INT startIndex, INT endIndex)
{
	INT count;
	return GdipPathIterCopyData(iterator, &count,
		points, types, startIndex, endIndex) == Ok? count : 0;
}

#endif // !_GRAPHICSPATH_HPP

