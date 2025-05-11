module "network" {
  source = "./modules/network"
}

module "policies" {
  source                    = "./modules/policies"
  instance_role_name        = "ecs-host-role"
  instance_profile_name     = "ecs-host-profile"
  task_execution_role_name  = "ecs-task-exec-role"
}

module "compute" {
  source                = "./modules/compute"
  cluster_name          = "petclinic-cluster"
  ami_id                = "ami-050504a7010a3a2f0" 
  instance_type         = var.instance_type
  instance_profile_name = module.policies.instance_profile_name
  subnet_ids            = [ module.network.subnet_id ]
  instance_sg_ids       = module.network.sg_ids
  execution_role_arn    = module.policies.task_execution_role_arn
  task_role_arn         = module.policies.task_role_arn
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  tag_name              = var.tag_name
  target_group_arn      = module.network.tg_arn

  key_name              = "prywatny_tomek_aws"
}
