/**************************************************************************\
*
* Module Name:
*
*   GdipPath.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipPathHPP
#define GdipPathHPP

//
enum TPathPointType
{
    //*ptStart,             // 指定 Path 的起始点。缺省（空）为ptStart
    ptLine,                 // 指定直线段。
    ptBezier,               // 指定默认的贝塞尔曲线。
    ptTypeMask,             // 指定掩码点
    ptDashMode = 4,         // 指定对应线段为虚线。
    ptPathMarker,           // 指定路径标记。
    ptCloseSubpath = 7,     // 指定子路径的终结点。
    ptBezier3 = ptBezier    // 指定立方贝塞尔曲线。
};

typedef Set<TPathPointType, ptLine, ptCloseSubpath>  TPathPointTypes;

enum TWarpMode { wmPerspective, wmBilinear };

class TGpGraphicsPath : public TGdiplusBase
{
private:
    friend  class TGpGraphics;
    friend  class TGpRegion;
    friend  class TGpPathGradientBrush;
    friend  class TGpGraphicsPathIterator;
    friend  class TGpCustomLineCap;

	TFillMode __fastcall GetFillMode(void)
	{
        CheckStatus(GdipGetPathFillMode(Native, (GdiplusSys::FillMode*)&Result.rINT));
        return (TFillMode)Result.rINT;
    }
	void __fastcall SetFillMode(TFillMode fillMode)
	{
        CheckStatus(GdipSetPathFillMode(Native, (GdiplusSys::FillMode)(int)fillMode));
    }
	TGpPointF __fastcall GetLastPoint()
	{
        TGpPointF p;
        CheckStatus(GdipGetPathLastPoint(Native, &p));
        return p;
    }
	int __fastcall GetPointCount(void)
	{
        CheckStatus(GdipGetPointCount(Native, &Result.rINT));
        return Result.rINT;
    }
	TPathData __fastcall GetPathData(void)
	{
        TPathData pathData;
        pathData.SetCount(PointCount);
        if (pathData.Count > 0)
            CheckStatus(GdipGetPathData(Native, &pathData));
        return pathData;
    }

protected:
	__fastcall TGpGraphicsPath(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpGraphicsPath));
	}
#endif
public:
	__fastcall TGpGraphicsPath(TFillMode fillMode = fmAlternate)
	{
        CheckStatus(GdipCreatePath((GdiplusSys::FillMode)(int)fillMode, &Native));
    }
	__fastcall TGpGraphicsPath(const TGpPointF * points, TPathPointTypes *types,
		const int count, TFillMode fillMode = fmAlternate)
	{
        for (int i = 0; i < count; i ++)
        {
            if (types[i].Contains(ptTypeMask))
                types[i] << ptBezier;
            if (types[i].Contains(ptBezier))
                types[i] << ptLine;
        }
        CheckStatus(GdipCreatePath2(points, (Byte*)types, count,
            (GdiplusSys::FillMode)(int)fillMode, &Native));
    }
	__fastcall TGpGraphicsPath(const TGpPoint * points, TPathPointTypes *types,
		const int count, TFillMode fillMode = fmAlternate)
	{
        for (int i = 0; i < count; i ++)
        {
            if (types[i].Contains(ptTypeMask))
                types[i] << ptBezier;
            if (types[i].Contains(ptBezier))
                types[i] << ptLine;
        }
        CheckStatus(GdipCreatePath2I(points, (Byte*)types, count,
            (GdiplusSys::FillMode)(int)fillMode, &Native));
    }
	__fastcall virtual ~TGpGraphicsPath(void)
	{
        GdipDeletePath(Native);
    }
	TGpGraphicsPath* __fastcall Clone(void)
    {
         return new TGpGraphicsPath(Native, (TCloneAPI)GdipClonePath);
    }
	void __fastcall AddLine(const TGpPointF &pt1, const TGpPointF &pt2)
	{
        AddLine(pt1.X, pt1.Y, pt2.X, pt2.Y);
    }
	void __fastcall AddLine(float x1, float y1, float x2, float y2)
	{
        CheckStatus(GdipAddPathLine(Native, x1, y1, x2, y2));
    }
	void __fastcall AddLine(const TGpPoint &pt1, const TGpPoint &pt2)
	{
        AddLine(pt1.X, pt1.Y, pt2.X, pt2.Y);
    }
	void __fastcall AddLine(int x1, int y1, int x2, int y2)
	{
        CheckStatus(GdipAddPathLineI(Native, x1, y1, x2, y2));
    }
	void __fastcall AddLines(const TGpPointF *points, const int points_Size)
	{
        CheckStatus(GdipAddPathLine2(Native, points, points_Size));
    }
	void __fastcall AddLines(const TGpPoint *points, const int points_Size)
	{
        CheckStatus(GdipAddPathLine2I(Native, points, points_Size));
    }
	void __fastcall AddArc(const TGpRectF &rect, float startAngle, float sweepAngle)
	{
        AddArc(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall AddArc(float x, float y, float width, float height, float startAngle, float sweepAngle)
	{
        CheckStatus(GdipAddPathArc(Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall AddArc(const TGpRect &rect, float startAngle, float sweepAngle)
	{
        AddArc(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall AddArc(int x, int y, int width, int height, float startAngle, float sweepAngle)
	{
        CheckStatus(GdipAddPathArcI(Native, x, y, width, height, startAngle, sweepAngle));
    }
	void __fastcall AddBezier(const TGpPointF &pt1, const TGpPointF &pt2,
        const TGpPointF &pt3, const TGpPointF &pt4)
	{
        AddBezier(pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
    }
	void __fastcall AddBezier(float x1, float y1, float x2, float y2,
        float x3, float y3, float x4, float y4)
	{
        CheckStatus(GdipAddPathBezier(Native, x1, y1, x2, y2, x3, y3, x4, y4));
    }
	void __fastcall AddBezier(const TGpPoint &pt1, const TGpPoint &pt2,
        const TGpPoint &pt3, const TGpPoint &pt4)
	{
        AddBezier(pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
    }
	void __fastcall AddBezier(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)
	{
        CheckStatus(GdipAddPathBezierI(Native, x1, y1, x2, y2, x3, y3, x4, y4));
    }
	void __fastcall AddBeziers(const TGpPointF *points, const int points_Size)
	{
        CheckStatus(GdipAddPathBeziers(Native, points, points_Size));
    }
	void __fastcall AddBeziers(const TGpPoint *points, const int points_Size)
	{
        CheckStatus(GdipAddPathBeziersI(Native, points, points_Size));
    }
	void __fastcall AddCurve(const TGpPointF *points, const int points_Size)
	{
        CheckStatus(GdipAddPathCurve(Native, points, points_Size));
    }
	void __fastcall AddCurve(const TGpPointF *points, const int points_Size, float tension)
	{
        CheckStatus(GdipAddPathCurve2(Native, points, points_Size, tension));
    }
	void __fastcall AddCurve(const TGpPointF *points, const int points_Size,
        int offset, int numberOfSegments, float tension)
	{
        CheckStatus(GdipAddPathCurve3(Native, points, points_Size, offset, numberOfSegments, tension));
    }
	void __fastcall AddCurve(const TGpPoint *points, const int points_Size)
	{
        CheckStatus(GdipAddPathCurveI(Native, points, points_Size));
    }
	void __fastcall AddCurve(const TGpPoint *points, const int points_Size, float tension)
	{
        CheckStatus(GdipAddPathCurve2I(Native, points, points_Size, tension));
    }
	void __fastcall AddCurve(const TGpPoint *points, const int points_Size,
        int offset, int numberOfSegments, float tension)
	{
        CheckStatus(GdipAddPathCurve3I(Native, points, points_Size, offset, numberOfSegments, tension));
    }
	void __fastcall AddClosedCurve(const TGpPointF *points, const int points_Size)
	{
        CheckStatus(GdipAddPathClosedCurve(Native, points, points_Size));
    }
	void __fastcall AddClosedCurve(const TGpPointF *points, const int points_Size, float tension)
	{
        CheckStatus(GdipAddPathClosedCurve2(Native, points, points_Size, tension));
    }
	void __fastcall AddClosedCurve(const TGpPoint *points, const int points_Size)
	{
        CheckStatus(GdipAddPathClosedCurveI(Native, points, points_Size));
    }
	void __fastcall AddClosedCurve(const TGpPoint *points, const int points_Size, float tension)
	{
        CheckStatus(GdipAddPathClosedCurve2I(Native, points, points_Size, tension));
    }
	void __fastcall AddRectangle(const TGpRectF &rect)
	{
        AddRectangle(rect.X, rect.Y, rect.Width, rect.Height);
    }
    void _fastcall AddRectangle(float x, float y, float Width, float Height)
    {
        CheckStatus(GdipAddPathRectangle(Native, x, y, Width, Height));
    }
	void __fastcall AddRectangle(const TGpRect &rect)
	{
        AddRectangle(rect.X, rect.Y, rect.Width, rect.Height);
    }
    void _fastcall AddRectangle(int x, int y, int Width, int Height)
    {
        CheckStatus(GdipAddPathRectangleI(Native, x, y, Width, Height));
    }
	void __fastcall AddRectangles(const TGpRectF *rects, const int rects_Size)
	{
        CheckStatus(GdipAddPathRectangles(Native, rects, rects_Size));
    }
	void __fastcall AddRectangles(const TGpRect *rects, const int rects_Size)
	{
        CheckStatus(GdipAddPathRectanglesI(Native, rects, rects_Size));
    }
	void __fastcall AddEllipse(const TGpRectF &rect)
	{
        AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall AddEllipse(float x, float y, float Width, float Height)
	{
        CheckStatus(GdipAddPathEllipse(Native, x, y, Width, Height));
    }
	void __fastcall AddEllipse(const TGpRect &rect)
	{
        AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
    }
	void __fastcall AddEllipse(int x, int y, int Width, int Height)
	{
        CheckStatus(GdipAddPathEllipseI(Native, x, y, Width, Height));
	}
	void __fastcall AddPie(const TGpRectF &rect, float startAngle, float sweepAngle)
	{
        AddPie(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall AddPie(float x, float y, float Width, float Height, float startAngle, float sweepAngle)
	{
        CheckStatus(GdipAddPathPie(Native, x, y, Width, Height, startAngle, sweepAngle));
    }
	void __fastcall AddPie(const TGpRect &rect, float startAngle, float sweepAngle)
	{
        AddPie(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
    }
	void __fastcall AddPie(int x, int y, int Width, int Height, float startAngle, float sweepAngle)
	{
        CheckStatus(GdipAddPathPieI(Native, x, y, Width, Height, startAngle, sweepAngle));
    }
	void __fastcall AddPolygon(const TGpPointF *points, const int points_Size)
	{
        CheckStatus(GdipAddPathPolygon(Native, points, points_Size));
    }
	void __fastcall AddPolygon(const TGpPoint *points, const int points_Size)
	{
        CheckStatus(GdipAddPathPolygonI(Native, points, points_Size));
    }
	void __fastcall AddPath(const TGpGraphicsPath *addingPath, bool connect)
	{
        CheckStatus(GdipAddPathPath(Native, ObjectNative(addingPath), connect));
    }
	void __fastcall AddString(const WideString str, const TGpFontFamily* family,
		TFontStyles style, float emSize, const TGpPointF &origin, const TGpStringFormat* format)
	{
        AddString(str, family, style, emSize, TGpRectF(origin.X, origin.Y, 0.0, 0.0), format);
	}
	void __fastcall AddString(const WideString str, const TGpFontFamily* family,
		TFontStyles style, float emSize, const TGpRectF &layoutRect, const TGpStringFormat* format)
	{
		CheckStatus(GdipAddPathString(Native, str.c_bstr(), str.Length(),
			  ObjectNative(family), SETTOBYTE(style), emSize, &layoutRect, ObjectNative(format)));
    }
	void __fastcall AddString(const WideString str, const TGpFontFamily* family,
		TFontStyles style, float emSize, const TGpPoint &origin, const TGpStringFormat* format)
	{
        AddString(str, family, style, emSize, TGpRect(origin.X, origin.Y, 0, 0), format);
    }
	void __fastcall AddString(const WideString str, const TGpFontFamily* family,
		TFontStyles style, float emSize, const TGpRect &layoutRect, const TGpStringFormat* format)
	{
        CheckStatus(GdipAddPathStringI(Native, str.c_bstr(), str.Length(),
			  ObjectNative(family), SETTOBYTE(style), emSize, &layoutRect, ObjectNative(format)));
    }
	void __fastcall Reset(void)
	{
        CheckStatus(GdipResetPath(Native));
    }
	void __fastcall StartFigure(void)
	{
        CheckStatus(GdipStartPathFigure(Native));
    }
	void __fastcall CloseFigure(void)
	{
        CheckStatus(GdipClosePathFigure(Native));
    }
	void __fastcall CloseAllFigures(void)
	{
        CheckStatus(GdipClosePathFigures(Native));
    }
	void __fastcall SetMarker(void)
	{
        CheckStatus(GdipSetPathMarker(Native));
    }
	void __fastcall ClearMarkers(void)
	{
        CheckStatus(GdipClearPathMarkers(Native));
    }
	void __fastcall Reverse(void)
	{
        CheckStatus(GdipReversePath(Native));
    }
	void __fastcall Transform(const TGpMatrix* matrix)
	{
        CheckStatus(GdipTransformPath(Native, matrix->Native));
    }
	void __fastcall GetBounds(TGpRectF &bounds, const TGpMatrix* matrix = NULL, const TGpPen* pen = NULL)
	{
        CheckStatus(GdipGetPathWorldBounds(Native, &bounds, ObjectNative(matrix), ObjectNative(pen)));
    }
	void __fastcall GetBounds(TGpRect &bounds, const TGpMatrix* matrix = NULL, const TGpPen* pen = NULL)
	{
        CheckStatus(GdipGetPathWorldBoundsI(Native, &bounds, ObjectNative(matrix), ObjectNative(pen)));
    }
	void __fastcall Flatten(const TGpMatrix* matrix = NULL, float flatness = FlatnessDefault)
    {
        CheckStatus(GdipFlattenPath(Native, matrix? matrix->Native : NULL, flatness));
    }
	void __fastcall Widen(const TGpPen* pen, const TGpMatrix* matrix = NULL, float flatness =FlatnessDefault)
    {
        CheckStatus(GdipWidenPath(Native, pen->Native, matrix? matrix->Native : NULL, flatness));
    }
	void __fastcall Outline(const TGpMatrix* matrix = NULL, float flatness = FlatnessDefault)
    {
        CheckStatus(GdipWindingModeOutline(Native, matrix? matrix->Native : NULL, flatness));
    }
	void __fastcall Warp(const TGpPointF * destPoints, const int destPoints_Size,
		const TGpRectF &srcRect, const TGpMatrix* matrix = NULL,
		TWarpMode warpMode = wmPerspective, float flatness = FlatnessDefault)
	{
         CheckStatus(GdipWarpPath(Native, matrix? matrix->Native : NULL, destPoints,
                           destPoints_Size, srcRect.X,  srcRect.Y,
                           srcRect.Width, srcRect.Height, (WarpMode)(int)warpMode, flatness));
	}
	void __fastcall GetPathPoints(TGpPoint *points)
	{
        CheckStatus(GdipGetPathPointsI(Native, points, PointCount));
    }
	void __fastcall GetPathPoints(TGpPointF *points)
	{
        CheckStatus(GdipGetPathPoints(Native, points, PointCount));
    }
	void __fastcall GetPathTypes(TPathPointTypes *types)
	{
        CheckStatus(GdipGetPathTypes(Native, (Byte*)types, PointCount));
    }
	bool __fastcall IsVisible(const TGpPointF &point, const TGpGraphics* g = NULL)
	{
        return IsVisible(point.X, point.Y, g);
    }
	bool __fastcall IsVisible(float x, float y, const TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpPoint &point, const TGpGraphics* g = NULL)
	{
        return IsVisible(point.X, point.Y, g);
    }
	bool __fastcall IsVisible(int x, int y, const TGpGraphics* g = NULL);
	bool __fastcall IsOutlineVisible(const TGpPointF &point, const TGpPen* pen, const TGpGraphics* g = NULL)
	{
        return IsOutlineVisible(point.X, point.Y, pen, g);
    }
	bool __fastcall IsOutlineVisible(float x, float y, const TGpPen* pen, const TGpGraphics* g = NULL);
	bool __fastcall IsOutlineVisible(const TGpPoint &point, const TGpPen* pen, const TGpGraphics* g = NULL)
	{
        return IsOutlineVisible(point.X, point.Y, pen, g);
    }
	bool __fastcall IsOutlineVisible(int x, int y, const TGpPen* pen, const TGpGraphics* g = NULL);
    /*
	{
        CheckStatus(GdipIsOutlineVisiblePathPointI(Native, x, y, ObjectNative(pen),
            g? g->Native : NULL, &Result.rBOOL));
        return Result.rBOOL;
    }
    */
	__property TFillMode FillMode = {read=GetFillMode, write=SetFillMode, nodefault};
	__property TGpPointF LastPoint = {read=GetLastPoint};
	__property int PointCount = {read=GetPointCount, nodefault};
	__property TPathData PathData = {read=GetPathData};

};

inline
TGpColor __fastcall TGpPathGradientBrush::GetCenterColor(void)
{
	CheckStatus(GdipGetPathGradientCenterColor(Native, &Result.rARGB));
	return TGpColor(Result.rARGB);
}
inline
void __fastcall TGpPathGradientBrush::SetCenterColor(const TGpColor color)
{
	CheckStatus(GdipSetPathGradientCenterColor(Native, color.Argb));
}
inline
int __fastcall TGpPathGradientBrush::GetPointCount(void)
{
	CheckStatus(GdipGetPathGradientPointCount(Native, &Result.rINT));
	return Result.rINT;
}
inline
int __fastcall TGpPathGradientBrush::GetSurroundColorCount(void)
{
	CheckStatus(GdipGetPathGradientSurroundColorCount(Native, &Result.rINT));
	return Result.rINT;
}
inline
void __fastcall TGpPathGradientBrush::SetGammaCorrection(bool useGammaCorrection)
{
	CheckStatus(GdipSetPathGradientGammaCorrection(Native, useGammaCorrection));
}
inline
bool __fastcall TGpPathGradientBrush::GetGammaCorrection(void)
{
	CheckStatus(GdipGetPathGradientGammaCorrection(Native, &Result.rINT));
	return Result.rBOOL;
}
inline
int __fastcall TGpPathGradientBrush::GetBlendCount(void)
{
	CheckStatus(GdipGetPathGradientBlendCount(Native, &Result.rINT));
	return Result.rINT;
}
inline
TWrapMode __fastcall TGpPathGradientBrush::GetWrapMode(void)
{
	CheckStatus(GdipGetPathGradientWrapMode(Native, (GdiplusSys::WrapMode*)&Result.rINT));
	return (TWrapMode)Result.rINT;
}
inline
void __fastcall TGpPathGradientBrush::SetWrapMode(TWrapMode wrapMode)
{
	CheckStatus(GdipSetPathGradientWrapMode(Native, (GdiplusSys::WrapMode)(int)wrapMode));
}
inline
TGpPointF __fastcall TGpPathGradientBrush::GetCenterPoint()
{
	TGpPointF point;
	CheckStatus(GdipGetPathGradientCenterPoint(Native, &point));
	return point;
}
inline
TGpPoint __fastcall TGpPathGradientBrush::GetCenterPointI()
{
	TGpPoint point;
	CheckStatus(GdipGetPathGradientCenterPointI(Native, &point));
	return point;
}
inline
TGpRectF __fastcall TGpPathGradientBrush::GetRectangle()
{
	TGpRectF rect;
	CheckStatus(GdipGetPathGradientRect(Native, &rect));
	return rect;
}
inline
TGpRect __fastcall TGpPathGradientBrush::GetRectangleI()
{
	TGpRect rect;
	CheckStatus(GdipGetPathGradientRectI(Native, &rect));
	return rect;
}
inline
void __fastcall TGpPathGradientBrush::SetCenterPoint(const TGpPointF &Value)
{
	CheckStatus(GdipSetPathGradientCenterPoint(Native, &Value));
}
inline
void __fastcall TGpPathGradientBrush::SetCenterPointI(const TGpPoint &Value)
{
	CheckStatus(GdipSetPathGradientCenterPointI(Native, &Value));
}
inline
TGpPointF __fastcall TGpPathGradientBrush::GetFocusScales()
{
	TGpPointF point;
	CheckStatus(GdipGetPathGradientFocusScales(Native, &point.X, &point.Y));
	return point;
}
inline
void __fastcall TGpPathGradientBrush::SetFocusScales(const TGpPointF &Value)
{
	CheckStatus(GdipSetPathGradientFocusScales(Native, Value.X, Value.Y));
}
inline
int __fastcall TGpPathGradientBrush::GetInterpolationColorCount(void)
{
	CheckStatus(GdipGetPathGradientPresetBlendCount(Native, &Result.rINT));
	return Result.rINT;
}
inline
__fastcall TGpPathGradientBrush::TGpPathGradientBrush(
    const TGpPointF *points, const int points_Size, TWrapMode wrapMode)
{
	CheckStatus(GdipCreatePathGradient(points, points_Size,
        (GdiplusSys::WrapMode)(int)wrapMode, &Native));
}
inline
__fastcall TGpPathGradientBrush::TGpPathGradientBrush(
    const TGpPoint *points, const int points_Size, TWrapMode wrapMode)
{
	CheckStatus(GdipCreatePathGradientI(points, points_Size,
        (GdiplusSys::WrapMode)(int)wrapMode, &Native));
}
inline
__fastcall TGpPathGradientBrush::TGpPathGradientBrush(TGpGraphicsPath* path)
{
	CheckStatus(GdipCreatePathGradientFromPath(path->Native, &Native));
}
inline
TGpPathGradientBrush* __fastcall TGpPathGradientBrush::Clone(void)
{
	return new TGpPathGradientBrush(Native, (TCloneAPI)GdipCloneBrush);
}
inline
int __fastcall TGpPathGradientBrush::GetSurroundColors(TGpColor *colors)
{
	Result.rINT = GetSurroundColorCount();
	CheckStatus(GdipGetPathGradientSurroundColorsWithCount(Native, (TARGB*)colors, &Result.rINT));
	return Result.rINT;
}
inline
int __fastcall TGpPathGradientBrush::SetSurroundColors(const TGpColor *colors, const int colors_Size)
{
	Result.rINT = GetPointCount();
	if (colors_Size > Result.rINT || Result.rINT <= 0)
		CheckStatus(InvalidParameter);
	Result.rINT = colors_Size;
	CheckStatus(GdipSetPathGradientSurroundColorsWithCount(Native, (TARGB*)colors, &Result.rINT));
	return Result.rINT;
}
inline
int __fastcall TGpPathGradientBrush::GetBlend(float *blendFactors, float *blendPositions)
{
	Result.rINT = BlendCount;
	CheckStatus(GdipGetPathGradientBlend(Native, blendFactors, blendPositions, Result.rINT));
	return Result.rINT;
}
inline
void __fastcall TGpPathGradientBrush::SetBlend(
    const float *blendFactors, const float *blendPositions, const int count)
{
	CheckStatus(GdipSetPathGradientBlend(Native, blendFactors, blendPositions, count));
}
inline
void __fastcall TGpPathGradientBrush::SetInterpolationColors(
    const TGpColor *presetColors, const float *blendPositions, const int count)
{
	CheckStatus(GdipSetPathGradientPresetBlend(Native, (TARGB*)presetColors, blendPositions, count));
}
inline
int __fastcall TGpPathGradientBrush::GetInterpolationColors(
    TGpColor *presetColors, float *blendPositions)
{
	Result.rINT = InterpolationColorCount;
	CheckStatus(GdipGetPathGradientPresetBlend(Native,
        (TARGB*)presetColors, blendPositions, Result.rINT));
	return Result.rINT;
}
inline
void __fastcall TGpPathGradientBrush::SetBlendBellShape(float focus, float scale)
{
	CheckStatus(GdipSetPathGradientSigmaBlend(Native, focus, scale));
}
inline
void __fastcall TGpPathGradientBrush::SetBlendTriangularShape(float focus, float scale)
{
	CheckStatus(GdipSetPathGradientLinearBlend(Native, focus, scale));
}
inline
void __fastcall TGpPathGradientBrush::GetTransform(TGpMatrix* matrix)
{
	CheckStatus(GdipGetPathGradientTransform(Native, matrix->Native));
}
inline
void __fastcall TGpPathGradientBrush::SetTransform(const TGpMatrix* matrix)
{
	CheckStatus(GdipSetPathGradientTransform(Native, matrix->Native));
}
inline
void __fastcall TGpPathGradientBrush::ResetTransform(void)
{
	CheckStatus(GdipResetPathGradientTransform(Native));
}
inline
void __fastcall TGpPathGradientBrush::MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order)
{
	CheckStatus(GdipMultiplyPathGradientTransform(Native,
        matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
}
inline
void __fastcall TGpPathGradientBrush::TranslateTransform(float dx, float dy, TMatrixOrder order)
{
	CheckStatus(GdipTranslatePathGradientTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
}
inline
void __fastcall TGpPathGradientBrush::ScaleTransform(float sx, float sy, TMatrixOrder order)
{
	CheckStatus(GdipScalePathGradientTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
}
inline
void __fastcall TGpPathGradientBrush::RotateTransform(float angle, TMatrixOrder order)
{
	CheckStatus(GdipRotatePathGradientTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
}
inline
void __fastcall TGpPathGradientBrush::GetGraphicsPath(TGpGraphicsPath* path)
{
	CheckStatus(GdipGetPathGradientPath(Native, path->Native));
}
inline
void __fastcall TGpPathGradientBrush::SetGraphicsPath(const TGpGraphicsPath* path)
{
	CheckStatus(GdipSetPathGradientPath(Native, path->Native));
}

#endif
