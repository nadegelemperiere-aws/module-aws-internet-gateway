.. image:: docs/imgs/logo.png
   :alt: Logo

=================================
Technogix internet gateway module
=================================

About The Project
=================

This project contains all the infrastructure as code (IaC) to deploy an internet gateway

.. image:: https://badgen.net/github/checks/technogix-terraform/module-aws-internet-gateway
   :target: https://github.com/technogix-terraform/module-aws-internet-gateway/actions/workflows/release.yml
   :alt: Status
.. image:: https://img.shields.io/static/v1?label=license&message=MIT&color=informational
   :target: ./LICENSE
   :alt: License
.. image:: https://badgen.net/github/commits/technogix-terraform/module-aws-internet-gateway/main
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Commits
.. image:: https://badgen.net/github/last-commit/technogix-terraform/module-aws-internet-gateway/main
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Last commit

Built With
----------

.. image:: https://img.shields.io/static/v1?label=terraform&message=1.1.7&color=informational
   :target: https://www.terraform.io/docs/index.html
   :alt: Terraform
.. image:: https://img.shields.io/static/v1?label=terraform%20AWS%20provider&message=4.4.0&color=informational
   :target: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
   :alt: Terraform AWS provider

Getting Started
===============

Prerequisites
-------------

N.A.

Configuration
-------------

To use this module in a wider terraform deployment, add the module to a terraform deployment using the following module:

.. code:: terraform

    module "gateway" {

        source       = "git::https://github.com/technogix-terraform/module-aws-internet-gateway?ref=<this module version>"
        project      = the project to which the permission set belongs to be used in naming and tags
        module       = the project module to which the permission set belongs to be used in naming and tags
        email        = the email of the person responsible for the permission set maintainance
        environment  = the type of environment to which the permission set contributes (prod, preprod, staging, sandbox, ...) to be used in naming and tags
        git_version  = the version of the deployment that uses the permission sets to be used as tag
        vpc          = the identifier of the vpc to which the gateway shall be associated
        route_tables = [ the list of route tables identifier to which the internet gateway shall be associated ]
        egress_only  = true if the internet gateway shall not allow flows initiated from the outside
    }

Usage
-----

The module is deployed alongside the module other terraform components, using the classic command lines :

.. code:: bash

    terraform init ...
    terraform plan ...
    terraform apply ...

Detailed design
===============

.. image:: docs/imgs/module.png
   :alt: Module architecture

Module creates an internet gateway or an "egress only" internet gateway depending on the egress_only variable.

It adds a route to internet in all the provided route tables.


.. IMPORTANT::
    Having a route between a vpc and the internet gateway is a mandatory condition to provide internet access to the vpc resources, but it is not enough. Security groups and access control list controlling resources shall still allow internet access.

Testing
=======

Tested With
-----------


.. image:: https://img.shields.io/static/v1?label=technogix_iac_keywords&message=v1.0.0&color=informational
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Technogix iac keywords
.. image:: https://img.shields.io/static/v1?label=python&message=3.10.2&color=informational
   :target: https://www.python.org
   :alt: Python
.. image:: https://img.shields.io/static/v1?label=robotframework&message=4.1.3&color=informational
   :target: http://robotframework.org/
   :alt: Robotframework
.. image:: https://img.shields.io/static/v1?label=boto3&message=1.21.7&color=informational
   :target: https://boto3.amazonaws.com/v1/documentation/api/latest/index.html
   :alt: Boto3

Environment
-----------

Tests can be executed in an environment :

* in which python and terraform has been installed, by executing the script `scripts/robot.sh`_, or

* in which docker is available, by using the `technogix infrastructure image`_ in its latest version, which already contains python and terraform, by executing the script `scripts/test.sh`_

.. _`technogix infrastructure image`: https://github.com/technogix-images/terraform-python-awscli
.. _`scripts/robot.sh`: scripts/robot.sh
.. _`scripts/test.sh`: scripts/test.sh

Strategy
--------

The test strategy consists in terraforming test infrastructures based on the internet gateway module and check that the resulting AWS infrastructure matches what is expected.
The tests currently contains 2 tests :

1 - A test to check the capability to create an internet gateway accessible through 3 route tables

2 - A test to check the capability to create an egress only internet gateway accessible through 3 route tables

The tests cases :

* Apply terraform to deploy the test infrastructure

* Use specific keywords to model the expected infrastructure in the boto3 format.

* Use shared EC2 keywords based on boto3 to check that the boto3 input matches the expected infrastructure

NB : It is not possible to completely specify the expected infrastructure, since some of the value returned by boto are not known before apply. The comparaison functions checks that all the specified data keys are present in the output, leaving alone the other undefined keys.

Results
-------

The test results for latest release are here_

.. _here: https://technogix-terraform.github.io/module-aws-internet-gateway/report.html

Issues
======

.. image:: https://img.shields.io/github/issues/technogix-terraform/module-aws-internet-gateway.svg
   :target: https://github.com/technogix-terraform/module-aws-internet-gateway/issues
   :alt: Open issues
.. image:: https://img.shields.io/github/issues-closed/technogix-terraform/module-aws-internet-gateway.svg
   :target: https://github.com/technogix-terraform/module-aws-internet-gateway/issues
   :alt: Closed issues

Roadmap
=======

N.A.

Contributing
============

.. image:: https://contrib.rocks/image?repo=technogix-terraform/module-aws-internet-gateway
   :alt: GitHub Contributors Image

We welcome contributions, do not hesitate to contact us if you want to contribute.

License
=======

This code is under MIT License.

Contact
=======

Nadege LEMPERIERE - nadege.lemperiere@technogix.io

Project Link: `https://github.com/technogix-terraform/module-aws-internet-gateway`_

.. _`https://github.com/technogix-terraform/module-aws-internet-gateway`: https://github.com/technogix-terraform/module-aws-internet-gateway

Acknowledgments
===============

N.A.
