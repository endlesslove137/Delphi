/**************************************************************************
*
* Module Name:
*
*   GdipInit_c.h
*
* Abstract:
*
*   GDI+ Startup and Shutdown and Memory Management APIs
*
* 湖北省公安县统计局  毛泽发  2009.6
*
**************************************************************************/

#ifndef __GDIPINIT_C_H
#define __GDIPINIT_C_H

#define WINGDIPAPI __stdcall

//----------------------------------------------------------------------------
// Memory Allocation APIs
//----------------------------------------------------------------------------

void* WINGDIPAPI
GdipAlloc(size_t size);

void WINGDIPAPI
GdipFree(void* ptr);

typedef enum 
{
    DebugEventLevelFatal,
    DebugEventLevelWarning
}DebugEventLevel;

// Callback function that GDI+ can call, on debug builds, for assertions
// and warnings.

typedef VOID (WINAPI *DebugEventProc)(DebugEventLevel level, CHAR *message);

// Notification functions which the user must call appropriately if
// "SuppressBackgroundThread" (below) is set.

typedef Status (WINAPI *NotificationHookProc)(OUT ULONG_PTR *token);
typedef VOID (WINAPI *NotificationUnhookProc)(ULONG_PTR token);

// Input structure for GdiplusStartup()

typedef struct
{
    UINT32 GdiplusVersion;             // Must be 1
    DebugEventProc DebugEventCallback; // Ignored on free builds
    BOOL SuppressBackgroundThread;     // FALSE unless you're prepared to call
                                       // the hook/unhook functions properly
    BOOL SuppressExternalCodecs;       // FALSE unless you want GDI+ only to use
									   // its internal image codecs.
}GdiplusStartupInput;

// Output structure for GdiplusStartup()

typedef struct
{
    // The following 2 fields are NULL if SuppressBackgroundThread is FALSE.
    // Otherwise, they are functions which must be called appropriately to
    // replace the background thread.
    //
    // These should be called on the application's main message loop - i.e.
    // a message loop which is active for the lifetime of GDI+.
    // "NotificationHook" should be called before starting the loop,
    // and "NotificationUnhook" should be called after the loop ends.

    NotificationHookProc NotificationHook;
    NotificationUnhookProc NotificationUnhook;
}GdiplusStartupOutput;

// GDI+ initialization. Must not be called from DllMain - can cause deadlock.
//
// Must be called before GDI+ API's or constructors are used.
//
// token  - may not be NULL - accepts a token to be passed in the corresponding
//          GdiplusShutdown call.
// input  - may not be NULL
// output - may be NULL only if input->SuppressBackgroundThread is FALSE.

FORCEINLINE
GdiplusStartupInput MakeGdiplusStartupInput(
	DebugEventProc debugEventCallback,
	BOOL suppressBackgroundThread,
	BOOL suppressExternalCodecs)
{
	GdiplusStartupInput input;
	input.GdiplusVersion = 1;
	input.DebugEventCallback = debugEventCallback;
	input.SuppressBackgroundThread = suppressBackgroundThread;
	input.SuppressExternalCodecs = suppressExternalCodecs;
	return input;
}

Status WINAPI GdiplusStartup(
	ULONG_PTR *token,
	const GdiplusStartupInput *input,
	GdiplusStartupOutput *output);

// GDI+ termination. Must be called before GDI+ is unloaded.
// Must not be called from DllMain - can cause deadlock.
//
// GDI+ API's may not be called after GdiplusShutdown. Pay careful attention
// to GDI+ object destructors.

VOID WINAPI GdiplusShutdown(ULONG_PTR token);


static ULONG_PTR	_Gdiplus_Token;
static PathData		_Gdiplus_PathData;

FORCEINLINE
static void FreePathData(VOID)
{
	if (_Gdiplus_PathData.Count > 0)
	{
		GdipFree(_Gdiplus_PathData.Points);
		GdipFree(_Gdiplus_PathData.Types);
	}
	_Gdiplus_PathData.Count = 0;
}

FORCEINLINE
PathData* AllocPathData(INT count)
{
	if (count <= 0 || (_Gdiplus_PathData.Count > 0 && _Gdiplus_PathData.Count < count))
	{
		FreePathData();
		if (count <= 0)
			return &_Gdiplus_PathData;
	}
	if ((_Gdiplus_PathData.Points = (PointF*)GdipAlloc(count * sizeof(PointF))) == NULL)
		return NULL;
	if ((_Gdiplus_PathData.Types = (BYTE*)GdipAlloc(count * sizeof(BYTE)))== NULL)
	{
		GdipFree(_Gdiplus_PathData.Points);
		return NULL;
	}
	_Gdiplus_PathData.Count = count;
	return &_Gdiplus_PathData;
}

FORCEINLINE
Status Gdiplus_Startup(void)
{
	GdiplusStartupInput input;
	_Gdiplus_PathData.Count = 0;
	input = MakeGdiplusStartupInput(NULL, FALSE, FALSE);
	return GdiplusStartup(&_Gdiplus_Token, &input, NULL);
}

FORCEINLINE
void Gdiplus_Shutdown(void)
{
	FreePathData();
	GdiplusShutdown(_Gdiplus_Token);
}

#endif
