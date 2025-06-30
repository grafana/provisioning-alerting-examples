
# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard

# load dashboard from file 
# update the data source uid to query the provisioned testdata datasource

locals {
  custom_dashboard = templatefile("../dashboards/definitions/random-walk-dashboard.json", {
    datasource_uid = grafana_data_source.testdata_datasource.uid
  })
}

resource "grafana_dashboard" "custom_dashboard" {
  folder = grafana_folder.test_folder.id
  config_json = local.custom_dashboard
}
