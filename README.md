# MoonPhaserKit

MoonPhaserKit 是面向 MoonBit JavaScript 后端的 Phaser 3 游戏开发绑定库，目标是让开发者用 MoonBit 编写 2D 网页游戏逻辑，并复用 Phaser 的浏览器渲染、输入、音频、相机、Tilemap 和 Arcade Physics 能力。

项目用于 2026 MoonBit 国产基础软件生态开源大赛。它不是单纯提交一个小游戏，而是补齐 MoonBit Web 游戏生态中的 2D 游戏开发基础能力；示例游戏 Moon Jumper 用来验证绑定链路和浏览器运行效果。

## 当前状态

- MoonBit 源码规模：超过 4k 行，覆盖核心库、FFI、模型层、测试和示例。
- 测试状态：`moon test --target js` 当前 34 个测试通过。
- Demo 运行时：Phaser `3.90.0` + Vite。
- 支持目标：MoonBit JavaScript 后端。
- 支持能力：场景生命周期、图片、Spritesheet、Atlas、动画、精灵、文字、键盘、触控指针、音频、主相机、Tilemap、Arcade Physics、碰撞和 overlap。
- 设计边界：暂不支持 Phaser 4、Godot、Cocos、Unity、Unreal、原生桌面端和原生移动端。

## 安装

Mooncakes 安装：

```bash
moon add moonphaserkit/moonphaserkit
```

源码方式：

```bash
git clone https://github.com/Ridge-Lab/MoonPhaserKit.git
cd MoonPhaserKit
moon check --target js
moon test --target js
```

宿主网页需要安装 Phaser 并在加载 MoonBit JS 产物前暴露全局对象：

```js
import Phaser from "phaser";

globalThis.Phaser = Phaser;
await import("./generated/moon-jumper.js");
```

## 最小示例

```moonbit
fn main {
  let config = @moonphaserkit.GameConfig::new(parent="game")
  ignore(@moonphaserkit.Game::create(
    config,
    scene => {
      scene.load_image(@moonphaserkit.ImageAsset::new("player", "/assets/player.svg"))
      scene.load_spritesheet(
        @moonphaserkit.SpriteSheetAsset::new("hero-run", "/assets/hero-run.png", 32, 48),
      )
      scene.load_audio(@moonphaserkit.AudioAsset::new("jump", "/assets/jump.ogg"))
    },
    scene => {
      scene.create_animation(
        @moonphaserkit.AnimationConfig::new(
          "run",
          "hero-run",
          @moonphaserkit.FrameRange::new(0, 7),
          frame_rate=14,
          repeat_mode=@moonphaserkit.AnimRepeatForever,
        ),
      )
      let player = scene.add_sprite(120.0, 220.0, "player")
      player.apply_options(@moonphaserkit.SpriteOptions::new(collide_world_bounds=true))
      player.play_animation("run")
      scene.main_camera().start_follow(player)
    },
    _scene => (),
  ))
}
```

## 运行 Demo

```bash
cd examples/moon-jumper-web
npm install
npm run dev
```

打开 Vite 输出的本地地址后，使用方向键左、右、上进行移动和跳跃。

## API 概览

| 类别 | 公开能力 |
| --- | --- |
| 游戏与场景 | `GameConfig`、`Game`、`Scene`，支持 Phaser 游戏创建、销毁和场景生命周期。 |
| 资源加载 | `ImageAsset`、`TextureAsset`、`SpriteSheetAsset`、`TextureAtlasAsset`、`AudioAsset`、`TilemapJsonAsset`、`BitmapFontAsset`。 |
| 显示对象 | `Sprite`、`Text`、`DisplayObjectOptions`、`SpawnSpec`，支持位置、缩放、透明度、层级、显示和销毁。 |
| 动画 | `AnimationConfig`、`FrameRange`、`AnimationPlayOptions`、`TweenConfig`、`SpriteTween`。 |
| 音频 | `Sound`、`SoundOptions`、`SoundMarker`、`AudioFade`、`AudioBusState`。 |
| 输入 | `CursorKeys`、`Key`、`Pointer`、`PointerSnapshot`、`TouchZone`、`SwipeSnapshot`、`KeyBinding`。 |
| 物理与碰撞 | `ArcadeBody`、`Collider`、`PhysicsMaterial`、`TileCollisionRange`、`TilePropertyMatcher`。 |
| 相机 | `Camera`、`CameraBounds`、`CameraFollowOptions`、`CameraFadeOptions`、`CameraShakeOptions`、`CameraPanOptions`、`CameraZoomOptions`。 |
| Tilemap | `Tilemap`、`Tileset`、`TileLayer`、`TilemapConfig`、`TilesetConfig`、`TileLayerConfig`、`TileObject`、`TileSpawnPoint`。 |
| 工程支撑 | `RuntimeCompatibility`、`IntegrationChecklist`、`BrowserSmokeScenario`、`ErrorPathExpectation`、`FfiCallRecord`。 |

## 兼容性

- MoonBit：JavaScript 后端。
- Phaser：以 `3.90.0` 为 Demo 和 CI 运行版本；库内兼容性模型标记 Phaser 3.60+ 为可支持窗口。
- 浏览器：Chromium/Edge/Firefox/Safari 的现代版本；音频播放遵循浏览器用户手势解锁规则。
- 宿主要求：运行 MoonBit 生成的 JavaScript 前必须设置 `globalThis.Phaser`。

## 测试与质量

项目包含 MoonBit 单元测试、白盒测试、浏览器 smoke test 和 CI：

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
npm install
npm run build
npm run smoke
```

测试覆盖配置校验、资源描述、动画、音频、相机、Tilemap、触控区域、错误路径、集成清单和浏览器验收场景描述。

## 文档

- [API 文档](docs/API.md)
- [集成指南](docs/INTEGRATION.md)
- [测试说明](docs/TESTING.md)
- [Roadmap](docs/ROADMAP.md)

## 仓库与参赛说明

- GitHub 仓库：https://github.com/Ridge-Lab/MoonPhaserKit.git
- GitLink 仓库：https://gitlink.org.cn/RidgeLab/MoonPhaserKit
- 项目性质：原创 MoonBit 生态绑定项目，不移植已有开源项目源码。
- 许可证：MIT。
