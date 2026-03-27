# Blade, Livewire & Tailwind CSS Checklist

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

## 2. ⚡ Livewire Specifics

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                                                                           |
| :------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| **RULE_LW_01** | 🔴 Critical | **Không dùng public property lưu dữ liệu nhạy cảm** (ID nội bộ, role...) mà không validate lại server-side. User có thể tamper từ frontend. |
| **RULE_LW_02** | 🔴 Critical | **Mọi action method (`wire:click`) phải có authorization check**. Livewire expose method ra ngoài, cần guard cẩn thận.                      |
| **RULE_LW_03** | 🟠 High     | Component chỉ xử lý UI state & user interaction. Business logic phải nằm trong Service.                                                     |
| **RULE_LW_04** | 🟠 High     | Form Object (Livewire v3) chỉ chứa validation và data binding.                                                                              |
| **RULE_LW_05** | 🟠 High     | Dùng attribute `#[Locked]` cho property không được phép sửa từ frontend.                                                                    |
| **RULE_LW_06** | 🟠 High     | SPA Mode (`wire:navigate`): Kiểm tra page state không bị leak giữa các lần chuyển trang.                                                    |
| **RULE_LW_07** | 🟠 High     | Dùng `wire:model.lazy` / `wire:model.blur` thay cho `live` với input không cần real-time để giảm network request.                           |
| **RULE_LW_08** | 🟠 High     | Có `wire:loading` để feedback UI, chặn user click nhiều lần (duplicate action).                                                             |
| **RULE_LW_09** | 🟠 High     | **Bắt buộc dùng `wire:key`** khi render danh sách động (`@foreach`) để diff DOM chính xác.                                                  |
| **RULE_LW_10** | 🟡 Medium   | Component quá phức tạp cần tách nhỏ thành các child component.                                                                              |
| **RULE_LW_11** | 🟡 Medium   | Attribute `#[Validate]` chỉ là shorthand, không thay thế server-side authorization.                                                         |
| **RULE_LW_12** | 🟡 Medium   | Phân tách rõ middleware/route giữa endpoint public API và endpoint nội bộ của Livewire.                                                     |

---

## 3. ⚡ Livewire Directives & Alpine.js

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

## 4. 🌊 Tailwind CSS

| Rule ID        | Priority  | Tiêu chí đánh giá                                                                                                                               |
| :------------- | :-------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_TW_01** | 🟠 High   | Chuỗi class quá dài (>8 utility classes) trên một element nên được extract vào `@apply` hoặc component.                                         |
| **RULE_TW_02** | 🟠 High   | Không dùng `style=""` inline khi có utility class tương đương — phá vỡ consistency.                                                             |
| **RULE_TW_03** | 🟠 High   | Màu sắc, spacing, font-size phải dùng token trong `tailwind.config` — không dùng `text-[13px]` arbitrary value cho giá trị thuộc design system. |
| **RULE_TW_04** | 🟡 Medium | Class responsive (`sm:`, `md:`, `lg:`) phải có thứ tự nhất quán: mobile-first.                                                                  |
| **RULE_TW_05** | 🟡 Medium | Variant `dark:` phải được test — không chỉ thêm cho có mà không verify trên dark mode.                                                          |
| **RULE_TW_06** | 🟡 Medium | Không dùng class `@apply` trong file Blade — chỉ dùng trong file CSS/SCSS riêng.                                                                |
| **RULE_TW_07** | 🟡 Medium | Tailwind config phải extend theme, không override default config mà không understand implications.                                                 |
| **RULE_TW_08** | 🟡 Medium | Custom colors, fonts, spacing phải có name descriptive, không dùng generic names.                                                                |

---

## 5. ⚡ Performance (Blade & Livewire)

| Rule ID            | Priority  | Tiêu chí đánh giá                                                                                                        |
| :----------------- | :-------- | :----------------------------------------------------------------------------------------------------------------------- |
| **RULE_PERF_B_01** | 🟠 High   | Không load toàn bộ icon set khi chỉ dùng một vài icon — import từng icon riêng (Heroicons, Phosphor...).                  |
| **RULE_PERF_B_02** | 🟠 High   | Tránh re-render Livewire toàn bộ component khi chỉ cần cập nhật một phần — dùng `wire:model.defer` hoặc child component. |
| **RULE_PERF_B_03** | 🟡 Medium | Blade component lazy loading: `<x-component lazy>` cho below-the-fold components.                                           |
| **RULE_PERF_B_04** | 🟡 Medium | Livewire: dùng `defer` loading cho form inputs không cần real-time validation.                                             |
| **RULE_PERF_B_05** | 🟡 Medium | Cache blade views: `php artisan view:cache` trong production.                                                              |
| **RULE_PERF_B_06** | 🟡 Medium | Livewire pagination: dùng `withUrl()` để preserve filters/search khi chuyển trang.                                        |

---

## 6. 🧹 Code Quality

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                     |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------- |
| **RULE_BQ_01** | 🔴 Critical | Xóa sạch `console.log`, debug attribute (`x-data="{ debug: true }"`) trước khi commit.                |
| **RULE_BQ_02** | 🟠 High     | Blade component (`<x-...>`) đặt trong đúng thư mục theo tính năng, không để flat trong `components/`. |
| **RULE_BQ_03** | 🟠 High     | Livewire component đặt trong `app/Livewire/` hoặc `resources/views/livewire/`, nhất quán.             |
| **RULE_BQ_04** | 🟡 Medium   | Tailwind classes nhất quán ordering: classes theo luật headwind/intializer.                          |
| **RULE_BQ_05** | 🟡 Medium   | Tách inline Tailwind classes phức tạp thành Blade component hoặc `@apply` classes.                    |
