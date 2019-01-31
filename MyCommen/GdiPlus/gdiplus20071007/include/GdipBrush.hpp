/**************************************************************************\
*
* Module Name:
*
*   GdipBrush.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipBrushHPP
#define GdipBrushHPP

//--------------------------------------------------------------------------
// Brush types
//--------------------------------------------------------------------------

enum TBrushType { btSolidColor, btHatchFill, btTextureFill, btPathGradient, btLinearGradient };

//--------------------------------------------------------------------------
// Abstract base class for various brush types
//--------------------------------------------------------------------------

class TGpBrush : public TGdiplusBase
{
private:
    friend class TGpPen;
	friend class TGpGraphics;
	friend class TGpBrushs;

private:
	TBrushType __fastcall GetType(void)
    {
        CheckStatus(GdipGetBrushType(Native, (GdiplusSys::BrushType*)&Result.rUINT));
		return (TBrushType)Result.rUINT;
    }

protected:
	__fastcall TGpBrush(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpBrush));
	}
#endif
	__fastcall TGpBrush(void) { }

public:
	__fastcall virtual ~TGpBrush(void)
    {
        GdipDeleteBrush(Native);
    }
	virtual TGpBrush* __fastcall Clone(void)
    {
        return new TGpBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// 返回Brush类型
	__property TBrushType BrushType = {read=GetType, nodefault};

};

//--------------------------------------------------------------------------
// Solid Fill Brush Object
//--------------------------------------------------------------------------

class TGpSolidBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetColor(void)
    {
        CheckStatus(GdipGetSolidFillColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	void __fastcall SetColor(const TGpColor color)
    {
        CheckStatus(GdipSetSolidFillColor(Native, color.Argb));
    }

protected:
	__fastcall TGpSolidBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpSolidBrush));
	}
#endif
public:
	// 初始化指定颜色的新 SolidBrush 对象。
	__fastcall TGpSolidBrush(TGpColor color)
    {
        CheckStatus(GdipCreateSolidFill(color.Argb, &Native));
    }
	virtual TGpSolidBrush* __fastcall Clone(void)
    {
        return new TGpSolidBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// 获取或设置此 SolidBrush 对象的颜色。
	__property TGpColor Color = {read=GetColor, write=SetColor};

};

//--------------------------------------------------------------------------
// Texture Brush Fill Object
//--------------------------------------------------------------------------

class TGpTextureBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	void __fastcall SetWrapMode(TWrapMode wrapMode)
    {
        CheckStatus(GdipSetTextureWrapMode(Native, (GdiplusSys::WrapMode)(int)wrapMode));
    }
	TWrapMode __fastcall GetWrapMode(void)
    {
        CheckStatus(GdipGetTextureWrapMode(Native, (GdiplusSys::WrapMode*)&Result.rINT));
        return (TWrapMode)Result.rINT;
    }
	TGpImage* __fastcall GetImage(void)
    {
        CheckStatus(GdipGetTextureImage(Native, &Result.rNATIVE));
        return new TGpImage(Result.rNATIVE, NULL);
    }

protected:
	__fastcall TGpTextureBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpTextureBrush));
	}
#endif
public:
	// 初始化使用指定的图像和自动换行模式的新 TextureBrush 对象。
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode = wmTile)
    {
        CheckStatus(GdipCreateTexture(image->Native, (GdiplusSys::WrapMode)(int)wrapMode, &Native));
	}
	// 初始化使用指定图像、自动换行模式和尺寸建立新 TextureBrush 对象。
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode, const TGpRectF &dstRect)
    {
        TGpTextureBrush(image, wrapMode, dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height);
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode, const TGpRect &dstRect)
    {
        TGpTextureBrush(image, wrapMode, dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height);
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode,
        float dstX, float dstY, float dstWidth, float dstHeight)
    {
        CheckStatus(GdipCreateTexture2(image->Native,
            (GdiplusSys::WrapMode)(int)wrapMode, dstX, dstY, dstWidth, dstHeight, &Native));
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode,
        int dstX, int dstY, int dstWidth, int dstHeight)
    {
        CheckStatus(GdipCreateTexture2I(image->Native,
            (GdiplusSys::WrapMode)(int)wrapMode, dstX, dstY, dstWidth, dstHeight, &Native));
	}
	// 初始化使用指定的图像、矩形尺寸和图像属性的新 TextureBrush 对象。
	__fastcall TGpTextureBrush(TGpImage* image, const TGpRectF &dstRect,
        TGpImageAttributes* imageAttributes = NULL)
    {
        CheckStatus(GdipCreateTextureIA(image->Native, ObjectNative(imageAttributes),
                  dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, &Native));
    }
	__fastcall TGpTextureBrush(TGpImage* image, const TGpRect &dstRect,
        TGpImageAttributes* imageAttributes = NULL)
    {
        CheckStatus(GdipCreateTextureIAI(image->Native, ObjectNative(imageAttributes),
                  dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, &Native));
	}
	virtual TGpTextureBrush* __fastcall Clone(void)
    {
        return new TGpTextureBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// 将此 TextureBrush 对象的 Transform 属性重置为单位矩阵。
	void __fastcall ResetTransform(void)
    {
        CheckStatus(GdipResetTextureTransform(Native));
	}
	// 以指定顺序将表示 TextureBrush 对象的局部几何变换的 Matrix 对象乘以指定的 Matrix 对象。
	void __fastcall MultiplyTransform(TGpMatrix* matrix, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipMultiplyTextureTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 以指定顺序将此 TextureBrush 对象的局部几何变换平移指定的尺寸。
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipTranslateTextureTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 以指定顺序将此 TextureBrush 对象的局部几何变换缩放指定的量。
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipScaleTextureTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将此 TextureBrush 对象的局部几何变换旋转指定的角度。
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipRotateTextureTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 获取或设置 Matrix 对象，它为与此 TextureBrush 对象关联的图像定义局部几何变换。
	void __fastcall GetTransform(TGpMatrix *matrix)
    {
        CheckStatus(GdipGetTextureTransform(Native, matrix->Native));
    }
	void __fastcall SetTransform(const TGpMatrix* matrix)
    {
        CheckStatus(GdipSetTextureTransform(Native, matrix->Native));
    }
	// 获取与此 TextureBrush 对象关联的 Image 对象。必须Free
	__property TGpImage* Image = {read=GetImage};
	// 获取或设置 WrapMode 枚举，它指示此 TextureBrush 对象的换行模式
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};

};

//--------------------------------------------------------------------------
// 该类封装双色渐变和自定义多色渐变。
// 所有渐变都是沿由矩形的宽度或两个点指定的直线定义的。
// 默认情况下，双色渐变是沿指定直线从起始色到结束色的均匀水平线性混合。
// 使用 Blend 类、SetSigmaBellShape 方法或 SetBlendTriangularShape 方法
// 自定义混合图案。通过在构造函数中指定 LinearGradientMode 枚举或角度自定义渐变的方向。
// 使用 InterpolationColors 属性创建多色渐变。
// Transform 属性指定应用到渐变的局部几何变形。
//--------------------------------------------------------------------------

enum TLinearGradientMode
{
    lmHorizontal,         // 指定从左到右的渐变。
    lmVertical,           // 指定从上到下的渐变。
    lmForwardDiagonal,    // 指定从左上到右下的渐变。
    lmBackwardDiagonal    // 指定从右上到左下的渐变。
};

class TGpLinearGradientBrush : public TGpBrush
{
private:
    friend  class TGpPen;
	TWrapMode __fastcall GetWrapMode(void)
    {
        CheckStatus(GdipGetLineWrapMode(Native, (GdiplusSys::WrapMode*)&Result.rINT));
        return (TWrapMode)Result.rINT;
    }
	void __fastcall SetWrapMode(TWrapMode wrapMode)
    {
        CheckStatus(GdipSetLineWrapMode(Native, (GdiplusSys::WrapMode)(int)wrapMode));
    }
	void __fastcall SetGammaCorrection(bool useGammaCorrection)
    {
        CheckStatus(GdipSetLineGammaCorrection(Native, useGammaCorrection));
    }
	bool __fastcall GetGammaCorrection(void)
    {
        CheckStatus(GdipGetLineGammaCorrection(Native, &Result.rBOOL));
        return Result.rBOOL;
    }
	int __fastcall GetBlendCount(void)
    {
        CheckStatus(GdipGetLineBlendCount(Native, &Result.rINT));
        return Result.rINT;
    }
	int __fastcall GetInterpolationColorCount(void)
    {
        CheckStatus(GdipGetLinePresetBlendCount(Native, &Result.rINT));
        return Result.rINT;
    }
	TGpRectF __fastcall GetRectangleF()
    {
        TGpRectF r;
        CheckStatus(GdipGetLineRect(Native, &r));
        return r;
    }
	TGpRect __fastcall GetRectangle()
    {
        TGpRect r;
        CheckStatus(GdipGetLineRectI(Native, &r));
        return r;
    }

protected:
	__fastcall TGpLinearGradientBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpLinearGradientBrush));
	}
#endif
public:
	// 使用指定的点和颜色初始化 LinearGradientBrush 类的新实例。
	__fastcall TGpLinearGradientBrush(const TGpPointF &point1,
        const TGpPointF &point2, TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipCreateLineBrush(&point1, &point2,
            color1.Argb, color2.Argb, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpPoint &point1,
        const TGpPoint &point2, TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipCreateLineBrushI(&point1, &point2,
            color1.Argb, color2.Argb, WrapModeTile, &Native));
	}
	// 根据一个矩形、起始颜色和结束颜色以及方向，创建 LinearGradientBrush 类的新实例。
	__fastcall TGpLinearGradientBrush(const TGpRectF &rect, TGpColor color1,
        TGpColor color2, TLinearGradientMode mode = lmHorizontal)
    {
        CheckStatus(GdipCreateLineBrushFromRect(&rect, color1.Argb, color2.Argb,
                (LinearGradientMode)(int)mode, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpRect &rect,
        TGpColor color1, TGpColor color2, TLinearGradientMode mode = lmHorizontal)
    {
        CheckStatus(GdipCreateLineBrushFromRectI(&rect, color1.Argb, color2.Argb,
                (LinearGradientMode)(int)mode, WrapModeTile, &Native));
	}
	// 根据矩形、起始颜色和结束颜色以及方向角度，创建 LinearGradientBrush 类的新实例。
	// isAngleScalable:指定角度是否受 LinearGradientBrush 关联的变形所影响
	__fastcall TGpLinearGradientBrush(const TGpRectF &rect,
        TGpColor color1, TGpColor color2, float angle, bool isAngleScalable = false)
    {
        CheckStatus(GdipCreateLineBrushFromRectWithAngle(&rect, color1.Argb,
                color2.Argb, angle, isAngleScalable, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpRect &rect,
        TGpColor color1, TGpColor color2, float angle, bool isAngleScalable = false)
    {
        CheckStatus(GdipCreateLineBrushFromRectWithAngleI(&rect, color1.Argb,
                color2.Argb, angle, isAngleScalable, WrapModeTile, &Native));
	}
	virtual TGpLinearGradientBrush* __fastcall Clone(void)
    {
        return new TGpLinearGradientBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// 获取或设置渐变的起始色和结束色。
	void __fastcall GetLinearColors(TGpColor &color1, TGpColor &color2)
    {
        DWORDLONG colors;
        CheckStatus(GdipGetLineColors(Native, (ARGB*)&colors));
        color1 = TGpColor((ARGB)colors);
        color2 = TGpColor((ARGB)(colors >> 32));
    }
	void __fastcall SetLinearColors(TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipSetLineColors(Native, color1.Argb, color2.Argb));
	}
	// 获取或设置 Blend，它指定为渐变定义自定义过渡的位置和因子。
	// blendFactors：用于渐变的混合因子数组。blendPositions：渐变的混合位置的数组。
	void __fastcall SetBlend(const float *blendFactors, const float * blendPositions, const int count)
    {
        CheckStatus(GdipSetLineBlend(Native, blendFactors, blendPositions, count));
    }
	void __fastcall GetBlend(float *blendFactors, float * blendPositions)
    {
        CheckStatus(GdipGetLineBlend(Native, blendFactors, blendPositions, BlendCount));
	}
	// 获取或设置一个定义多色线性渐变的 ColorBlend。
	// presetColors:沿渐变的相应位置处使用的颜色的颜色数组。blendPositions:沿渐变线的位置。
	void __fastcall SetInterpolationColors(
        const TGpColor *presetColors, const float *blendPositions, const int count)
    {
        CheckStatus(GdipSetLinePresetBlend(Native, (ARGB*)presetColors, blendPositions, count));
    }
	void __fastcall GetInterpolationColors(TGpColor *presetColors, float *blendPositions)
    {
        CheckStatus(GdipGetLinePresetBlend(Native,
            (ARGB*)presetColors, blendPositions, InterpolationColorCount));
	}
	// 创建基于钟形曲线的渐变过渡过程。
	void __fastcall SetBlendBellShape(float focus, float scale = 1.0)
    {
        CheckStatus(GdipSetLineSigmaBlend(Native, focus, scale));
	}
	// 创建一个从中心色向两端单个颜色线性过渡的线性渐变过程。
	void __fastcall SetBlendTriangularShape(float focus, float scale = 1.0)
    {
        CheckStatus(GdipSetLineLinearBlend(Native, focus, scale));
	}
	// 获取或设置一个 Matrix 对象，该对象为此 LinearGradientBrush 对象定义局部几何变形。
	void __fastcall SetTransform(const TGpMatrix* matrix)
    {
        CheckStatus(GdipSetLineTransform(Native, matrix->Native));
    }
	void __fastcall GetTransform(TGpMatrix* matrix)
    {
        CheckStatus(GdipGetLineTransform(Native, matrix->Native));
	}
	// 将 Transform 属性重置为相同。
	void __fastcall ResetTransform(void)
    {
        CheckStatus(GdipResetLineTransform(Native));
	}
	// 通过指定的 Matrix，将LinearGradientBrush 的局部几何变形的 Matrix 对象与该指定的 Matrix 相乘。
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipMultiplyLineTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变形转换指定的尺寸。该方法将预先计算对变形的转换。
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipTranslateLineTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变形缩放指定数量。该方法预先计算对变形的缩放矩阵。
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipScaleLineTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变形旋转指定大小。该方法预先计算对变形的旋转。
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipRotateLineTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
    }
	// 获取定义渐变的起始点和终结点的矩形区域。
	__property TGpRectF RectangleF = {read=GetRectangleF};
	__property TGpRect Rectangle = {read=GetRectangle};
	// 获取或设置 WrapMode 枚举，它指示该 LinearGradientBrush 的环绕模式
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};
	// 获取或设置一个值，该值指示是否为该 LinearGradientBrush 对象启用伽玛修正。
	__property bool GammaCorrection = {read=GetGammaCorrection, write=SetGammaCorrection, nodefault};
	__property int BlendCount = {read=GetBlendCount, nodefault};
	__property int InterpolationColorCount = {read=GetInterpolationColorCount, nodefault};

};

//--------------------------------------------------------------------------
// Hatch Brush Object 用阴影样式、前景色和背景色定义矩形画笔。
//--------------------------------------------------------------------------

enum THatchStyle
{
    hsHorizontal, hsVertical, hsForwardDiagonal, hsBackwardDiagonal,
    hsCross, hsDiagonalCross, hs05Percent, hs10Percent, hs20Percent, hs25Percent,
    hs30Percent, hs40Percent, hs50Percent, hs60Percent, hs70Percent, hs75Percent,
    hs80Percent, hs90Percent, hsLightDownwardDiagonal, hsLightUpwardDiagonal,
    hsDarkDownwardDiagonal, hsDarkUpwardDiagonal, hsWideDownwardDiagonal,
    hsWideUpwardDiagonal, hsLightVertical, hsLightHorizontal, hsNarrowVertical,
    hsNarrowHorizontal, hsDarkVertical, hsDarkHorizontal, hsDashedDownwardDiagonal,
    hsDashedUpwardDiagonal, hsDashedHorizontal, hsDashedVertical, hsSmallConfetti,
    hsLargeConfetti, hsZigZag, hsWave, hsDiagonalBrick, hsHorizontalBrick,
    hsWeave, hsPlaid, hsDivot, hsDottedGrid, hsDottedDiamond, hsShingle,
    hsTrellis, hsSphere, hsSmallGrid, hsSmallCheckerBoard, hsLargeCheckerBoard,
    hsOutlinedDiamond, hsSolidDiamond
};

class TGpHatchBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetBackgroundColor(void)
    {
        CheckStatus(GdipGetHatchBackgroundColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	TGpColor __fastcall GetForegroundColor(void)
    {
        CheckStatus(GdipGetHatchForegroundColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	THatchStyle __fastcall GetHatchStyle(void)
    {
        CheckStatus(GdipGetHatchStyle(Native, (GdiplusSys::HatchStyle*)&Result.rINT));
        return (THatchStyle)Result.rINT;
    }

protected:
	__fastcall TGpHatchBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpHatchBrush));
	}
#endif
public:
	// 使用指定的 HatchStyle 枚举、前景色和背景色初始化 HatchBrush 类的新实例。
	__fastcall TGpHatchBrush(THatchStyle hatchStyle, TGpColor foreColor, TGpColor backColor = TGpColor())
    {
		CheckStatus(GdipCreateHatchBrush((GdiplusSys::HatchStyle)(int)hatchStyle,
                foreColor.Argb, backColor.Argb, &Native));
	}
	virtual TGpHatchBrush* __fastcall Clone(void)
    {
        return new TGpHatchBrush(Native, (TCloneAPI)GdipCloneBrush);
    }
	// 获取此 HatchBrush 对象绘制的阴影线条的颜色。
	__property TGpColor ForegroundColor = {read=GetForegroundColor};
	// 获取此 HatchBrush 对象绘制的阴影线条间空间的颜色
	__property TGpColor BackgroundColor = {read=GetBackgroundColor};
	// 获取此 HatchBrush 对象的阴影样式。
	__property THatchStyle HatchStyle = {read=GetHatchStyle, nodefault};

};

//--------------------------------------------------------------------------
// Path Gradient Brush 通过渐变填充 GraphicsPath 对象的内部
// 这里只是类定义，实现代码在GdipPath.h
//--------------------------------------------------------------------------

class TGpPathGradientBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetCenterColor(void);
	void __fastcall SetCenterColor(const TGpColor color);
	int __fastcall GetPointCount(void);
	int __fastcall GetSurroundColorCount(void);
	void __fastcall SetGammaCorrection(bool useGammaCorrection);
	bool __fastcall GetGammaCorrection(void);
	int __fastcall GetBlendCount(void);
	TWrapMode __fastcall GetWrapMode(void);
	void __fastcall SetWrapMode(TWrapMode wrapMode);
	TGpPointF __fastcall GetCenterPoint();
	TGpPoint __fastcall GetCenterPointI();
	TGpRectF __fastcall GetRectangle();
	TGpRect __fastcall GetRectangleI();
	void __fastcall SetCenterPoint(const TGpPointF &Value);
	void __fastcall SetCenterPointI(const TGpPoint &Value);
	TGpPointF __fastcall GetFocusScales();
	void __fastcall SetFocusScales(const TGpPointF &Value);
	int __fastcall GetInterpolationColorCount(void);

protected:
	__fastcall TGpPathGradientBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpPathGradientBrush));
	}
#endif
public:
	// 使用指定的点和环绕模式初始化 PathGradientBrush 类的新实例。
	__fastcall TGpPathGradientBrush(const TGpPointF *points, const int points_Size, TWrapMode wrapMode = wmClamp);
	__fastcall TGpPathGradientBrush(const TGpPoint *points, const int points_Size, TWrapMode wrapMode = wmClamp);
	// 使用指定的路径初始化 PathGradientBrush 类的新实例。
	__fastcall TGpPathGradientBrush(TGpGraphicsPath* path);
	virtual TGpPathGradientBrush* __fastcall Clone(void);
	// 获取或设置与此 PathGradientBrush 对象填充的路径中的点相对应的颜色的数组。
	// 返回实际获取或设置的数组元素个数
	int __fastcall GetSurroundColors(TGpColor *colors);
	int __fastcall SetSurroundColors(const TGpColor *colors, const int colors_Size);
	// 获取或设置 Blend，它指定为渐变定义自定义过渡的位置和因子。
	int __fastcall GetBlend(float *blendFactors, float *blendPositions);
	void __fastcall SetBlend(const float *blendFactors, const float * blendPositions, const int count);
	// 获取或设置一个定义多色线性渐变的 ColorBlend 对象。
	void __fastcall SetInterpolationColors(
		const TGpColor *presetColors, const float *blendPositions, const int count);
	int __fastcall GetInterpolationColors(TGpColor *presetColors, float *blendPositions);
	// 创建基于钟形曲线的渐变过渡过程。
	void __fastcall SetBlendBellShape(float focus, float scale = 1.0);
	// 创建一个从中心色向周围色线性过渡的渐变过程。
    // focus: 介于 0 和 1 之间的一个值，它指定沿路径中心到路径边界的任意半径向上中心色亮度最高的位置。
	// scale: 介于 0 和 1 之间的一个值，它指定与边界色混合的中心色的最高亮度。
	void __fastcall SetBlendTriangularShape(float focus, float scale = 1.0);
	// 获取或设置一个 Matrix 对象，该对象为此 PathGradientBrush 对象定义局部几何变形。
	void __fastcall GetTransform(TGpMatrix* matrix);
	void __fastcall SetTransform(const TGpMatrix* matrix);
	// 将 Transform 属性重置为相同。
	void __fastcall ResetTransform(void);
	// 通过指定的 Matrix，将PathGradientBrush的局部几何变形的 Matrix 对象与该指定的 Matrix 相乘。
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend);
	// 按指定的顺序向局部几何变形应用指定的转换。
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend);
	// 将局部几何变形以指定顺序缩放指定数量。
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend);
	// 以指定顺序将局部几何变形旋转指定量。
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend);
	void __fastcall GetGraphicsPath(TGpGraphicsPath* path);
	void __fastcall SetGraphicsPath(const TGpGraphicsPath* path);
	// 获取此 PathGradientBrush 对象的边框。
	__property TGpRectF Rectangle = {read=GetRectangle};
	__property TGpRect RectangleI = {read=GetRectangleI};
	// 获取或设置一个 WrapMode 枚举，它指示此 PathGradientBrush 对象的环绕模式。
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};
	__property bool GammaCorrection = {read=GetGammaCorrection, write=SetGammaCorrection, nodefault};
	__property int BlendCount = {read=GetBlendCount, nodefault};
	__property int PointCount = {read=GetPointCount, nodefault};
	__property int SurroundColorCount = {read=GetSurroundColorCount, nodefault};
	// 获取或设置路径渐变的中心处的颜色。
	__property TGpColor CenterColor = {read=GetCenterColor, write=SetCenterColor};
	// 获取或设置路径渐变的中心点。
	__property TGpPointF CenterPoint = {read=GetCenterPoint, write=SetCenterPoint};
	__property TGpPoint CenterPointI = {read=GetCenterPointI, write=SetCenterPointI};
	// 获取或设置渐变过渡的焦点。
	__property TGpPointF FocusScales = {read=GetFocusScales, write=SetFocusScales};
	__property int InterpolationColorCount = {read=GetInterpolationColorCount, nodefault};

};


#endif
