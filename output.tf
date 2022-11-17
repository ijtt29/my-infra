# VPC
output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    value = module.vpc.vpc_cidr_block
}


output "private_key_pem" {
    value = module.key_pair.private_key_pem
    sensitive = true
}

output "instance_eip" {
    value = aws_eip.instance.address
}