# Backend Migration — DynamoDB Locking → S3 Native Locking

## Why

Your standing convention is S3-native locking (`use_lockfile = true`,
Terraform 1.10+) instead of a DynamoDB lock table. The backend block in
`versions.tf` has been updated to drop `dynamodb_table` and add
`use_lockfile = true`. This is a **backend configuration change** and
requires a one-time re-init against the state that already exists in S3.

## Steps (run locally, with your usual AWS credentials — not from CI)

```bash
cd environments/prod

# 1. Confirm current state is clean before touching backend config
terraform plan -var-file=terraform.tfvars

# 2. Re-initialize against the updated backend block.
#    Terraform detects the backend config changed and offers to migrate.
terraform init -migrate-state

# 3. Verify state is intact and nothing is proposed to change
terraform plan -var-file=terraform.tfvars
```

Terraform will prompt something like:

```
Backend configuration changed!
...
Do you want to migrate all workspace states?
```

Answer `yes`. This only rewrites the *locking* mechanism used by the S3
backend itself — it does not touch any of your actual AWS resources or
existing state content.

## After migrating

- The DynamoDB lock table created by `modules/backend`
  (`sandtongrid-tech-terraform-locks`) is no longer used for locking.
  Keep it in place for a few cycles as a rollback safety net, then remove
  it from `modules/backend/main.tf` and run another `plan`/`apply` once
  you're confident the S3-native lock (`.tflock` object next to the
  state file) is working reliably in CI.
- No changes are needed in GitHub Actions — `terraform init` in the
  pipeline will pick up the new backend block automatically on the next
  run, since the backend block itself isn't parameterized per-environment.
