#!/bin/bash

set -e  # Exit on error

# Helper functions
print_info() { echo -e "\e[34m[INFO] $1\e[0m"; }
print_success() { echo -e "\e[32m[SUCCESS] $1\e[0m"; }
print_error() { echo -e "\e[31m[ERROR] $1\e[0m"; exit 1; }

# Variables
DEB_DIR="../resources/debs/"
DOCKER_VERSION="26.0.0"
HELM_VERSION="v3.13.0"
SSH_KEY_PATH="./keyssh"  
node_01_ip="10.10.1.252"
node_02_ip="10.10.1.115"
node_03_ip="10.10.1.213"
node_01_user="root"
node_02_user="root"
node_03_user="root"

ANSIBLE_CORE_DEB="${DEB_DIR}ansible-core_2.16.8-1ppa~mantic_all.deb"
ANSIBLE_DEB="${DEB_DIR}ansible_5.10.0.deb"


# Install necessary packages
install_packages() {
    print_info "Installing required packages: tree, zip, ansible, sshpass, docker, docker-compose, helm..."
    apt update -y && apt upgrade -y
    apt install -yq tree zip sshpass curl apt-transport-https gnupg lsb-release
    
    #install ansible >= 2.15.5	
    if [[ ! -f "$ANSIBLE_CORE_DEB" || ! -f "$ANSIBLE_DEB" ]]; then
    echo "Error: One or more required .deb files are missing in $DEB_DIR"
    exit 1
    fi

    echo "Installing ansible-core..."
    sudo dpkg -i "$ANSIBLE_CORE_DEB"

    echo "Installing ansible..."
    sudo dpkg -i "$ANSIBLE_DEB"


    # Install Helm
    if ! command -v helm &>/dev/null; then
        curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s -- --version "$HELM_VERSION" || print_error "Failed to install Helm"
    fi

    print_success "Packages installed successfully!"
}

# Validate SSH using key.pem
validate_ssh() {
    print_info "Validating SSH access for HA nodes using key.pem..."

    mkdir -p ~/.ssh
    {
        ssh-keyscan -H "$node_01_ip"
        ssh-keyscan -H "$node_02_ip"
        ssh-keyscan -H "$node_03_ip"
    } >>~/.ssh/known_hosts || print_error "Failed to run ssh-keyscan on HA nodes"

    # Validate node 01
    if ! ssh -i "$SSH_KEY_PATH" -o BatchMode=yes -o StrictHostKeyChecking=no "$node_01_user@$node_01_ip" "echo SSH Connection Successful" &>/dev/null; then
        print_error "First server SSH connection failed! Check key.pem or server configuration."
    fi

    # Validate node 02
    if ! ssh -i "$SSH_KEY_PATH" -o BatchMode=yes -o StrictHostKeyChecking=no "$node_02_user@$node_02_ip" "echo SSH Connection Successful" &>/dev/null; then
        print_error "Second server SSH connection failed! Check key.pem or server configuration."
    fi

    # Validate node 03
    if ! ssh -i "$SSH_KEY_PATH" -o BatchMode=yes -o StrictHostKeyChecking=no "$node_03_user@$node_03_ip" "echo SSH Connection Successful" &>/dev/null; then
        print_error "Third server SSH connection failed! Check key.pem or server configuration."
    fi

    print_success "SSH keys validated successfully for all nodes!"
}

# Main script
main() {
    print_info "Starting setup process..."

    # Install packages
    install_packages

    # Validate SSH information
    validate_ssh

    print_success "Setup process completed successfully!"
}

# Run the main script
main
