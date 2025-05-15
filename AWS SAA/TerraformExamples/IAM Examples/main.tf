module "iam_role" {
  source      = "./modules/iam_role"
  role_name   = var.role_name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

module "iam_group" {
  source      = "./modules/iam_group"
  group_name  = var.group_name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

module "iam_user" {
  source      = "./modules/iam_user"
  user_name   = var.user_name
  group_name  = var.group_name
  role_name   = var.role_name
}
