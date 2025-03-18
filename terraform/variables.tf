variable "project" {
  description = "Project"
  default     = "ny-rides-gregl-446219"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "nyc_ems_calls_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "nyc-ems-calls-446219-gl"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}