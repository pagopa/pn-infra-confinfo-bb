#STREAM SOURCE ROLE
data "aws_iam_policy_document" "firehose-assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose-stream" {
  name = "${var.firehose_name}-stream-role"
  assume_role_policy = data.aws_iam_policy_document.firehose-assume.json
}

data "aws_iam_policy_document" "firehose-stream" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:SubscribeToShard"
    ]
    resources = [var.stream_arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [var.stream_kms_arn]
  }
}


resource "aws_iam_policy" "firehose-stream" {
  name        = "${var.firehose_name}-stream-policy"
  description = "IAM policy for Kinesis stream and KMS decryption"
  policy      = data.aws_iam_policy_document.firehose-stream.json
}

resource "aws_iam_role_policy_attachment" "firehose-stream" {
  role       = aws_iam_role.firehose-stream.name
  policy_arn = aws_iam_policy.firehose-stream.arn
}
###################################################################
 #EXTENDENDED S3 ROLE

resource "aws_iam_role" "firehose-extendend" {
  name               = "${var.firehose_name}-extended-role"
  assume_role_policy = data.aws_iam_policy_document.firehose-assume.json
}

data "aws_iam_policy_document" "firehose-extendend-s3" {
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "firehose-extendend-s3" {
  name   = "${var.firehose_name}-s3-policy"
  policy = data.aws_iam_policy_document.firehose-extendend-s3.json
}

resource "aws_iam_role_policy_attachment" "firehose-extendend-s3" {
  role       = aws_iam_role.firehose-extendend.name
  policy_arn = aws_iam_policy.firehose-extendend-s3.arn
}


data "aws_iam_policy_document" "firehose-extendend-put-record" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      var.stream_arn
    ]
  }
}

resource "aws_iam_policy" "firehose-extendend-put-record" {
  name   = "${var.firehose_name}-put_record-policy"
  policy = data.aws_iam_policy_document.firehose-extendend-put-record.json
}


resource "aws_iam_role_policy_attachment" "firehose-extendend-put-record" {
  role       = aws_iam_role.firehose-extendend.name
  policy_arn = aws_iam_policy.firehose-extendend-put-record.arn
}

data "aws_iam_policy_document" "firehose-extendend-cloudwatch" {
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.firehose_log_group.arn
    ]
  }
}

resource "aws_iam_policy" "firehose-extendend-cloudwatch" {
  name   = "${var.firehose_name}-cloudwatch-policy"
  policy = data.aws_iam_policy_document.firehose-extendend-cloudwatch.json
}


resource "aws_iam_role_policy_attachment" "firehose-extendend-cloudwatch" {
  role       = aws_iam_role.firehose-extendend.name
  policy_arn = aws_iam_policy.firehose-extendend-cloudwatch.arn
}
##################################################################
#CLOUDWATCH

resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name = "/aws/kinesisfirehose/${var.firehose_name}-delivery"
  retention_in_days = var.loggroup_retention
}

resource "aws_cloudwatch_log_stream" "firebose_log_stream" {
  name           = "/aws/kinesisfirehose/${var.firehose_name}-stream"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}



#######################################################################
#FIREHOSE

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
 count = var.dynamic_partitioning_enabled == false ? 1 : 0 
 depends_on = [
    aws_iam_role.firehose-stream
 ]
  name        = var.firehose_name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.stream_arn
    role_arn           = aws_iam_role.firehose-stream.arn
  }


  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose-extendend.arn
    bucket_arn = var.s3_bucket_arn

    buffer_interval = 60
    buffer_size     = 64


    cloudwatch_logging_options {
      enabled = "true"
      log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firebose_log_stream.name
    }

    prefix = "${var.StreamNamePrefix}/"
    error_output_prefix = "errors/${var.StreamNamePrefix}/"

    dynamic_partitioning_configuration {
      enabled = "false"
    }

    processing_configuration {
      enabled = "false"
    }
  }
}


resource "aws_kinesis_firehose_delivery_stream" "firehose-cdc" {
 count = var.dynamic_partitioning_enabled == true ? 1 : 0 
 depends_on = [
    aws_iam_role.firehose-stream
 ]
  name        = var.firehose_name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.stream_arn
    role_arn           = aws_iam_role.firehose-stream.arn
  }


  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose-extendend.arn
    bucket_arn = var.s3_bucket_arn

    buffer_interval = 60
    buffer_size     = 64


    cloudwatch_logging_options {
      enabled = "true"
      log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firebose_log_stream.name
    }

    prefix = "${var.StreamNamePrefix}/TABLE_NAME_!{partitionKeyFromQuery:TABLE_NAME}/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}"
    error_output_prefix = "errors/${var.StreamNamePrefix}/"

    dynamic_partitioning_configuration {
      enabled = "true"
    }

    processing_configuration {
      enabled = "true"

      processors {
        type = "AppendDelimiterToRecord"

        parameters {
          parameter_name  = "Delimiter"
          parameter_value = "\\n"
        }
      }

    processors {
        type = "MetadataExtraction"

        parameters {
           parameter_name  = "MetadataExtractionQuery"
           parameter_value = "{ TABLE_NAME : .tableName }"
        }
        parameters {
            parameter_name  = "JsonParsingEngine"
            parameter_value = "JQ-1.6"
        }
      }
    }
  }
}

#######################################################
#CLOUDWATCH

resource "aws_cloudwatch_metric_alarm" "alarm" {
 
  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm

  dimensions = var.dimensions
}

resource "aws_cloudwatch_log_metric_filter" "filter" {
  name           = var.filter_name
  pattern        = var.filter_pattern
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name

  metric_transformation {
    name      = "${var.firehose_name}-kinesis-error"
    namespace = var.namespace
    value     = 1
  }
}

