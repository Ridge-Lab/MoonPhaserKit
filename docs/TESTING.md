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
- 场景控制：start、launch、pause、resume、stop、sleep、wake 的命令模型。
- 时间事件：一次性、重复、循环 timer 配置和 Phaser repeat 映射。
- 文本 UI：`TextStyle` 预设、描边、背景、固定宽度和边界校验。
- 兼容性：Phaser 版本、MoonBit 后端、浏览器、集成清单。
- 诊断：验证问题、功能支持、FFI 调用记录和错误路径。

## 浏览器 Smoke Test

```bash
cd examples/moon-jumper-web
pnpm run smoke
```

测试会：

- 启动 Vite。
- 打开桌面和移动视口。
- 等待 Phaser canvas。
- 检查 canvas 尺寸和移动端不溢出。
- 模拟方向键移动和跳跃。
- 捕获页面错误、异常 HTTP 响应和 console error。

## E2E 场景模型

代码中新增 `BrowserSmokeScenario`、`InteractionStep`、`ErrorPathExpectation` 和 `InteractionScenarioSummary`，用于把验收场景表达成 MoonBit 模型。当前 JS smoke 脚本覆盖 canvas、桌面/移动视口、键盘/点击交互和错误捕获；这些模型用于把更多交互验收项固化到 MoonBit 测试与扩展自动化脚本中：

- 动画播放状态断言。
- 音频解锁后的播放断言。
- 指针点击和滑动手势。
- Tilemap 碰撞层。
- 相机 follow、shake、fade 效果。

## 提交前人工检查

- README 中的 GitHub、GitLink、Mooncakes 包名与实际账号一致。
- `moon.mod` 的 `repository` 指向公开 GitHub 仓库。
- GitHub 和 GitLink 均能看到 `README.md`、`moon.mod`、`docs`、`examples` 和核心 `.mbt` 文件。
- 提交记录为 10-20 个有效 commits，提交信息能反映真实工程演进。
- 仓库中没有 `node_modules`、`dist`、`_build` 或临时压缩包。

