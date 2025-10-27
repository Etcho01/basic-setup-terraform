resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.custom_vpc1.id

  tags = {
    Name = "public-sg"
  }
}

# --- Ingress Rules ---
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow HTTP from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH from anywhere"
}

# --- Egress Rule ---
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allow all outbound traffic
  description       = "Allow all outbound IPv4 traffic"
}

resource "aws_instance" "public_ec2" {
  ami                         = "ami-0f9fa7cd5a3697470" # Amazon Linux 2 AMI (eu-west-1)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.custom_public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  key_name  = "wsl-terraform-key"
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello ITI from Terraform (Mohamed Hesham Mohamed)" > /var/www/html/index.html
              EOF
  tags = {
    Name = "public-ec2"
  }
}