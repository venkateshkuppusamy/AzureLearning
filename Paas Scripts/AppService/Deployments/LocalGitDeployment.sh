#!/bin/bash

gitdirectory=<Replace with path to local Git repo>
username=venki241
password=venki#241
webappname=venkilocalgitapp

# Create a resource group.
az group create --location westeurope --name venkideploymentrg

# Create an App Service plan in FREE tier
az appservice plan create --name venkiappserviceplan --resource-group venkideploymentrg --sku FREE

# Create a web app.
az webapp create --name venkilocalgitapp --resource-group venkideploymentrg --plan venkiappserviceplan

# Set the account-level deployment credentials
az webapp deployment user set --user-name venki241 --password venki#241

# Configure local Git and get deployment URL
    az webapp deployment source config-local-git --name venkilocalgitapp ^
    --resource-group venkideploymentrg --query url --output tsv

# https://venki241@venkilocalgitapp.scm.azurewebsites.net/venkilocalgitapp.git

# Add the Azure remote to your local Git respository and push your code
cd $gitdirectory
git remote add azure $url
git push azure master

# When prompted for password, use the value of $password that you specified

# Copy the result of the following command into a browser to see the web app.
echo http://$webappname.azurewebsites.net