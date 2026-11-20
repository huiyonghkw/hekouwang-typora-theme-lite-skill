#!/usr/bin/env bash
# ============================================================
# 验收样张 · 16 节格式实拍（官网「支持的格式」板块）
#
# 用法：./scripts/shoot_formats.sh [输出目录]
# 默认输出到 docs/previews/r/formats/f01.webp … f16.webp
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="${1:-$ROOT/docs/previews/r/formats}"
DEMO_SRC="$ROOT/demo"
SAMPLE_NAME="验收样张.md"
PREF="abnerworks.Typora"
THEME_DIR="$HOME/Library/Application Support/abnerworks.Typora/themes"
SCALE=2
PLACE_X=40
PLACE_Y=72
PLACE_W=960
PLACE_H=577

ok()  { printf '\033[38;2;55;141;239m  ✅ %s\033[0m\n' "$*"; }
bad() { printf '  ❌ %s\n' "$*"; }

[ -f "$DEMO_SRC/$SAMPLE_NAME" ] || { bad "找不到 $DEMO_SRC/$SAMPLE_NAME"; exit 1; }
[ -f "$THEME_DIR/hekouwang.css" ] || { bad "未安装免费 V2：$THEME_DIR/hekouwang.css"; exit 1; }
mkdir -p "$OUT_DIR"

WORK_PARENT="$(mktemp -d -t hekouwang-formats)"
WORK="$WORK_PARENT/demo"
cleanup() { rm -rf "$WORK_PARENT"; }
trap cleanup EXIT INT TERM
mkdir -p "$WORK"
cp -R "$DEMO_SRC/." "$WORK/"
SAMPLE="$WORK/$SAMPLE_NAME"

# slug|查找串|展示短名
FORMATS=(
  "01|一、正文与中英混排|正文与中英混排"
  "02|二、引用|引用"
  "03|三、列表|列表"
  "04|四、代码|代码"
  "05|五、表格|表格"
  "06|六、数学公式|数学公式"
  "07|七、图表|Mermaid 图表"
  "08|八、Callout|Callout 提示块"
  "09|九、分隔线|分隔线与其他"
  "10|十、定稿截图|定稿截图"
  "11|十一、验收清单|验收清单"
  "12|十二、宽屏长文|宽屏长文"
  "13|十三、句中图片|图片与长链接"
  "14|十四、十二列表格|十二列表格"
  "15|十五、超过 200|超长单行代码"
  "16|十六、模式与导出|模式与导出矩阵"
)

defaults write "$PREF" theme -string "Hekouwang"
defaults write "$PREF" useSeparateDarkTheme -bool true
defaults write "$PREF" useDarkTheme -bool false
defaults write "$PREF" darkTheme -string "Hekouwang"

osascript -e 'tell application "Typora" to quit' >/dev/null 2>&1
sleep 2
pkill -x Typora >/dev/null 2>&1
sleep 1
open -a Typora "$WORK"
sleep 2
open -a Typora "$SAMPLE"
sleep 6

osascript <<APPLESCRIPT >/dev/null 2>&1
tell application "System Events" to tell process "Typora"
  set frontmost to true
  delay 0.4
  set position of front window to {$PLACE_X, $PLACE_Y}
  set size of front window to {$PLACE_W, $PLACE_H}
end tell
APPLESCRIPT
sleep 1.5

typora_window_id() {
  swift -e '
import Cocoa
let opts = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
guard let info = CGWindowListCopyWindowInfo(opts, kCGNullWindowID) as? [[String: Any]] else { exit(1) }
var bestId = 0
var bestArea: Double = 0
for w in info {
  let owner = w[kCGWindowOwnerName as String] as? String ?? ""
  guard owner == "Typora" else { continue }
  let bounds = w[kCGWindowBounds as String] as? [String: Any] ?? [:]
  let width = (bounds["Width"] as? NSNumber)?.doubleValue ?? 0
  let height = (bounds["Height"] as? NSNumber)?.doubleValue ?? 0
  let area = width * height
  let layer = w[kCGWindowLayer as String] as? Int ?? 0
  guard layer == 0, area > bestArea else { continue }
  bestArea = area
  bestId = w[kCGWindowNumber as String] as? Int ?? 0
}
if bestId == 0 { exit(1) }
print(bestId)
' 2>/dev/null
}

jump_heading() {
  local query="$1"
  osascript <<EOF >/dev/null 2>&1
tell application "Typora" to activate
delay 0.2
tell application "System Events" to tell process "Typora"
  set frontmost to true
  keystroke "f" using {command down}
  delay 0.35
  keystroke "a" using {command down}
  delay 0.1
  keystroke "$query"
  delay 0.35
  keystroke return
  delay 0.45
  key code 53
  delay 0.35
end tell
EOF
}

echo "hekouwang · 16 节格式实拍"
echo "────────────────────────────────────────"

for entry in "${FORMATS[@]}"; do
  IFS='|' read -r num query label <<< "$entry"
  echo "▸ $num  $label"
  jump_heading "$query"
  wid="$(typora_window_id || true)"
  if [ -z "$wid" ] || [ "$wid" = "0" ]; then
    bad "拿不到窗口 ID：$label"
    continue
  fi
  screencapture -x -o -l"$wid" /tmp/_hkw_fmt.png 2>/dev/null
  sips --cropToHeightWidth $((PLACE_H * SCALE)) $((PLACE_W * SCALE)) /tmp/_hkw_fmt.png \
    --out "/tmp/_hkw_fmt_crop.png" >/dev/null 2>&1
  cwebp -q 80 -quiet /tmp/_hkw_fmt_crop.png -o "$OUT_DIR/f${num}.webp" 2>/dev/null
  ok "f${num}.webp  · $label"
done

rm -f /tmp/_hkw_fmt.png /tmp/_hkw_fmt_crop.png
osascript -e 'tell application "Typora" to quit' >/dev/null 2>&1

# 元数据供官网使用
python3 - <<'PY'
import json
from pathlib import Path
root = Path(__file__).resolve().parents[1] if False else Path(".")
# written relative to OUT via shell below
PY

meta='['
first=1
for entry in "${FORMATS[@]}"; do
  IFS='|' read -r num query label <<< "$entry"
  [ $first -eq 1 ] || meta+=','
  first=0
  meta+=$(printf '{"id":"%s","file":"f%s.webp","label":"%s"}' "$num" "$num" "$label")
done
meta+=']'
printf '%s\n' "$meta" > "$OUT_DIR/manifest.json"

echo "────────────────────────────────────────"
echo "  完成：$OUT_DIR/f01.webp … f16.webp"
