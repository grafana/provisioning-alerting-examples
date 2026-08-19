# https://registry.terraform.io/providers/grafana/grafana/latest/docs

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 4.45.1"
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

  depends_on = [
    grafana_data_source.testdata_datasource,
  ]
}

module "platform" {
  source = "./platform"

  testdata_datasource_uid = grafana_data_source.testdata_datasource.uid
  
  depends_on = [
    # grafana_apps_notifications_routingtree_v1beta1 resources fail 
    # https://github.com/grafana/terraform-provider-grafana/issues/2942
    module.backend,
    grafana_data_source.testdata_datasource,
  ]
}
