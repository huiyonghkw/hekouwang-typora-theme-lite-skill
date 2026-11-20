# 06 · Reddit · 待发

- **代发：** ❌ 必须各 sub 账号
- **策略：** 一 sub 一帖，文案微调，别 copy-paste 完全相同（spam 判定）

## r/typora（首选）

**Title:**
```
I made a Typora theme for long Chinese writing sessions (fixed 1rem / 1.65 / 52em metrics)
```

**Body:**
```
GitHub: https://github.com/huiyonghkw/hekouwang-typora-theme-skill

I write long Markdown in Chinese daily. Most themes feel like chat bubbles once paragraphs get dense — tight leading, random measure.

This one locks three reading metrics first, generates CSS from tokens (build fails on any !important), and ships ~100KB Inter instead of a 24MB font bundle.

Free MIT tier: Hekouwang / Hekouwang Dark (warm paper on #write, sidebar chrome included).

Typora quirk worth knowing: after editing CSS you must fully quit the app (Cmd+Q), not just switch themes.

Screenshots in README. macOS only for now.
```

## r/macapps

**Title:**
```
Typora theme for long-form Chinese — token-built, 0 !important, small font bundle
```

**Body:** 同上，加一句「macOS tested, designed around PingFang + Inter pairing」。

## r/Markdown

**Title:**
```
Theme for people who write long Chinese docs in Typora
```

**Body:** 弱化「主题工程」，强调阅读指标和 Gallery Claude Theme 数字对照（397 !important vs 0）。

## 回复模板

```
Thanks — the reload issue is real: Typora won't hot-reload CSS on theme switch, only on full restart. install.sh copies into Typora's theme folder; after that Cmd+Q is mandatory.
```
