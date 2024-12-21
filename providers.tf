terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}


data "terraform_remote_state" "provider" {
  backend = "s3" 
  config = {
    bucket = "pv-testing-1"
    key    = "provider/terraform.tfstate"
    region = var.region
  }
}