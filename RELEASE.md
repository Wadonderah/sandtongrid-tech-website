# Environments & Release Workflow

## Environments

| Environment | Directory                | Branch    | Domain                        | GitHub Environment |
|-------------|---------------------------|-----------|--------------------------------|---------------------|
| Development | `environments/dev`        | `develop` | dev.sandtongridtech.com        | `development`       |
| Staging     | `environments/staging`    | `staging` | staging.sandtongridtech.com    | `staging`            |
| Production  | `environments/prod`       | `main`    | www.sandtongridtech.com        | `production`         |

All three share the same `modules/` — nothing in `modules/` is
environment-specific. Each environment directory is a thin composition
that calls the same modules with different `terraform.tfvars`, and
writes state to the same S3 backend bucket under a different key
(`dev/terraform.tfstate`, `staging/terraform.tfstate`,
`prod/terraform.tfstate`), so they never collide or lock each other out.

## Important: deploy order

`environments/prod` must be applied **at least once** before
`environments/dev` or `environments/staging` — the GitHub OIDC
provider is an AWS-account-wide singleton (one per account, not per
environment). `prod` creates it; `dev`/`staging` just look it up via
`create_oidc_provider = false`. Applying dev/staging before prod
exists will fail with "no matching OpenIDConnectProvider found".

## One-time setup required (GitHub UI)

Create three **Environments** under repo Settings → Environments:

- `development` — no required reviewers (deploys automatically on push to `develop`)
- `staging` — optionally add required reviewers if you want a gate before staging
- `production` — **add required reviewers**. This is the actual manual-approval gate; the workflow will pause here until approved, regardless of anything in the YAML.

Each Environment needs its own `AWS_ROLE_ARN` and `AWS_REGION` secrets
(scoped to that Environment, not repo-wide), pointing at the same
GitHub OIDC role created by `module.github_oidc` in that environment's
own state — i.e. `development`'s secrets point at the role from
`environments/dev`'s apply output, and so on.

## Release flow

```
feature branch → PR into develop  → auto-deploys to dev on merge
develop → PR into staging         → auto-deploys to staging on merge (or gated, your choice)
staging → PR into main             → deploys to prod, paused for manual approval
```

Each environment's workflow (`deploy-dev.yml`, `deploy-staging.yml`,
`terraform.yml`) is a thin wrapper around
`.github/workflows/reusable-terraform-deploy.yml` — the actual
validate/plan/apply logic lives in one place. To add a fourth
environment later, copy an `environments/<env>` directory and add one
more ~15-line caller workflow; no changes needed in the reusable
workflow or in `modules/`.

## Automated tests (Terratest)

`tests/` is a Go module using Terratest, run automatically by
`.github/workflows/terratest.yml` on every PR — nobody needs to run
`go test` by hand.

Two tiers:

- **`TestTerraformValidateEnvironments`** — `terraform init -backend=false` + `terraform validate` against all three environments. No AWS credentials needed at all, so it runs unconditionally on every PR (even from a fork). This is the tier that catches the class of bug this project has actually had — missing outputs, undeclared resource references, mismatched module inputs.
- **`TestTerraformPlanEnvironments`** — a real (read-only) `terraform plan` against AWS, asserting the plan includes the core resources (S3 bucket, CloudFront distribution, Route53 record) for each environment. Needs credentials, gated behind the `production` GitHub Environment, skips itself automatically if no credentials are present.

Neither tier applies or destroys anything — both are safe to run on
every single PR with no cost and no risk to real infrastructure.

To run locally:

```bash
cd tests
go mod tidy
go test -v ./...                                    # validate only, no AWS needed
AWS_ROLE_ARN=... go test -v -run TestTerraformPlanEnvironments ./...   # full plan, needs creds
```

If you later want deeper integration coverage (actual `apply` +
`destroy` against a disposable test stack) that's a natural next step,
but deliberately out of scope here — it costs real money and time on
every run, so it belongs on a schedule (e.g. nightly) rather than
every PR, and needs its own throwaway AWS resources rather than
touching dev/staging/prod.

## First deploy of dev/staging

`environments/dev` and `environments/staging` are new — nothing has
been applied for them yet. Before merging to `develop`/`staging` for
the first time, run locally once to confirm the plan looks right:

```bash
cd environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
```

Same for `environments/staging`. `environments/prod` already has
existing state — see `environments/prod/BACKEND_MIGRATION.md` for the
locking migration step that's still pending there.
