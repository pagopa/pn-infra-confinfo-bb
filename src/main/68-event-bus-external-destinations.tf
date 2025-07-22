locals {
  # - Because of a limitation on the CI/CD scripts we can handle only string vars.
  # - This set of locals mangle the vars to obtain a normalized data structure 
  #   memorized in  

  # - Split client's AWS account id list
  clients_accounts_ids = [ 
    for id in split(",", var.clients_accounts_ids): 
      trimspace(id) if length(trimspace(id)) > 0 
  ]

  # - The SafeStorage clients list is separated by '|' (pipe)  and ',' (comma).
  #   Comma is used to separate different AWS accounts, 
  #   pipe is used to separate clients names in the same AWS account.
  # - This locals contains the list split on commas, the next contains the "full split"
  clients_target_users_lists = [ 
    for users_lists in split(",", var.clients_target_users_lists): 
      trimspace(users_lists) if length(trimspace(users_lists)) > 0 
  ]

  # - This local contains an array of array.
  #   The outer array contains one element for each AWS Account;
  #   every element is an inner array containing the list of safe-storage clients that 
  #   run on one AWS Account
  split_clients_target_users_lists = flatten([
    for idx, users_list in local.clients_target_users_lists: [
        for user in split("|", users_list):
          {
            user_name = trimspace( user )
            account_id = local.clients_accounts_ids[idx]
          }
            if length( trimspace( user )) > 0
      ]
  ])

  # - Normalized data structure. clients_info is a "map" that associate a
  #   key of type string composed joining the AWS account id and the safestorage-client-short-code
  #   with a value composed by the same two values as distinct properties.
  clients_info = {
    for user in local.split_clients_target_users_lists:
      "${user.account_id}__${user.user_name}" => {
        account_id = user.account_id
        user_name = user.user_name
        key = "${user.account_id}__${user.user_name}"
      }
  }

}

# - One SNS topic for each safe-storage client
resource "aws_sns_topic" "client_ssn" {
  for_each = local.clients_info

  name = format("safe_storage_client_%s", each.value.user_name)
}

# One distinct policy for every SNS topic; this policy allow subscription 
# to the topic from the AWS Account associated to the safe-storage client.
resource "aws_sns_topic_policy" "client_ssn_policy" {
  for_each = local.clients_info

  arn = aws_sns_topic.client_ssn[ each.key ].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Subscribe"
        ]
        Principal = {
            AWS = each.value.account_id
        }
        Resource = [
          aws_sns_topic.client_ssn[ each.key ].arn
        ]   
      }
    ]
  })
}


# - One EventBus rule for each safe-storage client
resource "aws_cloudwatch_event_rule" "event_to_clients_sns_topics_rules" {

  for_each = local.clients_info

  name = format("client_%s", each.key)
  description = format("Send SafeStorage events to aws clients accounts %s", each.key)
  event_bus_name = aws_cloudwatch_event_bus.PnConfinfoEventBus.name
  
  role_arn = aws_iam_role.send_safestorage_events_to_clients_topics_role.arn

  event_pattern = jsonencode({
    source = [ "GESTORE DISPONIBILITA" ]
    detail = {
      client_short_code = [ each.value.user_name ]
    }
  })
}

# - One target for every rule (one for each safe-storage client)
resource "aws_cloudwatch_event_target" "event_to_clients_sns_topics_targets" {
  for_each = local.clients_info
  
  rule      = aws_cloudwatch_event_rule.event_to_clients_sns_topics_rules[ each.key ].name
  event_bus_name = aws_cloudwatch_event_bus.PnConfinfoEventBus.name
  role_arn = aws_iam_role.send_safestorage_events_to_clients_topics_role.arn
  
  target_id = format("user_%s", each.key)
  arn       = aws_sns_topic.client_ssn[ each.key ].arn

  dead_letter_config {
    arn = aws_sqs_queue.EventBusDeadLetterQueue.arn
  }
}


# - Only one role for EventBridge, used by all the rules and targets.
#   It simply allow EventBridge to write to all the SNS topic created by this terraform file.
resource "aws_iam_role" "send_safestorage_events_to_clients_topics_role" {
  name_prefix = "send_evt_role"

  assume_role_policy = data.aws_iam_policy_document.event_bridge_can_assume.json
}

# - Avoid https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html#cross-service-confused-deputy-prevention
data "aws_iam_policy_document" "event_bridge_can_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role_policy" "event_bus_to_topics" {
  name = "SendToSNS4Clients"
  role = aws_iam_role.send_safestorage_events_to_clients_topics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:GetTopicAttributes",
          "sns:Publish",
          "sns:PublishBatch"
        ]
        Resource = [
          for info in values(local.clients_info):
            aws_sns_topic.client_ssn[ info.key ].arn
        ]
      }
    ]
  })
}
