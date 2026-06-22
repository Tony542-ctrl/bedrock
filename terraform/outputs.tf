output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.id
}

output "catalog_db_endpoint" {
  value = aws_db_instance.catalog_mysql.endpoint
}

output "orders_db_endpoint" {
  value = aws_db_instance.orders_postgres.endpoint
}

# --- Sensitive outputs for CI/CD injection (never committed to source) ---

output "catalog_db_password" {
  description = "Catalog MySQL RDS password — injected into Helm values by CI/CD"
  value       = random_password.catalog_db.result
  sensitive   = true
}

output "orders_db_password" {
  description = "Orders PostgreSQL RDS password — injected into Helm values by CI/CD"
  value       = random_password.orders_db.result
  sensitive   = true
}

output "alb_controller_role_arn" {
  description = "IAM role ARN for the AWS Load Balancer Controller service account"
  value       = module.lb_controller_irsa.iam_role_arn
}

output "carts_irsa_role_arn" {
  description = "IAM role ARN for the carts DynamoDB service account"
  value       = aws_iam_role.carts_dynamodb.arn
}

# --- bedrock-dev-view credentials (for grading submission) ---

output "dev_view_access_key_id" {
  description = "Access Key ID for bedrock-dev-view IAM user"
  value       = aws_iam_access_key.dev_view.id
  sensitive   = true
}

output "dev_view_secret_access_key" {
  description = "Secret Access Key for bedrock-dev-view IAM user"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}

output "dev_view_console_password" {
  description = "Console login password for bedrock-dev-view IAM user"
  value       = aws_iam_user_login_profile.dev_view.password
  sensitive   = true
}
