# MoonPhaserKit

MoonPhaserKit 是面向 MoonBit JavaScript 后端的 Phaser 3 轻量游戏开发绑定库。它让开发者用 MoonBit 编写 2D 网页游戏逻辑，并调用 Phaser 3 的场景、精灵、输入、动画、音频、相机、Tilemap 和 Arcade Physics 能力。

本项目用于 2026 MoonBit 国产基础软件生态开源大赛。项目定位不是提交一个小游戏，而是补齐 MoonBit Web 游戏生态中“用 MoonBit 写浏览器 2D 游戏”的基础绑定能力；示例游戏 Moon Jumper 用来验证绑定链路、工程接入方式和浏览器运行效果。

## 交付范围

- 核心语言：MoonBit，目标后端为 JavaScript。
- 绑定目标：Phaser 3，Demo 与 CI 固定使用 `phaser@3.90.0`。
- 公开 API：游戏创建、场景生命周期、资源加载、精灵、文字、动画、音频、键盘、触控指针、相机、Tilemap、Arcade Physics、碰撞、场景控制和时间事件。
- 示例工程：`examples/moon-jumper-web`，使用 Vite 启动网页 Demo。
- 工程质量：包含 MoonBit 单元测试、白盒测试、浏览器 smoke test、CI、API 文档、集成指南、测试说明和提交说明。
- 设计边界：v1 只支持 MoonBit JavaScript 后端 + Phaser 3；不覆盖 Phaser 4、Godot、Cocos、Unity、Unreal、原生桌面端和原生移动端。

## 评审反馈处理

针对预验收反馈，本仓库已完成以下增强：

- 源码规模从早期轻量原型扩展到 4k+ 行 MoonBit 源码，新增动画、音频、相机、Tilemap、触控、场景控制、时间事件、UI 文本样式、兼容性模型和诊断模型。
- 测试从基础配置测试扩展为 40 个 MoonBit 测试用例，并保留浏览器 smoke test，覆盖配置、资源、动画、音频、相机、Tilemap、触控、错误路径、交互场景和新增运行时模型。
- README 已改为源码验收、Mooncakes 发布和比赛提交分别说明，避免把最终仓库写成半成品说明。
- 文档补充 API 示例、版本兼容、项目集成、测试方式和提交检查清单。

## 安装与使用

源码方式，适合评审和本地验收：

```bash
git clone https://github.com/Ridge-Lab/MoonPhaserKit.git
cd MoonPhaserKit
moon check --target js
moon test --target js
```

Mooncakes 发布后可使用包管理安装。发布前请确认 `moon.mod` 中的 owner 与你的 Mooncakes 用户名一致，然后执行：

```bash
moon publish
```

发布成功后，使用对应包名安装，例如：

```bash
moon add Ridge-Lab/moonphaserkit
```

宿主网页需要安装 Phaser，并在加载 MoonBit 生成的 JavaScript 前暴露全局对象：

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
      ignore(scene.delayed_call(@moonphaserkit.DurationMs::seconds(1), () => {
        player.set_tint(0xffcc00)
      }))
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

打开 Vite 输出的本地地址后，使用方向键左、右、上进行移动和跳跃；在移动端视口可以点击画布触发跳跃。

## 验收命令

在提交或评审前建议依次执行：

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
npm install
npm run build
npm run smoke
```

其中 `npm run smoke` 会启动浏览器检查 Phaser canvas 是否出现、桌面和移动视口是否正常、键盘交互是否可触发，以及页面是否出现 console error 或 HTTP 错误。

## API 概览

| 类别 | 公开能力 |
| --- | --- |
| 游戏与场景 | `GameConfig`、`Game`、`Scene`，支持 Phaser 游戏创建、销毁和场景生命周期。 |
| 场景控制 | `SceneControlCommand`、`start_scene`、`launch_scene`、`pause_scene`、`resume_scene`、`stop_scene`、`sleep_scene`、`wake_scene`。 |
| 时间事件 | `TimerEventConfig`、`TimerEvent`、`delayed_call`、`add_timer_event`，支持延迟、重复和循环回调。 |
| 资源加载 | `ImageAsset`、`TextureAsset`、`SpriteSheetAsset`、`TextureAtlasAsset`、`AudioAsset`、`TilemapJsonAsset`、`BitmapFontAsset`。 |
| 显示对象 | `Sprite`、`Text`、`DisplayObjectOptions`、`TextStyle`、`SpawnSpec`，支持位置、缩放、透明度、层级、文字样式、显示和销毁。 |
| 动画 | `AnimationConfig`、`FrameRange`、`AnimationPlayOptions`、`TweenConfig`、`SpriteTween`。 |
| 音频 | `Sound`、`SoundOptions`、`SoundMarker`、`AudioFade`、`AudioBusState`。 |
| 输入 | `CursorKeys`、`Key`、`Pointer`、`PointerSnapshot`、`TouchZone`、`SwipeSnapshot`、`KeyBinding`。 |
| 物理与碰撞 | `ArcadeBody`、`Collider`、`PhysicsMaterial`、`TileCollisionRange`、`TilePropertyMatcher`。 |
| 相机 | `Camera`、`CameraBounds`、`CameraFollowOptions`、`CameraFadeOptions`、`CameraShakeOptions`、`CameraPanOptions`、`CameraZoomOptions`。 |
| Tilemap | `Tilemap`、`Tileset`、`TileLayer`、`TilemapConfig`、`TilesetConfig`、`TileLayerConfig`、`TileObject`、`TileSpawnPoint`。 |
| 工程支撑 | `RuntimeCompatibility`、`IntegrationChecklist`、`BrowserSmokeScenario`、`ErrorPathExpectation`、`FfiCallRecord`。 |

## 兼容性

- MoonBit：JavaScript 后端。
- Phaser：Demo 和 CI 固定 `3.90.0`；库内兼容性模型将 Phaser `3.60+` 标记为可支持窗口。
- 浏览器：现代 Chromium、Edge、Firefox、Safari。
- 音频：遵循浏览器用户手势解锁规则，实际项目建议在首次点击、触摸或键盘输入后播放音频。
- 宿主要求：运行 MoonBit 生成的 JavaScript 前必须设置 `globalThis.Phaser`。

## 文档

- [API 文档](docs/API.md)
- [API 示例](docs/API_EXAMPLES.md)
- [集成指南](docs/INTEGRATION.md)
- [测试说明](docs/TESTING.md)
- [提交检查](docs/SUBMISSION.md)
- [Roadmap](docs/ROADMAP.md)
- [Changelog](CHANGELOG.md)

## 仓库与参赛说明

- GitHub 仓库：https://github.com/Ridge-Lab/MoonPhaserKit.git
- GitLink 仓库：https://gitlink.org.cn/RidgeLab/MoonPhaserKit
- 项目性质：原创 MoonBit 生态绑定项目，不移植已有开源项目源码。
- 许可证：MIT。
