# Bicep Sample Code

This repository contains various examples and templates for Bicep. It helps you learn how to use Bicep, a domain-specific language (DSL) for declaratively deploying Azure resources.

## Table of Contents

- Introduction
- Prerequisites
- Getting Started

## Introduction

Bicep is a simple, declarative language for deploying Azure resources. It aims to simplify the process of writing and managing Azure Resource Manager (ARM) templates. This repository provides a collection of Bicep files to demonstrate various use cases and best practices.

## Prerequisites

Before you begin, ensure you have the following installed:

- Azure CLI
- Bicep CLI

## Getting Started

To get started with the examples in this repository, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/kdkwakaba/BicepSample.git
    cd BicepSample/<sample-directory>
    ```

2. Deploy a Bicep file:
    ```sh
    az deployment group create --resource-group <your-resource-group> \
        --template-file <path-to-bicep-file> \
        --parameters <path-to-parameter-file>
    ```
