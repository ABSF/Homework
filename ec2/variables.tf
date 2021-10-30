variable "ec2_type" {
  description = "Instance type of launching EC2."
  type        = string
  default     = "t2.micro"
}

variable "ec2_name" {
  description = "Name of launching EC2."
  type        = string
  default     = "my-ec2-instance"
}

variable "myip" {
  description = "My IPv4."
  type        = string
}

variable "public_key" {
  description = "Public key for ssh"
  type        = string
}