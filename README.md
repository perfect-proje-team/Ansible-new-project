# Simple Web application with Database

- We create VPC (with subnets, route tables, igw, ngw, eip etc.) and 3 EC2 Instances (Webserver, database and Ansible)
- We use userdata for installing the tools we need

# How to run?

We can use two methods to run our application.

## First method (Create DB and table with user data)

- Change key name in 3 files (ansible.tf, db_instance.tf, webserver.tf)
- We should use db_userdata2.sh as userdata
- Run terraform

```bash
   terraform init
```

```bash
   terraform apply
```

- Connect to webserver via SSH
- Upload the /flaskapp folder in Webserver EC2
- Change IP in app.py (DB instance private IP)

- Run application in /flaskapp

```bash
   python3 app.py
```
- Open browser and see application
- Add sample user info 
- Check database

- Upload your pem file in Webserver EC2 (if need run chmod ...)

- In db server run following commands (password is in userdata)

```bash
mysql -u root -p
USE my_database;
SELECT * FROM users;
```

## Second method (Create DB and table manually)

### Deploy Infrastructure

- Change key name in 3 files (ansible.tf, db_instance.tf, webserver.tf)
- We should use db_userdata.sh as userdata
- Run terraform

```bash
   terraform init
```

```bash
   terraform apply
```

### Connect to Webserver and upload application files

- Connect to webserver via SSH
- Upload the /flaskapp folder in Webserver EC2
- Upload your pem file in Webserver EC2 (if need run chmod ...)

### Configure Database

- Connect to db server via ssh from webserver
- Connect to db (password is in userdata)

```bash
   mysql -u root -p
```

- create db (If any changes, then update also app.py)

```bash
   CREATE DATABASE my_database;
   USE my_database;
```
- Create a new table

```bash
   CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    country VARCHAR(100)
);
```

- create db user and permissions for flask app (If any changes, then update also app.py)

```bash
CREATE USER 'flask_user'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON my_database.* TO 'flask_user'@'%';
FLUSH PRIVILEGES;
```

### Run application

- Go to webserver instance and update db configuration in app.py (IP, password etc.)

```bash
   run python3 app.py
```
- Open browser and add sample users in web server 

- Connect to db server again and see them in db server

- In db server run flollowing commands

```bash
mysql -u root -p
SHOW DATABASES;
USE my_database;
SHOW TABLES;
DESCRIBE users;
SELECT * FROM users;
```



