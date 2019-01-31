/**************************************************************************\
*
* Module Name:
*
*   GdipCachedBitmap.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipCachedBitmapHPP
#define GdipCachedBitmapHPP

inline
__fastcall TGpCachedBitmap::TGpCachedBitmap(TGpBitmap *bitmap, TGpGraphics *graphics)
{
	CheckStatus(GdipCreateCachedBitmap(bitmap->Native, graphics->Native, &Native));
}
inline
__fastcall TGpCachedBitmap::~TGpCachedBitmap(void)
{
	GdipDeleteCachedBitmap(Native);
}

#endif


