
# Create an Azure container registry
# Clone application source code from GitHub
# Use Docker Compose to build an image and run a multi-container application locally
# Push the application image to your container registry
# Create an Azure context for Docker
# Bring up the application in Azure Container Instances 

# Create a resource group
    az group create --name venkimultcontainerrg --location eastus

# Create container registry
    az acr create --name venkimulticontaineracr --resource-group venkimultcontainerrg --sku Basic

# Login to container registry
    az acr login --name venkimulticontaineracr

# Get application code for multi contatiner deployment
    git clone https://github.com/Azure-Samples/azure-voting-app-redis.git
    cd azure-voting-app-redis

# Modify Docker file 
    # Make changes to docker file for build
    # Build the docker file and start the app
        docker-compose up --build -d

    # to see local images
        docker images

    # To see the running containers
        docker ps

    # To stop the rurnning containers
        docker-compose down

    # push the container to local repository.
        docker-compose push

    # Check repository after docker push
        az acr repository show --name venkimulticontaineracr --repository azure-vote-front

    # To Use Docker command in Azure container platform

        # Login to Azure
            docker login azure
        
        # Create a context
            docker context create aci myacicontext
        
        # Verify the created context
            docker context ls
        
    # Deploy application to Azure Container instances

        docker context use myacicontext

        docker compose up

    # Delete resourece group
        
