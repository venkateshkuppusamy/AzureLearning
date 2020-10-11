# create resource group
az group create --name venkirg123 --location eastus

# create VM scale set with 2 instances
az vmss create ^
  --resource-group venkirg123 ^
  --name venkiscaleset ^
  --image UbuntuLTS ^
  --upgrade-policy-mode automatic ^
  --instance-count 2 ^
  --admin-username venkiuser ^
  --generate-ssh-keys

# Create auto scale profile for your scaleset
  az monitor autoscale create ^
  --resource-group venkirg123 ^
  --resource venkiscaleset ^
  --resource-type Microsoft.Compute/virtualMachineScaleSets ^
  --name venkiautoscale ^
  --min-count 2 ^
  --max-count 10 ^
  --count 2

# Create auto scale out rule - Percentage of Avg CPU > 70 % for 5 minutes
  az monitor autoscale rule create ^
  --resource-group venkirg123 ^
  --autoscale-name venkiautoscale ^
  --condition "Percentage CPU > 70 avg 5m" ^
  --scale out 3

# Create auto scale in rule - Percentage or avg cpu < 30 % for 5 minutes
  az monitor autoscale rule create ^
  --resource-group venkirg123 ^
  --autoscale-name venkiautoscale ^
  --condition "Percentage CPU < 30 avg 5m" ^
  --scale in 1

# Check the no of instances, it should be 2 the default no of instances
  az vmss list-instance-connection-info ^
  --resource-group venkirg123 ^
  --name venkiscaleset

# connect to the linux machine using the public IP and port
ssh venkiuser@40.87.102.55 -p 50003
ssh venkiuser@40.87.102.55 -p 50001

# Perform the below steps in for each VM instance
sudo apt-get update
# Install stress
sudo apt-get -y install stress
# Add stress
sudo stress --cpu 10 --timeout 420 &
top
ctrl+c
exit

# check the no of instances
az vmss list-instances --resource-group venkirg123 --name venkiscaleset --output table

# delete the resource group after user
az group delete --name venkirg123 --yes --no-wait