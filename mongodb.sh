#!bin/bash

user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
Log_folder="/var/log/shellop-log"
script=$(echo $0 | cut -d "." -f1)
log_file="$Log_folder/$script.log"


mkdir -p $Log_folder
echo "script started at :$(date)" | tee -a $log_file 
if [ $user -ne 0 ]
then  
   echo -e "$R error: user doesn't have root accesss:$N" | tee -a $log_file  
   exit 1
else 
   echo "you are running with root access" | tee -a $log_file 
fi
#chekcing the installled pkgs
VALIDATE () {
    if [ $1 -eq 0 ]
    then 
      echo  -e "installing $2 is .. $G suucess $N" | tee -a $log_file 
    else 
      echo  -e "installing $2 is .. $R Failure $N" | tee -a $log_file 
      exit 1
    fi
}

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Copying MongoDB repo"

dnf install mongodb-org -y &>>$log_file
VALIDATE $? "Installing mongodb server"

systemctl enable mongod &>>$log_file
VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>>$log_file
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing MongoDB conf file for remote connections"

systemctl restart mongod &>>$log_file
VALIDATE $? "Restarting MongoDB"