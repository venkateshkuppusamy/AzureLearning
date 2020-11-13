# 1. Create a general purpose V2 Storage account (includes blobs, tables, files, queues and disks)
    # Create resource group 
        az group create --name venkiresourcegroup --location eastus
    
    # View list of locaitons to create
        az account list-locations --query "[]" --out table
    
    # Create storage account V2, read access geo redundant storage (RAGRS)
        az storage account create --name venkistgacc777 --resource-group venkiresourcegroup ^
            --location eastus --kind storagev2 --sku standard_RAGRS

    # Delete storage account
        az storage account delete --name venkistgacc777 --resource-group venkiresourcegroup


# 2. Create a BlockBlobStorage account (create block blobs for performance)
        az storage account create --location eastus ^
            --name venkiblockbblobstg777 --resource-group venkiresourcegroup ^
            --kind "BlockBlobStorage" --sku "Premium_LRS"

# 3. Update a V1 or blob storage account to V2 (v2 to v1 or other storage types could not be done)
    az storage account create -g venkiresourcegroup -n venkistraccv1 --kind storage 
    az storage account update -g venkiresourcegroup -n venkistraccv1 --set kind=StorageV2 --access-tier=Hot

# 4. 