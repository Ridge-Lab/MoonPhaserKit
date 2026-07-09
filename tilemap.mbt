///|
pub(all) enum TilemapOrientation {
  TilemapOrthogonal
  TilemapIsometric
  TilemapStaggered
  TilemapHexagonal
} derive(Eq, @debug.Debug)

///|
pub fn TilemapOrientation::label(self : TilemapOrientation) -> String {
  match self {
    TilemapOrthogonal => "orthogonal"
    TilemapIsometric => "isometric"
    TilemapStaggered => "staggered"
    TilemapHexagonal => "hexagonal"
  }
}

///|
pub(all) struct TilemapConfig {
  key : String
  tile_width : Int
  tile_height : Int
  width : Int
  height : Int
  orientation : TilemapOrientation
} derive(Eq, @debug.Debug)

///|
pub fn TilemapConfig::new(
  key : String,
  tile_width : Int,
  tile_height : Int,
  width? : Int = 0,
  height? : Int = 0,
  orientation? : TilemapOrientation = TilemapOrthogonal,
) -> TilemapConfig {
  { key, tile_width, tile_height, width, height, orientation }
}

///|
pub fn TilemapConfig::is_valid(self : TilemapConfig) -> Bool {
  self.key.length() > 0 &&
  self.tile_width > 0 &&
  self.tile_height > 0 &&
  self.width >= 0 &&
  self.height >= 0
}

///|
pub fn TilemapConfig::tile_size(self : TilemapConfig) -> Size2 {
  { width: self.tile_width, height: self.tile_height }
}

///|
pub(all) struct TilesetConfig {
  name : String
  texture_key : String
  tile_width : Int
  tile_height : Int
  margin : Int
  spacing : Int
} derive(Eq, @debug.Debug)

///|
pub fn TilesetConfig::new(
  name : String,
  texture_key : String,
  tile_width : Int,
  tile_height : Int,
  margin? : Int = 0,
  spacing? : Int = 0,
) -> TilesetConfig {
  { name, texture_key, tile_width, tile_height, margin, spacing }
}

///|
pub fn TilesetConfig::is_valid(self : TilesetConfig) -> Bool {
  self.name.length() > 0 &&
  self.texture_key.length() > 0 &&
  self.tile_width > 0 &&
  self.tile_height > 0 &&
  self.margin >= 0 &&
  self.spacing >= 0
}

///|
pub(all) struct TileLayerConfig {
  layer_name : String
  tileset_name : String
  x : Double
  y : Double
  visible : Bool
  alpha : Double
} derive(Eq, @debug.Debug)

///|
pub fn TileLayerConfig::new(
  layer_name : String,
  tileset_name : String,
  x? : Double = 0.0,
  y? : Double = 0.0,
  visible? : Bool = true,
  alpha? : Double = 1.0,
) -> TileLayerConfig {
  { layer_name, tileset_name, x, y, visible, alpha }
}

///|
pub fn TileLayerConfig::is_valid(self : TileLayerConfig) -> Bool {
  self.layer_name.length() > 0 &&
  self.tileset_name.length() > 0 &&
  self.alpha >= 0.0
}

///|
pub(all) struct TileCollisionRange {
  start_index : Int
  end_index : Int
  collides : Bool
} derive(Eq, @debug.Debug)

///|
pub fn TileCollisionRange::new(
  start_index : Int,
  end_index : Int,
  collides? : Bool = true,
) -> TileCollisionRange {
  { start_index, end_index, collides }
}

///|
pub fn TileCollisionRange::is_valid(self : TileCollisionRange) -> Bool {
  self.start_index >= 0 && self.end_index >= self.start_index
}

///|
pub(all) struct TilePropertyMatcher {
  property : String
  value : String
  collides : Bool
} derive(Eq, @debug.Debug)

///|
pub fn TilePropertyMatcher::new(
  property : String,
  value : String,
  collides? : Bool = true,
) -> TilePropertyMatcher {
  { property, value, collides }
}

///|
pub fn TilePropertyMatcher::is_valid(self : TilePropertyMatcher) -> Bool {
  self.property.length() > 0 && self.value.length() > 0
}

///|
pub(all) struct TileObject {
  name : String
  object_type : String
  position : Point2
  size : Size2
} derive(Eq, @debug.Debug)

///|
pub fn TileObject::new(
  name : String,
  object_type : String,
  position : Point2,
  size : Size2,
) -> TileObject {
  { name, object_type, position, size }
}

///|
pub fn TileObject::is_valid(self : TileObject) -> Bool {
  self.name.length() > 0 && self.size.is_valid()
}

///|
pub fn TileObject::bounds(self : TileObject) -> Rect {
  {
    x: self.position.x,
    y: self.position.y,
    width: self.size.width.to_double(),
    height: self.size.height.to_double(),
  }
}

///|
pub(all) struct TileSpawnPoint {
  name : String
  position : Point2
  facing : AnimationDirection
} derive(Eq, @debug.Debug)

///|
pub fn TileSpawnPoint::new(
  name : String,
  position : Point2,
  facing? : AnimationDirection = AnimForward,
) -> TileSpawnPoint {
  { name, position, facing }
}

///|
pub fn TileSpawnPoint::is_valid(self : TileSpawnPoint) -> Bool {
  self.name.length() > 0
}
