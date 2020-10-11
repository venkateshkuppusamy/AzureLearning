
#Bash Scripts to create VM and manage VM.

# Create Resource group
az group create --resource-group venkivmrg --location eastus

# Create a ubuntu linux VM
az vm create --resource-group venkivmrg --name venkivm --image ubuntults --admin-username venkiuser --generate-ssh-keys

#login to linux machine
ssh venkiuser@52.188.121.52

#Get list of VM image available in azure market place.
az vm image list --output table

# or the below command to filter by OS type, the below take time to query results
az vm image list --offer CentOS --all --output table

# Create a new VM from the available images.

# Get List of sizes supported in a specific location
# shows the no of cores, ram size, data disc count, data disk size.
az vm list-sizes --location eastus --output table

# Create a ubuntu vm with a specific size supported by the location
az vm create --resource-group venkivmrg --name venkivm2 --image UbuntuLTS --size Standard_F1s --generate-ssh-keys

# Resize VM size
# Check the current size of vm
az vm show --resource-group venkivmrg --name venkivm2 --query hardwareProfile.vmSize

# then check for the resize option for vm supported in current azure cluster
az vm list-vm-resize-options --resource-group venkivmrg --name venkivm2 --query [].name

# If available, change size with power on state, only rebooting required
az vm resize --resource-group venkivmrg --name venkivm2 --size Standard_F2s

# If not available, deallocate vm, then resize then start the vm
az vm deallocate --resource-group venkivmrg --name venkivm2
az vm resize --resource-group venkivmrg --name venkivm2 --size Standard_GS1
az vm start --resource-group venkivmrg --name venkivm2

# Get the state of a VM
# possible power states or a VM, starting, running, stopping, stopped, deallocating, deallocated
az vm get-instance-view --resource-group venkivmrg --name venkivm2 --query instanceView.statuses[1] --output table

# Get ip address, return public ip and private ip
az vm list-ip-addresses --resource-group venkivmrg --name venkivm2 --output table

# start vm
az vm start --resource-group venkivmrg --name venkivm2

# stop vm
az vm stop --resource-group venkivmrg --name venkivm2

# delete resource group
az group delete --resource-group venkivmrg






