# 渠道与版本矩阵

> 组织标准：structure · monetize · playbook  
> 本仓特例：[`STRUCTURE.md`](STRUCTURE.md) · 技术方案：`roadmap/产品技术方案-typora-theme-2.1.md`  
> 公开面 = **策略 A**。拍板 **A1+B1+C1**（SkillPay 买断 ¥9.9；E1 前邮件过渡同一 paid zip；无按次）。  
> 双产物：`python3 scripts/bump_version.py --check`  
> 更新：2026-11-20（链接 / CTA 对齐 lite；废止微信收银主路径）

## 一、产品

| # | 产品 | slug | 许可 |
|---|---|---|---|
| 1 | 免费版 | `hekouwang-typora-theme-lite-skill` | MIT |
| 2 | 专业版 | `hekouwang-typora-theme-skill` | Proprietary |
| 3 | 按次 | — | 本期不做（C1） |

## 二、渠道矩阵

| 渠道 | 产品 | 包 / 源 | 价格 / 说明 | 线上状态 |
|---|---|---|---|---|
| GitHub / Pages | 免费版 | `origin` → `*-lite-skill`；Pages = **`docs/`** | MIT | 已上线 |
| ClawHub | 免费版 | `./scripts/pack-skill-zip.sh` → `dist/<v>/…-lite-skill-….zip` | 免费 | 随发版上传 |
| 腾讯 SkillHub（社区） | 免费版 | 同上 Lite zip（须剔无扩展名 LICENSE/VERSION、`docs/fonts/`） | 免费 | **2.0.3 已发** `@indiv-huiyonghkw/…-lite-skill` |
| 支付宝 SkillPay | 专业版 | `listing-skillpay.md` → `./scripts/pack.sh` → `dist/<v>/…-skill-…-paid.zip` | **¥9.9 买断** | E1 待上架 |
| 过渡交付（E1 前） | 专业版 | **同一** paid zip；CTA = 体验站 `#buy` → 邮件 | 同价 | 邮件过渡，**非**微信收银 |
| SkillHub 按次 | — | — | — | **不做**（C1） |

过渡句（三处须一致：本文件 / `docs/index.html` / README）：  
> 主 CTA 为支付宝 SkillPay。通道开放前如需专业版，邮件 `huiyonghkw@gmail.com` 交付同一 `dist/<version>/*-paid.zip`。微信仅人工答疑，不作为收银。

## 三、远程

| Remote | GitHub |
|---|---|
| `origin` | `huiyonghkw/hekouwang-typora-theme-lite-skill`（公开） |
| `paid` | `huiyonghkw/hekouwang-typora-theme-skill`（private，可选备份） |

## 四、`dist/<version>/`

目录内**默认只放 zip**（不对齐 SHA256SUMS / MANIFEST；校验结果写 `roadmap/evidence/`）：

- `hekouwang-typora-theme-lite-skill-<version>.zip`  
- `hekouwang-typora-theme-skill-<version>-paid.zip`（专业版 `SKILL.md` + unlock + 12 CSS）

## 五、发版摘要

1. bump → `--check`  
2. `build.py --tier free`（有 edition 时再 `--tier paid` 打 Pro 包）  
3. 对账 `listing-skillpay.md` ↔ 平台 ↔ 官网价  
4. `pack.sh` / `pack-skill-zip.sh` → 只写入 `dist/<version>/`  
5. `git push origin`（只推 Lite 面；勿把 `edition/` 推进 origin）  
6. SkillHub：`skillhub publish` Lite zip 或等价干净目录  
7. SkillPay：上传 paid zip（E1，本人）；回执放 `roadmap/evidence/`  
