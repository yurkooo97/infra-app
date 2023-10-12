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


