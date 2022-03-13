# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 13 november 2021
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Standard Test Data')
def load_standard_test_data(vpc, routes, gateway) :

    result = {}

    result['gateway'] = []
    result['gateway'].append({})
    result['gateway'][0]['name'] = 'standard'
    result['gateway'][0]['data'] = {}
    result['gateway'][0]['data']['Attachments'] = []
    result['gateway'][0]['data']['Attachments'].append({'State' : 'available', 'VpcId' : vpc})
    result['gateway'][0]['data']['InternetGatewayId'] = gateway['id']
    result['gateway'][0]['data']['EgressOnly'] = False
    result['gateway'][0]['data']['Tags'] = []
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.internet'})

    result['routes'] =  []
    for index, identifier in enumerate(routes) :
        route = {}
        route['name'] = 'route-' + str(index)
        route['data'] = {}
        route['data']['VpcId'] = vpc
        route['data']['RouteTableId'] = identifier
        route['data']['Routes'] = [
            {"DestinationCidrBlock": "0.0.0.0/0", "GatewayId": gateway['id'], "Origin": "CreateRoute", "State": "active"}
        ]

        result['routes'].append(route)

    logger.debug(dumps(result))

    return result


@keyword('Load Egress Only Test Data')
def load_egress_only_test_data(vpc, routes, gateway) :

    result = {}

    result['gateway'] = []
    result['gateway'].append({})
    result['gateway'][0]['name'] = 'standard'
    result['gateway'][0]['data'] = {}
    result['gateway'][0]['data']['Attachments'] = []
    result['gateway'][0]['data']['Attachments'].append({'State' : 'attached', 'VpcId' : vpc})
    result['gateway'][0]['data']['InternetGatewayId'] = gateway['id']
    result['gateway'][0]['data']['EgressOnly'] = True
    result['gateway'][0]['data']['Tags'] = []
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result['gateway'][0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.internet'})

    result['routes'] =  []
    for index, identifier in enumerate(routes) :
        route = {}
        route['name'] = 'route-' + str(index)
        route['data'] = {}
        route['data']['VpcId'] = vpc
        route['data']['RouteTableId'] = identifier
        route['data']['Routes'] = [
            {"DestinationIpv6CidrBlock": "::/0", "EgressOnlyInternetGatewayId": gateway['id'], "Origin": "CreateRoute", "State": "active"}
        ]

        result['routes'].append(route)

    logger.debug(dumps(result))

    return result