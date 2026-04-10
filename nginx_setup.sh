#!/bin/bash

# 1. Update system and install Nginx
echo "Updating system and installing Nginx..."
sudo apt update
sudo apt install -y nginx

# 2. Create directory for the website
echo "Creating directory for MBA Maker's Studio..."
sudo mkdir -p /var/www/mba-studio
sudo chown -R $USER:$USER /var/www/mba-studio

# 3. Configure Nginx
echo "Configuring Nginx..."
sudo bash -c 'cat > /etc/nginx/sites-available/mba-studio <<EOF
server {
    listen 80;
    server_name _;  # Listens on all IP addresses (you can replace this with your domain later)

    root /var/www/mba-studio;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Optimization for media files
    location ~* \.(mp4|jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF'

# 4. Enable the site
echo "Enabling site..."
sudo ln -sf /etc/nginx/sites-available/mba-studio /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 5. Test and Restart Nginx
echo "Restarting Nginx..."
sudo nginx -t
sudo systemctl restart nginx

echo "---------------------------------------------------"
echo "Setup Complete! Your web server is ready."
echo "You can now upload your files to /var/www/mba-studio"
echo "---------------------------------------------------"
