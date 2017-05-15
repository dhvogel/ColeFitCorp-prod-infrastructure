provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "cfcorp" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  connection {
    user = "${var.connection_user}"
    private_key = "${var.connection_private_key}"
  }
}

resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = [
        "${aws_security_group.cfcorp.name}"
  ]
  user_data = "${file("userdata.sh")}"

  tags {
    Name = "${var.tag_name}"
  }
}
