# GitHub Actions Checklist

## 1. 🪝 GitHub Actions Fundamentals

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_GHA_01** | 🔴 Critical | Secrets: không access GitHub Secrets trong log output (`::add-mask::` hoặc không echo secrets). |
| **RULE_GHA_02** | 🔴 Critical | OIDC: dùng `actions/checkout@v4` và AWS OIDC Role thay vì long-term access key. Cấu hình `permissions: id-token: write`. |
| **RULE_GHA_03** | 🔴 Critical | `actions/checkout`: luôn specify `persist-credentials: false` nếu không cần git credentials. |
| **RULE_GHA_04** | 🟠 High | Checkout với `sparse-checkout` để chỉ clone directory cần thiết — giảm attack surface. |
| **RULE_GHA_05** | 🟠 High | Pin action versions bằng SHA (`actions/checkout@b4ffde65f46336ab88af53f90cecc9`) thay vì `@v4` — prevent supply chain attack. |
| **RULE_GHA_06** | 🟠 High | Matrix strategy: dùng cho multi-version testing (Node 18, 20, 22). Không hardcode version trong step. |
| **RULE_GHA_07** | 🟠 High | Caching: cache `node_modules`, Docker layers, CDK context để speed up workflow. |
| **RULE_GHA_08** | 🟠 High | Timeout: đặt `timeout-minutes` cho mỗi job (recommend <= 30 phút) để tránh zombie jobs. |
| **RULE_GHA_09** | 🟠 High | Fail-fast: `fail-fast: true` trong matrix để stop early khi có lỗi. |
| **RULE_GHA_10** | 🟡 Medium | Artifact retention: set `retention-days` phù hợp (recommend <= 7 ngày) để tiết kiệm storage. |
| **RULE_GHA_11** | 🟡 Medium | Concurrency group: `concurrency: group: ${{ github.workflow }}-${{ github.ref }}` để cancel in-progress runs on new push. |
| **RULE_GHA_12** | 🟡 Medium | Code coverage: upload coverage artifact vào Codecov/S3, không chỉ hiển thị trong log. |

---

## 2. 🔄 CI/CD Pipeline (CodePipeline / CodeBuild)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_PIPE_01** | 🔴 Critical | Pipeline phải có manual approval gate trước khi deploy production. |
| **RULE_PIPE_02** | 🔴 Critical | Build spec / pipeline definition phải được lưu trong source code (không hardcode trong CodePipeline console). |
| **RULE_PIPE_03** | 🔴 Critical | Artifact bucket phải có versioning và encryption enabled. Không dùng default S3 bucket. |
| **RULE_PIPE_04** | 🟠 High | Pipeline phải chạy `cdk diff` trong build stage để review thay đổi trước khi deploy. |
| **RULE_PIPE_05** | 🟠 High | Test stage phải chạy trước deploy: unit test, integration test, security scan (npm audit, trivy). |
| **RULE_PIPE_06** | 🟠 High | Image push lên ECR phải có tag theo git commit SHA (`git rev-parse HEAD`) — không dùng `latest`. |
| **RULE_PIPE_07** | 🟠 High | Cross-environment promotion: image được build và scan ở staging, chỉ promote lên production khi pass all checks. |
| **RULE_PIPE_08** | 🟡 Medium | Pipeline nên có notify qua SNS/Chatbot khi deployment thất bại. |
| **RULE_PIPE_09** | 🟡 Medium | Deploy rollback tự động: CodeDeploy hoặc ECS deployment với `rollbackOnFailure: true`. |

---

## 3. 🐳 Docker in GitHub Actions

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DOCKER_ACT_01** | 🔴 Critical | Dùng `docker/build-push-action@v6` với `push: true` và `tags:` để push multi-arch images. |
| **RULE_DOCKER_ACT_02** | 🔴 Critical | Image tag phải include git SHA: `sha-${{ github.sha }}` — không dùng `latest`. |
| **RULE_DOCKER_ACT_03** | 🟠 High | Dùng BuildKit (`docker/setup-buildx-action`) để enable advanced build features và caching. |
| **RULE_DOCKER_ACT_04** | 🟠 High | Cache Docker layers: dùng `cache-from: type=gha` và `cache-to: type=gha` để speed up builds. |
| **RULE_DOCKER_ACT_05** | 🟠 High | Docker metadata action (`docker/metadata-action`) để generate tags tự động từ git events. |
| **RULE_DOCKER_ACT_06** | 🟠 High | Scan image trước khi push: dùng Trivy hoặc Grype, fail nếu có CVE Critical/High. |
| **RULE_DOCKER_ACT_07** | 🟡 Medium | Multi-platform builds (`platforms: linux/amd64,linux/arm64`) nếu cần support nhiều arch. |
| **RULE_DOCKER_ACT_08** | 🟡 Medium | Dùng `docker/setup-buildx-action` để setup BuildKit builder. |

---

## 4. 🔒 Security Hardening

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_SEC_GHA_01** | 🔴 Critical | Không hardcode secrets trong workflow — dùng GitHub Secrets hoặc OIDC. |
| **RULE_SEC_GHA_02** | 🔴 Critical | Workflow phải có `permissions` explicitly set, không dùng `permissions: write-all`. |
| **RULE_SEC_GHA_03** | 🔴 Critical | Dùng `路径Filtering` để trigger workflow chỉ khi có file thay đổi cần thiết. |
| **RULE_SEC_GHA_04** | 🟠 High | Bật Secret scanning và Dependabot alerts trong repository settings. |
| **RULE_SEC_GHA_05** | 🟠 High | Dùng `actions/dependency-review-action` để block PR với vulnerable dependencies. |
| **RULE_SEC_GHA_06** | 🟠 High | CodeQL analysis: dùng `github/codeql-action/init-analyze` để detect vulnerabilities. |
| **RULE_SEC_GHA_07** | 🟠 High | Không dùng `pull_request_target` trigger nếu không cần — có nguy cơ credential leak. |
| **RULE_SEC_GHA_08** | 🟠 High | Review GitHub Apps và OAuth permissions định kỳ — remove không cần thiết. |
| **RULE_SEC_GHA_09** | 🟡 Medium | Dùng `osv-scanner` hoặc `npm audit` trong CI để scan vulnerabilities. |
| **RULE_SEC_GHA_10** | 🟡 Medium | Workflow artifacts không được chứa sensitive data — verify trước khi upload. |

---

## 5. 🚀 Deployment Strategies

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DEPLOY_01** | 🔴 Critical | Blue-green deployment: deploy version mới song song, switch traffic sau khi verify. |
| **RULE_DEPLOY_02** | 🔴 Critical | Rollback plan phải được define trước khi deploy: automatic rollback trigger conditions. |
| **RULE_DEPLOY_03** | 🟠 High | Canary deployment: route % traffic nhỏ đến version mới, tăng dần sau khi verify. |
| **RULE_DEPLOY_04** | 🟠 High | Environment protection: production environment phải có restrictions (required reviewers, IP whitelist). |
| **RULE_DEPLOY_05** | 🟠 High | Database migration phải be backward-compatible: old code phải work với new schema. |
| **RULE_DEPLOY_06** | 🟠 High | Deploy notification: SNS/Chatbot message khi deployment start, success, failure. |
| **RULE_DEPLOY_07** | 🟡 Medium | Feature flags: dùng feature flags để enable/disable features thay vì full deploy. |
| **RULE_DEPLOY_08** | 🟡 Medium | Deploy window: production deploy nên có maintenance window (off-peak hours). |
| **RULE_DEPLOY_09** | 🟡 Medium | Deployment frequency: track DORA metrics (deployment frequency, lead time). |

---

## 6. 🔀 Workflow Optimization

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_OPT_01** | 🟠 High | Dùng reusable workflows (`workflow_call`) để tránh duplicate workflow definitions. |
| **RULE_OPT_02** | 🟠 High | Composite actions cho repeated steps — đặt trong `.github/actions/`. |
| **RULE_OPT_03** | 🟠 High | Job parallelization: chạy independent jobs parallel (lint, test, build) thay vì sequential. |
| **RULE_OPT_04** | 🟠 High | Caching strategy: cache package manager files, Docker layers, build outputs. |
| **RULE_OPT_05** | 🟡 Medium | Conditional job/step: dùng `if:` để skip unnecessary jobs (skip lint nếu chỉ có docs changes). |
| **RULE_OPT_06** | 🟡 Medium | Reusable workflow inputs/outputs: standardize contracts giữa các workflows. |
| **RULE_OPT_07** | 🟡 Medium | Job dependencies: dùng `needs:` để ensure correct execution order khi cần. |

---

## 7. 🧪 Testing in CI

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_TEST_01** | 🔴 Critical | Test phải fail pipeline khi có test fail — không continue on error. |
| **RULE_TEST_02** | 🔴 Critical | Unit tests phải chạy trong < 5 phút. Nếu lâu hơn, parallelize hoặc split thành multiple jobs. |
| **RULE_TEST_03** | 🟠 High | Coverage report phải được upload và visible trong PR comments. |
| **RULE_TEST_04** | 🟠 High | Integration tests phải chạy trong isolated environment ( không affect production). |
| **RULE_TEST_05** | 🟠 High | E2E tests: dùng Playwright hoặc Cypress, chạy headless, parallel trên multiple browsers. |
| **RULE_TEST_06** | 🟡 Medium | Test matrix: test trên multiple Node versions, databases, browsers nếu applicable. |
| **RULE_TEST_07** | 🟡 Medium | Flaky test detection: track và alert khi tests fail intermittently. |
| **RULE_TEST_08** | 🟡 Medium | Mutation testing (nếu có time): verify test quality, không chỉ coverage. |

---

## 8. 📦 Build & Package

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_BUILD_01** | 🔴 Critical | Build artifact phải được signed và verified trước khi deploy. |
| **RULE_BUILD_02** | 🔴 Critical | SBOM (Software Bill of Materials) phải được generate và lưu trữ với artifact. |
| **RULE_BUILD_03** | 🟠 High | Reproducible builds: dùng `npm ci --frozen-lockfile` hoặc `yarn --frozen-lockfile`. |
| **RULE_BUILD_04** | 🟠 High | Build output phải consistent giữa các lần build (deterministic). |
| **RULE_BUILD_05** | 🟡 Medium | Dependency tree visualization để track direct và transitive dependencies. |
| **RULE_BUILD_06** | 🟡 Medium | Build provenance: dùng SLSA (Supply-chain Levels for Software Artifacts) framework. |

---

## 9. 🌍 Multi-Environment

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ENV_01** | 🔴 Critical | Environment-specific configs phải được load từ Secrets Manager, không hardcode trong code. |
| **RULE_ENV_02** | 🔴 Critical | Production environment phải có approval requirement — không auto-deploy được. |
| **RULE_ENV_03** | 🟠 High | Environment parity: development và staging phải mirror production configuration. |
| **RULE_ENV_04** | 🟠 High | Staging deploy tự động từ main branch, production deploy chỉ từ release tags. |
| **RULE_ENV_05** | 🟡 Medium | Feature branches deploy được vào ephemeral environment để preview. |
| **RULE_ENV_06** | 🟡 Medium | Environment inventory: maintain danh sách active environments và owners. |

---

## 10. 🔍 Monitoring & Feedback

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_MON_01** | 🟠 High | Deployment metrics: track thời gian deploy, success rate, rollback frequency. |
| **RULE_MON_02** | 🟠 High | Post-deploy verification: automated smoke tests chạy sau deploy để verify. |
| **RULE_MON_03** | 🟠 High | Slack/Teams notification: deployment status (start, success, failure) được notify. |
| **RULE_MON_04** | 🟡 Medium | PR status check: maintain clear status checks requirements trước khi merge. |
| **RULE_MON_05** | 🟡 Medium | Build time tracking: identify và optimize slow steps trong pipeline. |
| **RULE_MON_06** | 🟡 Medium | Cost tracking: monitor Actions minutes consumption và optimize nếu cần. |
