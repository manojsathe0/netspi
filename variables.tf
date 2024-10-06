variable "vpc_name" {
  default     = "netspi-vpc"
  type        = string
  description = "Name of the VPC"
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "project" {
  type        = string
  default = "netspi"
}

variable "environment" {
  type        = string
  default = "test"
}

variable "region" {
  default     = "us-east-1"
  type        = string
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list(any)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(any)
  description = "List of availability zones"
}

variable "tags" {
  default     = {}
  type        = map(string)
}