# load dashboard from file and update UID variables with local values

data "template_file" "custom_dashboard" {
  template = "${file("../dashboards/definitions/random-walk-dashboard.json")}"
  vars = {
    testdata_datasource_uid = local.testdata_datasource_uid
    uid = local.custom_dashboard_uid 
  }
}

resource "grafana_dashboard" "custom_dashboard" {
  folder = grafana_folder.test_folder.id
  config_json = "${data.template_file.custom_dashboard.rendered}"
}