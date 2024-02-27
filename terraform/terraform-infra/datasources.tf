# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source

resource "grafana_data_source" "testdata_datasource" {
    name = "TestData"
    type = "testdata"
    is_default = true
}