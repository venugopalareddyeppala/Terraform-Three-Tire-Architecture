########################
### variable for vpc ###
########################

variable "vpc_cidr" {
  default     = "171.0.0.0/16"
  description = "cidr for vpc"
  type        = string
}

###########################
### variable for subnet ###
###########################

variable "public_subnet1_cidr" {
  default     = "171.0.0.0/25"
  description = "cidr for public subnet1"
  type        = string
}

variable "public_subnet2_cidr" {
  default     = "171.0.2.0/25"
  description = "cidr for public subnet2"
  type        = string
}

variable "private_subnet3_cidr" {
  default     = "171.0.4.0/25"
  description = "cidr for private subnet3"
  type        = string
}

variable "private_subnet4_cidr" {
  default     = "171.0.6.0/25"
  description = "cidr for public subnet4"
  type        = string
}

variable "private_subnet5_cidr" {
  default     = "171.0.8.0/25"
  description = "cidr for public subnet5"
  type        = string
}

variable "private_subnet6_cidr" {
  default     = "171.0.10.0/25"
  description = "cidr for public subnet6"
  type        = string
}

################################
### variable for db instance ###
################################

variable "db_instance_class" {
  default     = "db.t3.micro"
  description = "cidr for public subnet1"
  type        = string
}