# Hetzner Cloud VPN Server

A ready-to-deploy WireGuard VPN server setup for [Hetzner Cloud](https://hetzner.com) using Infrastructure as Code.

## Features

- **[WireGuard](https://wireguard.com) VPN** - Fast, modern, secure VPN with excellent performance
- **Infrastructure as Code** - Automated deployment using [Packer](https://packer.io) and [Terraform](https://terraform.io)/[OpenTofu](https://opentofu.org)
- **Security Hardened** - Automated updates, [nftables](https://wiki.nftables.org) firewall, and [Fail2ban](https://fail2ban.org)
- **Easy Management** - Simple peer and user administration through Terraform
- **Multi-Platform** - Supports both x86 and ARM architectures
- **[Coolify](https://coolify.io) Integration** - Self-hosted Heroku/Netlify alternative for application deployment

## Prerequisites

- [Packer](https://developer.hashicorp.com/packer/downloads) installed
- [Terraform](https://developer.hashicorp.com/terraform/downloads) or [OpenTofu](https://opentofu.org/docs/intro/install/) installed
- A [Hetzner Cloud](https://console.hetzner.cloud/) account
- Hetzner Cloud API token ([how to create](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/))

## Quick Start

### Option 1: Automated Setup

1. Run the initialization script:
   ```sh
   ./init.sh
   ```

2. Follow the prompts to configure your deployment

3. Complete the remaining variables in `terraform/terraform.tfvars`:
   - WireGuard keys
   - SSH keys
   - User configuration

4. Build and deploy:
   ```sh
   cd packer && packer init && packer build ./
   cd ../terraform && terraform init && terraform apply
   ```

### Option 2: Manual Setup

#### 1. Configure Packer Variables

   Navigate to the `packer` directory:
   ```sh
   cd ./packer/
   ```

   Create your variables file by copying the sample:
   ```sh
   cp packer.auto.pkrvars.hcl.sample packer.auto.pkrvars.hcl
   ```

   Edit `packer.auto.pkrvars.hcl` and set the following variables:
   ```hcl
    # These values will be needed in Terraform later
    hcloud_api_token = ""          # Your hetzner API Token
    server_type      = "cx42"      # Should match server_type in Terraform
    location         = "fsn1"      # Should match server_location in Terraform
    image            = "ubuntu-24.04"
    server_name      = "spiderman" # Will be used as image label in Terraform
   ```

   Note: The `server_name` will be used to create an image with label `service=spiderman`, which Terraform will use to find the image.

#### 2. Build the Server Image

   Initialize Packer:
   ```sh
   packer init ./
   ```

   Build the image:
   ```sh
   packer build ./
   ```

   The build process will create a custom server image in your Hetzner Cloud project with the label `service=spiderman`.

#### 3. Configure Terraform Variables

   Navigate to the `terraform` directory:
   ```sh
   cd ../terraform/
   ```

   Create your variables file:
   ```sh
   cp terraform.tfvars.sample terraform.tfvars
   ```

   Edit `terraform.tfvars` and configure:
   ```hcl
   # Required variables - Must match Packer configuration
   hcloud_api_token = ""           # Your hetzner API Token
   server_location = "fsn1"        # Should match location from Packer
   
   # Server configuration
   server_architecture   = "x86"    # "arm" for ARM-based servers
   server_image_selector = "service=spiderman"  # Matches label from Packer
   
   # Optional server name
   server_name = "my-vpn-server"
   
   # WireGuard configuration
   server_wg_privatekey = ""        # Your WireGuard private key
   server_wg_peers = [              # List of WireGuard peer configurations
     {
       publickey    = ""            # Peer's public key
       presharedkey = ""            # Peer's preshared key
     }
   ]

   # SSH Configuration
   ssh_publickey      = ""          # Your SSH public key
   ssh_publickey_name = ""          # Name for the SSH key in Hetzner

   # User configuration
   users = [
     {
       name                = "your-username"
       sudo                = true
       shell              = "/bin/bash"
       groups             = ["sudo"]
       ssh_authorized_keys = [
         "ssh-rsa YOUR_SSH_KEY"     # Your SSH public key
       ]
     }
   ]
   ```

   Important: Make sure these values match between Packer and Terraform:
   - `hcloud_api_token`: Use the same API token
   - `server_type`: Must match between Packer and Terraform to ensure compatibility
   - `location`/`server_location`: Must be in the same location as the image
   - The image selector in Terraform (`service=spiderman`) must match the label applied by Packer

#### 4. Deploy the Server

   Initialize Terraform:
   ```sh
   terraform init
   ```

   Review the deployment plan:
   ```sh
   terraform plan
   ```

   Apply the configuration:
   ```sh
   terraform apply
   ```

#### 5. Accessing Your VPN

   After deployment, you can get WireGuard peer configurations in two ways:

   ##### Option 1: Using Terraform Output (Recommended)

   1. Generate the peer configuration file:
      ```bash
      # For a specific peer (e.g., peer 0)
      ./scripts/get-peer-config.sh 0
      
      # The configuration will be saved to terraform/wg-peer-0.conf
      ```

   2. Import the configuration:
      - For mobile: Use your WireGuard app to import the .conf file
      - For desktop: Copy the .conf file to your WireGuard configuration directory

   ##### Option 2: Manual Generation on Server
 n
   1. SSH into your server:
      ```bash
      ssh your-username@server-ip
      ```

   2. Generate peer configuration:
      ```bash
      sudo wg-create-peer \
        --interface wg0 \
        --peer-number N \
        --peer-public-key "PEER_PUBLIC_KEY" \
        --peer-preshared-key "PEER_PRESHARED_KEY"
      ```

#### 6. Managing WireGuard Peers

   To add or remove peers:
   1. Update the `server_wg_peers` list in `terraform.tfvars`
   2. Run `terraform apply` to apply the changes
   3. Generate new peer configurations using either method above

7. Managing Users

   To add, remove, or modify users:
   - Update the `users` list in `terraform.tfvars`
   - Run `terraform apply` to apply the changes

8. Cleanup

   To destroy the infrastructure:
   ```sh
   cd ./terraform/
   terraform destroy
   ```

9. Security Considerations

   - Keep your `terraform.tfvars` and `packer.auto.pkrvars.hcl` files secure as they contain sensitive information
   - Regularly update the server for security patches
   - Use strong WireGuard keys for peers
   - Consider enabling additional firewall rules as needed

10. Troubleshooting

    - If Packer build fails, check your Hetzner API token and network connectivity
    - For Terraform errors, ensure the server image was created successfully by Packer
    - Verify WireGuard peer configurations if connection issues occur
    - Check Hetzner Cloud console for server status and logs

11. Contributing

    Contributions are welcome! Please feel free to submit a Pull Request.

12. License

    This project is open source and available under the [MIT License](LICENSE).

## Useful Commands

### Packer Commands

```bash
# Initialize Packer working directory
packer init ./

# Format Packer configuration files
packer fmt ./

# Validate Packer configuration
packer validate ./

# Build image with debug output
PACKER_LOG=1 packer build ./

# List available Hetzner images (using hcloud CLI)
hcloud image list --selector service=spiderman

# Delete custom image (using hcloud CLI)
hcloud image delete <image-id>
```

### Terraform Commands

```bash
# Initialize Terraform working directory
terraform init

# Format Terraform configuration files
terraform fmt

# Validate Terraform configuration
terraform validate

# Show planned changes
terraform plan

# Apply changes
terraform apply

# Apply changes without confirmation prompt
terraform apply -auto-approve

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list

# Remove specific resource from state
terraform state rm <resource_name>

# Import existing resource into state
terraform import <resource_type>.<resource_name> <resource_id>

# Refresh state without making changes
terraform refresh

# Clean up state and downloaded modules
rm -rf .terraform/ .terraform.lock.hcl terraform.tfstate*
```

### Backup and State Management

```bash
# Create state backup
cp terraform.tfstate terraform.tfstate.backup

# Restore from backup
cp terraform.tfstate.backup terraform.tfstate

# Save state to a different file
terraform plan -out=tfplan
terraform apply tfplan

# Work with remote state
terraform state pull > terraform.tfstate.backup    # Download remote state
terraform state push terraform.tfstate.backup      # Upload state to remote

# Force unlock state if locked
terraform force-unlock <lock-id>
```

### Troubleshooting

```bash
# Enable debug output for Terraform
export TF_LOG=DEBUG
terraform apply

# Enable debug output for Packer
export PACKER_LOG=1
packer build ./

# Verify Hetzner connectivity (using hcloud CLI)
hcloud server list
hcloud image list

# Check Terraform workspace
terraform workspace show
terraform workspace list

# Clean slate (warning: removes all local state!)
rm -rf .terraform/ .terraform.lock.hcl terraform.tfstate*
terraform init
```

## Optional Components

### Coolify Installation

[Coolify](https://coolify.io) is a self-hosted Vercel/Netlify alternative that can be installed on your VPN server. It provides:

To install Coolify:

1. Navigate to the ansible directory:
   ```sh
   cd ./ansible
   ```

2. Run the Coolify installation playbook:
   ```sh
   ansible-playbook -i inventory/inventory.yml playbooks/pb_coolify.yml
   ```

3. Access Coolify:
   - Open your browser and navigate to `http://your-server-ip:3000`
   - Complete the initial setup process
   - For security, configure SSL and change the default credentials

Note: Ensure your firewall allows access to port 3000 for Coolify's web interface.