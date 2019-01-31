/**************************************************************************\
*
* Module Name:
*
*   GdipFontFamily_c.h
*
* Abstract:
*
*   GDI+ Font Family function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPFONTFAMILY_C_H
#define __GDIPFONTFAMILY_C_H

FORCEINLINE
PGpFontFamily FontFamilyFromFontCollection(const WCHAR* name,
	const PGpFontCollection fontCollection)
{
    PGpFontFamily family;
	return GdipCreateFontFamilyFromName(name, fontCollection,
		&family) == Ok? family : NULL;
}

FORCEINLINE
PGpFontFamily FontFamilyCreate(const WCHAR* name)
{
	return FontFamilyFromFontCollection(name, NULL);
}

static PGpFontFamily GenericSansSerifFontFamily = NULL;
static PGpFontFamily GenericSerifFontFamily     = NULL;
static PGpFontFamily GenericMonospaceFontFamily = NULL;

FORCEINLINE
PGpFontFamily FontFamilyGenericSansSerif(VOID)
{
	if (GenericSansSerifFontFamily == NULL)
		GdipGetGenericFontFamilySansSerif(&GenericSansSerifFontFamily);
	return GenericSansSerifFontFamily;
}

FORCEINLINE
PGpFontFamily FontFamilyGenericSerif(VOID)
{
	if (GenericSerifFontFamily == NULL)
		GdipGetGenericFontFamilySerif(&GenericSerifFontFamily);
	return GenericSerifFontFamily;
}

FORCEINLINE
PGpFontFamily FontFamilyGenericMonospace(VOID)
{
	if (GenericMonospaceFontFamily == NULL)
		GdipGetGenericFontFamilyMonospace(&GenericMonospaceFontFamily);
	return GenericMonospaceFontFamily;
}

FORCEINLINE
Status FontFamilyDelete(PGpFontFamily family)
{
	if (family == GenericSansSerifFontFamily ||
		family == GenericSerifFontFamily ||
		family == GenericMonospaceFontFamily)
		return Ok;
	return GdipDeleteFontFamily(family);
}

FORCEINLINE
PGpFontFamily FontFamilyClone(const PGpFontFamily source)
{
    PGpFontFamily family;
	return GdipCloneFontFamily(source, &family) == Ok? family : NULL;
}

/* name size >= LF_FACESIZE] */
FORCEINLINE
Status FontFamilyGetFamilyName(PGpFontFamily family, WCHAR* name, LANGID language)
{
	return GdipGetFamilyName(family, name, language);
}

FORCEINLINE
BOOL FontFamilyIsStyleAvailable(PGpFontFamily family, INT style)
{
	BOOL value;
	return GdipIsStyleAvailable(family, style, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL FontFamilyIsAvailable(PGpFontFamily family)
{
    return family != NULL;
}

FORCEINLINE
UINT16 FontFamilyGetEmHeight(PGpFontFamily family, INT style)
{
	UINT16 height;
	return GdipGetEmHeight(family, style, &height) == Ok? height : 0;
}

FORCEINLINE
UINT16 FontFamilyGetCellAscent(PGpFontFamily family, INT style)
{
	UINT16 ascent;
	return GdipGetCellAscent(family, style, &ascent) == Ok? ascent : 0;
}

FORCEINLINE
UINT16 FontFamilyGetCellDescent(PGpFontFamily family, INT style)
{
	UINT16 descent;
	return GdipGetCellDescent(family, style, &descent) == Ok? descent : 0;
}

FORCEINLINE
UINT16 FontFamilyGetLineSpacing(PGpFontFamily family, INT style)
{
	UINT16 spacing;
	return GdipGetLineSpacing(family, style, &spacing) == Ok? spacing : 0;
}

#endif

