provider "aws" {
  region = "us-east-1"
}

# 4 AWS t2.micro EC2 instances
resource "aws_instance" "Udacity_T2" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  count         = 4
  tags = {
    Name = "Udacity T2"
  }
}

# 2 m4.large EC2 instances
resource "aws_instance" "Udacity_M4" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "m4.large"
  count         = 2
  tags = {
    Name = "Udacity M4"
  }
}
