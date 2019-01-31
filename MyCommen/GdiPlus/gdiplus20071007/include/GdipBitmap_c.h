/**************************************************************************\
*
* Module Name:
*
*   GdipBitmap_c.h
*
* Abstract:
*
*   GDI+ Bitmap function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPBITMAP_C_H
#define __GDIPBITMAP_C_H

FORCEINLINE
PGpImage ImageFromFile(const WCHAR* filename, BOOL useEmbeddedColorManagement)
{
	PGpImage image;// = NULL;
	if(useEmbeddedColorManagement)
		GdipLoadImageFromFileICM(filename, &image);
	else
		GdipLoadImageFromFile(filename, &image);
	return image;
}

FORCEINLINE
PGpImage ImageCreate(const WCHAR* filename)
{
	return ImageFromFile(filename, FALSE);
}

FORCEINLINE
PGpImage ImageFromStream(IStream* stream, BOOL useEmbeddedColorManagement)
{
	PGpImage image;// = NULL;
    if(useEmbeddedColorManagement)
		GdipLoadImageFromStreamICM(stream, &image);
	else
		GdipLoadImageFromStream(stream, &image);
	return image;
}

FORCEINLINE
Status ImageDelete(PGpImage image)
{
	return GdipDisposeImage(image);
}

FORCEINLINE
PGpImage ImageClone(const PGpImage source)
{
    PGpImage image;
	return GdipCloneImage(source, &image) == Ok? image : NULL;
}

FORCEINLINE
UINT ImageGetEncoderParameterListSize(PGpImage image, const CLSID* clsidEncoder)
{
	UINT size;
	return GdipGetEncoderParameterListSize(image, clsidEncoder, &size) == Ok? size : 0;
}

FORCEINLINE
Status ImageGetEncoderParameterList(PGpImage image,
	const CLSID* clsidEncoder, UINT size, EncoderParameters* buffer)
{
	return GdipGetEncoderParameterList(image, clsidEncoder, size, buffer);
}

FORCEINLINE
Status ImageSaveToFile(PGpImage image, const WCHAR* filename,
	const CLSID* clsidEncoder, const EncoderParameters *encoderParams)
{
	return GdipSaveImageToFile(image, filename, clsidEncoder, encoderParams);
}

FORCEINLINE
Status ImageSaveToStream(PGpImage image, IStream* stream,
	const CLSID* clsidEncoder, const EncoderParameters *encoderParams)
{
	return GdipSaveImageToStream(image, stream, clsidEncoder, encoderParams);
}

FORCEINLINE
Status ImageSaveAdd(PGpImage image, const EncoderParameters *encoderParams)
{
	return GdipSaveAdd(image, encoderParams);
}

FORCEINLINE
Status ImageSaveAddImage(PGpImage image,
	PGpImage newImage, const EncoderParameters *encoderParams)
{
	return GdipSaveAddImage(image, newImage, encoderParams);
}

FORCEINLINE
ImageType ImageGetType(PGpImage image)
{
	ImageType type;
	return GdipGetImageType(image, &type) == Ok? type  : ImageTypeUnknown;
}

FORCEINLINE
Status ImageGetPhysicalDimension(PGpImage image, PREAL width, PREAL height)
{
	return GdipGetImageDimension(image, width, height);
}

FORCEINLINE
Status ImageGetBounds(PGpImage image, PRectF srcRect, Unit *srcUnit)
{
	return GdipGetImageBounds(image, srcRect, srcUnit);
}

FORCEINLINE
UINT ImageGetWidth(PGpImage image)
{
	UINT width;
	return GdipGetImageWidth(image, &width) == Ok? width : 0;
}

FORCEINLINE
UINT ImageGetHeight(PGpImage image)
{
	UINT height;
	return GdipGetImageHeight(image, &height) == Ok? height : 0;
}

FORCEINLINE
REAL ImageGetHorizontalResolution(PGpImage image)
{
	REAL value;
	return GdipGetImageHorizontalResolution(image, &value) == Ok? value : 0.0f;
}

FORCEINLINE
REAL ImageGetVerticalResolution(PGpImage image)
{
	REAL value;
	return GdipGetImageVerticalResolution(image, &value) == Ok? value : 0.0f;
}

FORCEINLINE
UINT ImageGetFlags(PGpImage image)
{
	UINT flags;
	return GdipGetImageFlags(image, &flags) == Ok? flags : 0;
}

FORCEINLINE
Status ImageGetRawFormat(PGpImage image, GUID *format)
{
	return GdipGetImageRawFormat(image, format);
}

FORCEINLINE
PixelFormat ImageGetPixelFormat(PGpImage image)
{
	PixelFormat format;
	GdipGetImagePixelFormat(image, &format);
	return format;
}

FORCEINLINE
INT ImageGetPaletteSize(PGpImage image)
{
	INT size;
	return GdipGetImagePaletteSize(image, &size) == Ok? size : 0;
}

FORCEINLINE
Status ImageGetPalette(PGpImage image, ColorPalette *palette, INT size)
{
    return GdipGetImagePalette(image, palette, size);
}

FORCEINLINE
Status ImageSetPalette(PGpImage image, const ColorPalette *palette)
{
    return GdipSetImagePalette(image, palette);
}

FORCEINLINE
PGpImage ImageGetThumbnailImage(PGpImage image, UINT thumbWidth,
	UINT thumbHeight, GetThumbnailImageAbort callback, VOID* callbackData)
{
    PGpImage thum;
	return GdipGetImageThumbnail(image, thumbWidth, thumbHeight,
		&thum, callback, callbackData) == Ok? thum : NULL;
}

FORCEINLINE
UINT ImageGetFrameDimensionsCount(PGpImage image)
{
	UINT count;
	return GdipImageGetFrameDimensionsCount(image, &count) == Ok? count : 0;
}

FORCEINLINE
Status ImageGetFrameDimensionsList(PGpImage image, GUID* dimensionIDs, UINT count)
{
	return GdipImageGetFrameDimensionsList(image, dimensionIDs, count);
}

FORCEINLINE
UINT ImageGetFrameCount(PGpImage image, const GUID* dimensionID)
{
	UINT count;
	return GdipImageGetFrameCount(image, dimensionID, &count) == Ok? count : 0;
}

FORCEINLINE
Status ImageSelectActiveFrame(PGpImage image,
	const GUID *dimensionID, UINT frameIndex)
{
	return GdipImageSelectActiveFrame(image, dimensionID, frameIndex);
}

FORCEINLINE
Status ImageRotateFlip(PGpImage image, RotateFlipType rotateFlipType)
{
	return GdipImageRotateFlip(image, rotateFlipType);
}

FORCEINLINE
UINT ImageGetPropertyCount(PGpImage image)
{
	UINT count;
	return GdipGetPropertyCount(image, &count) == Ok? count : 0;
}

FORCEINLINE
Status ImageGetPropertyIdList(PGpImage image, UINT numOfProperty, PROPID* list)
{
	return GdipGetPropertyIdList(image, numOfProperty, list);
}
    
FORCEINLINE
UINT ImageGetPropertyItemSize(PGpImage image, PROPID propId)
{
	UINT size;
	return GdipGetPropertyItemSize(image, propId, &size) == Ok? size : 0;
}

FORCEINLINE
Status ImageGetPropertyItem(PGpImage image,
	PROPID propId, UINT propSize, PropertyItem* buffer)
{
	return GdipGetPropertyItem(image, propId, propSize, buffer);
}

FORCEINLINE
Status ImageGetPropertySize(PGpImage image, UINT* totalBufferSize, UINT* numProperties)
{
	return GdipGetPropertySize(image, totalBufferSize, numProperties);
}

FORCEINLINE
Status ImageGetAllPropertyItems(PGpImage image,
	UINT totalBufferSize, UINT numProperties, PropertyItem* allItems)
{
    if (allItems == NULL) 
		return InvalidParameter;
	return GdipGetAllPropertyItems(image, totalBufferSize, numProperties, allItems);
}

FORCEINLINE
Status ImageRemovePropertyItem(PGpImage image, PROPID propId)
{
    return GdipRemovePropertyItem(image, propId);
}

FORCEINLINE
Status ImageSetPropertyItem(PGpImage image, const PropertyItem* item)
{
    return GdipSetPropertyItem(image, item);
}


FORCEINLINE
PGpBitmap BitmapCreate(INT width, INT height, PixelFormat format)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromScan0(width, height, 0, format, NULL,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromFile(const WCHAR *filename, BOOL useEmbeddedColorManagement)
{
	PGpBitmap bitmap;// = NULL;
	if(useEmbeddedColorManagement)
		GdipCreateBitmapFromFileICM(filename, &bitmap);
	else
		GdipCreateBitmapFromFile(filename, &bitmap);
	return bitmap;
}

FORCEINLINE
PGpBitmap BitmapFromStream(IStream *stream, BOOL useEmbeddedColorManagement)
{
	PGpBitmap bitmap;// = NULL;
	if(useEmbeddedColorManagement)
		GdipCreateBitmapFromStreamICM(stream, &bitmap);
	else
		GdipCreateBitmapFromStream(stream, &bitmap);
	return bitmap;
}

FORCEINLINE
PGpBitmap BitmapFromData(INT width, INT height, INT stride, PixelFormat format, BYTE *scan0)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromScan0(width, height, stride, format, scan0,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromGraphics(INT width, INT height, PGpGraphics target)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromGraphics(width, height, target,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromDirectDrawSurface7(IDirectDrawSurface7* surface)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromDirectDrawSurface(surface,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromBITMAPINFO(const BITMAPINFO* gdiBitmapInfo, VOID* gdiBitmapData)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromGdiDib(gdiBitmapInfo, gdiBitmapData,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromHBITMAP(HBITMAP hbm, HPALETTE hpal)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromHBITMAP(hbm, hpal, &bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromHICON(HICON hicon)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromHICON(hicon, &bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapFromResource(HINSTANCE hInstance, const WCHAR *bitmapName)
{
    PGpBitmap bitmap;
	return GdipCreateBitmapFromResource(hInstance, bitmapName,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapClone(const PGpBitmap source,
	INT x, INT y, INT width, INT height, PixelFormat format)
{
    PGpBitmap bitmap;
	return GdipCloneBitmapAreaI(x, y, width, height, format, source,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
PGpBitmap BitmapCloneF(const PGpBitmap source,
	REAL x, REAL y, REAL width, REAL height, PixelFormat format)
{
    PGpBitmap bitmap;
	return GdipCloneBitmapArea(x, y, width, height, format, source,
		&bitmap) == Ok? bitmap : NULL;
}

FORCEINLINE
Status BitmapLockBits(PGpBitmap bitmap, const PRect rect,
	UINT flags, PixelFormat format, PBitmapData lockedBitmapData)
{
	return GdipBitmapLockBits(bitmap, rect, flags, format, lockedBitmapData);
}

FORCEINLINE
Status BitmapUnlockBits(PGpBitmap bitmap, PBitmapData lockedBitmapData)
{
	return GdipBitmapUnlockBits(bitmap, lockedBitmapData);
}

FORCEINLINE
ARGB BitmapGetPixel(PGpBitmap bitmap, INT x, INT y)
{
	ARGB color;
	return GdipBitmapGetPixel(bitmap, x, y, &color) == Ok? color : 0;
}

FORCEINLINE
Status BitmapSetPixel(PGpBitmap bitmap, INT x, INT y, ARGB color)
{
	return GdipBitmapSetPixel(bitmap, x, y, color);
}

FORCEINLINE
Status BitmapSetResolution(PGpBitmap bitmap, REAL xdpi, REAL ydpi)
{
	return GdipBitmapSetResolution(bitmap, xdpi, ydpi);
}

FORCEINLINE
HBITMAP BitmapGetHBITMAP(PGpBitmap bitmap, ARGB colorBackground)
{
	HBITMAP hbmp;
	return GdipCreateHBITMAPFromBitmap(bitmap,
		&hbmp, colorBackground) == Ok? hbmp : NULL;
}

FORCEINLINE
HICON BitmapGetHICON(PGpBitmap bitmap)
{
	HICON icon;
	return GdipCreateHICONFromBitmap(bitmap, &icon) == Ok? icon : NULL;
}

#define BitmapDelete(bitmap)	ImageDelete(bitmap)

#endif

