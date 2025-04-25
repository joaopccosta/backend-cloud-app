resource "aws_dynamodb_table" "users" {
  name         = var.dynamodb_users_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "username"

  attribute {
    name = "username"
    type = "S"
  }
}
