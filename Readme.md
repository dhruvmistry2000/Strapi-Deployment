# Strapi Deployment with GitHub Actions and Terraform

This repository contains the configuration for building, pushing, and deploying a Strapi application using Docker, GitHub Actions, and Terraform.

## Overview

The deployment process is divided into two workflows:

1. **Build and Push Docker Image** (`ci.yml`):
   - Builds a Docker image for the Strapi application.
   - Pushes the image to Docker Hub.
   - Saves the Docker image URI as an artifact.

2. **Deploy with Terraform** (`terraform.yml`):
   - Downloads the Docker image URI artifact.
   - Deploys the Strapi application to AWS using Terraform.