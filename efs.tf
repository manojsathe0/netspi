resource "aws_security_group" "netspi_efs_sg" {
  depends_on  = [aws_vpc.netspi_vpc]
  name        = "efs_security_group"
  description = "Allow NFS traffic"
  vpc_id      = aws_vpc.netspi_vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "netspi-efs-sg"
  }
}

resource "aws_efs_file_system" "netspi_efs" {
  creation_token = "netspi_test_assignment_efs"

  tags = {
    Name = "netspi_test_assignment_efs"
  }
}

resource "aws_efs_mount_target" "my_efs_mount" {
  file_system_id = aws_efs_file_system.netspi_efs.id
  subnet_id      = aws_subnet.netspi_public_subnet[0].id

  security_groups = [aws_security_group.netspi_efs_sg.id]
}