# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group

resource "grafana_rule_group" "rule_group_0000" {
  name             = "group_1m"
  disable_provenance = true
  folder_uid       = grafana_folder.test_folder.uid
  interval_seconds = 60

  rule {
    name      = "random_walk_threshold"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = local.testdata_datasource_uid
      model          = "{\"datasource\":{\"type\":\"grafana-testdata-datasource\",\"uid\":\"${local.testdata_datasource_uid}\"},\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"A\",\"scenarioId\":\"random_walk\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"mean\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    annotations = {
      __dashboardUid__ = local.custom_dashboard_uid
      __panelId__      = "1"
    }
    labels = {
      monitor = "testdata"
    }
    is_paused = false
  }
}