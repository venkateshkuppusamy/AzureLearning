# Create resource group
	az group create --name venkiresourcegroup123 --location eastus
# Create Cosmosdb account
	az cosmosdb create --name venkicosmosdbacc123 --resource-group venkiresourcegroup123
# Get connection string 
	az cosmosdb list-connection-strings --name venkicosmosdbacc123 --resource-group venkiresourcegroup123

https://venkicosmosdbacc123-eastus.documents.azure.com:443/

https://venkicosmosdbacc123.documents.azure.com:443/;
oiEHT4CF9QArPLmbEQlzhGzDFYZ8lUrPUDiKxR7qMz1k8ZZFwzNvABplP3rEei1FNHNqZG8b3GL3Me4g0bzwhA==;