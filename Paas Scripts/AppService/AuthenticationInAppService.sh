# 1. Create a local web app
    git clone https://github.com/Azure-Samples/dotnet-core-api
    cd dotnet-core-api
    dotnet run

# Configure a deployment user
    az webapp deployment user set --user-name venki241 --password venki#241


# 2. Create Azure resources for Depolyment.
    
    # create resoruce group
        az group create --name venkiappservicerg --location "West Europe"
    # create appservice plan
        az appservice plan create --name venkiappserviceplan --resource-group venkiappservicerg --sku FREE --is-linux
    # create web app for front end
        az webapp create --resource-group venkiappservicerg --plan venkiappserviceplan --name venkifrontendapp --runtime "DOTNETCORE|3.1" --deployment-local-git --query deploymentLocalGitUrl
        # Deployment url "https://venki241@venkifrontendapp.scm.azurewebsites.net/venkifrontendapp.git"

    # create web app for back end
        az webapp create --resource-group venkiappservicerg --plan venkiappserviceplan --name venkibackendapp --runtime "DOTNETCORE|3.1" --deployment-local-git --query deploymentLocalGitUrl
        # Deployment url "https://venki241@venkibackendapp.scm.azurewebsites.net/venkibackendapp.git"

# 3. Push code to azure

    git remote add backend https://venki241@venkibackendapp.scm.azurewebsites.net/venkibackendapp.git
    git push backend master

    git remote add frontend https://venki241@venkifrontendapp.scm.azurewebsites.net/venkifrontendapp.git
    git push frontend master


# 4. Update chagnes to code push to frond end app
        git add .
        git commit -m "call back-end API"
        git push frontend master

# 5. Add authentication and authorization

    # Enable authentication and authroization for back end app via portal

    # client id for back end app.
        d7e326df-f272-43bc-8245-3baba45692d1


    az webapp cors add --resource-group venkiappservicerg --name venkibackendapp --allowed-origins 'https://venkifrontendapp.azurewebsites.net'

