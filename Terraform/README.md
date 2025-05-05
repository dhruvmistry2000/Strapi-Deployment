# Terraform Directory

This directory contains Terraform configurations for deploying a Strapi application on AWS EC2 instances.

## Infrastructure Overview

The Terraform configuration in this directory deploys the following infrastructure:

*   **EC2 Instance:** An EC2 instance to host the Strapi application.
*   **Security Group:** A security group to control network access to the EC2 instance, allowing SSH, HTTP, HTTPS, and traffic on port 1337.

## Prerequisites

Before using this Terraform configuration, you need to have the following:

*   An AWS account.
*   The Terraform CLI installed.
*   The AWS CLI installed and configured with your AWS credentials.
*   A Docker image of your Strapi application pushed to a container registry (e.g., Docker Hub, ECR).
*   An SSH key pair for accessing the EC2 instance.

## Configuration

The following variables can be configured in the `terraform.tfvars` file:

*   `ami_id`: The ID of the Amazon Machine Image (AMI) to use for the EC2 instance.
*   `instance_type`: The instance type to use for the EC2 instance.
*   `image_uri`: The URI of the Docker image for the Strapi application.
*   `key_name`: The name of the SSH key pair to use for accessing the EC2 instance.

## Usage

1.  Initialize Terraform:

    ```bash
    terraform init
    ```

2.  Create a Terraform plan:

    ```bash
    terraform plan
    ```

3.  Apply the Terraform configuration:

    ```bash
    terraform apply
    ```