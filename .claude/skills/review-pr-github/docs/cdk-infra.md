# CDK Infrastructure Checklist (TypeScript)

## 1. 🔰 AWS CDK TypeScript

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CDK_01** | 🔴 Critical | Không hardcode credentials, region, account ID trong code. Dùng `cdk.json` context, environment variable, hoặc SSM Parameter Store. |
| **RULE_CDK_02** | 🔴 Critical | Stack phải có `terminationProtection: true` cho production để tránh xóa nhầm CloudFormation stack. |
| **RULE_CDK_03** | 🔴 Critical | CDK version phải được lock trong `package.json` (dùng `^` hoặc fixed version), và `cdk.json`/`cdk.context.json` phải được commit. |
| **RULE_CDK_04** | 🔴 Critical | Deploy với `cdk deploy --require-approval=medium` để đảm bảo mọi thay đổi đều được review. |
| **RULE_CDK_05** | 🟠 High | Thư mục `lib/` chỉ chứa Stack/Construct definition — không chứa business logic hoặc inline Lambda code phức tạp. Lambda nên có thư mục riêng (`src/lambda/`). |
| **RULE_CDK_06** | 🟠 High | Dùng TypeScript strict mode (`"strict": true` trong `tsconfig.json`) để phát hiện lỗi type sớm. |
| **RULE_CDK_07** | 🟠 High | Mọi secret (DB password, API key...) phải dùng AWS Secrets Manager hoặc SSM Parameter Store với `kmsKeyId` hoặc `secretString`. Không dùng plain text trong CloudFormation output. |
| **RULE_CDK_08** | 🟠 High | Construct ID phải đặt tên có ý nghĩa, không dùng tên mặc định (`CfnSecurityGroup`) — dễ identify trong CloudFormation console. |
| **RULE_CDK_09** | 🟠 High | ECR repository phải có `imageTagMutability: IMMUTABLE` và lifecycle rule tự động xóa image cũ để tránh đầy storage. |
| **RULE_CDK_10** | 🟠 High | CodeBuild project dùng `privilegedMode` chỉ khi cần Docker-in-Docker, không bật mặc định. |
| **RULE_CDK_11** | 🟡 Medium | Dùng CDK Aspects (cdk-aspects) để enforce tagging policy tự động trên mọi resources (Environment, Owner, Project). |
| **RULE_CDK_12** | 🟡 Medium | Separate stacks cho mỗi environment (dev, staging, prod) — không gộp chung vào một stack quá lớn. |
| **RULE_CDK_13** | 🟡 Medium | `cdk.json` phải có `context` entries cho giá trị dùng chung (VPC ID, AMI ID...) để tránh hardcode. |
| **RULE_CDK_14** | 🟡 Medium | CDK output (CloudFormation) phải được diff và review trước khi deploy — dùng `cdk diff` như part của CI/CD. |

---

## 2. 🚢 ECS (Elastic Container Service)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ECS_01** | 🔴 Critical | Task Definition: không dùng `latest` tag cho container image. Phải specify image digest hoặc tag cố định (git SHA). |
| **RULE_ECS_02** | 🔴 Critical | Task có `cpu` và `memory` được set explicit — không dùng giá trị mặc định. Đặt giá trị phù hợp với workload. |
| **RULE_ECS_03** | 🔴 Critical | Container không chạy với privileged mode trừ khi bắt buộc. Dùng `privileged: false` làm mặc định. |
| **RULE_ECS_04** | 🔴 Critical | Secrets (DB password, API keys) phải được inject qua AWS Secrets Manager hoặc SSM Parameter Store — không hardcode trong environment variables. |
| **RULE_ECS_05** | 🟠 High | Logging: Container phải config CloudWatch Logs với `awslogs` driver. Log group phải có retention policy. |
| **RULE_ECS_06** | 🟠 High | Health check: Dùng `HEALTHCHECK` instruction trong Dockerfile hoặc `healthCheck` config trong task definition. ALB phải configured để target healthy containers. |
| **RULE_ECS_07** | 🟠 High | Network mode phải là `awsvpc` để mỗi task có ENI riêng trong VPC subnet — dễ quản lý Security Group. |
| **RULE_ECS_08** | 🟠 High | Service Auto Scaling: có min/max/desired capacity hợp lý. CPU target tracking <= 70%, memory <= 80%. |
| **RULE_ECS_09** | 🟠 High | Deployment: dùng `rolling update` hoặc `blue/green` deployment với `minimumHealthyPercent` và `maximumPercent` hợp lý. |
| **RULE_ECS_10** | 🟡 Medium | IAM Task Role riêng cho mỗi task — không dùng Instance Role có quyền rộng. |
| **RULE_ECS_11** | 🟡 Medium | Dùng Placement Strategy (spread, binpack, random) phù hợp với use case. |
| **RULE_ECS_12** | 🟡 Medium | Container essential flag phải đặt đúng: task cần chạy container phải là essential, nếu fail thì task stop. |

---

## 3. ☁️ EC2 (Elastic Compute Cloud)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_EC2_01** | 🔴 Critical | Key Pair: không dùng shared key. Dùng SSM Session Manager hoặc EC2 Instance Connect thay vì SSH trực tiếp. |
| **RULE_EC2_02** | 🔴 Critical | Security Group: chỉ mở port cần thiết. Không mở SSH (22) từ `0.0.0.0/0`. Nếu cần SSH, giới hạn IP source cụ thể. |
| **RULE_EC2_03** | 🔴 Critical | IMDS v2 bắt buộc: `aws ec2 modify-instance-metadata-options --http-tokens required`. Tắt IMDS hoàn toàn nếu không cần. |
| **RULE_EC2_04** | 🔴 Critical | Không dùng public IP cho instance chạy application — dùng NAT Gateway hoặc Private Subnet. |
| **RULE_EC2_05** | 🟠 High | EBS volume phải be encrypted (`encrypted: true`, `kmsKeyId`). Không dùng unencrypted root volume. |
| **RULE_EC2_06** | 🟠 High | IAM Instance Profile: không attach role có quyền admin. Dùng inline policy với least privilege. |
| **RULE_EC2_07** | 🟠 High | Auto Scaling Group: có Launch Template/Launch Configuration versioned. User data script không chứa secrets. |
| **RULE_EC2_08** | 🟠 High | Detailed monitoring enabled (`monitoring: true`) để CloudWatch có metrics đầy đủ cho Auto Scaling. |
| **RULE_EC2_09** | 🟠 High | Patch Management: dùng AWS Systems Manager Patch Manager hoặc Auto Scaling scheduled actions để update định kỳ. |
| **RULE_EC2_10** | 🟡 Medium | Placement Group: dùng `spread` cho workload cần high availability, `cluster` cho performance. |
| **RULE_EC2_11** | 🟡 Medium | Instance type phù hợp workload — không over-provision (tốn chi phí) hoặc under-provision (throttle). |

---

## 4. 🛰️ ALB / NLB (Load Balancer)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_ALB_01** | 🔴 Critical | SSL/TLS: dùng ACM certificate. Enforce HTTPS (`ALBListenerAction: redirect-to-https`). Không dùng HTTP unencrypted cho production. |
| **RULE_ALB_02** | 🔴 Critical | Security Group: ALB SG chỉ mở port 80/443. Backend SG chỉ accept traffic từ ALB SG, không accept từ `0.0.0.0/0`. |
| **RULE_ALB_03** | 🔴 Critical | Health check: target group phải có healthy threshold, interval, path phù hợp. Không dùng `/` làm health check path cho API. |
| **RULE_ALB_04** | 🟠 High | Access logs: enabled vào S3 bucket riêng với prefix phân biệt environment. Không dùng default bucket. |
| **RULE_ALB_05** | 🟠 High | Desync mitigation mode: dùng `defense` mode để protect khỏi HTTP Desync Attack. |
| **RULE_ALB_06** | 🟠 High | Connection draining (deregistration delay): set 30-60s để graceful shutdown, không drop in-flight requests. |
| **RULE_ALB_07** | 🟠 High | Idle timeout: default 60s phù hợp cho most cases. Tăng nếu có long-polling hoặc streaming. |
| **RULE_ALB_08** | 🟡 Medium | Cross-zone load balancing: enabled để distribute traffic đều giữa AZs. |
| **RULE_ALB_09** | 🟡 Medium | WAF Web ACL attached với rules phù hợp (rate limit, geo-block, SQL injection, XSS). |
| **RULE_ALB_10** | 🟡 Medium | ALB nên có scheme `internal` cho private API, `internet-facing` chỉ cho public-facing endpoints. |

---

## 5. ⚡ Lambda

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_LAMBDA_01** | 🔴 Critical | Execution role: không dùng role có quyền admin (`*`). Dùng inline policy với nguyên tắc least privilege cho từng function. |
| **RULE_LAMBDA_02** | 🔴 Critical | Secrets: không hardcode trong environment variables. Dùng AWS Secrets Manager hoặc SSM Parameter Store. |
| **RULE_LAMBDA_03** | 🔴 Critical | VPC: nếu function truy cập VPC resources (RDS, ElastiCache), phải đặt timeout đủ và Memory đủ để tránh connection timeout. |
| **RULE_LAMBDA_04** | 🟠 High | Ephemeral storage: set `EphemeralStorage.Size` phù hợp (default 512MB, max 10240MB) nếu xử lý large files. |
| **RULE_LAMBDA_05** | 🟠 High | Error handling: function phải handle exceptions, dùng dead-letter queue (DLQ) cho async invocations. |
| **RULE_LAMBDA_06** | 🟠 High | Concurrency: set reserved concurrency để prevent throttle và đảm bảo resource cho critical functions. |
| **RULE_LAMBDA_07** | 🟠 High | Cold start: nếu dùng VPC, dùng Lambda SnapStart (Java) hoặc Provisioned Concurrency cho latency-sensitive applications. |
| **RULE_LAMBDA_08** | 🟠 High | Structured logging: log phải có format JSON với `requestId`, `awsRequestId`, `level`, `message`. Không dùng `console.log` thuần túy. |
| **RULE_LAMBDA_09** | 🟠 High | X-Ray active tracing: enabled để debug latency và trace requests qua nhiều services. |
| **RULE_LAMBDA_10** | 🟡 Medium | Package size: bundle nhỏ nhất có thể. Không include thư viện không cần thiết. Dùng Lambda layer cho shared dependencies. |
| **RULE_LAMBDA_11** | 🟡 Medium | Environment variables: dùng `VariableType` và `kmsKeyArn` để encrypt sensitive variables. |

---

## 6. 🌍 Route 53

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_R53_01** | 🔴 Critical | DNSSEC signing: enabled cho domain để prevent DNS spoofing. Kiểm tra `KeySigningKey` status định kỳ. |
| **RULE_R53_02** | 🔴 Critical | Health checks: tất cả record quan trọng (failover, weighted) phải có health check gắn vào. |
| **RULE_R53_03** | 🔴 Critical | Alias record: dùng cho ALB/CloudFront/NLB/VPC endpoint thay vì CNAME để giảm latency và chi phí. |
| **RULE_R53_04** | 🟠 High | TTL: set TTL hợp lý. Low TTL (< 60s) cho failover records, higher TTL (300-3600s) cho static records để giảm query cost. |
| **RULE_R53_05** | 🟠 High | Routing policy: dùng `multivalue-answer` thay vì simple record nếu cần basic health check-based failover. |
| **RULE_R53_06** | 🟠 High | Private hosted zone: associate với đúng VPCs. Không dùng public zone cho internal traffic. |
| **RULE_R53_07** | 🟡 Medium | Latency-based routing: dùng khi có multi-region deployment và cần route đến region có latency thấp nhất. |
| **RULE_R53_08** | 🟡 Medium | Traffic flow / Route 53 ARC: dùng cho complex routing với failover, geolocation, weighted policies. |

---

## 7. 🔔 EventBridge

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_EB_01** | 🔴 Critical | Event bus policy: không dùng `Effect: Allow` với `Principal: "*"` cho cross-account. Phải specify exact account IDs hoặc organization ARNs. |
| **RULE_EB_02** | 🔴 Critical | Dead-letter queue (DLQ): mọi rule với target nên có DLQ để capture failed events. |
| **RULE_EB_03** | 🔴 Critical | Event payload: không chứa sensitive data (password, PII) trực tiếp. Dùng S3 presigned URL hoặc Secrets Manager reference. |
| **RULE_EB_04** | 🟠 High | Input transformer: dùng để transform event payload trước khi gửi đến target, không rely vào raw event format. |
| **RULE_EB_05** | 🟠 High | Schema registry: enabled để validate event structure. Dùng generated bindings cho TypeScript/Java. |
| **RULE_EB_06** | 🟠 High | Rule state: disable rule khi không cần để tránh unexpected invocations và cost. |
| **RULE_EB_07** | 🟡 Medium | Content-based filtering: dùng thay vì pattern matching phức tạp để giảm false positives. |
| **RULE_EB_08** | 🟡 Medium | Archive and replay: enabled archive cho critical event buses để có thể replay khi cần. Set retention phù hợp. |

---

## 8. 🔄 Step Functions

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_SF_01** | 🔴 Critical | IAM role: Workflow state machine role không dùng `*` resource. Specify exact ARNs cho từng Lambda/DynamoDB/SQS/SNS action. |
| **RULE_SF_02** | 🔴 Critical | Sensitive data: không pass credentials, passwords trong state input/output. Dùng Secrets Manager reference. |
| **RULE_SF_03** | 🔴 Critical | Error handling: mọi Task state phải có `Catch` và `Retry` configuration. Không để error propagate không kiểm soát. |
| **RULE_SF_04** | 🟠 High | Timeout: đặt `TimeoutSeconds` và `HeartbeatSeconds` cho mỗi Task để detect hanging executions. |
| **RULE_SF_05** | 🟠 High | Long-running workflows: dùng `Wait` state với timeout hoặc Express Workflow cho các bước ngắn thay vì Standard. |
| **RULE_SF_06** | 🟠 High | Activity workers: nếu dùng Activity, workers phải implement heartbeat và handle shutdown graceful. |
| **RULE_SF_07** | 🟠 High | CloudWatch metrics: enabled logging với `level: ERROR` hoặc `level: ALL` cho production. Không dùng `OFF` cho production. |
| **RULE_SF_08** | 🟡 Medium | Parallel state: dùng để process independent tasks concurrency. Set `MaxConcurrency` để tránh throttle downstream services. |
| **RULE_SF_09** | 🟡 Medium | Map state: set `Iterator` với `MaxConcurrency` để control parallel execution. |
| **RULE_SF_10** | 🟡 Medium | X-Ray tracing: enabled để debug execution flow và identify bottlenecks. |

---

## 9. 💾 Aurora (PostgreSQL / MySQL)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_AURORA_01** | 🔴 Critical | Không public accessible (`PubliclyAccessible: false`). Aurora phải nằm trong Private Subnet. |
| **RULE_AURORA_02** | 🔴 Critical | DB Cluster phải có `StorageEncrypted: true` với KMS key. Không dùng default encryption. |
| **RULE_AURORA_03** | 🔴 Critical | Master password phải được lưu trong AWS Secrets Manager, không hardcode trong CDK code. |
| **RULE_AURORA_04** | 🔴 Critical | IAM Authentication phải enabled (`IAMAuthenabled: true`) cho application access thay vì password-based auth. |
| **RULE_AURORA_05** | 🟠 High | `BackupRetentionPeriod` >= 7 ngày cho production. `PreferredBackupWindow` và `PreferredMaintenanceWindow` phải set. |
| **RULE_AURORA_06** | 🟠 High | Multi-AZ: `EngineMode: provisioned` với writer/reader endpoints. Replicas >= 2 cho high availability. |
| **RULE_AURORA_07** | 🟠 High | Performance Insights enabled để monitor query performance. Dùng Enhanced Monitoring cho OS-level metrics. |
| **RULE_AURORA_08** | 🟠 High | Parameter Group: set `log_connections = 1`, `log_disconnections = 1`, `log_lock_waits = 1` để audit. |
| **RULE_AURORA_09** | 🟠 High | Database name và username không đặt mặc định (`postgres`, `root`, `admin`). |
| **RULE_AURORA_10** | 🟡 Medium | `AutoMinorVersionUpgrade: true` để Aurora tự upgrade minor version. Major version upgrade phải review thủ công. |
| **RULE_AURORA_11** | 🟡 Medium | Dùng Reader Endpoint cho read-only queries, Writer Endpoint cho write operations. |
| **RULE_AURORA_12** | 🟡 Medium | Serverless v2: nếu dùng Aurora Serverless, set `MinCapacity` và `MaxCapacity` phù hợp để tránh surprise cost. |

---

## 10. 💎 ElastiCache (Redis / Memcached)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CACHE_01** | 🔴 Critical | Không public accessible. Cluster phải nằm trong Private Subnet, chỉ accessible từ application tier. |
| **RULE_CACHE_02** | 🔴 Critical | Encryption at rest: `AtRestEncryptionEnabled: true`. Encryption in transit: `TransitEncryptionEnabled: true` với `AuthTokenEnabled: true`. |
| **RULE_CACHE_03** | 🔴 Critical | Không disable `AUTH`/`TLS`. Redis phải require password. Memcached phải dùng SASL auth nếu supported. |
| **RULE_CACHE_04** | 🟠 High | Redis Cluster Mode: dùng Cluster Mode Enabled với replicas >= 2 để high availability và horizontal scaling. |
| **RULE_CACHE_05** | 🟠 High | `ParameterGroup`: set `maxmemory-policy` phù hợp (ví dụ: `allkeys-lru` cho cache thông thường). |
| **RULE_CACHE_06** | 🟠 High | Connection timeout và retries configured trong application: `timeout: 5s`, `retryAttempts: 3`. |
| **RULE_CACHE_07** | 🟠 High | CloudWatch metrics: `CacheMisses`, `CacheHits`, `CurrConnections`, `Evictions`, `ReplicationLag` phải được monitor. |
| **RULE_CACHE_08** | 🟡 Medium | ElastiCache Event Subscription: notify khi node replaced, failover, maintenance. |
| **RULE_CACHE_09** | 🟡 Medium | Test failover scenario: verify application tự recover khi primary node failover. |

---

## 11. 🌐 CloudFront

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CF_01** | 🔴 Critical | SSL/TLS: dùng ACM certificate cho custom domain. Enforce HTTPS redirect (`viewerProtocolPolicy: redirect-to-https`). |
| **RULE_CF_02** | 🔴 Critical | WAF Web ACL attached: enable AWSManagedRulesCommonRuleSet, AWSManagedRulesKnownBadInputsRuleSet. |
| **RULE_CF_03** | 🔴 Critical | Origin Shield enabled cho multi-region origin protection và giảm origin load. |
| **RULE_CF_04** | 🟠 High | Cache Policy: set `MinTTL`, `MaxTTL`, `DefaultTTL` phù hợp. Dùng `cached-query-strings` cho query-dependent responses. |
| **RULE_CF_05** | 🟠 High | Origin Response Timeout: set >= 30s cho API origins, phù hợp với backend response time expectation. |
| **RULE_CF_06** | 🟠 High | Compress objects: `enableCompress: true` để tự động gzip/brotli compress text-based content. |
| **RULE_CF_07** | 🟠 High | Price class phù hợp: `PriceClass_100` (NA/EU), `PriceClass_200` (+Asia, LatAm), `PriceClass_All` (all regions). Không dùng `All` nếu không cần. |
| **RULE_CF_08** | 🟠 High | Default root object (`index.html`) configured cho web distribution. |
| **RULE_CF_09** | 🟡 Medium | Field-level encryption cho sensitive data (PII, payment info). |
| **RULE_CF_10** | 🟡 Medium | Function@Edge hoặc Lambda@Edge cho request/response manipulation — không dùng CloudFront Functions cho logic phức tạp. |
| **RULE_CF_11** | 🟡 Medium | Access logs (Real-time log config hoặc standard logs) enabled vào S3 bucket riêng. |

---

## 12. ☁️ VPC (Virtual Private Cloud)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_VPC_01** | 🔴 Critical | VPC CIDR: đặt CIDR block phù hợp (recommend `/16` hoặc `/18`) — không dùng default VPC CIDR trong production. |
| **RULE_VPC_02** | 🔴 Critical | Subnet design: tách Public/Private/Isolated subnet theo AZ (mỗi AZ tối thiểu 1 public + 1 private). Không gộp chung mọi thứ vào một subnet. |
| **RULE_VPC_03** | 🔴 Critical | NAT Gateway: đặt trong Public Subnet, Private Subnet dùng NAT Gateway để outbound traffic. Không để instance trong Public Subnet trừ khi bắt buộc. |
| **RULE_VPC_04** | 🔴 Critical | VPC Endpoints (Interface/Gateway): dùng S3 Gateway Endpoint và Interface Endpoint cho AWS services nội bộ (SSM, Secrets Manager, ECR) — tránh NAT Gateway cho internal traffic. |
| **RULE_VPC_05** | 🟠 High | Security Group: quy tắc inbound restrictive nhất, outbound open. Không mở `0.0.0.0/0` trừ khi cần ALB/NAT. |
| **RULE_VPC_06** | 🟠 High | Network ACL (NACL): stateless, dùng cho layer bổ sung. Default NACL allow all, custom NACL deny specific ranges. |
| **RULE_VPC_07** | 🟠 High | VPC Flow Logs: enabled ở VPC level, gửi CloudWatch Logs hoặc S3. Dùng để audit traffic và security analysis. |
| **RULE_VPC_08** | 🟠 High | DNS: `enableDnsHostnames: true`, `enableDnsSupport: true` — required cho private hosted zone và load balancer. |
| **RULE_VPC_09** | 🟠 High | DHCP Options Set: cấu hình custom DNS, NTP, NetBIOS. Không dùng default DHCP options. |
| **RULE_VPC_10** | 🟡 Medium | Transit Gateway: dùng cho multi-VPC/multi-account peering thay vì VPC Peering (dễ quản lý hơn). |
| **RULE_VPC_11** | 🟡 Medium | PrivateLink / VPC Endpoint Services: dùng cho service-to-service communication thay vì Security Group cross-account. |
| **RULE_VPC_12** | 🟡 Medium | IPAM (IP Address Manager): dùng để quản lý và allocate CIDR blocks cho multi-VPC environment. |

---

## 13. 🪝 CloudFormation

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_CFN_01** | 🔴 Critical | Stack Name: đặt tên có prefix environment (ví dụ: `app-prod`, `app-staging`) — không dùng chung stack name cho multi-environment. |
| **RULE_CFN_02** | 🔴 Critical | `TerminationProtection: true` cho production stacks. Ngăn chặn xóa nhầm từ CloudFormation console/API. |
| **RULE_CFN_03** | 🔴 Critical | Stack Policy: explicit deny cho production resources (RDS, Aurora, IAM). Chỉ allow update qua bạc cụ thể. |
| **RULE_CFN_04** | 🟠 High | Outputs: không export secrets, passwords, connection strings. Output chỉ contain resource ARN hoặc non-sensitive info. |
| **RULE_CFN_05** | 🟠 High | Nested Stacks: dùng for reusable components (VPC, IAM roles). Parent stack reference child stacks qua cross-stack references. |
| **RULE_CFN_06** | 🟠 High | Drift Detection: thường xuyên chạy `aws cloudformation detect-drift` để phát hiện infrastructure drift. |
| **RULE_CFN_07** | 🟠 High | Rollback on failure: `RollbackConfiguration` với `MonitoringTimeInMinutes` và SNS alarm. |
| **RULE_CFN_08** | 🟡 Medium | Resource deletion policy: set `DeletionPolicy: Retain` cho resources quan trọng (RDS, S3 buckets) cần preserve data. |
| **RULE_CFN_09** | 🟡 Medium | Stack Set: dùng for multi-account/multi-region deployments với `AutoDeployment: Enabled`. |
| **RULE_CFN_10** | 🟡 Medium | Change Sets: luôn review change set trước khi execute stack update — không execute trực tiếp. |

---

## 14. 👤 IAM Role & Policy

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_IAM_01** | 🔴 Critical | Policy không dùng `Resource: "*"` trừ khi bắt buộc (ví dụ: STS GetCallerIdentity). Luôn specify ARN cụ thể. |
| **RULE_IAM_02** | 🔴 Critical | Không attach Managed Policy quá rộng (`AdministratorAccess`, `PowerUserAccess`) — dùng inline policy với permissions tối thiểu. |
| **RULE_IAM_03** | 🔴 Critical | IAM Role trust policy: `aws:PrincipalOrgID` hoặc `aws:PrincipalAccount` phải limit đúng account/organization. |
| **RULE_IAM_04** | 🔴 Critical | Service-linked role (SLR) cho services cần (RDS, ElastiCache, ECS...): dùng `aws:ServiceName` trust entity, không dùng generic role. |
| **RULE_IAM_05** | 🟠 High | IAM Policy Conditions: dùng `aws:RequestedRegion`, `aws:SourceVpce`, `aws:SourceAccount` để limit scope. |
| **RULE_IAM_06** | 🟠 High | Permission Boundary: attach permission boundary cho IAM users/roles để prevent privilege escalation. |
| **RULE_IAM_07** | 🟠 High | Access Analyzer: bật IAM Access Analyzer cho organization để detect external access. |
| **RULE_IAM_08** | 🟠 High | Session duration: role assumed trong CLI nên có `DurationSeconds` <= 3600 (1h) cho production. |
| **RULE_IAM_09** | 🟡 Medium | MFA: IAM users phải enable MFA. Không dùng access key cho long-term access khi có SSO. |
| **RULE_IAM_10** | 🟡 Medium | Policy variables: dùng `${aws:username}`, `${sso:AWSAccountId}` thay vì hardcode. |
| **RULE_IAM_11** | 🟡 Medium | Password policy: enforce uppercase, lowercase, number, symbol, min length 14, rotation 90 days. |

---

## 15. 🔒 Security & IAM (General)

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_SEC_01** | 🔴 Critical | Không commit `.env`, `*.pem`, `*.key`, `credentials`, `secrets.yml` vào git. Dùng `.gitignore` và `git-secrets` / Gitleaks để scan. |
| **RULE_SEC_02** | 🔴 Critical | AWS Access Key/Secret phải được quản lý qua IAM Roles, không dùng long-term credentials. Dùng SSO hoặc Workload Identity Federation cho CI/CD. |
| **RULE_SEC_03** | 🔴 Critical | Pipeline (CodePipeline/CodeBuild) phải dùng dedicated service role với nguyên tắc least privilege — không dùng role có quyền admin. |
| **RULE_SEC_04** | 🟠 High | Docker image scan (Trivy/Grype) phải chạy trong CI pipeline trước khi push lên ECR. Fail pipeline nếu có CVE Critical/High. |
| **RULE_SEC_05** | 🟠 High | CDK bootstrap phải chỉ định `trustedAccounts` rõ ràng để tránh cross-account deployment không được authorize. |
| **RULE_SEC_06** | 🟠 High | VPC: dùng Private Subnet cho application, Public Subnet chỉ cho ALB/NAT Gateway. Không đặt application trong Public Subnet. |
| **RULE_SEC_07** | 🟠 High | Encrypt at rest: S3 (`SSE-KMS`), RDS/Aurora (`storageEncrypted: true`), Lambda environment variables (dùng KMS key). |
| **RULE_SEC_08** | 🟡 Medium | Rate limiting / throttling trên API Gateway / ALB để chống DDoS và abuse. |
| **RULE_SEC_09** | 🟡 Medium | WAF Web ACL attached vào ALB/API Gateway/CloudFront với rules cơ bản (AWSManagedRulesKnownBadInputsRuleSet). |

---

## 16. 📈 Observability & Cost

| Rule ID | Priority | Tiêu chí đánh giá |
| :------ | :------- | :----------------- |
| **RULE_MON_01** | 🟠 High | CloudWatch Dashboard cho mỗi environment: hiển thị CPU, memory, request count, error rate, latency. |
| **RULE_MON_02** | 🟠 High | Cost Explorer / Budget alert: setup alert khi chi phí vượt ngưỡng (ví dụ: 110% của budget). |
| **RULE_MON_03** | 🟡 Medium | Structured logging: application log phải có format JSON với fields: `timestamp`, `level`, `message`, `requestId`, `userId`. |
| **RULE_MON_04** | 🟡 Medium | X-ray tracing enabled cho Lambda và ECS để debug latency issues. |
| **RULE_MON_05** | 🟡 Medium | Resource tagging nhất quán: mọi resource phải có tag `Environment`, `Project`, `CostCenter`, `Owner`. |
