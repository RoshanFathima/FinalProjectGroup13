terraform {
  backend "s3" {
    bucket = "prod-group13"              // Bucket where to SAVE Terraform State
    key    = "prod-vm/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                 // Region where bucket is created
  }
}
