# Development requisties -  Azure Cli and Docker.

# 1. Create Docker image locally and test it
    # Install Docker desktop for windows

    # Sample docker file to build the docker image from
        git clone https://github.com/Azure-Samples/aci-helloworld.git

    # Create a docker image from the repositiory downloaded. The repository should have a docker file.
        docker build ./aci-helloworld -t aci-tutorial-app

    # View the docker images available
        docker images

    # Run the docker image locally.
        docker run -d -p 8080:80 aci-tutorial-app
    # Output of running docker image a2e3e4435db58ab0c664ce521854c2e1a1bda88c9cf2fcff46aedf48df86cccf
    # test the locally running docker image at 8080 port, http://localhost:8080/

# 2. Create Registry for containers/images in Azure

    # Create Azure resoruce group
        az group create --name venkicontainerrg --location eastus
    
    # Create Azure container registry, to hold the images
        az acr create --resource-group venkicontainerrg --name venkiacr241 --sku Basic
    
    # Login to container registry
        az acr login --name venkiacr241

    # Tag container image
        # Get Auzre registry login server
            az acr show --name venkiacr241 --query loginServer --output table
        # registry login server venkiacr241.azurecr.io

        # Tag container image to registry login server
            docker tag aci-tutorial-app venkiacr241.azurecr.io/aci-tutorial-app:v1
        # push image to container registry
            docker push venkiacr241.azurecr.io/aci-tutorial-app:v1
        # list images in container registry 
            az acr repository list --name venkiacr241 --output table
        
        # view the tags for the container 
        az acr repository show-tags --name  --repository aci-tutorial-app --output table

# 3. Deploy Container
    # Get Registry login server 
        az acr show --name venkiacr241 --query loginServer
        # venkiacr241.azurecr.io
    # Createor use a service principle to pull container images.
        # ACR_NAME: The name of your Azure Container Registry, ACR_NAME=venkiacr241
        # SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant, SERVICE_PRINCIPAL_NAME=venkiacrserviceprinciple
        
        # Obtain the full registry ID for subsequent command args
            az acr show --name venkiacr241 --query id --output tsv
            ACR_REGISTRY_ID=/subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkicontainerrg/providers/Microsoft.ContainerRegistry/registries/venkiacr241

        # Create the service principal with rights scoped to the registry.
        # Default permissions are for docker pull access. Modify the '--role'
        # argument value as desired:
        # acrpull:     pull only
        # acrpush:     push and pull
        # owner:       push, pull, and assign roles
            az ad sp create-for-rbac --name http://venkiacrserviceprinciple --scopes /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkicontainerrg/providers/Microsoft.ContainerRegistry/registries/venkiacr241 --role acrpull --query password --output tsv
            az ad sp show --id http://venkiacrserviceprinciple --query appId --output tsv
        # SP_PASSWD=a-j2FF5K9YYwaNl-cE~C2YYx331Fx7O7xy
        # SP_APP_ID=03acaa55-0622-47b3-92ab-0a8d77b11c3f
    # For exising service principle use service principle id and container registry id, to provide permssion to pull image

        >az role assignment create --assignee 03acaa55-0622-47b3-92ab-0a8d77b11c3f --scope /subscriptions/679adac3-f665-4909-b5eb-3017e5fc5fb8/resourceGroups/venkicontainerrg/providers/Microsoft.ContainerRegistry/registries/venkiacr241 --role acrpull
    # Create container
        az container create --resource-group venkicontainerrg --name aci-tutorial-app --image venkiacr241.azurecr.io/aci-tutorial-app:v1 --cpu 1 --memory 1 --registry-login-server venkiacr241.azurecr.io --registry-username 03acaa55-0622-47b3-92ab-0a8d77b11c3f --registry-password a-j2FF5K9YYwaNl-cE~C2YYx331Fx7O7xy --dns-name-label venkidnslabel --ports 80

        az container create --resource-group venkicontainerrg --name aci-tutorial-app --image venkiacr241.azurecr.io/aci-tutorial-app:v1 --cpu 1 --memory 1 --registry-login-server venkiacr241.azurecr.io --registry-username <service-principal-ID> --registry-password <service-principal-password> --dns-name-label <aciDnsLabel> --ports 80

    # Show container status
        az container show --resource-group venkicontainerrg --name aci-tutorial-app --query instanceView.state
        az container show --resource-group venkicontainerrg --name aci-tutorial-app --query ipAddress.fqdn
    # View container logs
        az container logs --resource-group venkicontainerrg --name aci-tutorial-app

# 4. Delete Azure resource group
    az group delete --name venkicontainerrg


