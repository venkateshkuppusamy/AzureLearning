
# 1. Create a static web site
# 2. Push code to a default Azure app service


# 1. Create a static web site
    mkdir quickstart
    cd quickstart

    git clone https://github.com/Azure-Samples/html-docs-hello-world.git

    cd html-docs-hello-world

# 2. Push code to a default Azure app service
    # Create a default Azure app service, the below command creates a default resource group, app service plan, web app
        az webapp up --location westeurope --name venkiapp123 --html

# Delete resource group
    az group delete --name venki86_ece_rg_Windows_westeurope