/**************************************************************************\
*
* Module Name:
*
*   GdipHeaders.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipHeadersHPP
#define GdipHeadersHPP

class TGpRegion : public TGdiplusBase
{
private:
	friend	class TGpGraphics;

	int __fastcall GetDataSize(void);

protected:
	__fastcall TGpRegion(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpRegion));
	}
#endif
public:
	// 用无限内部初始化新 Region 对象。
	__fastcall TGpRegion(void);
	// 从指定的 Rect 结构初始化新 Region 对象。
	__fastcall TGpRegion(const TGpRectF &rect);
	__fastcall TGpRegion(const TGpRect &rect);
	// 从指定的 Rect 结构初始化新 Region 对象。
	__fastcall TGpRegion(TGpGraphicsPath *path);
    // 用现有的 Region 对象的内部数据创建一个新 Region 对象。
	// regionData 包含Region对象内部数据的缓冲区，一般通过GetData获得
	__fastcall TGpRegion(BYTE *regionData, const int regionData_Size);
	// 用指定的现有 GDI 区域的句柄初始化新 Region 对象。
	__fastcall TGpRegion(HRGN hrgn);
	static TGpRegion* __fastcall FromHRGN(HRGN hrgn);
	__fastcall virtual ~TGpRegion(void);
	TGpRegion* __fastcall Clone(void);
	// 将此 Region 对象初始化为无限内部。
	void __fastcall MakeInfinite(void);
	// 将此 Region 对象初始化为空内部。
	void __fastcall MakeEmpty(void);
	// 返回 RegionData，它表示用于描述此 Region 结构或对象的信息。
	void __fastcall GetData(BYTE *buffer, const int buffer_Size, UINT *sizeFilled = NULL);
	// 将此 Region 对象更新为其自身与指定结构或对象的交集。
	void __fastcall Intersect(const TGpRect &rect);
	void __fastcall Intersect(const TGpRectF &rect);
	void __fastcall Intersect(TGpGraphicsPath* path);
	void __fastcall Intersect(TGpRegion* region);
	// 将此 Region 对象更新为其自身与指定结构或对象的并集。
	void __fastcall Union(const TGpRect &rect);
	void __fastcall Union(const TGpRectF &rect);
	void __fastcall Union(TGpGraphicsPath* path);
	void __fastcall Union(TGpRegion* region);
	// 将此 Region 对象更新为其自身与指定结构或对象的并集减去这两者的交集
	void __fastcall Xor(const TGpRect &rect);
	void __fastcall Xor(const TGpRectF &rect);
	void __fastcall Xor(TGpGraphicsPath* path);
	void __fastcall Xor(TGpRegion* region);
	// 将此 Region 对象更新为仅包含其内部与指定结构或对象不相交的部分。
	void __fastcall Exclude(const TGpRect &rect);
	void __fastcall Exclude(const TGpRectF &rect);
	void __fastcall Exclude(TGpGraphicsPath* path);
	void __fastcall Exclude(TGpRegion* region);
	// 将此 Region 对象更新为指定结构或者对象中与此 Region 对象不相交的部分。
	void __fastcall Complement(const TGpRect &rect);
	void __fastcall Complement(const TGpRectF &rect);
	void __fastcall Complement(TGpGraphicsPath* path);
	void __fastcall Complement(TGpRegion* region);
	// 使此 Region 对象的坐标偏移指定的量。
	void __fastcall Translate(float dx, float dy);
	void __fastcall Translate(int dx, int dy);
	// 用指定的 Matrix 对象变换此 Region 对象。
	void __fastcall Transform(TGpMatrix* matrix);
	// 获取一个矩形结构，该矩形形成 Graphics 对象的绘制表面上此 Region 对象的边界。
	void __fastcall GetBounds(TGpRect &rect, const TGpGraphics* g);
	void __fastcall GetBounds(TGpRectF &rect, const TGpGraphics* g);
	// 返回指定图形上下文中此 Region 对象的 Windows GDI 句柄。
	HRGN __fastcall GetHRGN(TGpGraphics* g);
	// 测试此 Region 对象在指定的绘制表面 g 上是否空的内部
	bool __fastcall IsEmpty(TGpGraphics* g);
	// 测试此 Region 对象在指定的绘制表面上是否无限内部。
	bool __fastcall IsInfinite(TGpGraphics* g);
	// 测试指定的坐标是否包含在此 Region 对象内。
	bool __fastcall IsVisible(int x, int y, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpPoint &point, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(float x, float y, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpPointF &point, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(int x, int y, int width, int height, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpRect &rect, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(float x, float y, float width, float height, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpRectF &rect, TGpGraphics* g = NULL);
#if (__BORLANDC__ >= 0x610)
	HIDESBASE bool __fastcall Equals(TGpRegion* region, TGpGraphics* g);
#else
	bool __fastcall Equals(TGpRegion* region, TGpGraphics* g);
#endif
	int __fastcall GetRegionScansCount(TGpMatrix* matrix);
	// 获取与此 Region 对象近似的 RectF 结构的数组。返回数组元素个数
	int __fastcall GetRegionScans(TGpMatrix* matrix, TGpRectF *rects);
	int __fastcall GetRegionScans(TGpMatrix* matrix, TGpRect *rects);
	// 返回描述 Region 对象信息缓冲区的长度
	__property int DataSize = {read=GetDataSize};

};

//--------------------------------------------------------------------------
// FontFamily
//--------------------------------------------------------------------------

class TGpFontFamily : public TGdiplusBase
{
private:
	friend class TGpFont;
	friend class TGpGraphics;
	friend class TGpGraphicsPath;
	friend class TGpFontCollection;

protected:
	__fastcall TGpFontFamily(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFontFamily));
	}
#endif
public:
	__fastcall TGpFontFamily(void) : TGdiplusBase() { }
	__fastcall TGpFontFamily(WideString name, TGpFontCollection* fontCollection = NULL);
	__fastcall virtual ~TGpFontFamily(void);
	static TGpFontFamily* __fastcall GenericSansSerif(void);
	static TGpFontFamily* __fastcall GenericSerif(void);
	static TGpFontFamily* __fastcall GenericMonospace(void);
	// 用指定的语言返回此 FontFamily 对象的名称。
	WideString __fastcall GetFamilyName(WORD language = 0);
	TGpFontFamily* __fastcall Clone(void);
	// FontFamily 对象是否有效
	bool __fastcall IsAvailable(void);
	// 指示指定的 FontStyle 枚举是否有效。
	bool __fastcall IsStyleAvailable(TFontStyles style);
	// 获取指定样式的 em 方形的高度，采用字体设计单位。
	WORD __fastcall GetEmHeight(TFontStyles style);
	// 返回指定样式的 FontFamily 对象的单元格上升
	WORD __fastcall GetCellAscent(TFontStyles style);
	// 返回指定样式的 FontFamily 对象的单元格下降
	WORD __fastcall GetCellDescent(TFontStyles style);
	// 返回指定样式的 FontFamily 对象的行距
	WORD __fastcall GetLineSpacing(TFontStyles style);

};

enum TUnit {
	utWorld,      // 0 -- 将全局单位指定为度量单位。
	utDisplay,    // 1 -- 将 1/75 英寸指定为度量单位。
	utPixel,      // 2 -- 将设备像素指定为度量单位。
	utPoint,      // 3 -- 将打印机点（1/72 英寸）指定为度量单位。.
	utInch,       // 4 -- 将英寸指定为度量单位
	utDocument,   // 5 -- 将文档单位（1/300 英寸）指定为度量单位。
	utMillimeter  // 6 -- 将毫米指定为度量单位。
};

//--------------------------------------------------------------------------
// Font
//--------------------------------------------------------------------------

class TGpFont : public TGdiplusBase
{
private:
	friend class TGpGraphics;

private:
	float __fastcall GetSize(void);
	TFontStyles __fastcall GetStyle(void);
	TUnit __fastcall GetUnit(void);
	WideString __fastcall GetName();

protected:
	__fastcall TGpFont(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFont));
	}
#endif
public:
	    // 从设备上下文的指定 Windows 句柄创建 Font 对象。
    // DC 参数必须包含其中选定字体的设备上下文的句柄。
	// 此方法不能用于从 GDI+ Graphics 对象获得的 hdc，因为此 hdc 没有选定的字体。
	__fastcall TGpFont(HDC DC);
	__fastcall TGpFont(HDC DC, LOGFONTA* logfont);
	__fastcall TGpFont(HDC DC, LOGFONTW* logfont);
	__fastcall TGpFont(HDC DC, HFONT font);
	__fastcall TGpFont(TGpFontFamily* family, float emSize,
		TFontStyles style = TFontStyles(), TUnit unit = utPoint);
	__fastcall TGpFont(WideString familyName, float emSize,
		TFontStyles style = TFontStyles(), TUnit unit = utPoint,
		TGpFontCollection* fontCollection = NULL);
	__fastcall virtual ~TGpFont(void);
	LOGFONTA __fastcall GetLogFontA(TGpGraphics* g);
	LOGFONTW __fastcall GetLogFontW(TGpGraphics* g);
	TGpFont* __fastcall Clone(void);
	bool __fastcall IsAvailable(void);
	// 采用指定的 Graphics 对象的当前单位，返回此字体的行距。
	float __fastcall GetHeight(TGpGraphics* graphics);
    // 当用指定的垂直分辨率绘制到设备时返回此 Font 对象的高度，以像素为单位。
    // 行距是两个连续文本行的基线之间的垂直距离。
	// 因此，行距包括行间的空白空间及字符本身的高度。
	float __fastcall GetHeight(float dpi);
	// 获取此 Font 对象的字形信息。
	void __fastcall GetFamily(TGpFontFamily* family);
	// 获取采用这个 Font 对象的单位测量出的、这个 Font 对象的全身大小
	__property float Size = {read=GetSize};
	__property TFontStyles Style = {read=GetStyle};
	__property TUnit FontUnit = {read=GetUnit};
	__property WideString Name = {read=GetName};

};

//--------------------------------------------------------------------------
// Font Collection
//--------------------------------------------------------------------------
class TGpFontCollection : public TGdiplusBase
{
private:
	friend	class TGpFontFamily;

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFontCollection));
	}
#endif
public:
	__fastcall TGpFontCollection(void) : TGdiplusBase() { }
	__fastcall virtual ~TGpFontCollection(void) { }
	int __fastcall GetFamilyCount(void);
	int __fastcall GetFamilies(TGpFontFamily **gpfamilies, const int gpfamilies_Size);

};

class TGpInstalledFontCollection : public TGpFontCollection
{
protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpInstalledFontCollection));
	}
#endif
public:
	__fastcall TGpInstalledFontCollection(void);
	__fastcall virtual ~TGpInstalledFontCollection(void) { }

};

class TGpPrivateFontCollection : public TGpFontCollection
{
protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpPrivateFontCollection));
	}
#endif
public:
	__fastcall TGpPrivateFontCollection(void);
	__fastcall virtual ~TGpPrivateFontCollection(void);
	void __fastcall AddFontFile(const WideString filename);
	void __fastcall AddMemoryFont(const void *memory, int length);

};

//--------------------------------------------------------------------------
// Abstract base class for Image and Metafile
//--------------------------------------------------------------------------

enum TImageType {itUnknown, itBitmap, itMetafile};
enum TRotateFlipType
{
	rfNone     = 0,      // 指定不进行旋转和翻转
	rfNone90   = 1,      // 指定不进行翻转的 90 度旋转。
	rfNone180  = 2,      // 指定不进行翻转的 180 度旋转。
	rfNone270  = 3,      // 指定不进行翻转的 270 度旋转。

	rfXNone    = 4,      // 指定水平翻转。
	rfX90      = 5,      // 指定水平翻转的 90 度旋转。
	rfX180     = 6,      // 指定水平翻转的 180 度旋转。
	rfX270     = 7,      // 指定水平翻转的 270 度旋转。

	rfYNone = rfX180,    // 指定垂直翻转
	rfY90 = rfX270,      // 指定垂直翻转的 90 度旋转。
	rfY180 = rfXNone,    // 指定垂直翻转的 180 度旋转。
	rfY270 = rfX90,      // 指定垂直翻转的 270 度旋转。

	rfXYNone = rfNone180,// 指定没有水平和垂直翻转的旋转
	rfXY90 = rfNone270,  // 指定水平翻转和垂直翻转的 90 度旋转。
	rfXY180 = rfNone,    // 指定水平翻转和垂直翻转的 180 度旋转。
	rfXY270 = rfNone90   // 指定水平翻转和垂直翻转的 270 度旋转。
};

enum TPixelFormat
{
    pfNone,           // 未定义
    pf1bppIndexed,    // 像素格式为 1 位，并指定它使用索引颜色。因此颜色表中有两种颜色。
    pf4bppIndexed,    // 像素格式为 4 位而且已创建索引。
    pf8bppIndexed,    // 像素格式为 8 位而且已创建索引。因此颜色表中有 256 种颜色。
    pf16bppGrayScale, // 像素格式为 16 位。该颜色信息指定 65536 种灰色调。
    pf16bppRGB555,    // 像素格式为 16 位；红色、绿色和蓝色分量各使用 5 位。剩余的 1 位未使用。
    pf16bppRGB565,    // 像素格式为 16 位；红色分量使用 5 位，绿色分量使用 6 位，蓝色分量使用 5 位。
    pf16bppARGB1555,  // 像素格式 16 位。该颜色信息指定 32,768 种色调，红色、绿色和蓝色分量各使用 5 位，1 位为 alpha。
    pf24bppRGB,       // 像素格式为 24 位；红色、绿色和蓝色分量各使用 8 位。
    pf32bppRGB,       // 像素格式为 32 位；红色、绿色和蓝色分量各使用 8 位。剩余的 8 位未使用。
    pf32bppARGB,      // 像素格式为 32 位；alpha、红色、绿色和蓝色分量各使用 8 位。
    pf32bppPARGB,	  // 像素格式为 32 位；alpha、红色、绿色和蓝色分量各使用 8 位。根据 alpha 分量，对红色、绿色和蓝色分量进行自左乘。
    pf48bppRGB,		  // 像素格式为 48 位；红色、绿色和蓝色分量各使用 16 位。
    pf64bppARGB,      // 像素格式为 64 位；alpha、红色、绿色和蓝色分量各使用 16 位。
    pf64bppPARGB,	  // 像素格式为 64 位；alpha、红色、绿色和蓝色分量各使用 16 位。根据 alpha 分量，对红色、绿色和蓝色分量进行自左乘。
};

class TGpImage : public TGdiplusBase
{
private:
	friend class TGpBrush;
	friend class TGpTextureBrush;
	friend class TGpGraphics;

protected:
	__fastcall TGpImage(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpImage));
	}
#endif
    __fastcall TGpImage(void){}
private:
	TColorPalette* FPalette;

	TImageFlags __fastcall GetFlags(void);
	int __fastcall GetHeight(void);
	float __fastcall GetHorizontalResolution(void);
	int __fastcall GetPaletteSize(void);
	TGpSizeF __fastcall GetPhysicalDimension();
	TGUID __fastcall GetRawFormat();
	TImageType __fastcall GetType(void);
	float __fastcall GetVerticalResolution(void);
	int __fastcall GetWidth(void);
	TPixelFormat __fastcall GetPixelFormat(void);
	int __fastcall GetFrameDimensionsCount(void);
	int __fastcall GetPropertyCount(void);
	int __fastcall GetPropertySize(void);
	TColorPalette* __fastcall GetPalette();
	void __fastcall SetPalette(const TColorPalette *palette);
	
public:
	// 使用该文件中的嵌入颜色管理信息，从指定的文件创建 Image 对象。
	__fastcall TGpImage(const WideString filename, bool useEmbeddedColorManagement = false);
	static TGpImage* __fastcall FromFile(const WideString filename, bool useEmbeddedColorManagement = false);
	// 使用指定的数据流中嵌入的颜色管理信息，从该数据流创建 Image 对象。
	__fastcall TGpImage(IStream *stream, bool useEmbeddedColorManagement = false);
	static TGpImage* __fastcall FromStream(IStream *stream, bool useEmbeddedColorManagement = false);
	__fastcall virtual ~TGpImage(void);
	virtual TGpImage* __fastcall Clone(void);
	// 将此图像以指定的格式保存到指定的文件中
	// 注：通过文件名建立的Image，因文件处于引用状态，直接覆盖保存会出错
	void __fastcall Save(const WideString filename, const TGUID &clsidEncoder,
			const TEncoderParameters* encoderParams = NULL);
	// 将此图像以指定的格式保存到指定的流中。
	void __fastcall Save(IStream *stream, const TGUID &clsidEncoder,
			const TEncoderParameters* encoderParams = NULL);
	// 在上一 Save 方法调用所指定的文件或流内添加一帧。
	void __fastcall SaveAdd(const TEncoderParameters* encoderParams);
	void __fastcall SaveAdd(TGpImage *newImage, const TEncoderParameters* encoderParams);
	// 以指定的单位获取此 Image 对象的矩形
	void __fastcall GetBounds(TGpRectF &srcRect, TUnit &srcUnit);
	// 返回此 Image 对象的缩略图。使用后必须Free
	TGpImage* __fastcall GetThumbnailImage(int thumbWidth, int thumbHeight,
			GetThumbnailImageAbort callback = NULL, void *callbackData = NULL);
	// 获取 GUID 的数组，这些 GUID 表示 Image 对象中帧的维度。
	void __fastcall GetFrameDimensionsList(TGUID *dimensionIDs, const int dimensionIDs_Size);
	// 返回指定维度的帧数。
	int __fastcall GetFrameCount(const TGUID &dimensionID);
	// 选择由维度和索引指定的帧。
	void __fastcall SelectActiveFrame(const TGUID &dimensionID, int frameIndex);
	// 此方法旋转、翻转或者同时旋转和翻转 Image 对象。
	void __fastcall RotateFlip(TRotateFlipType rotateFlipType);
	// 获取存储于 Image 对象中的属性项的 ID。list长度不小于PropertyCount
	void __fastcall GetPropertyIdList(int numOfProperty, PROPID *list);
	// 获取propID所指属性项的长度，包括TPropertyItem长度和其value所指的长度
	int __fastcall GetPropertyItemSize(PROPID propId);
	// 获取propID所指属性项，buffer的长度应不小于GetPropertyItemSize
	void __fastcall GetPropertyItem(PROPID propId, TPropertyItem* buffer);
	// 获取全部属性项，alItems的长度必须不小于PropertySize
	void __fastcall GetAllPropertyItems(TPropertyItem* allItems);
	// 从Image中移去propID所指的属性项
	void __fastcall RemovePropertyItem(PROPID propId);
	// 设置属性项
	void __fastcall SetPropertyItem(const TPropertyItem &item);
	// 返回有关指定的图像编码器所支持的参数的信息的长度（字节数）
	int __fastcall GetEncoderParameterListSize(const Activex::TCLSID &clsidEncoder);
	// 返回有关指定的图像编码器所支持的参数的信息。
	void __fastcall GetEncoderParameterList(const Activex::TCLSID &clsidEncoder, int size, TEncoderParameters* buffer);
    // 返回指定的像素格式的颜色深度（像素的位数）。
	static int __fastcall GetPixelFormatSize(TPixelFormat Format);
	// 获取此 Image 对象的属性标记
	__property TImageFlags Flags = {read=GetFlags};
	// 获取此 Image 对象的高度。
	__property int Height = {read=GetHeight};
	// 获取此 Image 对象的水平分辨率（以“像素/英寸”为单位）。
	__property float HorizontalResolution = {read=GetHorizontalResolution};
	// 获取此图像的宽度和高度。
	__property TGpSizeF PhysicalDimension = {read=GetPhysicalDimension};
	// 获取此 Image 对象的格式。
	__property TGUID RawFormat = {read=GetRawFormat};
	// 获取 Image 对象的类型
	__property TImageType ImageType = {read=GetType};
	// 获取此 Image 对象的垂直分辨率（以“像素/英寸”为单位）。
	__property float VerticalResolution = {read=GetVerticalResolution};
	// 获取此 Image 对象的宽度。
	__property int Width = {read=GetWidth};
	// 获取此 Image 对象的像素格式。
	__property TPixelFormat PixelFormat = {read=GetPixelFormat};
	__property int FrameDimensionsCount = {read=GetFrameDimensionsCount};
	// 获取存储于 Image 对象中的属性个数
	__property int PropertyCount = {read=GetPropertyCount};
	// 获取存储于 Image 对象中的全部属性项的长度，包括TpropertyItem.value所指的字节数
	__property int PropertySize = {read=GetPropertySize};
	// 获取调色板的长度
	__property int PaletteSize = {read=GetPaletteSize};
	// 获取或设置用于此 Image 对象的调色板。
	__property TColorPalette* Palette = {read=GetPalette, write=SetPalette};

};

enum TImageLockMode
{
	imRead,
	imWrite,
	imUserInputBuf
};

typedef Set<TImageLockMode, imRead, imUserInputBuf> TImageLockModes;

class TGpBitmap : public TGpImage
{
private:
	friend class TGpImage;
	friend class TGpCachedBitmap;

protected:
	__fastcall TGpBitmap(GpNative *native, TCloneAPI cloneFun) : TGpImage(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpBitmap));
	}
#endif
private:
	TGpColor __fastcall GetPixel(int x, int y);
	void __fastcall SetPixel(int x, int y, const TGpColor &color);
	
public:
	__fastcall TGpBitmap(const WideString filename, bool useEmbeddedColorManagement = false);
	__fastcall TGpBitmap(IStream *stream, bool useEmbeddedColorManagement = false);
	__fastcall TGpBitmap(int width, int height, int stride, TPixelFormat format, BYTE* scan0);
	__fastcall TGpBitmap(int width, int height, TPixelFormat format = pf32bppARGB);
	__fastcall TGpBitmap(int width, int height, TGpGraphics* target);
	__fastcall TGpBitmap(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData);
	__fastcall TGpBitmap(HBITMAP hbm, HPALETTE hpal);
	__fastcall TGpBitmap(HICON icon);
	__fastcall TGpBitmap(HINSTANCE hInstance, const WideString bitmapName);
	__fastcall TGpBitmap(IDirectDrawSurface7* surface);
	static TGpBitmap* __fastcall FromFile(const WideString filename, bool useEmbeddedColorManagement = false);
	static TGpBitmap* __fastcall FromStream(IStream *stream, bool useEmbeddedColorManagement = false);
	static TGpBitmap* __fastcall FromDirectDrawSurface7(IDirectDrawSurface7* surface);
	static TGpBitmap* __fastcall FromBITMAPINFO(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData);
	static TGpBitmap* __fastcall FromHBITMAP(HBITMAP hbm, HPALETTE hpal);
	static TGpBitmap* __fastcall FromHICON(HICON icon);
	static TGpBitmap* __fastcall FromResource(HINSTANCE hInstance, const WideString bitmapName);

	HIDESBASE TGpBitmap* __fastcall Clone(const TGpRect &rect, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(int x, int y, int width, int height, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(const TGpRectF &rect, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(float x, float y, float width, float height, TPixelFormat format);
	// 将 Bitmap 对象锁定到系统内存中。参数 rect: 它指定要锁定的 Bitmap 部分。
    // flags: ImageLockMode 枚举，它指定 Bitmap 对象的访问级别（读和写）。
	// format: Bitmap 对象的数据格式
	void __fastcall LockBits(const TGpRect &rect, TImageLockModes mode, TPixelFormat format, TBitmapData &data);
	// 从系统内存解锁 Bitmap。
	void __fastcall UnlockBits(TBitmapData &lockedBitmapData);
	// 设置此 Bitmap 的分辨率。
	void __fastcall SetResolution(float xdpi, float ydpi);
	    // 用此 Bitmap 对象创建并返回 GDI 位图对象。colorBackground指定背景色。
	// 如果位图完全不透明，则忽略此参数。应调用 DeleteObject 释放 GDI 位图对象
	HBITMAP __fastcall GetHBITMAP(const TGpColor &colorBackground);
	// 返回图标的句柄。
	HICON __fastcall GetHICON(void);
	// 获取或设置 Bitmap 对象中指定像素的颜色。
	__property TGpColor Pixels[int x][int y] = {read=GetPixel, write=SetPixel};

};


//--------------------------------------------------------------------------
// Line cap constants (only the lowest 8 bits are used).
//--------------------------------------------------------------------------

enum TLineCap
{
	lcFlat,   					// 平线帽。
	lcSquare,   				// 方线帽。
	lcRound,   					// 圆线帽
	lcTriangle,   				// 三角线帽。
	lcNoAnchor         = 0x10, 	// 没有锚。
	lcSquareAnchor     = 0x11, 	// 方锚头帽
	lcRoundAnchor      = 0x12, 	// 圆锚头帽。
	lcDiamondAnchor    = 0x13, 	// 菱形锚头帽。
	lcArrowAnchor      = 0x14, 	// 箭头状锚头帽
	lcCustom           = 0xff, 	// 自定义线帽。
	lcAnchorMask       = 0xf0  	// 用于检查线帽是否为锚头帽的掩码。
};

//--------------------------------------------------------------------------
// Custom Line cap type constants
//--------------------------------------------------------------------------

enum TCustomLineCapType {ltDefault, ltAdjustableArrow};

//--------------------------------------------------------------------------
// Line join constants
//--------------------------------------------------------------------------

enum TLineJoin
{
	ljMiter, 		// 斜联接。这将产生一个锐角或切除角
	ljBevel, 		// 成斜角的联接。这将产生一个斜角。
	ljRound, 		// 圆形联接。这将在两条线之间产生平滑的圆弧。
	ljMiterClipped  // 斜联接。这将产生一个锐角或斜角，
};

class TGpCustomLineCap : public TGdiplusBase
{
private:
	friend	class TGpPen;

protected:
	__fastcall TGpCustomLineCap(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun){}
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpCustomLineCap));
	}
#endif
	__fastcall TGpCustomLineCap(void){}
private:
	TLineCap __fastcall GetBaseCap(void);
	void __fastcall SetBaseCap(TLineCap baseCap);
	float __fastcall GetBaseInset(void);
	void __fastcall SetBaseInset(float inset);
	TLineJoin __fastcall GetStrokeJoin(void);
	void __fastcall SetStrokeJoin(TLineJoin lineJoin);
	float __fastcall GetWidthScale(void);
	void __fastcall SetWidthScale(float widthScale);
	
public:
    // 通过指定的轮廓、填充和嵌入从指定的现有 LineCap 枚举初始化 CustomLineCap 类的新实例。
    // fillPath: 自定义线帽填充内容的对象；strokePath: 自定义线帽轮廓的对象。
	// baseCap: 将从其创建自定义线帽的线帽。baseInset: 线帽和直线之间的距离。
	__fastcall TGpCustomLineCap(TGpGraphicsPath* fillPath,
			TGpGraphicsPath* strokePath, TLineCap baseCap = lcFlat, float baseInset = 0.0);
	__fastcall virtual ~TGpCustomLineCap(void);
	TGpCustomLineCap* __fastcall Clone(void);
	// 设置用于构成此自定义线帽的起始直线和结束直线相同的线帽。
	void __fastcall SetStrokeCap(TLineCap strokeCap);
	// 获取用于构成此自定义线帽的起始直线和结束直线的线帽。
	void __fastcall GetStrokeCaps(TLineCap &startCap, TLineCap &endCap);
	// 设置用于构成此自定义线帽的起始直线和结束直线的线帽。
	void __fastcall SetStrokeCaps(TLineCap startCap, TLineCap endCap);
	// 获取或设置该 CustomLineCap 所基于的 LineCap 枚举。
	__property TLineCap BaseCap = {read=GetBaseCap, write=SetBaseCap};
	// 获取或设置线帽和直线之间的距离。
	__property float BaseInset = {read=GetBaseInset, write=SetBaseInset};
	// 获取或设置 LineJoin 枚举，该枚举确定如何联接构成此 CustomLineCap 对象的直线。
	__property TLineJoin StrokeJoin = {read=GetStrokeJoin, write=SetStrokeJoin};
	// 获取或设置相对于 Pen 对象的宽度此 CustomLineCap 类对象的缩放量。
	__property float WidthScale = {read=GetWidthScale, write=SetWidthScale};

};

class TGpCachedBitmap : public TGdiplusBase
{
private:
	friend	class TGpGraphics;

protected:
	__fastcall TGpCachedBitmap(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun){}
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpCachedBitmap));
	}
#endif
public:
	__fastcall TGpCachedBitmap(TGpBitmap *bitmap, TGpGraphics *graphics);
	__fastcall virtual ~TGpCachedBitmap(void);

};

#endif  // !GDIPHEADERS.HPP
