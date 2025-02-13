variable "project_name" {
  type    = string
  default = "gatus-uptime"
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

variable "keyholding_cert_arn" {
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

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "repository_name" {
  type = string
}