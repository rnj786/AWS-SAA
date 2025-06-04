module "vpc" {
  source    = "./VPC"
  region    = var.region
  vpc_cidr  = var.vpc_cidr
  vpc_name  = var.vpc_name
}

module "iam_examples" {
  source           = "./IAM Examples"
  region           = var.region
  ssm_role_name    = var.ssm_role_name
  user_name        = var.user_name
  group_name       = var.group_name
  user_policy_arn  = var.user_policy_arn
  group_policy_arn = var.group_policy_arn
}

module "ec2" {
  source                  = "./EC2"
  region                  = var.region
  key_name                = var.key_name
  public_key_path         = var.public_key_path
  security_group_name     = var.security_group_name
  security_group_description = var.security_group_description
  allowed_ssh_cidr        = var.allowed_ssh_cidr
  ami_id                  = var.ami_id
  instance_type           = var.instance_type
  instance_name           = var.instance_name
  volume_size             = var.volume_size
  volume_type             = var.volume_type
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.private_subnet_ids
  iam_instance_profile    = module.iam_examples.ssm_instance_profile
  ssm_role_name           = module.iam_examples.ssm_role_name
  user_name               = var.user_name
  group_name              = var.group_name
  user_policy_arn         = var.user_policy_arn
  group_policy_arn        = var.group_policy_arn
  account_id              = var.account_id
}