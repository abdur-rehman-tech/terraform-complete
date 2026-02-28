variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}



variable "ec2_default_root_storage_size" {
    default = 10
    type = number
  
}

variable "ec2_ami_id" {
    default = "ami-0f65fc8c24ec8d2a1"
    type = string
  
}

variable "env" {
    default = "dev"
    type = string
  
}