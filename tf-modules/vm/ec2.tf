# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-*"]
  }
}

# Key Pair for EC2 instances
resource "aws_key_pair" "main" {
  key_name   = "${var.name_prefix}-key"
  public_key = file(var.public_key_path)
}

# EC2 Instance 1 (foo) - with public IP
resource "aws_instance" "foo" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = var.public_subnet_id

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install --upgrade pip
    pip3 install ansible
  EOF

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-foo"
    Role = "web-server"
  })
    
}

# EC2 Instance 2 (bar)
resource "aws_instance" "bar" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.internal.id]
  subnet_id              = var.private_subnet_id 

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install --upgrade pip
    pip3 install ansible
  EOF

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bar"
    Role = "internal-server"
  })
}

# Elastic IP for foo instance
resource "aws_eip" "foo" {
  instance = aws_instance.foo.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-foo-eip"
  })
}

# Data source to get the existing hosted zone
data "aws_route53_zone" "main" {
  name         = "securityoncloud.com"
  private_zone = false
}

# Route 53 A record pointing to the Elastic IP
resource "aws_route53_record" "webserver" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "webserver.securityoncloud.com"
  type    = "A"
  ttl     = 300
  records = [aws_eip.foo.public_ip]

  depends_on = [aws_eip.foo]
}