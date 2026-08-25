terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
  }
}


variable "testdata_datasource_uid" {
  description = "UID of the shared testdata datasource, provisioned in the root module."
}