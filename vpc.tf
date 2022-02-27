module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
  name = local.name
  cidr = "10.0.0.0/16"
  azs             = [data.aws_availability_zones.availability-zones[0], data.aws_availability_zones.availability-zones[1]]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway = false
  tags = {
    Environment = local.environment
    Name        = local.name
  }
}