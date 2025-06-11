output "salesforce_to_s3_flow_arn" {
  value       = aws_appflow_flow.appflow_salesforce_to_s3.arn
  description = "ARN of the Salesforce to S3 AppFlow flow"
}

output "salesforce_to_s3_flow_status" {
  value       = aws_appflow_flow.appflow_salesforce_to_s3.flow_status
  description = "Status of the Salesforce to S3 AppFlow flow"
}

output "salesforce_to_s3_flow_id" {
  value       = aws_appflow_flow.appflow_salesforce_to_s3.id
  description = "ID of the Salesforce to S3 AppFlow flow"
}