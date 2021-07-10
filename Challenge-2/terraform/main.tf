#resources
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

}

resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone}"

}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }

}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_security_group" "sg_22_80" {
  name = "sg_22"
  vpc_id = "${aws_vpc.vpc.id}"

  # SSH access from the VPC
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# resource "aws_key_pair" "ec2key" {
#   key_name = "publicKey"
#   public_key = "${file(var.public_key_path)}"
# }

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${var.environment}-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.environment}-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "testInstance" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_public.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_22_80.id}"]
  key_name = "${aws_key_pair.key_pair.key_name}"


 provisioner "file" {
    source      = "./${aws_key_pair.key_pair.key_name}.pem"
    destination = "/home/ec2-user/${aws_key_pair.key_pair.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 ~/${aws_key_pair.key_pair.key_name}.pem",
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
      "sudo yum -y install python3 git"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    host        = self.public_ip
  }
}
