# 渠道与版本矩阵

> 组织标准：structure · monetize · playbook  
> 本仓特例：[`STRUCTURE.md`](STRUCTURE.md) · 技术方案：`roadmap/产品技术方案-typora-theme-2.1.md`  
> 公开面 = **策略 A**。拍板 **A1+B1+C1**（SkillPay 买断 ¥9.9；无按次）。  
> 双产物：`python3 scripts/bump_version.py --check`  
> 更新：2026-11-24（**2.0.4**：SkillPay / SkillHub / ClawHub 均已审过发布）

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
| ClawHub | 免费版 | `./scripts/pack-skill-zip.sh` → `dist/<v>/…-lite-skill-….zip` | 免费 | **2.0.4 已审过** [详情页](https://clawhub.ai/huiyonghkw/skills/hekouwang-typora-theme-lite-skill) |
| 腾讯 SkillHub（社区） | 免费版 | 同上 Lite zip | 免费 | **2.0.4 已审过** [详情页](https://skillhub.cn/skills/indiv-huiyonghkw/hekouwang-typora-theme-lite-skill) |
| 支付宝 SkillPay | 专业版 | `listing-skillpay.md` → `./scripts/pack.sh` → `dist/<v>/…-paid.zip` | **¥9.9 买断** | **2.0.4 已审过发布** |
| SkillHub 按次 | — | — | — | **不做**（C1） |

SkillPay 商品深链（真源亦见 `scripts/links.sh` → `HKW_URL_SKILLPAY`）：  
https://skillpay.alipay.com/shelf/product?productId=P0806000213890180&merchantCode=huiyonghkw  

商品名：**会勇禾口王 · Typora 主题工程**。官网 `#buy` CTA 直达本链。

## 三、远程

| Remote | GitHub |
|---|---|
| `origin` | `huiyonghkw/hekouwang-typora-theme-lite-skill`（公开） |
| `paid` | `huiyonghkw/hekouwang-typora-theme-skill`（private，可选备份） |

## 四、`dist/<version>/`

目录内**默认只放 zip**（校验结果写 `roadmap/evidence/`）：

- `hekouwang-typora-theme-lite-skill-<version>.zip`  
- `hekouwang-typora-theme-skill-<version>-paid.zip`

## 五、发版摘要

1. bump → `--check`  
2. `build.py --tier free`（有 edition 时再 `--tier paid`）  
3. 对账 `listing-skillpay.md` ↔ 平台 ↔ 官网价  
4. `pack.sh` / `pack-skill-zip.sh` → `dist/<version>/`  
5. `git push origin`  
6. SkillHub：publish Lite（同 version 不重复发）  
7. SkillPay：上传 / 更新 paid zip；回执 `roadmap/evidence/`  
