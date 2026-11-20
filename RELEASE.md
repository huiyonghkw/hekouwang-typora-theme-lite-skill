# 渠道与版本矩阵

> 组织标准：structure · monetize · playbook  
> 本仓特例：[`STRUCTURE.md`](STRUCTURE.md) · 技术方案：`roadmap/产品技术方案-typora-theme-2.1.md`  
> 公开面 = **策略 A**。拍板 **A1+B1+C1**（SkillPay 买断 ¥9.9；E1 前保留私发；无按次）。  
> 双产物：`python3 scripts/bump_version.py --check`  
> 更新：2026-11-20（纠偏同构：origin = Lite 公开仓）

## 一、产品

| # | 产品 | slug | 许可 |
|---|---|---|---|
| 1 | 免费版 | `hekouwang-typora-theme-lite-skill` | MIT |
| 2 | 专业版 | `hekouwang-typora-theme-skill` | Proprietary |
| 3 | 按次 | — | 本期不做 |

## 二、渠道矩阵

| 渠道 | 产品 | 包 / 源 |
|---|---|---|
| GitHub / Pages | 免费版 | `origin` → `*-lite-skill`；Pages = **`docs/`** |
| ClawHub | 免费版 | `./scripts/pack-skill-zip.sh` → `dist/<v>/…-lite-skill-….zip` |
| 支付宝 SkillPay | 专业版 | `listing-skillpay.md` → `./scripts/pack.sh` → `dist/<v>/…-skill-…-paid.zip` |
| 私发（过渡至 E1） | 专业版 | 同一 paid zip；E1 过门后主 CTA 改 SkillPay（B1） |
| SkillHub 按次 | — | 本期不做（C1） |

## 三、远程

| Remote | GitHub |
|---|---|
| `origin` | `huiyonghkw/hekouwang-typora-theme-lite-skill`（公开） |
| `paid` | `huiyonghkw/hekouwang-typora-theme-skill`（private，可选备份） |

## 四、`dist/<version>/`

- `hekouwang-typora-theme-lite-skill-<version>.zip`  
- `hekouwang-typora-theme-skill-<version>-paid.zip`（含专业版 `SKILL.md` + unlock + 12 CSS）

## 五、发版摘要

1. bump → `--check`  
2. `build.py --tier free`（有 edition 时再 `--tier paid` 打 Pro 包）  
3. listing → `pack.sh` / `pack-skill-zip.sh`  
4. `git push origin`（只推 Lite 面；勿把 `edition/` 推进 origin）  
5. SkillPay：上传 paid zip（E1，本人）  
