###############################################################
# GitHub Actions IAM Policy — Content Delivery & DNS
#
# Second of three policies split from one oversized policy (AWS
# caps a managed policy at 6144 characters). See
# iam_policy_storage.tf for context.
###############################################################

data "aws_iam_policy_document" "github_actions_delivery" {

  #############################################################
  # CloudFront — This Distribution
  #############################################################

  statement {
    sid    = "CloudFrontDistributionManagement"
    effect = "Allow"

    actions = [
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource"
    ]

    resources = [
      local.cloudfront_distribution_arn
    ]
  }

  statement {
    sid    = "CloudFrontAccountLevel"
    effect = "Allow"

    actions = [
      "cloudfront:ListDistributions",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:ListOriginAccessControls",
      "cloudfront:CreateDistribution"
    ]

    resources = [
      "*"
    ]
  }

  #############################################################
  # WAFv2 — CloudFront-scoped Web ACL (always us-east-1)
  #############################################################

  statement {
    sid    = "WAFv2Management"
    effect = "Allow"

    actions = [
      "wafv2:CreateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:UpdateWebACL",
      "wafv2:GetWebACL",
      "wafv2:ListWebACLs",
      "wafv2:TagResource",
      "wafv2:UntagResource",
      "wafv2:ListTagsForResource"
    ]

    resources = [
      "*"
    ]
  }

  #############################################################
  # ACM — Certificate Lifecycle
  #############################################################

  statement {
    sid    = "ACMManagement"
    effect = "Allow"

    actions = [
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:DeleteCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:ListTagsForCertificate"
    ]

    resources = [
      "*"
    ]
  }

  #############################################################
  # Route53 — This Hosted Zone Only
  #############################################################

  statement {
    sid    = "Route53Access"
    effect = "Allow"

    actions = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListTagsForResource",
      "route53:ChangeTagsForResource"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${var.hosted_zone_id}",
      "arn:aws:route53:::change/*"
    ]
  }
}
