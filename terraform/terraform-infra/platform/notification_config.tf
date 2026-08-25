
resource "grafana_contact_point" "platform_contact_point" {
  name = "Platform Contact Email Point"
  disable_provenance = true

  email {
    addresses               = ["platform@example.com"]
  }
}

resource "grafana_apps_notifications_routingtree_v1beta1" "team_platform" {
  metadata {
    uid = "platform-routing-tree"
  }
  spec {
    disable_provenance = false

    defaults {
      receiver        = grafana_contact_point.platform_contact_point.name
      group_by        = ["grafana_folder", "alertname"]
      group_wait      = "30s"
      group_interval  = "5m"
      repeat_interval = "4h"
    }

    routes {

      group_wait      = "0s"
      group_interval  = "1m"
      matchers = [
        {
          type  = "="
          label = "severity"
          value = "critical"
        }
      ]
    }
  }
}
