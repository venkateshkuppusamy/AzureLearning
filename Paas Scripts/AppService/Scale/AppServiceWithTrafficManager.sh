
# Variables
trafficManagerDnsName="venkitrafficmanagerdns"
app1Name="venkiappservice1"
app2Name="venkiappservice2"
location1="WestUS"
location2="EastUS"

# Create a Resource Group
    az group create --name venkitraffimanagerrg --location WestUS

# Create a Traffic Manager Profile
    az network traffic-manager profile create --name venkitraffimanagerrgprofile --resource-group venkitraffimanagerrg --routing-method Performance --unique-dns-name venkitrafficmanagerdns

# Create App Service Plans in two Regions
    az appservice plan create --name venkiappservice1-Plan --resource-group venkitraffimanagerrg --location WestUS --sku S1
    az appservice plan create --name venkiappservice2-Plan --resource-group venkitraffimanagerrg --location EastUS --sku S1

# Add a Web App to each App Service Plan
    az webapp create --name venkiappservice1 --plan venkiappservice1-Plan --resource-group venkitraffimanagerrg --query id --output tsv
    # id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkitraffimanagerrg/providers/Microsoft.Web/sites/venkiappservice1
    az webapp create --name venkiappservice2 --plan venkiappservice2-Plan --resource-group venkitraffimanagerrg --query id --output tsv
    # id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkitraffimanagerrg/providers/Microsoft.Web/sites/venkiappservice2
# Assign each Web App as an Endpoint for high-availabilty
    az network traffic-manager endpoint create -n venkiappservice1-WestUS --profile-name venkitraffimanagerrgprofile -g venkitraffimanagerrg --type azureEndpoints --target-resource-id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkitraffimanagerrg/providers/Microsoft.Web/sites/venkiappservice1
    az network traffic-manager endpoint create -n venkiappservice2-EastUS --profile-name venkitraffimanagerrgprofile -g venkitraffimanagerrg --type azureEndpoints --target-resource-id /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkitraffimanagerrg/providers/Microsoft.Web/sites/venkiappservice2


https://venki241@venkiappservice1.scm.azurewebsites.net/venkiappservice1.git
https://venki241@venkiappservice2.scm.azurewebsites.net/venkiappservice2.git

# Delete resource group
    az group delete --name venkitraffimanagerrg