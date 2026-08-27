#!/bin/bash
# portfolio-b/rimacafe/ は、スタンドアロン公開している rimacafe リポジトリの
# コピーを配置しているだけなので、スタンドアロン側を更新しても自動では
# 反映されない。rimacafe を更新した後、portfolio-design をコミット・push
# する前に必ずこのスクリプトを実行する。
#
# 使い方: portfolio-design ディレクトリで ./sync-rimacafe.sh

set -e
cd "$(dirname "$0")"

SRC="../rimacafe"
DST="portfolio-b/rimacafe"

echo "=== rimacafe（スタンドアロン $SRC からコピー） ==="

if [ ! -d "$SRC" ]; then
  echo "→ $SRC が見つかりません。スキップします。"
  exit 0
fi

DIFF=$(diff -rq "$SRC" "$DST" --exclude=.git --exclude=README.md --exclude=.claude 2>/dev/null || true)

if [ -z "$DIFF" ]; then
  echo "→ 差分なし（既に同期済み）"
else
  echo "→ 差分あり。同期します:"
  echo "$DIFF"
  cp "$SRC/index.html" "$SRC/animation.js" "$SRC/style.css" "$DST/"
  cp "$SRC/img/"* "$DST/img/" 2>/dev/null || true
  mkdir -p "$DST/case-study"
  cp -r "$SRC/case-study/." "$DST/case-study/" 2>/dev/null || true
  echo "→ コピー完了。git status で差分を確認してください。"
fi

echo ""
echo "=== 完了 ==="
echo "この後 portfolio-design で git status を確認し、変更があればコミット・pushしてください。"
