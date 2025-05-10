module "network" {
  source = "./modules/network"
}

module "iam" {
  source                   = "./modules/iam"
  instance_role_name       = "ecs-host-role"
  instance_profile_name    = "ecs-host-profile"
  task_execution_role_name = "ecs-task-exec-role"
}

module "compute" {
  source                = "./modules/compute"
  cluster_name          = "petclinic-cluster"
  instance_type         = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
  subnet_ids            = [ module.network.subnet_id ]
  instance_sg_ids       = module.network.sg_ids
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  tag_name              = var.tag_name
}
