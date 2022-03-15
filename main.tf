# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Module to deploy the internet gateway structure
# -------------------------------------------------------
# Nadège LEMPERIERE, @20 november 2021
# Latest revision: 20 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Create the internet gateway
# -------------------------------------------------------
resource "aws_egress_only_internet_gateway" "egress_gateway" {

    count = var.egress_only ? 1 : 0
	vpc_id = var.vpc

  	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.internet"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

resource "aws_internet_gateway" "gateway" {

    count = var.egress_only ? 0 : 1
	vpc_id = var.vpc

  	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.internet"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -------------------------------------------------------
# Add it to the route tables that need internet access
# -------------------------------------------------------
resource "aws_route" "gateway_route" {

	count = length(var.route_tables)

  	route_table_id         	    = var.route_tables[count.index]
	destination_cidr_block      = var.egress_only ? null : "0.0.0.0/0"
    destination_ipv6_cidr_block = var.egress_only ? "::/0" : null
    egress_only_gateway_id      = var.egress_only ? aws_egress_only_internet_gateway.egress_gateway[0].id : null
	gateway_id 				    = var.egress_only ? null : aws_internet_gateway.gateway[0].id
}