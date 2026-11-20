# SkillPay 商品文案（仓库副本）

> 支付宝 SkillPay · **专业版买断 · 已过审上架**。ClawHub / SkillHub 社区 = 免费 Lite。  
> **本期不做** SkillHub 按次。  
> 改版本前先改本文件，再改平台，再上传包。不进安装包。  
> 平台商品描述上限 **500 字**（去换行计）；上传包常把 `SKILL.md` 的 description **叠加上去**导致超长——上传后必须清空再粘贴。  
> **商品页：** https://skillpay.alipay.com/shelf/product?productId=P0806000213890180&merchantCode=huiyonghkw

## 商品名称

会勇禾口王 · Typora 主题工程

（统一用这一串；不要加「专业版」「hekouwang」后缀。包内 `name` 仍是 slug `hekouwang-typora-theme-skill`，上传后若被覆盖成英文，手动改回本名称。）

## 商品描述（131 字 · 上限 500）

```text
会勇禾口王 · Typora 主题工程：免费 V2 之上解锁 V1 / V2 Pro / V3–V6 六套视觉（浅深 12 个 CSS），含专业版 Skill 与 unlock。¥9.9 买断，试用 0。个人使用禁止二次分发；权益以 SkillPay 履约为准。
```

> **上传安装包会重置 / 叠加商品描述。** 每次上传后：清空描述框 → 只粘贴上面这段 → 确认右下角 `N/500` 未超限。  
> **商品名称也会被覆盖。** 上传后确认仍是「会勇禾口王 · Typora 主题工程」。

## 补充商品介绍（最多 4 条：建议 3 文字 + 1 图片）

平台弹窗规则：最多 4 条；文字每条 500 字；图片 PNG / JPG / WebP，单张不超过 5 MB。  
只补「补充介绍」时**不要重传安装包**；提交后会再审一次，审核期商品仍按当前线上版展示。

### 材料 1 · 文字（255 字）

```text
会勇禾口王 · Typora 主题工程解决的是中文长文连读不累：正文 1rem、行高 1.65、阅读列 48–96rem，层级靠字号与留白而不是彩条。免费 V2（Hekouwang / Dark，MIT）已是完整主题；专业版在同一套阅读指标上另给 V1 / V2 Pro / V3–V6 六套独立视觉（各含浅色与深色，共 12 个 CSS），换的是色彩、材质与标题工艺，不是功能阉割。包内含专业版 Agent Skill 与 unlock.sh，装进 Typora 后主题菜单选对应 Hekouwang Vn。
```

### 材料 2 · 图片（优先 · 官网首屏）

`materials/skillpay/02-site-hero-2880x2000.jpg`

体验站首屏截图（2880×2000，约 259 KB）：标题、买断价、真机预览入口。来源：`https://huiyonghkw.github.io/hekouwang-typora-theme-lite-skill/`

备选（主题四格对比）：`materials/skillpay/01-themes-2880x2000.png`（约 911 KB）。只能占一个图片位，优先官网首屏。

### 材料 3 · 文字（224 字）

```text
六套气质对应不同文类：V1 石墨青绿偏技术文档，V2 Pro 典藏编辑偏随笔评论，V3 财经偏表格复盘，V4 玻璃偏轻量规划，V5 HUD 偏方案演示，V6 焰彩偏创作手稿。免费与专业版共用 tokens 阅读指标；构建强制对比度审计与零滥用 !important。Windows 有独立字栈（微软雅黑 UI / Cascadia）。需要窄阅读列可在主题目录用 hekouwang.user.css 覆盖 --hk-reading-measure。
```

### 材料 4 · 文字（259 字）

```text
安装：SkillPay 履约拿到 paid zip 后按包内 SKILL.md / unlock.sh 装进 Typora 主题目录，完全退出并重开后选 Hekouwang V1…V6。免费 V2 可先 clone 公开仓 hekouwang-typora-theme-lite-skill 跑 ./scripts/install.sh。售卖为 ¥9.9 一次性买断，试用 0 次；个人使用禁止二次分发，权益以 SkillPay 履约为准。不含后端、密钥或本地许可证校验。不适合只想要一张静态配色、或不写中文长文的人。
```

## 售卖设定

| 项 | 值 |
|---|---|
| 售卖模式 | **一次性买断** |
| 价格 | **¥9.9** |
| 免费试用 | 0 |
| 交付物 | `dist/<version>/hekouwang-typora-theme-skill-<version>-paid.zip` |
| 许可 | Proprietary（`LICENSE-PRO.txt`） |

## 发版核对

1. `bump_version.py --check`  
2. 本文件 ↔ 平台名称/描述/价一致  
3. `./scripts/pack.sh` → `dist/<version>/*-paid.zip`  
4. 上传后立刻：名称改回「会勇禾口王 · Typora 主题工程」；描述清空后只贴本文件正文  
5. 补充材料：按上序粘贴 3 段文字 + 上传 `02-site-hero-*.jpg` → 提交审核  
6. 核对在售文件名含版本号与价格  
