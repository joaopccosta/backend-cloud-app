terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.3"
    }
  }

  backend "s3" {
    bucket         = "backend-cloud-app-state-bucket"
    key            = "env/kubernetes-terraform.tfstate"
    region         = "eu-west-1"
    use_lockfile = true
    encrypt        = true
  }
}
