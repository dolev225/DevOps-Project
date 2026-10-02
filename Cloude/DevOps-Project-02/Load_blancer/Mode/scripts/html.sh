#!/bin/bash
set -eux

# 1. עדכון חבילות והתקנת nginx
sudo dnf update -y
sudo dnf install -y nginx

# 2. יצירת התיקיות
sudo mkdir -p /var/www/html
sudo mkdir -p /usr/share/nginx/html

# 3. מחיקת דף הדיפולט של Nginx במידה וקיים
sudo rm -f /usr/share/nginx/html/index.html

# 4. הורדת התמונה המבוקשת בשם אחיד
sudo curl -sSL -o /var/www/html/animal.jpg "${image_base_url}/${image_file}" || true
sudo cp /var/www/html/animal.jpg /usr/share/nginx/html/animal.jpg || true

# 5. יצירת תוכן ה-HTML בשני הנתיבים (כדי לכסות את כל הקונפיגורציות של Nginx)
cat <<HTML | sudo tee /var/www/html/index.html /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${title}</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; background: ${color}; color: #fff; margin: 0; padding: 40px; }
    img  { max-width: 500px; width: 90%; border-radius: 16px; border: 6px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
    small { opacity: .8; display: block; margin-top: 15px; }
  </style>
</head>
<body>
  <h1>${title}</h1>
  <img src="/animal.jpg" alt="${title}">
  <p><small>Served by: $(hostname)</small></p>
</body>
</html>
HTML

# 6. הפעלה וטעינה מחדש של Nginx
sudo systemctl enable --now nginx
sudo systemctl restart nginx