#!/bin/bash
sudo chown -R ec2-user:ec2-user /app
# 1. עדכון חבילות והתקנת Docker ו-curl
sudo dnf update -y
sudo dnf install -y docker curl --allowerasing
sudo systemctl start docker
sudo systemctl enable docker

# 2. יצירת התיקייה /app והורדת תמונת הדוב
mkdir -p /app
cd /app
curl -s -o bear.jpg "https://placebear.com/800/600"

# 3. יצירת קובץ index.html
cat <<'HTML' > index.html
<!DOCTYPE html>
<html lang="he">
<head>
    <meta charset="UTF-8">
    <title>Bear Server</title>
    <style>
        body { 
            background-color: #1a1a1a; 
            color: #ffffff; 
            text-align: center; 
            font-family: Arial, sans-serif; 
            padding-top: 50px; 
        }
        img { 
            border-radius: 12px; 
            max-width: 80%; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.5); 
        }
    </style>
</head>
<body>
    <h1>Bear Server 🐻</h1>
    <img src="bear.jpg" alt="Bear">
</body>
</html>
HTML

# 4. הרצת Container של Nginx עם מיפוי נפח לתיקייה /app
sudo docker run -d -p 80:80 -v /app:/usr/share/nginx/html:ro --name bear-web nginx:alpine