# IAM role assumed by EC2 instances launched by our application Auto Scaling Group.
# We use an instance role instead of storing long-lived AWS access keys on the server.
resource "aws_iam_role" "ec2_ssm" {
  name = "${local.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          # Only the EC2 service is allowed to assume this role.
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-ssm-role"
  })
}

# Attach only the permissions required for Systems Manager access.
# We intentionally do not grant the application access to other AWS services here.
# If the app later needs S3, Secrets Manager, RDS-related access, etc., we will add
# narrowly scoped policies for those specific requirements instead of broad access.
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profiles are how an IAM role is attached to an EC2 instance.
# The Launch Template references this profile, and the EC2 instances receive
# temporary credentials for the role automatically.
resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name_prefix}-ec2-profile"

  role = aws_iam_role.ec2_ssm.name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-profile"
  })
}
