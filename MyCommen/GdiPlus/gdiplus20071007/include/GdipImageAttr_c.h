/**************************************************************************\
*
* Module Name:
*
*   GdipImageAttr_c.h
*
* Abstract:
*
*   GDI+ Image Attributes used with Graphics.DrawImage
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\***************************************************************************/

#ifndef __GDIPIMAGEATTR_C_H
#define __GDIPIMAGEATTR_C_H

FORCEINLINE
PGpImageAttr ImageAttrCreate(void)
{
	PGpImageAttr imageAttr;
	return GdipCreateImageAttributes(&imageAttr) == Ok? imageAttr : NULL;
}

FORCEINLINE
PGpImageAttr ImageAttrClone(const PGpImageAttr source)
{
	PGpImageAttr imageAttr;
	return GdipCloneImageAttributes(source, &imageAttr) == Ok? imageAttr : NULL;
}

FORCEINLINE
Status ImageAttrDelete(PGpImageAttr imageAttr)
{
	return GdipDisposeImageAttributes(imageAttr);
}

FORCEINLINE
Status ImageAttrSetToIdentity(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesToIdentity(imageAttr, type);
}

FORCEINLINE
Status ImageAttrReset(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipResetImageAttributes(imageAttr, type);
}

FORCEINLINE
Status ImageAttrSetColorMatrix(PGpImageAttr imageAttr,
	const PColorMatrix colorMatrix, ColorMatrixFlags mode, ColorAdjustType type)
{
	return GdipSetImageAttributesColorMatrix(imageAttr, type, TRUE,
											 colorMatrix, NULL, mode);
}

FORCEINLINE
Status ImageAttrClearColorMatrix(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesColorMatrix(imageAttr, type, FALSE, NULL,
											 NULL, ColorMatrixFlagsDefault);
}

FORCEINLINE
Status ImageAttrSetColorMatrices(PGpImageAttr imageAttr,
	const PColorMatrix colorMatrix, const PColorMatrix grayMatrix,
	ColorMatrixFlags mode, ColorAdjustType type)
{
	return GdipSetImageAttributesColorMatrix(imageAttr, type, TRUE,
											 colorMatrix, grayMatrix, mode);
}

FORCEINLINE
Status ImageAttrClearColorMatrices(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesColorMatrix(imageAttr, type, FALSE, NULL,
											 NULL, ColorMatrixFlagsDefault);
}

FORCEINLINE
Status ImageAttrSetThreshold(PGpImageAttr imageAttr,
	REAL threshold, ColorAdjustType type)
{
	return GdipSetImageAttributesThreshold(imageAttr, type, TRUE, threshold);
}

FORCEINLINE
Status ImageAttrClearThreshold(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesThreshold(imageAttr, type, FALSE, 0.0);
}

FORCEINLINE
Status ImageAttrSetGamma(PGpImageAttr imageAttr,
	REAL gamma, ColorAdjustType type)
{
	return GdipSetImageAttributesGamma(imageAttr, type, TRUE, gamma);
}

FORCEINLINE
Status ImageAttrClearGamma(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesGamma(imageAttr, type, FALSE, 0.0);
}

FORCEINLINE
Status ImageAttrSetNoOp(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesNoOp(imageAttr, type, TRUE);
}

FORCEINLINE
Status ImageAttrClearNoOp(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesNoOp(imageAttr, type, FALSE);
}

FORCEINLINE
Status ImageAttrSetColorKey(PGpImageAttr imageAttr,
	ARGB colorLow, ARGB colorHigh, ColorAdjustType type)
{
	return GdipSetImageAttributesColorKeys(imageAttr, type, TRUE, colorLow, colorHigh);
}

FORCEINLINE
Status ImageAttrClearColorKey(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesColorKeys(imageAttr, type, FALSE, 0, 0);
}

FORCEINLINE
Status ImageAttrSetOutputChannel(PGpImageAttr imageAttr,
	ColorChannelFlags channelFlags, ColorAdjustType type)
{
	return GdipSetImageAttributesOutputChannel(imageAttr, type, TRUE, channelFlags);
}

FORCEINLINE
Status ImageAttrClearOutputChannel(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesOutputChannel(imageAttr, type, FALSE, ColorChannelFlagsLast);
}

FORCEINLINE
Status ImageAttrSetOutputChannelColorProfile(PGpImageAttr imageAttr,
	const WCHAR *colorProfileFilename, ColorAdjustType type)
{
	return GdipSetImageAttributesOutputChannelColorProfile(imageAttr,
					type, TRUE, colorProfileFilename);
}

FORCEINLINE
Status ImageAttrClearOutputChannelColorProfile(
	PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesOutputChannelColorProfile(imageAttr, type, FALSE, NULL);
}

FORCEINLINE
Status ImageAttrSetRemapTable(PGpImageAttr imageAttr,
	UINT mapSize, const PColorMap map, ColorAdjustType type)
{
	return GdipSetImageAttributesRemapTable(imageAttr, type, TRUE, mapSize, map);
}

FORCEINLINE
Status ImageAttrClearRemapTable(PGpImageAttr imageAttr, ColorAdjustType type)
{
	return GdipSetImageAttributesRemapTable(imageAttr, type, FALSE, 0, NULL);
}

FORCEINLINE
Status ImageAttrSetBrushRemapTable(PGpImageAttr imageAttr,
	UINT mapSize, const PColorMap map)
{
	return ImageAttrSetRemapTable(imageAttr, mapSize, map, ColorAdjustTypeBrush);
}

FORCEINLINE
Status ImageAttrClearBrushRemapTable(PGpImageAttr imageAttr)
{
	return ImageAttrClearRemapTable(imageAttr, ColorAdjustTypeBrush);
}

FORCEINLINE
Status ImageAttrSetWrapMode(PGpImageAttr imageAttr,
	WrapMode wrap, ARGB argb, BOOL clamp)
{
	return GdipSetImageAttributesWrapMode(imageAttr, wrap, argb, clamp);
}

FORCEINLINE
Status ImageAttrGetAdjustedPalette(PGpImageAttr imageAttr,
	PColorPalette colorPalette, ColorAdjustType Type)
{
	return GdipGetImageAttributesAdjustedPalette(imageAttr, colorPalette, Type);
}

#endif

