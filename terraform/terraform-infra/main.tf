# https://registry.terraform.io/providers/grafana/grafana/latest/docs

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 4.45.2"
    }
  }
}

provider "grafana" {
  url = "http://localhost:3000"
  auth = "admin:admin"
}

module "backend" {
  source = "./backend"

  testdata_datasource_uid = grafana_data_source.testdata_datasource.uid
}

module "platform" {
  source = "./platform"

  testdata_datasource_uid = grafana_data_source.testdata_datasource.uid
}
