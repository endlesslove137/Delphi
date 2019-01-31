/**************************************************************************\
*
* Module Name:
*
*   GdipRegion_c.h
*
* Abstract:
*
*   GDI+ Region function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPREGION_C_H
#define __GDIPREGION_C_H

FORCEINLINE
PGpRegion RegionCreate(VOID)
{
    PGpRegion region;
	return GdipCreateRegion(&region) == Ok? region : NULL;
}

FORCEINLINE
PGpRegion RegionFromRectF(const PRectF rect)
{
    PGpRegion region;
	return GdipCreateRegionRect(rect, &region) == Ok? region : NULL;
}

FORCEINLINE
PGpRegion RegionFromRect(const PRect rect)
{
    PGpRegion region;
	return GdipCreateRegionRectI(rect, &region) == Ok? region : NULL;
}

FORCEINLINE
PGpRegion RegionFromPath(const PGpPath path)
{
    PGpRegion region;
	return GdipCreateRegionPath(path, &region) == Ok? region : NULL;
}

FORCEINLINE
PGpRegion RegionFromData(const BYTE* regionData, INT size)
{
    PGpRegion region;
	return GdipCreateRegionRgnData(regionData, size, &region) == Ok?
		region : NULL;
}

FORCEINLINE
PGpRegion RegionFromHRGN(HRGN hRgn)
{
    PGpRegion region;
	return GdipCreateRegionHrgn(hRgn, &region) == Ok? region : NULL;
}

FORCEINLINE
Status RegionDelete(PGpRegion region)
{
	return GdipDeleteRegion(region);
}

FORCEINLINE
PGpRegion RegionClone(const PGpRegion source)
{
    PGpRegion region;
	return GdipCloneRegion(source, &region) == Ok? region : NULL;
}

FORCEINLINE
Status RegionMakeInfinite(PGpRegion region)
{
    return GdipSetInfinite(region);
}

FORCEINLINE
Status RegionMakeEmpty(PGpRegion region)
{
    return GdipSetEmpty(region);
}

FORCEINLINE
Status RegionIntersectRectF(PGpRegion region, const PRectF rect)
{
	return GdipCombineRegionRect(region, rect, CombineModeIntersect);
}

FORCEINLINE
Status RegionIntersectRect(PGpRegion region, const PRect rect)
{
	return GdipCombineRegionRectI(region, rect, CombineModeIntersect);
}

FORCEINLINE
Status RegionIntersectPath(PGpRegion region, const PGpPath path)
{
	return GdipCombineRegionPath(region, path, CombineModeIntersect);
}

FORCEINLINE
Status RegionIntersectRegion(PGpRegion region, const PGpPath region2)
{
	return GdipCombineRegionRegion(region, region2, CombineModeIntersect);
}

FORCEINLINE
Status RegionUnionRectF(PGpRegion region, const PRectF rect)
{
	return GdipCombineRegionRect(region, rect, CombineModeUnion);
}

FORCEINLINE
Status RegionUnionRect(PGpRegion region, const PRect rect)
{
	return GdipCombineRegionRectI(region, rect, CombineModeUnion);
}

FORCEINLINE
Status RegionUnionPath(PGpRegion region, const PGpPath path)
{
	return GdipCombineRegionPath(region, path, CombineModeUnion);
}

FORCEINLINE
Status RegionUnionRegion(PGpRegion region, const PGpRegion region2)
{
	return GdipCombineRegionRegion(region, region2, CombineModeUnion);
}

FORCEINLINE
Status RegionXorRectF(PGpRegion region, const PRectF rect)
{
	return GdipCombineRegionRect(region, rect, CombineModeXor);
}

FORCEINLINE
Status RegionXorRect(PGpRegion region, const PRect rect)
{
	return GdipCombineRegionRectI(region, rect, CombineModeXor);
}

FORCEINLINE
Status RegionXorPath(PGpRegion region, const PGpPath path)
{
	return GdipCombineRegionPath(region, path, CombineModeXor);
}

FORCEINLINE
Status RegionXorRegion(PGpRegion region, const PGpRegion region2)
{
	return GdipCombineRegionRegion(region, region2, CombineModeXor);
}

FORCEINLINE
Status RegionExcludeRectF(PGpRegion region, const PRectF rect)
{
	return GdipCombineRegionRect(region, rect, CombineModeExclude);
}

FORCEINLINE
Status RegionExcludeRect(PGpRegion region, const PRect rect)
{
	 return GdipCombineRegionRectI(region, rect, CombineModeExclude);
}

FORCEINLINE
Status RegionExcludePath(PGpRegion region, const PGpPath path)
{
	return GdipCombineRegionPath(region, path, CombineModeExclude);
}

FORCEINLINE
Status RegionExcludeRegion(PGpRegion region, const PGpRegion region2)
{
	return GdipCombineRegionRegion(region, region2, CombineModeExclude);
}

FORCEINLINE
Status RegionComplementRectF(PGpRegion region, const PRectF rect)
{
	return GdipCombineRegionRect(region, rect, CombineModeComplement);
}

FORCEINLINE
Status RegionComplementRect(PGpRegion region, const PRect rect)
{
	return GdipCombineRegionRectI(region, rect, CombineModeComplement);
}

FORCEINLINE
Status RegionComplementPath(PGpRegion region, const PGpPath path)
{
	return GdipCombineRegionPath(region, path, CombineModeComplement);
}

FORCEINLINE
Status RegionComplementRegion(PGpRegion region, const PGpRegion region2)
{
	return GdipCombineRegionRegion(region, region2, CombineModeComplement);
}

FORCEINLINE
Status RegionTranslateF(PGpRegion region, REAL dx, REAL dy)
{
    return GdipTranslateRegion(region, dx, dy);
}

FORCEINLINE
Status RegionTranslate(PGpRegion region, INT dx, INT dy)
{
    return GdipTranslateRegionI(region, dx, dy);
}

FORCEINLINE
Status RegionTransform(PGpRegion region, const PGpMatrix matrix)
{
	return GdipTransformRegion(region, matrix);
}

FORCEINLINE
Status RegionGetBoundsF(PGpRegion region, PRectF rect, const PGpGraphics g)
{
	return GdipGetRegionBounds(region, g, rect);
}

FORCEINLINE
Status RegionGetBounds(PGpRegion region, PRect rect, const PGpGraphics g)
{
	return GdipGetRegionBoundsI(region, g, rect);
}

FORCEINLINE
HRGN RegionGetHRGN(PGpRegion region, const PGpGraphics g)
{
	HRGN rgn;
	return GdipGetRegionHRgn(region, g, &rgn) == Ok? rgn : NULL;
}

FORCEINLINE
BOOL RegionIsEmpty(PGpRegion region, const PGpGraphics g)
{
	BOOL value;
	return GdipIsEmptyRegion(region, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL RegionIsInfinite(PGpRegion region, const PGpGraphics g)
{
	BOOL value;
	return GdipIsInfiniteRegion(region, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL RegionEquals(PGpRegion region, const PGpRegion region2, const PGpGraphics g)
{
	BOOL value;
	return GdipIsEqualRegion(region, region2, g, &value) == Ok? value : FALSE;
}

// Get the size of the buffer needed for the GetData method
FORCEINLINE
UINT RegionGetDataSize(PGpRegion region)
{
	UINT size;
	return GdipGetRegionDataSize(region, &size) == Ok? size : 0;
}

// buffer     - where to put the data
// bufferSize - how big the buffer is (should be at least as big as GetDataSize())
// sizeFilled - if not NULL, this is an OUT param that says how many bytes
//              of data were written to the buffer.
FORCEINLINE
Status RegionGetData(PGpRegion region, BYTE* buffer, UINT bufferSize, UINT* sizeFilled)
{
	return GdipGetRegionData(region, buffer, bufferSize, sizeFilled);
}

/**
 * Hit testing operations
 */

FORCEINLINE
BOOL RegionIsVisiblePointF(PGpRegion region, const PPointF point, const PGpGraphics g)
{
	BOOL value;
	return GdipIsVisibleRegionPoint(region, point->X, point->Y, g,
		&value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL RegionIsVisibleRectF(PGpRegion region, const PRectF rect, const PGpGraphics g)
{
	BOOL value;
	return GdipIsVisibleRegionRect(region, rect->X, rect->Y,
		rect->Width, rect->Height, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL RegionIsVisiblePoint(PGpRegion region, const PPoint point, const PGpGraphics g)
{
	BOOL value;
	return GdipIsVisibleRegionPointI(region, point->X, point->Y, g,
		&value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL RegionIsVisibleRect(PGpRegion region, const PRect rect, const PGpGraphics g)
{
	BOOL value;
	return GdipIsVisibleRegionRectI(region, rect->X, rect->Y,
		rect->Width, rect->Height, g, &value) == Ok? value : FALSE;
}

FORCEINLINE
UINT RegionGetRegionScansCount(PGpRegion region, const PGpMatrix matrix)
{
	UINT count;
	return GdipGetRegionScansCount(region, &count, matrix) == Ok? count : 0;
}

// If rects is NULL, return the count of rects in the region.
// Otherwise, assume rects is big enough to hold all the region rects
// and fill them in and return the number of rects filled in.
// The rects are returned in the units specified by the matrix
// (which is typically a world-to-device transform).
// Note that the number of rects returned can vary, depending on the
// matrix that is used.

FORCEINLINE
Status RegionGetRegionScansF(PGpRegion region,
	const PGpMatrix matrix, PRectF rects, INT* count)
{
	return GdipGetRegionScans(region, rects, count, matrix);
}

FORCEINLINE
Status RegionGetRegionScans(PGpRegion region,
	const PGpMatrix matrix, PRect rects, INT* count)
{
	return GdipGetRegionScansI(region, rects, count, matrix);
}

#endif // !_GDIPLUSREGION_H

