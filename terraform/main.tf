
module "ecs" {
  source             = "./ecs"
  project_name       = var.project_name
  vpc_id             = var.vpc_id
  region             = var.region
  container_image    = var.container_image
  env                = terraform.workspace
  db_password       = var.db_password
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
  db_username          = var.db_username
  db_password          = var.db_password
  db_name              = var.db_name
}

module "ecr" {
  source = "./ecr"
  repository_name = var.repository_name    
  region          = var.region      
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "rds_host" {
  value = module.database.rds_host
}

output "rds_port" {
  value = module.database.rds_port
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}
