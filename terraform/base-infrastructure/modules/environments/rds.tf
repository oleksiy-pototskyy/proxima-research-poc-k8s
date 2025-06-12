resource "random_password" "dev-rds-password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "dev-rds-password" {
  name = "dev-rds-password"
}

resource "aws_secretsmanager_secret_version" "dev-rds-password" {
  secret_id     = aws_secretsmanager_secret.dev-rds-password.id
  secret_string = random_password.dev-rds-password.result
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name        = "db-subnet-group"
  description = "RDS subnet group for environments"
  subnet_ids  = var.ENVS_DB_SUBNETS_IDS
  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_parameter_group" "db-parameter-group" {
  name   = "aurora-instance-5-7"
  family = "aurora-mysql5.7"

  parameter {
    name         = "query_cache_type"
    value        = "0"
    apply_method = "pending-reboot"
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "RDS-sg"
  description = "Allow connection from EKS workers to RDS DB"
  egress      = []
  ingress = [
    {
      cidr_blocks      = []
      description      = "Allow connection from EKS workers to RDS"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups = [
        var.ENVS_EKS_SG_ID,
      ]
      self    = false
      to_port = 3306
    },
    {
      cidr_blocks      = []
      description      = "Allow connection from jump-host to RDS"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups = [
        var.ENVS_JUMP_HOST_SG_ID,
      ]
      self    = false
      to_port = 3306
    },
  ]
  tags = {
    "Name" = "RDS-sg"
  }
  vpc_id = var.ENVS_VPC_ID
}

resource "aws_rds_cluster" "dev-rds-cluster" {
  backtrack_window                = 0
  backup_retention_period         = 7
  cluster_identifier              = "dev-cluster"
  database_name                   = "corecrm"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  db_subnet_group_name            = aws_db_subnet_group.db-subnet-group.name
  engine                          = "aurora-mysql"
  engine_mode                     = "provisioned"
  engine_version                  = "5.7.mysql_aurora.2.09.1"
  master_username                 = "corecrm"
  master_password                 = random_password.dev-rds-password.result
  preferred_maintenance_window    = "sun:04:35-sun:05:05"
  storage_encrypted               = true
  skip_final_snapshot             = true
  vpc_security_group_ids = [
    aws_security_group.rds-sg.id,
  ]
}

resource "aws_rds_cluster_instance" "dev_rds_instance" {
  identifier                   = "dev"
  cluster_identifier           = aws_rds_cluster.dev-rds-cluster.id
  instance_class               = "db.t3.small"
  engine                       = aws_rds_cluster.dev-rds-cluster.engine
  engine_version               = aws_rds_cluster.dev-rds-cluster.engine_version
  auto_minor_version_upgrade   = false
  db_parameter_group_name      = aws_db_parameter_group.db-parameter-group.name
  preferred_maintenance_window = "sat:09:25-sat:09:55"
}
