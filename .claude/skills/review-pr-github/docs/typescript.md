# TypeScript Checklist

## 1. 📋 TypeScript Best Practices

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TS_01** | 🔴 Critical | Bật strict mode trong `tsconfig.json`: `"strict": true` để phát hiện lỗi type sớm. |
| **RULE_TS_02** | 🔴 Critical | Không dùng `any` type — dùng `unknown` khi type không xác định và validate trước khi sử dụng. |
| **RULE_TS_03** | 🔴 Critical | Không ignore TypeScript errors (`@ts-ignore`, `@ts-expect-error`) trong production code. |
| **RULE_TS_04** | 🟠 High | Dùng TypeScript strict null checks (`strictNullChecks: true`) để tránh undefined/null errors. |
| **RULE_TS_05** | 🟠 High | Export interfaces và types thay vì classes khi chỉ định shape — dễ mock trong tests. |
| **RULE_TS_06** | 🟠 High | Dùng `const` assertions (`as const`) cho config objects không thay đổi. |
| **RULE_TS_07** | 🟠 High | Tránh type assertions (`as`) khi có thể — dùng type guards hoặc discriminators. |
| **RULE_TS_08** | 🟡 Medium | Dùng branded types cho IDs, tokens để tránh confusion (ví dụ: `type UserId = string & { readonly brand: unique symbol }`). |
| **RULE_TS_09** | 🟡 Medium | Đặt `noUncheckedIndexedAccess: true` để access array/object index phải check undefined. |
| **RULE_TS_10** | 🟡 Medium | Dùng `infer` trong conditional types thay vì duplicate type logic. |
| **RULE_TS_11** | 🟡 Medium | Discriminated unions cho state management: `type Result = { ok: true; data: T } | { ok: false; error: Error }`. |
| **RULE_TS_12** | 🟡 Medium | Utility types: dùng `Partial`, `Required`, `Pick`, `Omit`, `Record` thay vì tự viết lại. |

---

## 2. 🧪 Testing & Validation

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TEST_01** | 🔴 Critical | CDK code phải có unit test cho every Stack/Construct — dùng `@aws-cdk/assert` hoặc `@aws-cdk-testing/青龙` assertions. |
| **RULE_TEST_02** | 🟠 High | Integration test: deploy infrastructure vào test environment, chạy automated tests, teardown. |
| **RULE_TEST_03** | 🟠 High | Snapshot test cho CloudFormation output để detect infrastructure drift. |
| **RULE_TEST_04** | 🟠 High | `cdk synth` phải pass trong CI — nếu synth fail thì không deploy. |
| **RULE_TEST_05** | 🟡 Medium | Policy validation test: Lambda execution role không có wildcard resource. |
| **RULE_TEST_06** | 🟠 High | Unit tests cho pure functions và utilities — dùng Jest hoặc Vitest. |
| **RULE_TEST_07** | 🟠 High | Mock dependencies rõ ràng: dùng `jest.mock()` hoặc `vi.mock()` với factory function. |
| **RULE_TEST_08** | 🟡 Medium | Test coverage >= 80% cho critical paths (business logic, error handling). |
| **RULE_TEST_09** | 🟡 Medium | Dùng `describe`/`it` blocks có naming rõ ràng: "should return X when Y". |

---

## 3. 📦 Dependencies & Configuration

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DEP_01** | 🔴 Critical | `package-lock.json` hoặc `yarn.lock` phải được commit. Không commit `node_modules/`. |
| **RULE_DEP_02** | 🟠 High | npm audit / yarn audit chạy trong CI, fail nếu có vulnerability Critical/High. |
| **RULE_DEP_03** | 🟠 High | CDK constructs version phải nhất quán (dùng `cdk.json` `cdkVersions` để validate). |
| **RULE_DEP_04** | 🟡 Medium | Dùng `npm ci` / `yarn --frozen-lockfile` trong CI thay vì `npm install` để đảm bảo reproducible build. |
| **RULE_DEP_05** | 🟠 High | Dependency version pinning: dùng exact versions (`1.2.3`) thay vì ranges (`^1.2.0`) trong production. |
| **RULE_DEP_06** | 🟠 High | Audit third-party packages: kiểm tra license, maintainability, security trước khi thêm. |
| **RULE_DEP_07** | 🟡 Medium |定期 update dependencies để get security patches — dùng Renovate hoặc Dependabot. |
| **RULE_DEP_08** | 🟡 Medium | Bundle size tracking: dùng `size-limit` hoặc similar để detect oversized bundles. |

---

## 4. ⚡ Node.js Best Practices

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_NODE_01** | 🔴 Critical | Không dùng `require()` — dùng ESM (`import`/`export`) cho consistency với TypeScript. |
| **RULE_NODE_02** | 🔴 Critical | Environment variables phải được validate khi app start (dùng `zod`, `yup`, hoặc `envalid`). |
| **RULE_NODE_03** | 🟠 High | Graceful shutdown: handle `SIGTERM` và `SIGINT` để cleanup resources trước khi exit. |
| **RULE_NODE_04** | 🟠 High | Memory leaks: monitor memory usage, avoid global caches grow unbounded. |
| **RULE_NODE_05** | 🟠 High | Unhandled promise rejections phải được handle — dùng `process.on('unhandledRejection', ...)`. |
| **RULE_NODE_06** | 🟠 High | Stream handling: always handle backpressure, pipe streams correctly, handle errors. |
| **RULE_NODE_07** | 🟡 Medium | Worker threads cho CPU-intensive tasks — không block event loop. |
| **RULE_NODE_08** | 🟡 Medium | Dùng `NODE_ENV=production` để enable production optimizations (minification, tree-shaking). |
| **RULE_NODE_09** | 🟡 Medium | Process manager: dùng PM2, systemd, hoặc container orchestrator thay vì `node` trực tiếp. |

---

## 5. 🔴 Error Handling & Logging

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ERR_01** | 🔴 Critical | Custom error classes: tạo specific error types thay vì throw generic `Error`. |
| **RULE_ERR_02** | 🔴 Critical | Error propagation: errors phải được wrapped với context khi re-throw (`throw new AppError(..., { cause: err })`). |
| **RULE_ERR_03** | 🟠 High | Result type pattern: dùng `Result<T, E>` thay vì throw exceptions cho expected failures. |
| **RULE_ERR_04** | 🟠 High | Centralized error handler: một middleware/handler catch và format all errors. |
| **RULE_ERR_05** | 🟠 High | Logging: structured JSON logs với fields: timestamp, level, message, requestId, userId, error. |
| **RULE_ERR_06** | 🟠 High | Log levels: `error` (app cannot continue), `warn` (recoverable issue), `info` (significant events), `debug` (development). |
| **RULE_ERR_07** | 🟡 Medium | Sensitive data redaction: không log passwords, tokens, PII — dùng redaction utilities. |
| **RULE_ERR_08** | 🟡 Medium | Alert on errors: production errors phải trigger alerts (to Slack, PagerDuty). |
| **RULE_ERR_09** | 🟡 Medium | Error budgets: track error rate và set SLO threshold. |

---

## 6. 🎨 Async Patterns

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ASYNC_01** | 🔴 Critical | Async/await: luôn dùng `await` thay vì `.then().catch()` — dễ đọc và debug. |
| **RULE_ASYNC_02** | 🔴 Critical | `Promise.all()`: dùng khi có independent async operations — không sequential nếu không cần. |
| **RULE_ASYNC_03** | 🟠 High | Error handling in `Promise.all()`: dùng `Promise.allSettled()` nếu một số failures là expected. |
| **RULE_ASYNC_04** | 🟠 High | Async iterators cho large datasets: dùng `ReadableStream` hoặc generators thay vì load all in memory. |
| **RULE_ASYNC_05** | 🟠 High | Race conditions: dùng `Promise.race()` với timeout để prevent hanging operations. |
| **RULE_ASYNC_06** | 🟡 Medium | Semaphore pattern cho concurrency limiting: không spawn unlimited promises. |
| **RULE_ASYNC_07** | 🟡 Medium | Async queue: dùng for batching, backpressure khi handling high-throughput scenarios. |

---

## 7. 🏗️ Design Patterns

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_PAT_01** | 🟠 High | Repository pattern: abstract database access, dễ mock trong tests. |
| **RULE_PAT_02** | 🟠 High | Dependency injection: inject dependencies qua constructor, không hardcode `new Class()`. |
| **RULE_PAT_03** | 🟠 High | Factory pattern: cho complex object creation với multiple configurations. |
| **RULE_PAT_04** | 🟠 High | Event-driven: dùng EventEmitter hoặc custom event bus cho loose coupling. |
| **RULE_PAT_05** | 🟡 Medium | Strategy pattern: cho interchangeable algorithms (different payment providers, loggers). |
| **RULE_PAT_06** | 🟡 Medium | Observer pattern: cho reactive data flow (RxJS observables nếu cần). |
| **RULE_PAT_07** | 🟡 Medium | Decorator pattern: dùng `reflect-metadata` hoặc native decorators cho cross-cutting concerns. |

---

## 8. ⚙️ Configuration Management

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CFG_01** | 🔴 Critical | Config không được hardcode — load từ environment variables. |
| **RULE_CFG_02** | 🔴 Critical | Schema validation: validate config schema at startup, fail fast nếu missing required fields. |
| **RULE_CFG_03** | 🟠 High | Config tiering: `default` < `development` < `staging` < `production` với proper precedence. |
| **RULE_CFG_04** | 🟠 High | Secrets: sensitive config (DB password, API keys) phải được load từ secrets manager. |
| **RULE_CFG_05** | 🟠 High | Type-safe config: dùng `zod` hoặc `typescript-is` để validate config có type safety. |
| **RULE_CFG_06** | 🟡 Medium | Config versioning: config changes nên be tracked, có rollback capability. |
| **RULE_CFG_07** | 🟡 Medium | Feature flags: dùng config-driven feature toggles, không comment/uncomment code. |

---

## 9. 🚀 Performance

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_PERF_01** | 🟠 High | Bundle optimization: code splitting, lazy loading, tree-shaking enabled. |
| **RULE_PERF_02** | 🟠 High | Lazy initialization: không khởi tạo heavy objects cho đến khi cần. |
| **RULE_PERF_03** | 🟠 High | Caching: implement caching layer cho expensive computations (in-memory, Redis). |
| **RULE_PERF_04** | 🟠 High | Pagination: never return unbounded lists — luôn paginate. |
| **RULE_PERF_05** | 🟡 Medium | Memoization: dùng `useMemo`, `computed` cho expensive derivations. |
| **RULE_PERF_06** | 🟡 Medium | Connection pooling: reuse database/Redis connections, don't create per-request. |
| **RULE_PERF_07** | 🟡 Medium | Batch operations: batch multiple writes/reads thay vì individual operations. |
| **RULE_PERF_08** | 🟡 Medium | Profiling: dùng clinic.js, 0x, hoặc built-in profiler để identify bottlenecks. |

---

## 10. 🛡️ Security

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_SEC_01** | 🔴 Critical | Input validation: validate all external input (request body, params, headers) với zod/yup. |
| **RULE_SEC_02** | 🔴 Critical | Output encoding: encode output appropriately (HTML encoding, SQL parameterization). |
| **RULE_SEC_03** | 🔴 Critical | Authentication/Authorization: implement properly, không bypass hoặc hardcode credentials. |
| **RULE_SEC_04** | 🟠 High | Rate limiting: implement rate limiting cho all public endpoints. |
| **RULE_SEC_05** | 🟠 High | CORS: configure CORS properly, không dùng `*` trong production. |
| **RULE_SEC_06** | 🟠 High | Helmet: dùng `helmet` middleware để set security headers. |
| **RULE_SEC_07** | 🟡 Medium | CSRF protection: implement CSRF tokens cho state-changing operations. |
| **RULE_SEC_08** | 🟡 Medium | SQL injection: always use parameterized queries, không string concatenation. |
| **RULE_SEC_09** | 🟡 Medium | XXS prevention: sanitize HTML input, escape output appropriately. |

---

## 11. 📚 API Design

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_API_01** | 🔴 Critical | HTTP status codes: dùng đúng codes (200, 201, 400, 401, 403, 404, 500...). |
| **RULE_API_02** | 🔴 Critical | Response format: nhất quán JSON structure, không leak internal errors. |
| **RULE_API_03** | 🟠 High | Pagination: standard pagination response `{ data, meta: { page, total, perPage } }`. |
| **RULE_API_04** | 🟠 High | Versioning: `GET /v1/resources`, có deprecation policy khi breaking changes. |
| **RULE_API_05** | 🟠 High | Request validation: validate request body, params, query với JSON schema. |
| **RULE_API_06** | 🟡 Medium | OpenAPI/Swagger: document API với OpenAPI spec, generate types từ spec. |
| **RULE_API_07** | 🟡 Medium | API errors: `{ error: { code, message, details } }` format. |

---

## 12. 🏛️ Code Organization

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ORG_01** | 🟠 High | Feature-based folder structure: `src/features/{feature}/...` thay vì type-based. |
| **RULE_ORG_02** | 🟠 High | Barrel exports (`index.ts`): có một entry point cho mỗi module. |
| **RULE_ORG_03** | 🟠 High | Path aliases: configure `paths` in `tsconfig.json` (`@/utils/*`, `@/types/*`). |
| **RULE_ORG_04** | 🟡 Medium | Shared code: có `shared/` hoặc `common/` modules cho reusable utilities. |
| **RULE_ORG_05** | 🟡 Medium | Boundary enforcement: feature không được import từ feature khác — dùng events/shared types. |
| **RULE_ORG_06** | 🟡 Medium | Single responsibility: mỗi file/class/function chỉ làm một việc. |
