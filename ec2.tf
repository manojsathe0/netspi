# Note: Elastic IP Created using AWS Console with Tag: "Project=NetSPI_EIP"

data "aws_eip" "netspi_eip" {
  filter {
    name   = "tag:Project"
    values = ["NetSPI_EIP"]
  }
}

data "aws_ami" "latest_amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "netspi_ec2_sg" {
  depends_on  = [aws_vpc.netspi_vpc]
  name        = "netspi-ec2-sg"
  description = "Security group for SSH access"

  vpc_id = aws_vpc.netspi_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "netspi-ec2-sg"
  }
}

resource "aws_instance" "netspi_ec2_instance" {
  ami             = data.aws_ami.latest_amazon_linux_2.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.netspi_ec2_sg.id]
  subnet_id       = aws_subnet.netspi_public_subnet[0].id

  iam_instance_profile = aws_iam_instance_profile.netspi_ec2_instance_profile.name
  key_name             = "netspi-key"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-efs-utils
              yum install -y nfs-common
              mkdir -p /data/test
              mount -t nfs4 -o nfsvers=4.1 ${aws_efs_file_system.netspi_efs.dns_name}:/ /data/test
              echo "${aws_efs_file_system.netspi_efs.dns_name}:/ /data/test nfs4 defaults,_netdev 0 0" >> /etc/fstab
              EOF
  tags = {
    Name = "netspi-ec2-instance"
  }
}

resource "aws_eip_association" "netspi_eip_attach" {
  instance_id   = aws_instance.netspi_ec2_instance.id
  allocation_id = data.aws_eip.netspi_eip.id
}