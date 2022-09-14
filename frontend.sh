echo Installing Nginx
yum install nginx -y

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

cd /usr/share/nginx/html

echo Removing Old Web Content
rm -rf *

echo Extracting Web Content
unzip /tmp/frontend.zip


mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting Nginx Service
systemctl enable nginx
systemctl restart nginx

