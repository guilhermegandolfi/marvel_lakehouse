variable "env" {

}

variable "environment" {
  type = map(string)
  default = {
    "dev" = "dev"
    "hmg" = "hmg"
    "prd" = "prd"
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_tags" {
  type = map(string)
  default = {
    "Owner"        = "Guilherme Gandolfi"
    "Data Project" = "Marvel Data Lakehouse"
  }

}