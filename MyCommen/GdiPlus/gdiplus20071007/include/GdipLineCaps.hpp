/**************************************************************************\
*
* Module Name:
*
*   GdipLineCaps.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipLineCapsHPP
#define GdipLineCapsHPP

inline
TLineCap __fastcall TGpCustomLineCap::GetBaseCap(void)
{
    CheckStatus(GdipGetCustomLineCapBaseCap(Native, (LineCap*)&Result.rINT));
    return (TLineCap)Result.rINT;
}
inline
void __fastcall TGpCustomLineCap::SetBaseCap(TLineCap baseCap)
{
    CheckStatus(GdipSetCustomLineCapBaseCap(Native, (LineCap)(int)baseCap));
}
inline
float __fastcall TGpCustomLineCap::GetBaseInset(void)
{
    CheckStatus(GdipGetCustomLineCapBaseInset(Native, &Result.rFLOAT));
    return Result.rFLOAT;
}
inline
void __fastcall TGpCustomLineCap::SetBaseInset(float inset)
{
    CheckStatus(GdipSetCustomLineCapBaseInset(Native, inset));
}
inline
TLineJoin __fastcall TGpCustomLineCap::GetStrokeJoin(void)
{
    CheckStatus(GdipGetCustomLineCapStrokeJoin(Native, (LineJoin*)&Result.rINT));
    return (TLineJoin)Result.rINT;
}
inline
void __fastcall TGpCustomLineCap::SetStrokeJoin(TLineJoin lineJoin)
{
    CheckStatus(GdipSetCustomLineCapStrokeJoin(Native, (LineJoin)(int)lineJoin));
}
inline
float __fastcall TGpCustomLineCap::GetWidthScale(void)
{
    CheckStatus(GdipGetCustomLineCapWidthScale(Native, &Result.rFLOAT));
    return Result.rFLOAT;
}
inline
void __fastcall TGpCustomLineCap::SetWidthScale(float widthScale)
{
    CheckStatus(GdipSetCustomLineCapWidthScale(Native, widthScale));
}
inline
__fastcall TGpCustomLineCap::TGpCustomLineCap(TGpGraphicsPath* fillPath,
	TGpGraphicsPath* strokePath, TLineCap baseCap, float baseInset)
{
    CheckStatus(GdipCreateCustomLineCap(fillPath? fillPath->Native : NULL,
        strokePath? strokePath->Native : NULL, (LineCap)(int)baseCap, baseInset, &Native));
}
inline
__fastcall TGpCustomLineCap::~TGpCustomLineCap(void)
{
    GdipDeleteCustomLineCap(Native);
}
inline
TGpCustomLineCap* __fastcall TGpCustomLineCap::Clone(void)
{
    return new TGpCustomLineCap(Native, (TCloneAPI)GdipCloneCustomLineCap);
}
inline
void __fastcall TGpCustomLineCap::SetStrokeCap(TLineCap strokeCap)
{
    SetStrokeCaps(strokeCap, strokeCap);
}
inline
void __fastcall TGpCustomLineCap::GetStrokeCaps(TLineCap &startCap, TLineCap &endCap)
{
    CheckStatus(GdipGetCustomLineCapStrokeCaps(Native,
        (LineCap*)&startCap, (LineCap*)&endCap));
}
inline
void __fastcall TGpCustomLineCap::SetStrokeCaps(TLineCap startCap, TLineCap endCap)
{
    CheckStatus(GdipSetCustomLineCapStrokeCaps(Native, (LineCap)(int)startCap, (LineCap)(int)endCap));
}

class TGpAdjustableArrowCap : public TGpCustomLineCap
{
private:
	bool __fastcall GetFillState(void)
	{
		CheckStatus(GdipGetAdjustableArrowCapFillState(Native, &Result.rBOOL));
		return Result.rBOOL;
    }
	float __fastcall GetHeight(void)
	{
		CheckStatus(GdipGetAdjustableArrowCapHeight(Native, &Result.rFLOAT));
		return Result.rFLOAT;
    }
	float __fastcall GetMiddleInset(void)
	{
		CheckStatus(GdipGetAdjustableArrowCapMiddleInset(Native, &Result.rFLOAT));
		return Result.rFLOAT;
    }
	float __fastcall GetWidth(void)
	{
		CheckStatus(GdipGetAdjustableArrowCapWidth(Native, &Result.rFLOAT));
		return Result.rFLOAT;
    }
	void __fastcall SetFillState(const bool Value)
	{
		CheckStatus(GdipSetAdjustableArrowCapFillState(Native, Value));
    }
	void __fastcall SetHeight(const float Value)
	{
		CheckStatus(GdipSetAdjustableArrowCapHeight(Native, Value));
    }
	void __fastcall SetMiddleInset(const float Value)
	{
		CheckStatus(GdipSetAdjustableArrowCapMiddleInset(Native, Value));
    }
	void __fastcall SetWidth(const float Value)
	{
		CheckStatus(GdipSetAdjustableArrowCapWidth(Native, Value));
	}

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpAdjustableArrowCap));
	}
#endif
public:
    // 使用指定的宽度、高度新实例。箭头端帽是否填充取决于传递给 isFilled 参数的参数。
	__fastcall TGpAdjustableArrowCap(float width, float height, bool isFilled = true)
	{
		CheckStatus(GdipCreateAdjustableArrowCap(height, width, isFilled, &Native));
    }
	// 获取或设置箭头帽的高度。
	__property float Height = {read=GetHeight, write=SetHeight};
    // 获取或设置箭头帽的宽度。
	__property float Width = {read=GetWidth, write=SetWidth};
    // 获取或设置箭头帽的轮廓和填充之间单位的数目。
	__property float MiddleInset = {read=GetMiddleInset, write=SetMiddleInset};
    // 获取或设置是否填充箭头帽。
	__property bool Filled = {read=GetFillState, write=SetFillState};
};

#endif
