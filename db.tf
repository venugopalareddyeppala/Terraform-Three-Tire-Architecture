###############
### DB TIRE ###
###############

################################
### SUBNET GROUP FOR DB TIRE ###
################################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds_subnet_group"
  subnet_ids  = [aws_subnet.private_subnet5.id, aws_subnet.private_subnet6.id]
  description = "subnet group for rds"

  tags = {
    name = "RDS_SUBNET-GROUP"
  }
}









#######################
### RDS FOR DB TIRE ###
#######################

resource "aws_db_instance" "rds_instance" {
  identifier             = "mydb-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  username               = "admin"
  password               = "Venu123#"
  db_name                = "mydb"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true
  multi_az               = false
  publicly_accessible    = false

  tags = {
    name = "RDS"
  }

}