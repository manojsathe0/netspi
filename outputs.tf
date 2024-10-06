output "netspi_vpc_id" {
  value       = aws_vpc.netspi_vpc.id
  description = "VPC ID"
}

output "netspi_ec2_instance_id" {
  value = aws_instance.netspi_ec2_instance.id
}

output "public_subnet_ids" {
  value       = aws_subnet.netspi_public_subnet.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.netspi_private_subnet.*.id
  description = "List of private subnet IDs"
}

output "netspi_s3bucket_id" {
  value = aws_s3_bucket.netspi_s3bucket.id
}

output "netspi_efs_id" {
  value = aws_efs_file_system.netspi_efs.id
}

output "netspi_ec2_sg_id" {
  value = aws_security_group.netspi_ec2_sg.id
}

output "netspi_efs_sg_id" {
  value = aws_security_group.netspi_efs_sg.id
}

output "nat_gateway_ips" {
  value       = aws_eip.netspi_nat_eip.*.public_ip
  description = "List of Elastic IPs associated with NAT gateways"
}