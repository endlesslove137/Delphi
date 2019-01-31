/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdipColorEnums.h
*
* Abstract:
*
*   GDI+ Color Enums
*
\**************************************************************************/

#ifndef GdipColorEnumsHPP
#pragma option push -b -a8 -pc -A- /*P_O_Push*/
#define GdipColorEnumsHPP

//----------------------------------------------------------------------------
// Color mode
//----------------------------------------------------------------------------

enum ColorMode
{
    ColorModeARGB32 = 0,
    ColorModeARGB64 = 1
};

//----------------------------------------------------------------------------
// Color Channel flags
//----------------------------------------------------------------------------

enum ColorChannelFlags
{
    ColorChannelFlagsC = 0,
    ColorChannelFlagsM,
    ColorChannelFlagsY,
    ColorChannelFlagsK,
    ColorChannelFlagsLast
};

#pragma option pop /*P_O_Pop*/
#endif

