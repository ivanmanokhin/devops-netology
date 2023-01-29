terraform {
  backend "s3" {
    bucket = "manokhin-terraform"
    key    = "backend/terraform.tfstate"
    region = "eu-north-1"
  }
}
