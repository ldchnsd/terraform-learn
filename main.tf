provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"  
  }
}

module "myapp-server" {
  source = "./modules/webserver"
  my_ip = var.my_ip
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  env_prefix = var.env_prefix
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  avail_zone = var.avail_zone
}
