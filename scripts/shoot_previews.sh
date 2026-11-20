#!/usr/bin/env bash
# ============================================================
# 预览图刷新 —— 在 Typora 里实拍，浅色 + 深色各一张
#
# 用法：./scripts/shoot_previews.sh [输出目录]
#
# 为什么不能用 headless 拍：docs/previews/*.webp 是 Typora 应用窗口
# 截图（含侧边栏、工具栏、真实字体渲染），不是纯 CSS 渲染。
# 仓库里已有 verify_render.py 那种 headless 探针，但产物形态不同。
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="${1:-$ROOT/docs/previews/r}"
DEMO_SRC="$ROOT/demo"
# 官网 / README 预览统一拍「验收样张」——铺满标题、行内样式、引用、列表、任务、代码、表格等，
# 一眼能看出 Markdown 常见格式在主题里是否清楚可读。
SAMPLE_NAME="验收样张.md"
PREF="abnerworks.Typora"
THEME_DIR="$HOME/Library/Application Support/abnerworks.Typora/themes"

ok()  { printf '\033[38;2;55;141;239m  ✅ %s\033[0m\n' "$*"; }
warn() { printf '  ⚠️  %s\n' "$*"; }
bad()  { printf '  ❌ %s\n' "$*"; }

[ -d "$DEMO_SRC" ] || { bad "找不到 demo 目录：$DEMO_SRC"; exit 1; }
[ -f "$DEMO_SRC/$SAMPLE_NAME" ] || { bad "找不到样张：$DEMO_SRC/$SAMPLE_NAME"; exit 1; }
mkdir -p "$OUT_DIR"

# ⚠️ 不要让 Typora 直接打开仓库里的 demo/。
# Typora 打开带 frontmatter 的 md 时会把 theme: 键改名（ctheme:），
# 退出时写回 —— 仓库样张会被改坏。整目录拷到临时区再开文件夹视图。
# 子目录固定叫 demo，侧边栏与仓库一致。
WORK_PARENT="$(mktemp -d -t hekouwang-shoot)"
WORK="$WORK_PARENT/demo"
cleanup() { rm -rf "$WORK_PARENT"; }
trap cleanup EXIT INT TERM
mkdir -p "$WORK"
cp -R "$DEMO_SRC/." "$WORK/"
SAMPLE="$WORK/$SAMPLE_NAME"

# 屏幕分辨率与缩放 —— 截图要按物理像素，retina 下是 2 倍
read -r SCR_W SCR_H <<< "$(osascript -e 'tell application "Finder" to get bounds of window of desktop' | tr ',' ' ')"
SCALE=2

# ------------------------------------------------------------
# 切主题并重启 Typora（改完 CSS 必须完全退出重开，否则加载的是旧版）
# ------------------------------------------------------------
set_theme() {
  local theme="$1" dark="$2"
  defaults write "$PREF" theme -string "$theme"
  defaults write "$PREF" useSeparateDarkTheme -bool "$dark"
  defaults write "$PREF" useDarkTheme -bool false
  defaults write "$PREF" darkTheme -string "$theme"
}

restart_typora() {
  osascript -e 'tell application "Typora" to quit' >/dev/null 2>&1
  sleep 2
  pkill -x Typora >/dev/null 2>&1
  sleep 1
  # 打开临时 demo 目录（侧边栏可见整夹），再打开展示样张
  open -a Typora "$WORK"
  sleep 2
  open -a Typora "$SAMPLE"
  sleep 5
}

# 目标逻辑像素 960×577 → 物理 1920×1154（retina SCALE=2）
# y 避开菜单栏 / 腾讯会议「正在共享屏幕」条（叠在 y=0 会被区域截图吃进去）
PLACE_X=40
PLACE_Y=72
PLACE_W=960
PLACE_H=577

place_window() {
  osascript <<APPLESCRIPT >/dev/null 2>&1
tell application "System Events" to tell process "Typora"
  set frontmost to true
  delay 0.4
  try
    set position of front window to {$PLACE_X, $PLACE_Y}
    set size of front window to {$PLACE_W, $PLACE_H}
  end try
end tell
APPLESCRIPT
  sleep 1.5
}

# 滚到「列表 / 任务 / 代码」一带，一屏里能看到更多 Markdown 块类型
scroll_to_formats() {
  osascript <<'APPLESCRIPT' >/dev/null 2>&1
tell application "System Events" to tell process "Typora"
  set frontmost to true
  delay 0.2
  key code 115 -- Home，先回顶
  delay 0.35
  -- 约到「三、列表」：无序/有序/任务 + 代码入口同屏
  repeat 3 times
    key code 121 -- Page Down
    delay 0.22
  end repeat
  delay 0.45
end tell
APPLESCRIPT
}

# 取 Typora 主窗口 CGWindowID（按窗口图层截，不含会议共享浮层）
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

# 顶部若有「结束共享」红钮，说明会议浮层污染了截图
shot_is_contaminated() {
  local png="$1"
  python3 - "$png" <<'PY'
import sys
from PIL import Image
im = Image.open(sys.argv[1]).convert("RGB")
w, h = im.size
band = im.crop((int(w * 0.35), 0, w, min(90, h)))
red = sum(1 for r, g, b in band.getdata() if r > 180 and g < 100 and b < 100)
sys.exit(0 if red > 400 else 1)
PY
}

shoot() {
  local outfile="$1"
  local wid pw ph attempt
  pw=$(( PLACE_W * SCALE ))
  ph=$(( PLACE_H * SCALE ))
  wid="$(typora_window_id || true)"
  if [ -z "$wid" ] || [ "$wid" = "0" ]; then
    bad "拿不到 Typora 窗口 ID"
    return 1
  fi
  for attempt in 1 2 3; do
    # -l 按窗口位图截；-o 不要阴影。不走 -R，避免叠上共享条。
    screencapture -x -o -l"$wid" /tmp/_hkw_shot.png 2>/dev/null
    sips --cropToHeightWidth "$ph" "$pw" /tmp/_hkw_shot.png --out "$outfile" >/dev/null 2>&1
    if shot_is_contaminated "$outfile"; then
      bad "截图含会议共享条，重试 ($attempt/3)…"
      place_window
      wid="$(typora_window_id || true)"
      sleep 1
      continue
    fi
    cwebp -q 82 -quiet "$outfile" -o "${outfile%.png}.webp" 2>/dev/null
    rm -f /tmp/_hkw_shot.png
    ok "${outfile%.png}.webp  ${pw}x${ph}  (window $wid)"
    return 0
  done
  rm -f /tmp/_hkw_shot.png "$outfile"
  bad "连续 3 次仍含共享条，请先结束腾讯会议屏幕共享后再拍"
  return 1
}

# 主题清单：菜单名 → 输出文件名
# 免费 V2 永远拍；付费六套若已装进 Typora（themes/ 下有对应 CSS）也一起拍。
ALL_THEMES=(
  "Hekouwang:v2"
  "Hekouwang V1:v1"
  "Hekouwang V2 Pro:v2-pro"
  "Hekouwang V3:v3"
  "Hekouwang V4:v4"
  "Hekouwang V5:v5"
  "Hekouwang V6:v6"
)

echo "hekouwang · 预览图刷新"
echo "────────────────────────────────────────"

for entry in "${ALL_THEMES[@]}"; do
  menu="${entry%%:*}"
  slug="${entry##*:}"
  for variant in light dark; do
    if [ "$variant" = "dark" ]; then
      theme="$menu Dark"
    else
      theme="$menu"
    fi
    # 主题没装进 Typora 就跳过（付费档没解锁时跳过，不报错）
    css_name="hekouwang-$slug.css"
    [ "$slug" = "v2" ] && css_name="hekouwang.css"
    if [ ! -f "$THEME_DIR/$css_name" ]; then
      warn "跳过 $theme（未安装：$css_name）"
      continue
    fi
    echo "▸ $theme"
    set_theme "$theme" true
    restart_typora
    place_window
    scroll_to_formats
    shoot "$OUT_DIR/_$slug-$variant.png"
  done
done

echo "────────────────────────────────────────"
echo "  完成。产物在 $OUT_DIR 下 _<slug>-<variant>.png / .webp"
echo "  确认无误后再改名覆盖 docs/previews/<slug>-<variant>.webp"
