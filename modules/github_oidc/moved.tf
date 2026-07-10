###############################################################
# State Migration
#
# create_oidc_provider defaults to true, so this resource's
# index doesn't change for existing deployments — this block is
# a safety net in case that default is ever flipped.
###############################################################

moved {
  from = aws_iam_openid_connect_provider.github
  to   = aws_iam_openid_connect_provider.github[0]
}
