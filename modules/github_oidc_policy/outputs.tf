###############################################################
# Outputs
#
# A map with static keys (known at plan time) so the root module
# can for_each over it safely — the values (ARNs) are unknown
# until apply, but for_each only requires the keys to be known.
###############################################################

output "policy_arns" {
  description = "Map of GitHub Actions IAM policy ARNs, keyed by policy group."
  value = {
    storage  = aws_iam_policy.github_actions_storage.arn
    delivery = aws_iam_policy.github_actions_delivery.arn
    identity = aws_iam_policy.github_actions_identity.arn
  }
}
