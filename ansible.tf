module "ansible_instance" {
  source               = "./modules/ec2"
  ami                  = "ami-018ba43095ff50d08"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc_main.public_subnets[1]
  iam_instance_profile = "ec2-ansible"
  ec2_name             = "ansible"
  ec2_role_name        = "ansibleEC2Role"
  ec2_security_group_name = "ansible-sg"
  user_data = data.template_file.ansible_userdata.rendered
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

data "template_file" "ansible_userdata" {
  template = file("${abspath(path.module)}/ansible_userdata.sh")
  
}

resource "aws_security_group_rule" "ansible_ssh" {
  security_group_id = module.ansible_instance.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ansible_egress_rule" {
  security_group_id =module.ansible_instance.security_group_id
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"  
  cidr_blocks = ["0.0.0.0/0"]
}










