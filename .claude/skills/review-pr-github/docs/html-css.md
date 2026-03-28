# HTML & CSS Checklist (Pure Frontend)

---

## 1. 🏷️ HTML Fundamentals

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                    |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| **RULE_HTML_01** | 🔴 Critical | **DOCTYPE** phải có ở đầu mọi HTML document — thiếu sẽ kích hoạt quirks mode.                                                      |
| **RULE_HTML_02** | 🔴 Critical | `<html>` phải có `lang` attribute đúng (`<html lang="vi">`) để screen reader và search engine nhận diện ngôn ngữ.                     |
| **RULE_HTML_03** | 🔴 Critical | `<meta charset="UTF-8">` và `<meta name="viewport" content="width=device-width, initial-scale=1">` phải có trong `<head>`.           |
| **RULE_HTML_04** | 🔴 Critical | Mọi `<img>` phải có `alt` — decorative image dùng `alt=""`, content image cần mô tả nội dung.                                           |
| **RULE_HTML_05** | 🔴 Critical | Không dùng inline styles (`style=""`) trong HTML — maintainability kém, vi phạm separation of concerns.                                |
| **RULE_HTML_06** | 🔴 Critical | `<a>` không dùng `href="#"` hoặc `href="javascript:void(0)"` — dùng `href` thực hoặc `role="button"` + `href` phù hợp.                |
| **RULE_HTML_07** | 🟠 High     | `<head>` phải có `<title>` có ý nghĩa, và `<meta name="description">` cho SEO.                                                         |
| **RULE_HTML_08** | 🟠 High     | `<link rel="canonical">` phải có trong `<head>` để tránh duplicate content bị search engine phạt.                                        |
| **RULE_HTML_09** | 🟠 High     | Form input phải có `<label>` liên kết qua `for`/`id`, hoặc `aria-label`/`aria-labelledby` — không dùng placeholder thay label.          |
| **RULE_HTML_10** | 🟠 High     | Button chỉ dùng `<button>` hoặc `<input type="button/submit/reset">`, không dùng `<div>/<span>` có click handler.                        |
| **RULE_HTML_11** | 🟠 High     | Icon-only button phải có `aria-label` mô tả hành động (VD: `aria-label="Đóng menu"`).                                                   |
| **RULE_HTML_12** | 🟠 High     | Script tags phải có `defer` hoặc `async`, đặt trước `</body>` hoặc trong `<head>` với `defer` để tránh render-blocking.              |
| **RULE_HTML_13** | 🟠 High     | `<template>` tag dùng cho HTML fragments không render ngay — thay vì hack bằng `display:none` hoặc comment-out.                        |
| **RULE_HTML_14** | 🟡 Medium   | Dùng `<details>/<summary>` cho accordion thay vì tự build toggle bằng div/span.                                                         |
| **RULE_HTML_15** | 🟡 Medium   | Table chỉ dùng cho tabular data, không dùng table để layout. Table phải có `<thead>`, `<tbody>`, `<th scope>`.                        |
| **RULE_HTML_16** | 🟡 Medium   | Dùng `<article>`, `<section>`, `<aside>`, `<nav>` thay vì toàn `<div>` để semantic rõ ràng.                                             |
| **RULE_HTML_17** | 🟡 Medium   | SVG inline phải có `role` và `aria-label` nếu không có text content.                                                                    |

---

## 2. ♿ Accessibility (WCAG 2.1 AA)

| Rule ID          | Priority    | Tiêu chí đánh giá                                                                                                                         |
| :--------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_A11Y_01** | 🔴 Critical | Mọi interactive element phải focusable và có visible focus indicator — không `outline: none` mà không thay thế bằng style khác.              |
| **RULE_A11Y_02** | 🔴 Critical | Form error phải được announce bằng `role="alert"` hoặc `aria-live="polite"` — không chỉ đổi màu border.                                      |
| **RULE_A11Y_03** | 🔴 Critical | Modal/Dialog phải có `role="dialog"`, `aria-modal="true"`, `aria-labelledby` trỏ đến title, và focus trap bên trong.                         |
| **RULE_A11Y_04** | 🔴 Critical | Mọi `<img>` phải có `alt` đúng — decorative dùng `alt=""`, content image mô tả nội dung.                                                     |
| **RULE_A11Y_05** | 🔴 Critical | Color contrast giữa text và background phải đạt tối thiểu **WCAG AA**: 4.5:1 (normal text), 3:1 (large text 18px+ / bold 14px+).             |
| **RULE_A11Y_06** | 🟠 High     | Trang phải có **skip link** (`<a href="#main-content">Bỏ qua nội dung chính</a>`) là first focusable element để user bỏ qua navigation.     |
| **RULE_A11Y_07** | 🟠 High     | Heading hierarchy phải đúng: `h1` → `h2` → `h3`, không nhảy cấp (`h1` → `h4`).                                                              |
| **RULE_A11Y_08** | 🟠 High     | Dynamic content updates (AJAX, filter, search) phải dùng `aria-live` region để screen reader thông báo.                                     |
| **RULE_A11Y_09** | 🟠 High     | Dropdown/Menu phải có `aria-expanded`, `aria-haspopup`, keyboard navigation (arrow keys, Escape).                                           |
| **RULE_A11Y_10** | 🟠 High     | Tab/Tabpanel interface phải có `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected`, và keyboard navigation (arrow keys).       |
| **RULE_A11Y_11** | 🟠 High     | Tooltip phải có `role="tooltip"` trên trigger, content phải được attach bằng `aria-describedby`.                                              |
| **RULE_A11Y_12** | 🟡 Medium   | `aria-*` attributes phải có giá trị hợp lệ và được cập nhật kịp thời khi state thay đổi.                                                    |
| **RULE_A11Y_13** | 🟡 Medium   | Motion/Animation phải tôn trọng `prefers-reduced-motion` — disable animation khi user yêu cầu.                                               |
| **RULE_A11Y_14** | 🟡 Medium   | Video/Audio phải có caption/subtitle (`<track kind="captions">`) nếu có spoken content.                                                     |
| **RULE_A11Y_15** | 🟡 Medium   | Language switcher phải có `hreflang` attribute đúng trên các phiên bản ngôn ngữ khác.                                                      |
| **RULE_A11Y_16** | 🟡 Medium   | Data table lớn nên có `scope` trên `<th>` (`scope="col"` / `scope="row"`) và `aria-colcount` / `aria-rowcount` khi cần.                   |
| **RULE_A11Y_17** | 🟡 Medium   | Icon-only button phải có `aria-label` mô tả hành động.                                                                                     |
| **RULE_A11Y_18** | 🟡 Medium   | Test bằng keyboard-only navigation (Tab, Shift+Tab, Enter, Space, Arrow keys, Escape) trước mỗi PR.                                       |

---

## 3. 🎨 CSS / SCSS Fundamentals

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                         |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_CSS_01** | 🔴 Critical | Không dùng `!important` ngoại trừ override 3rd-party library có documented API — lạm dụng phá vỡ cascade và maintainability.               |
| **RULE_CSS_02** | 🟠 High     | Nesting SCSS không quá **3 cấp** — tránh selector quá dài, specificity explosion, khó override.                                             |
| **RULE_CSS_03** | 🟠 High     | Dùng CSS Custom Properties (`--var`) hoặc SCSS variables (`$var`) cho màu, spacing, font-size — không hardcode magic values.                  |
| **RULE_CSS_04** | 🟠 High     | `z-index` phải dùng biến/token có tên (`--z-modal: 100`, `--z-dropdown: 50`) — không magic number (`z-index: 99999`).                     |
| **RULE_CSS_05** | 🟠 High     | Dùng `prefers-color-scheme` (light/dark) và `prefers-reduced-motion` để support user preferences.                                            |
| **RULE_CSS_06** | 🟠 High     | Dùng logical properties (`margin-inline-start` thay vì `margin-left`) để hỗ trợ RTL languages và future-proof.                          |
| **RULE_CSS_07** | 🟠 High     | `@layer` cascade ordering: define `@layer reset, tokens, base, components, utilities` — tránh specificity war giữa 3rd-party và custom. |
| **RULE_CSS_08** | 🟡 Medium   | `@mixin` có tham số mặc định hợp lý, có documentation rõ ràng.                                                                            |
| **RULE_CSS_09** | 🟡 Medium   | Tránh selector quá specific (`.page .sidebar .nav ul li a.active`) — dùng class name đơn lẻ, composable.                                     |
| **RULE_CSS_10** | 🟡 Medium   | Animation/transition chỉ nên animate `transform` và `opacity` — tránh animate `width`, `height`, `top`, `left` gây layout reflow.         |
| **RULE_CSS_11** | 🟡 Medium   | Import SCSS theo thứ tự: variables → functions → mixins → base → components → utilities.                                                   |
| **RULE_CSS_12** | 🟡 Medium   | Không để dead code (commented-out CSS) trong commit.                                                                                       |
| **RULE_CSS_13** | 🟡 Medium   | Dùng BEM, SMACSS, hoặc ITCSS convention để đặt tên class — nhất quán trong toàn project.                                                   |
| **RULE_CSS_14** | 🟡 Medium   | Print styles: có `@media print` cho content pages, ẩn navigation/sidebar không cần thiết khi in.                                          |

---

## 4. 📱 Responsive Design

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_RESP_01** | 🔴 Critical | **Mobile-first**: viết CSS cho mobile trước, dùng `min-width` breakpoint để scale up — không `max-width` để scale down.        |
| **RULE_RESP_02** | 🟠 High     | Breakpoint values phải dùng biến/token từ design system (`--breakpoint-md: 768px`), không magic number rải rác trong code.    |
| **RULE_RESP_03** | 🟠 High     | Container full-width phải dùng `width: 100%`, không set `max-width` cứng chặn trên mobile.                                      |
| **RULE_RESP_04** | 🟠 High     | Fluid typography dùng `clamp()` (VD: `clamp(1rem, 0.9rem + 0.5vw, 1.5rem)`) thay vì fixed `px` cho font-size responsive.          |
| **RULE_RESP_05** | 🟠 High     | `srcset` và `sizes` bắt buộc cho `<img>` responsive — tránh load ảnh desktop 4K trên mobile.                                    |
| **RULE_RESP_06** | 🟠 High     | Touch targets (button, link) phải có size tối thiểu **44×44px** (Apple) / **48×48dp** (Material) trên mobile.                  |
| **RULE_RESP_07** | 🟠 High     | Container queries (`@container`) thay vì chỉ media queries khi component cần respond theo parent size chứ không phải viewport.  |
| **RULE_RESP_08** | 🟡 Medium   | Không có horizontal scroll không mong muốn — test bằng `overflow-x: hidden` hoặc horizontal scroll trên mobile viewport.       |
| **RULE_RESP_09** | 🟡 Medium   | Dùng `dvh` / `lvh` thay vì `vh` cho mobile browser with dynamic address bar.                                                       |
| **RULE_RESP_10** | 🟡 Medium   | Responsive images: dùng `<picture>` + `<source type="image/webp">` để serve format tối ưu.                                         |

---

## 5. 🧩 Layout & Modern CSS

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                                                                   |
| :------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_LYT_01** | 🔴 Critical | **Không dùng `float`** để layout — dùng Flexbox hoặc Grid. Float chỉ dùng cho wrapping text quanh image.                         |
| **RULE_LYT_02** | 🟠 High     | Flexbox: dùng `flex-wrap` khi items có thể overflow, set `flex-shrink: 0` cho items không được co nhỏ.                            |
| **RULE_LYT_03** | 🟠 High     | Grid: dùng named lines (`[sidebar-start] 250px [sidebar-end]`) hoặc named areas (`grid-template-areas`) thay vì hardcode track size. |
| **RULE_LYT_04** | 🟠 High     | Luôn dùng `gap` thay vì `margin` để tạo spacing giữa flex/grid items — tránh double margin edge case.                              |
| **RULE_LYT_05** | 🟠 High     | `gap` property phải set trên container, không set margin trên individual items.                                                    |
| **RULE_LYT_06** | 🟡 Medium   | Subgrid (`grid-template-columns: subgrid`) dùng để align nested grids với parent grid lines.                                         |
| **RULE_LYT_07** | 🟡 Medium   | Container query: dùng `@container` để style component dựa trên container size thay vì viewport size khi phù hợp.               |
| **RULE_LYT_08** | 🟡 Medium   | Writing modes: dùng `margin-inline-start/end`, `padding-block-start/end` thay vì physical properties để support RTL.               |
| **RULE_LYT_09** | 🟡 Medium   | `min()` / `max()` / `clamp()` cho fluid sizing: `width: min(100%, 600px)` thay vì `width: 100%; max-width: 600px`.                  |
| **RULE_LYT_10** | 🟡 Medium   | `aspect-ratio` property dùng cho images/video/cards để reserve space trước khi content load, giảm CLS.                            |

---

## 6. ✍️ Typography

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                       |
| :-------------- | :---------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_TYPE_01** | 🔴 Critical | Font-size phải dùng `rem` hoặc `em`, **không dùng `px`** — để browser respect user zoom/font-size preference.                           |
| **RULE_TYPE_02** | 🟠 High     | Line-height cho body text: `1.5` – `1.7` (unitless), heading: `1.2` – `1.3` — không set `px` cho line-height.                          |
| **RULE_TYPE_03** | 🟠 High     | Measure (max-width của text column): `ch` unit (`max-width: 65ch`) hoặc `px` (`max-width: 680px`) — dòng quá dài gây mỏi mắt.         |
| **RULE_TYPE_04** | 🟠 High     | Font loading: dùng `font-display: swap` để tránh FOIT (invisible text), có `<link rel="preconnect">` cho external fonts.               |
| **RULE_TYPE_05** | 🟠 High     | Font weights phải match available weights trong font file — không `font-weight: 374` không supported.                                    |
| **RULE_TYPE_06** | 🟠 High     | Variable fonts dùng khi cần nhiều weights/styles — giảm HTTP requests và file size so với multiple font files.                         |
| **RULE_TYPE_07** | 🟡 Medium   | Text overflow: dùng `text-overflow: ellipsis` + `overflow: hidden` + `white-space: nowrap` cho single-line truncated text.             |
| **RULE_TYPE_08** | 🟡 Medium   | Hyphenation: dùng `hyphens: auto` + `overflow-wrap: break-word` cho text wrapping tốt trên narrow containers.                           |
| **RULE_TYPE_09** | 🟡 Medium   | Type scale (heading sizes) phải defined trong design system token, không ad-hoc `font-size: 27px`.                                      |
| **RULE_TYPE_10** | 🟡 Medium   | Font loading optimization: self-host fonts thay vì Google Fonts CDN khi cần offline support hoặc performance tối ưu hơn.               |

---

## 7. 📝 Forms & Input Validation

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                              |
| :-------------- | :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_FORM_01** | 🔴 Critical | Input phải có `<label for="id">` liên kết chính xác, hoặc `aria-labelledby` / `aria-label` — không dùng placeholder thay label.               |
| **RULE_FORM_02** | 🔴 Critical | Error message phải: (1) nằm gần input, (2) dùng `aria-describedby` để liên kết, (3) `role="alert"` hoặc `aria-live` để announce.              |
| **RULE_FORM_03** | 🟠 High     | Dùng đúng `type` attribute (`email`, `tel`, `number`, `date`, `url`) — browser tự validate và show appropriate keyboard trên mobile.          |
| **RULE_FORM_04** | 🟠 High     | `autocomplete` attribute phải đúng (`autocomplete="email"`, `autocomplete="given-name"`...) — hỗ trợ browser autofill, UX tốt hơn.        |
| **RULE_FORM_05** | 🟠 High     | Input length (maxlength) phải match validation phía server — không chỉ rely vào frontend maxlength.                                           |
| **RULE_FORM_06** | 🟠 High     | Required fields phải có `required` attribute và visual indicator (asterisk + legend "*=required"), không chỉ rely vào placeholder.          |
| **RULE_FORM_07** | 🟠 High     | Password input phải có `type="password"` và nút toggle show/hide password.                                                                      |
| **RULE_FORM_08** | 🟠 High     | Client-side validation chỉ là UX enhancement, **server-side validation bắt buộc phải có** — không tin client.                                 |
| **RULE_FORM_09** | 🟡 Medium   | Dùng `pattern` attribute hoặc `inputmode` (`inputmode="numeric"`, `inputmode="decimal"`) để trigger right keyboard trên mobile.            |
| **RULE_FORM_10** | 🟡 Medium   | Form submit button phải disabled state rõ ràng, loading state có spinner/indicator, không spam click khi đang submit.                          |

---

## 8. 🔍 SEO & Document Structure

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                                                                          |
| :------------- | :---------- | :----------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_SEO_01** | 🔴 Critical | `<title>` mỗi page phải unique, chứa keyword quan trọng, dưới 60 ký tự.                                                                    |
| **RULE_SEO_02** | 🔴 Critical | `<meta name="description">` mỗi page unique, chứa keyword, 120–160 ký tự.                                                                |
| **RULE_SEO_03** | 🔴 Critical | Heading hierarchy đúng: exactly một `<h1>` per page, `h2`–`h6` phân cấp đúng, chứa keyword khi tự nhiên.                                   |
| **RULE_SEO_04** | 🟠 High     | Open Graph meta tags (`og:title`, `og:description`, `og:image`, `og:url`) cho social sharing.                                              |
| **RULE_SEO_05** | 🟠 High     | Twitter Card meta (`twitter:card`, `twitter:title`, `twitter:image`) khi cần share lên Twitter/X.                                          |
| **RULE_SEO_06** | 🟠 High     | `<link rel="canonical">` để specify canonical URL, tránh duplicate content penalty.                                                          |
| **RULE_SEO_07** | 🟠 High     | Structured data JSON-LD cho content quan trọng (Article, Product, FAQ, Breadcrumb...) — dùng schema.org vocabulary đúng.                  |
| **RULE_SEO_08** | 🟠 High     | `<meta name="robots" content="noindex, nofollow">` cho pages không muốn index (login, admin, thank-you pages).                              |
| **RULE_SEO_09** | 🟡 Medium   | Breadcrumb navigation dùng `<nav aria-label="Breadcrumb">` + structured data BreadcrumbList.                                                |
| **RULE_SEO_10** | 🟡 Medium   | `<link rel="alternate" hreflang="x-default">` và `<link rel="alternate" hreflang="[lang]">` cho multi-language sites.                       |

---

## 9. ⚡ Performance (Frontend)

| Rule ID            | Priority    | Tiêu chí đánh giá                                                                                                                             |
| :----------------- | :---------- | :-------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_PERF_F_01** | 🔴 Critical | **Critical CSS** phải inline trong `<head>` (inline hoặc `<link rel="preload">`), non-critical load async bằng `media="print" onload`.         |
| **RULE_PERF_F_02** | 🔴 Critical | External CSS phải load với `media="all"` và không có `blocking="render"` attribute.                                                            |
| **RULE_PERF_F_03** | 🔴 Critical | `<script>` dùng `defer` (default cho hầu hết cases) hoặc `async` (analytics, 3rd-party không cần execution order) — không render-blocking.    |
| **RULE_PERF_F_04** | 🔴 Critical | CLS (Cumulative Layout Shift): reserve space cho images/video/ads bằng `width`/`height`, `aspect-ratio`, hoặc `min-height`.                    |
| **RULE_PERF_F_05** | 🟠 High     | Images: dùng WebP/AVIF với `<picture>`, có `srcset` cho multiple resolutions, `width`/`height` attributes để prevent CLS.                      |
| **RULE_PERF_F_06** | 🟠 High     | `<img>` below-the-fold: bắt buộc `loading="lazy"` để trì hoãn load cho đến khi gần viewport.                                                    |
| **RULE_PERF_F_07** | 🟠 High     | Font preconnect: `<link rel="preconnect" href="https://fonts.gstatic.com">` cho Google Fonts, self-host fonts khi có thể.                      |
| **RULE_PERF_F_08** | 🟠 High     | Icon: import từng icon riêng từ icon library (Heroicons, Phosphor, Lucide) — không load entire icon set.                                       |
| **RULE_PERF_F_09** | 🟡 Medium   | CSS animation chỉ animate `transform` và `opacity` — tránh animate properties gây layout/paint (width, height, top, left, background-color). |
| **RULE_PERF_F_10** | 🟡 Medium   | `<link rel="preload">` cho fonts và critical assets cần sớm — không preload quá nhiều resource tránh contention.                                  |
| **RULE_PERF_F_11** | 🟡 Medium   | Video/audio phải có `preload="none"` nếu không autoplay. Video poster image để show frame trước khi play.                                      |
| **RULE_PERF_F_12** | 🟡 Medium   | JavaScript bundle: code splitting, lazy loading, tree-shaking enabled. Third-party scripts đặt cuối `<body>` hoặc dùng `defer`.              |

---

## 10. 🏗️ CSS Architecture

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                           |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| **RULE_ARCH_01** | 🔴 Critical | **CSS Custom Properties (tokens)** là single source of truth cho design values — màu, spacing, font, border-radius, shadow.                |
| **RULE_ARCH_02** | 🟠 High     | BEM naming: `.block__element--modifier` — VD: `.card__header--featured`. Không nesting quá 1 cấp trong class name.                          |
| **RULE_ARCH_03** | 🟠 High     | ITCSS / Feature-based folder structure: `tokens/` → `base/` → `components/` → `utilities/` — đúng thứ tự import để cascade hoạt động đúng. |
| **RULE_ARCH_04** | 🟠 High     | CSS `@layer` ordering: `@layer reset, tokens, base, layout, components, utilities` — 3rd-party CSS vào layer riêng, không pollute global.  |
| **RULE_ARCH_05** | 🟠 High     | Component styles phải scoped — dùng class-based (BEM) hoặc CSS Modules hoặc Shadow DOM, không style by HTML tag name global.               |
| **RULE_ARCH_06** | 🟠 High     | Design tokens (màu, spacing, font) phải defined ở một chỗ, không duplicate giá trị rải rác.                                                 |
| **RULE_ARCH_07** | 🟡 Medium   | Không style bằng HTML tag selectors ngoài reset/base — luôn dùng class name cho component styles.                                            |
| **RULE_ARCH_08** | 🟡 Medium   | `@extend` trong SCSS dùng hạn chế — ưu tiên mixin hoặc utility classes vì `@extend` tạo coupling giữa selectors.                             |
| **RULE_ARCH_09** | 🟡 Medium   | File SCSS không quá 300 dòng — tách thành partial files theo component/module.                                                                |
| **RULE_ARCH_10** | 🟡 Medium   | Comment inline cho complex CSS: `@name — description` block comment, không comment-out dead code.                                             |

---

## 11. 🔘 State & Interactions

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                           |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| **RULE_STATE_01** | 🔴 Critical | `:focus` phải có visible style — không `outline: none` mà không thay thế bằng custom focus ring. Dùng `:focus-visible` để chỉ hiện khi keyboard nav. |
| **RULE_STATE_02** | 🟠 High     | Interactive states phải được style đầy đủ: `:hover`, `:focus`, `:focus-visible`, `:active`, `:disabled`, `:visited` (link).                  |
| **RULE_STATE_03** | 🟠 High     | CSS Custom Properties cho state: `--button-bg-hover`, `--input-border-focus` — không hardcode state colors trong selectors.                   |
| **RULE_STATE_04** | 🟠 High     | Loading state: dùng `aria-busy="true"` trên form/container, button disabled + spinner, không chỉ change opacity.                            |
| **RULE_STATE_05** | 🟠 High     | Disabled state: `pointer-events: none` + `opacity: 0.5` + `cursor: not-allowed` + `aria-disabled="true"`, không chỉ visual cue.               |
| **RULE_STATE_06** | 🟡 Medium   | Transitions: define `transition: property duration timing-function` rõ ràng, không `transition: all` gây performance issue.                    |
| **RULE_STATE_07** | 🟡 Medium   | Hover/Focus/Active order trong CSS: `:hover` → `:focus-visible` → `:active` — đúng cascade, không conflict.                                     |
| **RULE_STATE_08** | 🟡 Medium   | `:focus:not(:focus-visible)` để loại bỏ focus ring khi dùng mouse nhưng giữ lại khi keyboard.                                                 |
| **RULE_STATE_09** | 🟡 Medium   | Animation `prefers-reduced-motion`: `@media (prefers-reduced-motion: reduce)` disable transition/animation không cần thiết.                   |
| **RULE_STATE_10** | 🟡 Medium   | Touch feedback: `touch-action: manipulation` để loại bỏ 300ms delay trên mobile, `-webkit-tap-highlight-color: transparent` khi cần.          |

---

## 12. 🧹 Code Quality & Maintainability

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                   |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_QUAL_01** | 🔴 Critical | **Xóa sạch `console.log`**, `debugger`, `debug` attributes, dead code trước khi commit.**                                               |
| **RULE_QUAL_02** | 🟠 High     | CSS class names phải theo convention nhất quán (BEM, Tailwind component naming pattern) trong toàn project.                           |
| **RULE_QUAL_03** | 🟠 High     | Không HTML comment chứa thông tin nhạy cảm, credentials, internal paths, hoặc TODO lâu ngày không resolve.                             |
| **RULE_QUAL_04** | 🟠 High     | SVG inline lớn hơn ~50 dòng phải extract ra file riêng (`/icons/`) và dùng `<use>` hoặc component.                                     |
| **RULE_QUAL_05** | 🟡 Medium   | Whitespace: không trailing spaces, không blank line thừa cuối file.                                                                 |
| **RULE_QUAL_06** | 🟡 Medium   | Dùng `<picture>` + `<source>` cho responsive images với multiple formats (WebP, AVIF) — không chỉ single `<img>`.                      |
| **RULE_QUAL_07** | 🟡 Medium   | Comment CSS phải mô tả "why", không "what" — code đã tự giải thích what, comment giải thích business logic hoặc workaround có lý do.   |
| **RULE_QUAL_08** | 🟡 Medium   | Selector specificity không vượt quá `0-2-1` (0 IDs, 2 classes, 1 element) — giới hạn này đủ power mà không conflict.                  |
| **RULE_QUAL_09** | 🟡 Medium   | CSS file có thứ tự properties nhất quán: positioning → box model → typography → visual → transition/animation.                           |
| **RULE_QUAL_10** | 🟡 Medium   | `@charset "UTF-8"` phải là dòng đầu tiên trong CSS/SCSS file nếu có non-ASCII characters.                                              |
| **RULE_QUAL_11** | 🟡 Medium   | Review CSS specificity conflicts — dùng DevTools audit để phát hiện rules không applied đúng.                                           |
| **RULE_QUAL_12** | 🟡 Medium   | Lighthouse accessibility score >= 90 cho production pages — audit định kỳ.                                                           |
