# Create a basic VM scale set

#login to Azure
az login

# Create a resource group, specifiy name and location
az group create --name venkirg123 --location eastus

# Create a VM scale set, specify resource group, scaleset name, image, upgrade policy for the image
az vmss create --resource-group venkirg123 --name venkiscaleset --image UbuntuLTS --upgrade-policy-mode automatic ^
--admin-username venkiuser --generate-ssh-keys

# Add extension to the VM scale set,to run custom scripts, Here install nginx using bash script
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name customScript --resource-group venkirg123 ^
--vmss-name venkiscaleset ^
--settings "{\"fileUris\":[\"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh\"],\"commandToExecute\":\"./automate_nginx.sh\"}"

#create network rule for load balancer
az network lb rule create ^
  --resource-group venkirg123 ^
  --name myLoadBalancerRuleWeb ^
  --lb-name venkiscalesetLB ^
  --backend-pool-name venkiscalesetLBBEPool ^
  --backend-port 80 ^
  --frontend-ip-name loadBalancerFrontEnd ^
  --frontend-port 80 ^
  --protocol tcp

# Get the public ip for the load balancer of VM scale set
az network public-ip show --resource-group venkirg123 ^
--name venkiscalesetLBpublicIP --query ipAddress


# Delete entire resource group
az group delete --name venkirg123 --yes --no-wait
