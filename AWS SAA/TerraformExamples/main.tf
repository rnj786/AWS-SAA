module "vpc" {
  source = "./VPC"
  # ...other variables...
}

module "ec2" {
  source                = "./EC2"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_subnet_ids     = module.vpc.private_subnet_ids
  iam_instance_profile   = module.iam_examples.ssm_instance_profile
  # ...other variables...
}

module "iam_examples" {
  source = "./IAM Examples"
}