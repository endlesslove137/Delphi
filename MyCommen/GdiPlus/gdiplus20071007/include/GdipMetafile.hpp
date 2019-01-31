/**************************************************************************\
*
* Module Name:
*
*   GdipMetafile.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipMetafileHPP
#define GdipMetafileHPP

enum TEmfType
{
    etOnly,
    etPlusOnly,
    etPlusDual
};

enum TMetafileFrameUnit
{
    muPixel = 2,
    muUnitPoint,
    muInch,
    muDocument,
    muMillimeter,
    muGdi
};

enum TEmfToWmfBitsFlag
{
    ewEmbedEmf,
    ewIncludePlaceable,
    ewNoXORClip
};

typedef Set<TEmfToWmfBitsFlag, ewEmbedEmf, ewNoXORClip> TEmfToWmfBitsFlags;

class TGpMetafile : public TGpImage
{
private:
	friend class TGpImage;

protected:
//	__fastcall TGpMetafile(GpNative *native, TCloneAPI cloneFun) : TGpImage(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpMetafile));
	}
#endif
public:
	__fastcall TGpMetafile(HMETAFILE hWmf,
        const TWmfPlaceableFileHeader &wmfPlaceableFileHeader, bool deleteWmf = false)
	{
		CheckStatus(GdipCreateMetafileFromWmf(hWmf, deleteWmf, &wmfPlaceableFileHeader, &Native));
	}
	__fastcall TGpMetafile(HENHMETAFILE hEmf, bool deleteEmf = false)
    {
        CheckStatus(GdipCreateMetafileFromEmf(hEmf, deleteEmf, &Native));
    }
	__fastcall TGpMetafile(WideString filename)
    {
		CheckStatus(GdipCreateMetafileFromFile(filename.c_bstr(), &Native));
    }
	__fastcall TGpMetafile(WideString filename, const TWmfPlaceableFileHeader &wmfPlaceableFileHeader)
    {
		CheckStatus(GdipCreateMetafileFromWmfFile(filename.c_bstr(), &wmfPlaceableFileHeader, &Native));
    }
	__fastcall TGpMetafile(IStream *stream)
	{
		stream->AddRef();
		try
		{
			CheckStatus(GdipCreateMetafileFromStream(stream, &Native));
		}
		__finally
		{
			stream->Release();
        }
    }
	__fastcall TGpMetafile(HDC referenceHdc, TEmfType type = etPlusDual, wchar_t *description = NULL)
	{
		CheckStatus(GdipRecordMetafile(referenceHdc, (GdiplusSys::EmfType)(int)type, NULL,
				MetafileFrameUnitGdi, description, &Native));
	}
	__fastcall TGpMetafile(HDC referenceHdc, const TGpRectF &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		CheckStatus(GdipRecordMetafile(referenceHdc, (GdiplusSys::EmfType)(int)type, &frameRect,
					(GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
	}
	__fastcall TGpMetafile(HDC referenceHdc, const TGpRect &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		CheckStatus(GdipRecordMetafileI(referenceHdc, (GdiplusSys::EmfType)(int)type, &frameRect,
					(GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
    }
	__fastcall TGpMetafile(WideString fileName, HDC referenceHdc,
        TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		CheckStatus(GdipRecordMetafileFileName(fileName.c_bstr(), referenceHdc, (GdiplusSys::EmfType)(int)type,
					NULL, MetafileFrameUnitGdi, description, &Native));
    }
	__fastcall TGpMetafile(WideString fileName, HDC referenceHdc, const TGpRectF &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		CheckStatus(GdipRecordMetafileFileName(fileName.c_bstr(), referenceHdc, (GdiplusSys::EmfType)(int)type,
					&frameRect, (GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
	}
	__fastcall TGpMetafile(WideString fileName, HDC referenceHdc, const TGpRect &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		CheckStatus(GdipRecordMetafileFileNameI(fileName.c_bstr(), referenceHdc, (GdiplusSys::EmfType)(int)type,
					&frameRect, (GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
	}
	__fastcall TGpMetafile(IStream *stream, HDC referenceHdc, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		stream->AddRef();
		try
		{
			CheckStatus(GdipRecordMetafileStream(stream, referenceHdc, (GdiplusSys::EmfType)(int)type,
                NULL, MetafileFrameUnitGdi, description, &Native));
		}
		__finally
		{
			stream->Release();
		}
    }
	__fastcall TGpMetafile(IStream *stream, HDC referenceHdc, const TGpRectF &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		stream->AddRef();
		try
		{
			CheckStatus(GdipRecordMetafileStream(stream, referenceHdc, (GdiplusSys::EmfType)(int)type,
                &frameRect, (GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
		}
		__finally
		{
			stream->Release();
		}
	}
	__fastcall TGpMetafile(IStream *stream, HDC referenceHdc, const TGpRect &frameRect,
		TMetafileFrameUnit frameUnit = muGdi, TEmfType type = etPlusDual, wchar_t * description = NULL)
	{
		stream->AddRef();
		try
		{
			CheckStatus(GdipRecordMetafileStreamI(stream, referenceHdc, (GdiplusSys::EmfType)(int)type,
                &frameRect, (GdiplusSys::MetafileFrameUnit)(int)frameUnit, description, &Native));
		}
		__finally
		{
			stream->Release();
		}
	}
	static void __fastcall GetMetafileHeader(HMETAFILE hWmf,
		const TWmfPlaceableFileHeader &wmfPlaceableFileHeader, TMetafileHeader *header)
	{
		CheckStatus(GdipGetMetafileHeaderFromWmf(hWmf, &wmfPlaceableFileHeader, header));
	}
	static void __fastcall GetMetafileHeader(HENHMETAFILE hEmf, TMetafileHeader *header)
	{
		CheckStatus(GdipGetMetafileHeaderFromEmf(hEmf, header));
    }
	static void __fastcall GetMetafileHeader(const WideString filename, TMetafileHeader *header)
	{
		CheckStatus(GdipGetMetafileHeaderFromFile(filename.c_bstr(), header));
    }
	static void __fastcall GetMetafileHeader(IStream *stream, TMetafileHeader *header)
	{
		stream->AddRef();
		try
		{
			CheckStatus(GdipGetMetafileHeaderFromStream(stream, header));
		}
		__finally
		{
			stream->Release();
		}
	}
	void __fastcall GetMetafileHeader(TMetafileHeader *header)
	{
		CheckStatus(GdipGetMetafileHeaderFromMetafile(Native, header));
    }
	HENHMETAFILE __fastcall GetHENHMETAFILE(void)
	{
		HENHMETAFILE hEmf;
		CheckStatus(GdipGetHemfFromMetafile(Native, &hEmf));
		return hEmf;
	}
	void __fastcall PlayRecord(TEmfPlusRecordType recordType, int flags, int dataSize, const Byte *data)
	{
		CheckStatus(GdipPlayMetafileRecord(Native, recordType, flags, dataSize, data));
    }
	void __fastcall SetDownLevelRasterizationLimit(int metafileRasterizationLimitDpi)
	{
		CheckStatus(GdipSetMetafileDownLevelRasterizationLimit(Native, metafileRasterizationLimitDpi));
    }
	int __fastcall GetDownLevelRasterizationLimit(void)
	{
		CheckStatus(GdipGetMetafileDownLevelRasterizationLimit(Native, &Result.rUINT));
		return Result.rINT;
    }
	static void __fastcall EmfToWmfBits(HENHMETAFILE hemf, unsigned int cbData16, Byte *pData16,
		int iMapMode = MM_ANISOTROPIC, TEmfToWmfBitsFlags eFlags = TEmfToWmfBitsFlags())
	{
		CheckStatus((TStatus)GdipEmfToWmfBits(hemf, cbData16, pData16, iMapMode, SETTOBYTE(eFlags)));
	}

};

#endif // !GdipMetafileHPP
