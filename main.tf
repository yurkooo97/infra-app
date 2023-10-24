terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "= 4.44.0"

    }

  }

  required_version = ">= 1.1.0, <= 1.5.6"


}

resource "aws_key_pair" "bastion_auth" {

  key_name = "bastion"

  public_key = file("/home/yura/.ssh/bastion.pub")

}

data "aws_iam_instance_profile" "aws_ec2_full_access" {
  name = "AWS_EC2_FullAccess"
}

data "aws_iam_instance_profile" "ecr_role" {
  name = "ecr_role"
}

data "aws_route53_zone" "eschool" {
  name = "eschool-if.net"
}


