
# Create a web app and the scale to two instances

# Variables
appName="AppServiceManualScale$random"
location="WestUS"

# Create a Resource Group
az group create --name venkiappservicemanualscalerg --location WestUS

# Create App Service Plans
az appservice plan create --name venkiappserviceplan --resource-group venkiappservicemanualscalerg --location WestUS --sku B1

# Add a Web App
az webapp create --name venkiapp123 --plan venkiappserviceplan --resource-group venkiappservicemanualscalerg

# Deploy your app from local git and test your app

# Scale Web App to 2 Workers
az appservice plan update --number-of-workers 2 --name venkiappserviceplan --resource-group venkiappservicemanualscalerg

az webapp deployment source config-local-git --name venkiapp123 ^
    --resource-group venkiappservicemanualscalerg --query url --output tsv