# Security Group
variable "ingressports" {
  type    = list(number)
  default = [8080, 22]
}

resource "aws_security_group" "jenkins-sg" {
  name        = "Allow Jenkins web traffic"
  description = "inbound ports for ssh and standard http and everything outbound"
  vpc_id      = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.ingressports
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name"      = "Jenkins-sg"
    "Terraform" = "true"
  }
}

#ec2 and jenkins install

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]

}

resource "aws_iam_instance_profile" "jenkins-vm-iam-profile" {
  name = "jenkins_vm_profile"
  role = aws_iam_role.jenkins-vm-iam-role.name
}
resource "aws_iam_role" "jenkins-vm-iam-role" {
  name               = "jenkins-vm-role"
  description        = "The role for the developer resources EC2"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": {
  "Effect": "Allow",
  "Principal": {"Service": "ec2.amazonaws.com"},
  "Action": "sts:AssumeRole"
  }
  }
  EOF
  tags = {
    "Name" = "Jenkins"
  }
}
resource "aws_iam_role_policy_attachment" "jenkins-vm-ssm-policy" {
  role       = aws_iam_role.jenkins-vm-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins_eip.id
}

resource "aws_eip" "jenkins_eip" {
  domain = "vpc"
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins-vm-iam-profile.name
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install docker epel java-openjdk11 -y
  service docker start

  yum update -y
  yum remove java-1.7.0-openjdk -y
  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  yum install jenkins -y
  service jenkins start
  systemctl enable jenkins
  systemctl enable docker
  chkconfig --add jenkins
  groupadd docker
  usermod -aG docker jenkins
  curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/darwin/amd64/kubectl
  chmod +x ./kubectl
  mv kubectl /usr/sbin
  EOF

  tags = {
    "Name" = "Jenkins"
  }
}
                  