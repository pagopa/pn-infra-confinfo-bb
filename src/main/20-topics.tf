#AlarmSNSTopic
resource "aws_sns_topic" "sns_pn_confinfo_sns_topic" {
  name = var.pn_alarm_topic_name
}