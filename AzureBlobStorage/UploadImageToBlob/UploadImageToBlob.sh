# 1. Create storage accoun and contianers, azure app service plan and app service via azure cli

    # Create resoruce group
        az group create --name venkiblobstoragerg --location eastus

    # Create a storage account
        az storage account create --name venkistgacc098 --resource-group venkiblobstoragerg --sku standard_lrs --kind storagev2 --access-tier hot

    # Create storage containers using access keys
        az storage account keys list  --resource-group venkiblobstoragerg --account-name venkistgacc098 --query "[0].value" --output tsv
        "sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA=="
        az storage container create --name images --account-name venkistgacc098 --account-key "sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA=="
        az storage container create --name thumbnails --account-name venkistgacc098 --account-key "sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA=="

    # Create an app service plan
        az appservice plan create --name venkiappserviceplan098 --resource-group venkiblobstoragerg --sku free
        az webapp create --name venkiwebapp098 --resource-group venkiblobstoragerg --plan venkiappserviceplan098

# 2. Create a .net web app and upload to azure app service set app setting 
    # Deploy the sample app from git hub repository and deploy it to web app

    # set the deployment source for the web app
    az webapp deployment source config --name venkiwebapp098 --resource-group venkiblobstoragerg ^
  --branch master --manual-integration --repo-url https://github.com/Azure-Samples/storage-blob-upload-from-webapp

    # set the app setting for the web app
    az webapp config appsettings set --name venkiwebapp098 --resource-group venkiblobstoragerg --settings AzureStorageConfig__AccountName=venkistgacc098 ^
    AzureStorageConfig__ImageContainer=images ^
    AzureStorageConfig__ThumbnailContainer=thumbnails ^
    AzureStorageConfig__AccountKey="sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA=="

# 3. Create a azure function which runs when Azure event grid is triggered

    # Register provider for azure event grid
        az provider register --namespace Microsoft.EventGrid
    
    # Create azure function app
        az functionapp create --name venkifuncapp098 --storage-account venkistgacc098 --resource-group venkiblobstoragerg --consumption-plan-location eastus ^
            --functions-version 2
    
    # Add blob connection string to function app
        az storage account show-connection-string --resource-group venkiblobstoragerg ^
          --name venkistgacc098 --query connectionString --output tsv
        "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=venkistgacc098;AccountKey=sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA=="
        
        az functionapp config appsettings set --name venkifuncapp098 --resource-group venkiblobstoragerg ^
        --settings AzureWebJobsStorage="DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=venkistgacc098;AccountKey=sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA==" THUMBNAIL_CONTAINER_NAME=thumbnails THUMBNAIL_WIDTH=100 FUNCTIONS_EXTENSION_VERSION=~2

    # Set deployment source for function app
        az functionapp deployment source config --name venkifuncapp098 --resource-group venkiblobstoragerg --branch master --manual-integration ^
        --repo-url https://github.com/Azure-Samples/function-image-upload-resize

    # Create Event grid subscription for Blob created and deleted event to te processed by Azure function
        # Go to Function app --> Fuctions --> Integration
        # Select Event Grid trigger --> Create Event grid subscripton
        # In the Create event subscription forms window, select the storage account and container, then select the event types to get
        # notified to the funciton app.

# 4. Access blob using sas tokent
    # Disable public access to containers
        az storage container set-permission --account-name venkistgacc098 ^
            --account-key "sFdkuQbV1pk+7oZv2ANm7nUyYUBHYSPgLrTzBpERSYhJQSW1U+r28m1J3VfsIEeLURKh23WnJmpHTwlR8oQiIA==" ^
            --name thumbnails --public-access off
        
    # Deploy new branch which accesses blob using sas token
        az webapp deployment source delete --name venkifuncapp098 --resource-group venkiblobstoragerg

        az webapp deployment source config --name venkifuncapp098 ^
        --resource-group venkiblobstoragerg --branch sasTokens --manual-integration ^
        --repo-url https://github.com/Azure-Samples/storage-blob-upload-from-webapp