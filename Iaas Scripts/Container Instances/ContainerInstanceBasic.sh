# Create resource group
    az group create --name venkicirg123 --location eastus

# Create an Azure container, specifiy name of resrouce group, container name, docker image, dns name(uses to create fqdn)
    az container create --resource-group venkicirg123 --name venkicontainer --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label venki-aci-demo --ports 80

# Show status of azure container
    az container show --resource-group venkicirg123 --name venkicontainer --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

# View container logs for troubleshooting
    az container logs --resource-group venkicirg123 --name venkicontainer

# Attach application console output to container's output streams
    az container attach --resource-group venkicirg123 --name venkicontainer

# Delete container
    az container delete --resource-group venkicirg123 --name venkicontainer

    az container list --resource-group venkicirg123 --output table

# Delete resource group
    az group delete --name venkicirg123
