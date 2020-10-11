# Create VM in a available set
# this will ensure VM with high availablity, each VM is has diffent fault domain and update domain

# Create resource group 
az group create --name venkirgavailset --location eastus

# create availablity set with 2 fault domain and 2 update domain
az vm availability-set create --resource-group venkirgavailset ^
    --name venkiAvailabilitySet ^
    --platform-fault-domain-count 2 ^
    --platform-update-domain-count 2

# Create 2 VMs in availabiliy set, so that each has different availablit set and domain set
   az vm create ^
     --resource-group venkirgavailset ^
     --name myVM1 ^
     --availability-set venkiAvailabilitySet ^
     --size Standard_F1s  ^
     --vnet-name myVnet ^
     --subnet mySubnet ^
     --image UbuntuLTS ^
     --admin-username venkiuser ^
     --generate-ssh-keys

az vm create ^
     --resource-group venkirgavailset ^
     --name myVM2 ^
     --availability-set venkiAvailabilitySet ^
     --size Standard_F1s  ^
     --vnet-name myVnet ^
     --subnet mySubnet ^
     --image UbuntuLTS ^
     --admin-username venkiuser ^
     --generate-ssh-keys


# Check for the VM size supported by the 
az vm availability-set list-sizes ^
     --resource-group venkirgavailset ^
     --name venkiAvailabilitySet ^
     --output table

     