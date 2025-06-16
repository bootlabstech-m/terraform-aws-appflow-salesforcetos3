# ---------------------------
# Local values for existing bucket
# ---------------------------
locals {
  destination_bucket_name = var.destination_bucket_name
  destination_bucket_arn  = "arn:aws:s3:::${var.destination_bucket_name}"
  # account_id              = var.account_id
}

# # ---------------------------------------------------
# # Bucket policy allowing AppFlow to write to S3 bucket
# # ---------------------------------------------------
# data "aws_iam_policy_document" "example_destination" {
#   statement {
#     sid    = "AllowAppFlowDestinationActions"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["appflow.amazonaws.com"]
#     }

#     actions = [
#       "s3:PutObject",
#       "s3:AbortMultipartUpload",
#       "s3:ListMultipartUploadParts",
#       "s3:ListBucketMultipartUploads",
#       "s3:GetBucketAcl",
#       "s3:PutObjectAcl",
#     ]

#     resources = [
#       local.destination_bucket_arn,
#       "${local.destination_bucket_arn}/*",
#     ]
#     condition {
#         test     = "StringEquals"
#         variable = "aws:SourceArn"
#         values   = ["arn:aws:appflow:${var.region}:${var.account_id}:flow/${var.appflow_name}"]
#        }
#   }
# }

# resource "aws_s3_bucket_policy" "example_destination" {
#   bucket = local.destination_bucket_name
#   policy = data.aws_iam_policy_document.example_destination.json
# }

# -------------------------------
# IAM Role for AWS AppFlow access
# -------------------------------
resource "aws_iam_role" "appflow_execution_role" {
  name = "appflow-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "appflow.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# --------------------------------------------------
# IAM Policy to allow AppFlow access to destination
# --------------------------------------------------
resource "aws_iam_policy" "appflow_s3_policy" {
  name = "appflow-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = [
          local.destination_bucket_arn,
          "${local.destination_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "appflow_policy_attach" {
  role       = aws_iam_role.appflow_execution_role.name
  policy_arn = aws_iam_policy.appflow_s3_policy.arn
}

# --------------------- 
# Actual App flow Block:
# ---------------------

resource "aws_appflow_flow" "appflow_salesforce_to_s3" {
  name    = var.appflow_name
  kms_arn = var.kms_arn
  # tags    = var.tags

  destination_flow_config {
    connector_type = "S3"
    destination_connector_properties {
      s3 {
        bucket_name  = var.destination_bucket_name
        bucket_prefix = var.destination_bucket_prefix

        s3_output_format_config {
          file_type                   = var.file_type
          preserve_source_data_typing = var.preserve_source_data_typing

          aggregation_config {
            aggregation_type = var.aggregation_type
            target_file_size = var.target_file_size
          }

          prefix_config {
            prefix_type = var.prefix_type
          }
        }
      }
    }
  }

  source_flow_config {
    connector_type         = var.source_connector_type
    connector_profile_name = var.connector_profile_name

    source_connector_properties {
      salesforce {
        enable_dynamic_field_update = var.enable_dynamic_field_update
        include_deleted_records     = var.include_deleted_records
        object                      = var.salesforce_object
      }
    }
  }

# Projection Task (Filter) - Required when connector_operator is PROJECTION

task {
  source_fields = var.salesforce_task_projection_source_fields
  task_type     = var.salesforce_task_projection_task_type
  task_properties = {}
  connector_operator {
    salesforce = var.connector_operator
  }
}

task {
  destination_field = var.salesforce_task_map_destination_field
  source_fields     = var.salesforce_task_map_source_fields
  task_properties   = var.salesforce_task_map_task_properties
  task_type         = var.salesforce_task_map_task_type

  connector_operator {
    salesforce = var.connector_operator
  }
}

# Filter by Type with EQUAL_TO condition

task {
  source_fields     = var.salesforce_task_filters_source_fields
  task_type         = var.salesforce_task_filters_task_type
  task_properties   = var.salesforce_task_filters_task_properties
  connector_operator {
    salesforce = var.salesforce_task_filters_connector_operator
  }
}

  trigger_config {
    trigger_type = var.trigger_type
  }
}