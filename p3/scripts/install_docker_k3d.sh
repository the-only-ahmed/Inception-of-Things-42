#!/bin/bash

# Update and upgrade the system
echo "###### Updating and upgrading the system... ######"
sudo apt update && sudo apt upgrade -y

# Install prerequisites
echo "###### Installing prerequisites... ######"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# Add Docker's official GPG key
echo "###### Adding Docker's official GPG key... ######"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's official APT repository
echo "###### Adding Docker's official APT repository... ######"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with Docker packages from the newly added repo
echo "###### Updating the package database with Docker packages... ######"
sudo apt update

# Install Docker
echo "###### Installing Docker... ######"
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
echo "###### Starting and enabling Docker service... ######"
sudo systemctl start docker
sudo systemctl enable docker

# Add the current user to the Docker group
echo "###### Adding the current user to the Docker group... ######"
sudo usermod -aG docker $USER
ls -l /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock


# Install curl if not already installed
echo "###### Installing curl... ######"
sudo apt install -y curl

# Download the latest release of kubectl
echo "###### Downloading kubectl... ######"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Install k3d
echo "###### Installing k3d... ######"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Print installation summary
echo "###### Docker and K3d installation completed successfully. ######"

# Inform the user to log out and back in to apply Docker group membership
echo "###### Please log out and log back in to apply Docker group membership. ######"