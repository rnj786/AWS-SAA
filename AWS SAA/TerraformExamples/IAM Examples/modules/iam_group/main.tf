resource "aws_iam_group" "this" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = var.policy_arn
}
