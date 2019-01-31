/**************************************************************************\
*
* Module Name:
*
*   GdipBase.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipBaseHPP
#define GdipBaseHPP
//---------------------------------------------------------------------------

typedef	GdiplusSys::Status	TStatus;
typedef	GdiplusSys::SizeF	TGpSizeF, *PGpSizeF;
typedef	GdiplusSys::Size	TGpSize, *PGpSize;
typedef	GdiplusSys::PointF	TGpPointF, *PGpPointF;
typedef	GdiplusSys::Point	TGpPoint, *PGpPoint;
typedef	GdiplusSys::RectF	TGpRectF, *PGpRectF;
typedef	GdiplusSys::Rect	TGpRect, *PGpRect;
typedef	GdiplusSys::Color	TGpColor, *PGpColor;
typedef GdiplusSys::ARGB	TARGB;

typedef	PathData	    	TPathData;
typedef	CharacterRange		TCharacterRange;
typedef	ColorPalette		TColorPalette;
typedef ImageFlags			TImageFlags;
typedef ENHMETAHEADER3  	TENHMETAHEADER3;
typedef WmfPlaceableFileHeader TWmfPlaceableFileHeader;
typedef	MetafileHeader		TMetafileHeader;
typedef EmfPlusRecordType	TEmfPlusRecordType;

typedef GraphicsState		TGraphicsState;
typedef GraphicsContainer	TGraphicsContainer;
typedef	EnumerateMetafileProc	TEnumerateMetafileProc;
typedef ImageAbort			TImageAbort;

typedef	EncoderParameters	TEncoderParameters;
typedef PropertyItem		TPropertyItem;
typedef	BitmapData			TBitmapData;

typedef ImageCodecInfo		TImageCodecInfo;
//---------------------------------------------------------------------------
// GDI+ classes for forward reference
//---------------------------------------------------------------------------

class TGpGraphics;
class TGpPen;
class TGpBrush;
class TGpMatrix;
class TGpBitmap;
class TGpMetafile;
class TGpGraphicsPath;
class TGpPathIterator;
class TGpRegion;
class TGpImage;
class TGpTextureBrush;
class TGpHatchBrush;
class TGpSolidBrush;
class TGpLinearGradientBrush;
class TGpPathGradientBrush;
class TGpFont;
class TGpFontFamily;
class TGpFontCollection;
class TGpInstalledFontCollection;
class TGpPrivateFontCollection;
class TGpImageAttributes;
class TGpCachedBitmap;

class EGdiplusException : public Exception
{
private:
  TStatus FStatus;
  static CHAR* StatusStr[];
  String __fastcall GetErrorStr(void){ return StatusStr[FStatus]; }
public:
  __fastcall EGdiplusException(const TStatus status)
	: FStatus(status), Exception(StatusStr[status]){}
  TStatus __fastcall GetLastResult(){ return FStatus; }
  __property TStatus GdipError = {read=FStatus};
  __property String GdipErrorString = {read=GetErrorStr};
};

CHAR* EGdiplusException::StatusStr[] =
{
	"Ok",
	"GenericError",
	"InvalidParameter",
	"OutOfMemory",
    "ObjectBusy",
    "InsufficientBuffer",
    "NotImplemented",
    "Win32Error",
    "WrongState",
    "Aborted",
    "FileNotFound",
    "ValueOverflow",
    "AccessDenied",
    "UnknownImageFormat",
    "FontFamilyNotFound",
    "FontStyleNotFound",
    "NotTrueTypeFont",
    "UnsupportedGdiplusVersion",
	"GdiplusNotInitialized",
    "PropertyNotFound",
    "PropertyNotSupported"
};

class TGdiplusBase;

class TGdipGenerics
{
private:
	friend	class TGpStringFormat;
	friend  class TGenericStringFormat;
	friend	class TGpFontFamily;
	friend  class TGenericFontFamily;
private:
	ULONG_PTR gpToken;

	TGdiplusBase *FGenericObject[5];

	void GenericNil(TGdiplusBase *Item)
	{
		int i = 0;
		for (; i < 5 && Item != FGenericObject[i]; i ++);
		if (i < 5) FGenericObject[i] = NULL;
	}

	__property TGdiplusBase *GenericSansSerifFontFamily = {read=FGenericObject[0], write=FGenericObject[0]};
	__property TGdiplusBase *GenericSerifFontFamily = {read=FGenericObject[1], write=FGenericObject[1]};
	__property TGdiplusBase *GenericMonospaceFontFamily = {read=FGenericObject[2], write=FGenericObject[2]};
	__property TGdiplusBase *GenericTypographicStringFormatBuffer = {read=FGenericObject[3], write=FGenericObject[3]};
	__property TGdiplusBase *GenericDefaultStringFormatBuffer = {read=FGenericObject[4], write=FGenericObject[4]};

public:
	TGdipGenerics(void)
	{
		GdiplusStartupInput gpInput;
		Status status = GdiplusStartup(&gpToken, &gpInput, NULL);
		if (status != Ok)
			throw EGdiplusException(status);
	}
	~TGdipGenerics(void)
	{
		GdiplusShutdown(gpToken);
	}
};

static TGdipGenerics GdipGenerics;

#define	SETTOBYTE(s)		(int)(*(BYTE*)&s)
#define	SETTOWORD(s)		(int)(*(WORD*)&s)

inline
void CheckStatus(TStatus status)
{
	if (status != Ok)
		throw EGdiplusException(status);
}

typedef Status (__stdcall *TCloneAPI)(void *Native, void **clone);

union retValue {
	BOOL	rBOOL;
	int		rINT;
	UINT	rUINT;
	float	rFLOAT;
	void*	rPVOID;
	ARGB	rARGB;
	WORD	rWORD;
	GpNative*	rNATIVE;
};

class TGdiplusBase : public TObject
{
	friend	class TGpFont;
    friend  class TGpFontFamily;
    friend  class TGpStringFormat;
    
protected:
	static retValue Result;
	GpNative *Native;
	__fastcall TGdiplusBase(void){ }
	__fastcall TGdiplusBase(GpNative *native, TCloneAPI cloneFun)
	{
		if (cloneFun)
			CheckStatus(cloneFun(native, (void**)&Native));
		else
			Native = native;
	}

#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		TGdiplusBase *o = (TGdiplusBase*)TObject::InitInstance(
							cls, GdipAlloc((UINT)InstanceSize(cls)));
		return o;
	}

	virtual void __fastcall FreeInstance()
	{
		CleanupInstance();
		GdipFree(this);
	}
#endif
	const GpNative* ObjectNative(const TGdiplusBase* Object)
	{
		return Object == NULL? NULL : Object->Native;
	}

};

retValue TGdiplusBase::Result;


#endif
