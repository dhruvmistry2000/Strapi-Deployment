# Terraform3 Directory

This directory contains Terraform configurations for deploying a Strapi application on AWS using ECS and CodeDeploy. It focuses on a more modular and potentially more scalable approach compared to Terraform2.

## Infrastructure Overview

The Terraform configuration in this directory deploys the following infrastructure:

*   **S3 Backend:** Configures an S3 bucket for storing Terraform state.
*   **Provider Configuration:** Configures the AWS provider with a specified region.
*   **IAM Roles:** Defines IAM roles for ECS task execution and CodeDeploy.
*   **Networking:** Creates VPC, subnets, and security groups.
*   **ECS Cluster:** Sets up an ECS cluster to orchestrate containers.
*   **Load Balancer:** Configures an Application Load Balancer (ALB) for traffic distribution.
*   **CloudWatch Log Group:** Creates a CloudWatch Log Group for application logs.
*   **CloudWatch Alarms:** Configures CloudWatch alarms for CPU, Memory, Network In/Out, and Task Count.
*   **CodeDeploy:** Sets up CodeDeploy for blue/green deployments.

## Prerequisites

Before using this Terraform configuration, ensure you have:

*   An AWS account.
*   Terraform CLI installed.
*   AWS CLI installed and configured.
*   A Docker image of your Strapi application in a container registry (e.g., Docker Hub, ECR).
*   An S3 bucket for storing Terraform state (configured in `main.tf`).

## Configuration

Key configuration files:

*   [`main.tf`](main.tf): Contains the core resource definitions, including provider configuration and backend settings.
*   [`vpc.tf`](vpc.tf): Defines networking resources (VPC, subnets, security groups).
*   [`iam.tf`](iam.tf): Defines IAM roles and policies.
*   [`ecs.tf`](ecs.tf): Defines ECS cluster and service resources.
*   [`lb.tf`](lb.tf): Defines load balancer resources.
*   [`codedeploy.tf`](codedeploy.tf): Defines CodeDeploy resources.
*   [`cloudwatch.tf`](cloudwatch.tf): Defines CloudWatch resources.

Variables that can be configured (ideally in `terraform.tfvars`):

*   `region`: The AWS region to deploy to (e.g., "us-east-1").
*   `image_uri`: The URI of the Docker image for the Strapi application.

## Usage

1.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

2.  **Create a Terraform plan:**

    ```bash
    terraform plan
    ```

3.  **Apply the Terraform configuration:**

    ```bash
    terraform apply
    ```