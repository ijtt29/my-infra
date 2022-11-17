variable "region" {
  type        = string
  default     = "ap-northeast-2"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type = list(string)
  default = []
}

variable "environment" {
  description = "Deploy Environment"
  type = string
  default = "dev"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = null
}

variable "vpc_primary_cidr" {
  description = "VPC CIDR Range"
  type = string
  default = "10.0.0.0/16"
}
