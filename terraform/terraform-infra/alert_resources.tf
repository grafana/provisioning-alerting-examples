
resource "grafana_message_template" "my_alert_subject" {
    name = "custom_email.subject"
    disable_provenance = true

    template = <<EOT
{{ define "custom_email.subject" }}
{{ len .Alerts.Firing }} firing alert(s), {{ len .Alerts.Resolved }} resolved alert(s)
{{ end }}
EOT
}

resource "grafana_message_template" "my_alert_message" {
    name = "custom_email.message"
    disable_provenance = true

    template = <<EOT
{{ define "custom_email.message" }}
  Lorem ipsum - Custom alert!
{{ end }}
EOT
}


resource "grafana_contact_point" "my_contact_point" {
  name = "My Contact Email Point"
  disable_provenance = true

  email {
    addresses               = ["${var.contact_point_email}"]
    subject                 = "{{ template \"custom_email.subject\" .}}"
    message                 = "{{ template \"custom_email.message\" .}}"
  }
}

resource "grafana_notification_policy" "notification_policy_tree" {
  contact_point = grafana_contact_point.my_contact_point.name
  disable_provenance = true
  group_by      = ["grafana_folder", "alertname"]
}