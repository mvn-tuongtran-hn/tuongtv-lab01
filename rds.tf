resource "aws_db_instance" "mysql-db" {
  identifier        = "mysqldatabase"
  storage_type      = "gp2"
  allocated_storage = 20

  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  port                 = "3306"
  count                = length(var.private_subnet_cidr_blocks)
  db_subnet_group_name = var.private_subnet_cidr_blocks[1]

  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.sg_rds_private.id]

  publicly_accessible = false
  deletion_protection = true
  skip_final_snapshot = true

  tags = {
    name = "RDS Instance"
  }


}