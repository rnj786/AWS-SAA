resource "aws_dynamodb_table" "eventsrsvp" {
  name           = "eventsrsvp"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "eventId"

  attribute {
    name = "eventId"
    type = "S"
  }
}

resource "aws_iam_role_policy" "ecs_dynamodb_access" {
  name = "ecsDynamoDBAccessPolicy"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.eventsrsvp.arn
      }
    ]
  })
}
