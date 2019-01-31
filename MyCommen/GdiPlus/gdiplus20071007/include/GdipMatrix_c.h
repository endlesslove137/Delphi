/**************************************************************************\
*
* Module Name:
*
*   GdipMatrix_c.h
*
* Abstract:
*
*   GDI+ Matrix function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPMATRIX_C_H
#define __GDIPMATRIX_C_H

typedef  union
{
	REAL Elements[6];
	struct
	{
		REAL m11;
		REAL m12;
		REAL m21;
		REAL m22;
		REAL dx;
		REAL dy;
    };
}MatrixElements, *PMatrixElements;

FORCEINLINE
PGpMatrix MatrixCreate(void)
{
    PGpMatrix matrix;
	return GdipCreateMatrix(&matrix) == Ok? matrix : NULL;
}

FORCEINLINE
PGpMatrix MatrixFromElements(REAL m11, REAL m12, REAL m21,
								REAL m22, REAL dx, REAL dy)
{
    PGpMatrix matrix;
	return GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, &matrix) == Ok?
		   matrix : NULL;
}

FORCEINLINE
PGpMatrix MatrixFromRectF(const PRectF rect, const PPointF dstplg)
{
    PGpMatrix matrix;
	return GdipCreateMatrix3(rect, dstplg, &matrix) == Ok? matrix : NULL;
}

FORCEINLINE
PGpMatrix MatrixFromRect(const PRect rect, const PPoint dstplg)
{
    PGpMatrix matrix;
	return GdipCreateMatrix3I(rect, dstplg, &matrix) == Ok? matrix : NULL;
}

FORCEINLINE
PGpMatrix MatrixClone(const PGpMatrix source)
{
    PGpMatrix matrix;
	return GdipCloneMatrix(source, &matrix) == Ok? matrix : NULL;
}

FORCEINLINE
Status MatrixDelete(PGpMatrix matrix)
{
	return GdipDeleteMatrix(matrix);
}

FORCEINLINE
Status MatrixGetElements(PGpMatrix matrix, PMatrixElements elements)
{
	return GdipGetMatrixElements(matrix, (REAL*)elements);
}

FORCEINLINE
Status MatrixSetElements(PGpMatrix matrix,
	REAL m11, REAL m12, REAL m21, REAL m22, REAL dx, REAL dy)
{
	return GdipSetMatrixElements(matrix, m11, m12, m21, m22, dx, dy);
}

FORCEINLINE
REAL MatrixGetOffsetX(PGpMatrix matrix)
{
	MatrixElements elements;
	return GdipGetMatrixElements(matrix, (REAL*)&elements) == Ok? elements.dx : 0.0f;
}

FORCEINLINE
REAL MatrixGetOffsetY(PGpMatrix matrix)
{
	MatrixElements elements;
	return GdipGetMatrixElements(matrix, (REAL*)&elements) == Ok? elements.dy : 0.0f;
}

FORCEINLINE
Status MatrixReset(PGpMatrix matrix)
{
	return GdipSetMatrixElements(matrix, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
}

//  default MatrixOrder with MatrixOrderPrepend;

FORCEINLINE
Status MatrixMultiply(PGpMatrix matrix, PGpMatrix matrix2, MatrixOrder order)
{
	return GdipMultiplyMatrix(matrix, matrix2, order);
}

FORCEINLINE
Status MatrixTranslate(PGpMatrix matrix, REAL offsetX, REAL offsetY, MatrixOrder order)
{
	return GdipTranslateMatrix(matrix, offsetX, offsetY, order);
}

FORCEINLINE
Status MatrixScale(PGpMatrix matrix, REAL scaleX, REAL scaleY, MatrixOrder order)
{
	return GdipScaleMatrix(matrix, scaleX, scaleY, order);
}

FORCEINLINE
Status MatrixRotate(PGpMatrix matrix, REAL angle, MatrixOrder order)
{
	return GdipRotateMatrix(matrix, angle, order);
}

FORCEINLINE
Status MatrixRotateAt(PGpMatrix matrix, REAL angle,
	REAL centerX, REAL centerY, MatrixOrder order)
{
	if (order == MatrixOrderPrepend)
	{
		GdipTranslateMatrix(matrix, centerX, centerY, order);
		GdipRotateMatrix(matrix, angle, order);
		return GdipTranslateMatrix(matrix, -centerX, -centerY, order);
	}
	else
	{
		GdipTranslateMatrix(matrix, -centerX, -centerY, order);
		GdipRotateMatrix(matrix, angle, order);
		return GdipTranslateMatrix(matrix, centerX, centerY, order);
	}
}

FORCEINLINE
Status MatrixShear(PGpMatrix matrix, REAL shearX, REAL shearY, MatrixOrder order)
{
	return GdipShearMatrix(matrix, shearX, shearY, order);
}

FORCEINLINE
Status MatrixInvert(PGpMatrix matrix)
{
	return GdipInvertMatrix(matrix);
}

FORCEINLINE
Status MatrixTransformPointsF(PGpMatrix matrix, PPointF pts, INT count)
{
	return GdipTransformMatrixPoints(matrix, pts, count);
}

FORCEINLINE
Status MatrixTransformPoints(PGpMatrix matrix, PPoint pts, INT count)
{
	return GdipTransformMatrixPointsI(matrix, pts, count);
}

FORCEINLINE
Status MatrixTransformVectorsF(PGpMatrix matrix, PPointF pts, INT count)
{
	return GdipVectorTransformMatrixPoints(matrix, pts, count);
}

FORCEINLINE
Status MatrixTransformVectors(PGpMatrix matrix, PPoint pts, INT count)
{
	return GdipVectorTransformMatrixPointsI(matrix, pts, count);
}

FORCEINLINE
BOOL MatrixIsInvertible(PGpMatrix matrix)
{
	BOOL value;
	return GdipIsMatrixInvertible(matrix, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL MatrixIsIdentity(PGpMatrix matrix)
{
	BOOL value;
	return GdipIsMatrixIdentity(matrix, &value) == Ok? value : FALSE;
}

FORCEINLINE
BOOL MatrixEquals(PGpMatrix matrix, PGpMatrix matrix2)
{
	BOOL value;
	return GdipIsMatrixEqual(matrix, matrix2, &value) == Ok? value : FALSE;
}

#endif

