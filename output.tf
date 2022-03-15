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

output "id" {
	value = var.egress_only ? aws_egress_only_internet_gateway.egress_gateway[0].id : aws_internet_gateway.gateway[0].id
}

output "arn" {
	value = var.egress_only ? null : aws_internet_gateway.gateway[0].arn
}