variable "project_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}


variable "region" {
  type = string
}

variable "container_image" {
  type = string
}

variable "env" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_username" {
  type = string
}