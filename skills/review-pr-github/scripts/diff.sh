#!/bin/sh
#
# Usage: cat /tmp/pr.diff | ./diff.sh
#
# Output: Mapped line numbers for GitHub PR review API
#   LEFT_LINE  = line in base file (before merge)
#   RIGHT_LINE = line in post-merge file (after merge) ← DÙNG CHO side: "RIGHT"
#
# ⚠️  IMPORTANT: GitHub PR review API chỉ chấp nhận line number TRONG phạm vi hunk
#    (trong khoảng dòng được liệt kê trong diff cho file đó)
#    Nếu dòng bạn muốn comment KHÔNG nằm trong diff → dùng gh api comment thay thế
#

left_line=0
right_line=0
current_file=""
in_binary=0
seen_hunk=0

while IFS= read -r line; do
    # File header
    case "$line" in
      '--- a/'*)
        current_file="${line#--- a/}"
        left_line=0
        right_line=0
        seen_hunk=0
        printf '\n=== %s ===\n' "$current_file"
        continue
        ;;
      '+++ b/'*)
        continue
        ;;
    esac

    # Binary file
    case "$line" in
      'Binary files'*)
        in_binary=1
        printf '  [Binary file]\n'
        continue
        ;;
    esac

    # Hunk header @@ -L +R @@
    case "$line" in
      '@@ '*)
        in_binary=0
        seen_hunk=1
        left_line=$(echo "$line" | sed 's/@@ -\([0-9]*\).*/\1/')
        right_line=$(echo "$line" | sed 's/@@ -[^ ]* +\([0-9]*\).*/\1/')
        # Calculate hunk end for boundary check
        hunk_size=$(echo "$line" | sed -n 's/@@ -[0-9,]*\ +[0-9,]*\ +\(.*\) @@/\1/p')
        printf '\n  %s\n' "$line"
        printf '  %-10s | %-10s | %s\n' "LEFT_LINE" "RIGHT_LINE" "CONTENT"
        printf '  %s\n' "----------- | ----------- | -------"
        continue
        ;;
    esac

    # Skip binary content or before first hunk
    [ "$in_binary" -eq 1 ] && continue
    [ "$seen_hunk" -eq 0 ] && continue

    # Diff lines
    case "$line" in
      '-'*)
        printf '  %-10s | %-10s | - %s\n' "$left_line" "N/A" "${line#-}"
        left_line=$((left_line + 1))
        ;;
      '+'*)
        printf '  %-10s | %-10s | + %s\n' "N/A" "$right_line" "${line#+}"
        right_line=$((right_line + 1))
        ;;
      ' '*)
        printf '  %-10s | %-10s |   %s\n' "$left_line" "$right_line" "${line# }"
        left_line=$((left_line + 1))
        right_line=$((right_line + 1))
        ;;
    esac
done
