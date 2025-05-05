# Strapi Deployment on AWS with Docker and Terraform

This repository automates the deployment of a **Strapi CMS** using **Docker**, **Terraform**, and **GitHub Actions**. The project leverages **Amazon ECS** for serverless container orchestration, with various CI/CD workflows to automate the build, push, and deployment of Docker images to AWS.

## Overview

The repository provides infrastructure-as-code to deploy a **Strapi CMS** application to **AWS ECS** using Docker containers. The workflows include:

*   **Docker** for containerizing the Strapi app.
*   **Terraform** for provisioning infrastructure on AWS.
*   **GitHub Actions** for CI/CD automation.

The setup is designed to use **AWS ECS Fargate** for serverless execution of Docker containers, making the deployment scalable and cost-effective.

## Folder Structure

*   [`Terraform/`](Terraform/): Contains Terraform configuration for deploying Strapi on **AWS EC2**.
*   [`Terraform2/`](Terraform2/): Contains Terraform configurations for deploying Strapi on **AWS ECS** using CodeDeploy for blue/green deployments.
*   [`Terraform3/`](Terraform3/): Contains Terraform configurations for deploying Strapi on **AWS ECS** using CodeDeploy for blue/green deployments. This setup is more modular.
*   [`.github/workflows/`](.github/workflows/): Contains GitHub Actions workflows for CI/CD automation.
*   [`strapi/`](strapi/): Contains the Strapi CMS application.

## Secrets

The following secrets are used across the workflows. Configure these in your GitHub repository under **Settings > Secrets > Actions**.

1.  `AWS_ACCESS_KEY_ID`: AWS access key for configuring AWS credentials.
2.  `AWS_SECRET_ACCESS_KEY`: AWS secret access key for configuring AWS credentials.
3.  `AWS_REGION`: AWS region (e.g., `us-east-1`).
4.  `DOCKER_USERNAME`: Docker Hub username.
5.  `DOCKER_PASSWORD`: Docker Hub password.
6.  `ECR_REPOSITORY`: URI of the Amazon ECR repository.
7.  `IMAGE_URI`: URI of the Docker image.
8.  `AMI_ID`: AMI ID for EC2 instances (used in `Terraform/`).
9.  `INSTANCE_TYPE`: EC2 instance type (used in `Terraform/`).
10. `KEY_NAME`: EC2 key pair name for SSH access (used in `Terraform/`).

## Workflows

### 1. Build and Push to Docker Hub ([`.github/workflows/ci.yml`](.github/workflows/ci.yml))

*   **Trigger**: Manually triggered via `workflow_dispatch`.
*   **Purpose**: Builds a Docker image of the Strapi app and pushes it to Docker Hub.
*   **Key Secrets**: `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `IMAGE_URI`.
*   **Steps**:
    *   Checkout code.
    *   Log in to Docker Hub.
    *   Build Docker image.
    *   Push the image to Docker Hub.

### 2. Build and Push to ECR ([`.github/workflows/ecr.yml`](.github/workflows/ecr.yml))

*   **Trigger**: Manually triggered via `workflow_dispatch`.
*   **Purpose**: Builds a Docker image and pushes it to **Amazon Elastic Container Registry (ECR)**.
*   **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY`.
*   **Steps**:
    *   Checkout code.
    *   Configure AWS credentials.
    *   Log in to Amazon ECR.
    *   Build Docker image.
    *   Push Docker image to Amazon ECR.

### 3. Deploy Strapi on ECS with Terraform ([`.github/workflows/ecs.yml`](.github/workflows/ecs.yml))

*   **Trigger**: Manually triggered via `workflow_dispatch`.
*   **Purpose**: Deploys Strapi on **AWS ECS** using Terraform configurations from the [`Terraform2`](Terraform2/) directory.
*   **Key Secrets**: `ECR_REPOSITORY`, `AWS_REGION`.
*   **Steps**:
    *   Checkout code.
    *   Install Terraform.
    *   Configure AWS credentials.
    *   Initialize Terraform.
    *   Generate Terraform plan and apply it to deploy Strapi on ECS.

### 4. Deploy Strapi with Terraform ([`.github/workflows/terraform.yml`](.github/workflows/terraform.yml))

*   **Trigger**: Manually triggered via `workflow_dispatch`.
*   **Purpose**: Deploys Strapi on **AWS EC2** instances using Terraform configurations from the [`Terraform`](Terraform/) directory.
*   **Key Secrets**: `AMI_ID`, `INSTANCE_TYPE`, `IMAGE_URI`, `KEY_NAME`.
*   **Steps**:
    *   Checkout code.
    *   Install Terraform.
    *   Configure AWS credentials.
    *   Initialize Terraform.
    *   Generate Terraform plan and apply it to deploy Strapi on EC2.

### 5. CD - Infrastructure and Deployment ([`.github/workflows/deploy.yml`](.github/workflows/deploy.yml))

*   **Trigger**: Manually triggered via `workflow_dispatch`.
*   **Purpose**: Deploys Strapi on **AWS ECS** using Terraform configurations from the [`Terraform3`](Terraform3/) directory and CodeDeploy for blue/green deployments.
*   **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`.
*   **Steps**:
    *   Checkout code.
    *   Configure AWS credentials.
    *   Set up Terraform.
    *   Initialize Terraform.
    *   Apply Terraform.
    *   Get ECS Task Definition ARN.
    *   Trigger CodeDeploy Deployment.

## Strapi Application

The [`strapi/`](strapi/) directory contains the Strapi application. See the [Strapi documentation](https://docs.strapi.io/) for details on how to configure and customize your Strapi application.