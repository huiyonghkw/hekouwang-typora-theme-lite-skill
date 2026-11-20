# SkillPay 商品文案（仓库副本）

> 支付宝 SkillPay · **专业版买断**。ClawHub = 免费 Lite。  
> **本期不做** SkillHub 按次。  
> 改版本前先改本文件，再改平台，再上传包。不进安装包。

## 商品名称

会勇禾口王 · Typora 主题工程（专业版）

## 商品描述

```text
会勇禾口王 Typora 主题工程专业版：在免费 V2（MIT）之上，提供可安装的专业版 Agent Skill，并解锁 V1 / V2 Pro / V3–V6 共六套独立视觉（各含浅色与深色，12 个 CSS）。与免费版共享同一套阅读指标，付费档换的是色彩、材质与标题工艺。安装后可读 SKILL.md 做主题工程；包内 ./unlock.sh 装进 Typora。¥9.9 一次性买断，试用 0 次。个人使用禁止二次分发；不含本地许可证文件，权益以 SkillPay 履约为准。
```

## 补充介绍

1. **买到什么**：专业版 Skill + 付费色板/工艺 + 12 CSS + unlock。  
2. **怎么装**：SkillPay onboarding；Typora 见官网 unlock 说明。  
3. **授权**：`LICENSE-PRO.txt`；免费部分见 `LICENSE`（MIT）。  
4. **价格**：**¥9.9 买断**；试用 0。

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
2. 本文件 ↔ 平台描述 ↔ 官网价一致（均为买断 ¥9.9）  
3. `./scripts/pack.sh`；包内 `SKILL.md` 的 name 为 `hekouwang-typora-theme-skill`  
4. 上传后核对在售文件与价格  
