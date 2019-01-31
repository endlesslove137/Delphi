/**************************************************************************\
*
* Module Name:
*
*   GdipMatrix.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipMatrixHPP
#define GdipMatrixHPP

//--------------------------------------------------------------------------
// 封装表示几何变形的 3 x 2 仿射矩阵。
// 备注: 3 x 2 矩阵在第一列包含 x 值，在第二列包含 y 值，在第三列包含 w 值。
//--------------------------------------------------------------------------

enum TMatrixOrder
{
	moPrepend,		// 在旧操作前应用新操作。
	moAppend		// 在旧操作后应用新操作。
};

#pragma pack(push,1)
union TMatrixElements
{
    float Elements[6];
    struct
    {
    	float m11;
	    float m12;
    	float m21;
	    float m22;
    	float dx;
	    float dy;
    };
} ;
#pragma pack(pop)

typedef TMatrixElements *PMatrixElements;

class TGpMatrix : public TGdiplusBase
{
private:
	friend	class TGpRegion;
    friend  class TGpPen;
    friend  class TGpTextureBrush;
	friend  class TGpLinearGradientBrush;
	friend	class TGpPathGradientBrush;
    friend  class TGpGraphicsPath;
	friend	class TGpGraphics;
	
	TMatrixElements __fastcall GetElements()
    {
	    TMatrixElements e;
	    CheckStatus(GdipGetMatrixElements(Native, e.Elements));
	    return e;
    }
	void __fastcall SetElements(const TMatrixElements &Value)
    {
    	CheckStatus(GdipSetMatrixElements(Native, Value.m11, Value.m12, Value.m21,
									Value.m22, Value.dx, Value.dy));
    }
	float __fastcall GetOffsetX(void)
	{
		return Elements.dx;
    }
	float __fastcall GetOffsetY(void)
	{
		return Elements.dy;
    }

protected:
	__fastcall TGpMatrix(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpMatrix));
	}
#endif
public:
	// 将 Matrix 类的一个新实例初始化为单位矩阵。. Elements = 1,0,0,1,0,0
	__fastcall TGpMatrix(void)
	{
		CheckStatus(GdipCreateMatrix(&Native));
	}
	// 使用指定的元素初始化 Matrix 类的新实例。
	__fastcall TGpMatrix(float m11, float m12, float m21, float m22, float dx, float dy)
	{
		CheckStatus(GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, &Native));
	}
	// 将 Matrix 类的一个新实例初始化为指定矩形和点数组定义的几何变形。dstplg 由三个 Point 结构构成的数组
	__fastcall TGpMatrix(const TGpRectF &rect, PGpPointF dstplg)
	{
		CheckStatus(GdipCreateMatrix3(&rect, dstplg, &Native));
	}
	__fastcall TGpMatrix(const TGpRect &rect, PGpPoint dstplg)
	{
		CheckStatus(GdipCreateMatrix3I(&rect, dstplg, &Native));
	}
	__fastcall virtual ~TGpMatrix(void)
	{
		GdipDeleteMatrix(Native);
    }
	TGpMatrix* __fastcall Clone(void)
	{
		return new TGpMatrix(Native, (TCloneAPI)GdipCloneMatrix);
	}
	// 重置此 Matrix 对象以具有单位矩阵的元素。
	void __fastcall Reset(void)
	{
		CheckStatus(GdipSetMatrixElements(Native, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
	}
	// 按指定的顺序将此 Matrix 对象与在 matrix 参数中指定的矩阵相乘。
	void __fastcall Multiply(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipMultiplyMatrix(Native, matrix->Native, (MatrixOrder)(int)order));
	}
	// 通过预先计算转换向量将指定的转换向量应用到此 Matrix 对象。
	void __fastcall Translate(float offsetX, float offsetY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipTranslateMatrix(Native, offsetX, offsetY, (MatrixOrder)(int)order));
	}
	// 使用指定的顺序将指定的缩放向量（scaleX 和 scaleY）应用到此 Matrix 对象。
	void __fastcall Scale(float scaleX, float scaleY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipScaleMatrix(Native, scaleX, scaleY, (MatrixOrder)(int)order));
	}
	// 应用 angle 参数中指定的顺时针旋转量，为此 Matrix 对象沿原点（X,Y 坐标）旋转。
	void __fastcall Rotate(float angle, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
	}
	// 通过预先计算旋转，将沿指定点的顺时针旋转应用到该 Matrix 对象。
	void __fastcall RotateAt(float angle, const TGpPointF &center, TMatrixOrder order = moPrepend)
    {
    	if (order == moPrepend)
    	{
    		CheckStatus(GdipTranslateMatrix(Native, center.X, center.Y, (MatrixOrder)(int)order));
    		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
    		CheckStatus(GdipTranslateMatrix(Native, -center.X, -center.Y, (MatrixOrder)(int)order));
    	}
    	else
    	{
    		CheckStatus(GdipTranslateMatrix(Native, -center.X, - center.Y, (MatrixOrder)(int)order));
    		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
    		CheckStatus(GdipTranslateMatrix(Native, center.X, center.Y, (MatrixOrder)(int)order));
       }
	}
	// 按指定的顺序将指定的切变向量应用到此 Matrix 对象。
	void __fastcall Shear(float shearX, float shearY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipShearMatrix(Native, shearX, shearY, (MatrixOrder)(int)order));
	}
	// 如果此 Matrix 对象是可逆转的，则逆转该对象。
	void __fastcall Invert(void)
	{
		CheckStatus(GdipInvertMatrix(Native));
	}
	// 对指定的点数组应用此 Matrix 对象所表示的几何变形。
	void __fastcall TransformPoints(TGpPointF *pts, const int pts_Size)
	{
		CheckStatus(GdipTransformMatrixPoints(Native, pts, pts_Size));
    }
	void __fastcall TransformPoints(TGpPoint *pts, const int pts_Size)
	{
		CheckStatus(GdipTransformMatrixPointsI(Native, pts, pts_Size));
	}
	// 只将该 Matrix 对象的伸缩和旋转成分应用到指定的点数组。
	void __fastcall TransformVectors(TGpPointF *pts, const int pts_Size)
	{
		CheckStatus(GdipVectorTransformMatrixPoints(Native, pts, pts_Size));
    }
	void __fastcall TransformVectors(TGpPoint *pts, const int pts_Size)
	{
		CheckStatus(GdipVectorTransformMatrixPointsI(Native, pts, pts_Size));
	}
	// 获取一个值，该值指示此 Matrix 对象是否是可逆转的。
	bool __fastcall IsInvertible(void)
	{
		CheckStatus(GdipIsMatrixInvertible(Native, &Result.rBOOL));
		return Result.rBOOL;
	}
	// 获取一个值，该值指示此 Matrix 对象是否是单位矩阵。
	bool __fastcall IsIdentity(void)
	{
		CheckStatus(GdipIsMatrixIdentity(Native, &Result.rBOOL));
		return Result.rBOOL;
	}
#if (__BORLANDC__ >= 0x610)
    HIDESBASE bool __fastcall Equals(const TGpMatrix* matrix)
#else
	bool __fastcall Equals(const TGpMatrix* matrix)
#endif
	{
		CheckStatus(GdipIsMatrixEqual(Native, matrix->Native, &Result.rBOOL));
		return Result.rBOOL;
	}
	// 获取或设置该 Matrix 对象的元素。
	__property TMatrixElements Elements = {read=GetElements, write=SetElements};
	// 获取此 Matrix 对象的 x 转换值（dx 值，或第三行、第一列中的元素）。
	__property float OffsetX = {read=GetOffsetX};
	// 获取此 Matrix 的 y 转换值（dy 值，或第三行、第二列中的元素）。
	__property float OffsetY = {read=GetOffsetY};

};

#endif
