resource "aws_security_group" "rds" {
  name_prefix = "project-bedrock-rds-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow MySQL from EKS Nodes"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  ingress {
    description = "Allow PostgreSQL from EKS Nodes"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "project-bedrock-rds-subnets"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "catalog_mysql" {
  identifier             = "bedrock-catalog-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "catalog"
  username               = "dbadmin"
  password               = random_password.catalog_db.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
}

resource "aws_db_instance" "orders_postgres" {
  identifier             = "bedrock-orders-db"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "orders"
  username               = "dbadmin"
  password               = random_password.orders_db.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
}
