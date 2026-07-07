# MoonPhaserKit API

MoonPhaserKit 面向 MoonBit JavaScript 后端，提供一组经过收敛的 Phaser 3 API。库的目标不是完整复刻 Phaser JavaScript API，而是覆盖 2D 网页游戏最常用的一条生产链路。

## 游戏与场景

`GameConfig::new` 配置画布父节点、尺寸、背景色、Arcade Physics 重力和调试模式。

`Game::create(config, preload, create, update)` 将 MoonBit 回调映射到 Phaser 场景生命周期：

- `preload`：加载图片、Spritesheet、Atlas、音频和 Tilemap JSON。
- `create`：创建精灵、文字、动画、音效、碰撞、相机和输入。
- `update`：执行每帧游戏逻辑。

## 资源加载

```moonbit
scene.load_image(ImageAsset::new("player", "/assets/player.svg"))
scene.load_spritesheet(SpriteSheetAsset::new("hero-run", "/assets/hero-run.png", 32, 48))
scene.load_atlas(TextureAtlasAsset::new("ui", "/assets/ui.png", "/assets/ui.json"))
scene.load_audio(AudioAsset::new("jump", "/assets/jump.ogg"))
scene.load_tilemap_json(TilemapJsonAsset::new("level1", "/maps/level1.json"))
```

所有资源描述类型都提供 `is_valid()`，用于提前发现空 key、空路径、错误帧尺寸等问题。

## 动画

```moonbit
scene.create_animation(
  AnimationConfig::new(
    "run",
    "hero-run",
    FrameRange::new(0, 7),
    frame_rate=14,
    repeat_mode=AnimRepeatForever,
  ),
)
player.play_animation("run")
```

相关类型：

- `FrameRange`：帧范围。
- `AnimationRepeatMode`：一次、固定次数、无限循环。
- `AnimationConfig`：Phaser frame-number 动画配置。
- `AnimationPlayOptions`：播放行为配置。
- `TweenConfig` / `SpriteTween`：补间动画配置模型。

## 音频

```moonbit
scene.load_audio(AudioAsset::new("coin", "/assets/coin.ogg"))
let coin = scene.add_sound("coin", options=SoundOptions::new(volume=0.6))
coin.play()
```

相关能力：

- `Sound::play/pause/resume_playback/stop/destroy`
- `Sound::set_volume`
- `Sound::set_mute`
- `SoundOptions`
- `SoundMarker`
- `AudioFade`
- `AudioBusState`

浏览器音频受用户手势解锁规则影响，实际项目应在首次点击、触摸或键盘输入后播放音频。

## 输入

键盘：

```moonbit
let cursors = scene.cursor_keys()
if cursors.key(Left).is_down() {
  player.body().set_velocity_x(-220.0)
}
let space = scene.add_key("SPACE")
```

触控和指针：

```moonbit
scene.on_pointer_down(pointer => {
  if pointer.just_down() {
    let x = pointer.world_x()
    let y = pointer.world_y()
    ignore((x, y))
  }
})
```

纯 MoonBit 模型层提供 `PointerSnapshot`、`TouchZone`、`SwipeSnapshot` 和 `KeyBinding`，方便测试移动端输入逻辑。

## 相机

```moonbit
let camera = scene.main_camera()
camera.set_bounds(CameraBounds::new(0.0, 0.0, 2000.0, 1200.0))
camera.start_follow(player, options=CameraFollowOptions::new(lerp_x=0.2, lerp_y=0.2))
camera.shake(CameraShakeOptions::new(duration_ms=160, intensity=0.01))
```

支持主相机 bounds、follow、stop follow、zoom、center、fade in/out、shake、pan、zoomTo。

## Tilemap

```moonbit
scene.load_tilemap_json(TilemapJsonAsset::new("level1", "/maps/level1.json"))
let map = scene.make_tilemap(TilemapConfig::new("level1", 16, 16))
ignore(map.add_tileset(TilesetConfig::new("terrain", "terrain", 16, 16)))
let ground = map.create_layer(TileLayerConfig::new("ground", "terrain"))
ground.set_collision_between(TileCollisionRange::new(1, 200))
```

支持 Tiled JSON 加载、Tileset 绑定、Layer 创建、按 tile index 范围设置碰撞、按 tile 属性设置碰撞。

## 物理

`Sprite::body()` 返回 `ArcadeBody`，支持：

- `set_velocity`
- `set_velocity_x`
- `set_velocity_y`
- `set_bounce`
- `set_collide_world_bounds`
- `set_immovable`
- `set_gravity_y`
- `touching_down`

`PhysicsMaterial` 可以把常用物理配置转成 `SpriteOptions`，用于平台、拾取物和角色生成。

## 兼容性与集成模型

`RuntimeCompatibility`、`IntegrationChecklist`、`BrowserSmokeScenario`、`ErrorPathExpectation` 和 `FfiCallRecord` 用于描述运行时约束、集成步骤、浏览器验收和错误路径。它们可被测试和 CI 使用，减少“只在 README 里说清楚、代码里没有表达”的问题。

