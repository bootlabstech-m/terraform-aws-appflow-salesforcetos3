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