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