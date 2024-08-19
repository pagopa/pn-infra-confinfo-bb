data "aws_region" "current" {}

resource "aws_backup_vault" "BackupVault_Dynamodb" {
  name        = "BackupVault_Dynamodb"
}

resource "aws_backup_plan" "BackupPlan" {
  name = "BackupPlan"

  rule {
    rule_name         = "RuleForDailyBackups"
    target_vault_name = aws_backup_vault.BackupVault_Dynamodb.name
    schedule          = var.pn_backup_cron_expression
    start_window = var.pn_backup_start_window
    completion_window = var.pn_backup_completion_window
    enable_continuous_backup = true


    lifecycle {
      delete_after = var.pn_backup_delete_after 
    }
  }
}

data "aws_iam_policy_document" "BackupRole" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "BackupRole" {
  name = "BackupRole"
  assume_role_policy = data.aws_iam_policy_document.BackupRole.json
}


resource "aws_iam_role_policy_attachment" "BackupRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.BackupRole.name
}

resource "aws_backup_selection" "dynamo" {
  iam_role_arn = aws_iam_role.BackupRole.arn
  name         = "dynamo_backup_selection"
  plan_id      = aws_backup_plan.BackupPlan.id

  resources = [
    "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/pn-SsAnagraficaClient",
    "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/PnSsTableDocumentiStreamMetadati",
    "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/pn-SsDocumenti",
    "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/pn-SmStates",
    "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/pn-SsTipologieDocumenti"
  ]
}
