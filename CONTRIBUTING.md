# Contributing

MoonPhaserKit 优先保持小而稳定的 Phaser 3 绑定面。新增功能建议遵循以下原则：

- 优先覆盖 2D 网页游戏常用链路。
- 优先支持 MoonBit JavaScript 后端。
- 不把 Phaser JavaScript API 原样全部搬进来。
- 每个新增模型都应有 MoonBit 测试。
- 新增 FFI 方法应在 README 或 `docs/API.md` 中出现对应说明。

## 本地检查

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
corepack enable
pnpm install --frozen-lockfile
pnpm run build
pnpm run smoke
```

## 提交信息

推荐使用能说明真实工程变化的提交信息，例如：

- `feat: add timer event bindings`
- `test: cover text style validation`
- `docs: expand integration guide`

不要使用空提交、重复提交或无意义拆分来凑提交数。
