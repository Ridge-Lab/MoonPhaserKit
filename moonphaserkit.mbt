///|
/// Phaser game configuration supported by MoonPhaserKit v1.
///
/// The binding intentionally keeps this small: it targets one common 2D web
/// game path, not every Phaser option.
pub(all) struct GameConfig {
  parent : String
  width : Int
  height : Int
  background : String
  gravity_y : Int
  debug : Bool
} derive(Eq, @debug.Debug)

///|
/// Creates a default 800x450 Arcade Physics game configuration.
pub fn GameConfig::new(
  parent? : String = "game",
  width? : Int = 800,
  height? : Int = 450,
  background? : String = "#16213e",
  gravity_y? : Int = 900,
  debug? : Bool = false,
) -> GameConfig {
  { parent, width, height, background, gravity_y, debug }
}

///|
/// Returns true when the configuration is suitable for a Phaser canvas.
pub fn GameConfig::is_valid(self : GameConfig) -> Bool {
  self.parent.length() > 0 &&
  self.width > 0 &&
  self.height > 0 &&
  self.background.length() > 0
}

///|
/// A small immutable sprite setup object used by examples and tests.
pub(all) struct SpriteOptions {
  scale : Double
  immovable : Bool
  collide_world_bounds : Bool
  bounce_x : Double
  bounce_y : Double
  gravity_y : Double
} derive(Eq, @debug.Debug)

///|
/// Creates reusable sprite physics options.
pub fn SpriteOptions::new(
  scale? : Double = 1.0,
  immovable? : Bool = false,
  collide_world_bounds? : Bool = false,
  bounce_x? : Double = 0.0,
  bounce_y? : Double = 0.0,
  gravity_y? : Double = 0.0,
) -> SpriteOptions {
  { scale, immovable, collide_world_bounds, bounce_x, bounce_y, gravity_y }
}

///|
/// Two-dimensional velocity used by sprite and body helpers.
pub(all) struct Velocity {
  x : Double
  y : Double
} derive(Eq, @debug.Debug)

///|
/// Creates a velocity vector.
pub fn Velocity::new(x : Double, y : Double) -> Velocity {
  { x, y }
}

///|
/// Named asset loaded through `Scene::load_image`.
pub(all) struct ImageAsset {
  key : String
  path : String
} derive(Eq, @debug.Debug)

///|
/// Creates an image asset descriptor.
pub fn ImageAsset::new(key : String, path : String) -> ImageAsset {
  { key, path }
}

///|
/// Returns true when the asset has a non-empty key and path.
pub fn ImageAsset::is_valid(self : ImageAsset) -> Bool {
  self.key.length() > 0 && self.path.length() > 0
}

///|
/// Cursor-key direction names used in docs and tests.
pub(all) enum CursorDirection {
  Left
  Right
  Up
  Down
} derive(Eq, @debug.Debug)

///|
/// Stable string name for a cursor direction.
pub fn CursorDirection::to_key_name(self : CursorDirection) -> String {
  match self {
    Left => "left"
    Right => "right"
    Up => "up"
    Down => "down"
  }
}
