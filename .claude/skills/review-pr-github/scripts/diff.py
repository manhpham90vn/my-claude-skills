#!/usr/bin/env python3
"""
Usage:
    ./diff.py <owner> <repo> <pr_number>

Output: Valid line numbers for GitHub PR review API (chỉ dòng nằm TRONG patch)

⚠️  GitHub PR Review API CHỈ chấp nhận comment trên dòng NẰM TRONG HUNKS
    Script này lấy patch từ GitHub API để đảm bảo line numbers LUÔN valid

    Với modified files: chỉ trả về dòng nằm TRONG hunks
    Với new files: tất cả dòng trong patch
    Với binary files: trả về "__binary__", không crash
"""

import subprocess
import sys
import json
import re

def gh_api(query):
    """Execute gh api and return JSON"""
    result = subprocess.run(
        ['gh', 'api', query],
        capture_output=True, text=True, check=True
    )
    return result.stdout

def parse_hunks(patch):
    """
    Parse unified diff patch và trả về list các dòng added nằm TRONG hunks.
    Chỉ dòng added (bắt đầu bằng '+') mới được dùng cho review comment.

    Returns:
        list: Danh sách các dòng added.
        str: "__binary__" nếu file là binary (không xử lý).
        None: Nếu không có patch.
    """
    if not patch:
        return None  # No patch available

    # GitHub marks binary files with a specific placeholder in the patch field
    if patch.strip() == 'Binary file not shown.':
        return "__binary__"

    lines = patch.split('\n')
    valid_lines = []

    left_line = 0
    right_line = 0

    for line in lines:
        # Hunk header: @@ -L,R +L,R @@
        hunk_match = re.match(r'^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@', line)
        if hunk_match:
            left_line = int(hunk_match.group(1))
            right_line = int(hunk_match.group(2))
            # New files có hunk bắt đầu từ +0, bump lên 1
            if right_line == 0:
                right_line = 1
            continue

        # Dòng bị xóa
        if line.startswith('-'):
            left_line += 1
        # Dòng được thêm
        elif line.startswith('+'):
            # Bỏ qua +-- (binary diff) và \ No newline at end of file
            if not line.startswith('+--') and '\\ No newline' not in line:
                valid_lines.append({
                    'line': right_line,
                    'type': 'added',
                    'content': line[1:]
                })
            right_line += 1
        # Dòng context - chỉ tăng counters, không thêm vào valid_lines
        elif line.startswith(' '):
            left_line += 1
            right_line += 1

    return valid_lines

def main():
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} <owner> <repo> <pr_number>")
        print(f"Example: {sys.argv[0]} b54JP rikon-sodan 24")
        sys.exit(1)

    owner, repo, pr = sys.argv[1], sys.argv[2], sys.argv[3]

    print(f"Fetching PR #{pr} files from GitHub...\n")

    # Lấy tất cả files
    try:
        files_json = gh_api(f"repos/{owner}/{repo}/pulls/{pr}/files")
        files = json.loads(files_json)
    except Exception as e:
        print(f"Error fetching files: {e}")
        sys.exit(1)

    print(f"Found {len(files)} files in PR\n")
    print("=" * 70)

    all_valid_lines = {}

    for f in files:
        filename = f['filename']
        status = f['status']
        patch = f.get('patch', '')
        additions = f['additions']
        deletions = f['deletions']

        print(f"\n📄 {filename}")
        print(f"   Status: {status} | +{additions} -{deletions}")

        if status in ('removed', 'renamed'):
            print("   ⚠️ File bị xóa hoặc đổi tên - không thể comment")
            all_valid_lines[filename] = []
            continue

        if not patch:
            print("   ⚠️ Không có patch để analyze")
            all_valid_lines[filename] = []
            continue

        result = parse_hunks(patch)

        # Handle binary files
        if result == "__binary__":
            print("   ⚠️ Binary file - bỏ qua (không thể comment trên dòng)")
            all_valid_lines[filename] = "__binary__"
            continue

        # Handle no patch (None)
        if result is None:
            print("   ⚠️ Không có patch để analyze")
            all_valid_lines[filename] = []
            continue

        all_valid_lines[filename] = result

        if status == 'added':
            print(f"   📄 NEW FILE - {len(result)} dòng valid")
        else:
            print(f"   📄 MODIFIED - {len(result)} dòng valid trong hunks")

        if result:
            for vl in result:
                content = vl['content']
                print(f"      +Line {vl['line']:4d}: {content}")

    print("\n" + "=" * 70)
    print("\n✅ Script hoàn thành!")
    print("Dùng output trên để xác định line numbers cho comment.")
    print("Chỉ những dòng được liệt kê mới được GitHub API chấp nhận.")

if __name__ == '__main__':
    main()
