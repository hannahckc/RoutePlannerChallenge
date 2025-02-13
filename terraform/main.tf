
module "ecs" {
  source             = "./ecs"
  project_name       = var.project_name
  public_subnets     = var.public_subnets
  vpc_id             = var.vpc_id
  region             = var.region
  container_image    = var.container_image
  env                = terraform.workspace
  db_password        = var.db_password
  db_host            = module.database.rds_host
}

module "database" {
  source = "./rds"

  env                  = terraform.workspace
  allocated_storage    = 30
  instance_class       = terraform.workspace == "production" ? "db.t3.small" : "db.t3.micro"
  retention_days       = terraform.workspace == "production" ? 7 : 3
  engine_version       = 16.3
  app_name             = var.project_name
  db_subnet_group_name = var.db_subnet_group_name
  vpc_id               = var.vpc_id
  db_username             = var.db_username
  db_password          = var.db_password
  ingress_access = {
    gatus = { name : "gatus uptime monitor", sg_id : module.ecs.security_group_id }
  }
}

module "ecr" {
  source = "./ecr"
  repository_name = var.repository_name    
  region          = var.region      
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "security_group_id_ecs" {
  value = module.ecs.security_group_id
}

output "security_group_id_rds" {
  value = module.database.security_group_id
}

output "rds_host" {
  value = module.database.rds_host
}

output "rds_port" {
  value = module.database.rds_port
}
