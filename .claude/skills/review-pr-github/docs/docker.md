# Docker Checklist

## 1. 🐳 Docker Image

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DOCKER_01** | 🔴 Critical | Không chạy container với user `root`. Dùng `USER` instruction để switch sang non-root user. |
| **RULE_DOCKER_02** | 🔴 Critical | Không hardcode credentials, secret, token trong Dockerfile. Dùng `ARG` hoặc secret mount từ bên ngoài. |
| **RULE_DOCKER_03** | 🔴 Critical | Không dùng image `latest` tag — phải lock version cụ thể để đảm bảo reproducible build. |
| **RULE_DOCKER_04** | 🔴 Critical | Cần có `.dockerignore` để loại trừ `node_modules`, `.git`, secrets, và file không cần thiết vào context. |
| **RULE_DOCKER_05** | 🔴 Critical | Multi-stage build: stage 1 dùng `node:<version>-alpine` hoặc `node:<version>-slim` để build, stage 2 chỉ copy artifact vào image production nhỏ hơn. |
| **RULE_DOCKER_06** | 🟠 High | Thứ tự Dockerfile instruction phải tối ưu cache: dependency install (package.json) trước, source code copy sau cùng. Thay đổi source code không invalidate dependency layer. |
| **RULE_DOCKER_07** | 🟠 High | Base image phải được scan lỗ hổng bảo mật (Trivy, Snyk, Grype) trước khi deploy lên môi trường production. |
| **RULE_DOCKER_08** | 🟠 High | Health check: mọi container production phải có `HEALTHCHECK` instruction hoặc target health endpoint qua load balancer. |
| **RULE_DOCKER_09** | 🟡 Medium | Dùng `EXPOSE` đúng port, không expose port không cần thiết (chỉ expose port ứng dụng thực sự listen). |
| **RULE_DOCKER_10** | 🟡 Medium | Không có comment chứa thông tin nhạy cảm (token, endpoint, password mẫu) trong Dockerfile. |

---

## 2. ☸️ Docker Compose (Development & Production)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_COMPOSE_01** | 🔴 Critical | Không lưu secrets trực tiếp trong `docker-compose.yml` — dùng `.env` file hoặc `env_file`, và đảm bảo `.env` được add vào `.gitignore`. |
| **RULE_COMPOSE_02** | 🔴 Critical | Services phải có `restart: unless-stopped` hoặc `restart: on-failure` với limit để đảm bảo self-healing. |
| **RULE_COMPOSE_03** | 🟠 High | Khai báo `depends_on` với `condition: service_healthy` thay vì chỉ liệt kê tên service — tránh race condition khi database chưa ready. |
| **RULE_COMPOSE_04** | 🟠 High | Đặt resource limits (`deploy.resources.limits`) cho mỗi service để tránh container ngốn hết RAM/CPU. |
| **RULE_COMPOSE_05** | 🟠 High | Dùng volume named thay vì bind mount cho data persistence. Bind mount chỉ dùng cho development. |
| **RULE_COMPOSE_06** | 🟠 High | Production compose file (`docker-compose.prod.yml`) phải tách biệt với development, không dùng dev dependencies. |
| **RULE_COMPOSE_07** | 🟡 Medium | Đặt `container_name` cố định thay vì random name để dễ quản lý và monitoring. |
| **RULE_COMPOSE_08** | 🟡 Medium | Dùng `networks` để phân tách network zones (frontend, backend, database) — không dùng default network cho mọi thứ. |
| **RULE_COMPOSE_09** | 🟡 Medium | Health check trên database và cache services (postgres, redis) để đảm bảo `depends_on` hoạt động đúng. |

---

## 3. 🔒 Container Security

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_SEC_01** | 🔴 Critical | Container phải chạy với `--read-only` root filesystem trong production nếu ứng dụng không cần write. |
| **RULE_SEC_02** | 🔴 Critical | Drop tất cả Linux capabilities không cần thiết: `docker run --cap-drop=ALL`. |
| **RULE_SEC_03** | 🔴 Critical | Không dùng `--privileged` flag — chỉ request capabilities cụ thể khi cần. |
| **RULE_SEC_04** | 🔴 Critical | Dùng `--security-opt=no-new-privileges:true` để prevent privilege escalation. |
| **RULE_SEC_05** | 🟠 High | Container phải có label `run-as-non-root` và verify user trong Dockerfile không phải root (UID 0). |
| **RULE_SEC_06** | 🟠 High | Dùng Seccomp profile mặc định hoặc custom profile nếu cần syscalls đặc biệt. Không dùng `--security-opt seccomp=unconfined`. |
| **RULE_SEC_07** | 🟠 High | _tmp_ volume phải được mount với `tmpfs` và `no-exec` flag để prevent malicious binary execution. |
| **RULE_SEC_08** | 🟠 High | Container không được phép modify kernel parameters (`--sysctl` chỉ dùng namespace-safe parameters). |
| **RULE_SEC_09** | 🟡 Medium | Health check endpoint phải được protected khỏi unauthorized access từ external network. |
| **RULE_SEC_10** | 🟡 Medium | Dùng container signing (Docker Content Trust / Cosign) để verify image integrity trước khi deploy. |
| **RULE_SEC_11** | 🟡 Medium | Image metadata không chứa thông tin internal (internal IP, hostname, organizational info). |

---

## 4. 📝 .dockerignore Best Practices

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_DIGNORE_01** | 🔴 Critical | `.dockerignore` phải loại trừ: `.git`, `.gitignore`, `*.md`, `*.log`, `*.pem`, `*.key`, `credentials*`. |
| **RULE_DIGNORE_02** | 🔴 Critical | Không include `node_modules`, `vendor`, `.venv` trong build context — phải được install trong container. |
| **RULE_DIGNORE_03** | 🟠 High | Ignore các file config local: `.env.local`, `.env.*.local`, `config.local.*`. |
| **RULE_DIGNORE_04** | 🟠 High | Ignore IDE/editor files: `.vscode`, `.idea`, `*.swp`, `*~`. |
| **RULE_DIGNORE_05** | 🟠 High | Ignore test files và coverage reports: `coverage/`, `.nyc_output/`, `phpunit.xml`. |
| **RULE_DIGNORE_06** | 🟡 Medium | Ignore CI/CD files không cần thiết: `.github/`, `.gitlab-ci.yml`, `.travis.yml`. |
| **RULE_DIGNORE_07** | 🟡 Medium | Ignore documentation và scripts không cần thiết: `docs/`, `scripts/`, `*.md`. |
| **RULE_DIGNORE_08** | 🟡 Medium | Dùng comment trong `.dockerignore` để explain các entry không rõ ràng. |

---

## 5. 🏗️ Multi-stage Build Optimization

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_MULTI_01** | 🔴 Critical | Multi-stage build phải separate builder và runner stage — builder stage có thể có full SDK, runner stage chỉ có runtime. |
| **RULE_MULTI_02** | 🔴 Critical | Không copy unnecessary files vào production image (source code, dev tools, compiler). |
| **RULE_MULTI_03** | 🟠 High | Dùng `--link` flag khi copy between stages để tận dụng cache tốt hơn. |
| **RULE_MULTI_04** | 🟠 High | Thứ tự stage nên được optimize: dependencies → builder → runner (để tận dụng layer caching). |
| **RULE_MULTI_05** | 🟠 High | Production image chỉ nên chứa: runtime, application artifact, và necessary configs. |
| **RULE_MULTI_06** | 🟡 Medium | Dùng BuildKit (`DOCKER_BUILDKIT=1`) để tận dụng parallel build và better caching. |
| **RULE_MULTI_07** | 🟡 Medium | Runner stage nên dùng `scratch` hoặc `distroless` image nếu ứng dụng hỗ trợ static binary. |

---

## 6. 🔧 Build Secrets & Args

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_BUILD_01** | 🔴 Critical | Secrets (npm token, SSH keys) không được pass qua `--build-arg` có thể bị inspect trong image history. |
| **RULE_BUILD_02** | 🔴 Critical | Dùng BuildKit secret mount (`--secret`) để pass sensitive build args an toàn. |
| **RULE_BUILD_03** | 🟠 High | Build args chỉ nên chứa non-sensitive config (version, environment name). |
| **RULE_BUILD_04** | 🟠 High | Không echo hoặc log build args trong Dockerfile (`RUN echo $SECRET`). |
| **RULE_BUILD_05** | 🟡 Medium | Dùng `ARG` với default value rỗng cho optional build secrets. |
| **RULE_BUILD_06** | 🟡 Medium | Validate build args trong `ONBUILD` triggers nếu dùng base image. |

---

## 7. 📊 Container Logging & Monitoring

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_LOG_01** | 🔴 Critical | Container phải write logs to stdout/stderr — không write trực tiếp vào file trong container. |
| **RULE_LOG_02** | 🟠 High | Dùng JSON log format (`--log-opt json-file`) để dễ parse và analyze. |
| **RULE_LOG_03** | 🟠 High | Log rotation phải được config: `--log-opt max-size=10m --log-opt max-file=3`. |
| **RULE_LOG_04** | 🟠 High | Application logs phải có structured format (JSON) với fields: timestamp, level, message, request_id. |
| **RULE_LOG_05** | 🟡 Medium | Không log sensitive data (passwords, tokens, PII) — dùng redaction. |
| **RULE_LOG_06** | 🟡 Medium | Log level phải configurable qua environment variable (`LOG_LEVEL=info`). |

---

## 8. 🌐 Container Networking

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_NET_01** | 🔴 Critical | Database và cache services không được expose port ra host — chỉ accessible qua internal network. |
| **RULE_NET_02** | 🟠 High | Dùng custom network per stack (frontend, backend, data) thay vì default bridge. |
| **RULE_NET_03** | 🟠 High | Không bind container port ra `0.0.0.0` trong production — bind ra `127.0.0.1` nếu chỉ cần localhost. |
| **RULE_NET_04** | 🟠 High | External-facing services (nginx, traefik) phải có rate limiting và connection limits. |
| **RULE_NET_05** | 🟡 Medium | Dùng container name thay vì IP trong `depends_on` và network alias. |
| **RULE_NET_06** | 🟡 Medium | DNS resolution phải hoạt động correct giữa containers trong same network. |

---

## 9. 💾 Container Storage & Data

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_VOL_01** | 🔴 Critical | Database data phải dùng named volume hoặc bind mount với backup strategy. |
| **RULE_VOL_02** | 🔴 Critical | Không dùng host volume mount cho sensitive data — dùng Docker secrets hoặc env vars. |
| **RULE_VOL_03** | 🟠 High | Volume permissions phải được set correctly (UID/GID phù hợp với container user). |
| **RULE_VOL_04** | 🟠 High | Temporary files nên dùng `tmpfs` mount để improve performance và security. |
| **RULE_VOL_05** | 🟡 Medium | Backup volume phải được scheduled và tested định kỳ. |
| **RULE_VOL_06** | 🟡 Medium | Unused volumes phải được cleanup để tránh disk space leak. |

---

## 10. 🚀 Container Performance

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_PERF_01** | 🟠 High | Container phải có resource requests và limits (`--memory`, `--cpus`) để prevent resource starvation. |
| **RULE_PERF_02** | 🟠 High | Java/Node.js apps phải set appropriate heap size thay vì dùng default (JVM: `-Xmx`, Node: `--max-old-space-size`). |
| **RULE_PERF_03** | 🟠 High | Alpine-based images có thể gặp issues với musl libc — dùng debian-slim nếu gặp performance issues. |
| **RULE_PERF_04** | 🟡 Medium | Container startup time phải < 30 giây — có thể cần optimize health check và init process. |
| **RULE_PERF_05** | 🟡 Medium | Dùng `USER` directive cuối Dockerfile để leverage Docker layer caching tốt hơn. |
| **RULE_PERF_06** | 🟡 Medium | Optimize layer order: rarely-changing layers trước, frequently-changing sau. |
