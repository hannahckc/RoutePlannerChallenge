variable "project_name" {
  type    = string
  default = "route-planner"
}

variable "db_name" {
  type = string
  default = "gatedb"
}

variable "repository_name" {
  type = string
  default = "flask-app-repo"
}

variable "env" {
  type    = string
  default = "testing"
}

variable "region" {
  default = "eu-north-1"
}

variable "db_subnet_group_name" {
  type = string
  default = "default"
}

variable "public_subnets" {
  type = list(string)
}


variable "vpc_id" {
  type = string
}

variable "container_image" {
  type    = string
  default = ""
}

variable "db_password" {
  type = string
}

variable "db_username" {
  type = string
}


