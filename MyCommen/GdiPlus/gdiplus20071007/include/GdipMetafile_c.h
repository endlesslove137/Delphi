/**************************************************************************\
*
* Module Name:
*
*   GdipMetafile_c.h
*
* Abstract:
*
*   GDI+ Metafile function
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPMETAFILE_C_H
#define __GDIPMETAFILE_C_H

FORCEINLINE
PGpMetafile MetafileFromWmf(HMETAFILE hWmf,
	const PWmfPlaceableFileHeader wmfPlaceableFileHeader, BOOL deleteWmf)
{
    PGpMetafile metafile;
	return GdipCreateMetafileFromWmf(hWmf, deleteWmf,
		wmfPlaceableFileHeader, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromEmf(HENHMETAFILE hEmf, BOOL deleteEmf)
{
    PGpMetafile metafile;
	return GdipCreateMetafileFromEmf(hEmf, deleteEmf, &metafile) == Ok?
		metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromFile(const WCHAR* filename)
{
    PGpMetafile metafile;
	return GdipCreateMetafileFromFile(filename, &metafile) == Ok?
		metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromWmfFile(const WCHAR* filename,
	const PWmfPlaceableFileHeader wmfPlaceableFileHeader)
{
    PGpMetafile metafile;
	return GdipCreateMetafileFromWmfFile(filename,
		wmfPlaceableFileHeader, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromStream(IStream* stream)
{
    PGpMetafile metafile;
	return GdipCreateMetafileFromStream(stream, &metafile) == Ok?
		metafile : NULL;
}

/* All default frameRect = NULL, frameUnit = MetafileFrameUnitGdi */
FORCEINLINE
PGpMetafile MetafileFromDCF(HDC referenceHdc, const PRectF frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafile(referenceHdc, type, frameRect, frameUnit,
		description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromDC(HDC referenceHdc, const PRect frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafileI(referenceHdc, type, frameRect, frameUnit,
		description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromFileAndDCF(const WCHAR* fileName,
	HDC referenceHdc, const PRectF frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafileFileName(fileName, referenceHdc, type, frameRect,
		frameUnit, description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromFileAndDC(const WCHAR* fileName,
	HDC referenceHdc, const PRect frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafileFileNameI(fileName, referenceHdc, type, frameRect,
		frameUnit, description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromStreamAndDCF(IStream* stream, HDC referenceHdc, const PRectF frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafileStream(stream, referenceHdc, type, frameRect,
		frameUnit, description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileFromStreamAndDC(IStream* stream, HDC referenceHdc, const PRect frameRect,
	MetafileFrameUnit frameUnit, EmfType type, const WCHAR* description)
{
    PGpMetafile metafile;
	return GdipRecordMetafileStreamI(stream, referenceHdc, type, frameRect,
		frameUnit, description, &metafile) == Ok? metafile : NULL;
}

FORCEINLINE
PGpMetafile MetafileCreate(const WCHAR* filename)
{
	return MetafileFromFile(filename);
}

FORCEINLINE
Status MetafileGetHeaderFromWmf(HMETAFILE hWmf,
	const PWmfPlaceableFileHeader wmfPlaceableFileHeader, PMetafileHeader header)
{
	return GdipGetMetafileHeaderFromWmf(hWmf, wmfPlaceableFileHeader, header);
}

FORCEINLINE
Status MetafileGetHeaderFromEmf(HENHMETAFILE hEmf, PMetafileHeader header)
{
	return GdipGetMetafileHeaderFromEmf(hEmf, header);
}

FORCEINLINE
Status MetafileGetHeaderFromFile(const WCHAR* filename, PMetafileHeader header)
{
	return GdipGetMetafileHeaderFromFile(filename, header);
}

FORCEINLINE
Status MetafileGetHeaderFromStream(IStream* stream, PMetafileHeader header)
{
	return GdipGetMetafileHeaderFromStream(stream, header);
}

FORCEINLINE
Status MetafileGetHeader(PGpMetafile metafile, PMetafileHeader header)
{
	return GdipGetMetafileHeaderFromMetafile(metafile, header);
}

// Once this method is called, the Metafile object is in an invalid state
// and can no longer be used.  It is the responsiblity of the caller to
// invoke DeleteEnhMetaFile to delete this hEmf.

FORCEINLINE
Status MetafileGetHENHMETAFILE(PGpMetafile metafile, HENHMETAFILE* pEmf)
{
	return GdipGetHemfFromMetafile(metafile, pEmf);
}

// Used in conjuction with Graphics::EnumerateMetafile to play an EMF+
// The data must be DWORD aligned if it's an EMF or EMF+.  It must be
// WORD aligned if it's a WMF.

FORCEINLINE
Status MetafilePlayRecord(PGpMetafile metafile, EmfPlusRecordType recordType,
	UINT flags, UINT dataSize, const BYTE* data)
{
	return GdipPlayMetafileRecord(metafile, recordType, flags, dataSize, data);
}

// If you're using a printer HDC for the metafile, but you want the
// metafile rasterized at screen resolution, then use this API to set
// the rasterization dpi of the metafile to the screen resolution,
// e.g. 96 dpi or 120 dpi.

FORCEINLINE
Status MetafileSetDownLevelRasterizationLimit(PGpMetafile metafile,
	UINT metafileRasterizationLimitDpi)
{
	return GdipSetMetafileDownLevelRasterizationLimit(metafile,
		metafileRasterizationLimitDpi);
}

FORCEINLINE
UINT MetafileGetDownLevelRasterizationLimit(PGpMetafile metafile)
{
	UINT metafileRasterizationLimitDpi;
	return GdipGetMetafileDownLevelRasterizationLimit(metafile,
		&metafileRasterizationLimitDpi) == Ok? metafileRasterizationLimitDpi : 0;
}

FORCEINLINE
UINT MetafileEmfToWmfBits(HENHMETAFILE hemf, UINT cbData16,
	LPBYTE pData16, INT iMapMode, INT eFlags)
{
	return GdipEmfToWmfBits(hemf, cbData16, pData16, iMapMode, eFlags);
}

#endif // !_METAFILE_H

