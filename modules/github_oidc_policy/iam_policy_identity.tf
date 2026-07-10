###############################################################
# GitHub Actions IAM Policy — Identity & Observability
#
# Third of three policies split from one oversized policy (AWS
# caps a managed policy at 6144 characters). See
# iam_policy_storage.tf for context.
###############################################################

data "aws_iam_policy_document" "github_actions_identity" {

  #############################################################
  # IAM — This Role/Policy Only
  #############################################################

  statement {
    sid    = "IAMManagement"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:PassRole",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:DeletePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      local.github_role_arn,
      "${local.github_policy_arn}-storage",
      "${local.github_policy_arn}-delivery",
      "${local.github_policy_arn}-identity"
    ]
  }

  statement {
    sid    = "IAMCreate"
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:CreatePolicy"
    ]

    resources = [
      "*"
    ]
  }

  #############################################################
  # STS — Identity Check
  #############################################################

  statement {
    sid    = "STSManagement"
    effect = "Allow"

    actions = [
      "sts:GetCallerIdentity"
    ]

    resources = [
      "*"
    ]
  }

  #############################################################
  # SNS — Alarm Notification Topic
  #############################################################

  statement {
    sid    = "SNSAlertsManagement"
    effect = "Allow"

    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:ListSubscriptionsByTopic",
      "sns:TagResource",
      "sns:UntagResource"
    ]

    resources = [
      local.sns_topic_arn
    ]
  }

  #############################################################
  # CloudWatch — Alarms
  #############################################################

  statement {
    sid    = "CloudWatchAlarmManagement"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:TagResource",
      "cloudwatch:UntagResource"
    ]

    resources = [
      local.cloudwatch_alarm_arn_prefix
    ]
  }
}
