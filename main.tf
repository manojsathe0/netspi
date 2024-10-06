terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = ">= 5.0.0"
  }
}

provider "aws" {
  region = "us-east-1"
}
