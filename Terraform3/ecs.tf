
data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([{
    name      = "strapi"
    image     = "985539759598.dkr.ecr.us-east-1.amazonaws.com/strapi-app:latest"
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "HOST"
        value = "0.0.0.0"
      },
      {
        name  = "APP_URL"
        value = "http://${aws_lb.strapi_alb.dns_name}"
      },
      {
        name  = "ALLOWED_HOSTS"
        value = "${aws_lb.strapi_alb.dns_name}"
      },
      {
        name  = "PORT"
        value = "1337"
      },
      {
        name  = "APP_KEYS"
        value = "your_key1,your_key2"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/ecs/strapi",
        awslogs-region        = "us-east-1",
        awslogs-stream-prefix = "strapi"
      }
    }
  }])
}


resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.strapi.name
 
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
 
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet_2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.strapi_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  task_definition = aws_ecs_task_definition.strapi_task.arn

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1

  }

  deployment_controller {
  type = "CODE_DEPLOY"
  }

}

# CodeDeploy Application
resource "aws_codedeploy_app" "strapi_codedeploy_app" {
  name = "strapi-codedeploy-app"
  compute_platform = "ECS"
}

# IAM Role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "strapi_codedeploy_group" {
  app_name              = aws_codedeploy_app.strapi_codedeploy_app.name
  deployment_group_name = "strapi-deploy-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi.name
    service_name = aws_ecs_service.strapi_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.strapi_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}