/**************************************************************************\
*
* Module Name:
*
*   GdipImageCodec.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipImageCodecHPP
#define GdipImageCodecHPP

//--------------------------------------------------------------------------
// Codec Management APIs
//--------------------------------------------------------------------------

inline
TStatus GetImageDecodersSize(UINT *numDecoders, UINT *size)
{
	return GdipGetImageDecodersSize(numDecoders, size);
}
inline
TStatus GetImageDecoders(UINT numDecoders, UINT size, TImageCodecInfo *decoders)
{
	return GdipGetImageDecoders(numDecoders, size, decoders);
}
inline
TStatus GetImageEncodersSize(UINT *numEncoders, UINT *size)
{
	return GdipGetImageEncodersSize(numEncoders, size);
}
inline
TStatus GetImageEncoders(UINT numEncoders, UINT size, TImageCodecInfo *encoders)
{
	return GdipGetImageEncoders(numEncoders, size, encoders);
}

inline
bool GetEncoderClsid(const WideString format, CLSID* Clsid)
{
	UINT  num = 0;          // number of image encoders
	UINT  size = 0;         // size of the image encoder array in bytes

	TImageCodecInfo* pImageCodecInfo = NULL;
	GetImageEncodersSize(&num, &size);
	if (size == 0)
		return false;  // Failure
	pImageCodecInfo = (TImageCodecInfo*)new char[size];
	if (!pImageCodecInfo)
		return false;  // Failure
	GetImageEncoders(num, size, pImageCodecInfo);
	UINT i = 0;
	for (; i < num && wcscmp(pImageCodecInfo[i].MimeType, format.c_bstr()) != 0; i ++);
	if (i < num)
		*Clsid = pImageCodecInfo[i].Clsid;
	delete[] (char*)pImageCodecInfo;
	return i < num;
}


#endif  

