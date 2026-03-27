# HTML & CSS Checklist (Pure Frontend)

## 1. 🏷️ HTML

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                     |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------------------ |
| **RULE_HTML_01** | 🔴 Critical | Semantic HTML: dùng đúng tags (`<header>`, `<nav>`, `<main>`, `<article>`, `<footer>`) thay vì toàn `<div>`. |
| **RULE_HTML_02** | 🔴 Critical | Không dùng inline styles (`style=""`) trong HTML — maintainability kém.                                    |
| **RULE_HTML_03** | 🔴 Critical | Mọi `<img>` phải có `alt`. Ảnh decorative dùng `alt=""`.                                                  |
| **RULE_HTML_04** | 🟠 High     | Form input phải có `<label>` hoặc `aria-label` — không dùng placeholder làm label.                        |
| **RULE_HTML_05** | 🟠 High     | Button/Link có nội dung text rõ ràng. Icon-only button cần `aria-label`.                                   |
| **RULE_HTML_06** | 🟠 High     | Không dùng `<div>` / `<span>` làm button có sự kiện click mà không có `role="button"` và `tabindex`.       |
| **RULE_HTML_07** | 🟠 High     | Modal/Dialog phải có `role="dialog"`, `aria-modal="true"`, và focus trap.                                  |
| **RULE_HTML_08** | 🟡 Medium   | Heading (`h1`–`h6`) phải theo thứ tự phân cấp đúng — không nhảy từ `h1` sang `h4`.                       |
| **RULE_HTML_09** | 🟡 Medium   | Dùng `<button>` cho actions, `<a>` cho navigation — không dùng lẫn nhau.                                   |
| **RULE_HTML_10** | 🟡 Medium   | `aria-*` attributes phải có giá trị hợp lệ và được cập nhật đúng khi state thay đổi.                     |

---

## 2. 🎨 SCSS / CSS

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                               |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_CSS_01** | 🔴 Critical | Không dùng `!important` để override — chỉ chấp nhận khi override 3rd-party utility.                                                             |
| **RULE_CSS_02** | 🟠 High     | Nesting SCSS không quá **3 cấp** — tránh selector quá dài, khó override và đọc.                                                                 |
| **RULE_CSS_03** | 🟠 High     | Dùng CSS Custom Properties (`--var`) hoặc SCSS variables (`$var`) cho màu, spacing, breakpoint — không hardcode giá trị magic (`margin: 13px`). |
| **RULE_CSS_04** | 🟠 High     | Không duplicate selector/block giống nhau ở nhiều nơi — extract thành mixin hoặc placeholder `%`.                                               |
| **RULE_CSS_05** | 🟠 High     | `z-index` phải dùng biến/token có tên (`$z-modal`, `$z-dropdown`) — không magic number.                                                         |
| **RULE_CSS_06** | 🟡 Medium   | `@mixin` có tham số mặc định hợp lý, không để caller phải truyền giá trị hiển nhiên.                                                          |
| **RULE_CSS_07** | 🟡 Medium   | Tránh selector quá specific (`.page .sidebar .nav ul li a.active`) — tăng specificity không cần thiết.                                          |
| **RULE_CSS_08** | 🟡 Medium   | File SCSS dài hơn **300 dòng** nên được tách theo component/module.                                                                             |
| **RULE_CSS_09** | 🟡 Medium   | Import SCSS theo đúng thứ tự: variables → mixins → base → components → utilities.                                                               |
| **RULE_CSS_10** | 🟡 Medium   | Không để code CSS/SCSS bị comment-out (dead code) trong commit.                                                                                 |
| **RULE_CSS_11** | 🟡 Medium   | Dùng BEM, SMACSS, hoặc ITCSS convention để đặt tên class — nhất quán trong project.                                                             |
| **RULE_CSS_12** | 🟡 Medium   | Animation/transition chỉ animate `transform` và `opacity` để tránh layout thrashing.                                                            |

---

## 3. ⚡ Performance (Frontend)

| Rule ID            | Priority  | Tiêu chí đánh giá                                                                                                    |
| :----------------- | :-------- | :--------------------------------------------------------------------------------------------------------------------- |
| **RULE_PERF_F_01** | 🟠 High   | Không load toàn bộ icon set khi chỉ dùng một vài icon — import từng icon riêng.                                        |
| **RULE_PERF_F_02** | 🟠 High   | `<img>` lớn phải có `loading="lazy"` nếu không nằm above-the-fold.                                                      |
| **RULE_PERF_F_03** | 🟠 High   | Font chữ ngoài (`Google Fonts`…) phải có `preconnect` / `preload` hint.                                              |
| **RULE_PERF_F_04** | 🟡 Medium | CSS animation nên dùng `transform` / `opacity` — tránh animate `width`, `height`, `top`, `left` gây layout reflow.       |
| **RULE_PERF_F_05** | 🟡 Medium | Không nhúng `<style>` inline lớn trong HTML — tách ra file riêng và cache.                                             |
| **RULE_PERF_F_06** | 🟡 Medium | Video/audio phải có `preload="none"` nếu không cần autoplay.                                                           |

---

## 4. ♿ Accessibility (a11y)

| Rule ID          | Priority    | Tiêu chí đánh giá                                                                                    |
| :--------------- | :---------- | :--------------------------------------------------------------------------------------------------- |
| **RULE_A11Y_01** | 🔴 Critical | Mọi `<img>` phải có `alt`. Ảnh decorative dùng `alt=""`.                                             |
| **RULE_A11Y_02** | 🔴 Critical | Form input phải có `<label>` hoặc `aria-label` — không dùng placeholder làm label.                   |
| **RULE_A11Y_03** | 🟠 High     | Button/Link có nội dung text rõ ràng. Icon-only button cần `aria-label`.                             |
| **RULE_A11Y_04** | 🟠 High     | Không dùng `<div>` / `<span>` làm button có sự kiện click mà không có `role="button"` và `tabindex`. |
| **RULE_A11Y_05** | 🟠 High     | Modal/Dialog phải có `role="dialog"`, `aria-modal="true"`, và focus trap.                            |
| **RULE_A11Y_06** | 🟡 Medium   | Heading (`h1`–`h6`) phải theo thứ tự phân cấp đúng — không nhảy từ `h1` sang `h4`.                   |
| **RULE_A11Y_07** | 🟡 Medium   | Color contrast đủ tiêu chuẩn WCAG AA (4.5:1 text, 3:1 large text).                                   |
| **RULE_A11Y_08** | 🟡 Medium   | `aria-*` attributes phải có giá trị hợp lệ và được cập nhật đúng khi state thay đổi.                 |

---

## 5. 🧹 Code Quality & Maintainability

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                     |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------- |
| **RULE_QUA_01** | 🔴 Critical | Xóa sạch `console.log`, debug attribute trước khi commit.                                                |
| **RULE_QUA_02** | 🟠 High     | Tên class CSS/SCSS phải theo một convention nhất quán (BEM, hoặc Tailwind component naming).          |
| **RULE_QUA_03** | 🟠 High     | Không để HTML comment chứa thông tin nhạy cảm (credentials, internal path, TODO lâu ngày).            |
| **RULE_QUA_04** | 🟡 Medium   | SVG inline lớn hơn 50 dòng nên được extract ra file riêng và dùng `<use>` hoặc component.             |
| **RULE_QUA_05** | 🟡 Medium   | Không để whitespace / blank line thừa cuối file.                                                      |
| **RULE_QUA_06** | 🟡 Medium   | Dùng `<picture>` hoặc `<source>` cho responsive images với multiple formats (WebP, AVIF).             |
