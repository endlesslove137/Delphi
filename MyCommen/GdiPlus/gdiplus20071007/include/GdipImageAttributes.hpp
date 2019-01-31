/**************************************************************************\
*
* Module Name:
*
*   GdipImageAttributes.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipImageAttributesHPP
#define GdipImageAttributesHPP

//--------------------------------------------------------------------------
// ImageAttributes 对象包含有关在呈现时如何操作位图和图元文件颜色的信息。
//  维护多个颜色调整设置，包括颜色调整矩阵、灰度调整矩阵、伽玛校正值、
//  颜色映射表和颜色阈值。呈现过程中，可以对颜色进行校正、调暗、调亮或删除等等。
//--------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Color Matrix flags
//----------------------------------------------------------------------------

enum TColorMatrixFlags
{
	cfDefault,  // 调整所有的颜色值（包括灰色底纹）。
	cfSkipGrays,// 调整颜色但不调整灰色底纹。
	cfAltGray
};

//----------------------------------------------------------------------------
// Color Adjust Type
//----------------------------------------------------------------------------

enum TColorAdjustType
{
	ctDefault,  // 自身没有颜色调整信息的所有 GDI+ 对象所使用的颜色调整信息。
	ctBitmap,   // TBitmap 对象的颜色调整信息。
	ctBrush,    // TBrush 对象的颜色调整信息。
	ctPen,      // TPen 对象的颜色调整信息。
	ctText,     // 文本的颜色调整信息。
	ctCount,    // 指定的类型的数目。
	ctAny       // 指定的类型的数目。
};

//----------------------------------------------------------------------------
// Color Channel flags
//----------------------------------------------------------------------------

enum TColorChannelFlags
{
	ccfC,   // 青色通道。
	ccfM,   // 洋红色通道。
	ccfY,   // 黄色通道。
	ccfK,   // 黑色通道。
	ccfLast // 该元素指定不更改上次选定的颜色通道。
};

//--------------------------------------------------------------------------
// Various wrap modes for brushes
//--------------------------------------------------------------------------

enum TWrapMode
{
    wmTile,       // 平铺渐变或纹理。
    wmTileFlipX,  // 水平反转纹理或渐变，然后平铺该纹理或渐变。
    wmTileFlipY,  // 垂直反转纹理或渐变，然后平铺该纹理或渐变。
    wmTileFlipXY, // 水平和垂直反转纹理或渐变，然后平铺该纹理或渐变。
    wmClamp       // 将纹理和渐变向对象边界拉拢。
};

typedef	ColorMatrix		TColorMatrix;
typedef	ColorMap		TColorMap;

class TGpImageAttributes : public TGdiplusBase
{
	friend class TGpGraphics;
	friend class TGpTextureBrush;

protected:
	__fastcall TGpImageAttributes(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpImageAttributes));
	}
#endif
public:
	__fastcall TGpImageAttributes(void)
    {
		CheckStatus(GdipCreateImageAttributes(&Native));
    }
	__fastcall virtual ~TGpImageAttributes(void)
    {
		GdipDisposeImageAttributes(Native);
    }
	TGpImageAttributes* __fastcall Clone(void)
	{
		return new TGpImageAttributes(Native, (TCloneAPI)GdipCloneImageAttributes);
	}

	void __fastcall SetToIdentity(TColorAdjustType type = ctDefault)
	{
		CheckStatus(GdipSetImageAttributesToIdentity(Native, (ColorAdjustType)(int)type));
    }

	void __fastcall Reset(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipResetImageAttributes(Native, (ColorAdjustType)(int)type));
    }
	// 为指定类别设置颜色调整矩阵。
	void __fastcall SetColorMatrix(const TColorMatrix &colorMatrix,
						TColorMatrixFlags mode = cfDefault,
						TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native, (ColorAdjustType)(int)type,
			true, &colorMatrix, NULL, (ColorMatrixFlags)mode));
    }
    // 清除指定类别的颜色调整矩阵。
	void __fastcall ClearColorMatrix(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
            (ColorAdjustType)(int)type, false, NULL, NULL, ColorMatrixFlagsDefault));
    }
    // 为指定类别设置颜色调整矩阵和灰度调整矩阵。
	void __fastcall SetColorMatrices(const TColorMatrix &colorMatrix,
						  const TColorMatrix &grayMatrix,
						  TColorMatrixFlags mode = cfDefault,
						  TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
            (ColorAdjustType)(int)type, true, &colorMatrix, &grayMatrix, (ColorMatrixFlags)(int)mode));
    }
    // 清除指定类别颜色调整矩阵和灰度调整矩阵。
	void __fastcall ClearColorMatrices(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
							  (ColorAdjustType)(int)type, false, NULL, NULL, ColorMatrixFlagsDefault));
    }
    // 为指定类别设置阈值（透明范围）。
    // threshold: 0.0 到 1.0 之间的阈值.指定每种颜色成分的分界点。假定阈值设置为 0.7，
    // 并且假定当前所呈现的颜色中的红色、绿色和蓝色成分分别为 230、50 和 220。
    // 红色成分 230 大于 0.7x255，因此，红色成分将更改为 255（全亮度）。
    // 绿色成分 50 小于 0.7x255，因此，绿色成分将更改为 0。
    // 蓝色成分 220 大于 0.7x255，因此，蓝色成分将更改为 255
	void __fastcall SetThreshold(float threshold, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesThreshold(Native, (ColorAdjustType)(int)type, true, threshold));
    }
    // 为指定类别清除阈值。
	void __fastcall ClearThreshold(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesThreshold(Native, (ColorAdjustType)(int)type, false, 0.0));
    }
    // 为指定类别设置伽玛值。gamma 伽玛校正值。典型的伽玛值在 1.0 到 2.2 之间；
    // 但在某些情况下，0.1 到 5.0 范围内的值也很有用。
	void __fastcall SetGamma(float gamma, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesGamma(Native, (ColorAdjustType)(int)type, true, gamma));
    }
    // 禁用伽玛校正。
	void __fastcall ClearGamma(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesGamma(Native, (ColorAdjustType)(int)type, false, 0.0));
    }
    // 为指定类别关闭颜色调整。可以调用 ClearNoOp 恢复在 SetNoOp 调用前已存在的颜色调整设置。
	void __fastcall SetNoOp(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesNoOp(Native, (ColorAdjustType)(int)type, true));
    }
    // 清除 NoOp 设置。
	void __fastcall ClearNoOp(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesNoOp(Native, (ColorAdjustType)(int)type, false));
    }
    // 为指定类别设置色键（透明范围）。只要颜色成分处于高低色键范围内，该颜色就会成为透明的。
    // colorLow 低色键值; colorHigh 高色键值
	void __fastcall SetColorKey(const TGpColor& colorLow, const TGpColor& colorHigh,
					 TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorKeys(Native,
                              (ColorAdjustType)(int)type, true, colorLow.Argb, colorHigh.Argb));
    }
    // 为指定类别清除色键（透明范围）
	void __fastcall ClearColorKey(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorKeys(Native, (ColorAdjustType)(int)type, false, NULL, NULL));
    }
    // 为指定类别设置 CMYK 输出通道。flags: 指定输出通道。
	void __fastcall SetOutputChannel(TColorChannelFlags channelFlags, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannel(Native,
            (ColorAdjustType)(int)type, true, (ColorChannelFlags)(int)channelFlags));
    }
    // 为指定类别清除 CMYK 输出通道设置。
	void __fastcall ClearOutputChannel(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannel(Native, (ColorAdjustType)(int)type, false, ColorChannelFlagsLast));
    }
    // 为指定类别设置输出通道颜色配置文件
	void __fastcall SetOutputChannelColorProfile(const WideString colorProfileFilename,
								TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannelColorProfile(
                              Native, (ColorAdjustType)(int)type, true, colorProfileFilename.c_bstr()));
    }
    // 为指定类别清除输出通道颜色配置文件设置。
	void __fastcall ClearOutputChannelColorProfile(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannelColorProfile(Native, (ColorAdjustType)(int)type, false, NULL));
    }
    // 为指定类别设置颜色重新映射表。
	void __fastcall SetRemapTable(UINT mapSize, const TColorMap *map, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesRemapTable(Native, (ColorAdjustType)(int)type, true, mapSize, map));
    }
    // 清除颜色重新映射表。
	void __fastcall ClearRemapTable(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesRemapTable(Native, (ColorAdjustType)(int)type, false, 0, NULL));
    }
    // 为画刷类别设置颜色重新映射表。map: TColorMap数组。
	void __fastcall SetBrushRemapTable(UINT mapSize, const TColorMap *map)
    {
		SetRemapTable(mapSize, map, ctBrush);
    }
    // 清除画刷颜色重新映射表。
	void __fastcall ClearBrushRemapTable()
    {
		ClearRemapTable(ctBrush);
    }
    // 设置环绕模式和颜色，用于决定如何将纹理平铺到一个形状上，或平铺到形状的边界上。
    // 当纹理小于它所填充的形状时，纹理在该形状上平铺以填满该形状。
    // mode 重复的图像副本平铺区域的方式; color 指定呈现图像外部的像素的颜色。
	void __fastcall SetWrapMode(TWrapMode wrap, const TGpColor& color = TGpColor(kcBlack), bool clamp = false)
    {
		CheckStatus(GdipSetImageAttributesWrapMode(Native, (WrapMode)(int)wrap, color.Argb, clamp));
    }
    // 根据指定类别的调整设置，调整调色板中的颜色。
    // ColorPalette，在输入时包含要调整的调色板，在输出时包含已调整的调色板
    // TColorAdjustType 枚举的元素，它指定其调整设置将应用于调色板的类别。
	void __fastcall GetAdjustedPalette(TColorPalette* colorPalette, TColorAdjustType colorAdjustType)
    {
		CheckStatus(GdipGetImageAttributesAdjustedPalette(Native, colorPalette, (ColorAdjustType)(int)colorAdjustType));
	}

};

#endif
