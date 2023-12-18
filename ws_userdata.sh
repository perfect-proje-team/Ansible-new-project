#!/bin/bash
# Update and install Python3 and pip
yum update -y
yum install -y python3 python3-pip
pip3 install flask
pip3 install pymysql

# Install Flask and Gunicorn
pip3 install flask gunicorn