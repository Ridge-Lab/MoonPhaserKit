# MoonPhaserKit

MoonPhaserKit 是一个面向 MoonBit JavaScript 后端的 Phaser 3 轻量绑定包，目标是让开发者用 MoonBit 编写 2D 网页游戏核心逻辑，并复用 Phaser 成熟的浏览器运行时。

项目为 2026 MoonBit 国产基础软件生态开源大赛准备。它的重点不是“做一个小游戏”，而是补齐 MoonBit Web 游戏生态中的 2D 游戏开发绑定能力；示例游戏 Moon Jumper 用于验证和展示绑定链路。

## 项目状态

- 目标后端：MoonBit JavaScript 后端。
- Demo 运行时：Phaser `3.90.0`。
- v1 范围：场景、图片加载、物理精灵、静态平台、文字、方向键输入、Arcade Physics 碰撞与 overlap 回调。
- 暂不支持：Phaser 4、原生桌面/移动端、Godot、Cocos、Unity、Unreal、音频、粒子、复杂地图编辑器。

## 安装

发布到 Mooncakes 后可使用：

```bash
moon add moonphaserkit/moonphaserkit
```

本地开发和检查：

```bash
moon check --target js
moon test --target js
```

## 最小示例

```moonbit
fn main {
  let config = @moonphaserkit.GameConfig::new(parent="game")
  ignore(@moonphaserkit.Game::create(
    config,
    scene => scene.load_image(@moonphaserkit.ImageAsset::new("player", "/assets/player.svg")),
    scene => {
      let player = scene.add_sprite(120.0, 220.0, "player")
      player.apply_options(@moonphaserkit.SpriteOptions::new(collide_world_bounds=true))
    },
    _scene => (),
  ))
}
```

宿主网页需要先加载 Phaser 3，并在运行 MoonBit JavaScript 产物前暴露 `globalThis.Phaser`。

```js
import Phaser from "phaser";

globalThis.Phaser = Phaser;
await import("./generated/moon-jumper.js");
```

## 运行 Demo

示例游戏名为 Moon Jumper，是一个平台跳跃收集小游戏。游戏逻辑由 MoonBit 编写，网页宿主由 Vite 和 Phaser 提供，素材为自制 SVG。

```bash
cd examples/moon-jumper-web
npm install
npm run dev
```

如果本机没有把 MoonBit 工具链加入 PATH，请先设置 `MOON_HOME`。PowerShell 示例：

```powershell
$env:MOON_HOME="C:\path\to\moon"
npm run dev
```

打开 Vite 输出的本地地址后，使用方向键左、右、上进行移动和跳跃。

## API 概览

| 类型 | 作用 |
| --- | --- |
| `GameConfig` | 配置画布、尺寸、背景色、重力和调试选项。 |
| `Game` | 创建和销毁 Phaser 游戏实例。 |
| `Scene` | 加载图片、创建精灵/文字、注册碰撞和 overlap。 |
| `Sprite` | 封装 Arcade Physics 精灵及常用生命周期操作。 |
| `Text` | 更新 Phaser 文本对象。 |
| `CursorKeys` / `Key` | 读取方向键输入状态。 |
| `Collider` | 表示 collider 或 overlap 注册结果。 |
| `ArcadeBody` | 设置速度、重力、弹性、世界边界、不可移动状态和落地检测。 |

## 设计边界

MoonPhaserKit v1 不试图完整复刻 Phaser 的 JavaScript API，而是聚焦一条小型 2D 网页游戏的完整链路：创建游戏、加载素材、创建对象、处理输入、设置物理属性、注册碰撞回调、更新文字和销毁对象。

这种克制的范围让 API 更容易学习、测试和展示，也更适合作为 MoonBit Web 游戏生态的基础包起点。

## 工程质量

项目包含：

- MoonBit 核心包和公开接口文件。
- Moon Jumper 可运行网页 Demo。
- 单元测试与白盒测试。
- API 文档和 Roadmap。
- GitHub Actions CI，覆盖 MoonBit 检查/测试、前端构建和浏览器 smoke test。

## 仓库与参赛说明

- GitHub 仓库：https://github.com/Ridge-Lab/MoonPhaserKit.git
- GitLink 仓库：https://gitlink.org.cn/RidgeLab/MoonPhaserKit
- 项目性质：原创 MoonBit 生态绑定项目，不移植已有开源项目源码。
- 许可证：MIT。
- 申报阶段已提供源码、README、示例、文档、测试和 CI 配置；提交记录按大赛要求保持为 10-20 个有效 commits。
- Mooncakes 发布属于后续包发布事项，完成 Mooncakes 账号确认后执行 `moon publish`。
