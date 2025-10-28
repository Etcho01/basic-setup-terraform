terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-remote-state-mohamed" # your existing S3 bucket name
    key            = "global/s3/terraform.tfstate"       # path inside the bucket
    region         = "eu-west-1"                         # same region as your bucket
    dynamodb_table = "terraform-locks"                   # DynamoDB table for state locking
    encrypt        = true                                # ensures SSE encryption for state file
  }
}
