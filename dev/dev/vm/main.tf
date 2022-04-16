#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "dev-group13"                   // Bucket from where to GET Terraform State
    key    = "dev-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                     // Region where bucket created
  }
}


# Data source for availability zones in us-east-1
#data "aws_availability_zones" "available" {
# state = "available"
#}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/global_vars"
}





# Webserver deployment vm1
resource "aws_instance" "my_amazon" {
  #count                       = data.terraform_remote_state.network.outputs.private_subnet_id
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key1.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_id[0]
  security_groups             = [aws_security_group.albsg.id, aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "dev" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-Linux"
    }
  )
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "key1" {
  key_name   = "key1"
  public_key = file("/home/ec2-user/environment/GIT/FinalProjectGroup13/dev/dev/vm/key1.pub")
}


# Webserver deployment vm2
resource "aws_instance" "my_amazon2" {
  #count                       = data.terraform_remote_state.network.outputs.private_subnet_id
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key2.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_id[1]
  security_groups             = [aws_security_group.web_sg.id, aws_security_group.albsg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "dev" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-Linux"
    }
  )
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "key2" {
  key_name   = "key2" #local.name_prefix
  public_key = file("/home/ec2-user/environment/GIT/FinalProjectGroup13/dev/dev/vm/key2.pub")
}



# Security Group
resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      security_groups = [aws_security_group.bastion_sg.id]
      protocol        = "tcp"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-sg"
    }
  )
}



# Bastion deployment
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key2.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true


  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion"
    }
  )
}

resource "aws_key_pair" "key3" {
  key_name   = "key3" #local.name_prefix
  public_key = file("/home/ec2-user/environment/GIT/FinalProjectGroup13/dev/dev/vm/key2.pub")
}

# Security Group for Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "SSH from private IP of CLoud9 machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_private_ip}/32", "${var.my_public_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion-sg"
    }
  )
}



# Creating Security Group for ELB
resource "aws_security_group" "albsg" {
  name        = "LB Security Group"
  description = "LB"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#launch config
resource "aws_launch_configuration" "dev" {
  name_prefix = "dev-"
image_id = "amzn2-ami-hvm-*-x86_64-gp2" 
  instance_type = "t3.micro"
  key_name = "key2"
security_groups = [ "${aws_security_group.bastion_sg.id}" ]
  associate_public_ip_address = true
  #user_data = templatefile("${path.module}/install_httpd.sh.tpl"
  #user_data = "${file("data.sh")}"
lifecycle {
    create_before_destroy = true
  }
}


#auto scaling groups
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"
  min_size             = 1
  desired_capacity     = 3
  max_size             = 4
  
  health_check_type    = "ELB"
  #load_balancers = [
   # "${aws_elb.web_elb.id}"
  #]
launch_configuration = "${aws_launch_configuration.dev.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
       "${data.terraform_remote_state.network.outputs.private_subnet_id[0]}",
       "${data.terraform_remote_state.network.outputs.private_subnet_id[1]}"
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
    key                 = "Name"
    value               = "dev"
    propagate_at_launch = true
  }
}


#auto scaling policy
resource "aws_autoscaling_policy" "dev_policy_up" {
  name = "dev_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev.name}"
}
resource "aws_cloudwatch_metric_alarm" "dev_cpu_alarm_up" {
  alarm_name = "dev_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.dev.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.dev_policy_up.arn}" ]
}
resource "aws_autoscaling_policy" "dev_policy_down" {
  name = "dev_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev.name}"
}
resource "aws_cloudwatch_metric_alarm" "dev_cpu_alarm_down" {
  alarm_name = "dev_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.dev.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.dev_policy_down.arn}" ]
}