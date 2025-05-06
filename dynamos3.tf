##Generate random numbers
resource "random_integer" "pokemon" {
  count = 3  
  min = 1000
  max = 9999 
}

##create dynamod table
resource "aws_dynamodb_table" "terraformlocks" {
  count = 3
  name = "terraformlocks-${random_integer.pokemon[count.index].result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = local.dynamo_db
    Env  = local.env
  }
}
####create s3 bucket

resource "aws_s33_bucket" "pokemon" {
  count = 3
  bucket = join("-", [local.s3_bucket, terraform.workspace, random_integer.pokemon[count.index].result]) ##if you give like this you will get the env in name
  depends_on = [aws_dynamodb_table.terraformlocks]
  tags = {
    Name = join("-", [local.s3_bucket, terraform.workspace, random_integer.pokemon[count.index].result])
    Env  = local.env
  }
}
