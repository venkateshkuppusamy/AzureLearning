# Troubleshoot app service problem with Azure monitor

# 1. Push base code to Azure App service 
# Download the sample code from below git repository
    git clone https://github.com/Azure-Samples/App-Service-Troubleshoot-Azure-Monitor

# Create resource group name     
    az group create --name venkiazuremonitorrg --location "South Central US"

# Create a deployment user
    az webapp deployment user set --user-name <username> --password <password>
    az webapp deployment user show 
    # venki241 venki#241
# Create app service plan and web app
    az appservice plan create --name venkiazuremonitorplan --resource-group venkiazuremonitorrg --sku B1 --is-linux
    az webapp create --resource-group venkiazuremonitorrg --plan venkiazuremonitorplan --name venkiphpapp --runtime "PHP|7.3" --deployment-local-git
    # deployment url https://venki241@venkiphpapp.scm.azurewebsites.net/venkiphpapp.git
# Push code to Azure from git
    git remote add azure https://venki241@venkiphpapp.scm.azurewebsites.net/venkiphpapp.git
    git push azure master


# Configure Azure monitor

    # Azure monitor log analytics work space
        az monitor log-analytics workspace create --resource-group venkiazuremonitorrg --workspace-name venkiazuremonitorworkspace

    # Create Diagnostic settings for app service console logs and appservice http logs
        az webapp show -g venkiazuremonitorrg -n venkiphpapp --query id --output tsv
        # resource id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkiazuremonitorrg/providers/Microsoft.Web/sites/venkiphpapp

        az monitor log-analytics workspace show -g venkiazuremonitorrg --workspace-name venkiazuremonitorworkspace --query id --output tsv
        # workspace id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourcegroups/venkiazuremonitorrg/providers/microsoft.operationalinsights/workspaces/venkiazuremonitorworkspace

        # set diagnostic setting
            az monitor diagnostic-settings create --resource /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkiazuremonitorrg/providers/Microsoft.Web/sites/venkiphpapp ^
            --workspace /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourcegroups/venkiazuremonitorrg/providers/microsoft.operationalinsights/workspaces/venkiazuremonitorworkspace ^
            -n myMonitorLogs --logs "[{\"category\": \"AppServiceConsoleLogs\", \"enabled\": true}, {\"category\": \"AppServiceHTTPLogs\", \"enabled\": true}]"
    


# Delete resoruce group and azure monitor settings
    az monitor diagnostic-settings delete --resource $resourceID -n myMonitorLogs