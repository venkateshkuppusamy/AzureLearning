
# Create and deploy a function in Azure

# 1. Create and run Azure function locally
    # Install Azure function core tools

    # Create a local function project
        func init LocalFunctionProj --dotnet

    # Add Http trigger function with in the project
        func new --name HttpExample --template "HTTP trigger"

    # Run the function
        func start

# 2. Create Azure function app 

        # Create resource group
            az group create --name venkifunctionrg --location westeurope
        
        # Create a storage account
            az storage account create --name venkistgact --location westeurope --resource-group venkifunctionrg --sku Standard_LRS
        
        # Create a function app
            az functionapp create --name venkifuncapp --resource-group venkifunctionrg --consumption-plan-location westeurope --runtime dotnet --functions-version 3 --storage-account venkistgact
        
# 3. Deploy location function app to azure function app.
    # Use the publish command function to deploy to azure function app.
        func azure functionapp publish venkifuncapp

    # check function app logs in browser
        func azure functionapp logstream venkifuncapp --browser

    # Delete resource group
        az group delete --name venkifunctionrg