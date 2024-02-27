# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source

resource "grafana_data_source" "testdata_datasource" {
    name = "TestData"
    type = "testdata"
    uid = local.testdata_datasource_uid
    is_default = true
}