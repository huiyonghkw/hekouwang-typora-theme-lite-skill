#!/usr/bin/env bash
#
# hekouwang · 打专业版 SkillPay zip（白名单：Lite 运行面 ∪ edition）
#
#   ./scripts/pack.sh                         # → dist/<version>/…-paid.zip
#   ./scripts/pack.sh /path/to/out.zip
#
# 包内 = Agent 专业版 Skill（SKILL.md name: *-skill）+ 付费 12 CSS + unlock。
# 禁止 materials / listing / roadmap / 密钥。
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/links.sh"

EDITION="$ROOT/edition"
EDITION_SCRIPTS="$EDITION/scripts"

PAID_CSS=(
  hekouwang-v1.css hekouwang-v1-dark.css
  hekouwang-v2-pro.css hekouwang-v2-pro-dark.css
  hekouwang-v3.css hekouwang-v3-dark.css
  hekouwang-v4.css hekouwang-v4-dark.css
  hekouwang-v5.css hekouwang-v5-dark.css
  hekouwang-v6.css hekouwang-v6-dark.css
)

# 主仓 Lite 白名单（运行面；非全集）
LITE_SCRIPTS=(
  build.py contrast_check.py test_contrast_check.py
  tokens.json palettes.json
  sample_colors.py
  verify_layout.py verify_export_pdf.py verify_render.py
  install.sh install-windows.ps1
  links.sh unlock.sh
)

if [ -f "$EDITION/VERSION" ]; then
  PACK_VERSION="$(tr -d '[:space:]' < "$EDITION/VERSION")"
else
  PACK_VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"
fi
DIST_DIR="$ROOT/dist/${PACK_VERSION}"
DEFAULT_OUT="${DIST_DIR}/hekouwang-typora-theme-skill-${PACK_VERSION}-paid.zip"
OUT="${1:-$DEFAULT_OUT}"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/hkw-typora-pack-stage.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT

g='\033[1;32m'; r='\033[1;31m'; b='\033[1;34m'; o='\033[0m'
ok()  { printf "  ${g}✓${o} %s\n" "$*"; }
bad() { printf "  ${r}✗${o} %s\n" "$*"; }

echo -e "${b}hekouwang · pack Pro skill (SkillPay)${o}"
echo "────────────────────────────────────────"

[ -f "$EDITION_SCRIPTS/palettes.paid.json" ] || { bad "缺少 edition/scripts/palettes.paid.json"; exit 1; }
[ -f "$EDITION_SCRIPTS/craft_paid.py" ] || { bad "缺少 edition/scripts/craft_paid.py"; exit 1; }
[ -f "$EDITION/LICENSE-PRO.txt" ] || { bad "缺少 edition/LICENSE-PRO.txt"; exit 1; }
[ -f "$EDITION/SKILL.paid-section.md" ] || { bad "缺少 edition/SKILL.paid-section.md"; exit 1; }
[ -f "$EDITION/meta.paid.json" ] || { bad "缺少 edition/meta.paid.json"; exit 1; }
[ -f "$ROOT/SKILL.md" ] || { bad "缺少根 SKILL.md"; exit 1; }
ok "edition + Lite 入口在位 (VERSION=${PACK_VERSION})"

echo "  building paid CSS…"
python3 "$SCRIPT_DIR/build.py" --tier paid
ok "build --tier paid"

TOP="hekouwang-typora-theme-skill-$PACK_VERSION"
DEST="$STAGE/$TOP"
mkdir -p "$DEST/theme" "$DEST/scripts" "$DEST/references"

# —— SKILL.md：Lite 正文改专业版 frontmatter + 拼接付费节 ——
python3 - "$ROOT/SKILL.md" "$EDITION/SKILL.paid-section.md" "$DEST/SKILL.md" "$PACK_VERSION" <<'PY'
import re, sys
lite_path, paid_path, out_path, ver = sys.argv[1:5]
text = open(lite_path, encoding="utf-8").read()
paid = open(paid_path, encoding="utf-8").read().strip() + "\n"
# frontmatter → 专业版
def sub_fm(key, value, s):
    return re.sub(rf"(?m)^{key}: .+$", f"{key}: {value}", s, count=1)
text = sub_fm("name", "hekouwang-typora-theme-skill", text)
text = sub_fm("slug", "hekouwang-typora-theme-skill", text)
text = sub_fm("displayName", "会勇禾口王 · Typora 主题工程", text)
text = sub_fm("license", "Proprietary", text)
text = sub_fm("version", ver, text)
text = sub_fm(
    "summary",
    "Typora theme engineering — free V2 + paid V1/V2 Pro/V3–V6 craft, unlock, contrast/layout audits.",
    text,
)
# 先改目录树专行，再做全局 edition/scripts → scripts（顺序不能反）
text = text.replace(
    "edition/scripts/         付费色板 + craft（本地仓；不进公开 git）",
    "scripts/palettes.paid.json / craft_paid.py   付费色板与工艺（本包）",
)
text = text.replace("本地 `edition/`（不进公开 git）", "本专业版包内 `scripts/`（付费色板与工艺）")
text = text.replace("edition/SKILL.paid-section.md", "下文「专业版增量」")
# 包内路径：付费源在 scripts/（无 edition/ 目录）
text = text.replace("edition/scripts/", "scripts/")
# 去掉 Lite 标题措辞
text = text.replace("# Typora 主题工程（Lite）", "# Typora 主题工程（专业版）", 1)
text = text.replace("**Lite** Skill 入口（`hekouwang-typora-theme-lite-skill`）",
                    "**专业版** Skill 入口（`hekouwang-typora-theme-skill`）", 1)
# 包内已含付费源：删掉 Lite「本仓不含付费」口径与仅公开仓才有的文档链
text = re.sub(
    r"(?m)^专业版六套走私有仓 / SkillPay zip（`hekouwang-typora-theme-skill`），本仓不含付费源码。\n?",
    "本包已含专业版色板/工艺与 12 个 CSS；用包内 `./unlock.sh` 装进 Typora。\n",
    text,
    count=1,
)
text = text.replace(
    "**授权：** Lite Skill 文本与免费主题 / 脚本均为 **MIT**（根 `LICENSE`；说明见 [LICENSE.txt](LICENSE.txt)）。",
    "**授权：** 免费主题与脚本为 **MIT**（根 `LICENSE`）；付费六套见 `LICENSE-PRO.txt`（个人使用，禁止二次分发）。",
)
text = text.replace("[`STRUCTURE.md`](STRUCTURE.md)", "仓库 STRUCTURE.md（公开仓）")
text = text.replace("[LICENSE.txt](LICENSE.txt)", "`LICENSE`（MIT）与 `LICENSE-PRO.txt`")
text = text.replace(
    "- **主题产物（本仓 · 免费）**：`theme/hekouwang.css` + `hekouwang-dark.css`（= V2 编辑）",
    "- **主题产物（本包）**：免费 V2 + 付费 V1/V2 Pro/V3–V6（见 `theme/`）",
)
text = text.replace(
    "- **付费六套**（V1/V2 Pro/V3–V6）：专业版 zip / 私有仓；`./scripts/unlock.sh 包.zip`。付费 V2 Pro ≠ 免费 V2。",
    "- **付费六套**：已在本包；`./unlock.sh` 或公开仓 `./scripts/unlock.sh 本zip`。付费 V2 Pro ≠ 免费 V2。",
)
text = text.replace(
    "python3 scripts/build.py                    # → 同 free（本仓无 edition）",
    "python3 scripts/build.py --tier paid         # → 付费 12 CSS（本包已含 craft）",
)
text = text.replace(
    "> **从 ClawHub / SkillHub 安装的**：平台包可能不含完整 `scripts/` 工作区。\n"
    "> 先 `git clone https://github.com/huiyonghkw/hekouwang-typora-theme-lite-skill.git`，下文命令均在仓库根执行。",
    "> **本 SkillPay 包**：解压后在包根执行；装 Typora 主题用 `./unlock.sh`。"
    " 需要完整公开工作区时可再 clone lite 仓。",
)
text = text.replace(
    "SKILL.md                 本文件（Lite 入口；仓库根）",
    "SKILL.md                 本文件（专业版入口；本包根）",
)
text = text.replace(
    "scripts/build.py         默认：有 edition 则 free+paid；公开 CI 用 --tier free",
    "scripts/build.py         本包用 --tier paid；公开 lite 仓默认 --tier free",
)
# 兜底：若全局替换已把目录行打残
text = text.replace(
    "scripts/         付费色板 + craft（本地仓；不进公开 git）",
    "scripts/palettes.paid.json / craft_paid.py   付费色板与工艺（本包）",
)
text = text.replace(
    "scripts/pack.sh          打专业版 zip → dist/<version>/…-paid.zip\n",
    "",
)
text = text.replace(
    "scripts/unlock.sh        买家装付费 zip；开发树同步回 edition/",
    "scripts/unlock.sh / ./unlock.sh   装付费 CSS 进 Typora",
)
text = text.replace(
    "docs/                    GitHub Pages\n"
    "materials/               本机运营物料（不入库、不进安装包）\n",
    "",
)
if not text.endswith("\n"):
    text += "\n"
text = text.rstrip() + "\n\n" + paid
open(out_path, "w", encoding="utf-8").write(text)
print("SKILL.md merged")
PY
ok "SKILL.md（专业版 frontmatter + 付费节）"

# _meta.json ← meta.paid.json
python3 - "$EDITION/meta.paid.json" "$DEST/_meta.json" "$PACK_VERSION" <<'PY'
import json, sys
src, dst, ver = sys.argv[1:4]
data = json.loads(open(src, encoding="utf-8").read())
data["version"] = ver
data["slug"] = "hekouwang-typora-theme-skill"
data["name"] = "hekouwang-typora-theme-skill"
data["displayName"] = "会勇禾口王 · Typora 主题工程"
open(dst, "w", encoding="utf-8").write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

cp "$EDITION/LICENSE-PRO.txt" "$DEST/LICENSE-PRO.txt"
# SkillPay：无扩展名 LICENSE = MIT（免费部分）；LICENSE.txt = 本包总览；LICENSE-PRO = 付费条款
cp "$ROOT/LICENSE" "$DEST/LICENSE"
cat > "$DEST/LICENSE.txt" <<'EOF'
Professional pack license overview
==================================

This SkillPay zip contains:

1. Free themes / build scripts / references — MIT (see root `LICENSE`)
2. Paid theme pack (V1 / V2 Pro / V3–V6 CSS + craft) — `LICENSE-PRO.txt`
   (personal use; no redistribution)

Purchasing this zip grants you the rights in LICENSE-PRO.txt for the paid
assets included here. The MIT grant for free parts remains unchanged.
EOF
cp "$EDITION/VERSION" "$DEST/VERSION"
cp "$SCRIPT_DIR/unlock.sh" "$DEST/unlock.sh"
chmod +x "$DEST/unlock.sh"

# references
cp "$ROOT/references/"*.md "$DEST/references/"

# Lite scripts 白名单
for f in "${LITE_SCRIPTS[@]}"; do
  [ -f "$SCRIPT_DIR/$f" ] || { bad "缺 scripts/$f"; exit 1; }
  cp "$SCRIPT_DIR/$f" "$DEST/scripts/$f"
done
# edition Pro 源 → 包内 scripts/
cp "$EDITION_SCRIPTS/palettes.paid.json" "$DEST/scripts/palettes.paid.json"
cp "$EDITION_SCRIPTS/craft_paid.py" "$DEST/scripts/craft_paid.py"
chmod +x "$DEST/scripts/install.sh" "$DEST/scripts/unlock.sh" 2>/dev/null || true

# 付费 CSS
for f in "${PAID_CSS[@]}"; do
  [ -f "$ROOT/theme/$f" ] || { bad "缺 theme/$f"; exit 1; }
  cp "$ROOT/theme/$f" "$DEST/theme/$f"
done
# 免费 V2 一并带上，方便买家本包自给自足装齐
for f in hekouwang.css hekouwang-dark.css; do
  [ -f "$ROOT/theme/$f" ] && cp "$ROOT/theme/$f" "$DEST/theme/$f"
done
# 随包字体（若有）
if [ -d "$ROOT/theme/hekouwang/fonts" ]; then
  mkdir -p "$DEST/theme/hekouwang"
  rsync -a --exclude='fonts-local' "$ROOT/theme/hekouwang/" "$DEST/theme/hekouwang/"
fi
ok "白名单拷贝完成（Lite 脚本 + edition + CSS）"

cat > "$DEST/README.txt" <<EOF
hekouwang Typora 主题工程 · 专业版 Skill
版本 $PACK_VERSION · ¥9.9 买断口径

本包是支付宝 SkillPay 交付的专业版 Skill（hekouwang-typora-theme-skill）：
- Agent：读 SKILL.md；付费色板在 scripts/palettes.paid.json
- Typora：跑 ./unlock.sh 安装 V1 / V2 Pro / V3–V6（各含 Dark，共 12 CSS）

Typora 安装
----------
图文：$HKW_URL_SITE#unlock

  ./unlock.sh
  # 或在已 clone 的公开仓：./scripts/unlock.sh /path/to/本zip

然后 Cmd+Q 完全退出 Typora，主题菜单选 Hekouwang V1 / V2 Pro / V3–V6。

免费 V2 也可：./scripts/install.sh（本包已含 hekouwang.css / Dark）。

授权：LICENSE-PRO.txt（个人使用，禁止二次分发）
免费主题与脚本条款见 LICENSE（MIT）
SkillPay：$HKW_URL_SKILLPAY
落地页说明：$HKW_URL_BUY
EOF
ok "README / 许可"

mkdir -p "$DIST_DIR"
find "$ROOT/dist" -mindepth 1 -maxdepth 1 ! -name "$PACK_VERSION" -exec rm -rf {} + 2>/dev/null || true
rm -f "$OUT"
(
  cd "$STAGE"
  zip -rq "$OUT" "$TOP"
)

python3 - "$OUT" "$TOP" "${PAID_CSS[@]}" <<'PY'
import sys, zipfile
out, top = sys.argv[1], sys.argv[2]
need = [
    f"{top}/SKILL.md",
    f"{top}/_meta.json",
    f"{top}/LICENSE-PRO.txt",
    f"{top}/VERSION",
    f"{top}/unlock.sh",
    f"{top}/README.txt",
    f"{top}/scripts/palettes.paid.json",
    f"{top}/scripts/craft_paid.py",
    f"{top}/scripts/build.py",
    f"{top}/references/tokens.md",
]
need += [f"{top}/theme/{n}" for n in sys.argv[3:]]
forbid = ("/materials/", "/listing-skillpay.md", "/roadmap/", "/.env", "/edition/")
z = zipfile.ZipFile(out)
if z.testzip():
    print("CORRUPT:", z.testzip())
    sys.exit(1)
names = z.namelist()
missing = [n for n in need if n not in names]
if missing:
    print("MISSING:")
    for m in missing:
        print(" ", m)
    sys.exit(1)
leaked = [n for n in names if any(s in n for s in forbid)]
if leaked:
    print("LEAKED:")
    for n in leaked[:20]:
        print(" ", n)
    sys.exit(1)
# frontmatter 必须是专业版名
skill = z.read(f"{top}/SKILL.md").decode("utf-8")
if "name: hekouwang-typora-theme-skill" not in skill.split("---", 2)[1]:
    print("SKILL frontmatter name is not Pro slug")
    sys.exit(1)
if "name: hekouwang-typora-theme-lite-skill" in skill.split("---", 2)[1]:
    print("SKILL still has lite name in frontmatter")
    sys.exit(1)
for bad in (
    "本仓不含付费源码",
    "本仓 · 免费",
    "专业版 zip / 私有仓",
    "本仓无 edition",
    "Lite 入口",
    "本地仓；不进公开 git",
    "does not include rights to the paid pack",
):
    if bad in skill:
        print(f"SKILL still has Lite wording: {bad!r}")
        sys.exit(1)
lic_txt = z.read(f"{top}/LICENSE.txt").decode("utf-8")
if "does not include rights to the paid pack" in lic_txt:
    print("LICENSE.txt still denies paid rights (Lite copy)")
    sys.exit(1)
if "LICENSE-PRO.txt" not in lic_txt:
    print("LICENSE.txt must mention LICENSE-PRO.txt")
    sys.exit(1)
if f"{top}/LICENSE.txt" not in names:
    print("MISSING LICENSE.txt")
    sys.exit(1)
print(len(need), "required ok; no leaks; Pro SKILL/LICENSE ok")
PY
ok "验包通过 → $OUT"
printf "\n${g}SkillPay：上传/更新此 zip → dist/<version>/${o}\n"
printf "  商品页：%s\n" "$HKW_URL_SKILLPAY"
printf "  大小：%s\n" "$(du -h "$OUT" | cut -f1 | tr -d ' ')"
printf "  ${b}上传后必查：${o}商品名称「会勇禾口王 · Typora 主题工程」；描述清空后只贴 listing-skillpay.md\n"
