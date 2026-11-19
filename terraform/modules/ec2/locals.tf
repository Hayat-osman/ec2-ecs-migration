# User data script for EC2 instance
locals {
  user_data = <<-EOF
#!/bin/bash
set -euo pipefail

# Variables
APP_DIR="/opt/flask-app"
S3_BUCKET="${aws_s3_bucket.app.id}"
S3_KEY="app.zip"

# Install dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get upgrade -y -qq
apt-get install -y -qq awscli python3.11 python3.11-venv python3-pip nginx git curl wget unzip

# Create application directory
mkdir -p $APP_DIR
mkdir -p /var/log/flask-app
chown ubuntu:ubuntu $APP_DIR
chown ubuntu:ubuntu /var/log/flask-app

# Download application from S3
aws s3 cp s3://$S3_BUCKET/$S3_KEY /tmp/app.zip
cd /tmp
unzip -q app.zip -d $APP_DIR/
rm app.zip

# Set ownership
chown -R ubuntu:ubuntu $APP_DIR

# Run setup script (as root, script handles permissions)
cd $APP_DIR
chmod +x scripts/setup.sh
bash $APP_DIR/scripts/setup.sh

# Signal completion
echo "Application setup completed at $(date)" >> /var/log/user-data.log
  EOF
}


