locals {
  clients_accounts_ids = [ 
    for id in split(",", var.clients_accounts_ids): 
      trimspace(id) if length(trimspace(id)) > 0 
  ]

  clients_target_users_lists = [ 
    for users_lists in split(",", var.clients_target_users_lists): 
      trimspace(users_lists) if length(trimspace(users_lists)) > 0 
  ]

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

  clients_info = {
    for user in local.split_clients_target_users_lists:
      "${user.account_id}__${user.user_name}" => {
        account_id = user.account_id
        user_name = user.user_name
        key = "${user.account_id}__${user.user_name}"
      }
  }

}



resource "aws_cloudwatch_event_rule" "event_client_accounts_destinations" {

  for_each = local.clients_info

  name = format("client_%s", each.key)
  description = format("Send SafeStorage events to aws clients accounts %s", each.key)
  event_bus_name = aws_cloudwatch_event_bus.PnConfinfoEventBus.name
  
  role_arn = aws_iam_role.send_safestorage_events_to_client_accounts.arn

  event_pattern = jsonencode({
    source = [ "GESTORE DISPONIBILITA" ]
    detail = {
      client_short_code = [ each.value.user_name ]
    }
  })
}

resource "aws_cloudwatch_event_target" "event_external_destination_target" {
  for_each = local.clients_info
  
  rule      = aws_cloudwatch_event_rule.event_client_accounts_destinations[ each.key ].name
  event_bus_name = aws_cloudwatch_event_bus.PnConfinfoEventBus.name
  role_arn = aws_iam_role.send_safestorage_events_to_client_accounts.arn
  
  target_id = format("SSN_client_user_%s", each.key)
  arn       = aws_sns_topic.client_ssn[ each.key ].arn

  dead_letter_config {
    arn = aws_sqs_queue.EventBusDeadLetterQueue.arn
  }

}

resource "aws_sns_topic" "client_ssn" {
  for_each = local.clients_info

  name = format("safe_storage_client_%s", each.value.user_name)
}

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

resource "aws_iam_role" "send_safestorage_events_to_client_accounts" {
  name_prefix = "send_evt_role"

  assume_role_policy = data.aws_iam_policy_document.event_bridge_can_assume.json

}

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

    /*condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [
        aws_cloudwatch_event_bus.PnConfinfoEventBus.arn
      ]
    }*/
  }
}

resource "aws_iam_role_policy" "event_bus_to_topic" {
  name = "SendToSNS4Clients"
  role = aws_iam_role.send_safestorage_events_to_client_accounts.id

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
