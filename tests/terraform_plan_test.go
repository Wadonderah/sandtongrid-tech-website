// Package test contains automated Terraform checks for
// sandtongrid-tech-website. These run in CI on every pull request via
// .github/workflows/terratest.yml — nobody needs to run `go test`
// manually.
//
// Two tiers, by design:
//
//  1. TestTerraformValidateEnvironments — `terraform validate` only.
//     No AWS credentials needed, catches syntax/reference errors
//     (the exact class of bug this project has had — missing outputs,
//     undeclared resources, mismatched module inputs). Runs on every
//     PR unconditionally.
//
//  2. TestTerraformPlanEnvironments — full `terraform plan` against
//     real AWS (read-only — plan never mutates anything). Needs
//     credentials, so it's skipped automatically if none are present,
//     letting this suite still run for contributors/forks that don't
//     have AWS access.
package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type environment struct {
	name         string
	terraformDir string
	varFile      string
}

var environments = []environment{
	{name: "dev", terraformDir: "../environments/dev", varFile: "terraform.tfvars"},
	{name: "staging", terraformDir: "../environments/staging", varFile: "terraform.tfvars"},
	{name: "prod", terraformDir: "../environments/prod", varFile: "terraform.tfvars"},
}

// coreResources are the resources every environment must plan to
// create/manage, regardless of which environment it is.
var coreResources = []string{
	"module.s3.aws_s3_bucket.website_bucket",
	"module.cloudfront.aws_cloudfront_distribution.website_distribution",
	"module.route53.aws_route53_record.website_alias_record",
}

func TestTerraformValidateEnvironments(t *testing.T) {
	t.Parallel()

	for _, env := range environments {
		env := env

		t.Run(env.name, func(t *testing.T) {
			t.Parallel()

			opts := &terraform.Options{
				TerraformDir: env.terraformDir,
				NoColor:      true,
			}

			// -backend=false: only download providers/modules and
			// check syntax/references — never touches the real S3
			// backend, so this needs zero AWS credentials.
			terraform.RunTerraformCommand(t, opts, "init", "-backend=false", "-input=false")
			terraform.Validate(t, opts)
		})
	}
}

func TestTerraformPlanEnvironments(t *testing.T) {
	if os.Getenv("AWS_ROLE_ARN") == "" && os.Getenv("AWS_ACCESS_KEY_ID") == "" {
		t.Skip("No AWS credentials in this environment — skipping live plan tests. " +
			"TestTerraformValidateEnvironments above still ran and doesn't need credentials.")
	}

	t.Parallel()

	for _, env := range environments {
		env := env

		t.Run(env.name, func(t *testing.T) {
			t.Parallel()

			opts := &terraform.Options{
				TerraformDir: env.terraformDir,
				VarFiles:     []string{env.varFile},
				NoColor:      true,
			}

			plan := terraform.InitAndPlanAndShowWithStruct(t, opts)
			require.NotNil(t, plan)

			for _, resourceAddress := range coreResources {
				assert.Containsf(
					t,
					plan.ResourcePlannedValuesMap,
					resourceAddress,
					"expected %s to appear in the %s plan", resourceAddress, env.name,
				)
			}
		})
	}
}
