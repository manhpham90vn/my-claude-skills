# Blade, Livewire & Tailwind CSS Checklist

---

## 1. 🏷️ Blade Template Fundamentals

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                        |
| :-------------- | :---------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_BLD_01** | 🔴 Critical | **Không dùng `{!! !!}`** để render dữ liệu người dùng nhập (XSS). Chỉ dùng `{{ }}` trừ khi dữ liệu đã sanitize rõ ràng.                 |
| **RULE_BLD_02** | 🔴 Critical | Không gọi Model/Query trực tiếp trong Blade (`User::...`, `DB::...`). Mọi dữ liệu phải được chuẩn bị ở controller/service/view model. |
| **RULE_BLD_03** | 🔴 Critical | Form phải có `@csrf` cho mọi action ghi dữ liệu (POST/PUT/PATCH/DELETE).                                                              |
| **RULE_BLD_04** | 🟠 High     | Không hardcode URL; dùng `route()`, `url()`, `asset()`, `Vite::asset()` để tránh broken link khi đổi route/base path.                |
| **RULE_BLD_05** | 🟠 High     | Strings hiển thị user-facing phải dùng `__()` / `trans()` để hỗ trợ i18n, không hardcode text nếu project có đa ngôn ngữ.           |
| **RULE_BLD_06** | 🟠 High     | Component tái sử dụng phải dùng `<x-...>` hoặc `@include`, không copy-paste khối HTML lớn giữa nhiều view.                           |
| **RULE_BLD_07** | 🟠 High     | Component props phải khai báo rõ bằng `@props([...])`; không dùng biến ngầm từ parent gây khó trace.                                  |
| **RULE_BLD_08** | 🟠 High     | Dùng `@error('field')` cho error rendering thay vì if-check thủ công lặp lại ở nhiều nơi.                                            |
| **RULE_BLD_09** | 🟠 High     | Assets phải load qua `@vite(...)` / Mix helper chuẩn của dự án, không `<script src="/js/app.js">` hardcoded.                         |
| **RULE_BLD_10** | 🟠 High     | Dùng `@once` / `@pushOnce` cho script/style blocks để tránh include trùng khi component render nhiều lần.                             |
| **RULE_BLD_11** | 🟡 Medium   | Dùng `@auth`, `@guest`, `@can`, `@cannot` thay cho if-check verbose trên auth state/permission.                                      |
| **RULE_BLD_12** | 🟡 Medium   | `@section` / `@yield` naming phải nhất quán (`content`, `scripts`, `styles`), tránh section rỗng không mục đích.                      |
| **RULE_BLD_13** | 🟡 Medium   | Dùng slot fallback (`{{ $slot ?? '...' }}` hoặc default slot patterns) khi component cần graceful fallback.                            |
| **RULE_BLD_14** | 🟡 Medium   | Các list lớn phải phân trang trước khi render (`paginate()`), không `@foreach` toàn bộ dataset lớn trong một request.                 |
| **RULE_BLD_15** | 🟡 Medium   | Layout semantics: main content phải nằm trong `<main>`, điều hướng trong `<nav>`, tránh toàn bộ là `<div>`.                           |

---

## 2. 🟢 Alpine.js

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                              |
| :-------------- | :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_ALP_01** | 🔴 Critical | `x-html` chỉ dùng với dữ liệu đã sanitize chắc chắn; mặc định dùng `x-text` để tránh XSS.                                                     |
| **RULE_ALP_02** | 🔴 Critical | Không trộn `x-model` và `wire:model` trên cùng một input nếu không có chủ đích rõ ràng (dễ lệch state, race updates).                       |
| **RULE_ALP_03** | 🟠 High     | `x-data` không chứa logic phức tạp inline; extract qua `Alpine.data('name', () => (...))`.                                                   |
| **RULE_ALP_04** | 🟠 High     | Dùng `x-cloak` + CSS `[x-cloak]{display:none !important;}` để tránh FOUC khi Alpine chưa init.                                                |
| **RULE_ALP_05** | 🟠 High     | `x-init` chỉ làm init nhẹ; side effects phức tạp đưa vào method riêng hoặc lifecycle có kiểm soát.                                           |
| **RULE_ALP_06** | 🟠 High     | `x-for` phải có key ổn định (`:key="item.id"`), không key bằng index khi danh sách reorder/filter.                                           |
| **RULE_ALP_07** | 🟠 High     | `x-show` cần kết hợp transition hợp lý (`x-transition`) và a11y attributes (`aria-hidden`) khi nội dung ảnh hưởng UX.                        |
| **RULE_ALP_08** | 🟠 High     | `x-effect` không được gây side-effect lặp vô hạn; logic phải idempotent hoặc có guard condition.                                             |
| **RULE_ALP_09** | 🟡 Medium   | Global state dùng `Alpine.store()` cho dữ liệu chia sẻ; tránh event spaghetti giữa nhiều component độc lập.                                  |
| **RULE_ALP_10** | 🟡 Medium   | `$watch` phải unsubscribe/cleanup khi cần; tránh leak listeners trong component render động.                                                  |
| **RULE_ALP_11** | 🟡 Medium   | Event names khi dùng `$dispatch` theo `kebab-case` nhất quán (`modal-opened`, `cart-updated`).                                               |
| **RULE_ALP_12** | 🟡 Medium   | `x-ref` đặt tên có nghĩa (`emailInput`, `submitBtn`), không dùng tên chung chung (`el`, `input`).                                            |
| **RULE_ALP_13** | 🟡 Medium   | Không dùng Alpine cho business logic quan trọng; Alpine chỉ giữ vai trò UI behavior/client interactivity.                                    |
| **RULE_ALP_14** | 🟡 Medium   | Alpine script nên load `defer` và đặt sau core CSS để tránh blocking render.                                                                 |

---

## 3. ⚡ Livewire Fundamentals

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                                                                                  |
| :------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_LW_01** | 🔴 Critical | Mọi action methods (`wire:click`, `wire:submit`) phải có authorization check (`authorize()`, policy/gate).                                       |
| **RULE_LW_02** | 🔴 Critical | Public properties không chứa dữ liệu nhạy cảm mà không re-validate server-side (user có thể tamper payload).                                      |
| **RULE_LW_03** | 🔴 Critical | Validation bắt buộc server-side (`$this->validate()` / Form Object / custom validator), không tin client.                                         |
| **RULE_LW_04** | 🟠 High     | Business logic không đặt trong component render/action phức tạp; chuyển vào service/action class để test được.                                   |
| **RULE_LW_05** | 🟠 High     | Dùng `#[Locked]` cho properties không được phép sửa từ frontend.                                                                                  |
| **RULE_LW_06** | 🟠 High     | Với danh sách lớn, dùng pagination/chunk; không hydrate toàn bộ dataset vào component state.                                                     |
| **RULE_LW_07** | 🟠 High     | Lifecycle hooks (`mount`, `hydrate`, `updating*`, `updated*`) phải có mục đích rõ ràng; tránh side effects ẩn khó debug.                        |
| **RULE_LW_08** | 🟠 High     | File upload dùng `WithFileUploads`, validate mime/size và lưu qua storage disk đúng config.                                                       |
| **RULE_LW_09** | 🟠 High     | Redirect dùng đúng ngữ cảnh (`return $this->redirectRoute(...)` / `redirect()->route(...)`) để đảm bảo behavior nhất quán.                       |
| **RULE_LW_10** | 🟠 High     | Form Object / DTO dùng để gom state form phức tạp, tránh component class phình to với quá nhiều public properties.                                |
| **RULE_LW_11** | 🟠 High     | Không dispatch event bừa bãi; event names chuẩn hóa và documented.                                                                                |
| **RULE_LW_12** | 🟡 Medium   | Khi dùng computed properties/getters, đảm bảo không trigger query nặng lặp lại mỗi re-render.                                                    |
| **RULE_LW_13** | 🟡 Medium   | Dùng eager loading trong queries để tránh N+1 trong vòng đời re-render của component.                                                            |
| **RULE_LW_14** | 🟡 Medium   | Tách component quá lớn thành child components để giảm payload/hydration cost và tăng maintainability.                                             |
| **RULE_LW_15** | 🟡 Medium   | Dùng `reset()`, `resetValidation()`, `resetErrorBag()` sau action phù hợp để state nhất quán giữa các lần submit.                                |
| **RULE_LW_16** | 🟡 Medium   | Với API/public endpoints liên quan Livewire, middleware và throttling phải rõ ràng theo route nhóm.                                               |

---

## 4. 🧠 Livewire Directives & UI Patterns

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                              |
| :-------------- | :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_LWD_01** | 🔴 Critical | Mọi `@foreach` render dynamic elements/components phải có `wire:key` ổn định (`wire:key="item-{{ $item->id }}"`).                           |
| **RULE_LWD_02** | 🔴 Critical | `wire:model` trên field nhạy cảm phải đi kèm validation + authorization server-side; không dựa vào disabled/readOnly ở client.               |
| **RULE_LWD_03** | 🟠 High     | Dùng `wire:model.blur` / `wire:model.lazy` thay vì `.live` cho input không cần real-time để giảm request noise.                              |
| **RULE_LWD_04** | 🟠 High     | Submit/action phải có `wire:loading.attr="disabled"` hoặc cơ chế chặn duplicate click.                                                     |
| **RULE_LWD_05** | 🟠 High     | Dùng `wire:target` khi hiển thị loading theo action cụ thể, tránh loading indicator “toàn trang” không cần thiết.                            |
| **RULE_LWD_06** | 🟠 High     | `wire:poll` chỉ dùng khi thật sự cần realtime; interval phải hợp lý để tránh load server quá mức.                                            |
| **RULE_LWD_07** | 🟠 High     | `wire:navigate` (SPA mode) phải kiểm tra leak state giữa page transitions và xử lý browser back/forward đúng.                                |
| **RULE_LWD_08** | 🟡 Medium   | `wire:ignore` chỉ dùng cho 3rd-party widgets cần DOM ownership riêng; tránh lạm dụng làm mất sync state.                                    |
| **RULE_LWD_09** | 🟡 Medium   | `wire:dirty` / `wire:offline` nên dùng để phản hồi UI rõ ràng khi state chưa sync hoặc mất kết nối.                                         |
| **RULE_LWD_10** | 🟡 Medium   | `wire:click.prevent` / `.stop` chỉ dùng khi có lý do cụ thể; tránh cản trở default behavior không cần thiết.                                  |
| **RULE_LWD_11** | 🟡 Medium   | Entanglement (`@entangle`) giữa Alpine và Livewire chỉ dùng cho state đơn giản; state phức tạp nên có API rõ ràng qua events/actions.       |
| **RULE_LWD_12** | 🟡 Medium   | UI pattern (modal/dropdown/tabs) cần đồng bộ a11y states (`aria-expanded`, `aria-hidden`) khi thay đổi qua Livewire directives.             |

---

## 5. 🌊 Tailwind CSS

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                                                                                  |
| :------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_TW_01** | 🔴 Critical | Không dùng inline `style=""` nếu có utility class tương đương; vi phạm consistency của hệ thống style.                                            |
| **RULE_TW_02** | 🔴 Critical | Tokens (màu, spacing, radius, typography) phải lấy từ `tailwind.config.*`, không lạm dụng arbitrary values (`text-[13px]`) cho giá trị có token. |
| **RULE_TW_03** | 🟠 High     | Chuỗi class quá dài (≈ >8–10 utilities) nên extract thành component class (`@apply`) hoặc Blade component.                                        |
| **RULE_TW_04** | 🟠 High     | Ordering classes nhất quán theo quy ước team (Headwind/Prettier plugin), tránh class chaos khó review.                                            |
| **RULE_TW_05** | 🟠 High     | Responsive variants theo mobile-first (`sm:`, `md:`, `lg:`, `xl:`) có thứ tự nhất quán.                                                           |
| **RULE_TW_06** | 🟠 High     | `dark:` variants phải test thực tế trên dark mode; không thêm class mà không verify contrast/readability.                                          |
| **RULE_TW_07** | 🟠 High     | Tránh class conflicts (vd `p-2 p-4` cùng element) trừ khi có chủ đích rõ ràng theo breakpoint/state.                                              |
| **RULE_TW_08** | 🟠 High     | Plugins chính thức (`@tailwindcss/forms`, `@tailwindcss/typography`) nên dùng thay vì custom reset rời rạc nếu cùng mục tiêu.                   |
| **RULE_TW_09** | 🟡 Medium   | `@apply` chỉ dùng trong CSS layer phù hợp (`@layer components/utilities`), không dùng trong Blade template.                                       |
| **RULE_TW_10** | 🟡 Medium   | Tailwind config chỉ `extend` khi có thể; override defaults phải có lý do documented.                                                               |
| **RULE_TW_11** | 🟡 Medium   | Class names tùy biến (`bg-brand-primary`) phải descriptive, không generic (`bg-custom1`).                                                          |
| **RULE_TW_12** | 🟡 Medium   | Không dùng CDN build cho production app có pipeline riêng; dùng build step để purge/tree-shake classes.                                           |
| **RULE_TW_13** | 🟡 Medium   | Safelist classes phải tối thiểu và có lý do (dynamic classes), tránh safelist quá rộng làm tăng bundle size.                                      |
| **RULE_TW_14** | 🟡 Medium   | Animation utilities (`animate-*`) phải tôn trọng `motion-reduce` variant khi cần accessibility.                                                    |
| **RULE_TW_15** | 🟡 Medium   | Dùng container/query variants có chủ đích; tránh chồng nhiều breakpoint khó bảo trì.                                                              |

---

## 6. 🚀 Performance (Blade & Livewire)

| Rule ID            | Priority    | Tiêu chí đánh giá                                                                                                                                |
| :----------------- | :---------- | :----------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_PERF_B_01** | 🔴 Critical | Không render query nặng trong vòng lặp Blade/Livewire (`N+1`). Dùng eager loading và aggregate queries trước khi render.                      |
| **RULE_PERF_B_02** | 🔴 Critical | Livewire request frequency phải kiểm soát (debounce/lazy/blur), tránh bắn request mỗi keypress khi không cần.                                  |
| **RULE_PERF_B_03** | 🟠 High     | Dùng `wire:key` đúng để DOM diff chính xác, giảm re-render thừa.                                                                                |
| **RULE_PERF_B_04** | 🟠 High     | Chỉ update fragment cần thiết; tránh full component re-render cho thay đổi nhỏ (tách child component khi cần).                                  |
| **RULE_PERF_B_05** | 🟠 High     | Dùng `wire:ignore` cho JS widget nặng (editor, chart) để tránh patch DOM liên tục không cần thiết.                                             |
| **RULE_PERF_B_06** | 🟠 High     | Icon/fonts/assets chỉ load phần dùng thực tế; tránh import nguyên bộ khi dùng vài item.                                                        |
| **RULE_PERF_B_07** | 🟠 High     | `php artisan view:cache` và opcache settings phải được bật ở production deployment flow.                                                        |
| **RULE_PERF_B_08** | 🟠 High     | Pagination/search/filter state nên giữ qua URL (`->withQueryString()` hoặc tương đương) để giảm thao tác lặp và cải thiện UX.                 |
| **RULE_PERF_B_09** | 🟡 Medium   | Lazy load component below-the-fold (Blade lazy components hoặc defer strategy tương đương).                                                      |
| **RULE_PERF_B_10** | 🟡 Medium   | Image trong Blade nên có kích thước rõ ràng + lazy loading để giảm CLS và tải ban đầu.                                                         |
| **RULE_PERF_B_11** | 🟡 Medium   | Tách bundle JS/CSS theo trang hoặc feature nếu app lớn; tránh một bundle monolith cho mọi route.                                               |
| **RULE_PERF_B_12** | 🟡 Medium   | Cache data đọc nhiều (config/settings lookup, select options) bằng cache layer phù hợp.                                                         |
| **RULE_PERF_B_13** | 🟡 Medium   | Dùng Laravel Telescope/Debugbar chỉ ở local/dev; không để overhead debug tools ở production.                                                   |
| **RULE_PERF_B_14** | 🟡 Medium   | Theo dõi network payload của Livewire responses; payload lớn bất thường cần được tối ưu state/serialization.                                   |

---

## 7. 🛡️ Security (Blade/Livewire/Alpine)

| Rule ID              | Priority    | Tiêu chí đánh giá                                                                                                                                |
| :------------------- | :---------- | :----------------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_SEC_BLT_01**  | 🔴 Critical | Escaping output mặc định bằng `{{ }}`; mọi trường hợp unescaped output phải có comment nêu lý do + sanitize path.                             |
| **RULE_SEC_BLT_02**  | 🔴 Critical | Livewire actions bắt buộc authorization (`Gate::authorize`/policy) trước khi mutate dữ liệu.                                                   |
| **RULE_SEC_BLT_03**  | 🔴 Critical | Sensitive IDs/flags không được tin từ client (public properties, hidden fields); luôn resolve lại từ server context.                            |
| **RULE_SEC_BLT_04**  | 🔴 Critical | File uploads phải validate mime, extension, size, và scan nếu policy yêu cầu; không lưu filename gốc trực tiếp.                                |
| **RULE_SEC_BLT_05**  | 🔴 Critical | CSRF phải được giữ nguyên mặc định framework; không disable middleware cho routes xử lý form/action.                                            |
| **RULE_SEC_BLT_06**  | 🟠 High     | Không leak stack trace/exception details ra UI; hiển thị lỗi thân thiện, log chi tiết ở server logs.                                           |
| **RULE_SEC_BLT_07**  | 🟠 High     | Rate limit cho actions nhạy cảm (login, resend OTP, destructive actions) để chống abuse.                                                       |
| **RULE_SEC_BLT_08**  | 🟠 High     | Modal confirm bắt buộc cho delete/destructive actions; tránh one-click destructive operations.                                                  |
| **RULE_SEC_BLT_09**  | 🟠 High     | Không render raw HTML từ WYSIWYG/editor nếu không sanitize whitelist tags/attributes.                                                          |
| **RULE_SEC_BLT_10**  | 🟠 High     | Session/auth state đổi role/permission phải được refresh đúng; tránh stale authorization state phía client.                                    |
| **RULE_SEC_BLT_11**  | 🟡 Medium   | Không để credentials/secrets trong Blade comments, JS inline, data attributes.                                                                  |
| **RULE_SEC_BLT_12**  | 🟡 Medium   | CORS/CSP headers nên được cấu hình phù hợp môi trường; kiểm tra inline scripts/styles theo CSP policy của app.                                |
| **RULE_SEC_BLT_13**  | 🟡 Medium   | Event payload từ frontend phải được validate schema trước khi xử lý (kiểu dữ liệu, range, enum).                                               |
| **RULE_SEC_BLT_14**  | 🟡 Medium   | Logs phải redact dữ liệu nhạy cảm (token, email đầy đủ, phone đầy đủ, PII) theo policy.                                                        |

---

## 8. 🧱 Component Architecture

| Rule ID               | Priority    | Tiêu chí đánh giá                                                                                                                          |
| :-------------------- | :---------- | :----------------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_ARCH_BLT_01**  | 🟠 High     | Tách rõ 3 lớp: View (Blade/Livewire template) — UI state (Livewire/Alpine) — Business logic (Service/Action).                          |
| **RULE_ARCH_BLT_02**  | 🟠 High     | Livewire component naming theo feature (`App\Livewire\Billing\InvoiceTable`) thay vì tên chung chung (`TableComponent`).               |
| **RULE_ARCH_BLT_03**  | 🟠 High     | Blade component paths theo domain (`resources/views/components/billing/...`) thay vì flat `components/`.                                |
| **RULE_ARCH_BLT_04**  | 🟠 High     | Reusable form fragments/component phải chuẩn hóa API props/events, tránh mỗi màn hình một pattern khác nhau.                            |
| **RULE_ARCH_BLT_05**  | 🟠 High     | Component public API nhỏ gọn: chỉ expose props/events cần thiết, không expose state nội bộ không dùng.                                  |
| **RULE_ARCH_BLT_06**  | 🟡 Medium   | Shared UI primitives (button, input, modal, badge) phải có source-of-truth duy nhất, không clone biến thể rải rác.                     |
| **RULE_ARCH_BLT_07**  | 🟡 Medium   | Trait dùng có chọn lọc (`WithPagination`, `WithFileUploads`); tránh trait “god trait” gom logic unrelated.                              |
| **RULE_ARCH_BLT_08**  | 🟡 Medium   | Dùng DTO/ViewModel cho dữ liệu phức tạp chuyển sang view, hạn chế truyền mảng sâu khó theo dõi.                                         |
| **RULE_ARCH_BLT_09**  | 🟡 Medium   | Event-driven communication giữa components cần documented contract (event name, payload shape).                                           |
| **RULE_ARCH_BLT_10**  | 🟡 Medium   | Không để utility helpers trùng chức năng ở nhiều namespace; tái sử dụng helper/service hiện có.                                          |
| **RULE_ARCH_BLT_11**  | 🟡 Medium   | UI kit nội bộ cần guideline variant (`primary`, `secondary`, `danger`) thống nhất giữa Blade và Tailwind tokens.                         |
| **RULE_ARCH_BLT_12**  | 🟡 Medium   | Review coupling: component không nên phụ thuộc chặt vào route/model cụ thể nếu mục tiêu là tái sử dụng.                                 |

---

## 9. 🧹 Code Quality & Maintainability

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                                                                   |
| :-------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------- |
| **RULE_BQ_01**  | 🔴 Critical | Xóa sạch `dd()`, `dump()`, `ray()`, `console.log`, debug flags trước khi commit.                                                  |
| **RULE_BQ_02**  | 🔴 Critical | Không để TODO/FIXME critical tồn tại trong flow chính nếu chưa có ticket/link tracking rõ ràng.                                   |
| **RULE_BQ_03**  | 🟠 High     | PHP/Blade/Tailwind formatting phải theo tools chuẩn dự án (Pint, Prettier, plugin class sort).                                    |
| **RULE_BQ_04**  | 🟠 High     | Tên biến trong Blade rõ nghĩa (`$currentUser`, `$invoiceTotal`), không dùng tên mơ hồ (`$data`, `$item2`).                       |
| **RULE_BQ_05**  | 🟠 High     | Dùng strict comparison khi check giá trị (`===`, `!==`) ở JS/PHP nơi phù hợp để tránh coercion bugs.                              |
| **RULE_BQ_06**  | 🟠 High     | Tests tối thiểu cho flows quan trọng (form submit, authorization, validation, rendering branches).                                  |
| **RULE_BQ_07**  | 🟡 Medium   | Snapshot/UI tests cho component quan trọng (nếu dự án có setup) để detect regressions sớm.                                         |
| **RULE_BQ_08**  | 🟡 Medium   | PR nên nhỏ và theo feature boundary; tránh gộp refactor lớn + feature mới trong cùng thay đổi.                                      |
| **RULE_BQ_09**  | 🟡 Medium   | Commit message mô tả “why”, không chỉ “update file”.                                                                               |
| **RULE_BQ_10**  | 🟡 Medium   | Comments giải thích lý do business rule, không mô tả code hiển nhiên.                                                               |
| **RULE_BQ_11**  | 🟡 Medium   | File quá dài (Blade > 250–300 dòng, Livewire class > 200 dòng) nên tách component/phần phụ để dễ review.                          |
| **RULE_BQ_12**  | 🟡 Medium   | Checklist review nên được áp dụng nhất quán giữa các PR để tránh subjective feedback.                                               |
