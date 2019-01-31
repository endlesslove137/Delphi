unit wyTexture;

interface

uses
  Windows, SysUtils, Direct3D9, D3Dx9;

type
  TD3DTexture = class(TObject)
  private
    FWidth: Integer;
    FHeight: Integer;
    FImgWidth: Integer;
    FImgHeight: Integer;
    FTexture: IDirect3DTexture9;
    function getSingleU: Single;
    function getSingleV: Single;
  public
    constructor FromFile(Device: IDirect3DDevice9; AFileName: string);
    destructor Destroy();override;

    property Texture: IDirect3DTexture9 read FTexture write FTexture;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;     
    property ImgWidth: Integer read FImgWidth;
    property ImgHeight: Integer read FImgHeight;
    property SingleU: Single read getSingleU;
    property SingleV: Single read getSingleV;
  end;

implementation

{ TD3DTexture }

destructor TD3DTexture.Destroy;
begin
  FTexture := nil;
  inherited;
end;

constructor TD3DTexture.FromFile(Device: IDirect3DDevice9; AFileName: string);
var
  hr: HResult;
  desc: TD3DSurfaceDesc;
  info: TD3DXImageInfo;
begin
  hr := D3DXGetImageInfoFromFile(PChar(AFileName), info);
  if FAILED(hr) then
    Raise Exception.CreateFmt('获取纹理信息失败 0x%0.8X', [hr]);    
  FImgWidth := info.Width;
  FImgHeight := info.Height;

  hr := D3DXCreateTextureFromFileEx(Device, PChar(AFileName),
   D3DX_DEFAULT_NONPOW2, D3DX_DEFAULT_NONPOW2, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED,
    D3DX_FILTER_NONE, D3DX_FILTER_NONE, 0, @info, nil, FTexture);
  if FAILED(hr) then
    Raise Exception.CreateFmt('加载纹理失败 0x%0.8X', [hr]);
  hr := FTexture.GetLevelDesc(0, desc); 
  if FAILED(hr) then
  begin
    FTexture := nil;
    Raise Exception.CreateFmt('获取纹理信息失败 0x%0.8X', [hr]);
  end;
  FWidth := desc.Width;
  FHeight := desc.Height;
end;

function TD3DTexture.getSingleU: Single;
begin
  Result := FImgWidth / FWidth;
end;

function TD3DTexture.getSingleV: Single;
begin
  Result := FImgHeight / FHeight;
end;

end.
