---
name: review-pr-github
description: |
    Review Pull Request trên GitHub và đưa ra phản hồi.
    Sử dụng skill này khi người dùng cung cấp URL của một GitHub PR.

    Cách gọi:
        /review-pr-github <PR_URL> [--checklist=<name>]

    Parameters:
        PR_URL (required): GitHub PR URL, ví dụ: https://github.com/owner/repo/pull/123
        --checklist (optional): Tên checklist trong docs/ để sử dụng.
            - laravel: Checklist cho Laravel/PHP projects
            - html-css: Checklist cho HTML/CSS/JS projects
            - Nếu không chỉ định, mặc định dùng "laravel"

    Ví dụ:
        /review-pr-github https://github.com/acme/backend/pull/42
        /review-pr-github https://github.com/acme/frontend/pull/15 --checklist=html-css
compatibility:
    tools: [bash]
    dependencies: [gh (GitHub CLI)]
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
2. Xác minh git đã được cài đặt bằng cách chạy `git --version`. Nếu git chưa được cài đặt, trả về lỗi: "Cần cài đặt Git để sử dụng skill này."
3. Xác minh gh (GitHub CLI) đã được cài đặt bằng cách chạy `gh --version`. Nếu gh chưa được cài đặt, trả về lỗi: "Cần cài đặt GitHub CLI (gh) để sử dụng skill này."
4. Xác minh gh (GitHub CLI) đã được xác thực bằng `gh auth status`. Nếu chưa xác thực, trả về lỗi: "Cần xác thực GitHub CLI. Vui lòng chạy `gh auth login` trước."

### Bước 2: Phân tích URL của PR

Từ URL người dùng cung cấp, trích xuất:

- `OWNER` — tên tổ chức/người dùng
- `REPO` — tên repository
- `PR_NUMBER` — số thứ tự PR

**Ví dụ:** `https://github.com/acme/backend/pull/42` → OWNER=acme, REPO=backend, PR_NUMBER=42

- Tạo PREFIX=`<OWNER>_<REPO>_<PR_NUMBER>` để sử dụng cho các bước tiếp theo (ví dụ: `acme_backend_42`).

---

### Bước 3: Load Checklist

**Đọc checklist từ thư mục `docs/`:**

1. Kiểm tra parameter `--checklist` mà người dùng truyền vào:
    - Nếu `--checklist=laravel` hoặc không có param → đọc `.claude/skills/review-pr-github/docs/laravel.md`
    - Nếu `--checklist=html-css` → đọc `.claude/skills/review-pr-github/docs/html-css.md`
    - Nếu checklist không tồn tại → báo lỗi và dừng lại

2. Đọc nội dung checklist đã chọn vào biến `CHECKLIST_CONTENT`.

3. Phân tích checklist để xác định:
    - Các rule cần kiểm tra (rule ID, priority)
    - Các tiêu chí đặc biệt cần áp dụng cho project này

**Cấu trúc thư mục:**

```
.claude/skills/review-pr-github/
├── SKILL.md              # Skill chính
├── docs/
│   ├── laravel.md        # Checklist cho Laravel/PHP
│   └── html-css.md       # Checklist cho HTML/CSS/JS
└── scripts/
    └── diff.sh           # Script hỗ trợ map line number
```

---

### Bước 4: Thiết lập — git repo, dependencies

1. Xác minh thư mục hiện tại là một git repo có remote origin đúng với `<OWNER>/<REPO>`. Nếu không, trả về lỗi: "Thư mục hiện tại không phải là git repo hoặc remote origin không khớp với `<OWNER>/<REPO>`. Vui lòng chuyển đến thư mục chứa repo hoặc clone repo trước."
2. Checkout branch của PR bằng `gh pr checkout <PR_NUMBER>`.
3. Lấy diff của PR với `gh pr diff <PR_NUMBER>` và lưu vào `/tmp/pr_review_<PREFIX>.diff` (ví dụ: `/tmp/pr_review_acme_backend_42.diff`) bằng command `gh pr diff <PR_NUMBER> > /tmp/pr_review_<PREFIX>.diff`.
4. Phân tích file `composer.json` để xác định các công cụ formater/linter có sẵn (phpstan, php-cs-fixer, pint) và cài đặt dependencies nếu cần (ví dụ: `composer install`).
5. Phân tích file `package.json` để xác định các công cụ formater/linter có sẵn cho frontend (eslint, prettier) và cài đặt dependencies nếu cần (ví dụ: `npm install` hoặc `yarn install`).

Ghi nhớ vị trí file diff để sử dụng ở `Bước 6: Phân tích diff và source code thực tế` và các công cụ có sẵn để sử dụng ở `Bước 5: Chạy lint, formatter, static analysis, test`.

---

### Bước 5: Chạy lint, formatter, static analysis, test

1. Nếu có `phpstan`, chạy `phpstan analyse` trên toàn bộ codebase. Lưu lỗi vào `/tmp/phpstan_<PREFIX>.log`.
2. Nếu có `php-cs-fixer` hoặc `pint`, chạy trên toàn bộ codebase để kiểm tra lỗi style. Lưu lỗi vào `/tmp/phpcs_<PREFIX>.log`.
3. Nếu có `eslint` hoặc `prettier`, chạy trên toàn bộ codebase frontend để kiểm tra lỗi style. Lưu lỗi vào `/tmp/eslint_<PREFIX>.log` hoặc `/tmp/prettier_<PREFIX>.log`.
4. Nếu có test suite (PHPUnit, Pest, Jest...), chạy toàn bộ test để đảm bảo không có lỗi mới. Lưu kết quả vào `/tmp/test_<PREFIX>.log`.

Ghi nhớ vị trí các file log để phân tích ở `Bước 6: Phân tích diff và source code thực tế`.

---

### Bước 6: Phân tích diff và source code thực tế

- Đọc diff từ `/tmp/pr_review_<PREFIX>.diff` để lấy danh sách các file thay đổi. Sau đó **với mỗi file**, đọc **source code thực tế trên đĩa** để phân tích chi tiết. Không chỉ dựa vào nội dung diff.
- Đọc log từ các công cụ static analysis (phpstan, phpcs, pint, eslint, prettier, phpunit, jest) để lấy danh sách lỗi và cảnh báo (nếu có). ví dụ `/tmp/phpstan_<PREFIX>.log`, `/tmp/phpcs_<PREFIX>.log`, `/tmp/pint_<PREFIX>.log` từ bước 4.Liên kết lỗi từ static analysis với các dòng thay đổi trong diff để xác định vị trí cụ thể của lỗi trong file.

**Quy trình phân tích từng file:**

1. Xác định đường dẫn file trong diff
2. `Đọc` file thực tế trên đĩa
3. Phân tích **toàn bộ file**, không chỉ các dòng thay đổi
4. Với **mỗi dòng thay đổi**, đọc ngữ cảnh xung quanh để hiểu logic

**Phân tích theo tiêu chí:**

CHECKLIST_CONTENT - (đã load ở `Bước 3: Load Checklist`)

---

### Bước 6: Định dạng kết quả review thành các comment có cấu trúc rõ ràng, dễ hiểu, và có thể áp dụng trực tiếp trên GitHub (dùng "suggestion" để có nút "Apply suggestion").

Trình bày kết quả **theo từng file**, rồi **theo từng dòng/block cụ thể**.

#### Comment thường — dùng khi chỉ giải thích, không có code cụ thể

File: `path/to/file.ext`
Dòng <N> — <Rule ID> — <Priority>

**Vấn đề:** Giải thích ngắn gọn tại sao đây là một vấn đề và đề xuất cách cải thiện

#### Comment có đề xuất — dùng khi có code cụ thể để thay thế

Reviewer có thể nhấn **"Apply suggestion"** để áp dụng trực tiếp trên GitHub.

File: `path/to/file.ext`
Dòng <N> — <Rule ID> — <Priority>

**Vấn đề:** Giải thích ngắn gọn tại sao đây là một vấn đề và đề xuất cách cải thiện

```suggestion
dòng code thay thế hoàn chỉnh
```

#### Cách xác định line number cho comment:

- Chạy script `.claude/skills/review-pr-github-laravel/scripts/diff.sh` để map line number trong diff sang line number thực tế trong file sau khi merge (dòng mới) ví dụ `cat /tmp/pr_review_<PREFIX>.diff | .claude/skills/review-pr-github-laravel/scripts/diff.sh`.

#### Output

- Kết quả review được lưu vào file JSON có định dạng với path là `/tmp/gh_review_<PREFIX>.json` (ví dụ: `/tmp/gh_review_acme_backend_42.json`):

````json
{
    "comments": [
        {
            "path": "app/Http/Controllers/UserController.php",
            "line": 42,
            "side": "RIGHT",
            "body": "**Vấn đề:** Giải thích ngắn gọn tại sao đây là một vấn đề."
        },
        {
            "path": "app/Http/Controllers/UserController.php",
            "line": 56,
            "side": "RIGHT",
            "body": "**Vấn đề:** Giải thích.\n\n```suggestion\ndòng code thay thế hoàn chỉnh\n```"
        }
    ]
}
````

---

### Bước 7: Hỏi người dùng về ngôn ngữ comment

**Trước khi đăng comment lên GitHub, hỏi người dùng:**

> "Bạn muốn tôi dùng ngôn ngữ nào khi đăng review comment lên GitHub?"
>
> Các lựa chọn:
>
> - Tiếng Anh (khuyến nghị cho team quốc tế)
> - Tiếng Việt

Dùng ngôn ngữ đã chọn cho tất cả comment đăng lên GitHub.

---

### Bước 8: Đăng review lên GitHub

Sau khi xuất kết quả review, **tự động đăng review lên GitHub**

Dùng GitHub CLI (`gh`) để đăng review với các comment đã chuẩn bị
Lưu ý quan trọng phải tuân thủ các quy tắc sau khi đăng review:

- `$JSON_FILE` là file JSON đã tạo ở bước 6 `/tmp/gh_review_<PREFIX>.json`(ví dụ:`/tmp/gh_review_acme_backend_42.json`)
- Không thêm trường body khi đăng review vì tôi chỉ muốn tạo comment trên từng dòng cụ thể, không cần comment chung cho toàn PR.
- Nếu file bị xóa hoàn toàn thì không cần tạo comment vì không thể comment trên dòng đã bị xóa. Chỉ comment trên các dòng mới hoặc đã thay đổi.

```sh
gh api "repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/reviews" \
  --method POST \
  --input "$JSON_FILE"
```
