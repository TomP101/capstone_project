module "network" {
  source = "./modules/network"
}

module "compute" {
  source          = "./modules/compute"
  subnet_id       = module.network.subnet_id
  instance_sg_ids = module.network.sg_ids
  tag_name        = var.tag_name
  tg_arn          = module.network.tg_arn
}
