terraform {
  backend "s3" {
    bucket = "project-bedrock-tf-state-tony542"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
