1. To create an Azure Storage Account and a blob container, we can use either the Azure portal (https:/ / docs. microsoft. com/ en- gb/ azure/ storage/ common/ storage- quickstart- create- account? tabs= azure- portal) or an az cli script:

    # 1-Create resource group
    az group create --name MyRgRemoteBackend --location westeurope

    # 2-Create storage account
    az storage account create --resource-group MyRgRemoteBackend --name storagerbtf --sku Standard_LRS --encryption-services blob

    # 3-Get storage account key
    ACCOUNT_KEY=$(az storage account keys list --resource-group MyRgRemoteBackend --account-name storagerbtf --query [0].value -o tsv)

    # 4-Create blob container
    az storage container create --name tfbackends --account-name storagerbtf --account-key $ACCOUNT_KEY

This script creates a <MyRgRemoteBackend> resource group and a storage account, <storageremotetf>.
Then, the script retrieves the key account from the storage account and creates a blob container, tfbackends, in this storage account.
This script can be run in Azure Cloud Shell, and the advantage of using a script rather than using the Azure portal is that this script can be integrated into a CI/CD process.

2. Then, to configure Terraform to use the previously created remote backend, we must add the configuration section in the Terraform.tf file:

terraform {
    backend "azurerm" {
        storage_account_name = "storageremotetfdemo"
        container_name       = "tfbackends"
        key                  = "myappli.tfstate"
    }
}