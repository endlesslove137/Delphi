#ifndef __GDIPIMGUTILS_H
#define __GDIPIMGUTILS_H

#include <windows.h>
#ifdef __cplusplus
#include <algorithm>
using std::min;
using std::max;
#include <gdiplus.h>
using namespace Gdiplus;
#else
#include "Gdiplus_c.h"
#endif
#include "ImageUtils.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus

// 获取Bitmap图像数据结构，必须用FreeImageData释放返回值
BOOL GetGpBitmapData(const Bitmap *bitmap, PImageData data);
// 锁定Bitmap并返回图像数据结构，直接操作Bitmap扫描线
BOOL GpBitmapLockData(const Bitmap *bitmap, PImageData data);
// 对锁定Bitmap的图像数据结构Data解锁
void GpBitmapUnlockData(const Bitmap *bitmap, PImageData data);

#else

// 获取Bitmap图像数据结构，必须用FreeImageData释放返回值
BOOL GetGpBitmapData(const PGpBitmap bitmap, PImageData data);
// 锁定Bitmap并返回图像数据结构，直接操作Bitmap扫描线
BOOL GpBitmapLockData(const PGpBitmap bitmap, PImageData data);
// 对锁定Bitmap的图像数据结构Data解锁
void GpBitmapUnlockData(const PGpBitmap bitmap, PImageData data);

#endif

#ifdef __cplusplus
}   // extern "C"
#endif

#endif

