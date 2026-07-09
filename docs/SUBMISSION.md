# Submission Checklist

本页用于比赛提交前自查。

## 仓库

- GitHub：https://github.com/Ridge-Lab/MoonPhaserKit
- GitLink：https://gitlink.org.cn/RidgeLab/MoonPhaserKit
- 两边仓库均应公开可访问。
- GitLink 应从 GitHub 镜像同步，提交后确认最新 commit 一致。
- 提交记录保持 10-20 个有效 commits，不使用空提交、重复提交或无意义拆分。

## 项目内容

- `moon.mod` 的 `repository` 指向真实 GitHub 仓库。
- `moon.mod` 的 owner 应与实际 Mooncakes 用户名一致。
- README 说明项目目标、安装方式、Demo 运行方式、API 范围、兼容性和验收命令。
- `docs` 中包含 API、集成、测试、提交和 Roadmap 文档。
- `examples/moon-jumper-web` 可以本地构建并运行。

## 验收命令

```bash
moon check --target js
moon test --target js
cd examples/moon-jumper-web
npm install
npm run build
npm run smoke
```

## 不应上传

- `node_modules`
- `dist`
- `_build`
- `.mooncakes`
- 临时 zip 压缩包
- 本地日志文件

这些文件已写入 `.gitignore`。

## Mooncakes

发布前确认：

```text
name = "Ridge-Lab/moonphaserkit"
repository = "https://github.com/Ridge-Lab/MoonPhaserKit.git"
license = "MIT"
preferred_target = "js"
```

如果你的 Mooncakes 用户名不是 `Ridge-Lab`，请把 `name` 中 `/` 前面的 owner 改成真实 Mooncakes 用户名后再执行：

```bash
moon publish
```

## 申报材料

项目申报 PDF 可单独上传，不需要放进代码仓库。推荐提交：

- GitHub 仓库链接
- GitLink 仓库链接
- 一页 PDF 申报书
- Mooncakes 包地址，发布后填写
