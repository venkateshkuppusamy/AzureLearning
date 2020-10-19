
# Replace the following URL with a public GitHub repo URL
gitrepo=https://github.com/venkateshkuppusamy/SampleCoreApp.git
webappname=venkislotapp

# Create a resource group.
    az group create --location westeurope --name venkideploymentslotrg

# Create an App Service plan in STANDARD tier (minimum required by deployment slots).
    az appservice plan create --name venkislotappplan --resource-group venkideploymentslotrg --sku S1

# Create a web app.
    az webapp create --name venkislotapp --resource-group venkideploymentslotrg --plan venkislotappplan

#Create a deployment slot with the name "staging".
    az webapp deployment slot create --name venkislotapp --resource-group venkideploymentslotrg --slot staging

# Deploy sample code to "staging" slot from GitHub.
    az webapp deployment source config --name venkislotapp --resource-group venkideploymentslotrg --slot staging --repo-url https://github.com/venkateshkuppusamy/SampleCoreApp.git --branch master --manual-integration
        or 
    az webapp deployment source config --name venkislotapp --resource-group venkideploymentslotrg --slot staging --repo-url https://github.com/venkateshkuppusamy/SampleCoreApp.git --branch master --git-token 6449a85c6a96f134f4118a1142c62d6e2b663022

#Git hub token 6449a85c6a96f134f4118a1142c62d6e2b663022

# Copy the result of the following command into a browser to see the staging slot.
    echo http://venkislotapp-staging.azurewebsites.net

# Swap the verified/warmed up staging slot into production.
    az webapp deployment slot swap --name venkislotapp --resource-group venkideploymentslotrg --slot staging

# Copy the result of the following command into a browser to see the web app in the production slot.
    echo http://venkislotapp.azurewebsites.net