
# Variables
appName="AppServiceMonitor$random"
location="WestUS"

# Create a Resource Group
az group create --name venkiappservicerg --location westus

# Create an App Service Plan
az appservice plan create --name venkiappserviceplan --resource-group venkiappservicerg --location westus

# Create a Web App and save the URL
    az webapp create --name venkiapp123 --plan venkiappserviceplan --resource-group venkiappservicerg --query defaultHostName | sed -e 's/^"//' -e 's/"$//'
    #url venkiapp123.azurewebsites.net
# Enable all logging options for the Web App
    az webapp log config --name venkiapp123 --resource-group venkiappservicerg --application-logging filesystem --detailed-error-messages true --failed-request-tracing true --web-server-logging filesystem

# Create a Web Server Log
curl -s -L $url/404

# Download the log files for review
az webapp log download --name venkiapp123 --resource-group venkiappservicerg