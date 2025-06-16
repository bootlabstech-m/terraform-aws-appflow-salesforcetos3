variable "region" {
  default = "ap-south-1"
  type    = string
}

variable "role_arn" {
  type = string
  description = "The ARN of the IAM role"
}

# variable "account_id" {
#   type = string
#   description = "account id of the resources being created in"
  
# }
variable "appflow_name" {
  type        = string
  description = "The name of the AppFlow flow"
}

variable "kms_arn" {
  type        = string
  description = "The ARN of the KMS key to use for encryption"
}

# variable "tags" {
#   type        = map(string)
#   description = "Tags to apply to the AppFlow flow"
#   default = {
#     Environment = "dev"
#     Project     = "appflow-salesforcetos3"
#   }
# }

variable "destination_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where the data will be stored"
}

variable "destination_bucket_prefix" {
  type        = string
  description = "Prefix for the S3 bucket key (path)"
}

variable "file_type" {
  type        = string
  description = "The output file format (e.g., CSV, JSON)"
}

variable "preserve_source_data_typing" {
  type        = bool
  description = "Preserve source data types"
  default = false
}

variable "aggregation_type" {
  type        = string
  description = "Type of aggregation to apply to the flow data"
  default = "None"
}

variable "target_file_size" {
  type        = number
  description = "Target file size in MB for S3 files"
}

variable "prefix_type" {
  type        = string
  description = "Prefix type (e.g. 'PATH' or 'prefix' or 'timestamp')"
  default = "PATH"
}

variable "source_connector_type" {
  type        = string
  description = "Source connector type (e.g., 'Salesforce')"
  default = "Salesforce"
}

variable "connector_profile_name" {
  type        = string
  description = "Name of the Salesforce connector profile to use"
}

variable "enable_dynamic_field_update" {
  type        = bool
  description = "Whether to enable dynamic field updates from Salesforce"
  default = false
}

variable "include_deleted_records" {
  type        = bool
  description = "Whether to include deleted records from Salesforce"
  default = false
}

variable "salesforce_object" {
  type        = string
  description = "Name of the Salesforce object to sync"
}

variable "connector_operator" {
  type        = string
  description = "Connector operator type, supported values 'NO_OP', 'PROJECTION', 'UPSERT')"
  default = "PROJECTION"
}

variable "trigger_type" {
  type        = string
  description = "Trigger type for AppFlow (e.g., 'OnDemand', 'Scheduled', 'Event')"
  default = "OnDemand"
}

# task_map

variable "salesforce_task_map_source_fields" {
  type        = list(string)
  description = "Source fields for Salesforce Task Map"
  default     = ["AccountNumber"]
}

variable "salesforce_task_map_destination_field" {
  type        = string
  description = "Destination field for Salesforce Task Map"
  default     = "AccountNumber"
}

variable "salesforce_task_map_task_properties" {
  type        = map(string)
  description = "Task properties for Salesforce Task Map"
  default = {
    DESTINATION_DATA_TYPE = "string"
    SOURCE_DATA_TYPE      = "string"
  }
}

variable "salesforce_task_map_task_type" {
  type        = string
  description = "Task type for Salesforce Task Map"
  default     = "Map"
}

# task_projection

variable "salesforce_task_projection_source_fields" {
  type        = list(string)
  description = "Source fields to include from Salesforce for the Projection task"
  default     = ["AccountNumber"]
}

variable "salesforce_task_projection_task_type" {
  type        = string
  description = "Task type for Salesforce task projection"
  default     = "Filter"
}

# Task filters - expected salesforce to be one of ["PROJECTION" "LESS_THAN" "CONTAINS" "GREATER_THAN" "BETWEEN" "LESS_THAN_OR_EQUAL_TO" "GREATER_THAN_OR_EQUAL_TO" "EQUAL_TO" "NOT_EQUAL_TO" "ADDITION" "MULTIPLICATION" "DIVISION" "SUBTRACTION" "MASK_ALL" "MASK_FIRST_N" "MASK_LAST_N" "VALIDATE_NON_NULL" "VALIDATE_NON_ZERO" "VALIDATE_NON_NEGATIVE" "VALIDATE_NUMERIC" "NO_OP"]

variable "salesforce_task_filters_source_fields" {
  type        = list(string)
  description = "Source fields for Salesforce Task Filters"
  default     = ["Type"]
}

variable "salesforce_task_filters_task_type" {
  type        = string
  description = "Task type for Salesforce Task Filters"
  default     = "Filter"
}

variable "salesforce_task_filters_task_properties" {
  type        = map(string)
  description = "Task properties for Salesforce Task Filters"
  default = {
    "DATA_TYPE" = "picklist"
    "VALUES"    = "savings,current"
  }
}

variable "salesforce_task_filters_connector_operator" {
  type        = string
  description = "Connector operator for Salesforce Task Filters"
  default     = "EQUAL_TO"
}