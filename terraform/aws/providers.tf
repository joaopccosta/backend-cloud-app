provider "aws" {
  region                      = "eu-west-1"
  default_tags {
    tags = {
      Environment = var.environment
      Product     = "backend-cloud-app"
      Owner       = "joaopccosta"
    }
  }
}
