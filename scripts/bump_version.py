#!/usr/bin/env python3
"""bump_version.py — 双产物同号（真源 = edition/VERSION）

同步：
  - edition/VERSION
  - 根 VERSION
  - SKILL.md frontmatter version
  - _meta.json version
  - edition/meta.paid.json version

用法：
    python3 scripts/bump_version.py 2.0.3
    python3 scripts/bump_version.py --check
    python3 scripts/bump_version.py 2.0.3 --changelog
"""

from __future__ import annotations

import argparse
import datetime
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "SKILL.md"
META = ROOT / "_meta.json"
ROOT_VERSION = ROOT / "VERSION"
EDITION = ROOT / "edition"
VERSION_FILE = EDITION / "VERSION"
PAID_META = EDITION / "meta.paid.json"

VERSION_RE = re.compile(r"^\d+\.\d+\.\d+$")
# 本仓 frontmatter 为顶层 `version:`；兼容缩进两格写法
SKILL_VER_RE = re.compile(r"(?m)^( {0,2})version: .+$")


def read_edition_version() -> str:
    return VERSION_FILE.read_text(encoding="utf-8").strip()


def set_skill_version(path: Path, version: str) -> None:
    text = path.read_text(encoding="utf-8")
    new, n = SKILL_VER_RE.subn(rf"\1version: {version}", text, count=1)
    if n != 1:
        raise SystemExit(f"{path} 里找不到 frontmatter version")
    path.write_text(new, encoding="utf-8")


def get_skill_version(path: Path) -> str:
    m = SKILL_VER_RE.search(path.read_text(encoding="utf-8"))
    if not m:
        raise SystemExit(f"{path} 里找不到 frontmatter version")
    return m.group(0).split(":", 1)[1].strip()


def set_meta_version(path: Path, version: str) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    data["version"] = version
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def get_meta_version(path: Path) -> str:
    return str(json.loads(path.read_text(encoding="utf-8")).get("version", "")).strip()


def _insert_changelog_stub(path: Path, version: str) -> bool:
    if not path.exists():
        return False
    text = path.read_text(encoding="utf-8")
    markers = (f"## {version}", f"## v{version}")
    if any(m in text for m in markers):
        return False
    stub = f"## {version} — {datetime.date.today().isoformat()}\n\n- 待补。\n\n"
    # 插在 Unreleased 段落后，或文件首个 ## 之前
    unreleased = re.search(r"(?ms)^## Unreleased\n.*?(?=\n## )", text)
    if unreleased:
        pos = unreleased.end()
        text = text[:pos] + "\n" + stub + text[pos:]
    else:
        pos = text.find("\n## ")
        if pos == -1:
            text = text.rstrip() + "\n\n" + stub
        else:
            text = text[: pos + 1] + stub + text[pos + 1 :]
    path.write_text(text, encoding="utf-8")
    return True


def check(verbose: bool = True) -> list[str]:
    problems: list[str] = []
    try:
        version = read_edition_version()
    except OSError as e:
        return [f"读不到 edition/VERSION：{e}"]

    points: list[tuple[str, str]] = [
        ("根 VERSION", ROOT_VERSION.read_text(encoding="utf-8").strip() if ROOT_VERSION.exists() else ""),
        ("SKILL.md", get_skill_version(SKILL)),
        ("_meta.json", get_meta_version(META) if META.exists() else ""),
        ("edition/meta.paid.json", get_meta_version(PAID_META) if PAID_META.exists() else ""),
    ]
    for name, value in points:
        if value != version:
            problems.append(f"{name} = {value or '（空）'}，edition/VERSION = {version}")
    if verbose:
        print(f"edition/VERSION = {version}")
        for name, value in points:
            mark = "PASS" if value == version else "FAIL"
            print(f"  [{mark}] {name} = {value or '（空）'}")
        print("版本检查：", "全部一致" if not problems else f"{len(problems)} 处不一致")
    return problems


def bump(version: str, changelog: bool = False) -> int:
    if not VERSION_RE.match(version):
        print(f"版本号格式不对：{version}（示例 2.0.3）", file=sys.stderr)
        return 2
    if not EDITION.is_dir():
        print("缺少 edition/，无法确定专业版版本", file=sys.stderr)
        return 2
    if not PAID_META.exists():
        print("缺少 edition/meta.paid.json", file=sys.stderr)
        return 2
    if not META.exists():
        print("缺少 _meta.json", file=sys.stderr)
        return 2

    VERSION_FILE.write_text(version + "\n", encoding="utf-8")
    ROOT_VERSION.write_text(version + "\n", encoding="utf-8")
    set_skill_version(SKILL, version)
    set_meta_version(META, version)
    set_meta_version(PAID_META, version)
    updated = [
        "edition/VERSION",
        "VERSION",
        "SKILL.md",
        "_meta.json",
        "edition/meta.paid.json",
    ]
    if changelog and _insert_changelog_stub(ROOT / "CHANGELOG.md", version):
        updated.append("CHANGELOG.md（空条目）")
    print(f"已升到 {version}：")
    for name in updated:
        print(f"  - {name}")
    return 0


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="更新 Typora 主题技能双产物版本点")
    ap.add_argument("version", nargs="?", help="新版本号，如 2.0.3")
    ap.add_argument("--check", action="store_true", help="只检查版本点是否一致")
    ap.add_argument("--changelog", action="store_true", help="在 CHANGELOG.md 插入空条目")
    args = ap.parse_args(argv)

    if args.check:
        return 0 if not check() else 1
    if not args.version:
        ap.print_help()
        return 2
    return bump(args.version, changelog=args.changelog)


if __name__ == "__main__":
    sys.exit(main())
