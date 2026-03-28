#!/bin/sh
#
# Usage: cat /tmp/pr.diff | ./diff.sh
#
# Output: Mapped line numbers for GitHub PR review API
#   LEFT_LINE  = line in base file (before merge)
#   RIGHT_LINE = line in post-merge file (after merge) ← DÙNG CHO side: "RIGHT"
#   IS_NEW     = "YES" if file is new (created in this PR)
#
# ⚠️  IMPORTANT: GitHub PR review API chỉ chấp nhận line number TRONG phạm vi hunk
#    (trong khoảng dòng được liệt kê trong diff cho file đó)
#    Nếu dòng bạn muốn comment KHÔNG nằm trong diff → dùng gh api comment thay thế
#
# ⚠️  NEW FILES: GitHub API chỉ chấp nhận line numbers từ dòng 1 trở lên.
#    Script tự động bump right_line lên 1 nếu hunk header bắt đầu từ 0.
#    LUÔN VERIFY bằng grep -n trên file thực tế cho new files.
#

left_line=0
right_line=0
current_file=""
in_binary=0
seen_hunk=0
is_new_file=0

while IFS= read -r line; do
    # File header
    case "$line" in
      '--- a/'*)
        # Strip "--- a/" prefix, then strip trailing tab + metadata (e.g. "filename\ttimestamp")
        current_file="${line#--- a/}"
        current_file="${current_file%"${current_file##*[![:space:]]}"}"
        left_line=0
        right_line=0
        seen_hunk=0
        is_new_file=0
        printf '\n=== %s ===\n' "$current_file"
        continue
        ;;
      '+++ b/'*)
        continue
        ;;
    esac

    # Detect new file mode
    case "$line" in
      'new file mode'*)
        is_new_file=1
        printf '  [NEW FILE]\n'
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

        # Extract left and right starting lines
        left_start=$(echo "$line" | sed 's/@@ -\([0-9]*\).*/\1/')
        right_start=$(echo "$line" | sed 's/@@ -[^ ]* +\([0-9]*\).*/\1/')

        left_line="$left_start"
        right_line="$right_start"

        # ⚠️  FIX: For new files, hunk starts at @@ -0,0 +1,N @@
        # GitHub API only accepts line >= 1, so bump to 1
        if [ "$is_new_file" -eq 1 ] && [ "$right_line" -eq 0 ]; then
            right_line=1
        fi

        # Show file type indicator
        if [ "$is_new_file" -eq 1 ]; then
            printf '\n  [NEW FILE — verify line numbers manually with: grep -n "pattern" %s]\n' "$current_file"
        fi

        printf '\n  %s\n' "$line"
        printf '  %-10s | %-10s | %-6s | %s\n' "LEFT_LINE" "RIGHT_LINE" "IS_NEW" "CONTENT"
        printf '  %s\n' "----------- | ----------- | ------- | -------"
        continue
        ;;
    esac

    # Skip binary content or before first hunk
    [ "$in_binary" -eq 1 ] && continue
    [ "$seen_hunk" -eq 0 ] && continue

    # Diff lines
    case "$line" in
      '-'*)
        printf '  %-10s | %-10s | %-6s | - %s\n' "$left_line" "N/A" "$is_new_file" "${line#-}"
        left_line=$((left_line + 1))
        ;;
      '+'*)
        printf '  %-10s | %-10s | %-6s | + %s\n' "N/A" "$right_line" "$is_new_file" "${line#+}"
        right_line=$((right_line + 1))
        ;;
      ' '*)
        printf '  %-10s | %-10s | %-6s |   %s\n' "$left_line" "$right_line" "$is_new_file" "${line# }"
        left_line=$((left_line + 1))
        right_line=$((right_line + 1))
        ;;
    esac
done
