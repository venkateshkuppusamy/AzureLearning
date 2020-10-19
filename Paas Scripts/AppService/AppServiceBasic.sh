# 1. Create a sample .net code in local
# 2. Set up Azure app service
# 3. Push to Azure from local git.

# 1. Create a sample web app

    mkdir hellodotnetcore
    cd hellodotnetcore

    dotnet new web
    dotnet run

    # Initialise git repository
        git init
        git add .
        git commit -m "first commit"

    # Create a deployment user
        az webapp deployment user set --user-name venki241 --password venki#241


# 2. Set up Azure app service
    # Create resource group
        az group create --name venkiappservicerg --location "West Europe"

    # Create app service plan
        az appservice plan create --name venkiappsericeplan1 --resource-group venkiappservicerg --sku F1 --is-linux

    # Add web app to plan
        az webapp create --resource-group venkiappservicerg --plan venkiappsericeplan1 --name venkiwebapp124 ^
        --runtime "DOTNETCORE|3.1" --deployment-local-git
    
    # "deploymentLocalGitUrl": "https://venki241@venkiwebapp124.scm.azurewebsites.net/venkiwebapp124.git"

# 3. Push to azure from local

    git remote add azure https://venki241@venkiwebapp124.scm.azurewebsites.net/venkiwebapp124.git
    git push azure master

    # Modify you code and push you changes to azure

    git commit -am "updated output"
    git push azure master




    