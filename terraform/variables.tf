variable "ami_id" {
  description = "AMI ID"
  default = "ami-79f66d6f"
}

variable "aws_region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "connection_user" {
  description = "Name of user used in instance connection"
  default = "ubuntu"
}

variable "connection_private_key" {
  description = "Relative path of private key used to ssh into instance"
  default = "~/.ssh/cfcorp-2.pem"
}

variable "instance_type" {
  description = "Type of AWS Instance"
  default = "t2.micro"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "cfcorp-2"
}

variable "sg_description" {
  description = "Description of security group"
  default = "Cole Fit Corporation secruity group"
}

variable "sg_name" {
  description = "Name of security group"
  default = "cfcorp_sg"
}

variable "tag_name" {
  description = "Name tag on instance"
  default = "CFCorp_Web+Workout_Service"
}
