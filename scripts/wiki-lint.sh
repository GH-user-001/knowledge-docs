#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-wiki}"

if [ ! -d "$ROOT" ]; then
  echo "error: wiki directory not found: $ROOT"
  exit 1
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "error: ripgrep (rg) is required"
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

pages_file="$tmpdir/pages.txt"
inbound_file="$tmpdir/inbound.txt"
broken_file="$tmpdir/broken.txt"
orphans_file="$tmpdir/orphans.txt"
content_pages_file="$tmpdir/content_pages.txt"

find "$ROOT" -type f -name '*.md' ! -path "$ROOT/_templates/*" \
  | sed "s|^$ROOT/||" \
  | sort > "$pages_file"

: > "$inbound_file"
: > "$broken_file"
: > "$orphans_file"
: > "$content_pages_file"

while IFS= read -r page; do
  case "$page" in
    index.md|log.md|overview.md|README.md|*/README.md) ;;
    *) echo "$page" >> "$content_pages_file" ;;
  esac
done < "$pages_file"

while IFS= read -r line; do
  file="$(printf '%s' "$line" | cut -d: -f1)"
  line_no="$(printf '%s' "$line" | cut -d: -f2)"
  match="$(printf '%s' "$line" | cut -d: -f3-)"

  case "$file" in
    */_templates/*) continue ;;
  esac

  link="${match#[[}"
  link="${link%]]}"
  link="${link%%|*}"
  link="${link%%#*}"
  link="${link#/}"

  if [ -z "$link" ]; then
    continue
  fi

  case "$link" in
    http://*|https://*|mailto:*) continue ;;
  esac

  target="$link"
  case "$target" in
    *.md) ;;
    *) target="${target}.md" ;;
  esac

  if grep -Fxq "$target" "$pages_file"; then
    echo "$target" >> "$inbound_file"
  else
    echo "${file}:${line_no} -> [[${link}]]" >> "$broken_file"
  fi
done < <(rg --no-heading --line-number --with-filename -o '\[\[[^]]+\]\]' "$ROOT" --glob '*.md' || true)

sort -u "$inbound_file" -o "$inbound_file"

while IFS= read -r page; do
  if ! grep -Fxq "$page" "$inbound_file"; then
    echo "$page" >> "$orphans_file"
  fi
done < "$content_pages_file"

echo "Scanned pages: $(wc -l < "$pages_file" | tr -d ' ')"

lint_failed=0

if [ -s "$broken_file" ]; then
  echo
  echo "Broken wikilinks:"
  cat "$broken_file"
  lint_failed=1
fi

echo
if [ -s "$orphans_file" ]; then
  echo "Orphan pages (no inbound wikilinks):"
  cat "$orphans_file"
else
  echo "No orphan pages."
fi

echo
if [ "$lint_failed" -eq 0 ]; then
  echo "Wiki lint passed."
else
  echo "Wiki lint failed."
fi

exit "$lint_failed"
