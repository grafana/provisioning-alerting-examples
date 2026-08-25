# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/apps_rules_alertrule_v0alpha1
resource "grafana_apps_rules_alertrule_v0alpha1" "platform_random_walk_threshold" {
  depends_on = [
    grafana_apps_notifications_routingtree_v1beta1.team_platform
  ]
  metadata {
    uid        = "platform_random_walk_threshold"
    folder_uid = grafana_folder.platform_alerting.uid
  }

  spec {
    title = "random_walk_threshold"

    trigger {
      interval = "1m"
    }

    paused = false

    no_data_state  = "NoData"
    exec_err_state = "Error"

    expressions = {
      "A" = jsonencode({
        datasource_uid = var.testdata_datasource_uid
        query_type     = ""
        source         = false
        relative_time_range = {
          from = "300s"
          to   = "0s"
        }
        model = {
          datasource = {
            type = "grafana-testdata-datasource"
            uid  = var.testdata_datasource_uid
          }
          intervalMs    = 1000
          maxDataPoints = 43200
          refId         = "A"
          scenarioId    = "random_walk"
        }
      })
      "B" = jsonencode({
        datasource_uid = "__expr__"
        query_type     = ""
        source         = false
        relative_time_range = {
          from = "0s"
          to   = "0s"
        }
        model = {
          conditions = [
            {
              evaluator = {
                params = []
                type   = "gt"
              }
              operator = {
                type = "and"
              }
              query = {
                params = ["B"]
              }
              reducer = {
                params = []
                type   = "last"
              }
              type = "query"
            }
          ]
          datasource = {
            type = "__expr__"
            uid  = "__expr__"
          }
          expression    = "A"
          intervalMs    = 1000
          maxDataPoints = 43200
          reducer       = "mean"
          refId         = "B"
          type          = "reduce"
        }
      })
      "C" = jsonencode({
        datasource_uid = "__expr__"
        query_type     = ""
        source         = true
        relative_time_range = {
          from = "0s"
          to   = "0s"
        }
        model = {
          conditions = [
            {
              evaluator = {
                params = [0]
                type   = "gt"
              }
              operator = {
                type = "and"
              }
              query = {
                params = ["C"]
              }
              reducer = {
                params = []
                type   = "last"
              }
              type = "query"
            }
          ]
          datasource = {
            type = "__expr__"
            uid  = "__expr__"
          }
          expression = "B"
          refId      = "C"
          type       = "threshold"
        }
      })
    }

    notification_settings {
      named_routing_tree {
        # https://github.com/grafana/terraform-provider-grafana/issues/2941
        routing_tree = "platform-routing-tree"
      }
    }

    labels = {
      team     = "platform"
      severity = "critical"
    }
  }
}
