# Laravel check list

## 1. ⚡ Livewire Specifics

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

## 2. 🏗️ Architecture (Laravel Core)

| Rule ID          | Priority  | Tiêu chí đánh giá                                                                                           |
| :--------------- | :-------- | :---------------------------------------------------------------------------------------------------------- |
| **RULE_ARCH_01** | 🟠 High   | Controller chỉ xử lý HTTP request/response, không chứa business logic.                                      |
| **RULE_ARCH_02** | 🟠 High   | Service layer chịu trách nhiệm chứa business logic.                                                         |
| **RULE_ARCH_03** | 🟠 High   | Tuyệt đối **không gọi `env()` ngoài thư mục `config/`**. Dùng `config()` để đảm bảo cache config hoạt động. |
| **RULE_ARCH_04** | 🟡 Medium | Repository (nếu dùng) chỉ chứa logic query database.                                                        |
| **RULE_ARCH_05** | 🟡 Medium | Nguyên tắc DRY: Logic lặp lại phải được extract thành method/class dùng chung.                              |
| **RULE_ARCH_06** | 🟡 Medium | Model không chứa business logic nặng (chỉ giữ relations, scopes, casts...).                                 |
| **RULE_ARCH_07** | 🟡 Medium | Luôn cập nhật `.env.example` khi có biến môi trường mới.                                                    |

## 3. 🗄️ Database & Query

| Rule ID        | Priority    | Tiêu chí đánh giá                                                                         |
| :------------- | :---------- | :---------------------------------------------------------------------------------------- |
| **RULE_DB_01** | 🔴 Critical | **Không có N+1 query** (dùng `with()` eager loading, đặc biệt chú ý trong vòng lặp).      |
| **RULE_DB_02** | 🔴 Critical | Các thao tác ghi/sửa/xóa liên hoàn phải được bọc trong DB Transaction.                    |
| **RULE_DB_03** | 🔴 Critical | Không dùng `orderByRaw()`, `whereRaw()` với input chưa sanitize -> Nguy cơ SQL Injection. |
| **RULE_DB_04** | 🟠 High     | Đánh Index cho các cột thường xuyên dùng để filter, sort, join.                           |
| **RULE_DB_05** | 🟠 High     | Trả về danh sách lớn phải dùng Pagination.                                                |
| **RULE_DB_06** | 🟠 High     | Migration phải có hàm `down()` hợp lệ để rollback an toàn.                                |
| **RULE_DB_07** | 🟠 High     | Dùng API Resource/ResourceCollection để format output thay vì trả raw Model.              |
| **RULE_DB_08** | 🟡 Medium   | Chỉ select các cột cần thiết, tránh `SELECT *` trong query nặng.                          |
| **RULE_DB_09** | 🟡 Medium   | Xử lý SoftDelete nhất quán (dùng `withTrashed()` khi thực sự cần).                        |

## 4. 🔒 Security

| Rule ID         | Priority    | Tiêu chí đánh giá                                                                     |
| :-------------- | :---------- | :------------------------------------------------------------------------------------ |
| **RULE_SEC_01** | 🔴 Critical | Input từ user bắt buộc phải qua validation (FormRequest).                             |
| **RULE_SEC_02** | 🔴 Critical | Phải kiểm tra **Authorization** (Policy/Gate), không chỉ Authentication.              |
| **RULE_SEC_03** | 🔴 Critical | Authorization đúng scope (Kiểm tra ownership: User A không được sửa data của User B). |
| **RULE_SEC_04** | 🔴 Critical | Model khai báo `$fillable` hoặc `$guarded` để chống Mass Assignment.                  |
| **RULE_SEC_05** | 🔴 Critical | Không hardcode credential, token, secret key trong code.                              |
| **RULE_SEC_06** | 🔴 Critical | Cấm dùng `{!! !!}` in data user nhập -> Nguy cơ XSS. Chỉ dùng `{{ }}`.                |
| **RULE_SEC_07** | 🟠 High     | File upload phải validate nghiêm ngặt type (mimes) và size.                           |
| **RULE_SEC_08** | 🟠 High     | Endpoint nhạy cảm (Login, OTP, Export...) phải có Rate Limiting.                      |
| **RULE_SEC_09** | 🟠 High     | Luôn validate phía Server, không tin tưởng hoàn toàn vào Client validation.           |
| **RULE_SEC_10** | 🟠 High     | Model phải ẩn (`$hidden`) các field nhạy cảm (password, tokens).                      |
| **RULE_SEC_11** | 🟠 High     | Signed URL / Temporary URL phải được verify chữ ký hợp lệ.                            |
| **RULE_SEC_12** | 🟡 Medium   | Tránh lộ Auto-increment ID ra API, cân nhắc dùng UUID hoặc Hashid.                    |
| **RULE_SEC_13** | 🟡 Medium   | Cấu hình CORS (`config/cors.php`) chặt chẽ, không dùng `*` trên Production.           |

## 5. 🌐 API Design

| Rule ID         | Priority    | Tiêu chí đánh giá                                                               |
| :-------------- | :---------- | :------------------------------------------------------------------------------ |
| **RULE_API_01** | 🔴 Critical | API Response không được leak stack trace, internal info khi có lỗi.             |
| **RULE_API_02** | 🟠 High     | Cấu trúc Response và HTTP Status Code phải nhất quán.                           |
| **RULE_API_03** | 🟠 High     | Dùng đúng HTTP Method (GET không đổi data; POST/PUT/PATCH/DELETE cho mutation). |
| **RULE_API_04** | 🟡 Medium   | API nên có versioning (`/api/v1/...`).                                          |
| **RULE_API_05** | 🟡 Medium   | Pagination response trả về đủ metadata (current_page, total, per_page).         |

## 6. ⚠️ Error Handling & Logging

| Rule ID         | Priority    | Tiêu chí đánh giá                                                        |
| :-------------- | :---------- | :----------------------------------------------------------------------- |
| **RULE_ERR_01** | 🔴 Critical | Tuyệt đối không log thông tin nhạy cảm (Password, Token, PII của user).  |
| **RULE_ERR_02** | 🟠 High     | Bắt lỗi (try/catch) cho các external call (3rd party API, Queue, S3...). |
| **RULE_ERR_03** | 🟡 Medium   | Chủ động log lại các action quan trọng trong hệ thống.                   |

## 7. ⚡ Performance (Backend)

| Rule ID          | Priority  | Tiêu chí đánh giá                                                                   |
| :--------------- | :-------- | :---------------------------------------------------------------------------------- |
| **RULE_PERF_01** | 🟠 High   | Tác vụ nặng (Gửi mail, Export, Image processing) phải đẩy vào Background Job/Queue. |
| **RULE_PERF_02** | 🟠 High   | Cấu hình failed job logic (Retry, Fallback, Alert).                                 |
| **RULE_PERF_03** | 🟠 High   | Job phải **idempotent** (chạy lại nhiều lần không sinh ra rác, duplicate mail...).  |
| **RULE_PERF_04** | 🟠 High   | Đảm bảo tắt Telescope / Debugbar trên môi trường Production.                        |
| **RULE_PERF_05** | 🟡 Medium | Ứng dụng Cache cho các query nặng/ít thay đổi.                                      |
| **RULE_PERF_06** | 🟡 Medium | Không eager load (`with`) dư thừa nếu response không dùng tới.                      |

## 8. 🧪 Testing & Code Quality

| Rule ID          | Priority    | Tiêu chí đánh giá                                                          |
| :--------------- | :---------- | :------------------------------------------------------------------------- |
| **RULE_TEST_01** | 🔴 Critical | Xóa sạch các hàm debug (`dd()`, `dump()`, `console.log`) trước khi commit. |
| **RULE_TEST_02** | 🟠 High     | Viết Unit Test cho các business logic quan trọng/phức tạp.                 |
| **RULE_TEST_03** | 🟠 High     | Pass CI/CD pipelines (Lint, Format, PHPStan) không có warning mới.         |

## 9. 📦 Dependencies

| Rule ID         | Priority  | Tiêu chí đánh giá                                                          |
| :-------------- | :-------- | :------------------------------------------------------------------------- |
| **RULE_DEP_01** | 🟠 High   | Package mới phải được check về security, license và khả năng maintain.     |
| **RULE_DEP_02** | 🟡 Medium | Commit file `composer.lock` / `package-lock.json` nếu có thêm/bớt package. |
