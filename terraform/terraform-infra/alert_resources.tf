
#https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/message_template
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

#https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/contact_point
resource "grafana_contact_point" "my_contact_point" {
  name = "My Contact Email Point"
  disable_provenance = true

  email {
    addresses               = ["${var.contact_point_email}"]
    subject                 = "{{ template \"custom_email.subject\" .}}"
    message                 = "{{ template \"custom_email.message\" .}}"
  }
}

resource "grafana_mute_timing" "mute_timing_no_weekends" {
  name = "no_weekends"

  # unsupported https://github.com/grafana/terraform-provider-grafana/issues/1388
  # disable_provenance = true 

  intervals {
    weekdays = ["saturday", "sunday"]
  }
}

#https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/notification_policy
resource "grafana_notification_policy" "notification_policy_tree" {
  disable_provenance = true
  contact_point = grafana_contact_point.my_contact_point.name
  group_by      = ["grafana_folder", "alertname"]

  policy {
    contact_point = grafana_contact_point.my_contact_point.name

    matcher {
      label = "monitor"
      match = "="
      value = "testdata"
    }

    mute_timings = [grafana_mute_timing.mute_timing_no_weekends.name]
  }
}