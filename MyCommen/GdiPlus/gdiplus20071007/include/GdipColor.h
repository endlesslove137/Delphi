/**************************************************************************\
*
* Module Name:
*
*   GdipColor.h       
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipColorHPP
#pragma option push -b -a8 -pc -A- /*P_O_Push*/
#define GdipColorHPP

//----------------------------------------------------------------------------
// Color mode
//----------------------------------------------------------------------------

enum ColorMode
{
    ColorModeARGB32 = 0,
    ColorModeARGB64 = 1
};

//----------------------------------------------------------------------------
// Color Channel flags
//----------------------------------------------------------------------------

enum ColorChannelFlags
{
    ColorChannelFlagsC = 0,
    ColorChannelFlagsM,
    ColorChannelFlagsY,
    ColorChannelFlagsK,
    ColorChannelFlagsLast
};

// Known Color
#define		KnownColorCount		141

static const ARGB kcAliceBlue 		= 0xfff0f8ff;
static const ARGB kcAntiqueWhite 	= 0xfffaebd7;
static const ARGB kcAqua 			= 0xff00ffff;
static const ARGB kcAquamarine 		= 0xff7fffd4;
static const ARGB kcAzure 			= 0xfff0ffff;
static const ARGB kcBeige 			= 0xfff5f5dc;
static const ARGB kcBisque 			= 0xffffe4c4;
static const ARGB kcBlack 			= 0xff000000;
static const ARGB kcBlanchedAlmond 	= 0xffffebcd;
static const ARGB kcBlue 			= 0xff0000ff;
static const ARGB kcBlueViolet 		= 0xff8a2be2;
static const ARGB kcBrown 			= 0xffa52a2a;
static const ARGB kcBurlyWood 		= 0xffdeb887;
static const ARGB kcCadetBlue 		= 0xff5f9ea0;
static const ARGB kcChartreuse 		= 0xff7fff00;
static const ARGB kcChocolate 		= 0xffd2691e;
static const ARGB kcCoral 			= 0xffff7f50;
static const ARGB kcCornflowerBlue 	= 0xff6495ed;
static const ARGB kcCornsilk 		= 0xfffff8dc;
static const ARGB kcCrimson 		= 0xffdc143c;
static const ARGB kcCyan 			= 0xff00ffff;
static const ARGB kcDarkBlue 		= 0xff00008b;
static const ARGB kcDarkCyan 		= 0xff008b8b;
static const ARGB kcDarkGoldenrod 	= 0xffb8860b;
static const ARGB kcDarkGray 		= 0xffa9a9a9;
static const ARGB kcDarkGreen 		= 0xff006400;
static const ARGB kcDarkKhaki 		= 0xffbdb76b;
static const ARGB kcDarkMagenta 	= 0xff8b008b;
static const ARGB kcDarkOliveGreen 	= 0xff556b2f;
static const ARGB kcDarkOrange 		= 0xffff8c00;
static const ARGB kcDarkOrchid 		= 0xff9932cc;
static const ARGB kcDarkRed 		= 0xff8b0000;
static const ARGB kcDarkSalmon 		= 0xffe9967a;
static const ARGB kcDarkSeaGreen 	= 0xff8fbc8b;
static const ARGB kcDarkSlateBlue 	= 0xff483d8b;
static const ARGB kcDarkSlateGray 	= 0xff2f4f4f;
static const ARGB kcDarkTurquoise 	= 0xff00ced1;
static const ARGB kcDarkViolet 		= 0xff9400d3;
static const ARGB kcDeepPink 		= 0xffff1493;
static const ARGB kcDeepSkyBlue 	= 0xff00bfff;
static const ARGB kcDimGray 		= 0xff696969;
static const ARGB kcDodgerBlue 		= 0xff1e90ff;
static const ARGB kcFirebrick 		= 0xffb22222;
static const ARGB kcFloralWhite 	= 0xfffffaf0;
static const ARGB kcForestGreen 	= 0xff228b22;
static const ARGB kcFuchsia 		= 0xffff00ff;
static const ARGB kcGainsboro 		= 0xffdcdcdc;
static const ARGB kcGhostWhite 		= 0xfff8f8ff;
static const ARGB kcGold 			= 0xffffd700;
static const ARGB kcGoldenrod 		= 0xffdaa520;
static const ARGB kcGray 			= 0xff808080;
static const ARGB kcGreen 			= 0xff008000;
static const ARGB kcGreenYellow 	= 0xffadff2f;
static const ARGB kcHoneydew 		= 0xfff0fff0;
static const ARGB kcHotPink 		= 0xffff69b4;
static const ARGB kcIndianRed 		= 0xffcd5c5c;
static const ARGB kcIndigo 			= 0xff4b0082;
static const ARGB kcIvory 			= 0xfffffff0;
static const ARGB kcKhaki 			= 0xfff0e68c;
static const ARGB kcLavender 		= 0xffe6e6fa;
static const ARGB kcLavenderBlush 	= 0xfffff0f5;
static const ARGB kcLawnGreen 		= 0xff7cfc00;
static const ARGB kcLemonChiffon 	= 0xfffffacd;
static const ARGB kcLightBlue 		= 0xffadd8e6;
static const ARGB kcLightCoral 		= 0xfff08080;
static const ARGB kcLightCyan 		= 0xffe0ffff;
static const ARGB kcLightGoldenrodYellow = 0xfffafad2;
static const ARGB kcLightGray 		= 0xffd3d3d3;
static const ARGB kcLightGreen 		= 0xff90ee90;
static const ARGB kcLightPink 		= 0xffffb6c1;
static const ARGB kcLightSalmon 	= 0xffffa07a;
static const ARGB kcLightSeaGreen 	= 0xff20b2aa;
static const ARGB kcLightSkyBlue 	= 0xff87cefa;
static const ARGB kcLightSlateGray 	= 0xff778899;
static const ARGB kcLightSteelBlue 	= 0xffb0c4de;
static const ARGB kcLightYellow 	= 0xffffffe0;
static const ARGB kcLime 			= 0xff00ff00;
static const ARGB kcLimeGreen 		= 0xff32cd32;
static const ARGB kcLinen 			= 0xfffaf0e6;
static const ARGB kcMagenta 		= 0xffff00ff;
static const ARGB kcMaroon 			= 0xff800000;
static const ARGB kcMediumAquamarine = 0xff66cdaa;
static const ARGB kcMediumBlue 		= 0xff0000cd;
static const ARGB kcMediumOrchid 	= 0xffba55d3;
static const ARGB kcMediumPurple 	= 0xff9370db;
static const ARGB kcMediumSeaGreen 	= 0xff3cb371;
static const ARGB kcMediumSlateBlue = 0xff7b68ee;
static const ARGB kcMediumSpringGreen = 0xff00fa9a;
static const ARGB kcMediumTurquoise = 0xff48d1cc;
static const ARGB kcMediumVioletRed = 0xffc71585;
static const ARGB kcMidnightBlue 	= 0xff191970;
static const ARGB kcMintCream 		= 0xfff5fffa;
static const ARGB kcMistyRose 		= 0xffffe4e1;
static const ARGB kcMoccasin 		= 0xffffe4b5;
static const ARGB kcNavajoWhite 	= 0xffffdead;
static const ARGB kcNavy 			= 0xff000080;
static const ARGB kcOldLace 		= 0xfffdf5e6;
static const ARGB kcOlive 			= 0xff808000;
static const ARGB kcOliveDrab 		= 0xff6b8e23;
static const ARGB kcOrange 			= 0xffffa500;
static const ARGB kcOrangeRed 		= 0xffff4500;
static const ARGB kcOrchid 			= 0xffda70d6;
static const ARGB kcPaleGoldenrod 	= 0xffeee8aa;
static const ARGB kcPaleGreen 		= 0xff98fb98;
static const ARGB kcPaleTurquoise 	= 0xffafeeee;
static const ARGB kcPaleVioletRed 	= 0xffdb7093;
static const ARGB kcPapayaWhip 		= 0xffffefd5;
static const ARGB kcPeachPuff 		= 0xffffdab9;
static const ARGB kcPeru 			= 0xffcd853f;
static const ARGB kcPink 			= 0xffffc0cb;
static const ARGB kcPlum 			= 0xffdda0dd;
static const ARGB kcPowderBlue 		= 0xffb0e0e6;
static const ARGB kcPurple 			= 0xff800080;
static const ARGB kcRed 			= 0xffff0000;
static const ARGB kcRosyBrown 		= 0xffbc8f8f;
static const ARGB kcRoyalBlue 		= 0xff4169e1;
static const ARGB kcSaddleBrown 	= 0xff8b4513;
static const ARGB kcSalmon 			= 0xfffa8072;
static const ARGB kcSandyBrown 		= 0xfff4a460;
static const ARGB kcSeaGreen 		= 0xff2e8b57;
static const ARGB kcSeaShell 		= 0xfffff5ee;
static const ARGB kcSienna 			= 0xffa0522d;
static const ARGB kcSilver 			= 0xffc0c0c0;
static const ARGB kcSkyBlue 		= 0xff87ceeb;
static const ARGB kcSlateBlue 		= 0xff6a5acd;
static const ARGB kcSlateGray 		= 0xff708090;
static const ARGB kcSnow 			= 0xfffffafa;
static const ARGB kcSpringGreen 	= 0xff00ff7f;
static const ARGB kcSteelBlue 		= 0xff4682b4;
static const ARGB kcTan 			= 0xffd2b48c;
static const ARGB kcTeal 			= 0xff008080;
static const ARGB kcThistle 		= 0xffd8bfd8;
static const ARGB kcTomato 			= 0xffff6347;
static const ARGB kcTransparent 	= 0x00ffffff;
static const ARGB kcTurquoise 		= 0xff40e0d0;
static const ARGB kcViolet 			= 0xffee82ee;
static const ARGB kcWheat 			= 0xfff5deb3;
static const ARGB kcWhite 			= 0xffffffff;
static const ARGB kcWhiteSmoke 		= 0xfff5f5f5;
static const ARGB kcYellow 			= 0xffffff00;
static const ARGB kcYellowGreen 	= 0xff9acd32;

//----------------------------------------------------------------------------
// Color
//----------------------------------------------------------------------------

struct TIdentMap : public TIdentMapEntry
{
	TIdentMap(ARGB argb, CHAR *name){ Value = (int)argb; Name = name; }
};

class Color
{
	friend	bool __fastcall IdentToARGB(String, int&);
	friend	bool __fastcall ARGBToIdent(int, String&);
	friend	void __fastcall GetARGBValues(TGetStrProc);
	
private:
	union
	{
		ARGB FARGB;
		struct
		{
			BYTE FBlue;
			BYTE FGreen;
            BYTE FRed;
			BYTE FAlpha;
		};
	};
	static TIdentMap KnownColors[];

    void MakeARGB(BYTE a, BYTE r, BYTE g, BYTE b)
	{
		FARGB = (a << 24) | (r << 16) | (g << 8) | b;
	}
	void MakeARGB(BYTE a, Graphics::TColor color)
    {
        if (color < 0)
            color = (Graphics::TColor)GetSysColor(color & 0xFF);
        MakeARGB(a, GetRValue(color), GetGValue(color), GetBValue(color) );
	}
	COLORREF GetCOLORREF()
    {
        return RGB(FRed, FGreen, FBlue);
	}

	AnsiString GetKnownName(void)
    {
		return ARGBToString(FARGB);
    }

public:

    Color(){ FARGB = 0; }
	Color(const Color &color){ FARGB = color.FARGB; }
	Color(ARGB argb){ FARGB = argb; }
	Color(BYTE alpha, ARGB argb){ FARGB = argb; FAlpha = alpha; }
	Color(BYTE r, BYTE g, BYTE b){ MakeARGB(255, r, g, b); }
	Color(BYTE a, BYTE r, BYTE g, BYTE b){ MakeARGB(a, r, g, b); }
	Color(BYTE alpha, Graphics::TColor color){ MakeARGB(alpha, color); }
	Color(Graphics::TColor color){ MakeARGB(255, color); }
	Color(AnsiString Name, BYTE Alpha = 255){ FARGB = StringToARGB(Name, Alpha); }

	static Color FromTColor(BYTE alpha, Graphics::TColor color){ return Color(alpha, color); }
	static Color FromTColor(Graphics::TColor color){ return Color(color); }
	static Color FromArgb(ARGB argb){ return Color(argb); }
    static Color FromArgb(BYTE alpha, ARGB argb){ return Color(alpha, argb); }
    static Color FromArgb(BYTE r, BYTE g, BYTE b){ return Color(r, g, b); }
	static Color FromArgb(BYTE a, BYTE r, BYTE g, BYTE b){ return Color(a, r, g, b); }
	static Color FromName(AnsiString Name, BYTE Alpha = 255){ return Color(Name, Alpha); }
	static Color FromCOLORREF(BYTE alpha, COLORREF rgb)
    {
        return Color(alpha, GetRValue(rgb), GetGValue(rgb), GetBValue(rgb) );
    }
    static Color FromCOLORREF(COLORREF rgb){ return FromCOLORREF(255, rgb); }

    bool IsEmpty(){ return FARGB = 0; }
    Color& operator = (Color c)
    {
      FARGB = c.FARGB;
      return *this;
	}
	Color& operator = (ARGB c)
    {
      FARGB = c;
      return *this;
	}

	bool operator == (Color& c){ return FARGB == c.FARGB; }
	bool operator != (Color& c){ return !(*this == c); }

//	operator ARGB (){ return FARGB; }
//	operator ARGB*(){ return &FARGB; }

	static ARGB StringToARGB(String Name, BYTE Alpha = 255);
	static String ARGBToString(ARGB argb);

    __property ARGB Argb = { read = FARGB };
    __property BYTE Alpha = { read = FAlpha };
    __property BYTE A = { read = FAlpha };
    __property BYTE Red = { read = FRed };
    __property BYTE R = { read = FRed };
    __property BYTE Green = { read = FGreen };
    __property BYTE G = { read = FGreen };
    __property BYTE Blue = { read = FBlue };
    __property BYTE B = { read = FBlue };
    __property COLORREF Rgb = { read = GetCOLORREF };
	__property AnsiString Name = { read = GetKnownName };

};

TIdentMap Color::KnownColors[] =
{
	TIdentMap(kcAliceBlue, 			"kcAliceBlue"),
	TIdentMap(kcAntiqueWhite, 		"kcAntiqueWhite"),
	TIdentMap(kcAqua, 				"kcAqua"),
	TIdentMap(kcAquamarine, 		"kcAquamarine"),
	TIdentMap(kcAzure, 				"kcAzure"),
	TIdentMap(kcBeige, 				"kcBeige"),
	TIdentMap(kcBisque, 			"kcBisque"),
	TIdentMap(kcBlack, 				"kcBlack"),
	TIdentMap(kcBlanchedAlmond, 	"kcBlanchedAlmond"),
	TIdentMap(kcBlue, 				"kcBlue"),
	TIdentMap(kcBlueViolet, 		"kcBlueViolet"),
	TIdentMap(kcBrown, 				"kcBrown"),
	TIdentMap(kcBurlyWood, 			"kcBurlyWood"),
	TIdentMap(kcCadetBlue, 			"kcCadetBlue"),
	TIdentMap(kcChartreuse, 		"kcChartreuse"),
	TIdentMap(kcChocolate, 			"kcChocolate"),
	TIdentMap(kcCoral, 				"kcCoral"),
	TIdentMap(kcCornflowerBlue, 	"kcCornflowerBlue"),
	TIdentMap(kcCornsilk, 			"kcCornsilk"),
	TIdentMap(kcCrimson, 			"kcCrimson"),
	TIdentMap(kcCyan, 				"kcCyan"),
	TIdentMap(kcDarkBlue, 			"kcDarkBlue"),
	TIdentMap(kcDarkCyan, 			"kcDarkCyan"),
	TIdentMap(kcDarkGoldenrod, 		"kcDarkGoldenrod"),
	TIdentMap(kcDarkGray, 			"kcDarkGray"),
	TIdentMap(kcDarkGreen, 			"kcDarkGreen"),
	TIdentMap(kcDarkKhaki, 			"kcDarkKhaki"),
	TIdentMap(kcDarkMagenta, 		"kcDarkMagenta"),
	TIdentMap(kcDarkOliveGreen, 	"kcDarkOliveGreen"),
	TIdentMap(kcDarkOrange, 		"kcDarkOrange"),
	TIdentMap(kcDarkOrchid, 		"kcDarkOrchid"),
	TIdentMap(kcDarkRed, 			"kcDarkRed"),
	TIdentMap(kcDarkSalmon, 		"kcDarkSalmon"),
	TIdentMap(kcDarkSeaGreen, 		"kcDarkSeaGreen"),
	TIdentMap(kcDarkSlateBlue, 		"kcDarkSlateBlue"),
	TIdentMap(kcDarkSlateGray, 		"kcDarkSlateGray"),
	TIdentMap(kcDarkTurquoise, 		"kcDarkTurquoise"),
	TIdentMap(kcDarkViolet, 		"kcDarkViolet"),
	TIdentMap(kcDeepPink, 			"kcDeepPink"),
	TIdentMap(kcDeepSkyBlue, 		"kcDeepSkyBlue"),
	TIdentMap(kcDimGray, 			"kcDimGray"),
	TIdentMap(kcDodgerBlue, 		"kcDodgerBlue"),
	TIdentMap(kcFirebrick, 			"kcFirebrick"),
	TIdentMap(kcFloralWhite, 		"kcFloralWhite"),
	TIdentMap(kcForestGreen, 		"kcForestGreen"),
	TIdentMap(kcFuchsia, 			"kcFuchsia"),
	TIdentMap(kcGainsboro, 			"kcGainsboro"),
	TIdentMap(kcGhostWhite, 		"kcGhostWhite"),
	TIdentMap(kcGold, 				"kcGold"),
	TIdentMap(kcGoldenrod, 			"kcGoldenrod"),
	TIdentMap(kcGray, 				"kcGray"),
	TIdentMap(kcGreen, 				"kcGreen"),
	TIdentMap(kcGreenYellow, 		"kcGreenYellow"),
	TIdentMap(kcHoneydew, 			"kcHoneydew"),
	TIdentMap(kcHotPink, 			"kcHotPink"),
	TIdentMap(kcIndianRed, 			"kcIndianRed"),
	TIdentMap(kcIndigo, 			"kcIndigo"),
	TIdentMap(kcIvory, 				"kcIvory"),
	TIdentMap(kcKhaki, 				"kcKhaki"),
	TIdentMap(kcLavender, 			"kcLavender"),
	TIdentMap(kcLavenderBlush, 		"kcLavenderBlush"),
	TIdentMap(kcLawnGreen, 			"kcLawnGreen"),
	TIdentMap(kcLemonChiffon, 		"kcLemonChiffon"),
	TIdentMap(kcLightBlue, 			"kcLightBlue"),
	TIdentMap(kcLightCoral, 		"kcLightCoral"),
	TIdentMap(kcLightCyan, 			"kcLightCyan"),
	TIdentMap(kcLightGoldenrodYellow, "kcLightGoldenrodYellow"),
	TIdentMap(kcLightGray, 			"kcLightGray"),
	TIdentMap(kcLightGreen, 		"kcLightGreen"),
	TIdentMap(kcLightPink, 			"kcLightPink"),
	TIdentMap(kcLightSalmon, 		"kcLightSalmon"),
	TIdentMap(kcLightSeaGreen, 		"kcLightSeaGreen"),
	TIdentMap(kcLightSkyBlue, 		"kcLightSkyBlue"),
	TIdentMap(kcLightSlateGray, 	"kcLightSlateGray"),
	TIdentMap(kcLightSteelBlue, 	"kcLightSteelBlue"),
	TIdentMap(kcLightYellow, 		"kcLightYellow"),
	TIdentMap(kcLime, 				"kcLime"),
	TIdentMap(kcLimeGreen, 			"kcLimeGreen"),
	TIdentMap(kcLinen, 				"kcLinen"),
	TIdentMap(kcMagenta, 			"kcMagenta"),
	TIdentMap(kcMaroon, 			"kcMaroon"),
	TIdentMap(kcMediumAquamarine, 	"kcMediumAquamarine"),
	TIdentMap(kcMediumBlue, 		"kcMediumBlue"),
	TIdentMap(kcMediumOrchid, 		"kcMediumOrchid"),
	TIdentMap(kcMediumPurple, 		"kcMediumPurple"),
	TIdentMap(kcMediumSeaGreen, 	"kcMediumSeaGreen"),
	TIdentMap(kcMediumSlateBlue, 	"kcMediumSlateBlue"),
	TIdentMap(kcMediumSpringGreen, 	"kcMediumSpringGreen"),
	TIdentMap(kcMediumTurquoise, 	"kcMediumTurquoise"),
	TIdentMap(kcMediumVioletRed, 	"kcMediumVioletRed"),
	TIdentMap(kcMidnightBlue, 		"kcMidnightBlue"),
	TIdentMap(kcMintCream, 			"kcMintCream"),
	TIdentMap(kcMistyRose, 			"kcMistyRose"),
	TIdentMap(kcMoccasin, 			"kcMoccasin"),
	TIdentMap(kcNavajoWhite, 		"kcNavajoWhite"),
	TIdentMap(kcNavy, 				"kcNavy"),
	TIdentMap(kcOldLace, 			"kcOldLace"),
	TIdentMap(kcOlive, 				"kcOlive"),
	TIdentMap(kcOliveDrab, 			"kcOliveDrab"),
	TIdentMap(kcOrange, 			"kcOrange"),
	TIdentMap(kcOrangeRed, 			"kcOrangeRed"),
	TIdentMap(kcOrchid, 			"kcOrchid"),
	TIdentMap(kcPaleGoldenrod, 		"kcPaleGoldenrod"),
	TIdentMap(kcPaleGreen, 			"kcPaleGreen"),
	TIdentMap(kcPaleTurquoise, 		"kcPaleTurquoise"),
	TIdentMap(kcPaleVioletRed, 		"kcPaleVioletRed"),
	TIdentMap(kcPapayaWhip, 		"kcPapayaWhip"),
	TIdentMap(kcPeachPuff, 			"kcPeachPuff"),
	TIdentMap(kcPeru, 				"kcPeru"),
	TIdentMap(kcPink, 				"kcPink"),
	TIdentMap(kcPlum, 				"kcPlum"),
	TIdentMap(kcPowderBlue, 		"kcPowderBlue"),
	TIdentMap(kcPurple, 			"kcPurple"),
	TIdentMap(kcRed, 				"kcRed"),
	TIdentMap(kcRosyBrown, 			"kcRosyBrown"),
	TIdentMap(kcRoyalBlue, 			"kcRoyalBlue"),
	TIdentMap(kcSaddleBrown, 		"kcSaddleBrown"),
	TIdentMap(kcSalmon, 			"kcSalmon"),
	TIdentMap(kcSandyBrown, 		"kcSandyBrown"),
	TIdentMap(kcSeaGreen, 			"kcSeaGreen"),
	TIdentMap(kcSeaShell, 			"kcSeaShell"),
	TIdentMap(kcSienna, 			"kcSienna"),
	TIdentMap(kcSilver, 			"kcSilver"),
	TIdentMap(kcSkyBlue, 			"kcSkyBlue"),
	TIdentMap(kcSlateBlue, 			"kcSlateBlue"),
	TIdentMap(kcSlateGray, 			"kcSlateGray"),
	TIdentMap(kcSnow, 				"kcSnow"),
	TIdentMap(kcSpringGreen, 		"kcSpringGreen"),
	TIdentMap(kcSteelBlue, 			"kcSteelBlue"),
	TIdentMap(kcTan, 				"kcTan"),
	TIdentMap(kcTeal, 				"kcTeal"),
	TIdentMap(kcThistle, 			"kcThistle"),
	TIdentMap(kcTomato, 			"kcTomato"),
	TIdentMap(kcTransparent, 		"kcTransparent"),
	TIdentMap(kcTurquoise, 			"kcTurquoise"),
	TIdentMap(kcViolet, 			"kcViolet"),
	TIdentMap(kcWheat, 				"kcWheat"),
	TIdentMap(kcWhite, 				"kcWhite"),
	TIdentMap(kcWhiteSmoke, 		"kcWhiteSmoke"),
	TIdentMap(kcYellow, 			"kcYellow"),
	TIdentMap(kcYellowGreen, 		"kcYellowGreen")
};

bool __fastcall IdentToARGB(const String Ident, int &Argb)
{
	return IdentToInt(Ident, Argb, Color::KnownColors, KnownColorCount);
}
bool __fastcall ARGBToIdent(int Argb, String &Ident)
{
	return IntToIdent(Argb, Ident, Color::KnownColors, KnownColorCount);
}

void __fastcall GetARGBValues(TGetStrProc Proc)
{
	for (int i = 0; i < KnownColorCount; i ++)
		Proc(Color::KnownColors[i].Name);
}

inline
static ARGB Color::StringToARGB(String Name, BYTE Alpha)
{
		int v;
		if (!IdentToARGB(Name, v))
			v = StrToInt(Name);
		return (ARGB)(Alpha == 255? v : (v & 0xFFFFFF) | Alpha);
}
inline
static String Color::ARGBToString(ARGB argb)
{
		String s;
		if (!ARGBToIdent(argb, s))
		{
            TVarRec v = (int)argb;
			s = Format("0x%.8x", &v, 0);
		}
		return s;
}

#pragma option pop /*P_O_Pop*/
#endif

