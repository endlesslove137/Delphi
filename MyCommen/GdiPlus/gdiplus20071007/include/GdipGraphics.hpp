/**************************************************************************\
*
* Module Name:
*
*   GdipGraphics.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipGraphicsHPP
#define GdipGraphicsHPP

// Alpha 合成方式
enum TCompositingMode
{
	cmSourceOver,  // 与背景色混合。 混合程度由呈现的颜色的 alpha 成分确定。
	cmSourceCopy   // 改写背景色
};

// Alpha 合成质量
enum TCompositingQuality
{
	cqDefault,           // 默认质量
	cqHighSpeed,         // 高速度、低质量
	cqHighQuality,       // 高质量、低速度
	cqGammaCorrected,    // 使用伽玛修正
	cqAssumeLinear       // 假定线性值
};

enum TTextRenderingHint
{
	thSystemDefault,            // 为系统选择的所有字体修匀设置来绘制文本。
	thSingleBitPerPixelGridFit, // 改善字符在主干和弯曲部分的外观
	thSingleBitPerPixel,        // 使用标志符号位图来绘制字符。不使用提示
	thAntiAliasGridFit,         // 质量较佳，但同时会增加性能成本
	thAntiAlias,                // 质量较佳但速度较慢
	thClearTypeGridFit          // 质量最高的设置。用于利用ClearType字体功能
};

enum TInterpolationMode
{
	imDefault,                  // 默认模式
	imLowQuality,               // 低质量插值法
	imHighQuality,              // 高质量插值法
	imBilinear,                 // 双线性插值法
	imBicubic,                  // 双三次插值法
	imNearestNeighbor,          // 最临近插值法
	imHighQualityBilinear,      // 高质量双线性插值法
	imHighQualityBicubic        // 高质量双三次插值法
};

// 指定是否将平滑处理（消除锯齿）应用于直线、曲线和已填充区域的边缘。
enum TSmoothingMode
{
	smDefault,                  // 默认模式
	smHighSpeed,                // 高速度、低质量
	smHighQuality,              // 高质量、低速度
	smNone,                     // 不消除锯齿
	smAntiAlias                 // 消除锯齿
};

enum TPixelOffsetMode
{
	pmDefault,                  // 默认
	pmHighSpeed,                // 高速度、低质量
	pmHighQuality,              // 高质量、低速度
	pmNone,                     // 没有任何像素偏移
	pmHalf                      // 像素在水平和垂直距离上均偏移 -.5 个单位，以进行高速锯齿消除
};

enum TFlushIntention
{
	fiFlush,     	// 立即刷新所有图形操作的堆栈
	fiSync       	// 尽快执行堆栈上的所有图形操作。这将同步图形状态。
};

enum TCoordinateSpace
{
	csWorld,     	// 指定全局坐标上下文中的坐标
	csPage,      	// 指定页坐标上下文中的坐标。由 Graphics.PageUnit 属性定义
	csDevice     	// 指定设备坐标上下文中的坐标
};

enum TCombineMode
{
	cmReplace,     	// 一个剪辑区域被另一个剪辑区域替代
	cmIntersect,    // 通过采用两个剪辑区域的交集组合两个剪辑区域
	cmUnion,        // 通过采用两个剪辑区域的联合组合两个剪辑区域
	cmXor,          // 通过只采纳单独由其中一个区域（而非两个区域一起）包括的范围来组合两个剪辑区域
	cmExclude,      // 从现有区域中排除新区域
	cmComplement    // 从新区域中排除现有区域
};

class TGpGraphics : public TGdiplusBase
{
	typedef TGdiplusBase inherited;

private:
	friend class TGpRegion;
	friend class TGpImage;
	friend class TGpBitmap;
	friend class TGpFont;
	friend class TGpFontFamily;
	friend class TGpFontCollection;
	friend class TGpCachedBitmap;
	
	void __fastcall SetCompositingMode(TCompositingMode compositingMode)
	{
		CheckStatus(GdipSetCompositingMode(Native, (GdiplusSys::CompositingMode)(int)compositingMode));
    }
	TCompositingMode __fastcall GetCompositingMode(void)
	{
		CheckStatus(GdipGetCompositingMode(Native, (GdiplusSys::CompositingMode*)&Result.rINT));
		return (TCompositingMode)Result.rINT;
	}
	void __fastcall SetCompositingQuality(TCompositingQuality compositingQuality)
	{
		CheckStatus(GdipSetCompositingQuality(Native,
            (GdiplusSys::CompositingQuality)(int)compositingQuality));
    }
	TCompositingQuality __fastcall GetCompositingQuality(void)
	{
		CheckStatus(GdipGetCompositingQuality(Native, (GdiplusSys::CompositingQuality*)&Result.rINT));
		return  (TCompositingQuality)Result.rINT;
    }
	void __fastcall SetTextRenderingHint(TTextRenderingHint newMode)
	{
		CheckStatus(GdipSetTextRenderingHint(Native, (GdiplusSys::TextRenderingHint)(int)newMode));
    }
	TTextRenderingHint __fastcall GetTextRenderingHint(void)
	{
		  CheckStatus(GdipGetTextRenderingHint(Native, (GdiplusSys::TextRenderingHint*)&Result.rINT));
		return (TTextRenderingHint)Result.rINT;
    }
	void __fastcall SetTextContrast(int contrast)
	{
		CheckStatus(GdipSetTextContrast(Native, contrast));
    }
	int __fastcall GetTextContrast(void)
	{
		CheckStatus(GdipGetTextContrast(Native, &Result.rUINT));
		return Result.rINT;
    }
	TInterpolationMode __fastcall GetInterpolationMode(void)
	{
		CheckStatus(GdipGetInterpolationMode(Native, (GdiplusSys::InterpolationMode*)&Result.rINT));
		return (TInterpolationMode)Result.rINT;
	}
	void __fastcall SetInterpolationMode(TInterpolationMode interpolationMode)
	{
		CheckStatus(GdipSetInterpolationMode(Native, (GdiplusSys::InterpolationMode)(int)interpolationMode));
    }
	TSmoothingMode __fastcall GetSmoothingMode(void)
	{
		CheckStatus(GdipGetSmoothingMode(Native, (GdiplusSys::SmoothingMode*)&Result.rINT));
		return (TSmoothingMode)Result.rINT;
    }
	void __fastcall SetSmoothingMode(TSmoothingMode smoothingMode)
	{
		CheckStatus(GdipSetSmoothingMode(Native, (GdiplusSys::SmoothingMode)(int)smoothingMode));
    }
	TPixelOffsetMode __fastcall GetPixelOffsetMode(void)
	{
		CheckStatus(GdipGetPixelOffsetMode(Native, (GdiplusSys::PixelOffsetMode*)Result.rINT));
		return (TPixelOffsetMode)Result.rINT;
    }
	void __fastcall SetPixelOffsetMode(TPixelOffsetMode pixelOffsetMode)
	{
		CheckStatus(GdipSetPixelOffsetMode(Native, (GdiplusSys::PixelOffsetMode)(int)pixelOffsetMode));
    }
	void __fastcall SetPageUnit(TUnit unit)
	{
		CheckStatus(GdipSetPageUnit(Native, (GdiplusSys::Unit)(int)unit));
	}
	void __fastcall SetPageScale(float scale)
	{
		CheckStatus(GdipSetPageScale(Native, scale));
    }
	TUnit __fastcall GetPageUnit(void)
	{
		CheckStatus(GdipGetPageUnit(Native, (GdiplusSys::Unit*)Result.rINT));
		return (TUnit)Result.rINT;
    }
	float __fastcall GetPageScale(void)
	{
		CheckStatus(GdipGetPageScale(Native, &Result.rFLOAT));
		return Result.rFLOAT;
    }
	float __fastcall GetDpiX(void)
	{
		CheckStatus(GdipGetDpiX(Native, &Result.rFLOAT));
		return Result.rFLOAT;
    }
	float __fastcall GetDpiY(void)
	{
		CheckStatus(GdipGetDpiY(Native, &Result.rFLOAT));
		return Result.rFLOAT;
	}
	TGpPoint __fastcall GetRenderingOrigin()
	{
		TGpPoint point;
		CheckStatus(GdipGetRenderingOrigin(Native, &point.X, &point.Y));
		return point;
    }
	void __fastcall SetRenderingOrigin(const TGpPoint &Value)
	{
        CheckStatus(GdipSetRenderingOrigin(Native, Value.X, Value.Y));
    }

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpGraphics));
	}
#endif
public:
	__fastcall TGpGraphics(HDC hdc)
	{
		CheckStatus(GdipCreateFromHDC(hdc, &Native));
	}
	static TGpGraphics* __fastcall FromHDC(HDC hdc)
	{
		return new TGpGraphics(hdc);
    }
	__fastcall TGpGraphics(HDC hdc, HANDLE hdevice)
	{
		CheckStatus(GdipCreateFromHDC2(hdc, hdevice, &Native));
    }
	static TGpGraphics* __fastcall FromHDC(HDC hdc, HANDLE hdevice)
	{
		return new TGpGraphics(hdc, hdevice);
    }
	__fastcall TGpGraphics(HWND hwnd, bool icm)
	{
		if (icm) CheckStatus(GdipCreateFromHWNDICM(hwnd, &Native));
		else CheckStatus(GdipCreateFromHWND(hwnd, &Native));
    }
	static TGpGraphics* __fastcall FromHWND(HWND hwnd, bool icm = false)
	{
		return new TGpGraphics(hwnd, icm);
	}
	__fastcall TGpGraphics(TGpImage* image)
	{
		if (!image) CheckStatus(InvalidParameter);
		CheckStatus(GdipGetImageGraphicsContext(image->Native, &Native));
	}
	static TGpGraphics* __fastcall FromImage(TGpImage* image)
	{
		return new TGpGraphics(image);
    }
	__fastcall virtual ~TGpGraphics(void)
	{
		GdipDeleteGraphics(Native);
    }
	void __fastcall Flush(TFlushIntention intention = fiFlush)
	{
		GdipFlush(Native, (GdiplusSys::FlushIntention)(int)intention);
    }
	HDC __fastcall GetHDC(void)
	{
		HDC hdc;
		CheckStatus(GdipGetDC(Native, &hdc));
		return hdc;
    }
	void __fastcall ReleaseHDC(HDC hdc)
	{
		CheckStatus(GdipReleaseDC(Native, hdc));
    }
	void __fastcall GetTransform(TGpMatrix* matrix)
	{
		CheckStatus(GdipGetWorldTransform(Native, matrix->Native));
    }
	void __fastcall SetTransform(const TGpMatrix* matrix)
	{
		CheckStatus(GdipSetWorldTransform(Native, matrix->Native));
    }
	void __fastcall ResetTransform(void)
	{
		CheckStatus(GdipResetWorldTransform(Native));
    }
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipMultiplyWorldTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
    }
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipTranslateWorldTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
    }
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipScaleWorldTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
    }
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipRotateWorldTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
	}
	void __fastcall TransformPoints(TCoordinateSpace destSpace,
        TCoordinateSpace srcSpace, TGpPointF * pts, const int pts_Size)
	{
		CheckStatus(GdipTransformPoints(Native, (GdiplusSys::CoordinateSpace)(int)destSpace,
            (GdiplusSys::CoordinateSpace)(int)srcSpace, pts, pts_Size));
	}
	void __fastcall TransformPoints(TCoordinateSpace destSpace,
        TCoordinateSpace srcSpace, TGpPoint * pts, const int pts_Size)
	{
		CheckStatus(GdipTransformPointsI(Native, (GdiplusSys::CoordinateSpace)(int)destSpace,
            (GdiplusSys::CoordinateSpace)(int)srcSpace, pts, pts_Size));
	}
	TGpColor __fastcall GetNearestColor(const TGpColor color)
	{
    	Result.rARGB = color.Argb;
		CheckStatus(GdipGetNearestColor(Native, &Result.rARGB));
		return TGpColor(Result.rARGB);
	}
	void __fastcall Clear(const TGpColor color)
	{
		CheckStatus(GdipGraphicsClear(Native, color.Argb));
    }
	void __fastcall DrawLine(const TGpPen* pen, float x1, float y1, float x2, float y2)
	{
		CheckStatus(GdipDrawLine(Native, pen->Native, x1, y1, x2, y2));
    }
	void __fastcall DrawLine(const TGpPen* pen, const TGpPointF &pt1, const TGpPointF &pt2)
	{
		DrawLine(pen, pt1.X, pt1.Y, pt2.X, pt2.Y);
    }
	void __fastcall DrawLine(const TGpPen* pen, int x1, int y1, int x2, int y2)
	{
		CheckStatus(GdipDrawLineI(Native, pen->Native, x1, y1, x2, y2));
    }
	void __fastcall DrawLine(const TGpPen* pen, const TGpPoint &pt1, const TGpPoint &pt2)
	{
        DrawLine(pen, pt1.X, pt1.Y, pt2.X, pt2.Y);
    }
	void __fastcall DrawLines(const TGpPen* pen, TGpPointF const *points, const int points_Size)
	{
		CheckStatus(GdipDrawLines(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawLines(const TGpPen* pen, TGpPoint const *points, const int points_Size)
	{
    	CheckStatus(GdipDrawLinesI(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawArc(const TGpPen* pen,
        float x, float y, float width, float height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipDrawArc(Native, pen->Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall DrawArc(const TGpPen* pen, const TGpRectF &rect, float startAngle, float sweepAngle)
	{
		DrawArc(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall DrawArc(const TGpPen* pen, int x, int y, int width, int height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipDrawArcI(Native, pen->Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall DrawArc(const TGpPen* pen, const TGpRect &rect, float startAngle, float sweepAngle)
	{
		DrawArc(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall DrawBezier(const TGpPen* pen, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
	{
		CheckStatus(GdipDrawBezier(Native, pen->Native, x1, y1, x2, y2, x3, y3, x4, y4));
    }
	void __fastcall DrawBezier(const TGpPen* pen, const TGpPointF &pt1, const TGpPointF &pt2, const TGpPointF &pt3, const TGpPointF &pt4)
	{
		DrawBezier(pen, pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
    }
	void __fastcall DrawBezier(const TGpPen* pen, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)
	{
		CheckStatus(GdipDrawBezierI(Native, pen->Native, x1, y1, x2, y2, x3, y3, x4, y4));
    }
	void __fastcall DrawBezier(const TGpPen* pen, const TGpPoint &pt1, const TGpPoint &pt2, const TGpPoint &pt3, const TGpPoint &pt4)
	{
		DrawBezier(pen, pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
    }
	void __fastcall DrawBeziers(const TGpPen* pen, TGpPointF const *points, const int points_Size)
	{
		CheckStatus(GdipDrawBeziers(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawBeziers(const TGpPen* pen, TGpPoint const *points, const int points_Size)
	{
		CheckStatus(GdipDrawBeziersI(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawRectangle(const TGpPen* pen, const TGpRectF &rect)
	{
		DrawRectangle(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall DrawRectangle(const TGpPen* pen, float x, float y, float width, float height)
	{
		CheckStatus(GdipDrawRectangle(Native, pen->Native, x, y, width, height));
    }
	void __fastcall DrawRectangle(const TGpPen* pen, const TGpRect &rect)
	{
		DrawRectangle(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall DrawRectangle(const TGpPen* pen, int x, int y, int width, int height)
	{
		CheckStatus(GdipDrawRectangleI(Native, pen->Native, x, y, width, height));
    }
	void __fastcall DrawRectangles(const TGpPen* pen, TGpRectF const *rects, const int rects_Size)
	{
		CheckStatus(GdipDrawRectangles(Native, pen->Native, rects, rects_Size));
    }
	void __fastcall DrawRectangles(const TGpPen* pen, TGpRect const *rects, const int rects_Size)
	{
		CheckStatus(GdipDrawRectanglesI(Native, pen->Native, rects, rects_Size));
    }
	void __fastcall DrawEllipse(const TGpPen* pen, const TGpRectF &rect)
	{
		DrawEllipse(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall DrawEllipse(const TGpPen* pen, float x, float y, float width, float height)
	{
		CheckStatus(GdipDrawEllipse(Native, pen->Native, x, y, width, height));
    }
	void __fastcall DrawEllipse(const TGpPen* pen, const TGpRect &rect)
	{
		DrawEllipse(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall DrawEllipse(const TGpPen* pen, int x, int y, int width, int height)
	{
		CheckStatus(GdipDrawEllipseI(Native, pen->Native, x, y, width, height));
    }
	void __fastcall DrawPie(const TGpPen* pen, const TGpRectF &rect, float startAngle, float sweepAngle)
	{
		DrawPie(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall DrawPie(const TGpPen* pen, float x, float y, float width, float height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipDrawPie(Native, pen->Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall DrawPie(const TGpPen* pen, const TGpRect &rect, float startAngle, float sweepAngle)
	{
		DrawPie(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall DrawPie(const TGpPen* pen, int x, int y, int width, int height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipDrawPieI(Native, pen->Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall DrawPolygon(const TGpPen* pen, TGpPointF const * points, const int points_Size)
	{
		CheckStatus(GdipDrawPolygon(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawPolygon(const TGpPen* pen, TGpPoint const * points, const int points_Size)
	{
		CheckStatus(GdipDrawPolygonI(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawPath(const TGpPen* pen, const TGpGraphicsPath* path)
	{
		CheckStatus(GdipDrawPath(Native, pen? pen->Native : NULL, path? path->Native : NULL));
    }
	void __fastcall DrawCurve(const TGpPen* pen, TGpPointF const *points, const int points_Size)
	{
		CheckStatus(GdipDrawCurve(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawCurve(const TGpPen* pen, TGpPointF const *points, const int points_Size, float tension)
	{
		CheckStatus(GdipDrawCurve2(Native, pen->Native, points, points_Size, tension));
    }
	void __fastcall DrawCurve(const TGpPen* pen, TGpPointF const *points,
        const int points_Size, int offset, int numberOfSegments, float tension = 0.5)
	{
		CheckStatus(GdipDrawCurve3(Native, pen->Native,
            points, points_Size, offset, numberOfSegments, tension));
	}
	void __fastcall DrawCurve(const TGpPen* pen, TGpPoint const *points, const int points_Size)
	{
		CheckStatus(GdipDrawCurveI(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawCurve(const TGpPen* pen, TGpPoint const *points, const int points_Size, float tension)
	{
		CheckStatus(GdipDrawCurve2I(Native, pen->Native, points, points_Size, tension));
    }
	void __fastcall DrawCurve(const TGpPen* pen, TGpPoint const *points,
        const int points_Size, int offset, int numberOfSegments, float tension = 0.5)
	{
    	CheckStatus(GdipDrawCurve3I(Native, pen->Native,
            points, points_Size, offset, numberOfSegments, tension));
    }
	void __fastcall DrawClosedCurve(const TGpPen* pen, const TGpPointF *points, const int points_Size)
	{
		CheckStatus(GdipDrawClosedCurve(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawClosedCurve(const TGpPen* pen,
        const TGpPointF *points, const int points_Size, float tension)
	{
		CheckStatus(GdipDrawClosedCurve2(Native, pen->Native, points, points_Size, tension));
	}
	void __fastcall DrawClosedCurve(const TGpPen* pen, const TGpPoint *points, const int points_Size)
	{
		CheckStatus(GdipDrawClosedCurveI(Native, pen->Native, points, points_Size));
    }
	void __fastcall DrawClosedCurve(const TGpPen* pen, const TGpPoint *points,
        const int points_Size, float tension)
	{
        CheckStatus(GdipDrawClosedCurve2I(Native, pen->Native, points, points_Size, tension));
    }
	void __fastcall FillRectangle(const TGpBrush* brush, const TGpRectF &rect)
	{
		FillRectangle(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall FillRectangle(const TGpBrush* brush, float x, float y, float width, float height)
	{
		CheckStatus(GdipFillRectangle(Native, brush->Native, x, y, width, height));
	}
	void __fastcall FillRectangle(const TGpBrush* brush, const TGpRect &rect)
	{
		FillRectangle(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall FillRectangle(const TGpBrush* brush, int x, int y, int width, int height)
	{
		CheckStatus(GdipFillRectangleI(Native, brush->Native, x, y, width, height));
    }
	void __fastcall FillRectangles(const TGpBrush* brush, TGpRectF const *rects, const int rects_Size)
	{
		CheckStatus(GdipFillRectangles(Native, brush->Native, rects, rects_Size));
	}
	void __fastcall FillRectangles(const TGpBrush* brush, TGpRect const *rects, const int rects_Size)
	{
		CheckStatus(GdipFillRectanglesI(Native, brush->Native, rects, rects_Size));
	}
	void __fastcall FillPolygon(const TGpBrush* brush, const TGpPointF *points,
        const int points_Size, Graphics::TFillMode fillMode = fmAlternate)
	{
		CheckStatus(GdipFillPolygon(Native, brush->Native,
            points, points_Size, (GdiplusSys::FillMode)(int)fillMode));
    }
	void __fastcall FillPolygon(const TGpBrush* brush, const TGpPoint *points,
        const int points_Size, Graphics::TFillMode fillMode = fmAlternate)
	{
		CheckStatus(GdipFillPolygonI(Native, brush->Native,
            points, points_Size, (GdiplusSys::FillMode)(int)fillMode));
    }
	void __fastcall FillEllipse(const TGpBrush* brush, const TGpRectF &rect)
	{
		FillEllipse(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall FillEllipse(const TGpBrush* brush, float x, float y, float width, float height)
	{
		CheckStatus(GdipFillEllipse(Native, brush->Native, x, y, width, height));
    }
	void __fastcall FillEllipse(const TGpBrush* brush, const TGpRect &rect)
	{
		FillEllipse(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall FillEllipse(const TGpBrush* brush, int x, int y, int width, int height)
	{
		CheckStatus(GdipFillEllipseI(Native, brush->Native, x, y, width, height));
    }
	void __fastcall FillPie(const TGpBrush* brush, const TGpRectF &rect, float startAngle, float sweepAngle)
	{
		FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall FillPie(const TGpBrush* brush,
        float x, float y, float width, float height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipFillPie(Native, brush->Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall FillPie(const TGpBrush* brush, const TGpRect &rect, float startAngle, float sweepAngle)
	{
		FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall FillPie(const TGpBrush* brush,
        int x, int y, int width, int height, float startAngle, float sweepAngle)
	{
		CheckStatus(GdipFillPieI(Native, brush->Native, x, y, width, height, startAngle, sweepAngle));
	}
	void __fastcall FillPath(const TGpBrush* brush, const TGpGraphicsPath* path)
	{
		CheckStatus(GdipFillPath(Native, brush->Native, path->Native));
    }
	void __fastcall FillClosedCurve(const TGpBrush* brush, const TGpPointF *points, const int points_Size)
	{
		CheckStatus(GdipFillClosedCurve(Native, brush->Native, points, points_Size));
    }
	void __fastcall FillClosedCurve(const TGpBrush* brush, const TGpPointF *points,
        const int points_Size, Graphics::TFillMode fillMode, float tension = 0.5)
	{
		CheckStatus(GdipFillClosedCurve2(Native, brush->Native,
					points, points_Size, tension, (GdiplusSys::FillMode)(int)fillMode));
    }
	void __fastcall FillClosedCurve(const TGpBrush* brush, const TGpPoint *points, const int points_Size)
	{
		CheckStatus(GdipFillClosedCurveI(Native, brush->Native, points, points_Size));
    }
	void __fastcall FillClosedCurve(const TGpBrush* brush, const TGpPoint *points,
        const int points_Size, Graphics::TFillMode fillMode, float tension = 0.5)
	{
		CheckStatus(GdipFillClosedCurve2I(Native, brush->Native,
					points, points_Size, tension, (GdiplusSys::FillMode)(int)fillMode));
    }
	void __fastcall FillRegion(const TGpBrush* brush, const TGpRegion* region)
	{
		CheckStatus(GdipFillRegion(Native, brush->Native, region->Native));
    }
	void __fastcall DrawString(const WideString str, const TGpFont* font,
        const TGpBrush* brush, const TGpRectF &layoutRect, const TGpStringFormat* format = NULL)
	{
		CheckStatus(GdipDrawString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
					&layoutRect, ObjectNative(format), ObjectNative(brush)));
    }
	void __fastcall DrawString(const WideString str, const TGpFont* font,
        const TGpBrush* brush, float x, float y, const TGpStringFormat* format = NULL)
	{
		TGpRectF r(x, y, 0.0, 0.0);
		CheckStatus(GdipDrawString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
							 &r, ObjectNative(format), ObjectNative(brush)));
    }
	void __fastcall DrawString(const WideString str, const TGpFont* font,
        const TGpBrush* brush, const TGpPointF &origin, const TGpStringFormat* format = NULL)
	{
    	TGpRectF r(origin.X, origin.Y, 0.0, 0.0);
		CheckStatus(GdipDrawString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
							 &r, ObjectNative(format), ObjectNative(brush)));
    }
	TGpRectF __fastcall MeasureString(const WideString str, const TGpFont* font,
        const TGpSizeF &layoutArea, const TGpStringFormat* format = NULL, int* codepointsFitted = NULL, int* linesFilled = NULL)
	{
		TGpRectF rr, r(0.0, 0.0, layoutArea.Width, layoutArea.Height);
		CheckStatus(GdipMeasureString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
					&r, ObjectNative(format), &rr, codepointsFitted, linesFilled));
		return rr;
    }
	TGpRectF __fastcall MeasureString(const WideString str, const TGpFont* font,
        const TGpRectF &layoutRect, const TGpStringFormat* format = NULL)
	{
		TGpRectF rr;
		CheckStatus(GdipMeasureString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
					&layoutRect, ObjectNative(format), &rr, NULL, NULL));
		return rr;
	}
	TGpRectF __fastcall MeasureString(const WideString str, const TGpFont* font,
        const TGpPointF &origin, const TGpStringFormat* format = NULL)
	{
		TGpRectF rr, r(origin.X, origin.Y, 0.0, 0.0);
		CheckStatus(GdipMeasureString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
					&r, ObjectNative(format), &rr, NULL, NULL));
		return rr;
    }
	TGpRectF __fastcall MeasureString(const WideString str,
        const TGpFont* font, int width = 0, const TGpStringFormat* format = NULL)
    {
		TGpRectF rr, r(0.0, 0.0, width, 0.0);
		CheckStatus(GdipMeasureString(Native, str.c_bstr(), str.Length(), ObjectNative(font),
					&r, ObjectNative(format), &rr, NULL, NULL));
		return rr;
	}
	void __fastcall MeasureCharacterRanges(const WideString str, const TGpFont* font,
        const TGpRectF &layoutRect, const TGpStringFormat* format, const TGpRegion** regions, const int regions_Size)
	{
		if (!regions || regions_Size <= 0) CheckStatus(InvalidParameter);
		GpRegion **nativeRegions = new GpRegion* [regions_Size];
		try
		{
			for (int i = 0; i < regions_Size; i ++)
				nativeRegions[i] = regions[i]->Native;
			CheckStatus(GdipMeasureCharacterRanges(Native, str.c_bstr(), str.Length(),
						ObjectNative(font), layoutRect,
						ObjectNative(format), regions_Size, nativeRegions));
		}
		__finally
		{
			delete[] nativeRegions;
        }
	}
	void __fastcall DrawDriverString(const WORD *text, int length, const TGpFont* font,
        const TGpBrush* brush, const TGpPointF *positions, int flags, const TGpMatrix* matrix)
	{
		CheckStatus(GdipDrawDriverString(Native, text, length, ObjectNative(font),
					ObjectNative(brush), positions, flags, ObjectNative(matrix)));
    }
	TGpRectF __fastcall MeasureDriverString(const WORD *text, int length,
        const TGpFont* font, const TGpPointF *positions, int flags, const TGpMatrix* matrix)
	{
		TGpRectF rr;
    	CheckStatus(GdipMeasureDriverString(Native, text, length, ObjectNative(font),
					positions, flags, ObjectNative(matrix), &rr));
		return rr;
    }
	void __fastcall DrawCachedBitmap(TGpCachedBitmap* cb, int x, int y)
	{
		CheckStatus(GdipDrawCachedBitmap(Native, cb->Native, x, y));
    }
	void __fastcall DrawImage(TGpImage* image, const TGpPointF &point)
	{
		DrawImage(image, point.X, point.Y);
    }
	void __fastcall DrawImage(TGpImage* image, float x, float y)
	{
		CheckStatus(GdipDrawImage(Native, image? image->Native : NULL, x, y));
	}
	void __fastcall DrawImage(TGpImage* image, const TGpPoint &point)
	{
		DrawImage(image, point.X, point.Y);
    }
	void __fastcall DrawImage(TGpImage* image, int x, int y)
	{
		CheckStatus(GdipDrawImageI(Native, image? image->Native : NULL, x, y));
    }
	void __fastcall DrawImage(TGpImage* image, const TGpRectF &rect)
	{
		DrawImage(image, rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall DrawImage(TGpImage* image, const TGpRect &rect)
	{
		DrawImage(image, rect.X, rect.Y, rect.Width, rect.Height);
	}
	void __fastcall DrawImage(TGpImage* image, int x, int y, int width, int height)
	{
		CheckStatus(GdipDrawImageRectI(Native, image? image->Native : NULL, x, y, width, height));
    }
	void __fastcall DrawImage(TGpImage* image, float x, float y, float width, float height)
	{
		CheckStatus(GdipDrawImageRect(Native, image? image->Native : NULL, x, y, width, height));
    }
	void __fastcall DrawImage(TGpImage* image, TGpPointF const *destPoints, const int destPoints_Size)
	{
		if (destPoints_Size != 3 && destPoints_Size != 4)
			CheckStatus(InvalidParameter);
		CheckStatus(GdipDrawImagePoints(Native, image? image->Native : NULL, destPoints, destPoints_Size));
	}
	void __fastcall DrawImage(TGpImage* image, TGpPoint const *destPoints, const int destPoints_Size)
	{
		if (destPoints_Size != 3 && destPoints_Size != 4)
			CheckStatus(InvalidParameter);
		CheckStatus(GdipDrawImagePointsI(Native, image? image->Native : NULL, destPoints, destPoints_Size));
    }
	void __fastcall DrawImage(TGpImage* image, float x, float y,
        float srcx, float srcy, float srcwidth, float srcheight, TUnit srcUnit)
	{
		CheckStatus(GdipDrawImagePointRect(Native, image? image->Native : NULL,
            x, y, srcx, srcy, srcwidth, srcheight, (GdiplusSys::Unit)(int)srcUnit));
	}
	void __fastcall DrawImage(TGpImage* image, int x, int y,
        int srcx, int srcy, int srcwidth, int srcheight, TUnit srcUnit)
	{
		CheckStatus(GdipDrawImagePointRectI(Native, image? image->Native : NULL,
            x, y, srcx, srcy, srcwidth, srcheight, (GdiplusSys::Unit)(int)srcUnit));
    }
	void __fastcall DrawImage(TGpImage* image, float x, float y, const TGpRectF &srcRect, TUnit srcUnit)
	{
		CheckStatus(GdipDrawImagePointRect(Native, image? image->Native : NULL,
            x, y, srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, (GdiplusSys::Unit)(int)srcUnit));
    }
	void __fastcall DrawImage(TGpImage* image, int x, int y, const TGpRect &srcRect, TUnit srcUnit)
	{
    	CheckStatus(GdipDrawImagePointRectI(Native, image? image->Native : NULL,
            x, y, srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, (GdiplusSys::Unit)(int)srcUnit));
    }
	void __fastcall DrawImage(TGpImage* image, const TGpRectF &destRect,
		float srcx, float srcy, float srcwidth, float srcheight, TUnit srcUnit,
		const TGpImageAttributes* imageAttributes = NULL,
		TImageAbort callback = NULL, void *callbackData = NULL)
	{
		CheckStatus(GdipDrawImageRectRect(Native, image? image->Native : NULL,
					destRect.X, destRect.Y, destRect.Width, destRect.Height,
					srcx, srcy, srcwidth, srcheight, (GdiplusSys::Unit)(int)srcUnit,
					ObjectNative(imageAttributes), callback, callbackData));
    }
	void __fastcall DrawImage(TGpImage* image, const TGpRect &destRect,
		int srcx, int srcy, int srcwidth, int srcheight, TUnit srcUnit,
		const TGpImageAttributes* imageAttributes = NULL,
		TImageAbort callback = NULL, void *callbackData = NULL)
	{
		CheckStatus(GdipDrawImageRectRectI(Native, image? image->Native : NULL,
					destRect.X, destRect.Y, destRect.Width, destRect.Height,
					srcx, srcy, srcwidth, srcheight, (GdiplusSys::Unit)(int)srcUnit,
					ObjectNative(imageAttributes), callback, callbackData));
    }
	void __fastcall DrawImage(TGpImage* image, TGpPointF const * destPoints,
		const int destPoints_Size, float srcx, float srcy, float srcwidth, float srcheight,
		TUnit srcUnit, const TGpImageAttributes* imageAttributes = NULL,
		TImageAbort callback = NULL, void *callbackData = NULL)
	{
		CheckStatus(GdipDrawImagePointsRect(Native, image? image->Native : NULL, destPoints,
					destPoints_Size, srcx, srcy, srcwidth, srcheight, (GdiplusSys::Unit)(int)srcUnit,
					ObjectNative(imageAttributes), callback, callbackData));
    }
	void __fastcall DrawImage(TGpImage* image, TGpPoint const * destPoints,
		const int destPoints_Size, int srcx, int srcy, int srcwidth, int srcheight,
		TUnit srcUnit, const TGpImageAttributes* imageAttributes = NULL,
		TImageAbort callback = NULL, void *callbackData = NULL)
	{
		CheckStatus(GdipDrawImagePointsRectI(Native, image? image->Native : NULL,
					destPoints, destPoints_Size, srcx, srcy, srcwidth, srcheight,
					(GdiplusSys::Unit)(int)srcUnit, ObjectNative(imageAttributes),
                    callback, callbackData));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, const TGpPointF &destPoint,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileDestPoint(
					Native, ObjectNative(metafile), destPoint,
					callback, callbackData, ObjectNative(imageAttributes)));
	}
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, const TGpPoint &destPoint,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileDestPointI(
					Native, ObjectNative(metafile), destPoint,
					callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, const TGpRectF &destRect,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileDestRect(Native, ObjectNative(metafile),
					destRect, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, const TGpRect &destRect,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileDestRectI(Native, ObjectNative(metafile),
					destRect, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, TGpPointF const * destPoints, const int destPoints_Size,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileDestPoints(
					Native, ObjectNative(metafile), destPoints, destPoints_Size,
					callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, TGpPoint const * destPoints, const int destPoints_Size,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
		CheckStatus(GdipEnumerateMetafileDestPointsI(
					Native, ObjectNative(metafile), destPoints, destPoints_Size,
					callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile,
		const TGpPointF &destPoint, const TGpRectF &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestPoint(
					Native, ObjectNative(metafile), destPoint, srcRect,
					(GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile,
		const TGpPoint &destPoint, const TGpRect &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestPointI(
					Native, ObjectNative(metafile), destPoint, srcRect,
					(GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile,
		const TGpRectF &destRect, const TGpRectF &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestRect(
				  Native, ObjectNative(metafile), destRect, srcRect,
				  (GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
	}
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile,
		const TGpRect &destRect, const TGpRect &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestRectI(
					Native, ObjectNative(metafile), destRect, srcRect,
					(GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, TGpPointF const *destPoints,
		const int destPoints_Size, const TGpRectF &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestPoints(
					Native, ObjectNative(metafile), destPoints, destPoints_Size,
					srcRect, (GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall EnumerateMetafile(const TGpMetafile* metafile, TGpPoint const *destPoints,
		const int destPoints_Size, const TGpRect &srcRect, TUnit srcUnit,
		TEnumerateMetafileProc callback, void *callbackData = NULL, const TGpImageAttributes* imageAttributes = NULL)
	{
    	CheckStatus(GdipEnumerateMetafileSrcRectDestPointsI(
					Native, ObjectNative(metafile), destPoints, destPoints_Size,
					srcRect, (GdiplusSys::Unit)(int)srcUnit, callback, callbackData, ObjectNative(imageAttributes)));
    }
	void __fastcall SetClip(const TGpGraphics* g, TCombineMode combineMode = cmReplace)
	{
		CheckStatus(GdipSetClipGraphics(Native, g->Native, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall SetClip(const TGpRectF &rect, TCombineMode combineMode = cmReplace)
	{
    	CheckStatus(GdipSetClipRect(Native, rect.X, rect.Y,
					rect.Width, rect.Height, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall SetClip(const TGpRect &rect, TCombineMode combineMode = cmReplace)
	{
        CheckStatus(GdipSetClipRectI(Native, rect.X, rect.Y,
					rect.Width, rect.Height, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall SetClip(const TGpGraphicsPath* path, TCombineMode combineMode = cmReplace)
	{
		CheckStatus(GdipSetClipPath(Native, path->Native, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall SetClip(const TGpRegion* region, TCombineMode combineMode = cmReplace)
	{
		CheckStatus(GdipSetClipRegion(Native, region->Native, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall SetClip(HRGN hRgn, TCombineMode combineMode = cmReplace)
	{
		CheckStatus(GdipSetClipHrgn(Native, hRgn, (GdiplusSys::CombineMode)(int)combineMode));
    }
	void __fastcall IntersectClip(const TGpRectF &rect)
	{
		CheckStatus(GdipSetClipRect(Native, rect.X, rect.Y, rect.Width, rect.Height, CombineModeIntersect));
	}
	void __fastcall IntersectClip(const TGpRect &rect)
	{
		CheckStatus(GdipSetClipRectI(Native, rect.X, rect.Y, rect.Width, rect.Height, CombineModeIntersect));
    }
	void __fastcall IntersectClip(const TGpRegion* region)
	{
		CheckStatus(GdipSetClipRegion(Native, region->Native, CombineModeIntersect));
    }
	void __fastcall ExcludeClip(const TGpRectF &rect)
	{
		CheckStatus(GdipSetClipRect(Native, rect.X, rect.Y, rect.Width, rect.Height, CombineModeExclude));
    }
	void __fastcall ExcludeClip(const TGpRect &rect)
	{
		CheckStatus(GdipSetClipRectI(Native, rect.X, rect.Y, rect.Width, rect.Height, CombineModeExclude));
    }
	void __fastcall ExcludeClip(const TGpRegion* region)
	{
		CheckStatus(GdipSetClipRegion(Native, region->Native, CombineModeExclude));
    }
	void __fastcall ResetClip(void)
	{
		CheckStatus(GdipResetClip(Native));
    }
	void __fastcall TranslateClip(float dx, float dy)
	{
		CheckStatus(GdipTranslateClip(Native, dx, dy));
    }
	void __fastcall TranslateClip(int dx, int dy)
	{
		CheckStatus(GdipTranslateClipI(Native, dx, dy));
    }
	void __fastcall GetClip(TGpRegion* region)
	{
		CheckStatus(GdipGetClip(Native, region->Native));
    }
	void __fastcall GetClipBounds(TGpRectF &rect)
	{
		CheckStatus(GdipGetClipBounds(Native, &rect));
    }
	void __fastcall GetClipBounds(TGpRect &rect)
	{
		CheckStatus(GdipGetClipBoundsI(Native, &rect));
    }
	bool __fastcall IsClipEmpty(void)
	{
		CheckStatus(GdipIsClipEmpty(Native, &Result.rBOOL));
		return Result.rBOOL;
	}
	void __fastcall GetVisibleClipBounds(TGpRectF &rect)
	{
		CheckStatus(GdipGetVisibleClipBounds(Native, &rect));
	}
	void __fastcall GetVisibleClipBounds(TGpRect &rect)
	{
		CheckStatus(GdipGetVisibleClipBoundsI(Native, &rect));
	}
	bool __fastcall IsVisibleClipEmpty(void)
	{
		CheckStatus(GdipIsVisibleClipEmpty(Native, &Result.rBOOL));
		return Result.rBOOL;
    }
	bool __fastcall IsVisible(int x, int y)
	{
		return IsVisible(TGpPoint(x,y));
    }
	bool __fastcall IsVisible(const TGpPoint &point)
	{
		CheckStatus(GdipIsVisiblePointI(Native, point.X, point.Y, &Result.rBOOL));
		return Result.rBOOL;
	}
	bool __fastcall IsVisible(int x, int y, int width, int height)
	{
		return IsVisible(TGpRect(x, y, width, height));
    }
	bool __fastcall IsVisible(const TGpRect &rect)
	{
		CheckStatus(GdipIsVisibleRectI(Native, rect.X, rect.Y, rect.Width, rect.Height, &Result.rBOOL));
		return Result.rBOOL;
    }
	bool __fastcall IsVisible(float x, float y)
	{
		return IsVisible(TGpPointF(x, y));
    }
	bool __fastcall IsVisible(const TGpPointF &point)
	{
		CheckStatus(GdipIsVisiblePoint(Native, point.X, point.Y, &Result.rBOOL));
		return Result.rBOOL;
	}
	bool __fastcall IsVisible(float x, float y, float width, float height)
	{
		return IsVisible(TGpRectF(x, y, width, height));
    }
	bool __fastcall IsVisible(const TGpRectF &rect)
	{
		CheckStatus(GdipIsVisibleRect(Native, rect.X, rect.Y, rect.Width, rect.Height, &Result.rBOOL));
		return Result.rBOOL;
	}
	TGraphicsState __fastcall Save(void)
	{
		CheckStatus(GdipSaveGraphics(Native, &Result.rUINT));
		return Result.rUINT;
    }
	void __fastcall Restore(TGraphicsState gstate)
	{
		CheckStatus(GdipRestoreGraphics(Native, gstate));
	}
	TGraphicsContainer __fastcall BeginContainer(const TGpRectF &dstrect,
		const TGpRectF &srcrect, TUnit unit)
	{
		CheckStatus(GdipBeginContainer(Native, &dstrect, &srcrect,
			(GdiplusSys::Unit)(int)unit, &Result.rUINT));
		return Result.rUINT;
	}
	TGraphicsContainer __fastcall BeginContainer(const TGpRect &dstrect,
		const TGpRect &srcrect, TUnit unit)
	{
		CheckStatus(GdipBeginContainerI(Native, &dstrect, &srcrect,
			(GdiplusSys::Unit)(int)unit, &Result.rUINT));
		return Result.rUINT;
    }
	TGraphicsContainer __fastcall BeginContainer(void)
	{
		CheckStatus(GdipBeginContainer2(Native, &Result.rUINT));
		return Result.rUINT;
    }
	void __fastcall EndContainer(TGraphicsContainer state)
	{
		CheckStatus(GdipEndContainer(Native, state));
    }
	void __fastcall AddMetafileComment(const Byte *data, int sizeData)
	{
		CheckStatus(GdipComment(Native, sizeData, data));
    }
	static HPALETTE __fastcall GetHalftonePalette(void)
	{
		HPALETTE palette;
		palette = GdipCreateHalftonePalette();
		return palette;
	}

	__property TGpPoint RenderingOrigin = {read=GetRenderingOrigin, write=SetRenderingOrigin};
	__property TCompositingMode CompositingMode = {read=GetCompositingMode, write=SetCompositingMode, nodefault};
	__property TCompositingQuality CompositingQuality = {read=GetCompositingQuality, write=SetCompositingQuality, nodefault};
	__property TTextRenderingHint TextRenderingHint = {read=GetTextRenderingHint, write=SetTextRenderingHint, nodefault};
	__property int TextContrast = {read=GetTextContrast, write=SetTextContrast, nodefault};
	__property TInterpolationMode InterpolationMode = {read=GetInterpolationMode, write=SetInterpolationMode, nodefault};
	__property TSmoothingMode SmoothingMode = {read=GetSmoothingMode, write=SetSmoothingMode, nodefault};
	__property TPixelOffsetMode PixelOffsetMode = {read=GetPixelOffsetMode, write=SetPixelOffsetMode, nodefault};
	__property TUnit PageUnit = {read=GetPageUnit, write=SetPageUnit, nodefault};
	__property float PageScale = {read=GetPageScale, write=SetPageScale};
	__property float DpiX = {read=GetDpiX};
	__property float DpiY = {read=GetDpiY};

};

#endif
