<<Title
 Way to authorize access to blob
    --via azure AD credentials
    --via account access key
    --via SAS token 
Title

# 1. Create Container with Azure AD credentials
    az login
    # Create resource group
        az group create --name venkiresourcegroup --location eastus
    # Create storage account
        az storage account create --name venkistgacc211 --resource-group venkiresourcegroup --sku standard_ZRS --encryption-services blob
    # Add Storage Blob Data Contributor to the storage account for the log in user 
        az ad signed-in-user show --query objectId -o tsv | az role assignment create ^
        --role "Storage Blob Data Contributor" --assignee @- ^
        --scope "/subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkiresourcegroup/providers/Microsoft.Storage/storageAccounts/venkistgacc211"
    # Create storage container.
        az storage container create --account-name venkistgacc211 --name venkicontainer --auth-mode login
    

# 2. Create container with Access key
    # Get account keys
        az storage account keys list --account-name venkistgacc211 --resource-group venkiresourcegroup
        "yyLYmm1PrFt8UaKj/0387XEAVDRUeFBLNXLzW0FZ0in5IafBadS7Uq0NY2Ao5NePY5zi0+BsulbrptW8bieUdg=="
    # Use key to create container
        az storage container create --account-name venkistgacc211 --name venkicontainer2 --account-key "yyLYmm1PrFt8UaKj/0387XEAVDRUeFBLNXLzW0FZ0in5IafBadS7Uq0NY2Ao5NePY5zi0+BsulbrptW8bieUdg==" ^
        --auth-mode key

# 3. Create container using SAS token
    # Generate a sas token
        az storage account generate-sas --account-key yyLYmm1PrFt8UaKj/0387XEAVDRUeFBLNXLzW0FZ0in5IafBadS7Uq0NY2Ao5NePY5zi0+BsulbrptW8bieUdg== ^
         --account-name venkistgacc211 --expiry 2021-01-01 --https-only --permissions acuw --resource-types co --services bfqt
    
    # Create container with sas token
        az storage container create --account-name venkistgacc211 --name venkicontainer3 ^
            --sas-token "se=2021-01-01&sp=wacu&spr=https&sv=2018-03-28&ss=bqtf&srt=co&sig=ghkhMKvAJnK045eMNxdHqiODR01cFKA%2Brt9WOwStaNU%3D"