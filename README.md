# Examples - Provision alerting resources in Grafana

This repository includes examples to [provision alerting resources](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/) using Docker Compose:

- [Provision alerting resources in Grafana OSS using YAML files and Docker Compose](./config-files/)
- [Provision alerting resources in Grafana OSS using Terraform and Docker Compose](./terraform/)

The mermaid diagram below illustrates the primary provisioned Grafana resources in these examples and their relationships.

```mermaid
    erDiagram

    custom_dashboard ||--|{ JSON-random-walk-dashboard : loaded_from

    JSON-random-walk-dashboard ||--|{ testdata_datasource : targets

    alert_rule_group1 ||--|{ testdata_datasource : query
    alert_rule_group1 ||--|{ custom_dashboard : links_to

    notification_policy_tree ||--|{ nested_policy : includes

    nested_policy ||--|{ my_contact_point : uses
    nested_policy ||--|{ alert_rule_group1 : matches_with_monitor_label
    nested_policy ||--|{ mute_timing_no_weekends : configured_with

    my_contact_point ||--|{ my_alert_subject_template : uses
    my_contact_point ||--|{ my_alert_message_template : uses
    my_contact_point {
        email_addresses contact_point_email_variable
        email_subject my_alert_subject_template
        email_message my_alert_message_template
    }
```