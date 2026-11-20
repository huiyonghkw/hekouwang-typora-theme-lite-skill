# materials/ · 货架与首发物料

> 原 `launch/`。可进主仓 git，**不得**进 Skill / ClawHub 安装包（见 `.clawhubignore`）。  
> 目录约定：[`STRUCTURE.md`](../STRUCTURE.md)

# hekouwang-typora-theme-skill · 工具首发包

- **体验站：** https://huiyonghkw.github.io/hekouwang-typora-theme-skill/
- **仓库：** https://github.com/huiyonghkw/hekouwang-typora-theme-skill
- **免费档：** Hekouwang / Hekouwang Dark（V2 编辑 · MIT）
- **付费档：** V1 / V3–V6 共六套皮肤（¥9.9 · zip 私发）

## 首发顺序（建议）

| 序 | 渠道 | 文件 | 谁能发 | 状态 |
|---|---|---|---|---|
| 1 | 阮一峰周刊 | `01-阮一峰周刊.md` | gh 代发 issue | ✅ [#11051](https://github.com/ruanyf/weekly/issues/11051) |
| 2 | V2EX 分享创造 | `02-V2EX分享创造.md` | 手工粘贴 | ⬜ |
| 3 | Typora Gallery | `08-Typora-Gallery提交.md` | 手工表单 | ⬜ |
| 4 | 知乎专栏 + 答题 | `03-知乎.md` | 手工 · 图须本地上传 | ⬜ |
| 5 | 掘金 | `07-掘金待发.md` | 手工 | ⬜ |
| 6 | Hacker News | `04-HackerNews待发.md` | 手工 · ⚠️ 先攒 karma | ⬜ |
| 7 | Product Hunt | `05-ProductHunt待发.md` | 手工 | ⬜ |
| 8 | Reddit | `06-Reddit待发.md` | 手工 | ⬜ |

## 共用截图（外链可用）

| 用途 | URL |
|---|---|
| 中文验收样张 | `https://raw.githubusercontent.com/huiyonghkw/hekouwang-typora-theme-skill/main/docs/screenshot-zh.png` |
| 整窗侧栏 | `https://raw.githubusercontent.com/huiyonghkw/hekouwang-typora-theme-skill/main/docs/screenshot-window.png` |
| 连续代码块 | `https://raw.githubusercontent.com/huiyonghkw/hekouwang-typora-theme-skill/main/docs/screenshot-fences-zh.png` |
| V1 科技 | `https://raw.githubusercontent.com/huiyonghkw/hekouwang-typora-theme-skill/main/docs/V1.png` |

知乎 / 掘金：**必须下载 PNG 本地上传**，外链会裂。

## 开发者社区铁律

见 memory `dev-community-lower-ai-tolerance`：V2EX / HN / 掘金比公众号多砍三刀——术语换白话、排比列表并段、对仗金句打散；**别拿「AI 写的 / Skill 驱动」当卖点**。

## 粘贴自检

```bash
pbcopy < "_基础设施/工具首发/hekouwang-typora-theme/02-V2EX分享创造.md"
# 只复制正文块
pbpaste | python3 -c "import sys;t=sys.stdin.read();print('破折号',t.count('——'));print('§',t.count('§'))"
```
