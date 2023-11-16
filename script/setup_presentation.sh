#!/bin/bash

# Sets up a MillsMap server.
# Tested on a $10/month Digital Ocean droplet with Ubuntu 20.04 installed.

# Assumes a non-root sudo user called millsmap.

# Prompt the user for input
echo "Please enter the IP address of your server:"
read ip_address
echo

# Update and upgrade the operating system
echo "Updating and upgrading the OS"
sudo apt -y update
sudo apt -y upgrade

# Install Python dependencies
echo "Setting up a few random Python dependencies"
sudo apt install -y build-essential libssl-dev libffi-dev python3-setuptools

# Set up virtualenv and Flask infrastructure
echo "Setting up virtualenv and Flask infrastructure"
sudo apt install -y python3-venv
sudo apt install -y python3-dev
python3 -m venv venv
source venv/bin/activate
pip install wheel flask flask-wtf requests pandas matplotlib uwsgi apscheduler

# Install Nginx
echo "Installing Nginx"
if ! type "nginx"; then
    sudo apt install -y nginx
else
    echo "Nginx seems to be already installed"
fi

# Add the Web map site to Nginx
echo "Adding the Web map site to Nginx"
cat > millsmap <<EOF
server {
    listen 80;
    server_name $ip_address;

    location / {
        include uwsgi_params;
        uwsgi_pass unix:/home/millsmap/MillsMap/millsmap.sock;
    }
}
EOF

sudo mv millsmap /etc/nginx/sites-available/

# Create a symlink to millsmap site in Nginx sites-enabled
echo "Creating symlink to millsmap site in Nginx sites-enabled"
if [ ! -f /etc/nginx/sites-enabled/millsmap ]; then
    sudo ln -s /etc/nginx/sites-available/millsmap /etc/nginx/sites-enabled
else
    echo "Looks like the symlink has already been created"
fi

# Restart Nginx for changes to take effect
sudo systemctl restart nginx

# Add the MillsMap service to Systemd
echo "Adding the MillsMap service to Systemd"
cat > millsmap.service <<EOF
[Unit]
Description=uWSGI instance to serve millsmap
After=network.target

[Service]
User=millsmap
Group=www-data
WorkingDirectory=/home/millsmap/MillsMap
Environment="PATH=/home/millsmap/MillsMap/venv/bin"
ExecStart=/home/millsmap/MillsMap/venv/bin/uwsgi --ini millsmap.ini

[Install]
WantedBy=multi-user.target
EOF

sudo mv millsmap.service /etc/systemd/system/

# Start and enable the MillsMap service with Systemd
echo "Starting and enabling the MillsMap service with Systemd"
sudo systemctl start millsmap.service
sudo systemctl enable millsmap.service

