#!/bin/bash

echo "Starting Nginx web server deployment..."

echo "Updating package list..."
sudo apt update -y

echo "Installing Nginx..."
sudo apt install nginx -y

echo "Starting Nginx service..."
sudo systemctl start nginx

echo "Enabling Nginx to start on boot..."
sudo systemctl enable nginx

echo "Creating custom web page..."
sudo tee /var/www/html/index.nginx-debian.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My AWS Web Server</title>
</head>
<body>
  <h1>Welcome to My AWS Web Server</h1>
  <p>Deployed by Eniola Dankuwo</p>
  <p>Deployment Date: June 2026</p>
  <p>This web server is running on an AWS EC2 instance using Nginx.</p>
</body>
</html>
EOF

echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Checking Nginx status..."
sudo systemctl status nginx --no-pager

echo "Deployment completed successfully."
