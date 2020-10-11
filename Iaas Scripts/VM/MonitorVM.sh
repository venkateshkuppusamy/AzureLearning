# VM Monitorying


# 1. Create VM

    # create resrouce group
        az group create --name venkivmrg --location eastus

    # create vm
        az vm create --resource-group venkivmrg --name venkivm --image ubuntults --admin-user venkiuser --generate-ssh-keys


# 2. Enable boot diagnostics

    # create storage account to save the boot diagnostics data
        az storage account create --resource-group venkivmrg --name venkistoragediag --sku standard_LRS --location eastus

    # Get storage blob endpoint
        az storage account show --resource-group venkivmrg --name venkistoragediag --query "primaryEndpoints.blob" -o tsv
    # https://venkistoragediag.blob.core.windows.net/

    # enable boot diagnostics to the VM, specify the blob uri.
        az vm boot-diagnostics enable --resource-group venkivmrg --name venkivm --storage https://venkistoragediag.blob.core.windows.net/

# 3. View VM's boot process logs

    # delloacte the vm and then start vm, boot diagnostics will be logged to the storage container.
        az vm deallocate --resource-group venkivmrg --name venkivm
        az vm start --resource-group venkivmrg --name venkivm

    # Get boot info for vm
        az vm boot-diagnostics get-boot-log --resource-group venkivmrg --name venkivm

az group delete --name venkivmrg
