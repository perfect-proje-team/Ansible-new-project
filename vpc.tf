data "aws_caller_identity" "current" {}

module "vpc_main" {
  source          = "./modules/vpc"
  region_name     = "us-east-1"
  vpc_cidr_block  = "10.10.0.0/16"
  environment     = "development"
  public_subnets  = ["10.10.0.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.1.0/24", "10.10.3.0/24"]
  public_az       = ["us-east-1a", "us-east-1b"]
  private_az      = ["us-east-1a", "us-east-1b"]

}
