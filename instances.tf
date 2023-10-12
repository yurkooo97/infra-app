# data "aws_ami" "amazon_linux_latest" {
#   owners      = ["amazon"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.1.2023*x86_64"]
#   }
# }

# data "aws_ami" "amazon2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#   }
#   owners = ["amazon"]
# }


resource "aws_instance" "Bastion" {

  ami = "ami-065ab11fbd3d0323d"

  instance_type = var.instance_type_free

  key_name = aws_key_pair.bastion_auth.key_name

  subnet_id = element(aws_subnet.subnet_public[*].id, 0)

  vpc_security_group_ids = [aws_security_group.bastion_cg.id]

  provisioner "file" {
    source      = "/home/yura/test_git/infra-app/ansible"
    destination = "/home/ec2-user/"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/bastion")
      host        = aws_instance.Bastion.public_ip
    }
  }

  provisioner "file" {
    source      = "/home/yura/.ssh/bastion"
    destination = "/home/ec2-user/.ssh/bastion"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/bastion")
      host        = aws_instance.Bastion.public_ip
    }
  }

  user_data = templatefile("bastion_install.sh", {})

  tags = {
    Name = "Bastion"
  }

}


resource "aws_instance" "Frontend" {

  ami = "ami-065ab11fbd3d0323d"

  instance_type = var.instance_type_free

  key_name = aws_key_pair.bastion_auth.key_name

  subnet_id = element(aws_subnet.subnet_public[*].id, 0)

  vpc_security_group_ids = [aws_security_group.frontend_cg.id]

  tags = {
    Name = "Frontend"
  }

}

resource "aws_instance" "Backend" {

  ami = "ami-065ab11fbd3d0323d"

  instance_type = var.instance_type_medium

  key_name = aws_key_pair.bastion_auth.key_name

  subnet_id = element(aws_subnet.subnet_private[*].id, 0)

  vpc_security_group_ids = [aws_security_group.backend_cg.id]

  tags = {
    Name = "Backend"
  }

}

resource "aws_db_instance" "db" {

  identifier = "rds"

  allocated_storage = 10

  db_name = "eschool"

  engine = "mysql"

  engine_version = "5.7"

  instance_class = "db.t3.micro"

  username = "root"

  password = "password"

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group_private.name

  vpc_security_group_ids = [aws_security_group.project_cg_rds.id]

  parameter_group_name = "default.mysql5.7"

  skip_final_snapshot = true

  apply_immediately = true


}


output "bastion_ip" {
  value = aws_instance.Bastion.public_ip
}

output "frontend_public_ip" {
  value = aws_instance.Frontend.public_ip
}

output "frontend_private_ip" {
  value = aws_instance.Frontend.private_ip
}

output "backend_ip" {
  value = aws_instance.Backend.private_ip
}

output "rds_enpoint" {
  value = aws_db_instance.db.endpoint
}

output "database_name" {
  value = aws_db_instance.db.db_name
}

output "database_username" {
  value = aws_db_instance.db.username
}

output "database_password" {
  value     = aws_db_instance.db.password
  sensitive = true

}



