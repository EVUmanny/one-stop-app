provider "aws" {
  region = "eu-west-2"
}

module "networking" {
  source       = "./modules/networking"
  cidr_block   = "10.0.0.0/16"
  subnet_count = 2
}
