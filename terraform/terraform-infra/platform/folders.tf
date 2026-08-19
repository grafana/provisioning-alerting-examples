# https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder

resource "grafana_folder" "platform_alerting" {
  title = "PlatformAlerting"
}