# Deploy code from git hub branch to Azure #!/bin/bash

# Replace the following URL with a public GitHub repo URL
gitrepo=https://github.com/Azure-Samples/php-docs-hello-world
webappname=mywebapp$RANDOM

# Create a resource group.
az group create --location westeurope --name venkideploymentrg

# Create an App Service plan in `FREE` tier.
az appservice plan create --name venkiappserviceplan --resource-group venkideploymentrg --sku FREE

# Create a web app.
az webapp create --name venkigithubapp --resource-group venkideploymentrg --plan venkiappserviceplan

# Deploy code from a public GitHub repository. 
az webapp deployment source config --name venkigithubapp --resource-group venkideploymentrg ^
--repo-url https://github.com/Azure-Samples/php-docs-hello-world --branch master --manual-integration

# Copy the result of the following command into a browser to see the web app.
echo http://venkigithubapp.azurewebsites.net