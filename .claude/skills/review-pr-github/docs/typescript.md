# TypeScript Checklist

## 1. 📋 TypeScript Best Practices

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TS_01** | 🔴 Critical | `tsconfig.json` phải bật `"strict": true`. Kiểm tra tất cả các strict flags con (`strictNullChecks`, `noImplicitAny`, `strictFunctionTypes`, `strictPropertyInitialization`) đều được enable. Nếu project có legacy code, migration phải có plan rõ ràng. |
| **RULE_TS_02** | 🔴 Critical | Không dùng `any` — dùng `unknown` khi type không xác định. Mọi giá trị `unknown` phải được narrow trước khi sử dụng: dùng `typeof`, `instanceof`, type guards, hoặc validation library (`zod`, `valibot`). Tìm tất cả các vị trí dùng `any` bằng `noImplicitAny` và ESLint rule `@typescript-eslint/no-explicit-any`. |
| **RULE_TS_03** | 🔴 Critical | Không có `@ts-ignore`, `@ts-expect-error`, hoặc `@ts-check` không được resolve trong production code. Các directive này chỉ được phép trong test files hoặc trong quá trình migration có comment giải thích rõ lý do và có ticket theo dõi. |
| **RULE_TS_04** | 🔴 Critical | `strictNullChecks: true` bắt buộc. Mọi access property hoặc method phải handle `null`/`undefined` rõ ràng. Không dùng optional chaining (`?.`) để che lỗp logic — nó chỉ là syntax sugar, không thay thế việc validate data flow. |
| **RULE_TS_05** | 🔴 Critical | Luôn annotate return type cho public/exported functions. Đối với private/internal functions, TypeScript có thể infer, nhưng nếu function phức tạp (nhiều branch, generic), annotate rõ ràng giúp catch sai sót. Kiểm tra: `explicit-function-return-type` ESLint rule. |
| **RULE_TS_06** | 🔴 Critical | Không dùng `Function`, `Object`, `{}` như type. Thay bằng: `() => void` cho function type, `Record<string, unknown>` hoặc `object` cho plain objects. `{}` trong TypeScript không phải empty object — nó accept bất kỳ non-nullish value nào. |
| **RULE_TS_07** | 🟠 High | Tránh type assertions (`as`) khi có thể. Nếu buộc phải dùng, phải có comment giải thích tại sao. Tốt nhất: dùng type guards, user-defined type guards (`isX`), hoặc discriminated unions. Tìm: `@typescript-eslint/no-non-null-assertion` cho `!`, `@typescript-eslint/consistent-type-assertions` cho `as`. |
| **RULE_TS_08** | 🟠 High | Export `interface` cho public API shapes (object shapes). Export `type` cho unions, intersections, primitives aliases. Class chỉ export khi cần instantiation hoặc extends/implements. Interface có thể merge (declaration merging), type alias thì không — chọn đúng use case. |
| **RULE_TS_09** | 🟠 High | Dùng `as const` cho config objects, string literals, enum-like objects không thay đổi. Điều này tạo literal types thay vì wider types, giúp TypeScript catch errors sớm hơn. Ví dụ: `const ROUTES = { home: '/', about: '/about' } as const`. |
| **RULE_TS_10** | 🟠 High | Dùng readonly modifiers (`readonly`) cho properties không nên thay đổi sau khi khởi tạo. Kết hợp với `as const` cho objects/arrays. Đặt `strictReadonlyClasses: true` trong tsconfig nếu có thể để apply readonly cho class properties tự động. |
| **RULE_TS_11** | 🟠 High | `noUncheckedIndexedAccess: true` trong tsconfig — buộc check undefined khi truy cập array/object index. Giúp tránh bugs kiểu "undefined is not a function" khi index out of bounds. Nếu performance-critical, dùng explicit check thay vì tắt flag. |
| **RULE_TS_12** | 🟡 Medium | Branded types cho IDs và tokens: `type UserId = string & { readonly brand: unique symbol }`. Ngăn confusion giữa `UserId` và `string` thuần. Tạo factory functions `createUserId(id: string): UserId` để enforce creation pattern. Ví dụ sai thường gặp: dùng `number` cho cả `UserId` và `PostId`. |
| **RULE_TS_13** | 🟡 Medium | Discriminated unions cho state management và branching logic. Pattern chuẩn: `type Result<T, E = Error> = { ok: true; data: T } \| { ok: false; error: E }`. Giúp exhaustiveness checking với `never` — TypeScript sẽ báo lỗi nếu có union member chưa được handle trong switch/if. |
| **RULE_TS_14** | 🟡 Medium | Utility types: dùng `Partial`, `Required`, `Pick`, `Omit`, `Readonly`, `Record`, `Exclude`, `Extract`, `NonNullable`, `ReturnType`, `Parameters`, `InstanceType` — không tự viết lại. Kiểm tra `utility-value` của codebase trước khi tạo type helpers mới. |
| **RULE_TS_15** | 🟡 Medium | Function overloads: dùng khi function có behavior khác nhau dựa trên argument types. Đặt overload signatures trước implementation signature. Implementation signature phải compatible với tất cả overloads. Không lạm dụng — nếu > 3 overloads, xem xét dùng generic hoặc union với discriminated property. |
| **RULE_TS_16** | 🟡 Medium | Generic constraints (`extends`): khi generic không cần accept mọi type, constrain nó. Ví dụ: `function getProperty<T, K extends keyof T>(obj: T, key: K): T[K]`. Tránh `T extends object` quá rộng — dùng `T extends SomeInterface` khi có thể. |
| **RULE_TS_17** | 🟡 Medium | Optional chaining (`?.`) và nullish coalescing (`??`) phải dùng đúng ngữ cảnh. `?.` dùng khi property có thể undefined/null. `??` dùng để provide default cho nullish values (không phải mọi falsy value). `?.` không thay thế optional properties — `obj.prop?.method()` khác với `obj.optionalProp?.method()`. |
| **RULE_TS_18** | 🟡 Medium | Enum vs Union literal vs const object: ưu tiên `const enum` hoặc `as const` object thay vì regular `enum` vì regular enum compile thành runtime object, có thể cause issues với duplicate values và tree-shaking. Chỉ dùng regular `enum` khi cần bidirectional mapping (number ↔ string). |
| **RULE_TS_19** | 🟡 Medium | `infer` keyword: chỉ dùng trong conditional types để extract type information. Ví dụ chuẩn: `type UnwrapPromise<T> = T extends Promise<infer U> ? U : T`. Không dùng `infer` trong context không liên quan đến type extraction. Tránh quá nhiều nested `infer` — nó làm type error messages khó đọc. |
| **RULE_TS_20** | 🟡 Medium | Conditional types: dùng để model type-level logic. Pattern phổ biến: `type IsArray<T> = T extends any[] ? true : false`. Kết hợp với distributive conditional type behavior (khi T là union). Dùng `[T] extends [U]` thay vì `T extends U` để tránh distribution khi không muốn. |
| **RULE_TS_21** | 🟡 Medium | Mapped types: dùng để transform types. Built-in: `Partial<T>`, `Required<T>`, `Readonly<T>`, `Pick<T, K>`, `Record<K, V>`. Custom: `{ [P in keyof T]: Transformation<T[P]> }`. Dùng modifier `-readonly` và `-?` để remove readonly/optional. Key remapping với `as`: `{ [P in keyof T as Exclude<P, 'id'>]: T[P] }`. |
| **RULE_TS_22** | 🟡 Medium | Template literal types: dùng cho string manipulation ở type level. Ví dụ: `type EventName<T extends string> = `on${Capitalize<T>}`. Kết hợp với `infer` để parse strings. Chỉ dùng khi thực sự cần type-level string manipulation — không lạm dụng vì làm compile time chậm. |
| **RULE_TS_23** | 🟡 Medium | `never` type: dùng cho unreachable code và exhaustiveness checking. Function return type `never` nghĩa là không bao giờ return (throw hoặc infinite loop). `assertNever(x: never)` pattern giúp verify exhaustiveness. Không confuse `void` (có thể return undefined) với `never` (không bao giờ return). |
| **RULE_TS_24** | 🟡 Medium | Variance annotations (`+T`, `-T`): dùng khi generic interfaces/types có type parameters không covariant/contravariant theo mặc định. Class `extends`/`implements` phải preserve variance của parent. Tự động inference thường đủ, nhưng với complex generic types (callback-heavy APIs), explicit variance annotation giúp tránh type unsafety. |
| **RULE_TS_25** | 🟡 Medium | Declaration files (`.d.ts`): kiểm tra global declarations không pollute global scope không mong muốn. Module declarations phải có `export {}` để treat file là module. Ambient declarations (`declare module`) phải trong dedicated `.d.ts` files, không trong `.ts` files có logic. Triple-slash directives (`/// <reference />`) chỉ dùng khi cần, prefer ES module imports. |

---

## 2. 🧪 Type Testing

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TEST_01** | 🔴 Critical | Type testing: mọi public/exported types và utility types phải có tests xác nhận compile-time behavior đúng. Dùng `tsd` (对于 `.ts` type tests) hoặc `zod`/`valibot` để validate runtime behavior match compile-time types. Không chỉ trust types — types có thể compile nhưng model sai business logic. |
| **RULE_TEST_02** | 🔴 Critical | Unit tests cho pure functions: bất kỳ function nào có logic đều phải có unit tests. Pure function = deterministic, no side effects — dễ test nhất. Test edge cases: empty inputs, max values, boundary conditions, invalid inputs (nên return Result type hoặc throw typed error). |
| **RULE_TEST_03** | 🟠 High | Mocking typed dependencies: dùng `jest.mock()` hoặc `vi.mock()` với factory function. Factory phải return full typed mock object. Nếu mock interface phức tạp, dùng `jest.fn()` cho từng method thay vì cast `as any`. Tránh `jest.mock('./module', () => ({}))` — phải include tất cả exported members để tránh runtime errors. Fix MD033/MD038: escaped angle brackets and spaces. |
| **RULE_TEST_04** | 🟠 High | Snapshot tests cho complex types và serialized output: dùng `.toMatchSnapshot()` để detect breaking changes trong type shapes. Đặc biệt hữu ích cho: API response types, config shapes, generated types. Mỗi snapshot change phải được intentional — review snapshot diff trước khi update. |
| **RULE_TEST_05** | 🟠 High | Test coverage >= 80% cho critical paths: business logic, error handling branches, type narrowing code paths. Function có nhiều branches (`if/else`, `switch`) phải test mỗi branch. Type narrowing (`typeof`, `instanceof`, custom guards`) phải verify từng code path sau narrowing. |
| **RULE_TEST_06** | 🟠 High | Test discriminated unions exhaustiveness: mỗi union member phải có test case. Dùng `assertNever` helper để TypeScript báo compile error nếu có member mới được thêm mà chưa handle. Pattern: `const assertNever = (x: never): never => { throw new Error('Unexpected value: ' + JSON.stringify(x)); };` |
| **RULE_TEST_07** | 🟡 Medium | Property-based testing với `fast-check`: test với hàng trăm random inputs thay vì hardcoded cases. Đặc biệt hữu ích cho: parsing, validation, serialization, data transformation functions. Define arbitraries match real input distribution — không random thuần túy. |
| **RULE_TEST_08** | 🟡 Medium | Test naming convention: `describe` blocks theo subject/function, `it` blocks theo expected behavior. Pattern: `describe('UserService', () => { describe('createUser', () => { it('should throw ValidationError when email is invalid', () => { ... }); }); });`. Tránh vague names như "should work correctly". |
| **RULE_TEST_09** | 🟡 Medium | Integration tests: khi typesafe code gọi external systems (database, API), verify type contracts bằng integration tests. Mock at type level nếu possible — nếu API contract thay đổi, integration test phải fail để catch breaking changes. Dùng contract testing (Pact) nếu microservices. |
| **RULE_TEST_10** | 🟡 Medium | Test for type narrowing behavior: verify code hoạt động đúng sau khi type guard hoặc narrowing. Ví dụ: sau `if (result.ok) { /* TypeScript biết result.data tồn tại */ }` — viết test verify không access `result.data` khi `result.ok === false`. |
| **RULE_TEST_11** | 🟡 Medium | Verify error types: test thrown errors phải là đúng type và có đúng properties. Dùng `toThrow()` với error class: `expect(() => fn()).toThrow(ValidationError)`. Không dùng `toThrow(Error)` chung chung — phải specify exact error type để verify error hierarchy. |

---

## 3. 🔴 Error Handling

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ERR_01** | 🔴 Critical | Custom error classes: mỗi domain error phải là class riêng extend `Error` hoặc `AppError`. Error phải có: `name`, `message`, `code` (string), optional `details` (structured data). Không throw raw `Error` instances — không thể filter hoặc handle theo domain logic. |
| **RULE_ERR_02** | 🔴 Critical | Error wrapping: khi catch và re-throw, luôn wrap với context. Pattern: `throw new AppError('Failed to create user', { code: 'USER_CREATE_FAILED', cause: originalError, details: { userId } })`. Never swallow errors (`catch(e) {}`). Never throw non-Error values. |
| **RULE_ERR_03** | 🔴 Critical | Error cause chain: dùng `cause` property (built-in Error option) để preserve stack trace của original error. Không mất context khi error propagate qua nhiều layers. TypeScript 4.17+ support `cause` natively. Kiểm tra `no-throw-literal` ESLint rule. |
| **RULE_ERR_04** | 🟠 High | Result type pattern cho expected failures: `type Result<T, E = Error> = { ok: true; data: T } | { ok: false; error: E }`. Dùng khi failure là expected (validation, not found, unauthorized) — không exceptional. Giúp compiler enforce handling và làm code path rõ ràng hơn exception-based flow. |
| **RULE_ERR_05** | 🟠 High | Typed error boundaries: middleware hoặc error handler phải handle theo error type, không catch all. Dùng `instanceof` hoặc error `code` property để distinguish error types. Handler phải return structured error response, không expose internal error details ra ngoài. |
| **RULE_ERR_06** | 🟠 High | Never swallow errors: `catch (e)` không có re-throw hoặc logging là anti-pattern nghiêm trọng. Nếu error không cần propagate, phải có comment giải thích và logging. Pattern tốt: `catch (err) { logger.warn('Non-critical: ..., { cause: err }); return fallbackValue; }`. |
| **RULE_ERR_07** | 🟠 High | Error codes: mỗi error type phải có unique string `code` property (không phải HTTP status code). Codes giúp frontend/consumer handle errors programmatically. Pattern: `enum ErrorCode { VALIDATION_FAILED = 'VALIDATION_FAILED', NOT_FOUND = 'NOT_FOUND' }`. Codes phải documented. |
| **RULE_ERR_08** | 🟡 Medium | Logging: structured logs với fields rõ ràng: `timestamp`, `level`, `message`, `requestId`, `userId` (nếu có), `error` (object với `name`, `message`, `stack`, `code`). Dùng `error` field thay vì flatten vào message string. Levels: `error` (app cannot continue), `warn` (recoverable), `info` (significant events), `debug` (development only). |
| **RULE_ERR_09** | 🟡 Medium | Sensitive data redaction: error logs không được include passwords, tokens, credit card numbers, PII. Implement redaction utility: `const redact = (obj: unknown): unknown => { ... }`. Thực hiện ở logging layer, không trust developer sẽ tự redact trong message. |
| **RULE_ERR_10** | 🟡 Medium | Panic recovery: critical services phải có panic handler. Unhandled promise rejections và uncaught exceptions phải được logged và graceful shutdown. Pattern: `process.on('unhandledRejection', (reason) => { logger.fatal({ reason }, 'Unhandled rejection'); process.exit(1); });` |
| **RULE_ERR_11** | 🟡 Medium | Exhaustiveness checking for error handling: khi handle union of error types, dùng `assertNever` để verify tất cả cases được handle. Nếu thêm error type mới, compiler sẽ báo ở mọi nơi chưa handle — giúp maintain error handling coverage. |

---

## 4. 🎨 Async & Functional Patterns

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ASYNC_01** | 🔴 Critical | Async/await only: không dùng `.then().catch()` chaining — dùng `async/await` với `try/catch`. `async/await` dễ đọc, dễ debug, dễ type check. Chỉ dùng `.then()` khi cần compose multiple promises mà không block (ví dụ: `Promise.all`, `Promise.race`). |
| **RULE_ASYNC_02** | 🔴 Critical | Parallel when possible: dùng `Promise.all()` cho independent async operations. Không sequential nếu operations không depend on each other. Sequential thêm độ trễ không cần thiết. TypeScript infer `Promise.all([Promise<A>, Promise<B>])` → `Promise<[A, B]>`. |
| **RULE_ASYNC_03** | 🔴 Critical | `Promise.allSettled()` khi some failures are acceptable: nếu không cần fail-fast, dùng `Promise.allSettled()` thay vì `Promise.all()`. Return type: `Promise<PromiseSettledResult<T>[]>` — mỗi result có `status: 'fulfilled' | 'rejected'`. Dùng này cho batch operations mà partial failure là expected. |
| **RULE_ASYNC_04** | 🟠 High | Typed async function returns: luôn annotate return type là `Promise<T>`, không chỉ `async`. Giúp catch type errors sớm và làm signature rõ ràng. Exception: recursive functions hoặc internal helpers có thể rely on inference. |
| **RULE_ASYNC_05** | 🟠 High | Error handling in async code: try/catch phải có type narrowing cho caught error. Pattern: `try { ... } catch (err) { if (err instanceof ValidationError) { ... } else throw err; }`. Không catch với `any` nếu có thể — dùng typed catch variables (`catch (err: unknown)` in TypeScript 4.4+). |
| **RULE_ASYNC_06** | 🟠 High | Async race conditions: dùng `Promise.race()` với timeout để prevent hanging. Pattern: `const withTimeout = <T>(promise: Promise<T>, ms: number): Promise<T> => { const timeout = new Promise<T>((_, reject) => setTimeout(() => reject(new Error('Timeout')), ms)); return Promise.race([promise, timeout]); };` |
| **RULE_ASYNC_07** | 🟠 High | Async resource cleanup: async operations phải có cleanup path. Ví dụ: `try { const result = await resource(); return result; } finally { await resource.release(); }`. Không để resources leak (file handles, connections). ESLint: `no-floating-promises` rule để catch unhandled promises. |
| **RULE_ASYNC_08** | 🟡 Medium | Async iterators for large datasets: không load toàn bộ dataset vào memory. Dùng `AsyncGenerator`, `ReadableStream`, hoặc pagination. Pattern: `async function* streamUsers() { for await (const chunk of db.stream()) { yield chunk; } }`. Giới hạn memory growth. |
| **RULE_ASYNC_09** | 🟡 Medium | Concurrency limiting (Semaphore pattern): không spawn unlimited concurrent promises. Implement bounded concurrency: `async function batched<T, R>(items: T[], concurrency: number, fn: (item: T) => Promise<R>): Promise<R[]>`. Hoặc dùng library như `p-limit`. |
| **RULE_ASYNC_10** | 🟡 Medium | Cancellation: long-running async operations phải support cancellation. Dùng `AbortController` pattern: `async function fetchData(signal: AbortSignal) { const response = await fetch(url, { signal }); return response.json(); }`. Không bỏ qua `signal` parameter khi calling fetch. |
| **RULE_ASYNC_11** | 🟡 Medium | Functional error handling alternatives: ngoài Result type, consider `Option` pattern (Maybe monad) cho nullable values. Library: `neverthrow` (Result), `option-t` (Option/Result). Pattern `?.` operator là syntax sugar cho Option pattern — hiểu underlying semantics. |
| **RULE_ASYNC_12** | 🟡 Medium | Async queue patterns: dùng queue (Bull, BullMQ, oder Simple throttle) để batch và serialize async operations khi ordering matters. Không rely on fire-and-forget promises — lost errors không recoverable. Mọi async operation phải observable (logged, tracked, retried). |

---

## 5. 🏗️ Design Patterns

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_PAT_01** | 🟠 High | Repository pattern: abstract data access layer. Interface định nghĩa operations: `interface UserRepository { findById(id: UserId): Promise<User | null>; findAll(filter: UserFilter): Promise<User[]>; create(data: CreateUserDto): Promise<User>; update(id: UserId, data: UpdateUserDto): Promise<User>; delete(id: UserId): Promise<void>; }`. Implementation có thể là PostgreSQL, MongoDB, mock — interface giữ nguyên. |
| **RULE_PAT_02** | 🟠 High | Dependency injection: inject dependencies qua constructor, không instantiate trong class. `constructor(private userRepo: UserRepository) {}` — class không biết concrete implementation. Kết hợp với IoC container (NestJS, tsyringe, InversifyJS) hoặc manual DI cho lightweight solutions. |
| **RULE_PAT_03** | 🟠 High | Factory pattern: khi object creation có complex logic hoặc nhiều variants. Type-safe factory: dùng overloads hoặc discriminated union để type-check creation arguments. Ví dụ: `function createConnection(config: HttpConfig): HttpConnection; function createConnection(config: DbConfig): DbConnection;` |
| **RULE_PAT_04** | 🟠 High | Builder pattern: cho objects với nhiều optional fields hoặc complex construction steps. Type-safe builder: fluent interface với type safety ở mỗi step. Pattern: `class QueryBuilder<T = {}> { select<K extends keyof T>(k: K): QueryBuilder<Pick<T, K>>; where(condition: Partial<T>): QueryBuilder<T>; build(): Query<T>; }` |
| **RULE_PAT_05** | 🟠 High | Strategy pattern: interchangeable algorithms với shared interface. `interface PaymentStrategy { process(amount: number): Promise<PaymentResult>; }`. Implementations: `CreditCardStrategy`, `PayPalStrategy`, `CryptoStrategy`. Client code chỉ depend on interface, strategy được inject. |
| **RULE_PAT_06** | 🟠 High | Event-driven architecture: typed event bus. `interface EventMap { 'user.created': { userId: UserId; email: string; }; 'order.completed': { orderId: OrderId; total: number; }; }`. TypedEmitter: `const emitter = new TypedEmitter<EventMap>()`. Không dùng string literals không có type safety. |
| **RULE_PAT_07** | 🟠 High | Command pattern: encapsulate actions as objects. `interface Command<T = void> { execute(): Promise<T>; undo?(): Promise<void>; }`. Useful cho: undo/redo, audit log, command queue. Implementations phải be immutable — command object không thay đổi state sau khi created. |
| **RULE_PAT_08** | 🟡 Medium | Observer pattern: cho reactive data flow. Interface: `interface Observer<T> { next(value: T): void; error(err: Error): void; complete(): void; }`. Kết hợp với `Subscription` để cleanup. RxJS observables là implementation phổ biến nhưng có thể implement đơn giản nếu không cần full RxJS. |
| **RULE_PAT_09** | 🟡 Medium | Decorator pattern (Stage 3 decorators): metadata-driven patterns cho validation, DI, serialization. NestJS, TypeORM, class-validator dùng decorators. Class decorator: `@Injectable()`, method decorator: `@Get()`, property decorator: `@MinLength(3)`. Cẩn thận với decorator metadata — reflection không type-safe. |
| **RULE_PAT_10** | 🟡 Medium | Adapter pattern: wrap external APIs/services với typed interface. `class ExternalApiAdapter implements ExternalApi { constructor(private client: ThirdPartyClient) {} async fetchUser(id: string): Promise<InternalUser> { const raw = await this.client.getUser(id); return this.toInternal(raw); } }`. Adapter giữ codebase isolated khỏi third-party changes. |
| **RULE_PAT_11** | 🟡 Medium | Mixin pattern: compose classes không inheritance chain dài. `function Serializable<T extends new (...args: any[]) => {}>(Base: T) { return class extends Base { serialize(): string { return JSON.stringify(this); } }; }`. TypeScript mixins: `class Point { constructor(public x: number, public y: number) {} } class SerializablePoint extends Serializable(Point) {}` |
| **RULE_PAT_12** | 🟡 Medium | Type-safe state machines: dùng discriminated unions để model states. `type OrderState = { status: 'draft' } | { status: 'pending'; estimatedDelivery: Date } | { status: 'delivered'; deliveredAt: Date }`. Transitions phải typed — chỉ valid transitions được allow. Library: `xstate` nếu cần complex state machines. |
| **RULE_PAT_13** | 🟡 Medium | Type-safe builders với phantom types: enforce invariants ở compile time mà không runtime overhead. `type Validated<T> = T & { __brand: 'validated' }`. Builder chuyển `T` → `Validated<T>` khi hoàn tất. TypeScript không cho phép access `__brand`, chỉ dùng để phân biệt types. |

---

## 6. ⚙️ Configuration Management

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CFG_01** | 🔴 Critical | Config schema validation at startup: mọi environment variables phải được validate trước khi app start. Dùng `zod`, `valibot`, `yup`, hoặc `envalid`. Fail-fast — app không start nếu required config missing hoặc invalid. TypeScript infer types từ schema, không duplicate definitions. |
| **RULE_CFG_02** | 🔴 Critical | No hardcoded config values: mọi environment-dependent values phải đến từ config. Tìm hardcoded: URLs, timeouts, retry counts, connection strings. Pattern: `const config = { apiUrl: env.API_URL, timeout: env.API_TIMEOUT_MS }`. |
| **RULE_CFG_03** | 🟠 High | Type-safe config: schema definition là single source of truth. Dùng `zod.object({ ... })` và `.parse()` (throw) hoặc `.safeParse()` (return Result). Infer TypeScript type từ schema: `type Config = z.infer<typeof configSchema>`. Không manually define type rồi parse — dễ mismatch. |
| **RULE_CFG_04** | 🟠 High | Secrets management: DB passwords, API keys, tokens không hardcoded hoặc commit. Load từ secrets manager (AWS Secrets Manager, Vault, Kubernetes secrets). Config layer phải support multiple sources: env vars, secrets manager, config files với proper precedence. |
| **RULE_CFG_05** | 🟠 High | Config tiering: environments có precedence rõ ràng. `default < development < staging < production`. Code không được hardcode environment-specific logic. Dùng feature flags cho temporary overrides. |
| **RULE_CFG_06** | 🟠 High | Feature flags typed: dùng `const flags = { enableNewCheckout: process.env.ENABLE_NEW_CHECKOUT === 'true' } as const`. Hoặc dùng typed feature flag library. Feature flags phải have expiration date hoặc cleanup plan — không accumulate dead flags. |
| **RULE_CFG_07** | 🟡 Medium | Environment-specific discriminated union: `type Config = { env: 'development'; debug: true } | { env: 'production'; debug: false }`. TypeScript narrowing theo `env` property. Mỗi environment config phải have distinct type shape nếu fields khác nhau giữa environments. |
| **RULE_CFG_08** | 🟡 Medium | Config versioning và migration: khi schema thay đổi, có migration path. Validate old config format và convert sang format mới. Không break existing deployments. Config có thể come from multiple sources (env, secrets, remote config) — mỗi source có validation riêng. |
| **RULE_CFG_09** | 🟡 Medium | Config documentation: mỗi config field phải có description. Dùng JSDoc trên schema definition hoặc separate documentation file. Consumers phải hiểu field purpose, type, valid values, default. |

---

## 7. 🏛️ Code Organization

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ORG_01** | 🟠 High | Feature-based folder structure: `src/features/{feature}/` thay vì type-based. Mỗi feature tự chứa tất cả: types, services, controllers, tests. Shared code đặt ở `src/shared/`. Tránh feature cross-imports — features communicate qua events hoặc shared types. |
| | | ✅ `src/features/users/types.ts`, `src/features/users/user.service.ts`, `src/features/users/user.controller.ts` |
| | | ❌ `src/types/user.ts`, `src/services/userService.ts`, `src/controllers/userController.ts` |
| **RULE_ORG_02** | 🟠 High | Barrel exports (`index.ts`): mỗi module có entry point export public API. `export { UserService } from './user.service'; export type { User, CreateUserDto } from './types';`. Cẩn thận barrel exports cause circular dependencies — dùng `export type { ... }` để tránh circular reference issues với type-only imports. |
| **RULE_ORG_03** | 🟠 High | Path aliases: `tsconfig.json` paths (`"@/features/*"`, `"@/shared/*"`, `"@/types/*"`) giúp imports rõ ràng. Nhất quán: `"@/`" for src root, `"@/features/"` for features, `"@/shared/"` for shared. Tránh relative imports dài (`../../../../../`). |
| **RULE_ORG_04** | 🟠 High | Module boundary enforcement: feature không import từ feature khác trực tiếp. Communication qua: (1) shared types/events, (2) module-level events, (3) shared service that both depend on. Dùng ESLint rule `@typescript-eslint/no-restricted-imports` để enforce boundaries. |
| **RULE_ORG_05** | 🟡 Medium | File naming conventions: nhất quán. Patterns: `*.types.ts` (types/interfaces), `*.service.ts` (business logic), `*.repository.ts` (data access), `*.controller.ts` (request/response), `*.validator.ts` (validation), `*.mapper.ts` (DTO transforms), `*.test.ts` (tests cùng folder). |
| **RULE_ORG_06** | 🟡 Medium | Naming conventions: PascalCase cho types, interfaces, classes, enums, type parameters. camelCase cho variables, functions, methods, properties. UPPER_SNAKE_CASE cho constants. Interfaces không prefix với `I` (`. IUserService` → `UserService`). |
| **RULE_ORG_07** | 🟡 Medium | Single responsibility: mỗi file làm một việc. Dấu hiệu cần split: file > 300-500 lines, function > 30-50 lines, class có > 5 properties. Tách type definitions khỏi implementations. Tách interfaces khỏi classes. |
| **RULE_ORG_08** | 🟡 Medium | `export type` vs `export`: dùng `export type { User }` cho type-only exports để tận dùng TypeScript's `isolatedModules`. `export type` không emit JavaScript, giúp compilation faster và tránh circular dependency issues. Khi chỉ export types, luôn dùng `export type`. |
| **RULE_ORG_09** | 🟡 Medium | Re-export patterns: barrel files chỉ re-export, không có implementations. Nếu barrel file có logic, nó đã trở thành module thực — đặt tên khác. Re-export để provide public API surface, không phải để import side effects. |
| **RULE_ORG_10** | 🟡 Medium | Explicit imports: không dùng wildcard imports (`import * as`). Import named exports rõ ràng: `import { UserService, UserRepository } from './user.module'`. Wildcard imports làm không rõ dependencies, khó tree-shake, khó trace unused imports. |
| **RULE_ORG_11** | 🟡 Medium | Relative vs absolute imports: path aliases cho cross-folder, relative cho sibling/adjacent files. Không dùng `../` chains > 3 levels — đó là dấu hiệu folder structure sai. Consider refactor folder structure thay vì accept deep relative paths. |
| **RULE_ORG_12** | 🟡 Medium | Dead code elimination: remove unused exports, functions, types. TypeScript compiler không tự động remove unused code (trừ `isolatedModules`). Dùng `ts-prune`, `knip`, hoặc ESLint `no-unused-vars`/`no-restricted-globals`. Xóa code không dùng thay vì comment out. |

---

## 8. 🔬 Advanced TypeScript

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ADV_01** | 🟡 Medium | Recursive types: TypeScript hỗ trợ recursive type aliases với điều kiện. `type DeepPartial<T> = T extends object ? { [P in keyof T]?: DeepPartial<T[P]> } : T`. Cẩn thận với circular references trong interfaces — có thể cause "Type instantiation is excessively deep" error. Đặt `--noUncheckedIndexedAccess` khi dùng recursive mapped types. |
| **RULE_ADV_02** | 🟡 Medium | Variadic tuple types: dùng `...args` trong type để manipulate tuple types. Pattern: `type Concat<T extends any[], U extends any[]> = [...T, ...U]`. Useful cho typed event emitters, function composition, append/prepend operations. Có thể dùng với generics để type-check arguments. |
| **RULE_ADV_03** | 🟡 Medium | Satisfies operator (`satisfies`): TypeScript 4.9+. Dùng `satisfies` khi muốn validate type mà không widen. `const config = { db: { host: 'localhost' } } satisfies Config` — TypeScript biết config.db.host là literal `'localhost'`, không phải `string`. Rất hữu ích cho typed objects literals. |
| **RULE_ADV_04** | 🟡 Medium | `using` keyword (Stage 3, TS 5.2+): Resource management pattern. `using` invokes `Symbol.dispose` tự động khi scope exit. Dùng cho: file handles, database connections, locks. Pattern: `using file = using openFile(path);` — tương tự Python's `with`. Giúp avoid resource leaks without explicit try/finally. |
| **RULE_ADV_05** | 🟡 Medium | Declaration merging: interfaces merge khi khai báo cùng tên. Dùng để extend third-party types: `declare module 'express' { interface Request { userId?: string; } }`. Cẩn thận: merging có thể cause unexpected behavior nếu không document rõ. Prefer module augmentation thay vì modify original declaration. |
| **RULE_ADV_06** | 🟡 Medium | `infer` advanced: extract types từ complex structures. `type UnwrapPromise<T> = T extends Promise<infer U> ? U : T`. Kết hợp với rest/optional parameters: `type First<T extends any[]> = T extends [infer F, ...any[]] ? F : never`. Có thể extract function parameter/return types, array element types, object property types. |
| **RULE_ADV_07** | 🟡 Medium | Type-level programming: dùng conditional types, mapped types, template literal types để compute types. Avoid over-engineering — nếu type error messages trở nên cryptic ("Type instantiation is excessively deep"), simplify. Type-level code có compile-time cost — profile nếu project có hàng trăm complex types. |
| **RULE_ADV_08** | 🟡 Medium | Cross-file type boundaries: khi pass types across module boundaries, dùng explicit types (exported types/interfaces) thay vì inferred types. Inferred types (return type của internal function) có thể thay đổi mà không có breaking change notification. Explicit public API types enforce backward compatibility. |

---

## 9. 🧩 TypeScript & Tooling

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TOOL_01** | 🔴 Critical | ESLint với `@typescript-eslint`: không chỉ dùng JavaScript ESLint rules. `@typescript-eslint/explicit-function-return-type`, `@typescript-eslint/no-explicit-any`, `@typescript-eslint/no-non-null-assertion`, `@typescript-eslint/consistent-type-imports`, `@typescript-eslint/no-floating-promises`. Run ESLint trong CI, fail on errors. |
| **RULE_TOOL_02** | 🔴 Critical | `tsconfig` strictness: ngoài `strict: true`, xem xét thêm: `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitReturns` (every code path returns value). Các flags này có thể break existing code — add có plan, không phải all-at-once. |
| **RULE_TOOL_03** | 🟠 High | Project references cho monorepo: nếu codebase có multiple packages, dùng TypeScript project references. `tsconfig` base + per-package configs. Build order được TypeScript resolve tự động. Giúp `tsc --build` incremental, faster than `tsc` all packages. |
| **RULE_TOOL_04** | 🟠 High | `incremental: true` trong tsconfig: cache type-checking results, faster subsequent builds. Kết hợp với `composite: true` cho project references. `tsBuildInfoFile` đặt ở shared location (`.tsbuildinfo`). Clear cache khi having strange type errors. |
| **RULE_TOOL_05** | 🟠 High | Source maps và declaration maps: `sourceMap: true`, `declarationMap: true` để debugging TypeScript trong production. `declaration: true` bắt buộc nếu package là library — consumers cần `.d.ts` files. `declarationMap` cho seamless "Go to Definition" vào library source. |
| **RULE_TOOL_06** | 🟠 High | `skipLibCheck: true`: skip type-checking `.d.ts` files từ node_modules. Giảm build time đáng kể. Chỉ set `false` khi cần verify type definitions từ dependencies (thường không cần). Không `skipLibCheck` nếu có custom type overrides muốn verify. |
| **RULE_TOOL_07** | 🟡 Medium | Editor setup: sử dụng same TypeScript version trong editor và build. VS Code tự detect `typescript.tsdk` trong `package.json`. Mismatch giữa editor TS version và build TS version có thể cause confusing errors. |
| **RULE_TOOL_08** | 🟡 Medium | `tsc --noEmit` for type-checking only: không emit JavaScript files, chỉ check types. Dùng trong CI cho fast type check. `tsc --build` dùng cho production builds. Tách type-checking và emitting nếu build system cần flexibility. |
| **RULE_TOOL_09** | 🟡 Medium | Type coverage reporting: track percentage of typed code. Tools: `tsc --noEmit`, `@typescript/analyze-trace`, `knip`, `ts-prune`. Mục tiêu: >= 95% typed. Untyped code (`.js` files, `any` types) phải có justification. |
| **RULE_TOOL_10** | 🟡 Medium | Upgrade strategy: TypeScript upgrades thường xuyên (mỗi 3-6 tháng). Major version upgrades (TS 4→5) có breaking changes. Test with `strict: false` first, then gradually enable strict flags. Subscribe to TypeScript release notes để anticipate changes. |

---

## 10. 📚 Documentation & Types

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DOC_01** | 🟠 High | Type documentation: exported types/interfaces phải có JSDoc. Mô tả purpose, not implementation. Ví dụ: `/** Represents a user in the system. */ interface User { /** Unique identifier. */ id: UserId; /** User's email address (verified). */ email: string; }`. Documentation giúp IDE hover tips và generation tools. |
| **RULE_DOC_02** | 🟠 High | README per package/feature: giải thích purpose, usage examples, constraints. Nếu package có complex generic types, provide usage examples. README không chỉ là installation instructions — phải có conceptual overview. |
| **RULE_DOC_03** | 🟠 High | `strict` flag migrations: khi enabling strict flags on existing codebase, create tracking issue, add comment in code, set timeline. `strictNullChecks` migration guide: (1) add flag, (2) fix errors one file/module, (3) remove non-null assertions progressively. |
| **RULE_DOC_04** | 🟡 Medium | Changelog: breaking type changes phải documented. Semver: major = breaking type changes, minor = new types, patch = bug fixes. Type changes không breaking trên JavaScript consumers (nếu `.d.ts` backward compatible). |
| **RULE_DOC_05** | 🟡 Medium | Inline comments for complex types: type-level code phức tạp cần comments giải thích intent. `// Extracts the return type of an async function, unwrapping Promise` `type AsyncReturnType<T extends (...args: any) => Promise<any>> = T extends (...args: any) => Promise<infer R> ? R : never;`. Không assume người đọc hiểu advanced type patterns. |
| **RULE_DOC_06** | 🟡 Medium | Examples in type documentation: dùng JSDoc `@example` tag để show usage. `/** Creates a Result type. @example const result = ok(42); @example const result = err(new Error('failed')); */`. Examples là best documentation — chúng double như tests. |
| **RULE_DOC_07** | 🟡 Medium | Deprecation notices: khi deprecating types, dùng `/** @deprecated Use NewType instead. Will be removed in v3.0.0 */`. Deprecated types nên `export type DeprecatedType = NewType` (alias) để migration path rõ ràng. Add `@deprecated` JSDoc và mark với `@since` version. |
