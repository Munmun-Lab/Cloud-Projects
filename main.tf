provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "my-AWS-ubuntu-vm" {
  ami           = "ami-05fa00d4c63e32376" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
