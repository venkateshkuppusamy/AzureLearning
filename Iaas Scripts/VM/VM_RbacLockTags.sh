# Add Roles, Policy, Locks and Tags to VM

# Create resource group
    az group create --resource-group venkirg123 --location eastus

# Create Role assignment
    az ad group show --group parent --query objectId --output tsv
    # adgroup = efbcfb46-deb3-46b4-832e-2ce0a9d34d62
    az role assignment create --assignee-object-id efbcfb46-deb3-46b4-832e-2ce0a9d34d62 --role "Virtual Machine Contributor" --resource-group venkirg123

# View the available azure policy definitions
    az policy definition list --query "[].[displayName, policyType, name]" --output table


# Get policy definitions for allowed locations, allowed SKUs, and auditing VMs that don't use managed disks
    az policy definition list --query "[?displayName=='Allowed locations'].name | [0]" --output tsv
    # locationdefinition_policy e56962a6-4747-49cd-b67b-bf8b01975c4c

    az policy definition list --query "[?displayName=='Allowed virtual machine size SKUs'].name | [0]" --output tsv
    # sukdefinition_policy cccc23c7-8427-4f53-ad12-b6a63eb452b3

    az policy definition list --query "[?displayName=='Audit VMs that do not use managed disks'].name | [0]" --output tsv
    # auditdefinition_policy 06a78e20-9358-41c9-923c-fb736d382a4d

# Assign policy for allowed locations
    az policy assignment create --name "Set permitted locations" --resource-group venkirg123 --policy e56962a6-4747-49cd-b67b-bf8b01975c4c ^
    --params "{\"listOfAllowedLocations\": {\"value\": [\"eastus\",\"eastus2\"]}}"

# Assign policy for allowed SKUs
    az policy assignment create --name "Set permitted VM SKUs" --resource-group venkirg123 --policy cccc23c7-8427-4f53-ad12-b6a63eb452b3 ^
    --params "{\"listOfAllowedSKUs\": {\"value\": [\"Standard_DS1_v2\",\"Standard_E2s_v2\"]}}"

# Assign policy for auditing unmanaged disks
    az policy assignment create --name "Audit unmanaged disks" --resource-group venkirg123 --policy 06a78e20-9358-41c9-923c-fb736d382a4d 

#View policy assignment
    az policy definition show --name e56962a6-4747-49cd-b67b-bf8b01975c4c --query parameters

#Deploy the Virtual machine
    az vm create --resource-group venkirg123 --name venkiVm --image UbuntuLTS --generate-ssh-keys

#Lock resource for accidental deletion of resource

    # Add CanNotDelete lock to the VM
        az lock create --name LockVM --lock-type CanNotDelete --resource-group venkirg123 --resource-name venkiVm --resource-type Microsoft.Compute/virtualMachines

    # Add CanNotDelete lock to the network security group
        az lock create --name LockNSG --lock-type CanNotDelete --resource-group venkirg123 --resource-name venkiVmNSG --resource-type Microsoft.Network/networkSecurityGroups

    # Try deleting the resource group 
        az group delete --name venkirg123

    # Remove lock
    # Get lock ids
    az lock show --name LockVM --resource-group venkirg123 --resource-type Microsoft.Compute/virtualMachines --resource-name venkiVm --output tsv --query id
    az lock show --name LockNSG --resource-group venkirg123 --resource-type Microsoft.Network/networkSecurityGroups --resource-name venkiVmNSG --output tsv --query id

    # Delete locks 
    az lock delete --ids /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourcegroups/venkirg123/providers/Microsoft.Compute/virtualMachines/venkiVm/providers/Microsoft.Authorization/locks/LockVM ^
    /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourcegroups/venkirg123/providers/Microsoft.Network/networkSecurityGroups/venkiVmNSG/providers/Microsoft.Authorization/locks/LockNSG


#Tag resources to logicaly group resources
    # Add tag to resource group
        az group update -n venkirg123 --set tags.Environment=Dev tags.Dept=IT
        az group update -n venkirg123 --set tags.Project=Documentation
    
    # Remove tags to resource group
        az group update -n venkirg123 --remove tags

    # Apply tag to VM, 
        az resource tag -n venkiVm -g venkirg123 --tags Dept=IT Environment=Test Project=Documentation --resource-type "Microsoft.Compute/virtualMachines"
    # Apply tag clears existing tags on VM
        az resource tag -n venkiVm -g venkirg123 --tags Team=HCL --resource-type "Microsoft.Compute/virtualMachines"
    # Get Resource list by tags
        az resource list --tag Team=HCL --query [].name
    # Execute command on azure resource based on tags, like stop vm by tags
        # Get id of VMs
        az resource list --tag Team=HCL --query "[?type=='Microsoft.Compute/virtualMachines'].id" --output tsv
        # stop vm by id
        az vm stop --ids /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkirg123/providers/Microsoft.Compute/virtualMachines/venkiVm
    