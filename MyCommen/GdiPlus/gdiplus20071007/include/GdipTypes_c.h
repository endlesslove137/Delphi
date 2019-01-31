/**************************************************************************\
*
* Module Name:
*
*   GdipTypes_c.h
*
* Abstract:
*
*   GDI+ Types
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPTYPES_C_H
#define __GDIPTYPES_C_H

//--------------------------------------------------------------------------
// Callback functions
//--------------------------------------------------------------------------

typedef BOOL (CALLBACK * ImageAbort)(VOID *);
typedef ImageAbort DrawImageAbort;
typedef ImageAbort GetThumbnailImageAbort;

// Callback for EnumerateMetafile methods.  The parameters are:

//      recordType      WMF, EMF, or EMF+ record type
//      flags           (always 0 for WMF/EMF records)
//      dataSize        size of the record data (in bytes), or 0 if no data
//      data            pointer to the record data, or NULL if no data
//      callbackData    pointer to callbackData, if any

// This method can then call Metafile::PlayRecord to play the
// record that was just enumerated.  If this method  returns
// FALSE, the enumeration process is aborted.  Otherwise, it continues.

typedef BOOL (CALLBACK * EnumerateMetafileProc)(EmfPlusRecordType,UINT,UINT,const BYTE*,VOID*);

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

typedef float REAL, *PREAL;

#define REAL_MAX            FLT_MAX
#define REAL_MIN            FLT_MIN
#define REAL_TOLERANCE     (FLT_MIN * 100)
#define REAL_EPSILON        1.192092896e-07F        /* FLT_EPSILON */

#define MAX(a, b)   (a > b? a : b)
#define MIN(a, b)   (a < b? a : b)

//--------------------------------------------------------------------------
// Status return values from GDI+ methods
//--------------------------------------------------------------------------

typedef enum 
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
}Status;

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

typedef struct
{
    REAL Width;
    REAL Height;
}SizeF;

FORCEINLINE
SizeF MakeSizeF(const REAL width, const REAL height)
{
    SizeF sz;
    sz.Width = width;
    sz.Height = height;
    return sz;
}

FORCEINLINE
BOOL SizeEmptyF(const SizeF *sz)
{
    return ((sz->Width == 0.0) && (sz->Height == 0.0));
}

FORCEINLINE
BOOL SizeEqualsF(const SizeF *sz1, const SizeF *sz2)
{
    return ((sz1->Width == sz2->Width) && (sz1->Height == sz2->Height));
}

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

typedef struct
{
    INT Width;
    INT Height;
}Size;

FORCEINLINE
Size MakeSize(const INT width, const INT height)
{
    Size sz;
    sz.Width = width;
    sz.Height = height;
    return sz;
}

FORCEINLINE
BOOL SizeEmpty(const Size *sz)
{
    return ((sz->Width == 0) && (sz->Height == 0));
}

FORCEINLINE
BOOL SizeEquals(const Size *sz1, const Size *sz2)
{
    return ((sz1->Width == sz2->Width) && (sz1->Height == sz2->Height));
}

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

typedef struct
{
    REAL X;
    REAL Y;
}PointF;

FORCEINLINE
PointF MakePointF(const REAL x, const REAL y)
{
    PointF pt;
    pt.X = x;
    pt.Y = y;
    return pt;
}

FORCEINLINE
BOOL PointEqualsF(const PointF *pt1, const PointF *pt2)
{
    return ((pt1->X == pt2->X) && (pt1->Y == pt2->Y));
}

FORCEINLINE
void PointFOffsetF(PointF *point, const REAL dx, const REAL dy)
{
    point->X += dx;
    point->Y += dy;
}

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

typedef struct
{
    INT X;
    INT Y;
}Point;

FORCEINLINE
Point MakePoint(const INT x, const INT y)
{
    Point pt;
    pt.X = x;
    pt.Y = y;
    return pt;
}

FORCEINLINE
BOOL PointEquals(const Point *pt1, const Point *pt2)
{
    return ((pt1->X == pt2->X) && (pt1->Y == pt2->Y));
}

FORCEINLINE
void PointOffset(Point *point, const INT dx, const INT dy)
{
    point->X += dx;
    point->Y += dy;
}

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

typedef struct
{
	union
	{
		struct
		{
			REAL X;
			REAL Y;
			REAL Width;
			REAL Height;
		};
		struct
		{
			PointF point;
			SizeF size;
		};
	};
}RectF;

FORCEINLINE
RectF MakeRectF(const REAL x, const REAL y, const REAL width, const REAL height)
{
    RectF rect;
    rect.X = x;
    rect.Y = y;
    rect.Width = width;
    rect.Height = height;
    return rect;
}

FORCEINLINE
BOOL RectContainsF(const RectF *rect, const REAL x, REAL y)
{
    return ((x >= rect->X) && (x < rect->X + rect->Width) &&
            (y >= rect->Y) && (y < rect->Y + rect->Height));
}

FORCEINLINE
BOOL RectContainsPointF(const RectF *rect, const PointF *point)
{
	return RectContainsF(rect, point->X, point->Y);
}

FORCEINLINE
BOOL RectContainsRectF(const RectF *rect1, const RectF *rect2)
{
    return ((rect1->X <= rect2->X) &&
            (rect1->Y <= rect2->Y) &&
            (rect1->X + rect1->Width >= rect2->X + rect2->Width) &&
            (rect1->Y + rect1->Height >= rect2->Y + rect2->Height));
}

FORCEINLINE
BOOL RectEqualsF(const RectF *rect1, const RectF *rect2)
{
    return ((rect1->X == rect2->X) &&
            (rect1->Y == rect2->Y) &&
            (rect1->Width == rect2->Width) &&
            (rect1->Height == rect2->Height));
}

FORCEINLINE
void RectInflateF(RectF *rect, const REAL dx, const REAL dy)
{
    rect->X -= dx;
    rect->Y -= dy;
    rect->Width += (dx * 2);
	rect->Height += (dy * 2);
}

FORCEINLINE
BOOL RectIsEmptyAreaF(const RectF *rect)
{
    return ((rect->Width <= REAL_EPSILON) || (rect->Height <= REAL_EPSILON));
}

FORCEINLINE
BOOL RectIntersectF(RectF *dest, const RectF *rect1, const RectF *rect2)
{
	dest->X = MAX(rect1->X, rect2->X);
    dest->Y = MAX(rect1->Y, rect2->Y);
    dest->Width = MIN(rect1->X + rect1->Width, rect2->X + rect2->Width) - dest->X;
    dest->Height = MIN(rect1->Y + rect1->Height, rect2->Y + rect2->Height) - dest->Y;
	return !RectIsEmptyAreaF(dest);
}

FORCEINLINE
BOOL RectIntersectsWithF(const RectF *rect1, const RectF *rect2)
{
    return ((rect1->X < rect2->X + rect2->Width) &&
            (rect1->Y < rect2->Y + rect2->Height) &&
            (rect1->X + rect1->Width > rect2->X) &&
            (rect1->Y + rect1->Height > rect2->Y));
}

FORCEINLINE
void RectOffsetF(RectF *rect, const REAL dx, const REAL dy)
{
    rect->X += dx;
    rect->Y += dy;
}

FORCEINLINE
BOOL RectUnionF(RectF *dest, const RectF *rect1, const RectF *rect2)
{
    dest->X = MIN(rect1->X, rect2->X);
    dest->Y = MIN(rect1->Y, rect2->Y);
    dest->Width = MAX(rect1->X + rect1->Width, rect2->X + rect2->Width) - dest->X;
    dest->Height = MAX(rect1->Y + rect1->Height, rect2->Y + rect2->Height) - dest->Y;
	return !RectIsEmptyAreaF(dest);
}

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

typedef struct
{
	union
	{
		struct
		{
			INT X;
			INT Y;
			INT Width;
			INT Height;
		};
		struct
		{
			Point point;
			Size size;
		};
	};
}Rect;

FORCEINLINE
Rect MakeRect(const INT x, const INT y, const INT width, const INT height)
{
    Rect rect;
    rect.X = x;
    rect.Y = y;
    rect.Width = width;
    rect.Height = height;
    return rect;
}

FORCEINLINE
BOOL RectContains(const Rect *rect, const INT x, INT y)
{
    return ((x >= rect->X) && (x < rect->X + rect->Width) &&
            (y >= rect->Y) && (y < rect->Y + rect->Height));
}

FORCEINLINE
BOOL RectContainsPoint(const Rect *rect, const Point *point)
{
    return RectContains(rect, point->X, point->Y);
}

FORCEINLINE
BOOL RectContainsRect(const Rect *rect1, const Rect *rect2)
{
    return ((rect1->X <= rect2->X) &&
            (rect1->Y <= rect2->Y) &&
            (rect1->X + rect1->Width >= rect2->X + rect2->Width) &&
            (rect1->Y + rect1->Height >= rect2->Y + rect2->Height));
}

FORCEINLINE
BOOL RectEquals(const Rect *rect1, const Rect *rect2)
{
    return ((rect1->X == rect2->X) &&
            (rect1->Y == rect2->Y) &&
            (rect1->Width == rect2->Width) &&
            (rect1->Height == rect2->Height));
}

FORCEINLINE
void RectInflate(Rect *rect, const INT dx, const INT dy)
{
    rect->X -= dx;
    rect->Y -= dy;
    rect->Width += (dx << 1);
    rect->Height += (dy << 1);
}

FORCEINLINE
BOOL RectIsEmptyArea(const Rect *rect)
{
	return ((rect->Width <= 0) || (rect->Height <= 0));
}

FORCEINLINE
BOOL RectIntersect(Rect *dest, const Rect *rect1, const Rect *rect2)
{
	dest->X = MAX(rect1->X, rect2->X);
	dest->Y = MAX(rect1->Y, rect2->Y);
	dest->Width = MIN(rect1->X + rect1->Width, rect2->X + rect2->Width) - dest->X;
	dest->Height = MIN(rect1->Y + rect1->Height, rect2->Y + rect2->Height) - dest->Y;
	return !RectIsEmptyArea(dest);
}

FORCEINLINE
BOOL RectIntersectsWith(const Rect *rect1, const Rect *rect2)
{
	return ((rect1->X < rect2->X + rect2->Width) &&
			(rect1->Y < rect2->Y + rect2->Height) &&
			(rect1->X + rect1->Width > rect2->X) &&
			(rect1->Y + rect1->Height > rect2->Y));
}

FORCEINLINE
void RectOffset(Rect *rect, const INT dx, const INT dy)
{
    rect->X += dx;
    rect->Y += dy;
}

FORCEINLINE
BOOL RectUnion(Rect *dest, const Rect *rect1, const Rect *rect2)
{
    dest->X = MIN(rect1->X, rect2->X);
    dest->Y = MIN(rect1->Y, rect2->Y);
    dest->Width = MAX(rect1->X + rect1->Width, rect2->X + rect2->Width) - dest->X;
    dest->Height = MAX(rect1->Y + rect1->Height, rect2->Y + rect2->Height) - dest->Y;
	return !RectIsEmptyArea(dest);
}

typedef struct
{
    INT Count;
    PointF* Points;
    BYTE* Types;
}PathData;

typedef struct
{
    INT First;
    INT Length;
}CharacterRange;

#endif // !_GDIPTYPES_C_H

