/**************************************************************************\
*
* Module Name:
*
*   GdipObjs.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipObjsHPP
#define GdipObjsHPP

class TGpPens
{

private:
	TGpPen* FPen;
	TGpColor FColor;
	float FWidth;
	TGpPen* GetPen(TGpColor color, float AWidth)
	{
		if (FColor != color)
		{
			FColor = color;
			GdipSetPenColor(FPen->Native, FColor.Argb);
		}
		if (FWidth != AWidth)
		{
			FWidth = AWidth;
			GdipSetPenWidth(FPen->Native, FWidth);
		}
        return FPen;
    }
	TGpPen* GetDefinePen(int Index){ return GetPen((TARGB)Index, 1.0); }
	
public:
	TGpPens(void) : FColor(kcBlack), FWidth(1.0)
	{
		FPen = new TGpPen(TGpColor(FColor));
	}
	~TGpPens(void){ delete FPen; }
	TGpPen* operator[](TGpColor color){ return GetPen(color, 1.0); }
	TGpPen* operator()(TGpColor color, float AWidth)
	{
		return GetPen(color, AWidth);
    }
//	__property TGpPen* Pen[TGpColor color][float AWidth] = {read=GetPen};
	__property TGpPen* AliceBlue = {read=GetDefinePen, index=kcAliceBlue/*-984833*/};
	__property TGpPen* AntiqueWhite = {read=GetDefinePen, index=-332841};
	__property TGpPen* Aqua = {read=GetDefinePen, index=-16711681};
	__property TGpPen* Aquamarine = {read=GetDefinePen, index=-8388652};
	__property TGpPen* Azure = {read=GetDefinePen, index=-983041};
	__property TGpPen* Beige = {read=GetDefinePen, index=-657956};
	__property TGpPen* Bisque = {read=GetDefinePen, index=-6972};
	__property TGpPen* Black = {read=GetDefinePen, index=-16777216};
	__property TGpPen* BlanchedAlmond = {read=GetDefinePen, index=-5171};
	__property TGpPen* Blue = {read=GetDefinePen, index=-16776961};
	__property TGpPen* BlueViolet = {read=GetDefinePen, index=-7722014};
	__property TGpPen* Brown = {read=GetDefinePen, index=-5952982};
	__property TGpPen* BurlyWood = {read=GetDefinePen, index=-2180985};
	__property TGpPen* CadetBlue = {read=GetDefinePen, index=-10510688};
	__property TGpPen* Chartreuse = {read=GetDefinePen, index=-8388864};
	__property TGpPen* Chocolate = {read=GetDefinePen, index=-2987746};
	__property TGpPen* Coral = {read=GetDefinePen, index=-32944};
	__property TGpPen* CornflowerBlue = {read=GetDefinePen, index=-10185235};
	__property TGpPen* Cornsilk = {read=GetDefinePen, index=-1828};
	__property TGpPen* Crimson = {read=GetDefinePen, index=-2354116};
	__property TGpPen* Cyan = {read=GetDefinePen, index=-16711681};
	__property TGpPen* DarkBlue = {read=GetDefinePen, index=-16777077};
	__property TGpPen* DarkCyan = {read=GetDefinePen, index=-16741493};
	__property TGpPen* DarkGoldenrod = {read=GetDefinePen, index=-4684277};
	__property TGpPen* DarkGray = {read=GetDefinePen, index=-5658199};
	__property TGpPen* DarkGreen = {read=GetDefinePen, index=-16751616};
	__property TGpPen* DarkKhaki = {read=GetDefinePen, index=-4343957};
	__property TGpPen* DarkMagenta = {read=GetDefinePen, index=-7667573};
	__property TGpPen* DarkOliveGreen = {read=GetDefinePen, index=-11179217};
	__property TGpPen* DarkOrange = {read=GetDefinePen, index=-29696};
	__property TGpPen* DarkOrchid = {read=GetDefinePen, index=-6737204};
	__property TGpPen* DarkRed = {read=GetDefinePen, index=-7667712};
	__property TGpPen* DarkSalmon = {read=GetDefinePen, index=-1468806};
	__property TGpPen* DarkSeaGreen = {read=GetDefinePen, index=-7357301};
	__property TGpPen* DarkSlateBlue = {read=GetDefinePen, index=-12042869};
	__property TGpPen* DarkSlateGray = {read=GetDefinePen, index=-13676721};
	__property TGpPen* DarkTurquoise = {read=GetDefinePen, index=-16724271};
	__property TGpPen* DarkViolet = {read=GetDefinePen, index=-7077677};
	__property TGpPen* DeepPink = {read=GetDefinePen, index=-60269};
	__property TGpPen* DeepSkyBlue = {read=GetDefinePen, index=-16728065};
	__property TGpPen* DimGray = {read=GetDefinePen, index=-9868951};
	__property TGpPen* DodgerBlue = {read=GetDefinePen, index=-14774017};
	__property TGpPen* Firebrick = {read=GetDefinePen, index=-5103070};
	__property TGpPen* FloralWhite = {read=GetDefinePen, index=-1296};
	__property TGpPen* ForestGreen = {read=GetDefinePen, index=-14513374};
	__property TGpPen* Fuchsia = {read=GetDefinePen, index=-65281};
	__property TGpPen* Gainsboro = {read=GetDefinePen, index=-2302756};
	__property TGpPen* GhostWhite = {read=GetDefinePen, index=-460545};
	__property TGpPen* Gold = {read=GetDefinePen, index=-10496};
	__property TGpPen* Goldenrod = {read=GetDefinePen, index=-2448096};
	__property TGpPen* Gray = {read=GetDefinePen, index=-8355712};
	__property TGpPen* Green = {read=GetDefinePen, index=-16744448};
	__property TGpPen* GreenYellow = {read=GetDefinePen, index=-5374161};
	__property TGpPen* Honeydew = {read=GetDefinePen, index=-983056};
	__property TGpPen* HotPink = {read=GetDefinePen, index=-38476};
	__property TGpPen* IndianRed = {read=GetDefinePen, index=-3318692};
	__property TGpPen* Indigo = {read=GetDefinePen, index=-11861886};
	__property TGpPen* Ivory = {read=GetDefinePen, index=-16};
	__property TGpPen* Khaki = {read=GetDefinePen, index=-989556};
	__property TGpPen* Lavender = {read=GetDefinePen, index=-1644806};
	__property TGpPen* LavenderBlush = {read=GetDefinePen, index=-3851};
	__property TGpPen* LawnGreen = {read=GetDefinePen, index=-8586240};
	__property TGpPen* LemonChiffon = {read=GetDefinePen, index=-1331};
	__property TGpPen* LightBlue = {read=GetDefinePen, index=-5383962};
	__property TGpPen* LightCoral = {read=GetDefinePen, index=-1015680};
	__property TGpPen* LightCyan = {read=GetDefinePen, index=-2031617};
	__property TGpPen* LightGoldenrodYellow = {read=GetDefinePen, index=-329006};
	__property TGpPen* LightGray = {read=GetDefinePen, index=-2894893};
	__property TGpPen* LightGreen = {read=GetDefinePen, index=-7278960};
	__property TGpPen* LightPink = {read=GetDefinePen, index=-18751};
	__property TGpPen* LightSalmon = {read=GetDefinePen, index=-24454};
	__property TGpPen* LightSeaGreen = {read=GetDefinePen, index=-14634326};
	__property TGpPen* LightSkyBlue = {read=GetDefinePen, index=-7876870};
	__property TGpPen* LightSlateGray = {read=GetDefinePen, index=-8943463};
	__property TGpPen* LightSteelBlue = {read=GetDefinePen, index=-5192482};
	__property TGpPen* LightYellow = {read=GetDefinePen, index=-32};
	__property TGpPen* Lime = {read=GetDefinePen, index=-16711936};
	__property TGpPen* LimeGreen = {read=GetDefinePen, index=-13447886};
	__property TGpPen* Linen = {read=GetDefinePen, index=-331546};
	__property TGpPen* Magenta = {read=GetDefinePen, index=-65281};
	__property TGpPen* Maroon = {read=GetDefinePen, index=-8388608};
	__property TGpPen* MediumAquamarine = {read=GetDefinePen, index=-10039894};
	__property TGpPen* MediumBlue = {read=GetDefinePen, index=-16777011};
	__property TGpPen* MediumOrchid = {read=GetDefinePen, index=-4565549};
	__property TGpPen* MediumPurple = {read=GetDefinePen, index=-7114533};
	__property TGpPen* MediumSeaGreen = {read=GetDefinePen, index=-12799119};
	__property TGpPen* MediumSlateBlue = {read=GetDefinePen, index=-8689426};
	__property TGpPen* MediumSpringGreen = {read=GetDefinePen, index=-16713062};
	__property TGpPen* MediumTurquoise = {read=GetDefinePen, index=-12004916};
	__property TGpPen* MediumVioletRed = {read=GetDefinePen, index=-3730043};
	__property TGpPen* MidnightBlue = {read=GetDefinePen, index=-15132304};
	__property TGpPen* MintCream = {read=GetDefinePen, index=-655366};
	__property TGpPen* MistyRose = {read=GetDefinePen, index=-6943};
	__property TGpPen* Moccasin = {read=GetDefinePen, index=-6987};
	__property TGpPen* NavajoWhite = {read=GetDefinePen, index=-8531};
	__property TGpPen* Navy = {read=GetDefinePen, index=-16777088};
	__property TGpPen* OldLace = {read=GetDefinePen, index=-133658};
	__property TGpPen* Olive = {read=GetDefinePen, index=-8355840};
	__property TGpPen* OliveDrab = {read=GetDefinePen, index=-9728477};
	__property TGpPen* Orange = {read=GetDefinePen, index=-23296};
	__property TGpPen* OrangeRed = {read=GetDefinePen, index=-47872};
	__property TGpPen* Orchid = {read=GetDefinePen, index=-2461482};
	__property TGpPen* PaleGoldenrod = {read=GetDefinePen, index=-1120086};
	__property TGpPen* PaleGreen = {read=GetDefinePen, index=-6751336};
	__property TGpPen* PaleTurquoise = {read=GetDefinePen, index=-5247250};
	__property TGpPen* PaleVioletRed = {read=GetDefinePen, index=-2396013};
	__property TGpPen* PapayaWhip = {read=GetDefinePen, index=-4139};
	__property TGpPen* PeachPuff = {read=GetDefinePen, index=-9543};
	__property TGpPen* Peru = {read=GetDefinePen, index=-3308225};
	__property TGpPen* Pink = {read=GetDefinePen, index=-16181};
	__property TGpPen* Plum = {read=GetDefinePen, index=-2252579};
	__property TGpPen* PowderBlue = {read=GetDefinePen, index=-5185306};
	__property TGpPen* Purple = {read=GetDefinePen, index=-8388480};
	__property TGpPen* Red = {read=GetDefinePen, index=-65536};
	__property TGpPen* RosyBrown = {read=GetDefinePen, index=-4419697};
	__property TGpPen* RoyalBlue = {read=GetDefinePen, index=-12490271};
	__property TGpPen* SaddleBrown = {read=GetDefinePen, index=-7650029};
	__property TGpPen* Salmon = {read=GetDefinePen, index=-360334};
	__property TGpPen* SandyBrown = {read=GetDefinePen, index=-744352};
	__property TGpPen* SeaGreen = {read=GetDefinePen, index=-13726889};
	__property TGpPen* SeaShell = {read=GetDefinePen, index=-2578};
	__property TGpPen* Sienna = {read=GetDefinePen, index=-6270419};
	__property TGpPen* Silver = {read=GetDefinePen, index=-4144960};
	__property TGpPen* SkyBlue = {read=GetDefinePen, index=-7876885};
	__property TGpPen* SlateBlue = {read=GetDefinePen, index=-9807155};
	__property TGpPen* SlateGray = {read=GetDefinePen, index=-9404272};
	__property TGpPen* Snow = {read=GetDefinePen, index=-1286};
	__property TGpPen* SpringGreen = {read=GetDefinePen, index=-16711809};
	__property TGpPen* SteelBlue = {read=GetDefinePen, index=-12156236};
	__property TGpPen* Tan = {read=GetDefinePen, index=-2968436};
	__property TGpPen* Teal = {read=GetDefinePen, index=-16744320};
	__property TGpPen* Thistle = {read=GetDefinePen, index=-2572328};
	__property TGpPen* Tomato = {read=GetDefinePen, index=-40121};
	__property TGpPen* Transparent = {read=GetDefinePen, index=16777215};
	__property TGpPen* Turquoise = {read=GetDefinePen, index=-12525360};
	__property TGpPen* Violet = {read=GetDefinePen, index=-1146130};
	__property TGpPen* Wheat = {read=GetDefinePen, index=-663885};
	__property TGpPen* White = {read=GetDefinePen, index=-1};
	__property TGpPen* WhiteSmoke = {read=GetDefinePen, index=-657931};
	__property TGpPen* Yellow = {read=GetDefinePen, index=-256};
	__property TGpPen* YellowGreen = {read=GetDefinePen, index=-6632142};
};

class TGpBrushs
{

private:
	TGpBrush* FBrush;
	TGpColor FColor;
	TGpBrush*  GetDefineBrush(const int Index){ return GetBrush(TGpColor((TARGB)Index)); }
	TGpBrush* GetBrush(TGpColor AColor)
	{
		if (FColor != AColor)
		{
			FColor = AColor;
			GdipSetSolidFillColor(FBrush->Native, FColor.Argb);
        }
		return FBrush;
	}

public:
	TGpBrushs(void){ FBrush = new TGpSolidBrush(TGpColor(kcBlack)); }
	~TGpBrushs(void){ delete FBrush; }
	TGpBrush* operator[](TGpColor AColor) { return GetBrush(AColor); }
	__property TGpBrush* Brush[TGpColor AColor] = {read=GetBrush/*, default*/};
	__property TGpBrush* AliceBlue = {read=GetDefineBrush, index=-984833};
	__property TGpBrush* AntiqueWhite = {read=GetDefineBrush, index=-332841};
	__property TGpBrush* Aqua = {read=GetDefineBrush, index=-16711681};
	__property TGpBrush* Aquamarine = {read=GetDefineBrush, index=-8388652};
	__property TGpBrush* Azure = {read=GetDefineBrush, index=-983041};
	__property TGpBrush* Beige = {read=GetDefineBrush, index=-657956};
	__property TGpBrush* Bisque = {read=GetDefineBrush, index=-6972};
	__property TGpBrush* Black = {read=GetDefineBrush, index=-16777216};
	__property TGpBrush* BlanchedAlmond = {read=GetDefineBrush, index=-5171};
	__property TGpBrush* Blue = {read=GetDefineBrush, index=-16776961};
	__property TGpBrush* BlueViolet = {read=GetDefineBrush, index=-7722014};
	__property TGpBrush* Brown = {read=GetDefineBrush, index=-5952982};
	__property TGpBrush* BurlyWood = {read=GetDefineBrush, index=-2180985};
	__property TGpBrush* CadetBlue = {read=GetDefineBrush, index=-10510688};
	__property TGpBrush* Chartreuse = {read=GetDefineBrush, index=-8388864};
	__property TGpBrush* Chocolate = {read=GetDefineBrush, index=-2987746};
	__property TGpBrush* Coral = {read=GetDefineBrush, index=-32944};
	__property TGpBrush* CornflowerBlue = {read=GetDefineBrush, index=-10185235};
	__property TGpBrush* Cornsilk = {read=GetDefineBrush, index=-1828};
	__property TGpBrush* Crimson = {read=GetDefineBrush, index=-2354116};
	__property TGpBrush* Cyan = {read=GetDefineBrush, index=-16711681};
	__property TGpBrush* DarkBlue = {read=GetDefineBrush, index=-16777077};
	__property TGpBrush* DarkCyan = {read=GetDefineBrush, index=-16741493};
	__property TGpBrush* DarkGoldenrod = {read=GetDefineBrush, index=-4684277};
	__property TGpBrush* DarkGray = {read=GetDefineBrush, index=-5658199};
	__property TGpBrush* DarkGreen = {read=GetDefineBrush, index=-16751616};
	__property TGpBrush* DarkKhaki = {read=GetDefineBrush, index=-4343957};
	__property TGpBrush* DarkMagenta = {read=GetDefineBrush, index=-7667573};
	__property TGpBrush* DarkOliveGreen = {read=GetDefineBrush, index=-11179217};
	__property TGpBrush* DarkOrange = {read=GetDefineBrush, index=-29696};
	__property TGpBrush* DarkOrchid = {read=GetDefineBrush, index=-6737204};
	__property TGpBrush* DarkRed = {read=GetDefineBrush, index=-7667712};
	__property TGpBrush* DarkSalmon = {read=GetDefineBrush, index=-1468806};
	__property TGpBrush* DarkSeaGreen = {read=GetDefineBrush, index=-7357301};
	__property TGpBrush* DarkSlateBlue = {read=GetDefineBrush, index=-12042869};
	__property TGpBrush* DarkSlateGray = {read=GetDefineBrush, index=-13676721};
	__property TGpBrush* DarkTurquoise = {read=GetDefineBrush, index=-16724271};
	__property TGpBrush* DarkViolet = {read=GetDefineBrush, index=-7077677};
	__property TGpBrush* DeepPink = {read=GetDefineBrush, index=-60269};
	__property TGpBrush* DeepSkyBlue = {read=GetDefineBrush, index=-16728065};
	__property TGpBrush* DimGray = {read=GetDefineBrush, index=-9868951};
	__property TGpBrush* DodgerBlue = {read=GetDefineBrush, index=-14774017};
	__property TGpBrush* Firebrick = {read=GetDefineBrush, index=-5103070};
	__property TGpBrush* FloralWhite = {read=GetDefineBrush, index=-1296};
	__property TGpBrush* ForestGreen = {read=GetDefineBrush, index=-14513374};
	__property TGpBrush* Fuchsia = {read=GetDefineBrush, index=-65281};
	__property TGpBrush* Gainsboro = {read=GetDefineBrush, index=-2302756};
	__property TGpBrush* GhostWhite = {read=GetDefineBrush, index=-460545};
	__property TGpBrush* Gold = {read=GetDefineBrush, index=-10496};
	__property TGpBrush* Goldenrod = {read=GetDefineBrush, index=-2448096};
	__property TGpBrush* Gray = {read=GetDefineBrush, index=-8355712};
	__property TGpBrush* Green = {read=GetDefineBrush, index=-16744448};
	__property TGpBrush* GreenYellow = {read=GetDefineBrush, index=-5374161};
	__property TGpBrush* Honeydew = {read=GetDefineBrush, index=-983056};
	__property TGpBrush* HotPink = {read=GetDefineBrush, index=-38476};
	__property TGpBrush* IndianRed = {read=GetDefineBrush, index=-3318692};
	__property TGpBrush* Indigo = {read=GetDefineBrush, index=-11861886};
	__property TGpBrush* Ivory = {read=GetDefineBrush, index=-16};
	__property TGpBrush* Khaki = {read=GetDefineBrush, index=-989556};
	__property TGpBrush* Lavender = {read=GetDefineBrush, index=-1644806};
	__property TGpBrush* LavenderBlush = {read=GetDefineBrush, index=-3851};
	__property TGpBrush* LawnGreen = {read=GetDefineBrush, index=-8586240};
	__property TGpBrush* LemonChiffon = {read=GetDefineBrush, index=-1331};
	__property TGpBrush* LightBlue = {read=GetDefineBrush, index=-5383962};
	__property TGpBrush* LightCoral = {read=GetDefineBrush, index=-1015680};
	__property TGpBrush* LightCyan = {read=GetDefineBrush, index=-2031617};
	__property TGpBrush* LightGoldenrodYellow = {read=GetDefineBrush, index=-329006};
	__property TGpBrush* LightGray = {read=GetDefineBrush, index=-2894893};
	__property TGpBrush* LightGreen = {read=GetDefineBrush, index=-7278960};
	__property TGpBrush* LightPink = {read=GetDefineBrush, index=-18751};
	__property TGpBrush* LightSalmon = {read=GetDefineBrush, index=-24454};
	__property TGpBrush* LightSeaGreen = {read=GetDefineBrush, index=-14634326};
	__property TGpBrush* LightSkyBlue = {read=GetDefineBrush, index=-7876870};
	__property TGpBrush* LightSlateGray = {read=GetDefineBrush, index=-8943463};
	__property TGpBrush* LightSteelBlue = {read=GetDefineBrush, index=-5192482};
	__property TGpBrush* LightYellow = {read=GetDefineBrush, index=-32};
	__property TGpBrush* Lime = {read=GetDefineBrush, index=-16711936};
	__property TGpBrush* LimeGreen = {read=GetDefineBrush, index=-13447886};
	__property TGpBrush* Linen = {read=GetDefineBrush, index=-331546};
	__property TGpBrush* Magenta = {read=GetDefineBrush, index=-65281};
	__property TGpBrush* Maroon = {read=GetDefineBrush, index=-8388608};
	__property TGpBrush* MediumAquamarine = {read=GetDefineBrush, index=-10039894};
	__property TGpBrush* MediumBlue = {read=GetDefineBrush, index=-16777011};
	__property TGpBrush* MediumOrchid = {read=GetDefineBrush, index=-4565549};
	__property TGpBrush* MediumPurple = {read=GetDefineBrush, index=-7114533};
	__property TGpBrush* MediumSeaGreen = {read=GetDefineBrush, index=-12799119};
	__property TGpBrush* MediumSlateBlue = {read=GetDefineBrush, index=-8689426};
	__property TGpBrush* MediumSpringGreen = {read=GetDefineBrush, index=-16713062};
	__property TGpBrush* MediumTurquoise = {read=GetDefineBrush, index=-12004916};
	__property TGpBrush* MediumVioletRed = {read=GetDefineBrush, index=-3730043};
	__property TGpBrush* MidnightBlue = {read=GetDefineBrush, index=-15132304};
	__property TGpBrush* MintCream = {read=GetDefineBrush, index=-655366};
	__property TGpBrush* MistyRose = {read=GetDefineBrush, index=-6943};
	__property TGpBrush* Moccasin = {read=GetDefineBrush, index=-6987};
	__property TGpBrush* NavajoWhite = {read=GetDefineBrush, index=-8531};
	__property TGpBrush* Navy = {read=GetDefineBrush, index=-16777088};
	__property TGpBrush* OldLace = {read=GetDefineBrush, index=-133658};
	__property TGpBrush* Olive = {read=GetDefineBrush, index=-8355840};
	__property TGpBrush* OliveDrab = {read=GetDefineBrush, index=-9728477};
	__property TGpBrush* Orange = {read=GetDefineBrush, index=-23296};
	__property TGpBrush* OrangeRed = {read=GetDefineBrush, index=-47872};
	__property TGpBrush* Orchid = {read=GetDefineBrush, index=-2461482};
	__property TGpBrush* PaleGoldenrod = {read=GetDefineBrush, index=-1120086};
	__property TGpBrush* PaleGreen = {read=GetDefineBrush, index=-6751336};
	__property TGpBrush* PaleTurquoise = {read=GetDefineBrush, index=-5247250};
	__property TGpBrush* PaleVioletRed = {read=GetDefineBrush, index=-2396013};
	__property TGpBrush* PapayaWhip = {read=GetDefineBrush, index=-4139};
	__property TGpBrush* PeachPuff = {read=GetDefineBrush, index=-9543};
	__property TGpBrush* Peru = {read=GetDefineBrush, index=-3308225};
	__property TGpBrush* Pink = {read=GetDefineBrush, index=-16181};
	__property TGpBrush* Plum = {read=GetDefineBrush, index=-2252579};
	__property TGpBrush* PowderBlue = {read=GetDefineBrush, index=-5185306};
	__property TGpBrush* Purple = {read=GetDefineBrush, index=-8388480};
	__property TGpBrush* Red = {read=GetDefineBrush, index=-65536};
	__property TGpBrush* RosyBrown = {read=GetDefineBrush, index=-4419697};
	__property TGpBrush* RoyalBlue = {read=GetDefineBrush, index=-12490271};
	__property TGpBrush* SaddleBrown = {read=GetDefineBrush, index=-7650029};
	__property TGpBrush* Salmon = {read=GetDefineBrush, index=-360334};
	__property TGpBrush* SandyBrown = {read=GetDefineBrush, index=-744352};
	__property TGpBrush* SeaGreen = {read=GetDefineBrush, index=-13726889};
	__property TGpBrush* SeaShell = {read=GetDefineBrush, index=-2578};
	__property TGpBrush* Sienna = {read=GetDefineBrush, index=-6270419};
	__property TGpBrush* Silver = {read=GetDefineBrush, index=-4144960};
	__property TGpBrush* SkyBlue = {read=GetDefineBrush, index=-7876885};
	__property TGpBrush* SlateBlue = {read=GetDefineBrush, index=-9807155};
	__property TGpBrush* SlateGray = {read=GetDefineBrush, index=-9404272};
	__property TGpBrush* Snow = {read=GetDefineBrush, index=-1286};
	__property TGpBrush* SpringGreen = {read=GetDefineBrush, index=-16711809};
	__property TGpBrush* SteelBlue = {read=GetDefineBrush, index=-12156236};
	__property TGpBrush* Tan = {read=GetDefineBrush, index=-2968436};
	__property TGpBrush* Teal = {read=GetDefineBrush, index=-16744320};
	__property TGpBrush* Thistle = {read=GetDefineBrush, index=-2572328};
	__property TGpBrush* Tomato = {read=GetDefineBrush, index=-40121};
	__property TGpBrush* Transparent = {read=GetDefineBrush, index=16777215};
	__property TGpBrush* Turquoise = {read=GetDefineBrush, index=-12525360};
	__property TGpBrush* Violet = {read=GetDefineBrush, index=-1146130};
	__property TGpBrush* Wheat = {read=GetDefineBrush, index=-663885};
	__property TGpBrush* White = {read=GetDefineBrush, index=-1};
	__property TGpBrush* WhiteSmoke = {read=GetDefineBrush, index=-657931};
	__property TGpBrush* Yellow = {read=GetDefineBrush, index=-256};
	__property TGpBrush* YellowGreen = {read=GetDefineBrush, index=-6632142};
};

static TGpPens Pens;
static TGpBrushs Brushs;

#endif
 