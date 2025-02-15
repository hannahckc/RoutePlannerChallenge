variable "instance_class" {}
variable "allocated_storage" {}
variable "db_subnet_group_name" {}
variable "engine_version" {}
variable "retention_days" {}
variable "env" {}
variable "vpc_id" {}
variable "app_name" {}
variable "ingress_access" {
    type = map(object({name = string, sg_id = string}))
}
variable "password" {
  type = string
}

variable "username" {
  type = string
}