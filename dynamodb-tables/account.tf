#Table Name : Tasks
resource "aws_dynamodb_table" "account" {
  name           = "account"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "accountId"
  range_key      = "dtCreated"

  attribute {
    name = "accountId"
    type = "S"
  }
  attribute {
    name = "dtCreated"
    type = "S"
  }
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
  tags = {
    Name        = "account"
  }
}