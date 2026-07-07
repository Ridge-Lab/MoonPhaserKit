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
/// A Phaser.Sound.BaseSound handle.
#external
pub type Sound

///|
/// A Phaser.Cameras.Scene2D.Camera handle.
#external
pub type Camera

///|
/// A Phaser.Tilemaps.Tilemap handle.
#external
pub type Tilemap

///|
/// A Phaser.Tilemaps.TilemapLayer handle.
#external
pub type TileLayer

///|
/// A Phaser.Tilemaps.Tileset handle.
#external
pub type Tileset

///|
/// A Phaser input pointer handle.
#external
pub type Pointer

///|
pub type SceneCallback = (Scene) -> Unit

///|
pub type UpdateCallback = (Scene) -> Unit

///|
pub type OverlapCallback = (Sprite, Sprite) -> Unit

///|
pub type PointerCallback = (Pointer) -> Unit

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
extern "js" fn js_scene_load_spritesheet(
  scene : Scene,
  key : String,
  path : String,
  frame_width : Int,
  frame_height : Int,
  margin : Int,
  spacing : Int,
) -> Unit =
  #| (scene, key, path, frameWidth, frameHeight, margin, spacing) => {
  #|   scene.load.spritesheet(key, path, {
  #|     frameWidth,
  #|     frameHeight,
  #|     margin,
  #|     spacing
  #|   });
  #| }

///|
/// Loads a spritesheet for frame animations.
pub fn Scene::load_spritesheet(self : Scene, asset : SpriteSheetAsset) -> Unit {
  guard asset.is_valid() else { abort("invalid MoonPhaserKit SpriteSheetAsset") }
  js_scene_load_spritesheet(
    self,
    asset.key,
    asset.path,
    asset.frame_width,
    asset.frame_height,
    asset.margin,
    asset.spacing,
  )
}

///|
extern "js" fn js_scene_load_atlas(
  scene : Scene,
  key : String,
  texture_path : String,
  atlas_path : String,
) -> Unit =
  #| (scene, key, texturePath, atlasPath) => scene.load.atlas(key, texturePath, atlasPath)

///|
/// Loads a texture atlas.
pub fn Scene::load_atlas(self : Scene, asset : TextureAtlasAsset) -> Unit {
  guard asset.is_valid() else { abort("invalid MoonPhaserKit TextureAtlasAsset") }
  js_scene_load_atlas(self, asset.key, asset.texture_path, asset.atlas_path)
}

///|
extern "js" fn js_scene_load_audio(
  scene : Scene,
  key : String,
  path : String,
) -> Unit =
  #| (scene, key, path) => scene.load.audio(key, path)

///|
/// Loads an audio asset.
pub fn Scene::load_audio(self : Scene, asset : AudioAsset) -> Unit {
  guard asset.is_valid() else { abort("invalid MoonPhaserKit AudioAsset") }
  js_scene_load_audio(self, asset.key, asset.path)
}

///|
extern "js" fn js_scene_load_tilemap_json(
  scene : Scene,
  key : String,
  path : String,
) -> Unit =
  #| (scene, key, path) => scene.load.tilemapTiledJSON(key, path)

///|
/// Loads a Tiled JSON tilemap.
pub fn Scene::load_tilemap_json(self : Scene, asset : TilemapJsonAsset) -> Unit {
  guard asset.is_valid() else { abort("invalid MoonPhaserKit TilemapJsonAsset") }
  js_scene_load_tilemap_json(self, asset.key, asset.path)
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
extern "js" fn js_sprite_set_position(
  sprite : Sprite,
  x : Double,
  y : Double,
) -> Unit =
  #| (sprite, x, y) => sprite.setPosition(x, y)

///|
/// Sets sprite position.
pub fn Sprite::set_position(self : Sprite, point : Point2) -> Unit {
  js_sprite_set_position(self, point.x, point.y)
}

///|
extern "js" fn js_sprite_set_flip_x(sprite : Sprite, flip : Bool) -> Unit =
  #| (sprite, flip) => sprite.setFlipX(flip)

///|
/// Mirrors a sprite horizontally.
pub fn Sprite::set_flip_x(self : Sprite, flip : Bool) -> Unit {
  js_sprite_set_flip_x(self, flip)
}

///|
extern "js" fn js_sprite_set_alpha(sprite : Sprite, alpha : Double) -> Unit =
  #| (sprite, alpha) => sprite.setAlpha(alpha)

///|
/// Sets sprite alpha.
pub fn Sprite::set_alpha(self : Sprite, alpha : Double) -> Unit {
  js_sprite_set_alpha(self, alpha)
}

///|
extern "js" fn js_sprite_set_depth(sprite : Sprite, depth : Int) -> Unit =
  #| (sprite, depth) => sprite.setDepth(depth)

///|
/// Sets sprite render depth.
pub fn Sprite::set_depth(self : Sprite, depth : Int) -> Unit {
  js_sprite_set_depth(self, depth)
}

///|
extern "js" fn js_scene_create_animation(
  scene : Scene,
  key : String,
  texture_key : String,
  start : Int,
  end : Int,
  frame_rate : Int,
  repeat : Int,
  yoyo : Bool,
  delay_ms : Int,
) -> Unit =
  #| (scene, key, textureKey, start, end, frameRate, repeat, yoyo, delayMs) => {
  #|   scene.anims.create({
  #|     key,
  #|     frames: scene.anims.generateFrameNumbers(textureKey, { start, end }),
  #|     frameRate,
  #|     repeat,
  #|     yoyo,
  #|     delay: delayMs
  #|   });
  #| }

///|
/// Creates a frame-number based animation.
pub fn Scene::create_animation(self : Scene, config : AnimationConfig) -> Unit {
  guard config.is_valid() else { abort("invalid MoonPhaserKit AnimationConfig") }
  js_scene_create_animation(
    self,
    config.key,
    config.texture_key,
    config.frames.start,
    config.frames.end,
    config.frame_rate,
    config.phaser_repeat(),
    config.yoyo,
    config.delay_ms,
  )
}

///|
extern "js" fn js_sprite_play_animation(
  sprite : Sprite,
  key : String,
  ignore_if_playing : Bool,
) -> Unit =
  #| (sprite, key, ignoreIfPlaying) => sprite.play(key, ignoreIfPlaying)

///|
/// Plays a previously created animation.
pub fn Sprite::play_animation(
  self : Sprite,
  key : String,
  ignore_if_playing? : Bool = true,
) -> Unit {
  guard key.length() > 0 else { abort("invalid MoonPhaserKit animation key") }
  js_sprite_play_animation(self, key, ignore_if_playing)
}

///|
extern "js" fn js_sprite_stop_animation(sprite : Sprite) -> Unit =
  #| (sprite) => sprite.stop()

///|
/// Stops the current sprite animation.
pub fn Sprite::stop_animation(self : Sprite) -> Unit {
  js_sprite_stop_animation(self)
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
extern "js" fn js_scene_add_sound(
  scene : Scene,
  key : String,
  volume : Double,
  rate : Double,
  detune : Int,
  seek : Double,
  delay_ms : Int,
  should_loop : Bool,
) -> Sound =
  #| (scene, key, volume, rate, detune, seek, delayMs, shouldLoop) => {
  #|   return scene.sound.add(key, {
  #|     volume,
  #|     rate,
  #|     detune,
  #|     seek,
  #|     delay: delayMs / 1000,
  #|     loop: shouldLoop
  #|   });
  #| }

///|
/// Adds a loaded audio asset to the scene sound manager.
pub fn Scene::add_sound(
  self : Scene,
  key : String,
  options? : SoundOptions = SoundOptions::new(),
) -> Sound {
  guard key.length() > 0 && options.is_valid() else {
    abort("invalid MoonPhaserKit sound options")
  }
  js_scene_add_sound(
    self,
    key,
    options.volume,
    options.rate,
    options.detune,
    options.seek,
    options.delay_ms,
    options.should_loop(),
  )
}

///|
extern "js" fn js_sound_play(sound : Sound) -> Unit =
  #| (sound) => sound.play()

///|
pub fn Sound::play(self : Sound) -> Unit {
  js_sound_play(self)
}

///|
extern "js" fn js_sound_pause(sound : Sound) -> Unit =
  #| (sound) => sound.pause()

///|
pub fn Sound::pause(self : Sound) -> Unit {
  js_sound_pause(self)
}

///|
extern "js" fn js_sound_resume(sound : Sound) -> Unit =
  #| (sound) => sound.resume()

///|
pub fn Sound::resume_playback(self : Sound) -> Unit {
  js_sound_resume(self)
}

///|
extern "js" fn js_sound_stop(sound : Sound) -> Unit =
  #| (sound) => sound.stop()

///|
pub fn Sound::stop(self : Sound) -> Unit {
  js_sound_stop(self)
}

///|
extern "js" fn js_sound_set_volume(sound : Sound, volume : Double) -> Unit =
  #| (sound, volume) => sound.setVolume(volume)

///|
pub fn Sound::set_volume(self : Sound, volume : Double) -> Unit {
  js_sound_set_volume(self, volume)
}

///|
extern "js" fn js_sound_set_mute(sound : Sound, muted : Bool) -> Unit =
  #| (sound, muted) => sound.setMute(muted)

///|
pub fn Sound::set_mute(self : Sound, muted : Bool) -> Unit {
  js_sound_set_mute(self, muted)
}

///|
extern "js" fn js_sound_destroy(sound : Sound) -> Unit =
  #| (sound) => sound.destroy()

///|
pub fn Sound::destroy(self : Sound) -> Unit {
  js_sound_destroy(self)
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
extern "js" fn js_scene_add_key(scene : Scene, key_code : String) -> Key =
  #| (scene, keyCode) => scene.input.keyboard.addKey(keyCode)

///|
/// Adds a keyboard key by Phaser key code, such as "SPACE" or "W".
pub fn Scene::add_key(self : Scene, key_code : String) -> Key {
  guard key_code.length() > 0 else { abort("invalid MoonPhaserKit key code") }
  js_scene_add_key(self, key_code)
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
extern "js" fn js_scene_active_pointer(scene : Scene) -> Pointer =
  #| (scene) => scene.input.activePointer

///|
pub fn Scene::active_pointer(self : Scene) -> Pointer {
  js_scene_active_pointer(self)
}

///|
extern "js" fn js_pointer_x(pointer : Pointer) -> Double =
  #| (pointer) => pointer.x

///|
pub fn Pointer::x(self : Pointer) -> Double {
  js_pointer_x(self)
}

///|
extern "js" fn js_pointer_y(pointer : Pointer) -> Double =
  #| (pointer) => pointer.y

///|
pub fn Pointer::y(self : Pointer) -> Double {
  js_pointer_y(self)
}

///|
extern "js" fn js_pointer_world_x(pointer : Pointer) -> Double =
  #| (pointer) => pointer.worldX

///|
pub fn Pointer::world_x(self : Pointer) -> Double {
  js_pointer_world_x(self)
}

///|
extern "js" fn js_pointer_world_y(pointer : Pointer) -> Double =
  #| (pointer) => pointer.worldY

///|
pub fn Pointer::world_y(self : Pointer) -> Double {
  js_pointer_world_y(self)
}

///|
extern "js" fn js_pointer_is_down(pointer : Pointer) -> Bool =
  #| (pointer) => pointer.isDown

///|
pub fn Pointer::is_down(self : Pointer) -> Bool {
  js_pointer_is_down(self)
}

///|
extern "js" fn js_pointer_just_down(pointer : Pointer) -> Bool =
  #| (pointer) => Phaser.Input.Pointer.JustDown(pointer)

///|
pub fn Pointer::just_down(self : Pointer) -> Bool {
  js_pointer_just_down(self)
}

///|
extern "js" fn js_scene_on_pointer_down(
  scene : Scene,
  callback : PointerCallback,
) -> Unit =
  #| (scene, callback) => scene.input.on("pointerdown", pointer => callback(pointer))

///|
pub fn Scene::on_pointer_down(self : Scene, callback : PointerCallback) -> Unit {
  js_scene_on_pointer_down(self, callback)
}

///|
extern "js" fn js_scene_on_pointer_up(
  scene : Scene,
  callback : PointerCallback,
) -> Unit =
  #| (scene, callback) => scene.input.on("pointerup", pointer => callback(pointer))

///|
pub fn Scene::on_pointer_up(self : Scene, callback : PointerCallback) -> Unit {
  js_scene_on_pointer_up(self, callback)
}

///|
extern "js" fn js_scene_on_pointer_move(
  scene : Scene,
  callback : PointerCallback,
) -> Unit =
  #| (scene, callback) => scene.input.on("pointermove", pointer => callback(pointer))

///|
pub fn Scene::on_pointer_move(self : Scene, callback : PointerCallback) -> Unit {
  js_scene_on_pointer_move(self, callback)
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
extern "js" fn js_scene_main_camera(scene : Scene) -> Camera =
  #| (scene) => scene.cameras.main

///|
pub fn Scene::main_camera(self : Scene) -> Camera {
  js_scene_main_camera(self)
}

///|
extern "js" fn js_camera_set_bounds(
  camera : Camera,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit =
  #| (camera, x, y, width, height) => camera.setBounds(x, y, width, height)

///|
pub fn Camera::set_bounds(self : Camera, bounds : CameraBounds) -> Unit {
  guard bounds.is_valid() else { abort("invalid MoonPhaserKit CameraBounds") }
  js_camera_set_bounds(self, bounds.x, bounds.y, bounds.width, bounds.height)
}

///|
extern "js" fn js_camera_start_follow(
  camera : Camera,
  sprite : Sprite,
  lerp_x : Double,
  lerp_y : Double,
  offset_x : Double,
  offset_y : Double,
  deadzone_width : Double,
  deadzone_height : Double,
) -> Unit =
  #| (camera, sprite, lerpX, lerpY, offsetX, offsetY, deadzoneWidth, deadzoneHeight) => {
  #|   camera.startFollow(sprite, false, lerpX, lerpY, offsetX, offsetY);
  #|   if (deadzoneWidth > 0 && deadzoneHeight > 0) {
  #|     camera.setDeadzone(deadzoneWidth, deadzoneHeight);
  #|   }
  #| }

///|
pub fn Camera::start_follow(
  self : Camera,
  sprite : Sprite,
  options? : CameraFollowOptions = CameraFollowOptions::new(),
) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraFollowOptions") }
  js_camera_start_follow(
    self,
    sprite,
    options.lerp_x,
    options.lerp_y,
    options.offset_x,
    options.offset_y,
    options.deadzone_width,
    options.deadzone_height,
  )
}

///|
extern "js" fn js_camera_stop_follow(camera : Camera) -> Unit =
  #| (camera) => camera.stopFollow()

///|
pub fn Camera::stop_follow(self : Camera) -> Unit {
  js_camera_stop_follow(self)
}

///|
extern "js" fn js_camera_set_zoom(camera : Camera, zoom : Double) -> Unit =
  #| (camera, zoom) => camera.setZoom(zoom)

///|
pub fn Camera::set_zoom(self : Camera, zoom : Double) -> Unit {
  guard zoom > 0.0 else { abort("invalid MoonPhaserKit zoom") }
  js_camera_set_zoom(self, zoom)
}

///|
extern "js" fn js_camera_center_on(
  camera : Camera,
  x : Double,
  y : Double,
) -> Unit =
  #| (camera, x, y) => camera.centerOn(x, y)

///|
pub fn Camera::center_on(self : Camera, point : Point2) -> Unit {
  js_camera_center_on(self, point.x, point.y)
}

///|
extern "js" fn js_camera_fade_in(
  camera : Camera,
  duration_ms : Int,
  red : Int,
  green : Int,
  blue : Int,
  force : Bool,
) -> Unit =
  #| (camera, durationMs, red, green, blue, force) => camera.fadeIn(durationMs, red, green, blue, force)

///|
pub fn Camera::fade_in(
  self : Camera,
  options? : CameraFadeOptions = CameraFadeOptions::new(),
) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraFadeOptions") }
  js_camera_fade_in(self, options.duration_ms, options.red, options.green, options.blue, options.force)
}

///|
extern "js" fn js_camera_fade_out(
  camera : Camera,
  duration_ms : Int,
  red : Int,
  green : Int,
  blue : Int,
  force : Bool,
) -> Unit =
  #| (camera, durationMs, red, green, blue, force) => camera.fadeOut(durationMs, red, green, blue, force)

///|
pub fn Camera::fade_out(
  self : Camera,
  options? : CameraFadeOptions = CameraFadeOptions::new(),
) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraFadeOptions") }
  js_camera_fade_out(self, options.duration_ms, options.red, options.green, options.blue, options.force)
}

///|
extern "js" fn js_camera_shake(
  camera : Camera,
  duration_ms : Int,
  intensity : Double,
  force : Bool,
) -> Unit =
  #| (camera, durationMs, intensity, force) => camera.shake(durationMs, intensity, force)

///|
pub fn Camera::shake(
  self : Camera,
  options? : CameraShakeOptions = CameraShakeOptions::new(),
) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraShakeOptions") }
  js_camera_shake(self, options.duration_ms, options.intensity, options.force)
}

///|
extern "js" fn js_camera_pan(
  camera : Camera,
  x : Double,
  y : Double,
  duration_ms : Int,
  ease : String,
  force : Bool,
) -> Unit =
  #| (camera, x, y, durationMs, ease, force) => camera.pan(x, y, durationMs, ease, force)

///|
pub fn Camera::pan(self : Camera, options : CameraPanOptions) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraPanOptions") }
  js_camera_pan(
    self,
    options.target.x,
    options.target.y,
    options.duration_ms,
    options.ease.to_phaser_name(),
    options.force,
  )
}

///|
extern "js" fn js_camera_zoom_to(
  camera : Camera,
  zoom : Double,
  duration_ms : Int,
  ease : String,
) -> Unit =
  #| (camera, zoom, durationMs, ease) => camera.zoomTo(zoom, durationMs, ease)

///|
pub fn Camera::zoom_to(self : Camera, options : CameraZoomOptions) -> Unit {
  guard options.is_valid() else { abort("invalid MoonPhaserKit CameraZoomOptions") }
  js_camera_zoom_to(self, options.zoom, options.duration_ms, options.ease.to_phaser_name())
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
extern "js" fn js_scene_make_tilemap(
  scene : Scene,
  key : String,
  tile_width : Int,
  tile_height : Int,
  width : Int,
  height : Int,
) -> Tilemap =
  #| (scene, key, tileWidth, tileHeight, width, height) => {
  #|   return scene.make.tilemap({ key, tileWidth, tileHeight, width, height });
  #| }

///|
pub fn Scene::make_tilemap(self : Scene, config : TilemapConfig) -> Tilemap {
  guard config.is_valid() else { abort("invalid MoonPhaserKit TilemapConfig") }
  js_scene_make_tilemap(
    self,
    config.key,
    config.tile_width,
    config.tile_height,
    config.width,
    config.height,
  )
}

///|
extern "js" fn js_tilemap_add_tileset(
  map : Tilemap,
  name : String,
  texture_key : String,
  tile_width : Int,
  tile_height : Int,
  margin : Int,
  spacing : Int,
) -> Tileset =
  #| (map, name, textureKey, tileWidth, tileHeight, margin, spacing) => {
  #|   return map.addTilesetImage(name, textureKey, tileWidth, tileHeight, margin, spacing);
  #| }

///|
pub fn Tilemap::add_tileset(self : Tilemap, config : TilesetConfig) -> Tileset {
  guard config.is_valid() else { abort("invalid MoonPhaserKit TilesetConfig") }
  js_tilemap_add_tileset(
    self,
    config.name,
    config.texture_key,
    config.tile_width,
    config.tile_height,
    config.margin,
    config.spacing,
  )
}

///|
extern "js" fn js_tilemap_create_layer(
  map : Tilemap,
  layer_name : String,
  tileset_name : String,
  x : Double,
  y : Double,
  visible : Bool,
  alpha : Double,
) -> TileLayer =
  #| (map, layerName, tilesetName, x, y, visible, alpha) => {
  #|   const layer = map.createLayer(layerName, tilesetName, x, y);
  #|   layer.setVisible(visible);
  #|   layer.setAlpha(alpha);
  #|   return layer;
  #| }

///|
pub fn Tilemap::create_layer(self : Tilemap, config : TileLayerConfig) -> TileLayer {
  guard config.is_valid() else { abort("invalid MoonPhaserKit TileLayerConfig") }
  js_tilemap_create_layer(
    self,
    config.layer_name,
    config.tileset_name,
    config.x,
    config.y,
    config.visible,
    config.alpha,
  )
}

///|
extern "js" fn js_tile_layer_set_collision_between(
  layer : TileLayer,
  start_index : Int,
  end_index : Int,
  collides : Bool,
) -> Unit =
  #| (layer, startIndex, endIndex, collides) => layer.setCollisionBetween(startIndex, endIndex, collides)

///|
pub fn TileLayer::set_collision_between(
  self : TileLayer,
  range : TileCollisionRange,
) -> Unit {
  guard range.is_valid() else { abort("invalid MoonPhaserKit TileCollisionRange") }
  js_tile_layer_set_collision_between(self, range.start_index, range.end_index, range.collides)
}

///|
extern "js" fn js_tile_layer_set_collision_by_property(
  layer : TileLayer,
  property : String,
  value : String,
  collides : Bool,
) -> Unit =
  #| (layer, property, value, collides) => layer.setCollisionByProperty({ [property]: value }, collides)

///|
pub fn TileLayer::set_collision_by_property(
  self : TileLayer,
  matcher : TilePropertyMatcher,
) -> Unit {
  guard matcher.is_valid() else { abort("invalid MoonPhaserKit TilePropertyMatcher") }
  js_tile_layer_set_collision_by_property(self, matcher.property, matcher.value, matcher.collides)
}

///|
extern "js" fn js_tile_layer_set_visible(layer : TileLayer, visible : Bool) -> Unit =
  #| (layer, visible) => layer.setVisible(visible)

///|
pub fn TileLayer::set_visible(self : TileLayer, visible : Bool) -> Unit {
  js_tile_layer_set_visible(self, visible)
}

///|
extern "js" fn js_tile_layer_set_alpha(layer : TileLayer, alpha : Double) -> Unit =
  #| (layer, alpha) => layer.setAlpha(alpha)

///|
pub fn TileLayer::set_alpha(self : TileLayer, alpha : Double) -> Unit {
  js_tile_layer_set_alpha(self, alpha)
}

///|
extern "js" fn js_tile_layer_destroy(layer : TileLayer) -> Unit =
  #| (layer) => layer.destroy()

///|
pub fn TileLayer::destroy(self : TileLayer) -> Unit {
  js_tile_layer_destroy(self)
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
