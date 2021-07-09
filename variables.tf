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
  default = "hot"
}