module "db_instance" {
  source               = "./modules/ec2"
  ami                  = "ami-018ba43095ff50d08"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc_main.private_subnets[1]
  iam_instance_profile = "ec2-database"
  ec2_name             = "database"
  ec2_role_name        = "databaseEC2Role"
  ec2_security_group_name = "database-sg"
  user_data = data.template_file.db_userdata.rendered
  key_name = "CHANGEMEPLEASE"
  assume_role_policy   = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
    }
    }
  ]
}
EOT

  vpc_id              = module.vpc_main.vpc_id
  environment         = "development"
}

data "template_file" "db_userdata" {
  template = file("${abspath(path.module)}/db_userdata2.sh")
  
}

resource "aws_security_group_rule" "db_ssh" {
  security_group_id = module.db_instance.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.webserver_instance.security_group_id
}

resource "aws_security_group_rule" "db_ssh_ansible" {
  security_group_id = module.db_instance.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_instance.security_group_id
}

resource "aws_security_group_rule" "db_mysql" {
  security_group_id = module.db_instance.security_group_id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.webserver_instance.security_group_id
}

resource "aws_security_group_rule" "ansible_mysql" {
  security_group_id = module.db_instance.security_group_id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.ansible_instance.security_group_id
}

resource "aws_security_group_rule" "db_egress_rule" {
  security_group_id =module.db_instance.security_group_id
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"  
  cidr_blocks = ["0.0.0.0/0"]
}




