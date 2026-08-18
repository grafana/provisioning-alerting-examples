
resource "grafana_contact_point" "platform_contact_point" {
  name = "Platform Contact Email Point"
  disable_provenance = true

  email {
    addresses               = ["${var.contact_point_email}"]
  }
}

resource "grafana_apps_notifications_routingtree_v1beta1" "team_platform" {
  # grafana_apps_notifications_routingtree_v1beta1 resources fail with
  # "HTTP 500 - could not find object using provided id and hash" when created
  # concurrently, so routing trees must be chained via depends_on and applied
  # one at a time (arbitrarily ordered alphabetically here).
  depends_on = [
    grafana_contact_point.platform_contact_point,
    grafana_apps_notifications_routingtree_v1beta1.team_backend,
  ]

  metadata {
    uid = "team-platform"
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