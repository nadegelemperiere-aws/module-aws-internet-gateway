# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check virtual private cloud creation
Library         technogix_iac_keywords.terraform
Library         technogix_iac_keywords.keepass
Library         technogix_iac_keywords.ec2
Library         ../keywords/data.py

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY}                      ${vault_key}
${KEEPASS_GOD_KEY_ENTRY}            /engineering-environment/aws/aws-god-access-key
${KEEPASS_ID_ENTRY}                 /engineering-environment/aws/aws-sso-sysadmin-group-id
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve god credential from database and initialize python tests keywords
    ${god_access}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            username
    ${god_secret}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            password
    Initialize Terraform    ${REGION}   ${god_access}   ${god_secret}
    Initialize EC2          None        ${god_access}   ${god_secret}    ${REGION}

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
