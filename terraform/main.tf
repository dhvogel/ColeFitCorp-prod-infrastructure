provider "aws" {
  region = "${var.aws_region}"
}



resource "aws_security_group" "cfcorp_web_sg" {
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



resource "aws_instance" "cfcorp_web_instance" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = [
        "${aws_security_group.cfcorp_web_sg.name}"
  ]
  user_data = "${file("userdata.sh")}"

  tags {
    Name = "${var.tag_name}"
  }
}



resource "aws_elb" "cfcorp_web_elb" {
  name               = "cfcorp-web-elb"
  availability_zones = ["${aws_instance.cfcorp_web_instance.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.cfcorp_web_instance.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "foobar-terraform-elb"
  }
}
