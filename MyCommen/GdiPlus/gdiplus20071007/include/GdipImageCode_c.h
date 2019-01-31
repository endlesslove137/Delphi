/**************************************************************************\
*
* Module Name:
*
*   GdipImageCode_c.h
*
* Abstract:
*
*   GDI+ Codec Image APIs
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPIMAGECODE_C_H
#define __GDIPIMAGECODE_C_H

//--------------------------------------------------------------------------
// Codec Management APIs
//--------------------------------------------------------------------------

#define GetImageDecodersSize(numDecoders, size)	\
		GdipGetImageDecodersSize(numDecoders, size)

#define GetImageDecoders(numDecoders, size, decoders)	\
		GdipGetImageDecoders(numDecoders, size, decoders)

#define	GetImageEncodersSize(numEncoders, size)	\
		GdipGetImageEncodersSize(numEncoders, size)

#define GetImageEncoders(numEncoders, size, encoders)	\
		GdipGetImageEncoders(numEncoders, size, encoders)


FORCEINLINE
BOOL GetEncoderClsid(const WCHAR* format, CLSID* Clsid)
{
	UINT i;
	UINT  num;// = 0;			// number of image encoders
	UINT  size;// = 0;			// size of the image encoder array in bytes
	ImageCodecInfo* pImageCodecInfo;

	GetImageEncodersSize(&num, &size);
	if (!size || (pImageCodecInfo = (ImageCodecInfo*)GdipAlloc(size)) == NULL)
		return FALSE; 		// Failure
	GetImageEncoders(num, size, pImageCodecInfo);
	for (i = 0; i < num && wcscmp(pImageCodecInfo[i].MimeType, format); i ++);
	if (i < num)
		*Clsid = pImageCodecInfo[i].Clsid;
	GdipFree(pImageCodecInfo);
	return i < num;
}

#endif  // _GDIPLUSIMAGECODEC_H

