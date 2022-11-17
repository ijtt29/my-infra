module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.vpc_primary_cidr
  azs  = var.azs

  public_subnets = [for index in range(1):
                      cidrsubnet(var.vpc_primary_cidr, 2, index)]

}