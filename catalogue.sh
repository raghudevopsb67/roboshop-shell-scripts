LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this script as root user or with sudo privileges.
  exit 1
fi

echo "Setup NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  echo "Add RoboShop Application User"
  useradd roboshop &>>${LOG_FILE}
  if [ $? -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
fi

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

cd /home/roboshop

echo "Clean Old App Content"
rm -rf catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "Start Catalogue Service"
systemctl start catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e Status = "\e[32mSUCCESS\e[0m"
else
  echo -e Status = "\e[31mFAILURE\e[0m"
  exit 1
fi
