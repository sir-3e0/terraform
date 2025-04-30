terraform {
  required_version = "1.10.5"
  required_providers {
    aws = {
      version = "~> 5.84.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
locals {
  instance_type = {
    default = "t2.micro"
    dev     = "t2.nano"
    prod    = "m5.large"
  }
}

data "aws_ami" "my_imgage" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
variable "sg_ports" {
  type    = list(number)
  default = [22, 80, 8080, 8000]
}

# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic_sg"
  description = "Ingress for vault"
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_instance" "myec2" {
  ami             = data.aws_ami.my_imgage.image_id
  instance_type   = local.instance_type[terraform.workspace]
  key_name        = "deployer-key"
  security_groups = ["dynamic_sg"]
  tags = {
    Name = "jenkins-server"
    Env  = terraform.workspace
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
    script_path = "terraform_provisioner_%RAND%.sh"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #         "sudo apt update",
  #         "sudo apt upgrade -y",
  #         "sudo apt -y install apache2",
  #         "sudo systemctl enable --now apache2"
  #   ]
  # }

  provisioner "local-exec" {
    command = "sleep 30 && echo ${self.public_ip} > inventory && ansible-playbook -i inventory my-playbook.yaml"
  }

}

output "public_ip" {
  value = aws_instance.myec2.public_ip
}

