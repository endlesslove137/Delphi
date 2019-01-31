/**************************************************************************\
*
* Module Name:
*
*   GdipFont.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipFontHPP
#define GdipFontHPP

inline
float __fastcall TGpFont::GetSize(void)
{
	CheckStatus(GdipGetFontSize(Native, &Result.rFLOAT));
	return Result.rFLOAT;
}
inline
TFontStyles __fastcall TGpFont::GetStyle(void)
{
  CheckStatus(GdipGetFontStyle(Native, &Result.rINT));
  return *(TFontStyles*)&Result.rINT;
}
inline
TUnit __fastcall TGpFont::GetUnit(void)
{
   CheckStatus(GdipGetFontUnit(Native, (GdiplusSys::Unit*)&Result.rINT));
   return (TUnit)Result.rINT;
}
inline
WideString __fastcall TGpFont::GetName()
{
  GdipGetFamily(Native, &Result.rNATIVE);
  WCHAR str[LF_FACESIZE];
  CheckStatus(GdipGetFamilyName(Result.rNATIVE, str, 0));
  return WideString(str);
}
inline
__fastcall TGpFont::TGpFont(HDC DC)
{
	CheckStatus(GdipCreateFontFromDC(DC, &Native));
}
inline
__fastcall TGpFont::TGpFont(HDC DC, LOGFONTA* logfont)
{
	if (logfont)
		CheckStatus(GdipCreateFontFromLogfontA(DC, logfont, &Native));
	else
		CheckStatus(GdipCreateFontFromDC(DC, &Native));
}
inline
__fastcall TGpFont::TGpFont(HDC DC, LOGFONTW* logfont)
{
	if (logfont)
		CheckStatus(GdipCreateFontFromLogfontW(DC, logfont, &Native));
	else
		CheckStatus(GdipCreateFontFromDC(DC, &Native));
}
inline
__fastcall TGpFont::TGpFont(HDC DC, HFONT font)
{
	LOGFONTA lf;
	if (font && GetObjectA(font, sizeof(LOGFONTA), &lf))
		CheckStatus(GdipCreateFontFromLogfontA(DC, &lf, &Native));
	else
		CheckStatus(GdipCreateFontFromDC(DC, &Native));
}
inline
__fastcall TGpFont::TGpFont(TGpFontFamily* family, float emSize, TFontStyles style, TUnit unit)
{
	CheckStatus(GdipCreateFont(ObjectNative(family), emSize,
        SETTOBYTE(style), (GdiplusSys::Unit)(int)unit, &Native));
}
inline
__fastcall TGpFont::TGpFont(WideString familyName, float emSize,
	TFontStyles style, TUnit unit, TGpFontCollection* fontCollection)
{
	GpFontFamily *nativeFamily;
	TStatus Status = GdipCreateFontFamilyFromName(familyName.c_bstr(),
						fontCollection? fontCollection->Native : NULL, &nativeFamily);
	bool IsFree = Status == Ok;
	if (Status != Ok)
		nativeFamily = TGpFontFamily::GenericSansSerif()->Native;
	Status = GdipCreateFont(nativeFamily, emSize, SETTOBYTE(style),
        (GdiplusSys::Unit)(int)unit, &Native);
	if (Status != Ok)
	{
		nativeFamily = TGpFontFamily::GenericSansSerif()->Native;
		Status = GdipCreateFont(nativeFamily, emSize, SETTOBYTE(style),
            (GdiplusSys::Unit)(int)unit, &Native);
	}
	if (IsFree) GdipDeleteFontFamily(nativeFamily);
	else CheckStatus(Status);
}
inline
__fastcall TGpFont::~TGpFont(void)
{
	GdipDeleteFont(Native);
}
inline
LOGFONTA __fastcall TGpFont::GetLogFontA(TGpGraphics* g)
{
	LOGFONTA la;
	CheckStatus(GdipGetLogFontA(Native, g? g->Native : NULL, &la));
	return la;
}
inline
LOGFONTW __fastcall TGpFont::GetLogFontW(TGpGraphics* g)
{
	LOGFONTW lw;
	CheckStatus(GdipGetLogFontW(Native, g? g->Native : NULL, &lw));
	return lw;
}
inline
TGpFont* __fastcall TGpFont::Clone(void)
{
	return new TGpFont(Native, (TCloneAPI)GdipCloneFont);
}
inline
bool __fastcall TGpFont::IsAvailable(void)
{
	return Native;
}
inline
float __fastcall TGpFont::GetHeight(TGpGraphics* graphics)
{
	CheckStatus(GdipGetFontHeight(Native, ObjectNative(graphics), &Result.rFLOAT));
	return Result.rFLOAT;
}
inline
float __fastcall TGpFont::GetHeight(float dpi)
{
	CheckStatus(GdipGetFontHeightGivenDPI(Native, dpi, &Result.rFLOAT));
	return Result.rFLOAT;
}
inline
void __fastcall TGpFont::GetFamily(TGpFontFamily* family)
{
  if (!family) CheckStatus(InvalidParameter);
  CheckStatus(GdipGetFamily(Native, &family->Native));
}

#endif
