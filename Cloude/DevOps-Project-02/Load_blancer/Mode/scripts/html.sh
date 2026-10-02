#!/bin/bash
set -eux

sudo dnf update -y
sudo dnf install -y nginx


sudo mkdir -p /var/www/html
sudo mkdir -p /usr/share/nginx/html

sudo rm -f /usr/share/nginx/html/index.html



sudo curl -sSL -o /var/www/html/animal.jpg "${image_base_url}/${image_file}" || true
sudo cp /var/www/html/animal.jpg /usr/share/nginx/html/animal.jpg || true


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

sudo systemctl enable --now nginx
sudo systemctl restart nginx

#add
