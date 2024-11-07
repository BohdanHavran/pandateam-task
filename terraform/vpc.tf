module "vpc" {
  source      = "./modules/vpc"
  enabled     = true
  name        = "panda-team-vpc-task"
  region      = "fra1"
  ip_range    = "10.10.0.0/16"
  description = "VPC Panda Team Task"
}