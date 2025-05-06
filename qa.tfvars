vpc_name             = "Gamer-VPC"
vpc_cidr             = "10.168.0.0/16"
azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidrs  = ["10.168.1.0/24", "10.168.2.0/24", "10.168.3.0/24"]
private_subnet_cidrs = ["10.168.4.0/24", "10.168.5.0/24", "10.168.6.0/24"]
region               = "us-east-1"
instance_type        = "t2.micro"
key_name             = "mykey"
ami = {
  "us-west-2" = "ami-07b0c09aab6e66ee9"
  "us-east-1" = "ami-0e449927258d45bc4"
}
dynamo_db   = "statelock"
s3_bucket   = "Vikingbucket"
qa_role_arn = "arn:aws:iam::811362454422:role/qarole"