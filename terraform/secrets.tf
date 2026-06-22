# -----------------------------------------------------------------------------
# Random passwords for RDS instances (stored in Terraform state + Secrets Manager)
# -----------------------------------------------------------------------------

resource "random_password" "catalog_db" {
  length  = 24
  special = false # Avoid special chars that can break JDBC URLs
}

resource "random_password" "orders_db" {
  length  = 24
  special = false
}

# -----------------------------------------------------------------------------
# AWS Secrets Manager — secure storage for database credentials
# -----------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "catalog_db" {
  name        = "bedrock/catalog-db-password"
  description = "Password for the Catalog MySQL RDS instance"
}

resource "aws_secretsmanager_secret_version" "catalog_db" {
  secret_id     = aws_secretsmanager_secret.catalog_db.id
  secret_string = random_password.catalog_db.result
}

resource "aws_secretsmanager_secret" "orders_db" {
  name        = "bedrock/orders-db-password"
  description = "Password for the Orders PostgreSQL RDS instance"
}

resource "aws_secretsmanager_secret_version" "orders_db" {
  secret_id     = aws_secretsmanager_secret.orders_db.id
  secret_string = random_password.orders_db.result
}
