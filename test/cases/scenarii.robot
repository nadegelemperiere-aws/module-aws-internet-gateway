# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 30 november 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check virtual private cloud creation
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.ec2
Library         ../keywords/data.py
Library         OperatingSystem

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${KEEPASS_ID_ENTRY}                 /aws/aws-sso-sysadmin-group-id
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve principal credential from database and initialize python tests keywords
    ${keepass_key}          Get Environment Variable          ${KEEPASS_KEY_ENV}
    ${principal_access}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            username
    ${principal_secret}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            password
    Initialize Terraform    ${REGION}   ${principal_access}   ${principal_secret}
    Initialize EC2          None        ${principal_access}   ${principal_secret}    ${REGION}

Create Standard Gateway
    [Documentation]         Create Standard Gateway
    Launch Terraform Deployment                 ${CURDIR}/../data/standard
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['vpc']['value']['id']}   ${states['test']['outputs']['vpc']['value']['routes']}   ${states['test']['outputs']['gateway']['value']}
    Internet Gateway Shall Exist And Match      ${specs['gateway']}
    Route Table Shall Exist And Match           ${specs['routes']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard

Create Egress Only Gateway
    [Documentation]         Create Egress Only Gateway
    Launch Terraform Deployment                 ${CURDIR}/../data/egress
    ${states}   Load Terraform States           ${CURDIR}/../data/egress
    ${specs}    Load Egress Only Test Data      ${states['test']['outputs']['vpc']['value']['id']}   ${states['test']['outputs']['vpc']['value']['routes']}   ${states['test']['outputs']['gateway']['value']}
    Internet Gateway Shall Exist And Match      ${specs['gateway']}
    Route Table Shall Exist And Match           ${specs['routes']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/egress
