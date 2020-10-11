# Create VM with Load balancer


# 1. Create Resource group
az group create --name venkirglb --location eastus

# 2. Create public ip for the load balancer
az network public-ip create --resource-group venkirglb --name venkilbip

# 3. Create loadbalancer and add public ip to it.
az network lb create --resource-group venkirglb --name venkilb --frontend-ip-name venkifrontendip ^
    --backend-pool-name venkibackendpool --public-ip-address venkilbip

# 4. Create a basic health probe for the load balancer, with this load balancer forwards request
# only to responsive VM connected to the load balancer.
az network lb probe create --resource-group venkirglb --lb-name venkilb --name venkihp --protocol tcp --port 80

# 5. Create a load balancer rule, specify the protocol the front end and back end port.
az network lb rule create --resource-group venkirglb --lb-name venkilb --name venkilbrule --protocol tcp ^
    --frontend-port 80 --backend-port 80 --frontend-ip-name venkifrontendip --backend-pool-name venkibackendpool ^
    --probe-name venkihp

# 6. Configure virtual network

# To deploy your VM and load balancer you need network resources(Virtual network, subnet, network interface card and nsg group) 
# Create a Virtual network with subnet
    az network vnet create --resource-group venkirglb --name myVnet --subnet-name mySubnet

# Create a network security group
    az network nsg create --resource-group venkirglb --name myNetworkSecurityGroup

# Add network security group rules
    az network nsg rule create --resource-group venkirglb --nsg-name myNetworkSecurityGroup --name myNetworkSecurityGroupRule ^
    --priority 1001 --protocol tcp --destination-port-range 80

# Create network interface card and add network security group. Each NIC card for a VM and one for load balancer.
    for %i in (1 2 3) do az network nic create --resource-group venkirglb --name myNic%i --vnet-name myVnet --subnet mySubnet ^
        --network-security-group myNetworkSecurityGroup ^
        --lb-name venkilb --lb-address-pools venkibackendpool ^
    

# 7. Create Virutal machines

# Create a availability set
    az vm availability-set create --resource-group venkirglb --name venkiavailset

# create vm within availabilit set
    for %i in (1 2 3) do az vm create --resource-group venkirglb --name myVM%i --availability-set venkiavailset --nics myNic%i --image UbuntuLTS --admin-username venkiuser --generate-ssh-keys --custom-data cloud-init.txt

        az vm create --resource-group venkirglb --name myVM3 --availability-set venkiavailset ^
        --nics myNic3 --image UbuntuLTS --admin-username venkiuser --generate-ssh-keys --custom-data cloud-init.txt


# 8. Test load balancer

az network public-ip show --resource-group venkirglb --name venkilbip --query [ipAddress] --output tsv

