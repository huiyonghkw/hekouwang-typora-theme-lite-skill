# SkillPay 商品文案（仓库副本）

> 支付宝 SkillPay · **专业版买断**。ClawHub / SkillHub 社区 = 免费 Lite。  
> **本期不做** SkillHub 按次。  
> 改版本前先改本文件，再改平台，再上传包。不进安装包。  
> 平台商品描述上限 **500 字**（去换行计）；上传包常把 `SKILL.md` 的 description **叠加上去**导致超长——上传后必须清空再粘贴。

## 商品名称

会勇禾口王 · Typora 主题工程

（统一用这一串；不要加「专业版」「hekouwang」后缀。包内 `name` 仍是 slug `hekouwang-typora-theme-skill`，上传后若被覆盖成英文，手动改回本名称。）

## 商品描述（131 字 · 上限 500）

```text
会勇禾口王 · Typora 主题工程：免费 V2 之上解锁 V1 / V2 Pro / V3–V6 六套视觉（浅深 12 个 CSS），含专业版 Skill 与 unlock。¥9.9 买断，试用 0。个人使用禁止二次分发；权益以 SkillPay 履约为准。
```

> **上传安装包会重置 / 叠加商品描述。** 每次上传后：清空描述框 → 只粘贴上面这段 → 确认右下角 `N/500` 未超限。  
> **商品名称也会被覆盖。** 上传后确认仍是「会勇禾口王 · Typora 主题工程」。

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
2. 本文件 ↔ 平台名称/描述/价一致  
3. `./scripts/pack.sh` → `dist/<version>/*-paid.zip`  
4. 上传后立刻：名称改回「会勇禾口王 · Typora 主题工程」；描述清空后只贴本文件正文  
5. 核对在售文件名含版本号与价格  
