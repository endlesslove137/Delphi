/**************************************************************************\
*
* Module Name:
*
*   GdipBitmap.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipBitmapHPP
#define GdipBitmapHPP

inline
TImageFlags __fastcall TGpImage::GetFlags(void)
{
	CheckStatus(GdipGetImageFlags(Native, &Result.rUINT));
	return (TImageFlags)Result.rINT;
}
inline
int __fastcall TGpImage::GetHeight(void)
{
	CheckStatus(GdipGetImageHeight(Native, &Result.rUINT));
	return Result.rINT;
}
inline
float __fastcall TGpImage::GetHorizontalResolution(void)
{
	CheckStatus(GdipGetImageHorizontalResolution(Native, &Result.rFLOAT));
	return Result.rFLOAT;
}
inline
int __fastcall TGpImage::GetPaletteSize(void)
{
	CheckStatus(GdipGetImagePaletteSize(Native, &Result.rINT));
	return Result.rINT;
}
inline
TGpSizeF __fastcall TGpImage::GetPhysicalDimension()
{
	TGpSizeF size;
	CheckStatus(GdipGetImageDimension(Native, &size.Width, &size.Height));
	return size;
}
inline
TGUID __fastcall TGpImage::GetRawFormat()
{
	TGUID guid;
	CheckStatus(GdipGetImageRawFormat(Native, &guid));
	return guid;
}
inline
TImageType __fastcall TGpImage::GetType(void)
{
	CheckStatus(GdipGetImageType(Native, (GdiplusSys::ImageType*)&Result.rINT));
	return (TImageType)Result.rINT;
}
inline
float __fastcall TGpImage::GetVerticalResolution(void)
{
	CheckStatus(GdipGetImageVerticalResolution(Native, &Result.rFLOAT));
	return Result.rFLOAT;
}
inline
int __fastcall TGpImage::GetWidth(void)
{
	CheckStatus(GdipGetImageWidth(Native, &Result.rUINT));
	return Result.rINT;
}

static const int PixFormat[15] = {
	PixelFormatUndefined,
    PixelFormat1bppIndexed,
	PixelFormat4bppIndexed,
    PixelFormat8bppIndexed,
	PixelFormat16bppGrayScale,
    PixelFormat16bppRGB555,
    PixelFormat16bppRGB565,
    PixelFormat16bppARGB1555,
	PixelFormat24bppRGB,
    PixelFormat32bppRGB,
	PixelFormat32bppARGB,
    PixelFormat32bppPARGB,
    PixelFormat48bppRGB,
    PixelFormat64bppARGB,
    PixelFormat64bppPARGB
};

inline
static int __fastcall GetPixelFormatSize(TPixelFormat Format)
{
	return (PixFormat[Format] >> 8) & 0xff;
}
inline
TPixelFormat __fastcall TGpImage::GetPixelFormat(void)
{
	CheckStatus(GdipGetImagePixelFormat(Native, &Result.rINT));
	for (int i = 14; i >= 0; i --)
		if (Result.rINT == PixFormat[i])
			return (TPixelFormat)i;
	return pfNone;
}
inline
int __fastcall TGpImage::GetFrameDimensionsCount(void)
{
	CheckStatus(GdipImageGetFrameDimensionsCount(Native, &Result.rUINT));
	return Result.rINT;
}
inline
int __fastcall TGpImage::GetPropertyCount(void)
{
	CheckStatus(GdipGetPropertyCount(Native, &Result.rUINT));
	return Result.rINT;
}
inline
int __fastcall TGpImage::GetPropertySize(void)
{
	UINT size;
	CheckStatus(GdipGetPropertySize(Native, &size, &Result.rUINT));
	return size;
}
inline
TColorPalette* __fastcall TGpImage::GetPalette()
{
	if (!FPalette)
	{
		Result.rINT = PaletteSize;
		FPalette = (TColorPalette*)new char[Result.rINT];
		CheckStatus(GdipGetImagePalette(Native, FPalette, Result.rINT));
	}
	return FPalette;
}
inline
void __fastcall TGpImage::SetPalette(const TColorPalette *palette)
{
	CheckStatus(GdipSetImagePalette(Native, palette));
	if (FPalette)
	{
		delete[] (char*)FPalette;
		FPalette = NULL;
    }
}
inline
__fastcall TGpImage::TGpImage(const WideString filename, bool useEmbeddedColorManagement)
{
	if (useEmbeddedColorManagement)
		CheckStatus(GdipLoadImageFromFileICM(filename.c_bstr(), &Native));
	else
		CheckStatus(GdipLoadImageFromFile(filename.c_bstr(), &Native));
}
inline
static TGpImage* __fastcall TGpImage::FromFile(const WideString filename, bool useEmbeddedColorManagement)
{
	return new TGpImage(filename.c_bstr(), useEmbeddedColorManagement);
}
inline
__fastcall TGpImage::TGpImage(IStream *stream, bool useEmbeddedColorManagement)
{
	stream->AddRef();
	try
	{
		if (useEmbeddedColorManagement)
			CheckStatus(GdipLoadImageFromStreamICM(stream, &Native));
		else
			CheckStatus(GdipLoadImageFromStream(stream, &Native));
	}
	__finally
	{
		stream->Release();
    }
}
inline
static TGpImage* __fastcall TGpImage::FromStream(IStream *stream, bool useEmbeddedColorManagement)
{
	return new TGpImage(stream, useEmbeddedColorManagement);
}
inline
__fastcall TGpImage::~TGpImage(void)
{
	if (FPalette) delete[] (char*)FPalette;
	GdipDisposeImage(Native);
}
inline
TGpImage* __fastcall TGpImage::Clone(void)
{
	return new TGpImage(Native, (TCloneAPI)GdipCloneImage);
}
inline
void __fastcall TGpImage::Save(const WideString filename,
	const TGUID &clsidEncoder, const TEncoderParameters* encoderParams)
{
	CheckStatus(GdipSaveImageToFile(Native, filename.c_bstr(), &clsidEncoder, encoderParams));
}
inline
void __fastcall TGpImage::Save(IStream *stream, const TGUID &clsidEncoder,
	const TEncoderParameters* encoderParams)
{
	stream->AddRef();
	try
	{
		CheckStatus(GdipSaveImageToStream(Native, stream, &clsidEncoder, encoderParams));
	}
	__finally
	{
		stream->Release();
	}
}
inline
void __fastcall TGpImage::SaveAdd(const TEncoderParameters* encoderParams)
{
	CheckStatus(GdipSaveAdd(Native, encoderParams));
}
inline
void __fastcall TGpImage::SaveAdd(TGpImage *newImage, const TEncoderParameters* encoderParams)
{
	CheckStatus(GdipSaveAddImage(Native, newImage->Native, encoderParams));
}
inline
void __fastcall TGpImage::GetBounds(TGpRectF &srcRect, TUnit &srcUnit)
{
	CheckStatus(GdipGetImageBounds(Native, &srcRect, (GdiplusSys::Unit*)&srcUnit));
}
inline
TGpImage* __fastcall TGpImage::GetThumbnailImage(int thumbWidth, int thumbHeight,
	GetThumbnailImageAbort callback, void *callbackData)
{
	CheckStatus(GdipGetImageThumbnail(Native, thumbWidth, thumbHeight,
									  &Result.rNATIVE, callback, callbackData));
	return new TGpImage(Result.rNATIVE, NULL);
}
inline
void __fastcall TGpImage::GetFrameDimensionsList(TGUID *dimensionIDs, const int dimensionIDs_Size)
{
	CheckStatus(GdipImageGetFrameDimensionsList(Native, dimensionIDs, dimensionIDs_Size));
}
inline
int __fastcall TGpImage::GetFrameCount(const TGUID &dimensionID)
{
	CheckStatus(GdipImageGetFrameCount(Native, &dimensionID, &Result.rUINT));
	return Result.rINT;
}
inline
void __fastcall TGpImage::SelectActiveFrame(const TGUID &dimensionID, int frameIndex)
{
	CheckStatus(GdipImageSelectActiveFrame(Native, &dimensionID, frameIndex));
}
inline
void __fastcall TGpImage::RotateFlip(TRotateFlipType rotateFlipType)
{
	CheckStatus(GdipImageRotateFlip(Native, (GdiplusSys::RotateFlipType)(int)rotateFlipType));
}
inline
void __fastcall TGpImage::GetPropertyIdList(int numOfProperty, PROPID *list)
{
	CheckStatus(GdipGetPropertyIdList(Native, numOfProperty, list));
}
inline
int __fastcall TGpImage::GetPropertyItemSize(PROPID propId)
{
	CheckStatus(GdipGetPropertyItemSize(Native, propId, &Result.rUINT));
	return Result.rINT;
}
inline
void __fastcall TGpImage::GetPropertyItem(PROPID propId, TPropertyItem* buffer)
{
	CheckStatus(GdipGetPropertyItem(Native, propId, GetPropertyItemSize(propId), buffer));
}
inline
void __fastcall TGpImage::GetAllPropertyItems(TPropertyItem* allItems)
{
	CheckStatus(GdipGetAllPropertyItems(Native, PropertySize, PropertyCount, allItems));
}
inline
void __fastcall TGpImage::RemovePropertyItem(PROPID propId)
{
	CheckStatus(GdipRemovePropertyItem(Native, propId));
}
inline
void __fastcall TGpImage::SetPropertyItem(const TPropertyItem &item)
{
	CheckStatus(GdipSetPropertyItem(Native, &item));
}
inline
int __fastcall TGpImage::GetEncoderParameterListSize(const Activex::TCLSID &clsidEncoder)
{
	CheckStatus(GdipGetEncoderParameterListSize(Native, &clsidEncoder, &Result.rUINT));
	return Result.rINT;
}
inline
void __fastcall TGpImage::GetEncoderParameterList(const Activex::TCLSID &clsidEncoder, int size, TEncoderParameters* buffer)
{
	CheckStatus(GdipGetEncoderParameterList(Native, &clsidEncoder, size, buffer));
}

inline
TGpColor __fastcall TGpBitmap::GetPixel(int x, int y)
{
	CheckStatus(GdipBitmapGetPixel(Native, x, y, &Result.rARGB));
	return TGpColor(Result.rARGB);
}
inline
void __fastcall TGpBitmap::SetPixel(int x, int y, const TGpColor &color)
{
	CheckStatus(GdipBitmapSetPixel(Native, x, y, color.Argb));
}
inline
__fastcall TGpBitmap::TGpBitmap(const WideString filename, bool useEmbeddedColorManagement)
{
	if (useEmbeddedColorManagement)
		CheckStatus(GdipCreateBitmapFromFileICM(filename.c_bstr(), &Native));
	else
		CheckStatus(GdipCreateBitmapFromFile(filename.c_bstr(), &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(IStream *stream, bool useEmbeddedColorManagement)
{
	stream->AddRef();
	try
	{
		if (useEmbeddedColorManagement)
			CheckStatus(GdipCreateBitmapFromStreamICM(stream, &Native));
		else
		CheckStatus(GdipCreateBitmapFromStream(stream, &Native));
	}
	__finally
	{
		stream->Release();
    }
}
inline
__fastcall TGpBitmap::TGpBitmap(int width, int height, int stride, TPixelFormat format, BYTE* scan0)
{
	CheckStatus(GdipCreateBitmapFromScan0(width, height, stride, PixFormat[format], scan0, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(int width, int height, TPixelFormat format)
{
	CheckStatus(GdipCreateBitmapFromScan0(width, height, 0, PixFormat[format], NULL, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(int width, int height, TGpGraphics* target)
{
	CheckStatus(GdipCreateBitmapFromGraphics(width, height, target->Native, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData)
{
	CheckStatus(GdipCreateBitmapFromGdiDib(&gdiBitmapInfo, gdiBitmapData, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(HBITMAP hbm, HPALETTE hpal)
{
	CheckStatus(GdipCreateBitmapFromHBITMAP(hbm, hpal, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(HICON icon)
{
	CheckStatus(GdipCreateBitmapFromHICON(icon, &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(HINSTANCE hInstance, const WideString bitmapName)
{
	CheckStatus(GdipCreateBitmapFromResource(hInstance, bitmapName.c_bstr(), &Native));
}
inline
__fastcall TGpBitmap::TGpBitmap(IDirectDrawSurface7* surface)
{
	GdipCreateBitmapFromDirectDrawSurface(surface, &Native);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromFile(const WideString filename, bool useEmbeddedColorManagement)
{
	return new TGpBitmap(filename, useEmbeddedColorManagement);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromStream(IStream *stream, bool useEmbeddedColorManagement)
{
	return new TGpBitmap(stream, useEmbeddedColorManagement);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromDirectDrawSurface7(IDirectDrawSurface7* surface)
{
	return new TGpBitmap(surface);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromBITMAPINFO(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData)
{
	return new TGpBitmap(gdiBitmapInfo, gdiBitmapData);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromHBITMAP(HBITMAP hbm, HPALETTE hpal)
{
	return new TGpBitmap(hbm, hpal);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromHICON(HICON icon)
{
	return new TGpBitmap(icon);
}
inline
static TGpBitmap* __fastcall TGpBitmap::FromResource(HINSTANCE hInstance, const WideString bitmapName)
{
	return new TGpBitmap(hInstance, bitmapName);
}
inline
TGpBitmap* __fastcall TGpBitmap::Clone(const TGpRect &rect, TPixelFormat format)
{
	return Clone(rect.X, rect.Y, rect.Width, rect.Height, format);
}
inline
TGpBitmap* __fastcall TGpBitmap::Clone(int x, int y, int width, int height, TPixelFormat format)
{
	CheckStatus(GdipCloneBitmapAreaI(x, y, width, height, PixFormat[format], Native, &Result.rNATIVE));
	return new TGpBitmap(Result.rNATIVE, NULL);
}
inline
TGpBitmap* __fastcall TGpBitmap::Clone(const TGpRectF &rect, TPixelFormat format)
{
	return Clone(rect.X, rect.Y, rect.Width, rect.Height, format);
}
inline
TGpBitmap* __fastcall TGpBitmap::Clone(float x, float y, float width, float height, TPixelFormat format)
{
	CheckStatus(GdipCloneBitmapArea(x, y, width, height, PixFormat[format], Native, &Result.rNATIVE));
	return new TGpBitmap(Result.rNATIVE, NULL);
}
inline
void __fastcall TGpBitmap::LockBits(const TGpRect &rect,
	TImageLockModes mode, TPixelFormat format, TBitmapData &data)
{
	CheckStatus(GdipBitmapLockBits(Native, &rect, SETTOBYTE(mode), PixFormat[format], &data));
}
inline
void __fastcall TGpBitmap::UnlockBits(TBitmapData &lockedBitmapData)
{
	CheckStatus(GdipBitmapUnlockBits(Native, &lockedBitmapData));
}
inline
void __fastcall TGpBitmap::SetResolution(float xdpi, float ydpi)
{
	CheckStatus(GdipBitmapSetResolution(Native, xdpi, ydpi));
}
inline
HBITMAP __fastcall TGpBitmap::GetHBITMAP(const TGpColor &colorBackground)
{
	HBITMAP bitmap;
	CheckStatus(GdipCreateHBITMAPFromBitmap(Native, &bitmap, colorBackground.Argb));
	return bitmap;
}
inline
HICON __fastcall TGpBitmap::GetHICON(void)
{
	HICON icon;
	CheckStatus(GdipCreateHICONFromBitmap(Native, &icon));
	return icon;
}

#endif
