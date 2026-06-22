# -----------------------------------------------------------------------------
# Carts Service — IRSA Role for DynamoDB Access
# Grants the carts pod access to the managed AWS DynamoDB table
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "carts_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:retail-app:retail-store-carts"]
    }
  }
}

resource "aws_iam_role" "carts_dynamodb" {
  name               = "bedrock-carts-dynamodb"
  assume_role_policy = data.aws_iam_policy_document.carts_assume.json

  tags = {
    Project = "karatu-2025-capstone"
  }
}

resource "aws_iam_policy" "carts_dynamodb" {
  name        = "bedrock-carts-dynamodb"
  description = "Allow carts service to access the bedrock-carts DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          aws_dynamodb_table.carts.arn,
          "${aws_dynamodb_table.carts.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "carts_dynamodb" {
  role       = aws_iam_role.carts_dynamodb.name
  policy_arn = aws_iam_policy.carts_dynamodb.arn
}
