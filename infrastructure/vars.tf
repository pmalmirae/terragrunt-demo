/******************************
# Variables to be used with the infrastructure code
******************************/

variable "name" {
  type        = string
  description = "Name of the company or the platform to build etc." 
}

variable "environment" {
  type        = string
  description = "Name of the environment/stack"
}

variable "aws_region" {
  type    = string
  description = "AWS Region" 
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID" 
}

