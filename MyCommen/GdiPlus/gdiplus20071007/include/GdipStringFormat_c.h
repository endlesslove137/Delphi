/**************************************************************************\
*
* Module Name:
*
*   GdipStringFormat_c.h
*
* Abstract:
*
*   GDI+ StringFormat function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPSTRINGFORMAT_C_H
#define __GDIPSTRINGFORMAT_C_H

FORCEINLINE
PGpStringFormat StrFormatFromFlags(StringFormatFlags formatFlags, LANGID language)
{
	PGpStringFormat format;
	return GdipCreateStringFormat(formatFlags, language, &format) == Ok? format : NULL;
}

FORCEINLINE
PGpStringFormat StrFormatCreate(VOID)
{
	return StrFormatFromFlags(0, LANG_NEUTRAL);
}

static PGpStringFormat GenericTypographicStringFormat = NULL;
static PGpStringFormat GenericDefaultStringFormat = NULL;

FORCEINLINE
PGpStringFormat StrFormatGenericDefault(VOID)
{
	if (!GenericDefaultStringFormat)
		GdipStringFormatGetGenericDefault(&GenericDefaultStringFormat);
	return GenericDefaultStringFormat;
}

FORCEINLINE
PGpStringFormat StrFormatGenericTypographic(VOID)
{
	if (!GenericTypographicStringFormat)
		GdipStringFormatGetGenericTypographic(&GenericTypographicStringFormat);
	return GenericTypographicStringFormat;
}

FORCEINLINE
PGpStringFormat StrFormatClone(const PGpStringFormat source)
{
    PGpStringFormat format;
	return GdipCloneStringFormat(source, &format) == Ok? format : NULL;
}

FORCEINLINE
Status StrFormatDelete(PGpStringFormat format)
{
	if (format == GenericTypographicStringFormat ||
		format == GenericDefaultStringFormat)
		return Ok;
	return GdipDeleteStringFormat(format);
}

FORCEINLINE
Status StrFormatSetFormatFlags(PGpStringFormat format, StringFormatFlags flags)
{
	return GdipSetStringFormatFlags(format, flags);
}

FORCEINLINE
StringFormatFlags StrFormatGetFormatFlags(PGpStringFormat format)
{
	StringFormatFlags flags;
	GdipGetStringFormatFlags(format, (INT*)&flags);
	return flags;
}

FORCEINLINE
Status StrFormatSetAlignment(PGpStringFormat format, StringAlignment align)
{
	return GdipSetStringFormatAlign(format, align);
}

FORCEINLINE
StringAlignment StrFormatGetAlignment(PGpStringFormat format)
{
	StringAlignment alignment;
	GdipGetStringFormatAlign(format, &alignment);
	return alignment;
}

FORCEINLINE
Status StrFormatSetLineAlignment(PGpStringFormat format, StringAlignment align)
{
	return GdipSetStringFormatLineAlign(format, align);
}

FORCEINLINE
StringAlignment StrFormatGetLineAlignment(PGpStringFormat format)
{
	StringAlignment alignment;
	GdipGetStringFormatLineAlign(format, &alignment);
	return alignment;
}

FORCEINLINE
Status StrFormatSetHotkeyPrefix(PGpStringFormat format, HotkeyPrefix hotkeyPrefix)
{
	return GdipSetStringFormatHotkeyPrefix(format, (INT)hotkeyPrefix);
}

FORCEINLINE
HotkeyPrefix StrFormatGetHotkeyPrefix(PGpStringFormat format)
{
	HotkeyPrefix hotkeyPrefix;
	GdipGetStringFormatHotkeyPrefix(format, (INT*)&hotkeyPrefix);
	return hotkeyPrefix;
}

FORCEINLINE
Status StrFormatSetTabStops(PGpStringFormat format,
	REAL firstTabOffset, INT count, const PREAL tabStops)
{
	return GdipSetStringFormatTabStops(format, firstTabOffset, count, tabStops);
}

FORCEINLINE
INT StrFormatGetTabStopCount(PGpStringFormat format)
{
	INT count;
	return GdipGetStringFormatTabStopCount(format, &count) == Ok? count : 0;
}

FORCEINLINE
Status StrFormatGetTabStops(PGpStringFormat format,
	PREAL firstTabOffset, PREAL tabStops, INT count)
{
	return GdipGetStringFormatTabStops(format, count, firstTabOffset, tabStops);
}

FORCEINLINE
Status StrFormatSetDigitSubstitution(PGpStringFormat format,
	LANGID language, StringDigitSubstitute substitute)
{
	return GdipSetStringFormatDigitSubstitution(format, language, substitute);
}

FORCEINLINE
LANGID StrFormatGetDigitSubstitutionLanguage(PGpStringFormat format)
{
	LANGID langID;
	GdipGetStringFormatDigitSubstitution(format, &langID, NULL);
	return langID;
}

FORCEINLINE
StringDigitSubstitute StrFormatGetDigitSubstitutionMethod(PGpStringFormat format)
{
	StringDigitSubstitute value;
	GdipGetStringFormatDigitSubstitution(format, NULL, &value);
	return value;
}

FORCEINLINE
Status StrFormatSetTrimming(PGpStringFormat format, StringTrimming trimming)
{
	return GdipSetStringFormatTrimming(format, trimming);
}

FORCEINLINE
StringTrimming StrFormatGetTrimming(PGpStringFormat format)
{
	StringTrimming trimming;
	GdipGetStringFormatTrimming(format, &trimming);
	return trimming;
}

FORCEINLINE
Status StrFormatSetMeasurableCharacterRanges(PGpStringFormat format,
	const CharacterRange *ranges, INT rangeCount)
{
	return GdipSetStringFormatMeasurableCharacterRanges(format, rangeCount, ranges);
}

FORCEINLINE
INT StrFormatGetMeasurableCharacterRangeCount(PGpStringFormat format)
{
	INT count;
	return GdipGetStringFormatMeasurableCharacterRangeCount(
		format, &count) == Ok? count : 0;
}

#endif //

