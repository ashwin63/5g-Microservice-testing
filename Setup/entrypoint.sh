#!/bin/bash

# Exit if any command fails
set -e

# Update and install necessary packages
apt-get update
apt-get install -y wget git curl python3 python3-pip python3.10-venv

# Clone repositories
git clone https://github.com/sathiyajith/foREST.git
git clone https://github.com/ashwin63/5g-Microservice-testing.git

# Setup Python virtual environment
python3 -m venv /venv
source /venv/bin/activate

# Install Python dependencies
pip install allpairspy
cd foREST
pip install -r requirements.txt

# Keep the container running
while true; do
  echo 'Container is running'
  sleep 60
done
