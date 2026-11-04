resource "aws_launch_template" "golden_machin_template" {
  name_prefix   = "golden_machin"
  image_id      = "ami-0ea87431b78a82070"  
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = var.if_Public_ip
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  
  user_data = base64encode(templatefile("${path.module}/install_app.sh", {
    s3_bucket_name = aws_s3_bucket.Clude_s3.id
    aws_region     = var.aws_region
    docker_image   = var.docker_image
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Golden-Server-Node"
    }
  }
}

# יצירת IAM Role עבור ה-EC2
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# חיבור מדיניות קריאה/כתיבה ל-S3 (או גישה מלאה לבקט שלך) ל-Role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# יצירת Instance Profile שדרכו ה-EC2 מקבל את ה-Role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_s3_instance_profile"
  role = aws_iam_role.ec2_s3_role.name
}