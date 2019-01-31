/**************************************************************************\
*
* Module Name:
*
*   GdipTypes.h       
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef BCGdipTypesHPP
#pragma option push -b -a8 -pc -A- /*P_O_Push*/
#define BCGdipTypesHPP

//--------------------------------------------------------------------------
// Callback functions
//--------------------------------------------------------------------------

extern "C" {
typedef BOOL (CALLBACK * ImageAbort)(VOID *);
typedef ImageAbort DrawImageAbort;
typedef ImageAbort GetThumbnailImageAbort;
}

// Callback for EnumerateMetafile methods.  The parameters are:

//      recordType      WMF, EMF, or EMF+ record type
//      flags           (always 0 for WMF/EMF records)
//      dataSize        size of the record data (in bytes), or 0 if no data
//      data            pointer to the record data, or NULL if no data
//      callbackData    pointer to callbackData, if any

// This method can then call Metafile::PlayRecord to play the
// record that was just enumerated.  If this method  returns
// FALSE, the enumeration process is aborted.  Otherwise, it continues.

extern "C" {
typedef BOOL (CALLBACK * EnumerateMetafileProc)(EmfPlusRecordType,UINT,UINT,const BYTE*,VOID*);
}

//--------------------------------------------------------------------------
// Primitive data types
//
// NOTE:
//  Types already defined in standard header files:
//      INT8
//      UINT8
//      INT16
//      UINT16
//      INT32
//      UINT32
//      INT64
//      UINT64
//
//  Avoid using the following types:
//      LONG - use INT
//      ULONG - use UINT
//      DWORD - use UINT32
//--------------------------------------------------------------------------

typedef float REAL;

#define REAL_MAX            FLT_MAX
#define REAL_MIN            FLT_MIN
#define REAL_TOLERANCE     (FLT_MIN * 100)
#define REAL_EPSILON        1.192092896e-07F        /* FLT_EPSILON */

//--------------------------------------------------------------------------
// Forward declarations of common classes
//--------------------------------------------------------------------------

class Size;
class SizeF;
class Point;
class PointF;
class Rect;
class RectF;
class CharacterRange;

//--------------------------------------------------------------------------
// Status return values from GDI+ methods
//--------------------------------------------------------------------------

enum Status
{
    Ok = 0,
    GenericError = 1,
    InvalidParameter = 2,
    OutOfMemory = 3,
    ObjectBusy = 4,
    InsufficientBuffer = 5,
    NotImplemented = 6,
    Win32Error = 7,
    WrongState = 8,
    Aborted = 9,
    FileNotFound = 10,
    ValueOverflow = 11,
    AccessDenied = 12,
    UnknownImageFormat = 13,
    FontFamilyNotFound = 14,
    FontStyleNotFound = 15,
    NotTrueTypeFont = 16,
    UnsupportedGdiplusVersion = 17,
    GdiplusNotInitialized = 18,
    PropertyNotFound = 19,
    PropertyNotSupported = 20
};

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

class SizeF
{
public:
    float Width;
    float Height;
    SizeF(){ Width = Height = 0.0f; }
    SizeF(const SizeF &size){ *this = size; }
    SizeF(float width, float height)
    {
        Width = width;
        Height = height;
    }
    SizeF& operator = (const SizeF &sz)
    {
      Width = sz.Width;
      Height = sz.Height;
      return *this;
    }
    SizeF operator + (const SizeF &sz) const
    {
        return SizeF(Width + sz.Width, Height + sz.Height);
    }
    SizeF operator - (const SizeF &sz) const
    {
        return SizeF(Width - sz.Width, Height - sz.Height);
    }
    bool operator == (const SizeF &sz) const
    {
        return (Width == sz.Width) && (Height == sz.Height);
    }
    bool operator != (const SizeF &sz) const
    {
        return !(*this == sz);
    }
    bool Empty() const
    {
        return (Width == 0.0f && Height == 0.0f);
    }
};

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

class Size
{
public:
    int Width;
    int Height;
    Size(){ Width = Height = 0; }
    Size(const Size &size){ *this = size; }
    Size(int width, int height)
    {
        Width = width;
        Height = height;
	}
	Size(const SIZE &size){ *this = size; }
    Size& operator = (const Size &sz)
    {
      Width = sz.Width;
      Height = sz.Height;
      return *this;
	}
	Size& operator = (const SIZE &sz)
	{
		Width = sz.cx;
		Height = sz.cy;
		return *this;
	}
    Size operator + (const Size &sz) const
    {
        return Size(Width + sz.Width, Height + sz.Height);
    }
    Size operator - (const Size &sz) const
    {
        return Size(Width - sz.Width, Height - sz.Height);
    }
    bool operator == (const Size &sz) const
    {
        return (Width == sz.Width) && (Height == sz.Height);
    }
    bool operator != (const Size &sz) const
    {
        return !(*this == sz);
    }
    bool Empty() const
    {
        return (Width == 0 && Height == 0);
    }
};

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

class PointF
{
public:
    float X;
    float Y;
    PointF(){ X = Y = 0.0f; }
    PointF(const PointF &point){ *this = point; }
    PointF(const SizeF &size){ *this = size; }
    PointF(float x, float y){ X = x; Y = y; }
    PointF& operator = (const PointF &pt)
    {
        X = pt.X; Y = pt.Y;
        return *this;
    }
    PointF& operator = (const SizeF &sz)
    {
        X = sz.Width; Y = sz.Height;
        return *this;
    }
    PointF operator + (const PointF& point) const
    {
        return PointF(X + point.X, Y + point.Y);
    }
    PointF operator - (const PointF& point) const
    {
        return PointF(X - point.X, Y - point.Y);
    }
    bool operator == (const PointF& point) const
    {
        return (X == point.X) && (Y == point.Y);
    }
    bool operator != (const PointF& point) const
    {
        return !(*this == point);
    }
};

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

class Point
{
public:
    int X;
    int Y;
    Point(){ X = Y = 0; }
    Point(const Point &point){ *this = point; }
    Point(const Size &size){ *this = size; }
    Point(int x, int y){ X = x; Y = y; }
    Point(POINT& pt){ *this = pt; }
    Point& operator = (const Point &point)
    {
        X = point.X;
        Y = point.Y;
        return *this;
    }
    Point& operator = (const Size &size)
    {
         X = size.Width;
         Y = size.Height;
         return *this;
    }
    Point& operator = (const POINT &point)
    {
      X = point.x;
      Y = point.y;
      return *this;
    }
    Point operator + (const Point& point) const
    {
        return Point(X + point.X, Y + point.Y);
    }
    Point operator - (const Point& point) const
    {
        return Point(X - point.X, Y - point.Y);
    }
    bool operator == (const Point& point) const
    {
        return (X == point.X) && (Y == point.Y);
    }
    bool operator != (const Point& point) const
    {
        return !(*this == point);
    }
};

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

class RectF
{
public:
    float X;
    float Y;
    float Width;
    float Height;
    RectF(){ X = Y = Width = Height = 0.0f; }
    RectF(float x, float y, float width, float height)
    {
        X = x;
        Y = y;
        Width = width;
        Height = height;
    }
    RectF(const PointF& location, const SizeF& size)
    {
        X = location.X;
        Y = location.Y;
        Width = size.Width;
        Height = size.Height;
    }
    RectF(const RectF& rect){ *this = rect; }
private:
    PointF GetLocation(){ return PointF(X, Y); }
    void SetLocation(const PointF& pt){ X = pt.X; Y = pt.Y; }
    SizeF GetSize(){ return SizeF(Width, Height); }
    void SetSize(const SizeF& sz){ Width = sz.Width; Height = sz.Height; }
    float GetRight() const { return X + Width; }
    void SetRight(const float r){ Width = r - X; }
    float GetBottom() const { return Y + Height; }
    void SetBottom(const float b){ Height = b - Y; }
public:
    bool IsEmptyArea() const
    {
        return (Width <= REAL_EPSILON) || (Height <= REAL_EPSILON);
    }
    RectF& operator = (const RectF &rect)
    {
        X = rect.X;
        Y = rect.Y;
        Width = rect.Width;
        Height = rect.Height;
        return *this;
    }
    bool operator == (const RectF &rect) const
    {
        return X == rect.X && Y == rect.Y && Width == rect.Width && Height == rect.Height;
    }
    bool operator != (const RectF &rect)
    {
        return !(*this == rect);
    }
    bool Contains(float x, float y) const
    {
        return x >= Left && x < Right && y >= Top && y < Bottom;
    }
    bool Contains(const PointF& pt) const
    {
        return Contains(pt.X, pt.Y);
    }
    bool Contains(const RectF& rect) const
    {
        return (Left <= rect.Left) && (rect.Right <= Right) &&
               (Top <= rect.Top) && (rect.Bottom <= Bottom);
    }
    void Inflate(float dx, float dy)
    {
        X -= dx;
        Y -= dy;
        Width += 2 * dx;
        Height += 2 * dy;
    }
    void Inflate(const PointF& point){ Inflate(point.X, point.Y); }
    bool Intersect(const RectF& rect)
    {
		Width = Right > rect.Right? rect.Right : Right;
		Height = Bottom > rect.Bottom? rect.Bottom : Bottom;
		if (Left < rect.Left) Left = rect.Left;
		if (Top < rect.Top) Top = rect.Top;
		Width -= Left;
		Height -= Top;
		return !IsEmptyArea();
    }
    bool IntersectsWith(const RectF& rect) const
    {
        return (Left < rect.Right && Top < rect.Bottom &&
                Right > rect.Left && Bottom > rect.Top);
    }
	bool Union(const RectF& rect)
    {
		Width = Right < rect.Right? rect.Right : Right;
		Height = Bottom < rect.Bottom? rect.Bottom : Bottom;
		if (Left > rect.Left) Left = rect.Left;
		if (Top > rect.Top) Top = rect.Top;
		Width -= Left;
		Height -= Top;
		return !IsEmptyArea();
    }
    void Offset(const PointF& point){ Offset(point.X, point.Y); }
    void Offset(float dx, float dy){ X += dx; Y += dy; }

    __property PointF Location = { read = GetLocation, write = SetLocation };
	__property SizeF Size = { read = GetSize, write = SetSize };
    __property float Left = { read = X, write = X };
    __property float Top = { read = Y, write = Y };
    __property float Right = { read = GetRight, write = SetRight };
    __property float Bottom = { read = GetBottom, write = SetBottom };
};

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

class Rect
{
public:
    int X;
    int Y;
    int Width;
    int Height;
    Rect(){ X = Y = Width = Height = 0; }
    Rect(int x, int y, int width, int height)
    {
        X = x;
        Y = y;
        Width = width;
        Height = height;
    }
    Rect(const Point& location, const Size& size)
    {
        X = location.X;
        Y = location.Y;
        Width = size.Width;
        Height = size.Height;
    }
    Rect(const Rect& rect){ *this = rect; }
    Rect(const RECT& rect){ *this = rect; }
private:
    Point GetLocation(){ return Point(X, Y); }
	void SetLocation(const Point& pt){ X = pt.X; Y = pt.Y; }
	Size GetSize(){ return GdiplusSys::Size(Width, Height); }
    void SetSize(const Size& sz){ Width = sz.Width; Height = sz.Height; }
	int GetRight() const { return X + Width; }
    void SetRight(const int r){ Width = r - X; }
    int GetBottom() const { return Y + Height; }
    void SetBottom(const int b){ Height = b - Y; }
public:
    bool IsEmptyArea() const
    {
        return (Width <= 0) || (Height <= 0);
    }
    Rect& operator = (const Rect &rect)
    {
        X = rect.X;
        Y = rect.Y;
        Width = rect.Width;
        Height = rect.Height;
        return *this;
    }
    Rect& operator = (const RECT &rect)
    {
        Left = rect.left;
        Top = rect.top;
        Right = rect.right;
        Bottom = rect.bottom;
        return *this;
    }
    bool operator == (const Rect &rect) const
    {
        return X == rect.X && Y == rect.Y && Width == rect.Width && Height == rect.Height;
    }
    bool operator != (const Rect &rect)
    {
        return !(*this == rect);
    }
    bool Contains(int x, int y) const
    {
        return x >= Left && x < Right && y >= Top && y < Bottom;
    }
    bool Contains(const Point& pt) const
    {
        return Contains(pt.X, pt.Y);
    }
    bool Contains(const Rect& rect) const
    {
        return (Left <= rect.Left) && (rect.Right <= Right) &&
               (Top <= rect.Top) && (rect.Bottom <= Bottom);
    }
    void Inflate(int dx, int dy)
    {
        X -= dx;
        Y -= dy;
        Width += 2 * dx;
        Height += 2 * dy;
    }
    void Inflate(const Point& point){ Inflate(point.X, point.Y); }
    bool Intersect(const Rect& rect)
	{
		Width = Right > rect.Right? rect.Right : Right;
		Height = Bottom > rect.Bottom? rect.Bottom : Bottom;
		if (Left < rect.Left) Left = rect.Left;
		if (Top < rect.Top) Top = rect.Top;
		Width -= Left;
		Height -= Top;
		return !IsEmptyArea();
    }
    bool IntersectsWith(const Rect& rect) const
    {
        return (Left < rect.Right && Top < rect.Bottom &&
                Right > rect.Left && Bottom > rect.Top);
    }
	bool Union(const Rect& rect)
	{
		Width = Right < rect.Right? rect.Right : Right;
		Height = Bottom < rect.Bottom? rect.Bottom : Bottom;
		if (Left > rect.Left) Left = rect.Left;
		if (Top > rect.Top) Top = rect.Top;
		Width -= Left;
		Height -= Top;
		return !IsEmptyArea();
    }
    void Offset(const Point& point){ Offset(point.X, point.Y); }
    void Offset(int dx, int dy){ X += dx; Y += dy; }

	__property Point Location = { read = GetLocation, write = SetLocation };
	__property Size Size = { read = GetSize, write = SetSize };
    __property int Left = { read = X, write = X };
    __property int Top = { read = Y, write = Y };
    __property int Right = { read = GetRight, write = SetRight };
    __property int Bottom = { read = GetBottom, write = SetBottom };
};

class TGpGraphicsPath;

class PathData
{
	friend class TGpGraphicsPath;
private:
    int FCount;
    PointF *FPoints;
    BYTE *FTypes;
    PathData(const PathData &);
    PathData& operator=(const PathData &);
    void SetCount(const int count)
    {
        if (FCount != count)
        {
          Clear();
          if (count > 0)
          {
            FPoints = new PointF[count];
            FTypes = new BYTE[count];
            FCount = count;
          }
        }
    }
public:
    PathData(){ FCount = 0; }
	~PathData(){ Clear(); }
    void Clear()
    {
        if (FCount != 0)
        {
            delete[] Points;
            delete[] Types;
            FCount = 0;
        }
    }

    __property int Count = { read = FCount };
	__property PointF* Points = { read = FPoints };
    __property BYTE* Types = { read = FTypes };
};

class CharacterRange
{
public:
    CharacterRange(int first, int length) : First(first), Length(length){}
    CharacterRange() : First(0), Length(0){}
    CharacterRange& operator = (const CharacterRange &rhs)
    {
        First  = rhs.First;
        Length = rhs.Length;
        return *this;
    }

    int First;
    int Length;
};

#pragma option pop /*P_O_Pop*/
#endif // !BCGdipTypesHPP
