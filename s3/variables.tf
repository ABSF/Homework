variable "bucket" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {
    test = "test"
  }
}

variable "myip" {
  description = "My IPv4 address used in policy."
  type        = string
  default     = null
}