# Sandtongrid Technologies — Website Infrastructure

This repo runs the Sandtongrid Technologies marketing site end to end: the Terraform that provisions everything on AWS, the static site itself, and the GitHub Actions pipeline that ships changes to production. If you're looking at this because you're picking up the project, welcome — hopefully this saves you a few hours of reading code to figure out how the pieces fit together.

## What's actually running

The site is fully static — no servers to patch, no containers to babysit. Here's the request path:


Visitor
  │
  ▼
Route 53  (DNS)
  │
  ▼
CloudFront  (CDN, HTTPS via ACM cert, WAFv2 attached)
  │
  ▼
S3 bucket  (private — only reachable through CloudFront's Origin Access Control)


A few things worth knowing about that setup before you go digging through the modules:

- **The S3 bucket is not public, and can't serve traffic directly.** CloudFront reaches it through an Origin Access Control (OAC), and the bucket policy only trusts requests that come from *this specific distribution*. There's no S3 static website hosting endpoint in play here — deliberately, since that would mean the bucket has to be public.
- **The bucket is encrypted with a customer-managed KMS key**, not the default SSE-S3. CloudFront needs an explicit grant on that key to decrypt objects when it serves them — this tripped me up once already, so if you're ever debugging a mysterious 403 from CloudFront on an otherwise-correct setup, check the KMS key policy first.
- **The ACM certificate and the WAF Web ACL both live in `us-east-1`**, regardless of which region the rest of the stack is in (`eu-west-1`). This isn't optional — CloudFront requires certificates in `us-east-1`, and a CLOUDFRONT-scoped WAFv2 ACL has to be created there too. The Terraform handles this with a second `aws` provider alias (`aws.virginia`), so you don't need to do anything manually, but it's worth understanding why that alias exists before you go changing provider blocks.

## Repo layout


modules/                   # Reusable building blocks — no environment-specific values live here
  s3/                       # The private origin bucket + KMS key
  acm/                      # Certificate request + DNS validation (us-east-1)
  cloudfront/                # Distribution, OAC, WAF, bucket policy, KMS grant for CloudFront
  route53/                  # The DNS record pointing at the distribution
  website_deployment/        # Uploads website/ to S3 with correct content-types and cache headers
  backend/                   # The S3 bucket + DynamoDB table Terraform's own state lives in
  github_oidc/                # Lets GitHub Actions authenticate to AWS without long-lived keys
  github_oidc_policy/          # The least-privilege IAM policies attached to that OIDC role
  logging/                   # S3 bucket that receives CloudFront access logs
  monitoring/                # CloudWatch alarms + SNS topic for error-rate and WAF alerts

environments/
  prod/                      # www.sandtongridtech.com
  staging/                    # staging.sandtongridtech.com
  dev/                        # dev.sandtongridtech.com

website/                    # The actual site — plain HTML/CSS/JS, no build step
tests/                      # Terratest suite (Go) — validates every environment automatically in CI
.github/workflows/           # The whole CI/CD pipeline


Every environment directory is a thin wrapper that calls the same modules with different variables. If you're adding a feature to the infrastructure, you're almost always editing something in `modules/` and letting all three environments pick it up — not copy-pasting changes into each environment separately.

## Before you touch anything: how the environments actually relate

This isn't three independent copies of the same stack. A couple of things are genuinely shared across all three:

- **One S3 bucket and one DynamoDB table hold all three environments' Terraform state**, just under different keys (`prod/terraform.tfstate`, `dev/terraform.tfstate`, `staging/terraform.tfstate`). Only `environments/prod` actually creates that bucket and table — `dev` and `staging` just point at it.
- **The GitHub OIDC provider is an AWS-account-wide singleton.** You can only have one `token.actions.githubusercontent.com` provider per account. `prod` creates it; `dev` and `staging` look it up instead of creating their own (there's a `create_oidc_provider` flag on the module that controls this).

The practical consequence: **`environments/prod` has to be applied at least once before `dev` or `staging` will work.** If you try to bootstrap a fresh AWS account starting from `dev`, it'll fail looking for a state bucket and an OIDC provider that don't exist yet.

## Getting started locally

You'll need:

- Terraform >= 1.13.0
- An AWS account with credentials configured (`aws configure`, or an SSO profile — whatever you normally use)
- Go 1.22+ if you want to run the test suite locally

First time setting this up in a brand new AWS account:


cd environments/prod
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars


That single apply bootstraps the shared state backend, the OIDC provider, and the entire prod stack in one pass — Terraform figures out the dependency order for you. After that, `dev` and `staging` are just:


cd environments/dev      # or staging
terraform init
terraform plan -var-file=terraform.tfvars


If everything in the plan looks right, `terraform apply`.

One more thing on state locking: this project uses S3's native locking (`use_lockfile = true`, needs Terraform 1.10+) rather than a DynamoDB lock table. If you're used to the DynamoDB pattern, you won't find a `dynamodb_table` line in the backend config — that's intentional, not a mistake.

## Shipping changes through CI/CD

Nobody should be running `terraform apply` from their laptop against `prod` — that's what the pipeline is for. The flow:


feature branch → PR into develop   → auto-deploys to dev on merge
develop → PR into staging          → deploys to staging on merge
staging → PR into main             → deploys to prod, held for manual approval


Every environment's deploy workflow is a thin wrapper around one shared workflow (`.github/workflows/reusable-terraform-deploy.yml`) — validate, plan, then apply. The actual safety gate on production isn't in the YAML, it's a **required reviewers** rule on the `production` GitHub Environment, so someone has to click approve before anything touches prod, no matter what the workflow logic says.

There's a fair bit else running on every PR: `terraform fmt`/`validate`, TFLint, Checkov and Trivy for security misconfigurations, CodeQL on the site's JavaScript, and the Terratest suite (which does a real `terraform plan` against AWS to catch anything the static checks can't). Infracost comments estimated cost changes on infrastructure PRs. Dependabot keeps provider versions and Action versions current on its own schedule. A drift-detection workflow runs nightly against prod and opens a GitHub issue if reality has quietly diverged from what's in state.

Full setup details — which GitHub Environments to create, what secrets each one needs — are in `RELEASE.md`.

## Monitoring and logs — where to actually look

**CloudWatch alarms and the SNS alert topic live in `us-east-1`**, not `eu-west-1`, for the same reason the WAF and ACM cert do — that's where CloudFront and CLOUDFRONT-scoped WAF publish their metrics. If you go looking for the alarms in the "main" region and can't find them, that's why.

After the first apply, check your email — SNS sends a subscription confirmation, and alerts silently go nowhere until someone clicks confirm. There's no error or warning if you skip this step; the alarms just fire into the void.

CloudFront access logs land in a separate S3 bucket per environment (look for `{project}-{env}-cf-logs-` in S3, it has a random suffix to keep the name globally unique) and expire automatically after 90 days. They're just raw gzipped log files sitting in S3 right now — nothing queries them automatically. If you need to actually search them, pointing Athena at that bucket is the standard next step; it isn't set up yet.

## Testing


cd tests
go mod tidy
go test -v ./...


That runs `TestTerraformValidateEnvironments` — a `terraform validate` against all three environments that needs zero AWS credentials, so it works even for someone who's never touched the AWS account. It's what actually runs on every PR automatically.

If you have AWS credentials handy and want the deeper check (a real, read-only `terraform plan` against each environment):


AWS_ROLE_ARN=<role-arn> go test -v -run TestTerraformPlanEnvironments ./...


What's *not* covered yet: an actual `apply`/`destroy` integration test cycle. That's deliberately left out for now — it costs real money and time on every run, and it needs its own disposable AWS resources rather than touching dev/staging/prod. Worth adding if this project keeps growing.

## Conventions this repo sticks to

If you're adding to this project, a few things are consistent on purpose — please keep them that way:

- **Nothing is hardcoded.** Every resource name, region, and identifier comes from a variable, a local, or a data source. If you find yourself typing a literal AWS account ID or bucket name into a `.tf` file, stop — there's almost certainly a `local.` or `var.` that should be there instead.
- **`for_each` over `count`**, everywhere it's a real choice between the two.
- **Every module gets its own `versions.tf`** with pinned provider versions, even if it only uses `aws`.
- **Tags are consistent** across every resource: `Environment`, `ManagedBy`, `Owner`, `CostCenter` at minimum.
- **`terraform fmt` matters here** — it's a required check in CI, and a misaligned `=` sign will fail the pipeline just as surely as a real bug will.

## If something's on fire

- **CloudFront serving a 403 for everything** → almost always the KMS key policy, not the S3 bucket policy. Check that CloudFront's grant on the origin bucket's KMS key is actually there.
- **A new environment fails to apply with "already exists" on the OIDC provider or the state bucket** → you're trying to create something that's meant to be a singleton. Check `create_oidc_provider` and make sure you're not accidentally including `module "backend"` outside of `prod`.
- **`terraform fmt -check` failing in CI on a file you didn't think you touched** → CI checks formatting across the whole repo, not just your environment. Run `terraform fmt -recursive` from the repo root before you push.
- **An alarm never fires even though you can see errors happening** → check you're looking in `us-east-1`, and check the SNS subscription was actually confirmed.

## License

See `LICENSE`.
