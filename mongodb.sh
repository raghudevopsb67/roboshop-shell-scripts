LOG_FILE=/tmp/mongodb

source common.sh

echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatusCheck $?

echo "Installing MongoDB Server"
yum install -y mongodb-org &>>$LOG_FILE
StatusCheck $?

echo "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatusCheck $?

echo "Starting MongoDB Service"
systemctl enable mongod &>>$LOG_FILE && systemctl restart mongod &>>$LOG_FILE
StatusCheck $?

echo "Downloading MongoDb Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /tmp
echo "Extract Schema File"
unzip -o mongodb.zip &>>$LOG_FILE
StatusCheck $?

cd mongodb-main

echo "Load Schema"
for schema in catalogue.js users.js ; do
  mongo < ${schema} &>>$LOG_FILE
done



