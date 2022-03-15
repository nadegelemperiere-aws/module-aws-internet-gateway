# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Simple deployment for internet gateway testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


# -------------------------------------------------------
# Create a network
# -------------------------------------------------------
resource "aws_vpc" "test" {
	cidr_block  = "10.2.0.0/24"
   	tags 		= { Name = "test.vpc" }
}

# -------------------------------------------------------
# Create the default network route table
# -------------------------------------------------------
resource "aws_default_route_table" "test" {
	default_route_table_id	= aws_vpc.test.default_route_table_id
	tags 		= { Name = "test.vpc.route" }
}

# -------------------------------------------------------
# Create 2 other network route table
# -------------------------------------------------------
resource "aws_route_table" "tests" {

	count = 2
	vpc_id = aws_vpc.test.id
	tags   = { Name = "test.vpc.route${count.index}" }

}

# -------------------------------------------------------
# Create subnets using the current module
# -------------------------------------------------------
module "gateway" {

	source 			= "../../../"
	email 			= "moi.moi@moi.fr"
	project 		= "test"
	environment 	= "test"
	module 			= "test"
	git_version 	= "test"
	vpc 			= aws_vpc.test.id
	route_tables 	= concat([aws_default_route_table.test.id], aws_route_table.tests.*.id)
    egress_only     = false
}

# -------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------
provider "aws" {
	region		= var.region
	access_key 	= var.access_key
	secret_key	= var.secret_key
}

terraform {
	required_version = ">=1.0.8"
	backend "local"	{
		path="terraform.tfstate"
	}
}

# -------------------------------------------------------
# Region for this deployment
# -------------------------------------------------------
variable "region" {
	type    = string
}

# -------------------------------------------------------
# AWS credentials
# -------------------------------------------------------
variable "access_key" {
	type    	= string
	sensitive 	= true
}
variable "secret_key" {
	type    	= string
	sensitive 	= true
}

# -------------------------------------------------------
# Test outputs
# -------------------------------------------------------
output "vpc" {
	value = {
		id 		= aws_vpc.test.id
		routes 	= concat([aws_default_route_table.test.id], aws_route_table.tests.*.id)
	}
}

output "gateway" {
	value = {
		id = module.gateway.id
		arn = module.gateway.arn
	}
}
