terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.62.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.sp_service_key["subscription_id"]
  client_id       = var.sp_service_key["client_id"]
  client_secret   = var.sp_service_key["client_secret"]
  tenant_id       = var.sp_service_key["tenant_id"]
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "gen2_datalake" {
  name                     = var.gen2_datalake_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storageaccount_account_tier
  account_replication_type = var.storageaccount_replication_type
  account_kind             = var.storageaccount_kind
  is_hns_enabled           = var.storageaccount_is_hns_enabled
  min_tls_version          = var.min_tls_version

  access_tier              = var.storageaccount_access_tier
  network_rules {
    default_action         = "Allow"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gen2_datalake_containers" {
  count              = length(var.datalake_resource_config["datalake_container_list"])
  name               = var.datalake_resource_config["datalake_container_list"][count.index]
  storage_account_id = azurerm_storage_account.gen2_datalake.id

  ace {
    scope       = "access"
    type        = "group"
    id          = var.datalake_permissions["rw_rights_obj_id"]
    permissions = "rwx"
  }
  ace {
    scope       = "default"
    type        = "group"
    id          = var.datalake_permissions["rw_rights_obj_id"]
    permissions = "rwx"
  }
}

resource "azurerm_storage_management_policy" "data_lifecycle_datalake" {
  storage_account_id = azurerm_storage_account.gen2_datalake.id

  rule {
    name    = "archive-raw-data-lifecycle-datalake"
    enabled = var.datalake_resource_config["enable_archive_raw_data_lifecycle_datalake"]
    filters {
      prefix_match = var.datalake_resource_config["raw_container_prefix_archive"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = var.datalake_resource_config["days_after_to_archive_raw_data"]
      }
    }
  }

  rule {
    name    = "delete-raw-data-lifecycle-datalake"
    enabled = var.datalake_resource_config["enable_delete_raw_data_lifecycle_datalake"]
    filters {
      prefix_match = var.datalake_resource_config["raw_container_prefix_delete"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.datalake_resource_config["days_after_to_delete_raw_data"]
      }
    }
  }

  rule {
    name    = "cool-refined-data-lifecycle-datalake"
    enabled = var.datalake_resource_config["enable_cool_refined_data_lifecycle_datalake"]
    filters {
      prefix_match = var.datalake_resource_config["refined_container_prefix_cool"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = var.datalake_resource_config["days_after_to_cool_refined_data"]
      }
    }
  }
}