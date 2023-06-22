provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "kamataryo-tfstate-tokyo"
    key    = "sandbox-tf-cloudfront-s3-redirection-with-hsts"
  }

  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      "source"  = "hashicorp/aws"
      "version" = "~> 5.4.0"
    }
  }
}

locals {
  hosted_zone_id = "Z17T639TOLS7MH"
  naked_domain   = "sandbox-tf-cloudfront-s3-redirection-with-hsts.kamataryo.com"
}

data "aws_caller_identity" "current" {}
