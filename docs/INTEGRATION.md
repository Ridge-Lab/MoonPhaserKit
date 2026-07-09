# Integration Guide

本指南说明如何把 MoonPhaserKit 接入一个 Vite + Phaser 3 网页项目。

## 1. 准备依赖

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
npm install
```

Demo 固定使用 Phaser `3.90.0`。如果在新项目里集成，建议先使用相同版本，确认通过后再升级。

如果通过源码方式验收，直接使用仓库根目录即可；如果通过 Mooncakes 安装，请先确认 `moon.mod` 中的 owner 与你的 Mooncakes 用户名一致，并完成 `moon publish`。

## 2. 暴露 Phaser

MoonBit JS 产物通过 FFI 调用 `globalThis.Phaser`：

```js
import Phaser from "phaser";

globalThis.Phaser = Phaser;
await import("./generated/moon-jumper.js");
```

没有这一步时，`Game::create` 会抛出运行时错误。

## 3. 组织资源

推荐按资源类型拆分目录：

```text
public/
  assets/
    player.svg
    hero-run.png
    jump.ogg
  maps/
    level1.json
```

然后在 MoonBit 的 `preload` 回调里声明：

```moonbit
scene.load_image(ImageAsset::new("player", "/assets/player.svg"))
scene.load_spritesheet(SpriteSheetAsset::new("hero-run", "/assets/hero-run.png", 32, 48))
scene.load_audio(AudioAsset::new("jump", "/assets/jump.ogg"))
scene.load_tilemap_json(TilemapJsonAsset::new("level1", "/maps/level1.json"))
```

## 4. 构建 MoonBit JS

示例项目通过 `examples/moon-jumper-web/scripts/build-moonbit.mjs` 调用 MoonBit 工具链，把示例入口编译到 `src/generated/moon-jumper.js`。新项目可以复用这个思路：

```bash
moon build --target js
```

## 5. 验收

建议每次提交前执行：

```bash
moon check --target js
moon test --target js
npm run build
npm run smoke
```

`npm run smoke` 会启动浏览器，确认 canvas 出现、桌面和移动视口不溢出、键盘交互可触发、页面无明显运行时错误。

## 6. 常见接入问题

### 找不到 Phaser

确认加载 MoonBit 生成的 JS 前已经执行：

```js
globalThis.Phaser = Phaser;
```

### 音频没有播放

浏览器通常要求用户先点击、触摸或按键，音频才能播放。建议在首次输入事件后调用 `Sound::play()`。

### 场景切换后状态没有重置

如果需要完全重开当前场景，使用 `scene.restart()`；如果切到另一个关卡，使用 `scene.start_scene("level-2")`；如果只是打开暂停菜单，使用 `scene.launch_scene("pause-menu")` 并暂停原场景。

### Demo 页面空白

先执行：

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
npm run build
```

如果仍为空白，检查浏览器控制台是否有资源路径错误或 `globalThis.Phaser` 未设置。

## 7. 兼容性

- MoonBit 后端：JavaScript。
- Phaser：Demo 锁定 `3.90.0`，代码兼容目标为 Phaser 3.60+。
- 浏览器：现代 Chromium、Edge、Firefox、Safari。
- 音频：遵循浏览器用户手势解锁规则。

