/**************************************************************************\
*
* Module Name:
* 
*   GdipFontCollection_c.h
*
* Abstract:
*
*   Font collections (Installed and Private) function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPFONTCOLL_C_H
#define __GDIPFONTCOLL_C_H

FORCEINLINE
INT FontCollectionGetFamilyCount(PGpFontCollection fontCollection)
{
	INT count;
	return GdipGetFontCollectionFamilyCount(fontCollection, &count) == Ok? count : 0;
}

FORCEINLINE
INT FontCollectionGetFamilies(PGpFontCollection fontCollection,
	INT numSought, PGpFontFamily families)
{
	INT count;
	if (numSought <= 0 || families == NULL)
		return 0;
	return GdipGetFontCollectionFamilyList(fontCollection,
		numSought, families, &count) == Ok? count : 0;
}

FORCEINLINE
PGpInstalledFontCollection InstalledFontCollectionCreate(VOID)
{
	PGpInstalledFontCollection collect;
	return GdipNewInstalledFontCollection(&collect) == Ok? collect : NULL;
}

FORCEINLINE
PGpPrivateFontCollection PrivateFontCollectionCreate(VOID)
{
    PGpPrivateFontCollection collect;
	return GdipNewPrivateFontCollection(&collect) == Ok? collect : NULL;
}

FORCEINLINE
Status PrivateFontCollectionDelete(PGpPrivateFontCollection fontCollection)
{
	return GdipDeletePrivateFontCollection(&fontCollection);
}

FORCEINLINE
Status PrivateFontCollectionAddFontFile(
	PGpPrivateFontCollection fontCollection, const WCHAR* filename)
{
	return GdipPrivateAddFontFile(fontCollection, filename);
}

FORCEINLINE
Status PrivateFontCollectionAddMemoryFont(
	PGpPrivateFontCollection fontCollection, const void* memory, INT length)
{
	return GdipPrivateAddMemoryFont(fontCollection, memory, length);
}

#endif // _GDIPLUSFONTCOLL_H

