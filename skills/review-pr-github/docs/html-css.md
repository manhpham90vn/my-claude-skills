# Blade & CSS

## 1. 🏷️ Blade Template

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                            |
| :-------------- | :---------- | :------------------------------------------------------------------------------------------- |
| **RULE_BLD_01** | 🔴 Critical | **Không dùng `{!! !!}`** để render dữ liệu người dùng nhập → XSS. Chỉ dùng `{{ }}`.          |
| **RULE_BLD_02** | 🔴 Critical | Không nhúng query DB trực tiếp trong Blade (không gọi Model/DB trong view).                  |
| **RULE_BLD_03** | 🟠 High     | Logic phức tạp (if lồng nhiều lớp, vòng lặp nặng) phải được đưa về ViewModel hoặc Component. |
| **RULE_BLD_04** | 🟠 High     | Dùng `@include` / `@component` / `<x-component>` để tái sử dụng — không copy-paste HTML.     |
| **RULE_BLD_05** | 🟠 High     | Biến truyền vào `@include` / component phải được khai báo `@props` rõ ràng.                  |
| **RULE_BLD_06** | 🟠 High     | `@foreach` trên collection lớn cần kết hợp với pagination; không dump toàn bộ.               |
| **RULE_BLD_07** | 🟡 Medium   | Dùng `@isset`, `@empty`, `@auth`, `@can` thay vì `@if(isset(...))` verbose.                  |
| **RULE_BLD_08** | 🟡 Medium   | `@section` / `@yield` có tên nhất quán, không để section trống vô nghĩa.                     |
| **RULE_BLD_09** | 🟡 Medium   | Không hardcode URL — dùng `route()`, `asset()`, `url()`.                                     |
| **RULE_BLD_10** | 🟡 Medium   | String hiển thị cho người dùng phải qua `__()` / `trans()` để hỗ trợ i18n.                   |

---

## 2. ⚡ Livewire Directives & Alpine.js

| Rule ID          | Priority    | Tiêu chí đánh giá                                                                                                  |
| :--------------- | :---------- | :----------------------------------------------------------------------------------------------------------------- |
| **RULE_LW_T_01** | 🔴 Critical | `wire:model` trên input nhạy cảm phải có server-side validation tương ứng (không tin client).                      |
| **RULE_LW_T_02** | 🔴 Critical | Action bind bằng `wire:click` / `wire:submit` không được gọi method chứa logic phân quyền mà bỏ qua `authorize()`. |
| **RULE_LW_T_03** | 🟠 High     | **Bắt buộc `wire:key`** trong mọi `@foreach` render Livewire component hoặc element động.                          |
| **RULE_LW_T_04** | 🟠 High     | Dùng `wire:model.lazy` / `wire:model.blur` cho input không cần real-time sync để giảm request.                     |
| **RULE_LW_T_05** | 🟠 High     | Có `wire:loading` / `wire:loading.attr="disabled"` để chặn duplicate submit khi đang xử lý.                        |
| **RULE_LW_T_06** | 🟠 High     | `wire:navigate` (SPA): kiểm tra không leak state giữa các lần chuyển trang.                                        |
| **RULE_LW_T_07** | 🟡 Medium   | Không mix `wire:model` và Alpine `x-model` trên cùng một input — gây conflict state.                               |
| **RULE_LW_T_08** | 🟡 Medium   | Event `wire:click.prevent` / `wire:submit.prevent` — dùng `.prevent` khi cần block default.                        |
| **RULE_LW_T_09** | 🟡 Medium   | `$wire.dispatch()` / `Livewire.dispatch()` phải dùng tên event dạng `kebab-case` nhất quán.                        |
| **RULE_ALP_01**  | 🟠 High     | `x-data` không chứa logic phức tạp inline — extract sang `Alpine.data()` hoặc `x-init` riêng.                      |
| **RULE_ALP_02**  | 🟠 High     | `x-html` có nguy cơ XSS giống `{!! !!}` — chỉ dùng với dữ liệu đã sanitize chắc chắn.                              |
| **RULE_ALP_03**  | 🟡 Medium   | `x-cloak` phải được khai báo trong CSS để tránh flash of unstyled content (FOUC).                                  |
| **RULE_ALP_04**  | 🟡 Medium   | `x-ref` đặt tên descriptive, không dùng tên chung chung (`input`, `btn`, `el`).                                    |

---

## 3. 🎨 SCSS / CSS

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                               |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_CSS_01** | 🔴 Critical | Không dùng `!important` để override — chỉ chấp nhận khi override 3rd-party utility.                                                             |
| **RULE_CSS_02** | 🟠 High     | Nesting SCSS không quá **3 cấp** — tránh selector quá dài, khó override và đọc.                                                                 |
| **RULE_CSS_03** | 🟠 High     | Dùng CSS Custom Properties (`--var`) hoặc SCSS variables (`$var`) cho màu, spacing, breakpoint — không hardcode giá trị magic (`margin: 13px`). |
| **RULE_CSS_04** | 🟠 High     | Không duplicate selector/block giống nhau ở nhiều nơi — extract thành mixin hoặc placeholder `%`.                                               |
| **RULE_CSS_05** | 🟠 High     | `z-index` phải dùng biến/token có tên (`$z-modal`, `$z-dropdown`) — không magic number.                                                         |
| **RULE_CSS_06** | 🟡 Medium   | `@mixin` có tham số mặc định hợp lý, không để caller phải truyền giá trị hiển nhiên.                                                            |
| **RULE_CSS_07** | 🟡 Medium   | Tránh selector quá specific (`.page .sidebar .nav ul li a.active`) — tăng specificity không cần thiết.                                          |
| **RULE_CSS_08** | 🟡 Medium   | File SCSS dài hơn **300 dòng** nên được tách theo component/module.                                                                             |
| **RULE_CSS_09** | 🟡 Medium   | Import SCSS theo đúng thứ tự: variables → mixins → base → components → utilities.                                                               |
| **RULE_CSS_10** | 🟡 Medium   | Không để code CSS/SCSS bị comment-out (dead code) trong commit.                                                                                 |

---

## 4. 🌊 Tailwind CSS

| Rule ID        | Priority  | Tiêu chí đánh giá                                                                                                                               |
| :------------- | :-------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_TW_01** | 🟠 High   | Chuỗi class quá dài (>8 utility classes) trên một element nên được extract vào `@apply` hoặc component.                                         |
| **RULE_TW_02** | 🟠 High   | Không dùng `style=""` inline khi có utility class tương đương — phá vỡ consistency.                                                             |
| **RULE_TW_03** | 🟠 High   | Màu sắc, spacing, font-size phải dùng token trong `tailwind.config` — không dùng `text-[13px]` arbitrary value cho giá trị thuộc design system. |
| **RULE_TW_04** | 🟡 Medium | Class responsive (`sm:`, `md:`, `lg:`) phải có thứ tự nhất quán: mobile-first.                                                                  |
| **RULE_TW_05** | 🟡 Medium | Variant `dark:` phải được test — không chỉ thêm cho có mà không verify trên dark mode.                                                          |
| **RULE_TW_06** | 🟡 Medium | Không dùng class `@apply` trong file Blade — chỉ dùng trong file CSS/SCSS riêng.                                                                |

---

## 5. ♿ Accessibility (a11y)

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

## 6. ⚡ Performance (Frontend)

| Rule ID            | Priority  | Tiêu chí đánh giá                                                                                                        |
| :----------------- | :-------- | :----------------------------------------------------------------------------------------------------------------------- |
| **RULE_PERF_F_01** | 🟠 High   | Không load toàn bộ icon set khi chỉ dùng một vài icon — import từng icon riêng.                                          |
| **RULE_PERF_F_02** | 🟠 High   | `<img>` lớn phải có `loading="lazy"` nếu không nằm above-the-fold.                                                       |
| **RULE_PERF_F_03** | 🟠 High   | Tránh re-render Livewire toàn bộ component khi chỉ cần cập nhật một phần — dùng `wire:model.defer` hoặc child component. |
| **RULE_PERF_F_04** | 🟡 Medium | CSS animation nên dùng `transform` / `opacity` — tránh animate `width`, `height`, `top`, `left` gây layout reflow.       |
| **RULE_PERF_F_05** | 🟡 Medium | Không nhúng `<style>` / `<script>` inline lớn trong Blade — tách ra file riêng và cache.                                 |
| **RULE_PERF_F_06** | 🟡 Medium | Font chữ ngoài (`Google Fonts`…) phải có `preconnect` / `preload` hint.                                                  |

---

## 7. 🧹 Code Quality & Maintainability

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                     |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------- |
| **RULE_QUA_01** | 🔴 Critical | Xóa sạch `console.log`, debug attribute (`x-data="{ debug: true }"`) trước khi commit.                |
| **RULE_QUA_02** | 🟠 High     | Tên class CSS/SCSS phải theo một convention nhất quán (BEM, hoặc Tailwind component naming).          |
| **RULE_QUA_03** | 🟠 High     | Không để HTML comment chứa thông tin nhạy cảm (credentials, internal path, TODO lâu ngày).            |
| **RULE_QUA_04** | 🟡 Medium   | Blade component (`<x-...>`) đặt trong đúng thư mục theo tính năng, không để flat trong `components/`. |
| **RULE_QUA_05** | 🟡 Medium   | SVG inline lớn hơn 50 dòng nên được extract ra file riêng và dùng `@include` / `<x-icon>`.            |
| **RULE_QUA_06** | 🟡 Medium   | Không để whitespace / blank line thừa cuối file.                                                      |
