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
    bucket = "prod-group13"                   // Bucket from where to GET Terraform State
    key    = "prod-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                      // Region where bucket created
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
  source = "../../module2/global_vars"
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
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrk+A/268//QCkuBDew8gDwibJy7zDKnC/Z91uqpKYyzwOZqfe1Ki3o5lrLvYrNH4ofIxXCBpRIj6HBjKGMej2RgR8CDbZJ/WAeg8a3GTkWJeO6RN9Zn9DykVyTKJFNt2IVzKWgazF10N+/iqrFSpxC+TZaB3kU4dvtnQdeJDb64f2CvZORanBh78+tTF7APSKxeqWHNUjiIcyMg5gg5K3Nec/R26io6Z3anZfAHxHq/G26tQHpLnYPoclcyzTlcZByTo8AKXJ8aPTDzas3/XoPD2UuQhood64h7n9NZU4z9sBvSVhrFj3uTm36mcmSTHyBa5107bC8VPP/OKvuh/N ec2-user@ip-172-31-73-236.ec2.internal"
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
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_tokens = "required"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs6YvAGImddYQkMpAY5OdvlayPdmi4LSwS2j7ao/uhBr5d7seio/2QzUmGoo207VQ/MBu8L0A4+nVJ6gsHP+dBUxhffXA2tYG7AznlI6pUMzMEeBdsgDvcNxhiWjcBOUzz1G6y4TxUDFuX5aV91oW2pevpMsHi3Pla33mY+W+9vmycNGpsyl3AtT/Y/2VdsdPKAnLIVmhFjlRyvW39qMxJmy7jP83vgriutTCw1EswAqZramKDcRAWmwCHurSItCSMYzvCveIAgAbAjL4L6QyyragFSG4to9ZNW2lBZ5t0MsFq2L2+bT7rJ3qlK//Af1Xe7LblluRO6RqnyqzcUpqB ec2-user@ip-172-31-73-236.ec2.internal"
}


# Webserver deployment vm3
resource "aws_instance" "my_amazon3" {
  #count                       = data.terraform_remote_state.network.outputs.private_subnet_id
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key3.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_id[2]
  security_groups             = [aws_security_group.albsg.id, aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
  }


  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-Linux"
    }
  )
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "key3" {
  key_name   = "key3"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCWKpt0TUvA/h2SbDzZf7/i2WgnB5LjeBiFED+BxeJg7CqZzYBbYErZLP316TeKoSxAkWw1xz1NWRAwFnoh2H4WUyrP5KzYc0VCzhCfTiqcSNBq0wc5Sm0tBPjyyU4Z9cDGllIcMxh2BI1FZpW6vHVSTR1NmfQVU155ihx0hdAHeN0SU3B5Kb8IRT3Wg8UpA5INj/SaC9P36kKi9Efz1gnk1d1a2avflR+ztg3qUgPxfbGnfajO+F/nPDvSfhxPCJVPUvkz+SHtE+H4OKV7qdhwB5gpfE666ecl9Xqt2EboqMcupcFeHGGOiEklveCoSAYU2GAZKa97aH0f68XX9oBr ec2-user@ip-172-31-73-236.ec2.internal"
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
    cidr_blocks      = ["172.31.73.236/32"]
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
  key_name                    = aws_key_pair.key2b.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true


  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
  }


  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion"
    }
  )
}

resource "aws_key_pair" "key2b" {
  key_name   = "key2b" #local.name_prefix
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs6YvAGImddYQkMpAY5OdvlayPdmi4LSwS2j7ao/uhBr5d7seio/2QzUmGoo207VQ/MBu8L0A4+nVJ6gsHP+dBUxhffXA2tYG7AznlI6pUMzMEeBdsgDvcNxhiWjcBOUzz1G6y4TxUDFuX5aV91oW2pevpMsHi3Pla33mY+W+9vmycNGpsyl3AtT/Y/2VdsdPKAnLIVmhFjlRyvW39qMxJmy7jP83vgriutTCw1EswAqZramKDcRAWmwCHurSItCSMYzvCveIAgAbAjL4L6QyyragFSG4to9ZNW2lBZ5t0MsFq2L2+bT7rJ3qlK//Af1Xe7LblluRO6RqnyqzcUpqB ec2-user@ip-172-31-73-236.ec2.internal"
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
    cidr_blocks      = ["172.31.73.236/32"]
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
    cidr_blocks = ["172.31.73.236/32"]
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
    cidr_blocks = ["172.31.73.236/32"]
  }
}


#launch config
resource "aws_launch_configuration" "prod" {
  name_prefix                 = "prod-"
  image_id                    = "ami-087c17d1fe0178315"
  instance_type               = "t3.small"
  key_name                    = "key2"
  security_groups             = ["${aws_security_group.bastion_sg.id}"]
  associate_public_ip_address = false
  #user_data = templatefile("${path.module}/install_httpd.sh.tpl"
  #user_data = "${file("data.sh")}"
  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_tokens = "required"
  }
}


#auto scaling groups
resource "aws_autoscaling_group" "prod" {
  name             = "${aws_launch_configuration.prod.name}-asg"
  min_size         = 1
  desired_capacity = 3
  max_size         = 4

  health_check_type = "ELB"
  #load_balancers = [
  # "${aws_elb.web_elb.id}"
  #]
  launch_configuration = aws_launch_configuration.prod.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    "${data.terraform_remote_state.network.outputs.private_subnet_id[0]}",
    "${data.terraform_remote_state.network.outputs.private_subnet_id[1]}",
    "${data.terraform_remote_state.network.outputs.private_subnet_id[2]}"

  ]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "prod"
    propagate_at_launch = true
  }
}


#auto scaling policy
resource "aws_autoscaling_policy" "prod_policy_up" {
  name                   = "prod_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.prod.name
}
resource "aws_cloudwatch_metric_alarm" "prod_cpu_alarm_up" {
  alarm_name          = "prod_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.prod.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.prod_policy_up.arn}"]
}
resource "aws_autoscaling_policy" "prod_policy_down" {
  name                   = "prod_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.prod.name
}
resource "aws_cloudwatch_metric_alarm" "prod_cpu_alarm_down" {
  alarm_name          = "prod_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.prod.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.prod_policy_down.arn}"]
}