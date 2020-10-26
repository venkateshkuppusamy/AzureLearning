# Create a basic blob storage

# Create a resource group
    az group create --name venkistoragerg --location eastus

# Create a storage account
    az storage account create --name venkistgacc123 --location eastus --resource-group venkistoragerg ^
    --sku standard_ZRS --encryption-services blob

# Add Storage Blob Data Contributor role to single in user for the storage account
    az ad signed-in-user show --query objectId -o tsv | az role assignment create ^
    --role "Storage Blob Data Contributor" --assignee @- ^
    --scope "/subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkistoragerg/providers/Microsoft.Storage/storageAccounts/venkistgacc123"
# Create a contatiner
    az storage container create --account-name venkistgacc123 --name venkicontainer --auth-mode login

# Upload a blob
    az storage blob upload  --account-name venkistgacc123 --container-name venkicontainer --name helloworld ^
    --file helloworld --auth-mode login

# Show blobs in container
    az storage blob list --account-name venkistgacc123 --container-name venkicontainer --output table --auth-mode login

# Download blob from container
    az storage blob download --account-name venkistgacc123 --container-name venkicontainer --name helloworld ^
    --file "downloads\helloword.txt" --auth-mode login

# Azcopy to upload
    azcopy login --identity --identity-object-id "5e76b854-b4c9-4f66-887c-0a75559724dc"
    azcopy copy "downloads\helloword.txt" "https://venkistgacc123.blob.core.windows.net/venkicontainer/myTextFile.txt"

    azcopy copy "C:\Users\venki\source\repos\Github\venkateshkuppusamy\AZ204\AzureCompute\AzureBlobStorage\downloads\helloword.txt" "https://venkistgacc123.blob.core.windows.net/venkicontainer/myTextFile.txt?sv=2019-12-12&ss=bfqt&srt=c&sp=rwdlacupx&se=2020-10-26T01:46:55Z&st=2020-10-25T17:46:55Z&spr=https&sig=hT2JAQoj8crEJc9XHFLVuo9WXIKjMl6mKOfRTWn%2BBiM%3D"
    
# Delete resource group
    az group delete --name venkistoragerg
