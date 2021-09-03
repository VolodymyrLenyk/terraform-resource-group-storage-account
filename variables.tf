variable "sp_service_key" {
  description = "Service Principal for provisioning"
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "location name"
  type        = string
}

variable "gen2_datalake_name" {
  description = "gen2 datalake name"
}

variable "storageaccount_account_tier" {
  description = "storage account access tier"
  default = "Standard"
}

variable "storageaccount_replication_type" {
  description = "storage account replication type"
  default = "LRS"
}

variable "storageaccount_kind" {
  description = "storage account kind"
  default = "StorageV2"
}

variable "storageaccount_is_hns_enabled" {
  description = "storage account is hns enabled"
  default = true 
}

variable "storageaccount_access_tier" {
  description = "storage account access tier"
  default = "Hot"
}

variable "min_tls_version" {
  description = "storage account TLS version"
  default = "TLS1_2"
}

variable "datalake_resource_config" {
  description = "Resource config details"
  type = object(
    {
      datalake_container_list   = list(string)
      enable_archive_raw_data_lifecycle_datalake  = bool
      enable_delete_raw_data_lifecycle_datalake = bool
      enable_cool_refined_data_lifecycle_datalake = bool
      raw_container_prefix_archive = list(string)
      raw_container_prefix_delete = list(string)
      refined_container_prefix_cool = list(string)
      days_after_to_archive_raw_data = number
      days_after_to_delete_raw_data = number
      days_after_to_cool_refined_data = number
    }
  )
}

variable "datalake_permissions" {
  description = "Datalake permissions"
  type = object(
    {
      rw_rights_obj_id = string
    }
  )
}