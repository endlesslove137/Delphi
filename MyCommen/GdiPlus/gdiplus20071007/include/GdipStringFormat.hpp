/**************************************************************************\
*
* Module Name:
*
*   GdipStringFormat.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipStringFormatHPP
#define GdipStringFormatHPP

//---------------------------------------------------------------------------
// National language digit substitution
//---------------------------------------------------------------------------

enum TStringDigitSubstitute
{
    ssUser,             // 指定用户定义的替换方案。
    ssNone,             // 指定禁用替换。
    ssNational,         // 指定与用户区域设置的正式国家/地区语言相对应的替换数字位。
    ssTraditional       // 指定与用户的本机脚本或语言相对应的替换数字位
};

//---------------------------------------------------------------------------
// Hotkey prefix interpretation
//---------------------------------------------------------------------------

enum THotkeyPrefix { hpNone, hpShow, hpHide };

//---------------------------------------------------------------------------
// String alignment flags 左到右布局，远端位置是右。右到左布局，远端位置是左。
//---------------------------------------------------------------------------

enum TStringAlignment
{
    saNear,     // 文本近端对齐
    saCenter,   // 文本居中对齐
    saFar       // 文本远端对齐
};

//---------------------------------------------------------------------------
// StringFormatFlags
//---------------------------------------------------------------------------

enum TStringFormatFlag
{
    sfDirectionRightToLeft,     // 文本从右到左排列
    sfDirectionVertical,        // 文本垂直排列
    sfNoFitBlackBox,            // 任何标志符号的任何部分都不突出边框
    sfDisplayFormatControl = 5, // 控制字符随具有代表性的标志符号一起显示在输出中
    sfNoFontFallback = 10,      // 缺失的字符都用缺失标志符号的字体显示
       // 在默认情况下，MeasureString 方法返回的边框都将排除每一行结尾处的空格。
    // 设置此标记以便在测定时将空格包括进去。
    sfMeasureTrailingSpaces,
    sfNoWrap,                   // 在矩形中进行格式化时禁用文本换行
    sfLineLimit,                // 确保看到的都是整行
    sfNoClip                    // 允许显示标志符号的伸出部分和延伸到边框外的未换行文本
};

typedef Set<TStringFormatFlag, sfDirectionRightToLeft, sfNoClip>  TStringFormatFlags;

//---------------------------------------------------------------------------
// StringTrimming
//---------------------------------------------------------------------------

enum TStringTrimming
{
    stNone,             // 不进行任何修整
    stCharacter,        // 将文本修整成最接近的字符
    stWord,             // 将文本修整成最接近的单词
    stEllipsisCharacter,// 将文本修整成最接近的字符，并在行的末尾插入一个省略号。
    stEllipsisWord,     // 将文本修整成最接近的单词，并在行的末尾插入一个省略号
    stEllipsisPath      // 中心从被修整的行移除并用省略号替换
};

class TGpStringFormat : public TGdiplusBase
{
private:
	friend  class TGpGraphicsPath;
    friend  class TGpGraphics;

	int __fastcall GetTabStopCount(void)
    {
         CheckStatus(GdipGetStringFormatTabStopCount(Native, &Result.rINT));
         return Result.rINT;
    }
	LANGID __fastcall GetDigitSubstitutionLanguage(void)
    {
        CheckStatus(GdipGetStringFormatDigitSubstitution(Native, (Word*)&Result.rUINT, NULL));
        return Result.rUINT;
    }
	TStringDigitSubstitute __fastcall GetDigitSubstitutionMethod(void)
    {
        CheckStatus(GdipGetStringFormatDigitSubstitution(Native, NULL, (StringDigitSubstitute*)&Result.rINT));
        return (TStringDigitSubstitute)Result.rINT;
    }
	int __fastcall GetMeasurableCharacterRangeCount(void)
    {
        CheckStatus(GdipGetStringFormatMeasurableCharacterRangeCount(Native, &Result.rINT));
        return Result.rINT;
    }
	TStringAlignment __fastcall GetAlignment(void)
    {
        CheckStatus(GdipGetStringFormatAlign(Native, (StringAlignment*)&Result.rINT));
        return (TStringAlignment)Result.rINT;
    }
	TStringFormatFlags __fastcall GetFormatFlags(void)
    {
        CheckStatus(GdipGetStringFormatFlags(Native, &Result.rINT));
        return *(TStringFormatFlags*)&Result.rINT;
    }
	THotkeyPrefix __fastcall GetHotkeyPrefix(void)
    {
        CheckStatus(GdipGetStringFormatHotkeyPrefix(Native, &Result.rINT));
        return (THotkeyPrefix)Result.rINT;
    }
	TStringAlignment __fastcall GetLineAlignment(void)
    {
        CheckStatus(GdipGetStringFormatLineAlign(Native, (GdiplusSys::StringAlignment*)&Result.rINT));
        return (TStringAlignment)Result.rINT;
    }
	TStringTrimming __fastcall GetTrimming(void)
    {
        CheckStatus(GdipGetStringFormatTrimming(Native, (GdiplusSys::StringTrimming*)&Result.rINT));
        return (TStringTrimming)Result.rINT;
    }
	void __fastcall SetAlignment(TStringAlignment align)
    {
        CheckStatus(GdipSetStringFormatAlign(Native,(StringAlignment)(int)align));
    }
	void __fastcall SetFormatFlags(TStringFormatFlags flags)
    {
		CheckStatus(GdipSetStringFormatFlags(Native, SETTOWORD(flags)));
    }
	void __fastcall SetHotkeyPrefix(THotkeyPrefix hotkeyPrefix)
    {
        CheckStatus(GdipSetStringFormatHotkeyPrefix(Native, (int)hotkeyPrefix));
    }
	void __fastcall SetLineAlignment(TStringAlignment align)
    {
        CheckStatus(GdipSetStringFormatLineAlign(Native, (StringAlignment)(int)align));
    }
	void __fastcall SetTrimming(TStringTrimming trimming)
    {
        CheckStatus(GdipSetStringFormatTrimming(Native, (StringTrimming)(int)trimming));
    }

protected:
	__fastcall TGpStringFormat(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpStringFormat));
	}
#endif
	// 因默认构造函数已经分配了Native，TGenericStringFormat只好用这个构造函数，否则内存泄露
	__fastcall TGpStringFormat(bool Generic){}
public:
	__fastcall TGpStringFormat(TStringFormatFlags formatFlags = TStringFormatFlags(), LANGID language = LANG_NEUTRAL)
    {
		CheckStatus(GdipCreateStringFormat(SETTOWORD(formatFlags), language, &Native));
    }
	__fastcall TGpStringFormat(TGpStringFormat* format)
    {
        CheckStatus(GdipCloneStringFormat(ObjectNative(format), &Native));
    }
	static TGpStringFormat* __fastcall GenericDefault(void);
	static TGpStringFormat* __fastcall GenericTypographic(void);
	TGpStringFormat* __fastcall Clone(void)
	{
		return new TGpStringFormat(Native, (TCloneAPI)GdipCloneStringFormat);
	}
	__fastcall virtual ~TGpStringFormat(void)
	{
		GdipDeleteStringFormat(Native);
	}
	void __fastcall SetTabStops(float firstTabOffset, const float * tabStops, const int tabStops_Size)
    {
        CheckStatus(GdipSetStringFormatTabStops(Native, firstTabOffset, tabStops_Size, tabStops));
    }
	void __fastcall GetTabStops(float &firstTabOffset, float *tabStops)
    {
        CheckStatus(GdipGetStringFormatTabStops(Native, TabStopCount, &firstTabOffset, tabStops));
    }
	void __fastcall SetDigitSubstitution(LANGID language, TStringDigitSubstitute substitute)
    {
        CheckStatus(GdipSetStringFormatDigitSubstitution(Native, language,
                (GdiplusSys::StringDigitSubstitute)(int)substitute));
    }
	void __fastcall SetMeasurableCharacterRanges(const TCharacterRange *ranges, const int ranges_Size)
    {
        CheckStatus(GdipSetStringFormatMeasurableCharacterRanges(Native,ranges_Size, (CharacterRange*)ranges));
    }
    
	__property int TabStopCount = {read=GetTabStopCount, nodefault};
	__property LANGID DigitSubstitutionLanguage = {read=GetDigitSubstitutionLanguage, nodefault};
	__property TStringDigitSubstitute DigitSubstitutionMethod = {read=GetDigitSubstitutionMethod, nodefault};
	__property int MeasurableCharacterRangeCount = {read=GetMeasurableCharacterRangeCount, nodefault};
	__property TStringAlignment Alignment = {read=GetAlignment, write=SetAlignment, nodefault};
	__property TStringFormatFlags FormatFlags = {read=GetFormatFlags, write=SetFormatFlags, nodefault};
	__property THotkeyPrefix HotkeyPrefix = {read=GetHotkeyPrefix, write=SetHotkeyPrefix, nodefault};
	__property TStringAlignment LineAlignment = {read=GetLineAlignment, write=SetLineAlignment, nodefault};
	__property TStringTrimming Trimming = {read=GetTrimming, write=SetTrimming, nodefault};

};

class TGenericStringFormat : public TGpStringFormat
{

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGenericStringFormat));
	}
#endif
	virtual void __fastcall FreeInstance()
	{
		GdipGenerics.GenericNil(this);
		TGdiplusBase::FreeInstance();
	}
public:
	TGenericStringFormat(void): TGpStringFormat(true){}
};

inline
static TGpStringFormat* __fastcall TGpStringFormat::GenericDefault(void)
{
	if (GdipGenerics.GenericDefaultStringFormatBuffer == NULL)
	{
		GdipGenerics.GenericDefaultStringFormatBuffer = new TGenericStringFormat();
		GdipStringFormatGetGenericDefault(&GdipGenerics.GenericDefaultStringFormatBuffer->Native);
	}
	return (TGpStringFormat*)GdipGenerics.GenericDefaultStringFormatBuffer;
}

inline
static TGpStringFormat* __fastcall TGpStringFormat::GenericTypographic(void)
{
	if (GdipGenerics.GenericTypographicStringFormatBuffer == NULL)
	{
		GdipGenerics.GenericTypographicStringFormatBuffer = new TGenericStringFormat();
		GdipStringFormatGetGenericTypographic(&GdipGenerics.GenericTypographicStringFormatBuffer->Native);
	}
	return (TGpStringFormat*)GdipGenerics.GenericTypographicStringFormatBuffer;
}

#endif // !_GDIPLUSSTRINGFORMAT_H

