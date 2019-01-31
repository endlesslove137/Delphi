/**************************************************************************\
*
* Module Name:
*
*   GdipFontFamily.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipFontFamilyHPP
#define GdipFontFamilyHPP

inline
__fastcall TGpFontFamily::TGpFontFamily(WideString name, TGpFontCollection* fontCollection)
{
	CheckStatus(GdipCreateFontFamilyFromName(name.c_bstr(),
				fontCollection? fontCollection->Native : NULL, &Native));
}
inline
__fastcall TGpFontFamily::~TGpFontFamily(void)
{
	if (Native)
		GdipDeleteFontFamily(Native);
}
inline
WideString __fastcall TGpFontFamily::GetFamilyName(WORD language)
{
	WCHAR str[LF_FACESIZE];
	CheckStatus(GdipGetFamilyName(Native, str, language));
	return WideString(str);
}
inline
TGpFontFamily* __fastcall TGpFontFamily::Clone(void)
{
	return new TGpFontFamily(Native, (TCloneAPI)GdipCloneFontFamily);
}
inline
bool __fastcall TGpFontFamily::IsAvailable(void)
{
	return Native;
}
inline
bool __fastcall TGpFontFamily::IsStyleAvailable(TFontStyles style)
{
	CheckStatus(GdipIsStyleAvailable(Native, SETTOBYTE(style), &Result.rBOOL));
	return Result.rBOOL;
}
inline
WORD __fastcall TGpFontFamily::GetEmHeight(TFontStyles style)
{
	CheckStatus(GdipGetEmHeight(Native, SETTOBYTE(style), &Result.rWORD));
	return Result.rWORD;
}
inline
WORD __fastcall TGpFontFamily::GetCellAscent(TFontStyles style)
{
	CheckStatus(GdipGetCellAscent(Native, SETTOBYTE(style), &Result.rWORD));
	return Result.rWORD;
}
inline
WORD __fastcall TGpFontFamily::GetCellDescent(TFontStyles style)
{
	CheckStatus(GdipGetCellDescent(Native, SETTOBYTE(style), &Result.rWORD));
	return Result.rWORD;
}
inline
WORD __fastcall TGpFontFamily::GetLineSpacing(TFontStyles style)
{
	CheckStatus(GdipGetLineSpacing(Native, SETTOBYTE(style), &Result.rWORD));
	return Result.rWORD;
}


class TGenericFontFamily : public TGpFontFamily
{

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGenericFontFamily));
	}
#endif
	virtual void __fastcall FreeInstance()
	{
		GdipGenerics.GenericNil(this);
		TGdiplusBase::FreeInstance();
    }
};

inline
static TGpFontFamily* __fastcall TGpFontFamily::GenericSansSerif(void)
{
	if (GdipGenerics.GenericSansSerifFontFamily == NULL)
	{
		GdipGenerics.GenericSansSerifFontFamily = new TGenericFontFamily();
		GdipGetGenericFontFamilySansSerif(&GdipGenerics.GenericSansSerifFontFamily->Native);
	}
	return (TGpFontFamily*)GdipGenerics.GenericSansSerifFontFamily;
}
inline
static TGpFontFamily* __fastcall TGpFontFamily::GenericSerif(void)
{
	if (GdipGenerics.GenericSerifFontFamily == NULL)
	{
		GdipGenerics.GenericSerifFontFamily = new TGenericFontFamily();
		GdipGetGenericFontFamilySerif(&GdipGenerics.GenericSerifFontFamily->Native);
	}
	return (TGpFontFamily*)GdipGenerics.GenericSerifFontFamily;
}
inline
static TGpFontFamily* __fastcall TGpFontFamily::GenericMonospace(void)
{
	if (GdipGenerics.GenericMonospaceFontFamily == NULL)
	{
		GdipGenerics.GenericMonospaceFontFamily = new TGenericFontFamily();
		GdipGetGenericFontFamilyMonospace(&GdipGenerics.GenericMonospaceFontFamily->Native);
	}
	return (TGpFontFamily*)GdipGenerics.GenericMonospaceFontFamily;
}

#endif
