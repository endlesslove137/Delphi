/**************************************************************************
*
* Copyright (c) 2000 Microsoft Corporation
*
* Module Name:
*
*   GdipCachedBitmap_c.h
*
* Abstract:
*
*   GDI+ CachedBitmap is a representation of an accelerated drawing
*   that has restrictions on what operations are allowed in order
*   to accelerate the drawing to the destination.
*
* 湖北省公安县统计局  毛泽发  2009.6
*
**************************************************************************/

#ifndef __GDIPCACHEDBITMAP_C_H
#define __GDIPCACHEDBITMAP_C_H

FORCEINLINE
PGpCachedBitmap CachedBitmapCreate(PGpBitmap bitmap, PGpGraphics graphics)
{
    PGpCachedBitmap cbitmap;
	return GdipCreateCachedBitmap(bitmap, graphics, &cbitmap) == Ok? cbitmap : NULL;
}

FORCEINLINE
Status CachedBitmapDelete(PGpCachedBitmap bitmap)
{
	return GdipDeleteCachedBitmap(bitmap);
}

#endif


