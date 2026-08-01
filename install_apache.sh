#!/bin/bash

sudo -i
apt update -y
apt install apache2 -y
systemctl start apache2 -y
systemctl enable apache2
echo "<html><body> <h1> Hello TERRAFORM RUNNING on server </h1> </body></html>" > /var/www/html/index.html