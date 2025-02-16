variable "project_name" {
  type    = string
}

variable "public_subnets" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "region" {
  default = "eu-north-1"
}

variable "vpc_id" {
  type = string
}

variable "container_image" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = "testing"
}

variable "db_password" {
  type = string
}

variable "db_username" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "db_name" {
  type = string
}