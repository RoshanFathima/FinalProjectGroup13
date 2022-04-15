terraform {
  backend "s3" {
    bucket = "dev-group13"              // Bucket where to SAVE Terraform State
    key    = "dev-vm/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                // Region where bucket is created
  }
}