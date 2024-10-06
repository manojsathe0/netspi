resource "aws_iam_role" "netspi_ec2_iam_role" {
  name = "netspi_ec2_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a policy to allow EC2 instances with this role to access the S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name = "s3_access_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::netspi-assignment-bucket",
          "arn:aws:s3:::netspi-assignment-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "efs_access_policy" {
  name = "efs_access_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaceAttribute"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_role" {
  role       = aws_iam_role.netspi_ec2_iam_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_efs_policy_to_role" {
  role       = aws_iam_role.netspi_ec2_iam_role.name
  policy_arn = aws_iam_policy.efs_access_policy.arn
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "netspi_ec2_instance_profile" {
  name = "netspi_ec2_instance_profile"
  role = aws_iam_role.netspi_ec2_iam_role.name
}