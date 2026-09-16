#!/bin/bash

dnf install -y httpd php php-pgsql

systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<'HTML'
<h1>AWS Terraform Hands-on</h1>
<p>Created by Terraform</p>
HTML
