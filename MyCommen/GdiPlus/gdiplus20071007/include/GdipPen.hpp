/**************************************************************************\
*
* Module Name:
*
*   GdipPen.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipPenHPP
#define GdipPenHPP

//--------------------------------------------------------------------------
// Pen types
//--------------------------------------------------------------------------

enum TPenAlignment
{
    paCenter,   // 以理论的线条为中心
    paInset     // 定位于理论的线条内
};

//--------------------------------------------------------------------------
// Dash cap constants
//--------------------------------------------------------------------------

enum TDashCap { dcFlat, dcRound = 2, dcTriangle };

//--------------------------------------------------------------------------
// Dash style constants
//--------------------------------------------------------------------------

enum TDashStyle { dsSolid, dsDash, dsDot, dsDashDot, dsDashDotDot, dsCustom };

//--------------------------------------------------------------------------
// Pen's Fill types
//--------------------------------------------------------------------------

enum TPenType { ptSolidColor, ptHatchFill, ptTextureFill, ptPathGradient, ptLinearGradient };

//--------------------------------------------------------------------------
// Pen class
//--------------------------------------------------------------------------

class TGpPen : public TGdiplusBase
{
private:
    friend  class TGpGraphicsPath;
    friend  class TGpGraphics;
	friend	class TGpPens;
	
	TGpBrush* __fastcall GetBrush(void)
    {
        CheckStatus(GdipGetPenBrushFill(Native, &Result.rNATIVE));
        TGpBrush *brush = NULL;
        switch (PenType)
        {
            case ptSolidColor:
                brush = new TGpSolidBrush(Result.rNATIVE, NULL);
                break;
            case ptHatchFill:
                brush = new TGpHatchBrush(Result.rNATIVE, NULL);
                break;
            case ptTextureFill:
                brush = new TGpTextureBrush(Result.rNATIVE, NULL);
                break;
            case ptPathGradient:
                brush = new TGpPathGradientBrush(Result.rNATIVE, NULL);
                break;
            case ptLinearGradient:
                brush = new TGpLinearGradientBrush(Result.rNATIVE, NULL);
        }
        return brush;
    }
	void __fastcall SetBrush(const TGpBrush* brush)
    {
        CheckStatus(GdipSetPenBrushFill(Native, brush->Native));
    }
	TPenAlignment __fastcall GetAlignment(void)
    {
        CheckStatus(GdipGetPenMode(Native, (GdiplusSys::PenAlignment*)&Result.rINT));
        return (TPenAlignment)Result.rINT;
    }
	void __fastcall SetAlignment(TPenAlignment penAlignment)
    {
        CheckStatus(GdipSetPenMode(Native, (GdiplusSys::PenAlignment)(int)penAlignment));
    }
	TGpColor __fastcall GetColor(void)
    {
        if (PenType != ptSolidColor)
            CheckStatus(WrongState);
        CheckStatus(GdipGetPenColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	void __fastcall SetColor(const TGpColor color)
    {
        CheckStatus(GdipSetPenColor(Native, color.Argb));
    }
	TDashCap __fastcall GetDashCap(void)
    {
        CheckStatus(GdipGetPenDashCap197819(Native, (GdiplusSys::DashCap*)&Result.rINT));
        return (TDashCap)Result.rINT;
    }
	float __fastcall GetDashOffset(void)
    {
        CheckStatus(GdipGetPenDashOffset(Native, &Result.rFLOAT));
        return Result.rFLOAT;
    }
	TDashStyle __fastcall GetDashStyle(void)
    {
        CheckStatus(GdipGetPenDashStyle(Native, (GdiplusSys::DashStyle*)&Result.rINT));
        return (TDashStyle)Result.rINT;
    }
	TLineCap __fastcall GetEndCap(void)
    {
        CheckStatus(GdipGetPenEndCap(Native, (GdiplusSys::LineCap*)&Result.rINT));
        return (TLineCap)Result.rINT;
    }
	TLineJoin __fastcall GetLineJoin(void)
    {
        CheckStatus(GdipGetPenLineJoin(Native, (GdiplusSys::LineJoin*)&Result.rINT));
        return (TLineJoin)Result.rINT;
    }
	float __fastcall GetMiterLimit(void)
    {
        CheckStatus(GdipGetPenMiterLimit(Native, &Result.rFLOAT));
        return Result.rFLOAT;
    }
	TPenType __fastcall GetPenType(void)
    {
        CheckStatus(GdipGetPenFillType(Native, (GdiplusSys::PenType*)&Result.rINT));
        return (TPenType)Result.rINT;
    }
	TLineCap __fastcall GetStartCap(void)
    {
        CheckStatus(GdipGetPenStartCap(Native, (GdiplusSys::LineCap*)&Result.rINT));
        return (TLineCap)Result.rINT;
    }
	float __fastcall GetWidth(void)
    {
        CheckStatus(GdipGetPenWidth(Native, &Result.rFLOAT));
        return Result.rFLOAT;
    }
	void __fastcall SetDashCap(TDashCap dashCap)
    {
        CheckStatus(GdipSetPenDashCap197819(Native, (GdiplusSys::DashCap)(int)dashCap));
    }
	void __fastcall SetDashOffset(float dashOffset)
    {
        CheckStatus(GdipSetPenDashOffset(Native, dashOffset));
    }
	void __fastcall SetDashStyle(TDashStyle dashStyle)
    {
        CheckStatus(GdipSetPenDashStyle(Native, (GdiplusSys::DashStyle)(int)dashStyle));
    }
	void __fastcall SetEndCap(TLineCap endCap)
    {
        CheckStatus(GdipSetPenEndCap(Native, (GdiplusSys::LineCap)(int)endCap));
    }
	void __fastcall SetLineJoin(TLineJoin lineJoin)
    {
        CheckStatus(GdipSetPenLineJoin(Native, (GdiplusSys::LineJoin)(int)lineJoin));
    }
	void __fastcall SetMiterLimit(float miterLimit)
    {
        CheckStatus(GdipSetPenMiterLimit(Native, miterLimit));
    }
	void __fastcall SetStartCap(TLineCap startCap)
    {
        CheckStatus(GdipSetPenStartCap(Native, (GdiplusSys::LineCap)(int)startCap));
    }
	void __fastcall SetWidth(float width)
    {
        CheckStatus(GdipSetPenWidth(Native, width));
    }
	int __fastcall GetDashPatternCount(void)
    {
        CheckStatus(GdipGetPenDashCount(Native, &Result.rINT));
        return Result.rINT;
    }
	int __fastcall GetCompoundArrayCount(void)
    {
        CheckStatus(GdipGetPenCompoundCount(Native, &Result.rINT));
        return Result.rINT;
    }

protected:
	__fastcall TGpPen(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpPen));
	}
#endif
public:
	__fastcall TGpPen(const TGpColor color, float width = 1.0)
    {
        CheckStatus(GdipCreatePen1(color.Argb, width, UnitWorld, &Native));
    }
	__fastcall TGpPen(TGpBrush* brush, float width = 1.0)
    {
        CheckStatus(GdipCreatePen2(brush->Native, width, UnitWorld, &Native));
    }
	__fastcall virtual ~TGpPen(void)
    {
        GdipDeletePen(Native);
    }
	TGpPen* __fastcall Clone(void)
    {
        return new TGpPen(Native, (TCloneAPI)GdipClonePen);
	}
	// 设置用于确定帽样式的值，此样式用于结束通过此 Pen 对象绘制的直线。
	void __fastcall SetLineCap(TLineCap startCap, TLineCap endCap, TDashCap dashCap)
    {
        CheckStatus(GdipSetPenLineCap197819(Native, (GdiplusSys::LineCap)(int)startCap,
            (GdiplusSys::LineCap)(int)endCap, (GdiplusSys::DashCap)(int)dashCap));
	}
	// 获取或设置在通过此 Pen 对象绘制的直线起点要使用的自定义帽。
	void __fastcall SetCustomStartCap(const TGpCustomLineCap* customCap)
    {
        CheckStatus(GdipSetPenCustomStartCap(Native, customCap? customCap->Native : NULL));
    }
	void __fastcall GetCustomStartCap(TGpCustomLineCap* customCap)
    {
        CheckStatus(GdipGetPenCustomStartCap(Native, &customCap->Native));
	}
	// 获取或设置在通过此 Pen 对象绘制的直线终点要使用的自定义帽。
	void __fastcall SetCustomEndCap(const TGpCustomLineCap* customCap)
    {
        CheckStatus(GdipSetPenCustomEndCap(Native, customCap? customCap->Native : NULL));
    }
	void __fastcall GetCustomEndCap(TGpCustomLineCap* customCap)
    {
        CheckStatus(GdipGetPenCustomEndCap(Native, &customCap->Native));
	}
	// 获取或设置此 Pen 对象的几何变换。
	void __fastcall SetTransform(const TGpMatrix* matrix)
    {
        CheckStatus(GdipSetPenTransform(Native, matrix->Native));
    }
	void __fastcall GetTransform(TGpMatrix* matrix)
    {
        CheckStatus(GdipGetPenTransform(Native, matrix->Native));
	}
	// 将此 Pen 对象的几何变换矩阵重置为单位矩阵。
	void __fastcall ResetTransform(void)
    {
         CheckStatus(GdipResetPenTransform(Native));
	}
	// 用指定的 Matrix 乘以此 Pen 对象的变换矩阵。
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipMultiplyPenTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变换平移指定尺寸。
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipTranslatePenTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变换缩放指定的量。
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipScalePenTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 将局部几何变换旋转指定角度。
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipRotatePenTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
	}
	// 获取或设置自定义的短划线和空白区域的数组。
	void __fastcall SetDashPattern(const float *dashArray, const int count)
    {
        CheckStatus(GdipSetPenDashArray(Native, dashArray, count));
    }
	void __fastcall GetDashPattern(float *dashArray)
    {
        CheckStatus(GdipGetPenDashArray(Native, dashArray, DashPatternCount));
	}
	// 获取或设置用于指定复合钢笔的数组值。复合钢笔绘制由平行直线和空白区域组成的复合直线。
	// compoundArray用于指定复合数组的实数组。该数组中的元素必须按升序排列，不能小于 0，也不能大于 1。
	void __fastcall SetCompoundArray(const float *compoundArray, const int count)
    {
        CheckStatus(GdipSetPenCompoundArray(Native, compoundArray, count));
    }
	void __fastcall GetCompoundArray(float *compoundArray)
    {
        CheckStatus(GdipGetPenCompoundArray(Native, compoundArray, CompoundArrayCount));
    }

	__property int CompoundArrayCount = {read=GetCompoundArrayCount, nodefault};
	__property int DashPatternCount = {read=GetDashPatternCount, nodefault};
	// 获取用此 Pen 对象绘制的直线的样式。
	__property TPenType PenType = {read=GetPenType, nodefault};
	// 获取或设置用在短划线终点的帽样式，这些短划线构成通过此 Pen 对象绘制的虚线。
    // 如果 Pen 对象的 Pen.Alignment 属性设置为 PenAlignment.Inset，
	// 则不要将此属性设置为 DashCapTriangle。
	__property TDashCap DashCap = {read=GetDashCap, write=SetDashCap, nodefault};
	// 获取或设置用于通过此 Pen 对象绘制的虚线的样式。
	__property TDashStyle DashStyle = {read=GetDashStyle, write=SetDashStyle, nodefault};
	// 获取或设置直线的起点到短划线图案起始处的距离。
	__property float DashOffset = {read=GetDashOffset, write=SetDashOffset};
	// 获取或设置用在通过此 Pen 对象绘制的直线起点或终点的帽样式。
	__property TLineCap StartCap = {read=GetStartCap, write=SetStartCap, nodefault};
	__property TLineCap EndCap = {read=GetEndCap, write=SetEndCap, nodefault};
	// 获取或设置通过此 Pen 对象绘制的两条连续直线终点之间的联接样式。
	__property TLineJoin LineJoin = {read=GetLineJoin, write=SetLineJoin, nodefault};
	// 获取或设置斜接角上联接宽度的限制。
	__property float MiterLimit = {read=GetMiterLimit, write=SetMiterLimit};
	__property float Width = {read=GetWidth, write=SetWidth};
	// 获取或设置用于确定此 Pen 对象的属性的 Brush 对象。返回的TBrush必须释放
	__property TGpBrush* Brush = {read=GetBrush, write=SetBrush};
	// 获取或设置此 Pen 对象的对齐方式。
	__property TPenAlignment Alignment = {read=GetAlignment, write=SetAlignment, nodefault};
	__property TGpColor Color = {read=GetColor, write=SetColor};
	
};


#endif
