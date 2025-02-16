variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "db_subnet_group_name" {
  type = string
}

variable "engine_version" {
  type = number
}

variable "retention_days" {
  type = number
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "app_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}