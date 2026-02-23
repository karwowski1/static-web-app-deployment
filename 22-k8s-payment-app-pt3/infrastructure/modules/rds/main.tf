# sg for RDS allowing access only from VPC
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow inbound traffic from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

# subnet group for RDS
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "FinPay DB subnet group"
  }
}

# DB instance
resource "aws_db_instance" "postgres" {
  identifier           = "${var.project_name}-db"
  allocated_storage    = 20
  db_name              = "payments"
  engine               = "postgres"
  engine_version       = "16.6"
  instance_class       = "db.t3.micro"
  username             = "payments"
  password             = var.db_password
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  publicly_accessible  = false
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}