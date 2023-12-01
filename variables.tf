# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy the internet gateway structure
# -------------------------------------------------------
# Nadège LEMPERIERE, @20 november 2021
# Latest revision: 30 november 2023
# -------------------------------------------------------

# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type     = string
	nullable = false
}
variable "module" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type     = string
	default  = "unmanaged"
	nullable = false
}

# --------------------------------------------------------
# VPC identifiers
# --------------------------------------------------------
variable "vpc" {
	type     = string
	nullable = false
}
variable "route_tables" {
	type     = list(string)
	nullable = false
}

# -------------------------------------------------------
# Egress only
# -------------------------------------------------------
variable "egress_only" {
	type     = bool
	default  = true
	nullable = false
}