
module "my_vpc" {
  source                     = "./modules/vpc"
  cidr_block                 = var.cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

}


module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.my_vpc.vpc_id

}


module "ec2" {
  source                = "./modules/ec2"
  sg_id                 = module.security_group.sg_id
  subnet_id             = module.my_vpc.public_subnet_id
  instance_profile_name = module.security_group.bastion-profile
}

module "iam" {
  source = "./modules/iam"
}


module "eks" {
  source = "./modules/my_eks"

  cluster_name       = "demo-eks"
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  subnet_ids         = module.my_vpc.private_subnet_ids
  kubernetes_version = "1.30"

  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]
}

