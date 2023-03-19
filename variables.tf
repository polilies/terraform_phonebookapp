variable "ec2_type" {
  type = string
  description = "instance type"
  default = "t2.micro"
}

variable "ingress-ports" {
  type        = list(number)
  description = "docker-instance-sec-gr-inbound-rules"
  default     = [22, 80, 443]
}

variable "ingress-cidrs" {
  type        = list(number)
  description = "docker-instance-sec-gr-inbound-rules"
  default     = [ aws_vpc.phone.cidr_block, aws_vpc.phone.cidr_block, "0.0.0.0/0"]
}
