/* resource "aws_db_instance" "phone" {
  allocated_storage    = 10
  db_name              = "clarusway_phonebook"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "awsdevops13"
  parameter_group_name = "phone.mysql5.7"
  skip_final_snapshot  = true
  port = 3306
}

output "rds_endpoint" {
  value = aws_db_instance.phone.endpoint
} */