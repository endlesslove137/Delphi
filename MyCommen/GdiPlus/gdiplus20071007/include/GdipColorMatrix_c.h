/**************************************************************************\
*
* Module Name:
*
*   GdipColorMatrix_c.h
*
* Abstract:
*
*  GDI+ Color Matrix object, used with Graphics.DrawImage
*
* 湖北省公安县统计局  毛泽发  2009.6
*
\**************************************************************************/

#ifndef __GDIPCOLORMATRIX_C_H
#define __GDIPCOLORMATRIX_C_H

//----------------------------------------------------------------------------
// Color matrix
//----------------------------------------------------------------------------

typedef struct 
{
    REAL m[5][5];
}ColorMatrix, *PColorMatrix;

//----------------------------------------------------------------------------
// Color Matrix flags
//----------------------------------------------------------------------------

typedef enum
{
    ColorMatrixFlagsDefault   = 0,
    ColorMatrixFlagsSkipGrays = 1,
    ColorMatrixFlagsAltGray   = 2
}ColorMatrixFlags;

//----------------------------------------------------------------------------
// Color Adjust Type
//----------------------------------------------------------------------------

typedef enum 
{
    ColorAdjustTypeDefault,
    ColorAdjustTypeBitmap,
    ColorAdjustTypeBrush,
    ColorAdjustTypePen,
    ColorAdjustTypeText,
    ColorAdjustTypeCount,
    ColorAdjustTypeAny      // Reserved
}ColorAdjustType;

//----------------------------------------------------------------------------
// Color Map
//----------------------------------------------------------------------------

typedef struct 
{
    ARGB oldColor;
    ARGB newColor;
}ColorMap, *PColorMap;


#endif
