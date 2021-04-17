terraform {
  backend "s3" {
    bucket = "nus-iss-equeue-terraform"
    key    = "vpc/tfstate"
    region = "us-east-1"
  }
}
