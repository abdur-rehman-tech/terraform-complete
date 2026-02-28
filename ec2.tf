#Key Pair (login)
resource "aws_key_pair" "Deployer" {
  key_name   = "TerraKey_EC2"
  public_key = file("FINAL.pub")
}


#VPC

resource "aws_default_vpc" "default" {


}


resource "aws_security_group" "security_group" {
  name        = "automate-sg"
  description = "This will add a security group"
  vpc_id      = aws_default_vpc.default.id #Interpolation


  

  #ingress (Inbound Rules)
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"

  }

  
  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }

  #egress (Outbound Rules)
  egress {
    from_port=0
    to_port=0
    protocol=-1
    cidr_blocks=["0.0.0.0/0"]
    description="Simple Outbound Rule"
  }

}
# EC2 Instance


resource "aws_instance" "my_instance" {
    ##count = 3   #Meta Argument  Create 2 Instance
    for_each = tomap({
      TWS-Dev="t2.micro"
      TWS-prod="t2.micro"
      TWS-test="t2.micro"
    })

    depends_on = [ aws_security_group.security_group ]

    key_name = aws_key_pair.Deployer.key_name
    vpc_security_group_ids = [aws_security_group.security_group.id]
    instance_type = each.value
    ami=var.ec2_ami_id


    root_block_device {
      volume_size = var.env =="prd" ? 20: var.ec2_default_root_storage_size
      volume_type = "gp3"
    }


    user_data = file("install_nginx.sh")
  


  tags = {
    Name = each.key
  }

}


resource "aws_instance" "my_new_instance" {
    ami="unknown"
    instance_type ="unknown"
    
  
}
