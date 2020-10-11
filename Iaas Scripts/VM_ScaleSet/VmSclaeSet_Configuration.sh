# View all of instance running under the scale set
az vmss list-instances --resource-group venkirg123 --name venkiscaleset --output table

# View a single instance in vm scale set
az vmss get-instance-view --resource-group venkirg123 --name venkiscaleset --instance-id 1

# get instatnce connection info
az vmss list-instance-connection-info --resource-group venkirg123 --name venkiscaleset

# List vm images
az vm image list --output table

#List vm sizes in location
az vm list-sizes --location eastus --output table

#Change the no of instances for scaleset
az vmss scale  --resource-group venkirg123 --name venkiscaleset --new-capacity 3

# Check no of instances in scaleset
az vmss show --resource-group venkirg123 --name venkiscaleset --query [sku.capacity] --output table

#Stop VM in scale set
az vmss stop --resource-group venkirg123 --name venkiscaleset --instance-ids 1

#deallocate VM in scale set
az vmss deallocate --resource-group venkirg123 --name venkiscaleset --instance-ids 1

#start VM in scale set
az vmss start --resource-group venkirg123 --name venkiscaleset --instance-ids 1


az vmss create --resource-group venkirg123 --name venkiscaleset ^
--image ubuntults --upgrade-policy-mode automatic --instance-count 2 --admin-username azureuser --generate-ssh-keys