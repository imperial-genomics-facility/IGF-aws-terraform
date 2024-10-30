provider "aws" {
  region = var.aws_region
}


## create s3 buckets
module "igf_s3_bucket" {
  source = "./modules/s3_bucket"
}

