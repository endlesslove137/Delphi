/**************************************************************************\
*
* Module Name:
*
*   GdipFont_c.h
*
* Abstract:
*
*   GDI+ Font function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPFONT_C_H
#define __GDIPFONT_C_H

FORCEINLINE
PGpFont FontFromDC(HDC hdc)
{
    PGpFont font;
	return GdipCreateFontFromDC(hdc, &font) == Ok? font : NULL;
}

FORCEINLINE
PGpFont FontFromHFONT(HDC hdc, const HFONT hfont)
{
	PGpFont font;// = NULL;
	LOGFONTA lf;
	if (hfont && GetObjectA(hfont, sizeof(LOGFONTA), &lf))
		GdipCreateFontFromLogfontA(hdc, &lf, &font);
	else
		GdipCreateFontFromDC(hdc, &font);
	return font;
}

FORCEINLINE
PGpFont FontFromLogfontW(HDC hdc, const LOGFONTW* logfont)
{
	PGpFont font;// = NULL;
	if (logfont)
		GdipCreateFontFromLogfontW(hdc, logfont, &font);
	else
		GdipCreateFontFromDC(hdc, &font);
	return font;
}

FORCEINLINE
PGpFont FontFromLogfontA(HDC hdc, const LOGFONTA* logfont)
{
	PGpFont font;// = NULL;
	if (logfont)
		GdipCreateFontFromLogfontA(hdc, logfont, &font);
	else
		GdipCreateFontFromDC(hdc, &font);
	return font;
}

FORCEINLINE
PGpFont FontFromFamily(const PGpFontFamily family,
	REAL emSize, INT style, Unit unit)
{
    PGpFont font;
	return GdipCreateFont(family, emSize, style, unit, &font) == Ok? font : NULL;
}

FORCEINLINE
PGpFont FontFromName(const WCHAR* familyName, REAL emSize, INT style,
	 Unit unit, const PGpFontCollection fontCollection)
{
    PGpFont font;
	PGpFontFamily family;
	family = FontFamilyFromFontCollection(familyName, fontCollection);
	if (family == NULL) family = FontFamilyGenericSansSerif();
	if (GdipCreateFont(family, emSize, style, unit, &font) == Ok)
		return font;
	FontFamilyDelete(family);
	return NULL;
}

FORCEINLINE
PGpFont FontCreate(const WCHAR* familyName, REAL emSize, INT style)
{
	return FontFromName(familyName, emSize, style, UnitPoint, NULL);
}

FORCEINLINE
PGpFont FontClone(const PGpFont source)
{
    PGpFont font;
	return GdipCloneFont(source, &font) == Ok? font : NULL;
}

FORCEINLINE
Status FontGetLogFontA(PGpFont font, const PGpGraphics g, LOGFONTA *logfontA)
{
	return GdipGetLogFontA(font, g, logfontA);
}

FORCEINLINE
Status FontGetLogFontW(PGpFont font, const PGpGraphics g, LOGFONTW *logfontW)
{
	return GdipGetLogFontW(font, g, logfontW);
}

FORCEINLINE
Status FontDelete(PGpFont font)
{
	return GdipDeleteFont(font);
}

// Operations

FORCEINLINE
BOOL FontIsAvailable(PGpFont font)
{
	return (font? TRUE : FALSE);
}

FORCEINLINE
PGpFontFamily FontGetFamily(PGpFont font)
{
    PGpFontFamily family;
	return GdipGetFamily(font, &family) == Ok? family : NULL;
}

FORCEINLINE
INT FontGetStyle(PGpFont font)
{
	INT style;
	return GdipGetFontStyle(font, &style) == Ok? style : 0;
}

FORCEINLINE
REAL FontGetSize(PGpFont font)
{
	REAL size;
	return GdipGetFontSize(font, &size) == Ok? size : 0;
}

FORCEINLINE
Unit FontGetUnit(PGpFont font)
{
	Unit unit;
	GdipGetFontUnit(font, &unit);
	return unit;
}

FORCEINLINE
REAL FontGetHeight(PGpFont font, const PGpGraphics graphics)
{
	REAL height;
	return GdipGetFontHeight(font, graphics, &height) == Ok? height : 0;
}


FORCEINLINE
REAL FontGetDpiHeight(PGpFont font, REAL dpi)
{
	REAL height;
	return GdipGetFontHeightGivenDPI(font, dpi, &height) == Ok? height : 0;
}

#endif

