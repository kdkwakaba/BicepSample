# Azure VM and Network Interface Deployment using Bicep

This repository contains a Bicep template that uses Azure Verified Modules to deploy an Azure Virtual Machine and a Network Interface. This bicep template is a sample for [my blog](https://www.kdkwakaba.com/articles/get-subnet-id-in-avm-with-subnet-name).

## Prerequisites

- Azure CLI installed
- Bicep CLI installed
- An Azure subscription

## Bicep Template Details

The Bicep template (main.bicep) includes the following resources:

Virtual Network: A virtual network with a specified address space.
Subnet: A subnet within the virtual network.
Network Interface: A network interface associated with the subnet.
