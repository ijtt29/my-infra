module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.project_name}-instance"

  ami                    = "ami-058165de3b7202099"
  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.ec2_instance_security_group.security_group_id]
  subnet_id              = "${element(module.vpc.public_subnets, 0)}"

  user_data = <<EOF
#!/bin/bash
sudo su
apt-get update
apt-get upgrade
apt-get install net-tools
echo "[MIMO] MySQL Install"
apt-get install mysql-server -y
mysql --version
systemctl start mysql
systemctl enable mysql
echo "[MIMO] MySQL Install Succeed!!"
echo "[MIMO] Docker Install"
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
chmod 666 /var/run/docker.sock
EOF
}

module "ec2_instance_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  name   = "${var.project_name}-sg"
  description = "Security group for ${var.project_name}"

  ingress_cidr_blocks = [
    "0.0.0.0/0"]
  ingress_rules = [
    "ssh-tcp",
    "mysql-tcp"
    ]
  egress_rules = [
    "all-all"]
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "${var.project_name}-common"
  create_private_key = true
}

resource "aws_eip" "instance" {
  instance = module.ec2_instance.id
  vpc      = true
}