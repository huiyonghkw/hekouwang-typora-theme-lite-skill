# 目录结构（本仓库特例）

> 组织标准（目录）：`~/.user-agents/standards/hekouwang-skill-structure.md`  
> 付费化口径：`~/.user-agents/standards/hekouwang-skill-monetize.md`  
> 迁移执行手册：`~/.user-agents/standards/hekouwang-skill-monetize-playbook.md`  
> 本文件只写本仓特例与成熟度档位。渠道 × 版本见 [`RELEASE.md`](RELEASE.md)。  
> 公开面策略：**A. Lite 引流**。版本同号：根 `VERSION` ↔ `edition/VERSION` ↔ `SKILL.md` / `_meta.json` / `edition/meta.paid.json`（`bump_version.py --check`）。  
> 更新：2026-11-20（纠偏：与 terminal/writer 同构；废除旁路 lite 工作树）

---

## 成熟度

| 档 | 本仓状态 |
|---|---|
| **现况** | **L3** + 付费化 **E0**：主仓 = Lite；Pro ∈ `edition/`；白名单 Pro **Skill** 包（`pack.sh`）；Lite ClawHub 包；bump；`dist/<version>/`；日常 **`git push origin`**；Pages = 公开仓 **`docs/`** |

---

## 命名

| 版本 | 命名 | 交付 |
|---|---|---|
| 专业版 | `hekouwang-typora-theme-skill` | `dist/<version>/…-paid.zip` / SkillPay |
| 免费版 | `hekouwang-typora-theme-lite-skill` | GitHub + Pages + ClawHub |

根 `SKILL.md` = Lite（MIT）；`edition/SKILL.paid-section.md` = Pro 增补（`pack.sh` 拼接）。

---

## 目录树

```text
hekouwang-typora-theme-skill/   # 本机开发家；origin = 公开 Lite
├── SKILL.md · _meta.json       Lite（name: *-lite-skill）
├── scripts/ · references/ · theme/ · demo/
├── docs/                       GitHub Pages（含付费档预览图，引流用，非 Pro 源码）
├── materials/ · listing-skillpay.md
├── RELEASE.md · STRUCTURE.md · .clawhubignore
├── VERSION                     = edition/VERSION
├── edition/                    本地仓：Pro 增量（无公开远程）
├── roadmap/                    本地仓：升级与作战地图
├── services/README.md
└── dist/<version>/             不版控；Lite zip + Pro paid zip
```

```text
专业版 zip  =  主仓（Lite）  ∪  edition/
免费版/公开 =  主仓本身（git push origin → *-lite-skill；Pages = docs/）
```

**不再使用 `public/` worktree。**  
**不另开本机旁路目录 `hekouwang-typora-theme-lite-skill/`。**

---

## 推送

| Remote | 用途 |
|---|---|
| `origin` | 公开 Lite：`hekouwang-typora-theme-lite-skill`；**日常 `git push origin`** |
| `paid` | 可选；专业版仓 `hekouwang-typora-theme-skill`（private / 备份），**不要**把 Pro 源推进 `origin` |

禁止给 `edition/`、`roadmap/` 加公开远程。

---

## 导出与打包

| 命令 | 作用 |
|---|---|
| `python3 scripts/bump_version.py --check` | 双产物同号门 |
| `python3 scripts/build.py --tier free\|paid` | 构建 CSS |
| `./scripts/pack.sh` | Pro → `dist/<version>/…-skill-…-paid.zip` |
| `./scripts/pack-skill-zip.sh` | Lite → `dist/<version>/…-lite-skill-….zip` |
| `./scripts/unlock.sh <zip>` | 装付费包；开发树可同步回 `edition/` |

---

## 禁止

- 免费版与专业版同名  
- 给 `edition/`、`roadmap/` 加公开远程  
- 把「必选 `public/`」或「旁路 lite 工作树」写回本仓流程  
- `materials/` / listing 进 Skill/ClawHub 包  
- 把 Pro 源提交进 `origin`（公开 Lite）  
