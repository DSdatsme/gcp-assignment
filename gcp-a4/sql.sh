#!/bin/bash
echo "enter a name for sql instance"
read mySqlInstance
#echo "enter database name"
#read myDatabaseName
#echo "enter table name"
#read myTableName
#echo "enter user name"
#read myUserName
echo "creating SQL instance....."
gcloud sql instances create "$mySqlInstance" --tier=db-f1-micro --region=us-central1
echo "creating Database....."
gcloud sql databases create employee_management --instance="$mySqlInstance"
echo "creating user....."
gcloud sql users create application_user --instance "$mySqlInstance"
echo "fetching IP of SQL instance......"
myIp=`gcloud sql instances describe "$mySqlInstance" --format="value(ipAddresses.ipAddress)"`
gcloud sql connect "$mySqlInstance" --user=root<< EOF
USE employee_management;
CREATE TABLE employee_details (emp_name VARCHAR(10), emp_role VARCHAR(10));
INSERT INTO employee_details VALUES ('ABC', 'small');
INSERT INTO employee_details VALUES ('DEF', 'mid');
INSERT INTO employee_details VALUES ('GHI', 'small');
INSERT INTO employee_details VALUES ('JKL', 'big');
INSERT INTO employee_details VALUES ('MNO', 'small');
SELECT * FROM employee_details;
UPDATE employee_details SET emp_role='PE' WHERE emp_name=='DEF';
SELECT * FROM employee_details;
DELETE FROM employee_details WHERE emp_name=='MNO';
SELECT * FROM employee_details;
GRANT SELECT, INSERT on employee_management.employee_details to application_user;
SHOW GRANTS application_user;
REVOKE SELECT, INSERT on employee_management.employee_details from application_user;
SHOW GRANTS application_user;
EOF