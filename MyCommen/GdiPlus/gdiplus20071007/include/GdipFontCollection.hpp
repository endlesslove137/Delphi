/**************************************************************************\
*
* Module Name:
*
*   GdipFontCollection.hpp
*
* 2007年，湖北省公安县统计局 毛泽发 于大连
*
\**************************************************************************/

#ifndef GdipFontCollectionHPP
#define GdipFontCollectionHPP

inline
int __fastcall TGpFontCollection::GetFamilyCount(void)
{
	CheckStatus(GdipGetFontCollectionFamilyCount(Native, &Result.rINT));
	return Result.rINT;
}
inline
int __fastcall TGpFontCollection::GetFamilies(TGpFontFamily **gpfamilies, const int gpfamilies_Size)
{
	int numSought = GetFamilyCount();
	if (numSought <= 0 || gpfamilies == NULL || gpfamilies_Size <= 0)
		CheckStatus(InvalidParameter);
	GpFontFamily **nativeFamilyList = new GpFontFamily*[numSought];
	try
	{
		CheckStatus(GdipGetFontCollectionFamilyList(Native,
					numSought, nativeFamilyList, &Result.rINT));
		for (int i = 0; i < Result.rINT; i ++)
			GdipCloneFontFamily(nativeFamilyList[i], &gpfamilies[i]->Native);
	}
	__finally
	{
		delete[] nativeFamilyList;
	}
	return Result.rINT;
}

inline
__fastcall TGpInstalledFontCollection::TGpInstalledFontCollection(void)
{
	CheckStatus(GdipNewInstalledFontCollection(&Native));
}

inline
__fastcall TGpPrivateFontCollection::TGpPrivateFontCollection(void)
{
	CheckStatus(GdipNewPrivateFontCollection(&Native));
}
inline
__fastcall TGpPrivateFontCollection::~TGpPrivateFontCollection(void)
{
	GdipDeletePrivateFontCollection(&Native);
}
inline
void __fastcall TGpPrivateFontCollection::AddFontFile(const WideString filename)
{
	CheckStatus(GdipPrivateAddFontFile(Native, filename.c_bstr()));
}
inline
void __fastcall TGpPrivateFontCollection::AddMemoryFont(const void *memory, int length)
{
	CheckStatus(GdipPrivateAddMemoryFont(Native, memory, length));
}

#endif // _GDIPLUSFONTCOLL_H

