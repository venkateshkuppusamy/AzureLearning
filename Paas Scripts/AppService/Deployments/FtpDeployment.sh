# FTP deployment to app service


#!/bin/bash

warurl=https://raw.githubusercontent.com/Azure-Samples/html-docs-hello-world/master/index.html
webappname=mywebapp$RANDOM

# Download sample static HTML page
curl https://raw.githubusercontent.com/Azure-Samples/html-docs-hello-world/master/index.html --output index.html

# Create a resource group.
az group create --location westeurope --name venkideploymentrg

# Create an App Service plan in `FREE` tier.
az appservice plan create --name venkiappserviceplan --resource-group venkideploymentrg --sku FREE

# Create a web app.
az webapp create --name venkiftpapp --resource-group venkideploymentrg --plan venkiappserviceplan

# Get FTP publishing profile and query for publish URL and credentials
az webapp deployment list-publishing-profiles --name venkiftpapp --resource-group venkideploymentrg ^
--query "[?contains(publishMethod, 'FTP')].[publishUrl,userName,userPWD]" --output tsv

# Use cURL to perform FTP upload. You can use any FTP tool to do this instead. 
curl -T index.html -u venkiftpapp:KoNvT5YQuyThYgGCFDockSRWgJ0mc3WzWtiRjtRljNJpzgr6xl8ZRyAeRZoW ftp://waws-prod-am2-061.ftp.azurewebsites.windows.net/site/wwwroot/

# Copy the result of the following command into a browser to see the static HTML site.
echo http://venkiftpapp.azurewebsites.net