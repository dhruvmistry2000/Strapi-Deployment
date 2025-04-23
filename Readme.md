# Strapi Deployment on AWS with Docker and Terraform

This repository automates the deployment of a **Strapi CMS** using **Docker**, **Terraform**, and **GitHub Actions**. The project leverages **Amazon ECS** for serverless container orchestration, with various CI/CD workflows to automate the build, push, and deployment of Docker images to AWS.

## Overview

The repository provides infrastructure-as-code to deploy a **Strapi CMS** application to **AWS ECS** using Docker containers. The workflows include:

- **Docker** for containerizing the Strapi app.
- **Terraform** for provisioning infrastructure on AWS.
- **GitHub Actions** for CI/CD automation.

The setup is designed to use **AWS ECS Fargate** for serverless execution of Docker containers, making the deployment scalable and cost-effective.

## Folder Structure

- **`Terraform/`**: Contains Terraform configuration for deploying Strapi on **AWS ECS**.
- **`Terraform2/`**: Another set of Terraform configurations, possibly for a different ECS setup or environment (e.g., staging or test).
- **`.github/workflows/`**: Contains GitHub Actions workflows for CI/CD automation.

## Secrets

The following secrets are used across the workflows:

1. **`AWS_ACCESS_KEY_ID`** – AWS access key for configuring AWS credentials.
2. **`AWS_SECRET_ACCESS_KEY`** – AWS secret access key for configuring AWS credentials.
3. **`AWS_REGION`** – AWS region (e.g., `us-east-1`).
4. **`DOCKER_USERNAME`** – Docker Hub username.
5. **`DOCKER_PASSWORD`** – Docker Hub password.
6. **`ECR_REPOSITORY`** – URI of the Amazon ECR repository.
7. **`IMAGE_URI`** – URI of the Docker image.
8. **`AMI_ID`** – AMI ID for EC2 instances (used in Terraform).
9. **`INSTANCE_TYPE`** – EC2 instance type (used in Terraform).
10. **`KEY_NAME`** – EC2 key pair name for SSH access.

Ensure these secrets are configured in your GitHub repository under **Settings > Secrets**.

## Workflows

### 1. **Build and Push to Docker Hub**
- **Trigger**: Manually triggered via `workflow_dispatch`.
- **Purpose**: Builds a Docker image of the Strapi app and pushes it to Docker Hub.
- **Key Secrets**: `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `IMAGE_URI`.
- **Steps**:
  - Checkout code.
  - Log in to Docker Hub.
  - Build Docker image.
  - Push the image to Docker Hub.

### 2. **Build and Push to ECR**
- **Trigger**: Automatically triggered on `push` to the `main` branch.
- **Purpose**: Builds a Docker image and pushes it to **Amazon Elastic Container Registry (ECR)**.
- **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY`.
- **Steps**:
  - Checkout code.
  - Configure AWS credentials.
  - Log in to Amazon ECR.
  - Build Docker image.
  - Push Docker image to Amazon ECR.

### 3. **Deploy Strapi on ECS with Terraform**
- **Trigger**: Manually triggered via `workflow_dispatch`.
- **Purpose**: Deploys Strapi on **AWS ECS** using Terraform configurations from the `Terraform2` directory.
- **Key Secrets**: `ECR_REPOSITORY`, `AWS_REGION`.
- **Steps**:
  - Checkout code.
  - Install Terraform.
  - Configure AWS credentials.
  - Initialize Terraform.
  - Generate Terraform plan and apply it to deploy Strapi on ECS.

### 4. **Deploy Strapi with Terraform**
- **Trigger**: Manually triggered via `workflow_dispatch`.
- **Purpose**: Deploys Strapi on **AWS EC2** instances using Terraform configurations from the `Terraform` directory.
- **Key Secrets**: `AMI_ID`, `INSTANCE_TYPE`, `IMAGE_URI`, `KEY_NAME`.
- **Steps**:
  - Checkout code.
  - Install Terraform.
  - Configure AWS credentials.
  - Initialize Terraform.
  - Generate Terraform plan and apply it to deploy Strapi on EC2.

