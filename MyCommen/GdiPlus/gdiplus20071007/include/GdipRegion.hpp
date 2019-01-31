/**************************************************************************\
*
* Module Name:
*
*   GdipRegion.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipRegionH
#define GdipRegionH

inline
__fastcall TGpRegion::TGpRegion(void)
{
	CheckStatus(GdipCreateRegion(&Native));
}
inline
__fastcall TGpRegion::TGpRegion(const TGpRectF &rect)
{
	CheckStatus(GdipCreateRegionRect(&rect, &Native));
}
inline
__fastcall TGpRegion::TGpRegion(const TGpRect &rect)
{
	CheckStatus(GdipCreateRegionRectI(&rect, &Native));
}
inline
__fastcall TGpRegion::TGpRegion(TGpGraphicsPath *path)
{
	CheckStatus(GdipCreateRegionPath(path->Native, &Native));
}
inline
__fastcall TGpRegion::TGpRegion(Byte *regionData, const int regionData_Size)
{
	CheckStatus(GdipCreateRegionRgnData(regionData, regionData_Size, &Native));
}
inline
__fastcall TGpRegion::TGpRegion(HRGN hrgn)
{
	CheckStatus(GdipCreateRegionHrgn(hrgn, &Native));
}
inline
static TGpRegion* __fastcall TGpRegion::FromHRGN(HRGN hrgn)
{
	return new TGpRegion(hrgn);
}
inline
__fastcall TGpRegion::~TGpRegion(void)
{
GdipDeleteRegion(Native);
}
inline
TGpRegion* __fastcall TGpRegion::Clone(void)
{
	return new TGpRegion(Native, (TCloneAPI)GdipCloneRegion);
}
inline
void __fastcall TGpRegion::MakeInfinite(void)
{
	CheckStatus(GdipSetInfinite(Native));
}
inline
void __fastcall TGpRegion::MakeEmpty(void)
{
	CheckStatus(GdipSetEmpty(Native));
}
inline
void __fastcall TGpRegion::GetData(Byte *buffer, const int buffer_Size, UINT *sizeFilled)
{
	CheckStatus(GdipGetRegionData(Native, buffer, buffer_Size, sizeFilled));
}
inline
void __fastcall TGpRegion::Intersect(const TGpRect &rect)
{
	CheckStatus(GdipCombineRegionRectI(Native, &rect, CombineModeIntersect));
}
inline
void __fastcall TGpRegion::Intersect(const TGpRectF &rect)
{
	CheckStatus(GdipCombineRegionRect(Native, &rect, CombineModeIntersect));
}
inline
void __fastcall TGpRegion::Intersect(TGpGraphicsPath* path)
{
	CheckStatus(GdipCombineRegionPath(Native, path->Native, CombineModeIntersect));
}
inline
void __fastcall TGpRegion::Intersect(TGpRegion* region)
{
	CheckStatus(GdipCombineRegionRegion(Native, region->Native, CombineModeIntersect));
}
inline
void __fastcall TGpRegion::Union(const TGpRect &rect)
{
	CheckStatus(GdipCombineRegionRectI(Native, &rect, CombineModeUnion));
}
inline
void __fastcall TGpRegion::Union(const TGpRectF &rect)
{
	CheckStatus(GdipCombineRegionRect(Native, &rect, CombineModeUnion));
}
inline
void __fastcall TGpRegion::Union(TGpGraphicsPath* path)
{
	CheckStatus(GdipCombineRegionPath(Native, path->Native, CombineModeUnion));
}
inline
void __fastcall TGpRegion::Union(TGpRegion* region)
{
	CheckStatus(GdipCombineRegionRegion(Native, region->Native, CombineModeUnion));
}
inline
void __fastcall TGpRegion::Xor(const TGpRect &rect)
{
	CheckStatus(GdipCombineRegionRectI(Native, &rect, CombineModeXor));
}
inline
void __fastcall TGpRegion::Xor(const TGpRectF &rect)
{
	CheckStatus(GdipCombineRegionRect(Native, &rect, CombineModeXor));
}
inline
void __fastcall TGpRegion::Xor(TGpGraphicsPath* path)
{
	CheckStatus(GdipCombineRegionPath(Native, path->Native, CombineModeXor));
}
inline
void __fastcall TGpRegion::Xor(TGpRegion* region)
{
	CheckStatus(GdipCombineRegionRegion(Native, region->Native, CombineModeXor));
}
inline
void __fastcall TGpRegion::Exclude(const TGpRect &rect)
{
	CheckStatus(GdipCombineRegionRectI(Native, &rect, CombineModeExclude));
}
inline
void __fastcall TGpRegion::Exclude(const TGpRectF &rect)
{
	CheckStatus(GdipCombineRegionRect(Native, &rect, CombineModeExclude));
}
inline
void __fastcall TGpRegion::Exclude(TGpGraphicsPath* path)
{
	CheckStatus(GdipCombineRegionPath(Native, path->Native, CombineModeExclude));
}
inline
void __fastcall TGpRegion::Exclude(TGpRegion* region)
{
	CheckStatus(GdipCombineRegionRegion(Native, region->Native, CombineModeExclude));
}
inline
void __fastcall TGpRegion::Complement(const TGpRect &rect)
{
	CheckStatus(GdipCombineRegionRectI(Native, &rect, CombineModeComplement));
}
inline
void __fastcall TGpRegion::Complement(const TGpRectF &rect)
{
	CheckStatus(GdipCombineRegionRect(Native, &rect, CombineModeComplement));
}
inline
void __fastcall TGpRegion::Complement(TGpGraphicsPath* path)
{
	CheckStatus(GdipCombineRegionPath(Native, path->Native, CombineModeComplement));
}
inline
void __fastcall TGpRegion::Complement(TGpRegion* region)
{
	CheckStatus(GdipCombineRegionRegion(Native, region->Native, CombineModeComplement));
}
inline
void __fastcall TGpRegion::Translate(float dx, float dy)
{
	CheckStatus(GdipTranslateRegion(Native, dx, dy));
}
inline
void __fastcall TGpRegion::Translate(int dx, int dy)
{
	CheckStatus(GdipTranslateRegionI(Native, dx, dy));
}
inline
void __fastcall TGpRegion::Transform(TGpMatrix* matrix)
{
	CheckStatus(GdipTransformRegion(Native, matrix->Native));
}
inline
void __fastcall TGpRegion::GetBounds(TGpRect &rect, const TGpGraphics* g)
{
	CheckStatus(GdipGetRegionBoundsI(Native, g->Native, &rect));
}
inline
void __fastcall TGpRegion::GetBounds(TGpRectF &rect, const TGpGraphics* g)
{
	CheckStatus(GdipGetRegionBounds(Native, g->Native, &rect));
}
inline
HRGN __fastcall TGpRegion::GetHRGN(TGpGraphics* g)
{
	CheckStatus(GdipGetRegionHRgn(Native, g->Native, &(HRGN)Result.rPVOID));
	return (HRGN)Result.rPVOID;
}
inline
bool __fastcall TGpRegion::IsEmpty(TGpGraphics* g)
{
	CheckStatus(GdipIsEmptyRegion(Native, g->Native, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsInfinite(TGpGraphics* g)
{
	CheckStatus(GdipIsInfiniteRegion(Native, g->Native, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsVisible(int x, int y, TGpGraphics* g)
{
	CheckStatus(GdipIsVisibleRegionPointI(Native, x, y, g? g->Native : NULL, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsVisible(const TGpPoint &point, TGpGraphics* g)
{
	return IsVisible(point.X, point.Y, g);
}
inline
bool __fastcall TGpRegion::IsVisible(float x, float y, TGpGraphics* g)
{
	CheckStatus(GdipIsVisibleRegionPoint(Native, x, y, g? g->Native : NULL, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsVisible(const TGpPointF &point, TGpGraphics* g)
{
	return IsVisible(point.X, point.Y, g);
}
inline
bool __fastcall TGpRegion::IsVisible(int x, int y, int width, int height, TGpGraphics* g)
{
	CheckStatus(GdipIsVisibleRegionRectI(Native, x, y, width, height, g? g->Native : NULL, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsVisible(const TGpRect &rect, TGpGraphics* g)
{
	return IsVisible(rect.X, rect.Y, rect.Width, rect.Height, g);
}
inline
bool __fastcall TGpRegion::IsVisible(float x, float y, float width, float height, TGpGraphics* g)
{
	CheckStatus(GdipIsVisibleRegionRect(Native, x, y, width, height, g? g->Native : NULL, &Result.rBOOL));
	return Result.rBOOL;
}
inline
bool __fastcall TGpRegion::IsVisible(const TGpRectF &rect, TGpGraphics* g)
{
	return IsVisible(rect.X, rect.Y, rect.Width, rect.Height, g);
}
inline
bool __fastcall TGpRegion::Equals(TGpRegion* region, TGpGraphics* g)
{
	CheckStatus(GdipIsEqualRegion(Native, region->Native, g->Native, &Result.rBOOL));
	return Result.rBOOL;
}
inline
int __fastcall TGpRegion::GetRegionScansCount(TGpMatrix* matrix)
{
	CheckStatus(GdipGetRegionScansCount(Native, &Result.rUINT, matrix->Native));
	return Result.rINT;
}
inline
int __fastcall TGpRegion::GetRegionScans(TGpMatrix* matrix, TGpRectF *rects)
{
	CheckStatus(GdipGetRegionScans(Native, rects, &Result.rINT, matrix->Native));
	return Result.rINT;
}
inline
int __fastcall TGpRegion::GetRegionScans(TGpMatrix* matrix, TGpRect *rects)
{
	CheckStatus(GdipGetRegionScansI(Native, rects, &Result.rINT, matrix->Native));
	return Result.rINT;
}

#endif
