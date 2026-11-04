#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# הוספת משתמש ה-root לקבוצת docker (אופציונלי אך מומלץ)
sudo usermod -a -G docker ec2-user

sudo docker pull ${docker_image}

sudo docker run -d -p 5000:5000 \
  -e S3_BUCKET_NAME="${s3_bucket_name}" \
  -e AWS_REGION="${aws_region}" \
  --restart always \
  ${docker_image}