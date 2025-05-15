resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_user_group_membership" "this" {
  user = aws_iam_user.this.name
  groups = [
    var.group_name
  ]
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
