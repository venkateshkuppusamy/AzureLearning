
# Create Cosmos db account

az group create --name venkiresourcegroup --location eastus

az cosmosdb create --resource-group venkiresourcegroup --name venkicosmosdb123 --kind GlobalDocumentDB ^
	--locations regionName="South Central US" failoverPriority=0 --locations regionName="North Central US" failoverPriority=1 ^
	--default-consistency-level "Session" --enable-multiple-write-locations true

az cosmosdb list-connection-strings --name venkicosmosdb123 --resource-group venkiresourcegroup

#AccountEndpoint=https://venkicosmosdb123.documents.azure.com:443/;AccountKey=Sq77VnJ2B2qWsiMpDJlZX9uzZ51CSe7zIhgwSSKbma8138B7oXP5CZATI0cBSHz6pbqykY2JEkJrqk8Nlj6mXg==;

az group delete -g "venkiresourcegroup"