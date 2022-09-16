LOG_FILE=/tmp/mongodb

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this script as root user or with sudo privileges.
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
}


echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo Status = $?

echo "Installing MongoDB Server"
yum install -y mongodb-org &>>$LOG_FILE
echo Status = $?

echo "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo Status = $?

echo "Starting MongoDB Service"
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
echo Status = $?

echo "Downloading MongoDb Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
echo Status = $?

cd /tmp
echo "Extract Schema File"
unzip mongodb.zip &>>$LOG_FILE
echo Status = $?

cd mongodb-main

echo "Load Catalogue Service Schema"
mongo < catalogue.js &>>$LOG_FILE
echo Status = $?

echo "Load Users Service Schema"
mongo < users.js &>>$LOG_FILE
echo Status = $?



