#!/usr/bin/env bash
# ============================================================
# pack-skill-zip.sh — ClawHub / 平台用 Lite 瘦身包
#
#   ./scripts/pack-skill-zip.sh
#   ./scripts/pack-skill-zip.sh /path/to/out.zip
#
# 与根目录 .clawhubignore 对账；产物：
#   dist/<version>/hekouwang-typora-theme-lite-skill-<version>.zip
# ============================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IGNORE="$ROOT/.clawhubignore"
VER="$(tr -d '[:space:]' < "$ROOT/edition/VERSION" 2>/dev/null || tr -d '[:space:]' < "$ROOT/VERSION")"
DIST_DIR="$ROOT/dist/$VER"
DEFAULT_OUT="$DIST_DIR/hekouwang-typora-theme-lite-skill-${VER}.zip"
OUT="${1:-$DEFAULT_OUT}"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/hkw-typora-lite-pack.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT

g='\033[1;32m'; r='\033[1;31m'; b='\033[1;34m'; o='\033[0m'
ok()  { printf "  ${g}✓${o} %s\n" "$*"; }
bad() { printf "  ${r}✗${o} %s\n" "$*"; }

echo -e "${b}hekouwang · pack lite skill zip${o}"
echo "────────────────────────────────────────"

[ -f "$IGNORE" ] || { bad "缺少 .clawhubignore"; exit 1; }
[ -f "$ROOT/SKILL.md" ] || { bad "缺少 SKILL.md"; exit 1; }

TOP="hekouwang-typora-theme-lite-skill-$VER"
DEST="$STAGE/$TOP"
mkdir -p "$DEST"

# rsync：排除 .clawhubignore 中的模式；不跟 .git
RSYNC_EXCLUDES=()
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"
  line="$(echo "$line" | sed 's/[[:space:]]*$//;s/^[[:space:]]*//')"
  [ -z "$line" ] && continue
  RSYNC_EXCLUDES+=(--exclude="$line")
done < "$IGNORE"

rsync -a \
  --exclude='.git/' \
  --exclude='dist/' \
  --exclude='edition/' \
  --exclude='roadmap/' \
  --exclude='__pycache__/' \
  --exclude='*.pyc' \
  --exclude='.DS_Store' \
  "${RSYNC_EXCLUDES[@]}" \
  "$ROOT/" "$DEST/"

# 强制再剔（与标准铁律对账）
for p in materials listing-skillpay.md edition roadmap services dist archive \
  STRUCTURE.md RELEASE.md .clawhubignore .gitignore .github; do
  rm -rf "$DEST/$p"
done

# 维护者工具不进 ClawHub 包
for p in scripts/pack.sh scripts/pack-skill-zip.sh scripts/bump_version.py \
  scripts/unlock.sh scripts/shoot_previews.sh scripts/sync_preview.py; do
  rm -f "$DEST/$p"
done

[ -f "$DEST/SKILL.md" ] || { bad "包内缺 SKILL.md"; exit 1; }
[ -f "$DEST/_meta.json" ] || { bad "包内缺 _meta.json"; exit 1; }
[ ! -e "$DEST/materials" ] || { bad "包内不得含 materials/"; exit 1; }
[ ! -e "$DEST/edition" ] || { bad "包内不得含 edition/"; exit 1; }
[ ! -e "$DEST/listing-skillpay.md" ] || { bad "包内不得含 listing-skillpay.md"; exit 1; }
ok "舞台树就绪（已剔 materials/edition/listing/维护者脚本）"

mkdir -p "$DIST_DIR"
# 只保留当前版目录下的 zip；不清空同目录其他当前版产物（paid 可共存）
rm -f "$OUT"
(
  cd "$STAGE"
  zip -rq "$OUT" "$TOP"
)

python3 - "$OUT" "$TOP" <<'PY'
import sys, zipfile
out, top = sys.argv[1], sys.argv[2]
need = [f"{top}/SKILL.md", f"{top}/_meta.json", f"{top}/references/tokens.md"]
forbid_substr = ("/materials/", "/edition/", "/listing-skillpay.md", "/roadmap/")
z = zipfile.ZipFile(out)
if z.testzip():
    print("CORRUPT:", z.testzip())
    sys.exit(1)
names = z.namelist()
missing = [n for n in need if n not in names]
if missing:
    print("MISSING:", *missing, sep="\n  ")
    sys.exit(1)
leaked = [n for n in names if any(s in n for s in forbid_substr)]
if leaked:
    print("LEAKED:")
    for n in leaked[:20]:
        print(" ", n)
    sys.exit(1)
print(len(names), "entries; required ok; no leaks")
PY

ok "验包通过 → $OUT"
printf "  大小：%s\n" "$(du -h "$OUT" | cut -f1 | tr -d ' ')"
