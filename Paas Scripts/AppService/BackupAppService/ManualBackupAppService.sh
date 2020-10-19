
groupname="myResourceGroup"
planname="myAppServicePlan"
webappname=mywebapp$RANDOM
storagename=mywebappstorage$RANDOM
location="WestEurope"
container="appbackup"
backupname="backup1"
expirydate=$(date -I -d "$(date) + 1 month")

# Create a Resource Group 
az group create --name venkibackuprg --location WestEurope

# Create a Storage Account
az storage account create --name venkibackupstgacc --resource-group venkibackuprg --location WestEurope --sku Standard_LRS

# Create a storage container
az storage container create --account-name venkibackupstgacc --name venkibackupcontainer

# Generates an SAS token for the storage container, valid for one month.
# NOTE: You can use the same SAS token to make backups in App Service until --expiry
az storage container generate-sas --account-name venkibackupstgacc --name venkibackupcontainer --expiry "2021-01-01T00:00:00Z"  --permissions rwdl --output tsv
# se=2021-01-01T00%3A00%3A00Z&sp=rwdl&sv=2018-11-09&sr=c&sig=qadUGglaQcxGJu4ucGaxjvX5XcNC9vzmPLnBjTM73QU%3D

# Construct the SAS URL for the container
sasurl=https://venkibackupstgacc.blob.core.windows.net/venkibackupcontainer?se=2021-01-01T00%3A00%3A00Z&sp=rwdl&sv=2018-11-09&sr=c&sig=qadUGglaQcxGJu4ucGaxjvX5XcNC9vzmPLnBjTM73QU%3D

# Create an App Service plan in Standard tier. Standard tier allows one backup per day.
az appservice plan create --name venkiappbkpplan --resource-group venkibackuprg --location WestEurope --sku S1

# Create a web app
az webapp create --name venkiapp123 --plan venkiappbkpplan --resource-group venkibackuprg

https://venki241@venkiapp123.scm.azurewebsites.net/venkiapp123.git

# Create a one-time backup
az webapp config backup create --resource-group venkibackuprg --webapp-name venkiapp123 --backup-name venkiapp123bkp --container-url https://venkibackupstgacc.blob.core.windows.net/venkibackupcontainer?se=2021-01-01T00%3A00%3A00Z&sp=rwdl&sv=2018-11-09&sr=c&sig=qadUGglaQcxGJu4ucGaxjvX5XcNC9vzmPLnBjTM73QU%3D

# List statuses of all backups that are complete or currently executing.
az webapp config backup list --resource-group venkibackuprg --webapp-name venkiapp123