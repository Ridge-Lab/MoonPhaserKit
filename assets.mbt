///|
/// Image asset loaded by Phaser's loader.
pub(all) struct TextureAsset {
  key : String
  path : String
} derive(Eq, @debug.Debug)

///|
pub fn TextureAsset::new(key : String, path : String) -> TextureAsset {
  { key, path }
}

///|
pub fn TextureAsset::from_image(asset : ImageAsset) -> TextureAsset {
  { key: asset.key, path: asset.path }
}

///|
pub fn TextureAsset::is_valid(self : TextureAsset) -> Bool {
  self.key.length() > 0 && self.path.length() > 0
}

///|
/// Sprite-sheet asset descriptor for frame based animation.
pub(all) struct SpriteSheetAsset {
  key : String
  path : String
  frame_width : Int
  frame_height : Int
  margin : Int
  spacing : Int
} derive(Eq, @debug.Debug)

///|
pub fn SpriteSheetAsset::new(
  key : String,
  path : String,
  frame_width : Int,
  frame_height : Int,
  margin? : Int = 0,
  spacing? : Int = 0,
) -> SpriteSheetAsset {
  { key, path, frame_width, frame_height, margin, spacing }
}

///|
pub fn SpriteSheetAsset::is_valid(self : SpriteSheetAsset) -> Bool {
  self.key.length() > 0 &&
  self.path.length() > 0 &&
  self.frame_width > 0 &&
  self.frame_height > 0 &&
  self.margin >= 0 &&
  self.spacing >= 0
}

///|
pub fn SpriteSheetAsset::frame_size(self : SpriteSheetAsset) -> Size2 {
  { width: self.frame_width, height: self.frame_height }
}

///|
/// Atlas asset descriptor for packed sprite frames.
pub(all) struct TextureAtlasAsset {
  key : String
  texture_path : String
  atlas_path : String
} derive(Eq, @debug.Debug)

///|
pub fn TextureAtlasAsset::new(
  key : String,
  texture_path : String,
  atlas_path : String,
) -> TextureAtlasAsset {
  { key, texture_path, atlas_path }
}

///|
pub fn TextureAtlasAsset::is_valid(self : TextureAtlasAsset) -> Bool {
  self.key.length() > 0 &&
  self.texture_path.length() > 0 &&
  self.atlas_path.length() > 0
}

///|
/// Audio file descriptor. The path can point to mp3, ogg, wav, or browser-supported audio.
pub(all) struct AudioAsset {
  key : String
  path : String
} derive(Eq, @debug.Debug)

///|
pub fn AudioAsset::new(key : String, path : String) -> AudioAsset {
  { key, path }
}

///|
pub fn AudioAsset::is_valid(self : AudioAsset) -> Bool {
  self.key.length() > 0 && self.path.length() > 0
}

///|
/// JSON tilemap descriptor loaded through `Scene::load_tilemap_json`.
pub(all) struct TilemapJsonAsset {
  key : String
  path : String
} derive(Eq, @debug.Debug)

///|
pub fn TilemapJsonAsset::new(key : String, path : String) -> TilemapJsonAsset {
  { key, path }
}

///|
pub fn TilemapJsonAsset::is_valid(self : TilemapJsonAsset) -> Bool {
  self.key.length() > 0 && self.path.length() > 0
}

///|
/// Bitmap font descriptor for score panels and pixel-art UI.
pub(all) struct BitmapFontAsset {
  key : String
  texture_path : String
  data_path : String
} derive(Eq, @debug.Debug)

///|
pub fn BitmapFontAsset::new(
  key : String,
  texture_path : String,
  data_path : String,
) -> BitmapFontAsset {
  { key, texture_path, data_path }
}

///|
pub fn BitmapFontAsset::is_valid(self : BitmapFontAsset) -> Bool {
  self.key.length() > 0 &&
  self.texture_path.length() > 0 &&
  self.data_path.length() > 0
}

///|
/// A logical asset group used by docs and larger examples.
pub(all) struct AssetGroup {
  name : String
  base_path : String
} derive(Eq, @debug.Debug)

///|
pub fn AssetGroup::new(name : String, base_path : String) -> AssetGroup {
  { name, base_path }
}

///|
pub fn AssetGroup::is_valid(self : AssetGroup) -> Bool {
  self.name.length() > 0 && self.base_path.length() > 0
}

///|
pub fn AssetGroup::resolve(self : AssetGroup, file_name : String) -> String {
  if self.base_path.length() == 0 {
    file_name
  } else {
    "\{self.base_path}/\{file_name}"
  }
}

///|
pub(all) enum AssetKind {
  AssetImage
  AssetSpriteSheet
  AssetAtlas
  AssetAudio
  AssetTilemapJson
  AssetBitmapFont
} derive(Eq, @debug.Debug)

///|
pub fn AssetKind::label(self : AssetKind) -> String {
  match self {
    AssetImage => "image"
    AssetSpriteSheet => "spritesheet"
    AssetAtlas => "atlas"
    AssetAudio => "audio"
    AssetTilemapJson => "tilemap-json"
    AssetBitmapFont => "bitmap-font"
  }
}

///|
/// Lightweight manifest entry used in tests, docs, and future asset preloaders.
pub(all) struct AssetManifestEntry {
  kind : AssetKind
  key : String
  primary_path : String
  secondary_path : String
} derive(Eq, @debug.Debug)

///|
pub fn AssetManifestEntry::new(
  kind : AssetKind,
  key : String,
  primary_path : String,
  secondary_path? : String = "",
) -> AssetManifestEntry {
  { kind, key, primary_path, secondary_path }
}

///|
pub fn AssetManifestEntry::is_valid(self : AssetManifestEntry) -> Bool {
  self.key.length() > 0 && self.primary_path.length() > 0
}

///|
pub fn AssetManifestEntry::requires_secondary_path(self : AssetManifestEntry) -> Bool {
  match self.kind {
    AssetAtlas => true
    AssetBitmapFont => true
    _ => false
  }
}

///|
pub fn AssetManifestEntry::secondary_path_is_valid(self : AssetManifestEntry) -> Bool {
  if self.requires_secondary_path() {
    self.secondary_path.length() > 0
  } else {
    true
  }
}

///|
pub fn AssetManifestEntry::is_complete(self : AssetManifestEntry) -> Bool {
  self.is_valid() && self.secondary_path_is_valid()
}

