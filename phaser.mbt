///|
/// A Phaser.Game handle.
#external
pub type Game

///|
/// A Phaser.Scene handle.
#external
pub type Scene

///|
/// A Phaser.Physics.Arcade.Sprite handle.
#external
pub type Sprite

///|
/// A Phaser.GameObjects.Text handle.
#external
pub type Text

///|
/// A Phaser cursor key bundle.
#external
pub type CursorKeys

///|
/// A Phaser keyboard key handle.
#external
pub type Key

///|
/// A Phaser collider or overlap handle.
#external
pub type Collider

///|
/// A Phaser Arcade Physics body handle.
#external
pub type ArcadeBody

///|
pub type SceneCallback = (Scene) -> Unit

///|
pub type UpdateCallback = (Scene) -> Unit

///|
pub type OverlapCallback = (Sprite, Sprite) -> Unit

///|
extern "js" fn js_create_game(
  parent : String,
  width : Int,
  height : Int,
  background : String,
  gravity_y : Int,
  debug : Bool,
  preload : SceneCallback,
  create : SceneCallback,
  update : UpdateCallback,
) -> Game =
  #| (parent, width, height, background, gravityY, debug, preload, create, update) => {
  #|   const Phaser = globalThis.Phaser;
  #|   if (!Phaser) {
  #|     throw new Error("MoonPhaserKit requires Phaser 3 on globalThis.Phaser");
  #|   }
  #|   class MoonPhaserKitScene extends Phaser.Scene {
  #|     constructor() {
  #|       super("moonphaserkit-main");
  #|     }
  #|     preload() {
  #|       preload(this);
  #|     }
  #|     create() {
  #|       create(this);
  #|     }
  #|     update() {
  #|       update(this);
  #|     }
  #|   }
  #|   const game = new Phaser.Game({
  #|     type: Phaser.AUTO,
  #|     parent,
  #|     width,
  #|     height,
  #|     backgroundColor: background,
  #|     physics: {
  #|       default: "arcade",
  #|       arcade: {
  #|         gravity: { y: gravityY },
  #|         debug
  #|       }
  #|     },
  #|     scene: MoonPhaserKitScene
  #|   });
  #|   globalThis.__moonphaserkitGame = game;
  #|   return game;
  #| }

///|
/// Creates a Phaser game from MoonBit callbacks.
pub fn Game::create(
  config : GameConfig,
  preload : SceneCallback,
  create : SceneCallback,
  update : UpdateCallback,
) -> Game {
  guard config.is_valid() else { abort("invalid MoonPhaserKit GameConfig") }
  js_create_game(
    config.parent,
    config.width,
    config.height,
    config.background,
    config.gravity_y,
    config.debug,
    preload,
    create,
    update,
  )
}

///|
extern "js" fn js_destroy_game(game : Game) -> Unit =
  #| (game) => game.destroy(true)

///|
/// Destroys the Phaser game and removes its canvas.
pub fn Game::destroy(self : Game) -> Unit {
  js_destroy_game(self)
}

///|
extern "js" fn js_scene_load_image(
  scene : Scene,
  key : String,
  path : String,
) -> Unit =
  #| (scene, key, path) => scene.load.image(key, path)

///|
/// Loads an image asset during the scene `preload` callback.
pub fn Scene::load_image(self : Scene, asset : ImageAsset) -> Unit {
  guard asset.is_valid() else { abort("invalid MoonPhaserKit ImageAsset") }
  js_scene_load_image(self, asset.key, asset.path)
}

///|
extern "js" fn js_scene_add_sprite(
  scene : Scene,
  x : Double,
  y : Double,
  key : String,
) -> Sprite =
  #| (scene, x, y, key) => scene.physics.add.sprite(x, y, key)

///|
/// Adds an Arcade Physics sprite to the scene.
pub fn Scene::add_sprite(
  self : Scene,
  x : Double,
  y : Double,
  key : String,
) -> Sprite {
  js_scene_add_sprite(self, x, y, key)
}

///|
extern "js" fn js_scene_add_static_sprite(
  scene : Scene,
  x : Double,
  y : Double,
  key : String,
) -> Sprite =
  #| (scene, x, y, key) => scene.physics.add.staticSprite(x, y, key)

///|
/// Adds an immovable static Arcade Physics sprite to the scene.
pub fn Scene::add_static_sprite(
  self : Scene,
  x : Double,
  y : Double,
  key : String,
) -> Sprite {
  js_scene_add_static_sprite(self, x, y, key)
}

///|
extern "js" fn js_scene_add_text(
  scene : Scene,
  x : Double,
  y : Double,
  value : String,
  size : Int,
  color : String,
) -> Text =
  #| (scene, x, y, value, size, color) => scene.add.text(x, y, value, {
  #|   fontFamily: "Inter, system-ui, sans-serif",
  #|   fontSize: `${size}px`,
  #|   color
  #| })

///|
/// Adds text to the scene.
pub fn Scene::add_text(
  self : Scene,
  x : Double,
  y : Double,
  value : String,
  size? : Int = 18,
  color? : String = "#ffffff",
) -> Text {
  js_scene_add_text(self, x, y, value, size, color)
}

///|
extern "js" fn js_text_set_text(text : Text, value : String) -> Unit =
  #| (text, value) => text.setText(value)

///|
/// Updates a text object's displayed string.
pub fn Text::set_text(self : Text, value : String) -> Unit {
  js_text_set_text(self, value)
}

///|
extern "js" fn js_scene_cursor_keys(scene : Scene) -> CursorKeys =
  #| (scene) => scene.input.keyboard.createCursorKeys()

///|
/// Creates Phaser cursor keys for keyboard control.
pub fn Scene::cursor_keys(self : Scene) -> CursorKeys {
  js_scene_cursor_keys(self)
}

///|
extern "js" fn js_cursor_left(keys : CursorKeys) -> Key =
  #| (keys) => keys.left

///|
extern "js" fn js_cursor_right(keys : CursorKeys) -> Key =
  #| (keys) => keys.right

///|
extern "js" fn js_cursor_up(keys : CursorKeys) -> Key =
  #| (keys) => keys.up

///|
extern "js" fn js_cursor_down(keys : CursorKeys) -> Key =
  #| (keys) => keys.down

///|
/// Returns a single key from a cursor-key bundle.
pub fn CursorKeys::key(self : CursorKeys, direction : CursorDirection) -> Key {
  match direction {
    Left => js_cursor_left(self)
    Right => js_cursor_right(self)
    Up => js_cursor_up(self)
    Down => js_cursor_down(self)
  }
}

///|
extern "js" fn js_key_is_down(key : Key) -> Bool =
  #| (key) => key.isDown

///|
/// Returns true while the key is held down.
pub fn Key::is_down(self : Key) -> Bool {
  js_key_is_down(self)
}

///|
extern "js" fn js_key_is_up(key : Key) -> Bool =
  #| (key) => key.isUp

///|
/// Returns true while the key is released.
pub fn Key::is_up(self : Key) -> Bool {
  js_key_is_up(self)
}

///|
extern "js" fn js_sprite_body(sprite : Sprite) -> ArcadeBody =
  #| (sprite) => sprite.body

///|
/// Returns the Arcade Physics body attached to a sprite.
pub fn Sprite::body(self : Sprite) -> ArcadeBody {
  js_sprite_body(self)
}

///|
extern "js" fn js_sprite_set_scale(sprite : Sprite, scale : Double) -> Unit =
  #| (sprite, scale) => sprite.setScale(scale).refreshBody?.()

///|
/// Sets a sprite scale.
pub fn Sprite::set_scale(self : Sprite, scale : Double) -> Unit {
  js_sprite_set_scale(self, scale)
}

///|
extern "js" fn js_sprite_set_visible(sprite : Sprite, visible : Bool) -> Unit =
  #| (sprite, visible) => sprite.setVisible(visible)

///|
/// Shows or hides a sprite.
pub fn Sprite::set_visible(self : Sprite, visible : Bool) -> Unit {
  js_sprite_set_visible(self, visible)
}

///|
extern "js" fn js_sprite_set_active(sprite : Sprite, active : Bool) -> Unit =
  #| (sprite, active) => sprite.setActive(active)

///|
/// Activates or deactivates a sprite.
pub fn Sprite::set_active(self : Sprite, active : Bool) -> Unit {
  js_sprite_set_active(self, active)
}

///|
extern "js" fn js_sprite_destroy(sprite : Sprite) -> Unit =
  #| (sprite) => sprite.destroy()

///|
/// Destroys a sprite.
pub fn Sprite::destroy(self : Sprite) -> Unit {
  js_sprite_destroy(self)
}

///|
extern "js" fn js_body_set_velocity(
  body : ArcadeBody,
  x : Double,
  y : Double,
) -> Unit =
  #| (body, x, y) => body.setVelocity(x, y)

///|
/// Sets a body's x and y velocity.
pub fn ArcadeBody::set_velocity(self : ArcadeBody, velocity : Velocity) -> Unit {
  js_body_set_velocity(self, velocity.x, velocity.y)
}

///|
extern "js" fn js_body_set_velocity_x(body : ArcadeBody, x : Double) -> Unit =
  #| (body, x) => body.setVelocityX(x)

///|
/// Sets a body's x velocity.
pub fn ArcadeBody::set_velocity_x(self : ArcadeBody, x : Double) -> Unit {
  js_body_set_velocity_x(self, x)
}

///|
extern "js" fn js_body_set_velocity_y(body : ArcadeBody, y : Double) -> Unit =
  #| (body, y) => body.setVelocityY(y)

///|
/// Sets a body's y velocity.
pub fn ArcadeBody::set_velocity_y(self : ArcadeBody, y : Double) -> Unit {
  js_body_set_velocity_y(self, y)
}

///|
extern "js" fn js_body_set_bounce(
  body : ArcadeBody,
  x : Double,
  y : Double,
) -> Unit =
  #| (body, x, y) => body.setBounce(x, y)

///|
/// Sets a body's bounce.
pub fn ArcadeBody::set_bounce(
  self : ArcadeBody,
  x : Double,
  y : Double,
) -> Unit {
  js_body_set_bounce(self, x, y)
}

///|
extern "js" fn js_body_set_collide_world_bounds(
  body : ArcadeBody,
  collide : Bool,
) -> Unit =
  #| (body, collide) => body.setCollideWorldBounds(collide)

///|
/// Sets whether the body collides with world bounds.
pub fn ArcadeBody::set_collide_world_bounds(
  self : ArcadeBody,
  collide : Bool,
) -> Unit {
  js_body_set_collide_world_bounds(self, collide)
}

///|
extern "js" fn js_body_set_immovable(
  body : ArcadeBody,
  immovable : Bool,
) -> Unit =
  #| (body, immovable) => body.setImmovable(immovable)

///|
/// Sets whether the body is immovable.
pub fn ArcadeBody::set_immovable(self : ArcadeBody, immovable : Bool) -> Unit {
  js_body_set_immovable(self, immovable)
}

///|
extern "js" fn js_body_set_gravity_y(
  body : ArcadeBody,
  gravity_y : Double,
) -> Unit =
  #| (body, gravityY) => body.setGravityY(gravityY)

///|
/// Sets a body-specific vertical gravity.
pub fn ArcadeBody::set_gravity_y(self : ArcadeBody, gravity_y : Double) -> Unit {
  js_body_set_gravity_y(self, gravity_y)
}

///|
extern "js" fn js_body_touching_down(body : ArcadeBody) -> Bool =
  #| (body) => body.blocked.down || body.touching.down

///|
/// Returns true when the body is standing on something.
pub fn ArcadeBody::touching_down(self : ArcadeBody) -> Bool {
  js_body_touching_down(self)
}

///|
extern "js" fn js_scene_collider(
  scene : Scene,
  a : Sprite,
  b : Sprite,
) -> Collider =
  #| (scene, a, b) => scene.physics.add.collider(a, b)

///|
/// Adds a collider between two sprites.
pub fn Scene::add_collider(self : Scene, a : Sprite, b : Sprite) -> Collider {
  js_scene_collider(self, a, b)
}

///|
extern "js" fn js_scene_overlap(
  scene : Scene,
  a : Sprite,
  b : Sprite,
  callback : OverlapCallback,
) -> Collider =
  #| (scene, a, b, callback) => scene.physics.add.overlap(a, b, (left, right) => callback(left, right))

///|
/// Adds an overlap callback between two sprites.
pub fn Scene::add_overlap(
  self : Scene,
  a : Sprite,
  b : Sprite,
  callback : OverlapCallback,
) -> Collider {
  js_scene_overlap(self, a, b, callback)
}

///|
extern "js" fn js_scene_restart(scene : Scene) -> Unit =
  #| (scene) => scene.scene.restart()

///|
/// Restarts the current scene.
pub fn Scene::restart(self : Scene) -> Unit {
  js_scene_restart(self)
}

///|
/// Applies reusable sprite options to an Arcade sprite.
pub fn Sprite::apply_options(self : Sprite, options : SpriteOptions) -> Unit {
  self.set_scale(options.scale)
  let body = self.body()
  body.set_immovable(options.immovable)
  body.set_collide_world_bounds(options.collide_world_bounds)
  body.set_bounce(options.bounce_x, options.bounce_y)
  body.set_gravity_y(options.gravity_y)
}
