---
name: review-pr-github
description: |
  Review Pull Request trên GitHub và đưa ra phản hồi.
  Sử dụng skill này khi người dùng cung cấp URL của một GitHub PR.

  Cách gọi:
      /review-pr-github <PR_URL> [--checklist=<name>]

  Parameters:
      PR_URL (required): GitHub PR URL, ví dụ: https://github.com/owner/repo/pull/123
      --checklist (optional): Tên checklist(s) để sử dụng, có thể dùng nhiều checklist cùng lúc (comma-separated).
          - laravel: Checklist cho Laravel/PHP projects
          - html-css: Checklist cho HTML & CSS thuần (không có framework)
          - blade-livewire-tailwind: Checklist cho Blade, Livewire & Tailwind CSS
          - docker: Checklist cho Docker & Container
          - github-actions: Checklist cho GitHub Actions & CI/CD
          - typescript: Checklist cho TypeScript & Node.js
          - cdk-infra: Checklist cho AWS CDK & Infrastructure
          - Nếu không chỉ định, mặc định dùng "laravel"
          - Có thể kết hợp nhiều checklist: --checklist=html-css,blade-livewire-tailwind

  Ví dụ:
      /review-pr-github https://github.com/acme/backend/pull/42
      /review-pr-github https://github.com/acme/frontend/pull/15 --checklist=html-css,blade-livewire-tailwind
      /review-pr-github https://github.com/acme/infra/pull/99 --checklist=cdk-infra,typescript,docker,github-actions
      /review-pr-github https://github.com/acme/fullstack/pull/88 --checklist=laravel
compatibility:
  tools: [bash]
  dependencies: [gh (GitHub CLI), git, python3]
---

# Review PR trên GitHub

Review PR: chất lượng code, bảo mật, logic/lỗi, và các đề xuất cải thiện.
Kết quả đầu ra là các inline comment trên từng file và dòng cụ thể.

## Khi nào nên dùng

- Người dùng cung cấp URL của một GitHub PR (ví dụ: `https://github.com/acme/backend/pull/42`)
- Người dùng muốn review, kiểm tra, hoặc đánh giá một PR

## Khi nào KHÔNG nên dùng

- Đầu vào là một đoạn diff hoặc code dán trực tiếp (không phải URL)

## Các bước thực hiện

### Bước 1: Kiểm tra điều kiện đầu vào

1. Xác minh đầu vào là một URL hợp lệ của GitHub PR có định dạng: `https://github.com/<owner>/<repo>/pull/<number>`. Nếu không, trả về lỗi: "Đầu vào không phải là URL hợp lệ của GitHub PR. Vui lòng cung cấp URL như `https://github.com/acme/backend/pull/42`".
2. Xác minh `git` đã được cài đặt bằng cách chạy `git --version`. Nếu `git` chưa được cài đặt, trả về lỗi: "Cần cài đặt Git để sử dụng skill này."
3. Xác minh `gh` (GitHub CLI) đã được cài đặt bằng cách chạy `gh --version`. Nếu `gh` chưa được cài đặt, trả về lỗi: "Cần cài đặt GitHub CLI để sử dụng skill này."
4. Xác minh `gh` (GitHub CLI) đã được xác thực bằng `gh auth status`. Nếu chưa xác thực, trả về lỗi: "Cần xác thực GitHub CLI. Vui lòng chạy `gh auth login` trước."
5. Xác minh `python3` đã được cài đặt bằng cách chạy `python3 --version`. Nếu `python3` chưa được cài đặt, trả về lỗi: "Cần cài đặt Python 3 để sử dụng skill này."

### Bước 2: Phân tích URL của PR

Từ URL người dùng cung cấp, trích xuất:

- `OWNER` — tên tổ chức/người dùng
- `REPO` — tên repository
- `PR_NUMBER` — số thứ tự PR

  **Ví dụ:** `https://github.com/acme/backend/pull/42` → OWNER=acme, REPO=backend, PR_NUMBER=42

- Ghi nhớ `SKILL_DIR=~/.claude/skills/review-pr-github/` là thư mục chính của skill này
- Ghi nhớ `TASKS_DIR=$SKILL_DIR/tasks/` để lưu trữ các file tạm thời liên quan đến PR này (diff, logs, review output)
- Tạo PREFIX=`<OWNER>_<REPO>_<PR_NUMBER>` để sử dụng cho các bước tiếp theo

  **Ví dụ:** `https://github.com/acme/backend/pull/42` -> PREFIX=`acme_backend_42`.

---

### Bước 3: Load Checklist(s)

**Đọc checklist(s) từ thư mục `$SKILL_DIR/docs`:**

1. Kiểm tra parameter `--checklist` mà người dùng truyền vào:
   - Nếu có comma-separated values (ví dụ: `laravel,docker,github-actions`): parse và load nhiều checklist
   - Nếu là single value hoặc không có param: mặc định là `laravel`

2. **Danh sách checklist files:**
   - `laravel.md` — Laravel/PHP projects
   - `html-css.md` — HTML & CSS thuần (pure frontend, không framework)
   - `blade-livewire-tailwind.md` — Blade templates, Livewire, Alpine.js & Tailwind CSS
   - `docker.md` — Docker & Container
   - `github-actions.md` — GitHub Actions & CI/CD
   - `typescript.md` — TypeScript & Node.js
   - `cdk-infra.md` — AWS CDK & Infrastructure

3. Load tất cả checklist files được chỉ định vào biến `CHECKLIST_CONTENT`:
   - Đọc tất cả file được yêu cầu
   - Merge nội dung lại (rules có thể overlap nhưng khác rule ID)
   - Nếu checklist không tồn tại → báo lỗi và dừng lại

4. Phân tích checklist đã merge để xác định:
   - Các rule cần kiểm tra (rule ID, priority)
   - Các tiêu chí đặc biệt cần áp dụng cho project này

**Cấu trúc thư mục:**

```
~/.claude/skills/review-pr-github/
├── SKILL.md                    # Skill chính
├── docs/
│   ├── laravel.md              # Checklist cho Laravel/PHP
│   ├── html-css.md             # Checklist cho HTML & CSS thuần
│   ├── blade-livewire-tailwind.md  # Checklist cho Blade, Livewire & Tailwind
│   ├── docker.md               # Checklist cho Docker & Container
│   ├── github-actions.md       # Checklist cho GitHub Actions & CI/CD
│   ├── typescript.md           # Checklist cho TypeScript & Node.js
│   └── cdk-infra.md           # Checklist cho AWS CDK & Infrastructure
└── scripts/
    └── diff.py                 # Script hỗ trợ map line number
```

---

### Bước 4: Thiết lập — git repo, dependencies

1. Xác minh thư mục hiện tại là một git repo có remote origin đúng với `<OWNER>/<REPO>`. Nếu không, trả về lỗi: "Thư mục hiện tại không phải là git repo hoặc remote origin không khớp với `<OWNER>/<REPO>`. Vui lòng chuyển đến thư mục chứa repo hoặc clone repo trước."
2. Checkout branch của PR bằng `gh pr checkout <PR_NUMBER>`.
3. Lấy **PR head commit SHA** bằng `gh api "repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}" --jq '.head.sha'` và lưu vào biến `PR_HEAD_SHA` để sử dụng cho `Bước 8: Đăng review lên GitHub`.
4. Lấy diff của PR với `$SKILL_DIR/scripts/diff.py <owner> <repo> <pr_number> > $TASKS_DIR/pr_diff_<PREFIX>.diff` (ví dụ: `~/.claude/skills/review-pr-github/scripts/diff.py acme backend 42 > ~/.claude/skills/review-pr-github/tasks/pr_diff_acme_backend_42.diff`)
5. Phân tích file `composer.json` để xác định các công cụ formater/linter có sẵn (phpstan, php-cs-fixer, pint) và cài đặt dependencies nếu cần (ví dụ: `composer install`).
6. Phân tích file `package.json` để xác định các công cụ formater/linter có sẵn cho frontend (eslint, prettier) và cài đặt dependencies nếu cần (ví dụ: `npm install` hoặc `yarn install`).

Ghi nhớ vị trí file diff để sử dụng ở `Bước 6: Phân tích diff và source code thực tế` và các công cụ có sẵn để sử dụng ở `Bước 5: Chạy lint, formatter, static analysis, test`.

---

### Bước 5: Chạy lint, formatter, static analysis, test

> **Lưu ý:** Để tối ưu performance, chỉ chạy các công cụ trên **các file trong diff** (không chạy toàn bộ codebase).

1. Lấy danh sách file thay đổi từ diff đọc từ `$TASKS_DIR/pr_diff_<PREFIX>.diff`.
2. Nếu có `phpstan`, chạy `phpstan analyse` **chỉ trên các file PHP trong diff**. Lưu lỗi vào `$TASKS_DIR/phpstan_<PREFIX>.log`.
3. Nếu có `php-cs-fixer` hoặc `pint`, chạy trên **các file PHP trong diff** để kiểm tra lỗi style. Lưu lỗi vào `$TASKS_DIR/phpcs_<PREFIX>.log`.
4. Nếu có `eslint` hoặc `prettier`, chạy trên **các file JS/TS/CSS trong diff** để kiểm tra lỗi style. Lưu lỗi vào `$TASKS_DIR/eslint_<PREFIX>.log` hoặc `$TASKS_DIR/prettier_<PREFIX>.log`.
5. Nếu có test suite (PHPUnit, Pest, Jest...), chạy test trên **các file liên quan trong diff** để đảm bảo không có lỗi mới. Lưu kết quả vào `$TASKS_DIR/test_<PREFIX>.log`.

Ghi nhớ vị trí các file log để phân tích ở `Bước 6: Phân tích diff và source code thực tế`.

---

### Bước 6: Phân tích diff và source code thực tế

- Đọc diff từ `$TASKS_DIR/pr_diff_<PREFIX>.diff` để lấy danh sách các file thay đổi. Sau đó **với mỗi file**, đọc **source code thực tế trên đĩa** để phân tích chi tiết. Không chỉ dựa vào nội dung diff.
- Đọc log từ các công cụ static analysis (phpstan, phpcs, pint, eslint, prettier, phpunit, jest) để lấy danh sách lỗi và cảnh báo (nếu có). ví dụ `$TASKS_DIR/phpstan_<PREFIX>.log`, `$TASKS_DIR/phpcs_<PREFIX>.log`, `$TASKS_DIR/pint_<PREFIX>.log` từ bước `Bước 5: Chạy lint, formatter, static analysis, test` liên kết lỗi từ static analysis với các dòng thay đổi trong diff để xác định vị trí cụ thể của lỗi trong file.

**Quy trình phân tích từng file:**

1. Xác định đường dẫn file trong diff
2. `Đọc` file thực tế trên đĩa
3. Phân tích **toàn bộ file**, không chỉ các dòng thay đổi
4. Với **mỗi dòng thay đổi**, đọc ngữ cảnh xung quanh để hiểu logic

**Phân tích theo tiêu chí:**

CHECKLIST_CONTENT - (đã load ở `Bước 3: Load Checklist(s)` - có thể bao gồm nhiều checklist)

---

### Bước 7: Định dạng kết quả review thành các comment có cấu trúc rõ ràng

Trình bày kết quả **theo từng file**, rồi **theo từng dòng/block cụ thể**.

#### 7.1. Cấu trúc chuẩn của một comment

Mỗi comment trên GitHub **bắt buộc** có các thành phần theo thứ tự sau:

```
**Rule:** <RULE_ID>
**Priority:** <PRIORITY>
**File:** <path/to/file.ext> | Dòng <N>

<Vấn đề:> Giải thích ngắn gọn tại sao đây là một vấn đề.
<Đề xuất:> (nếu có) Cách cải thiện cụ thể.
```

#### 7.2. Hai loại comment

**Comment thường — không có code suggestion**

Dùng khi chỉ cần giải thích hoặc đề xuất thay đổi không cần code cụ thể.

```
**Rule:** RULE_DB_01
**Priority:** 🔴 Critical
**File:** app/Models/User.php | Dòng 42

**Vấn đề:** Query này có N+1 problem — mỗi user trong vòng lặp sẽ trigger một câu query riêng.
**Đề xuất:** Dùng eager loading: `User::with('posts')->get()` thay vì loop.
```

**Comment có code suggestion — dùng khi có code cụ thể để thay thế**

Reviewer có thể nhấn **"Apply suggestion"** để áp dụng trực tiếp trên GitHub.

````
**Rule:** RULE_LW_01
**Priority:** 🔴 Critical
**File:** app/Livewire/UpdateProfile.php | Dòng 78

**Vấn đề:** Action không có authorization check — user có thể gọi trực tiếp từ frontend mà không qua permission.
**Đề xuất:** Thêm Gate::authorize() trước khi thực hiện mutation.

```suggestion
public function updateProfile()
{
    Gate::authorize('update', $this->user);

    // ... existing code
}
```

````

#### 7.4. Lưu JSON output

- Lưu comments vào `$TASKS_DIR/gh_review_<PREFIX>.json`

**Line-level JSON format** (bắt buộc có `commit_id`):

````json
{
  "commit_id": "<PR_HEAD_SHA từ Step 4>",
  "event": "COMMENT",
  "comments": [
    {
      "path": "app/Http/Controllers/UserController.php",
      "line": 42,
      "side": "RIGHT",
      "body": "**Rule:** RULE_DB_01\n**Priority:** 🔴 Critical\n**File:** app/Http/Controllers/UserController.php | Dòng 42\n\n**Vấn đề:** Query này có N+1 problem.",
      "commit_id": "<PR_HEAD_SHA từ Step 4>"
    },
    {
      "path": "app/Http/Controllers/UserController.php",
      "line": 56,
      "start_line": 50,
      "side": "RIGHT",
      "body": "**Rule:** RULE_LW_01\n**Priority:** 🔴 Critical\n**File:** app/Http/Controllers/UserController.php | Dòng 56\n\n**Vấn đề:** Action không có authorization check.\n\n```suggestion\nGate::authorize('update', $this->user);\n```",
      "commit_id": "<PR_HEAD_SHA từ Step 4>"
    }
  ]
}
````

#### 7.5. Các quy tắc khi format comment

| Quy tắc                        | Mô tả                                                                                         |
| ------------------------------ | --------------------------------------------------------------------------------------------- |
| **Thứ tự cố định**             | `Rule` → `Priority` → `File` → `Vấn đề` → `Đề xuất` → code suggestion                         |
| **Priority**                   | Luôn dùng emoji: 🔴 Critical, 🟠 High, 🟡 Medium                                              |
| **Code suggestion**            | Chỉ dùng khi có thể apply trực tiếp; indent 4 spaces bên trong block                          |
| **Không dùng markdown header** | Không dùng `###` hay `---` trong body comment vì GitHub không render đúng trong inline review |
| **Không hardcode emoji**       | Luôn dùng `*` xung quanh text để GitHub parse đúng markdown                                   |
| **Giữ ngắn**                   | Mỗi comment tối đa 5-7 dòng; issue phức tạp thì chia thành nhiều comments                     |
| **Không trùng lặp**            | Nếu cùng một rule vi phạm ở nhiều file, đăng comment riêng ở mỗi file, không gộp              |
| **PR overview**                | Đăng summary comment sau khi tất cả inline comments đã đăng                                   |

---

### Bước 8: Đăng review lên GitHub

- Sau khi xuất kết quả review, **tự động đăng review lên GitHub** (dùng GitHub CLI (`gh`) để đăng review với các comment đã chuẩn bị)
- Lưu ý quan trọng phải tuân thủ các quy tắc sau khi đăng review:
  - `$JSON_FILE_LINE` = `$TASKS_DIR/gh_review_<PREFIX>.json` (line-level comments, ví dụ: `$TASKS_DIR/gh_review_acme_backend_42.json`).
  - Nếu file bị xóa hoàn toàn thì không cần tạo comment vì không thể comment trên dòng đã bị xóa. Chỉ comment trên các dòng mới hoặc đã thay đổi.
  - Dùng `$PR_HEAD_SHA` (từ `Bước 4: Thiết lập — git repo, dependencies`) trong JSON để GitHub API chấp nhận request
  - Line number trong comment thì lấy từ file diff `$TASKS_DIR/pr_diff_<PREFIX>.diff`
  - Nếu gặp lỗi `Line could not be resolved` thì đọc lại từ source và verify lại line number bằng `grep -n` để map lại line number chính xác.

```sh
gh api "repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/reviews" \
  --method POST \
  --input "$TASKS_DIR/gh_review_<PREFIX>.json"
```
