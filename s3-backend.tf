terraform {
  backend "s3" {
    bucket         = "s3-ewi-backend"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
  }
}
