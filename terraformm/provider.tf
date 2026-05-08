terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.39.0"
    }
     tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
     null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    cloudflare = {
      source = "cloudflare/cloudflare" //domain name automatically update garna lai
      version = "5.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}
