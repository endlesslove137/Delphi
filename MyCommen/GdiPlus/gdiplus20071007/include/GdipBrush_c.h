/**************************************************************************\
*
* Module Name:
*
*   GdipBrush_c.h
*
* Abstract:
*
*   GDI+ Brush function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPBRUSH_C_H
#define __GDIPBRUSH_C_H

//--------------------------------------------------------------------------
// Abstract base class for various brush types
//--------------------------------------------------------------------------

/* Gdiplus所有Brush继承于GPBRUSH，下面的函数适用于所有Gdiplus Brush */

FORCEINLINE
Status BrushDelete(PGpBrush brush)
{
	return GdipDeleteBrush(brush);
}

FORCEINLINE
PGpBrush BrushClone(const PGpBrush source)
{
    PGpBrush brush;
	return GdipCloneBrush(source, &brush) == Ok?  brush : NULL;
}

FORCEINLINE
BrushType BrushGetType(PGpBrush brush)
{
	BrushType type;
	GdipGetBrushType(brush, &type);
	return type;
}

//--------------------------------------------------------------------------
// Solid Fill Brush Object
//--------------------------------------------------------------------------

FORCEINLINE
PGpSolidBrush SolidBrushCreate(ARGB argb)
{
    PGpBrush  brush;
	return GdipCreateSolidFill(argb, &brush) == Ok? brush : NULL;
}

FORCEINLINE
ARGB SolidBrushGetColor(PGpSolidBrush brush)
{
	ARGB color;
	return GdipGetSolidFillColor(brush, &color) == Ok? color : 0;
}

FORCEINLINE
Status SolidBrushSetColor(PGpSolidBrush brush, ARGB argb)
{
	return GdipSetSolidFillColor(brush, argb);
}

#define SolidBrushClone(source)		BrushClone(source)
#define SolidbrushDelete(brush)		BrushDelete(brush)

//--------------------------------------------------------------------------
// Texture Brush Fill Object
//--------------------------------------------------------------------------

FORCEINLINE
PGpTextureBrush TextureBrushFromWrapMode(PGpImage image, WrapMode wrapMode)
{
    PGpBrush  brush;
	return GdipCreateTexture(image, wrapMode, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpTextureBrush TextureBrushFromRectF(PGpImage image,
	const PRectF dstRect, const PGpImageAttr imageAttributes)
{
	PGpBrush  brush;
	return GdipCreateTextureIA(image, imageAttributes,
				dstRect->X, dstRect->Y, dstRect->Width, dstRect->Height,
				&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpTextureBrush TextureBrushFromRect(PGpImage image,
	const PRect dstRect, const PGpImageAttr imageAttributes)
{
    PGpBrush  brush;
	return GdipCreateTextureIAI(image, imageAttributes,
				dstRect->X, dstRect->Y, dstRect->Width, dstRect->Height,
				&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpTextureBrush TextureBrushFromBoundsF(PGpImage image, WrapMode wrapMode,
	REAL dstX, REAL dstY, REAL dstWidth, REAL dstHeight)
{
    PGpBrush  brush;
	return GdipCreateTexture2(image, wrapMode, dstX, dstY, dstWidth, dstHeight,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpTextureBrush TextureBrushFromBounds(PGpImage image, WrapMode wrapMode,
	INT dstX, INT dstY, INT dstWidth, INT dstHeight)
{
    PGpBrush  brush;
	return GdipCreateTexture2I(image, wrapMode, dstX, dstY, dstWidth, dstHeight,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpTextureBrush TextureBrushCreate(PGpImage image)
{
	return TextureBrushFromWrapMode(image, WrapModeTile);
}

FORCEINLINE
Status TextureBrushSetTransform(PGpTextureBrush brush, const PGpMatrix matrix)
{
	return GdipSetTextureTransform(brush, matrix);
}

FORCEINLINE
Status TextureBrushGetTransform(PGpTextureBrush brush, PGpMatrix matrix)
{
	return GdipGetTextureTransform(brush, matrix);
}

FORCEINLINE
Status TextureBrushResetTransform(PGpTextureBrush brush)
{
	return GdipResetTextureTransform(brush);
}

FORCEINLINE
Status TextureBrushMultiply(PGpTextureBrush brush,
	const PGpMatrix matrix, MatrixOrder order)
{
	return GdipMultiplyTextureTransform(brush, matrix, order);
}

FORCEINLINE
Status TextureBrushTranslate(PGpTextureBrush brush, REAL dx, REAL dy, MatrixOrder order)
{
	return GdipTranslateTextureTransform(brush, dx, dy, order);
}

FORCEINLINE
Status TextureBrushScale(PGpTextureBrush brush, REAL sx, REAL sy, MatrixOrder order)
{
	return GdipScaleTextureTransform(brush, sx, sy, order);
}

FORCEINLINE
Status TextureBrushRotate(PGpTextureBrush brush, REAL angle, MatrixOrder order)
{
	return GdipRotateTextureTransform(brush, angle, order);
}

FORCEINLINE
Status TextureBrushSetWrapMode(PGpTextureBrush brush, WrapMode wrapMode)
{
	return GdipSetTextureWrapMode(brush, wrapMode);
}

FORCEINLINE
WrapMode TextureBrushGetWrapMode(PGpTextureBrush brush)
{
	WrapMode mode;
	GdipGetTextureWrapMode(brush, &mode);
	return mode;
}

FORCEINLINE
PGpImage TextureBrushGetImage(PGpTextureBrush brush)
{
	PGpImage image;
	return GdipGetTextureImage(brush, &image) == Ok? image : NULL;
}

#define TextureBrushClone(source)	BrushClone(source)
#define TextureBrushDelete(brush)	BrushDelete(brush)

//--------------------------------------------------------------------------
// Linear Gradient Brush Object
//--------------------------------------------------------------------------

FORCEINLINE
PGpLineBrush LineBrushFromPointF(const PPointF point1,
	const PPointF point2, ARGB color1, ARGB color2)
{
    PGpBrush  brush;
	return GdipCreateLineBrush(point1, point2, color1, color2, WrapModeTile,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushFromPoint(const PPoint point1,
	const PPoint point2, ARGB color1, ARGB color2)
{
    PGpBrush  brush;
	return GdipCreateLineBrushI(point1, point2, color1, color2, WrapModeTile,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushFromRectF(const PRectF rect,
	ARGB color1, ARGB color2, LinearGradientMode mode)
{
    PGpBrush  brush;
	return GdipCreateLineBrushFromRect(rect, color1, color2, mode, WrapModeTile,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushFromRect(const PRect rect,
	ARGB color1, ARGB color2, LinearGradientMode mode)
{
    PGpBrush  brush;
	return GdipCreateLineBrushFromRectI(rect, color1, color2, mode,
		WrapModeTile, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushFromAngleF(const PRectF rect,
	ARGB color1, ARGB color2, REAL angle, BOOL isAngleScalable)
{
    PGpBrush  brush;
	return GdipCreateLineBrushFromRectWithAngle(rect, color1, color2, angle,
		isAngleScalable, WrapModeTile, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushFromAngle(const PRect rect,
	ARGB color1, ARGB color2, REAL angle, BOOL isAngleScalable)
{
    PGpBrush  brush;
	return GdipCreateLineBrushFromRectWithAngleI(rect, color1, color2, angle,
		isAngleScalable, WrapModeTile, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpLineBrush LineBrushCreateF(const PRectF rect, REAL angle)
{
	return LineBrushFromAngleF(rect, White, Black, angle, FALSE);
}

FORCEINLINE
PGpLineBrush LineBrushCreate(const PRect rect, REAL angle)
{
	return LineBrushFromAngle(rect, White, Black, angle, FALSE);
}

FORCEINLINE
Status LineBrushSetLinearColors(PGpLineBrush brush, ARGB color1, ARGB color2)
{
	return GdipSetLineColors(brush, color1, color2);
}

FORCEINLINE
Status LineBrushGetLinearColors(PGpLineBrush brush, PARGB color1, PARGB color2)
{
	ARGB colors[2];
	Status status = GdipGetLineColors(brush, colors);
	if (status == Ok)
	{
		*color1 = colors[0];
		*color2 = colors[1];
	}
	return status;
}

FORCEINLINE
Status LineBrushGetRectangleF(PGpLineBrush brush, PRectF rect)
{
	return GdipGetLineRect(brush, rect);
}

FORCEINLINE
Status LineBrushGetRectangle(PGpLineBrush brush, PRect rect)
{
	return GdipGetLineRectI(brush, rect);
}

FORCEINLINE
Status LineBrushSetGammaCorrection(PGpLineBrush brush, BOOL useGammaCorrection)
{
	return GdipSetLineGammaCorrection(brush, useGammaCorrection);
}

FORCEINLINE
BOOL LineBrushGetGammaCorrection(PGpLineBrush brush)
{
	BOOL value;
	return GdipGetLineGammaCorrection(brush, &value) == Ok? value : FALSE;
}

FORCEINLINE
INT LineBrushGetBlendCount(PGpLineBrush brush)
{
	INT count;
	return GdipGetLineBlendCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
Status LineBrushSetBlend(PGpLineBrush brush,
	const PREAL blendFactors, const PREAL blendPositions, INT count)
{
	return GdipSetLineBlend(brush, blendFactors, blendPositions, count);
}

FORCEINLINE
Status LineBrushGetBlend(PGpLineBrush brush,
	PREAL blendFactors, PREAL blendPositions, INT count)
{
	return GdipGetLineBlend(brush, blendFactors, blendPositions, count);
}

FORCEINLINE
INT LineBrushGetInterpolationColorCount(PGpLineBrush brush)
{
	INT count;
	return GdipGetLinePresetBlendCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
Status LineBrushSetInterpolationColors(PGpLineBrush brush,
	const PARGB presetColors, const PREAL blendPositions, INT count)
{
	return GdipSetLinePresetBlend(brush, presetColors, blendPositions, count);
}

FORCEINLINE
Status LineBrushGetInterpolationColors(PGpLineBrush brush,
	PARGB presetColors, PREAL blendPositions, INT count)
{
	return GdipGetLinePresetBlend(brush, presetColors, blendPositions, count);
}

FORCEINLINE
Status LineBrushSetBlendBellShape(PGpLineBrush brush, REAL focus, REAL scale)
{
	return GdipSetLineSigmaBlend(brush, focus, scale);
}

FORCEINLINE
Status LineBrushSetBlendTriangularShape(PGpLineBrush brush, REAL focus, REAL scale)
{
	return GdipSetLineLinearBlend(brush, focus, scale);
}

FORCEINLINE
Status LineBrushSetTransform(PGpLineBrush brush, const PGpMatrix matrix)
{
	return GdipSetLineTransform(brush, matrix);
}

FORCEINLINE
Status LineBrushGetTransform(PGpLineBrush brush, PGpMatrix matrix)
{
	return GdipGetLineTransform(brush, matrix);
}

FORCEINLINE
Status LineBrushResetTransform(PGpLineBrush brush)
{
	return GdipResetLineTransform(brush);
}

FORCEINLINE
Status LineBrushMultiply(PGpLineBrush brush,
	const PGpMatrix matrix, MatrixOrder order)
{
	return GdipMultiplyLineTransform(brush, matrix, order);
}

FORCEINLINE
Status LineBrushTranslate(PGpLineBrush brush, REAL dx, REAL dy, MatrixOrder order)
{
	return GdipTranslateLineTransform(brush, dx, dy, order);
}

FORCEINLINE
Status LineBrushScale(PGpLineBrush brush, REAL sx, REAL sy, MatrixOrder order)
{
	return GdipScaleLineTransform(brush, sx, sy, order);
}

FORCEINLINE
Status LineBrushRotate(PGpLineBrush brush, REAL angle, MatrixOrder order)
{
	return GdipRotateLineTransform(brush, angle, order);
}

FORCEINLINE
Status LineBrushSetWrapMode(PGpLineBrush brush, WrapMode wrapMode)
{
	return GdipSetLineWrapMode(brush, wrapMode);
}

FORCEINLINE
WrapMode LineBrushGetWrapMode(PGpLineBrush brush)
{
	WrapMode mode;
	GdipGetLineWrapMode(brush, &mode);
	return mode;
}

#define LineBrushClone(source)	BrushClone(source)
#define LineBrushDelete(brush)	BrushDelete(brush)

//--------------------------------------------------------------------------
// PathGradientBrush object is defined
// in gdipluspath.h.
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Hatch Brush Object
//--------------------------------------------------------------------------

FORCEINLINE
PGpHatchBrush HatchBrushCreate(HatchStyle hatchStyle, ARGB foreColor, ARGB backColor)
{
    PGpBrush  brush;
	return GdipCreateHatchBrush(hatchStyle, foreColor, backColor,
		&brush) == Ok? brush : NULL;
}

FORCEINLINE
HatchStyle HatchBrushGetHatchStyle(PGpHatchBrush brush)
{
	HatchStyle style;
	GdipGetHatchStyle(brush, &style);
	return style;
}

FORCEINLINE
ARGB HatchBrushGetForegroundColor(PGpHatchBrush brush)
{
	ARGB color;
	return GdipGetHatchForegroundColor(brush, &color) == Ok? color : 0;
}

FORCEINLINE
ARGB HatchBrushGetBackgroundColor(PGpHatchBrush brush)
{
	ARGB color;
	return GdipGetHatchBackgroundColor(brush, &color) == Ok? color : 0;
}

#define HatchBrushClone(source)		BrushClone(source)
#define HatchBrushDelete(brush)		BrushDelete(brush)

//--------------------------------------------------------------------------
// Path Gradient Brush
//--------------------------------------------------------------------------

/* default WrapMode = WrapModeClamp */
FORCEINLINE
PGpPathBrush PathBrushFromPointF(const PPointF points, INT count, WrapMode wrapMode)
{
    PGpBrush  brush;
	return GdipCreatePathGradient(points, count, wrapMode, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpPathBrush PathBrushFromPoint(const PPoint points, INT count, WrapMode wrapMode)
{
    PGpBrush  brush;
	return GdipCreatePathGradientI(points, count, wrapMode, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpPathBrush PathBrushFromPath(PGpPath path)
{
	PGpBrush  brush;
	return GdipCreatePathGradientFromPath(path, &brush) == Ok? brush : NULL;
}

FORCEINLINE
PGpPathBrush PathBrushCreate(PGpPath path)
{
	return PathBrushFromPath(path);
}

FORCEINLINE
ARGB PathBrushGetCenterColor(PGpPathBrush brush)
{
	ARGB color;
	return GdipGetPathGradientCenterColor(brush, &color) == Ok? color : 0;
}

FORCEINLINE
Status PathBrushSetCenterColor(PGpPathBrush brush, ARGB color)
{
	return GdipSetPathGradientCenterColor(brush, color);
}

FORCEINLINE
INT PathBrushGetPointCount(PGpPathBrush brush)
{
	INT count;
	return GdipGetPathGradientPointCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
INT PathBrushGetSurroundColorCount(PGpPathBrush brush)
{
	INT count;
	return GdipGetPathGradientSurroundColorCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
Status PathBrushGetSurroundColors(PGpPathBrush brush, PARGB colors, INT* count)
{
	INT _count;
	GdipGetPathGradientSurroundColorCount(brush, &_count);
	if ((*count < _count) || (_count <= 0))
		return InsufficientBuffer;
	return GdipGetPathGradientSurroundColorsWithCount(brush, colors, count);
}

FORCEINLINE
Status PathBrushSetSurroundColors(PGpPathBrush brush,
	const PARGB colors, INT count)
{
	INT _count;
	_count = PathBrushGetPointCount(brush);
	if(colors == NULL || _count <= 0 || count > _count)
		return InvalidParameter;
	return GdipSetPathGradientSurroundColorsWithCount(brush, colors, &count);
}

FORCEINLINE
Status PathBrushGetGraphicsPath(PGpPathBrush brush, PGpPath path)
{
	return GdipGetPathGradientPath(brush, path);
}

FORCEINLINE
Status PathBrushSetGraphicsPath(PGpPathBrush brush, const PGpPath path)
{
	return GdipSetPathGradientPath(brush, path);
}

FORCEINLINE
Status PathBrushGetCenterPointF(PGpPathBrush brush, PPointF point)
{
	return GdipGetPathGradientCenterPoint(brush, point);
}

FORCEINLINE
Status PathBrushGetCenterPoint(PGpPathBrush brush, PPoint point)
{
	return GdipGetPathGradientCenterPointI(brush, point);
}


FORCEINLINE
Status PathBrushSetCenterPointF(PGpPathBrush brush, const PPointF point)
{
	return GdipSetPathGradientCenterPoint(brush, point);
}

FORCEINLINE
Status PathBrushSetCenterPoint(PGpPathBrush brush, const PPoint point)
{
	return GdipSetPathGradientCenterPointI(brush, point);
}

FORCEINLINE
Status PathBrushGetRectangleF(PGpPathBrush brush, PRectF rect)
{
	return GdipGetPathGradientRect(brush, rect);
}

FORCEINLINE
Status PathBrushGetRectangle(PGpPathBrush brush, PRect rect)
{
	return GdipGetPathGradientRectI(brush, rect);
}

FORCEINLINE
Status PathBrushSetGammaCorrection(PGpPathBrush brush, BOOL useGammaCorrection)
{
	return GdipSetPathGradientGammaCorrection(brush, useGammaCorrection);
}

FORCEINLINE
BOOL PathBrushGetGammaCorrection(PGpPathBrush brush)
{
	BOOL useGammaCorrection;
	GdipGetPathGradientGammaCorrection(brush, &useGammaCorrection);
	return useGammaCorrection;
}

FORCEINLINE
INT PathBrushGetBlendCount(PGpPathBrush brush)
{
	INT count;
	return GdipGetPathGradientBlendCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
Status PathBrushGetBlend(PGpPathBrush brush,
	PREAL blendFactors, PREAL blendPositions, INT count)
{
	return GdipGetPathGradientBlend(brush, blendFactors, blendPositions, count);
}

FORCEINLINE
Status PathBrushSetBlend(PGpPathBrush brush,
	const PREAL blendFactors, const PREAL blendPositions, INT count)
{
	return GdipSetPathGradientBlend(brush, blendFactors, blendPositions, count);
}

FORCEINLINE
INT PathBrushGetInterpolationColorCount(PGpPathBrush brush)
{
	INT count;
	return GdipGetPathGradientPresetBlendCount(brush, &count) == Ok? count : 0;
}

FORCEINLINE
Status PathBrushSetInterpolationColors(PGpPathBrush brush,
	const PARGB presetColors, const PREAL blendPositions, INT count)
{
	return GdipSetPathGradientPresetBlend(brush, presetColors, blendPositions, count);
}

FORCEINLINE
Status PathBrushGetInterpolationColors(PGpPathBrush brush,
	PARGB presetColors, PREAL blendPositions, INT count)
{
	return GdipGetPathGradientPresetBlend(brush, presetColors, blendPositions, count);
}

FORCEINLINE
Status PathBrushSetBlendBellShape(PGpPathBrush brush, REAL focus, REAL scale)
{
	return GdipSetPathGradientSigmaBlend(brush, focus, scale);
}

FORCEINLINE
Status PathBrushSetBlendTriangularShape(PGpPathBrush brush, REAL focus, REAL scale)
{
	return GdipSetPathGradientLinearBlend(brush, focus, scale);
}

FORCEINLINE
Status PathBrushGetTransform(PGpPathBrush brush, PGpMatrix matrix)
{
	return GdipGetPathGradientTransform(brush, matrix);
}

FORCEINLINE
Status PathBrushSetTransform(PGpPathBrush brush, const PGpMatrix matrix)
{
	return GdipSetPathGradientTransform(brush, matrix);
}

FORCEINLINE
Status PathBrushResetTransform(PGpPathBrush brush)
{
	return GdipResetPathGradientTransform(brush);
}

FORCEINLINE
Status PathBrushMultiply(PGpPathBrush brush,
	const PGpMatrix matrix, MatrixOrder order)
{
	return GdipMultiplyPathGradientTransform(brush, matrix, order);
}

FORCEINLINE
Status PathBrushTranslate(PGpPathBrush brush, REAL dx, REAL dy, MatrixOrder order)
{
	return GdipTranslatePathGradientTransform(brush, dx, dy, order);
}

FORCEINLINE
Status PathBrushScale(PGpPathBrush brush, REAL sx, REAL sy, MatrixOrder order)
{
	return GdipScalePathGradientTransform(brush, sx, sy, order);
}

FORCEINLINE
Status PathBrushRotate(PGpPathBrush brush, REAL angle, MatrixOrder order)
{
	return GdipRotatePathGradientTransform(brush, angle, order);
}

FORCEINLINE
Status PathBrushGetFocusScales(PGpPathBrush brush, PREAL xScale, PREAL yScale)
{
	return GdipGetPathGradientFocusScales(brush, xScale, yScale);
}

FORCEINLINE
Status PathBrushSetFocusScales(PGpPathBrush brush, REAL xScale, REAL yScale)
{
	return GdipSetPathGradientFocusScales(brush, xScale, yScale);
}

FORCEINLINE
WrapMode PathBrushGetWrapMode(PGpPathBrush brush)
{
	WrapMode mode;
	GdipGetPathGradientWrapMode(brush, &mode);
	return mode;
}

FORCEINLINE
Status PathBrushSetWrapMode(PGpPathBrush brush, WrapMode wrapMode)
{
	return GdipSetPathGradientWrapMode(brush, wrapMode);
}

#define PathBrushClone(source)	BrushClone(source)
#define PathBrushDelete(brush)	BrushDelete(brush)

#endif

