# https://registry.terraform.io/providers/grafana/grafana/latest/docs

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.25.0"
    }
  }
}

provider "grafana" {
  url = "http://localhost:3000"
  auth = "admin:admin"
}
