# Testing

MoonPhaserKit 的测试分为三层。

## MoonBit 单元测试

```bash
moon test --target js
```

当前覆盖：

- 基础配置：`GameConfig`、`SpriteOptions`、`Velocity`。
- 资源描述：图片、Spritesheet、Atlas、音频、Tilemap JSON、BitmapFont。
- 动画：帧范围、循环语义、播放选项、Tween、状态快照。
- 音频：音量、循环、marker、fade、bus。
- 相机：bounds、follow、fade、shake、pan、zoom。
- 输入：键盘、触控区域、指针快照、滑动方向、动作绑定。
- Tilemap：地图配置、Tileset、Layer、碰撞范围、属性匹配。
- 场景对象：显示配置、物理材质、层级、生成规格、场景切换。
- 兼容性：Phaser 版本、MoonBit 后端、浏览器、集成清单。
- 诊断：验证问题、功能支持、FFI 调用记录和错误路径。

## 浏览器 Smoke Test

```bash
cd examples/moon-jumper-web
npm run smoke
```

测试会：

- 启动 Vite。
- 打开桌面和移动视口。
- 等待 Phaser canvas。
- 检查 canvas 尺寸和移动端不溢出。
- 模拟方向键移动和跳跃。
- 捕获页面错误、异常 HTTP 响应和 console error。

## 后续 E2E 扩展

代码中新增 `BrowserSmokeScenario`、`InteractionStep`、`ErrorPathExpectation` 和 `InteractionScenarioSummary`，用于把验收场景表达成 MoonBit 模型。后续可以把这些模型导出给 JS 测试脚本，扩展到：

- 动画播放状态断言。
- 音频解锁后的播放断言。
- 指针点击和滑动手势。
- Tilemap 碰撞层。
- 相机 follow、shake、fade 效果。

