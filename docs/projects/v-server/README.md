# Configuration of vServer

This README describes the procedure for configuring the vServer, installing a web server (nginx), and setting up Git on this vServer. 

## Repository Description

This repository is intended solely to provide information about setting up my vServer.

## Table of Contents

- [Configuration of vServer](#configuration-of-vserver)
    - [SSH Key Setup & Security](#ssh-key-setup--security)
    - [Nginx Web Server Installation & Configuration](#nginx-web-server-installation)
    - [Git & GitHub Integration](#git--github-integration)

## SSH Key Setup & Security

To enhance the security of the vServer, password-based authentication is disabled and replaced with passwordless login via SSH keys.

1. **Initial Login:** Log in to the vServer using your password:
   ```bash
   ssh <username>@<your_ip>
   ```

2. **Create Keypair on Local Machine:**
   If you don't already have an SSH key, generate a new pair on your *local* machine:
   ```bash
   ssh-keygen -t ed25519 -C '<your-email>'
   ```

3. **Transfer Public Key:**
   Copy the public key to the vServer:
   ```bash
   ssh-copy-id -i ~/.ssh/vserver_ed25519.pub <username>@<your_ip>
   ```

4. **Test Login via Public Key:**
   Verify that login works without a password:
   ```bash
   ssh -i /c/Users/karst/.ssh/vserver_ed25519 <username>@<your_ip>
   ```

5. **Modify SSH Configuration (`/etc/ssh/sshd_config`):**
   * Locate the `PasswordAuthentication` line, uncomment it, and set it to `no`:
     ```text
     PasswordAuthentication no
     ```
   * Restart the SSH service to apply the changes:
     ```bash
     sudo systemctl restart ssh.service
     ```

6. **Verification:**
   * **Logout** from the server
    ```bash
    logout
    ```
    and try logging in again with your password:
    ```bash
    ssh -o PubkeyAuthentication=no <username>@<your_ip>
    ```
     * **Result:** `Permission denied (publickey)` (Successfully blocked).
   * **Login via SSH with key:** Works seamlessly.
   ```bash
   ssh -i /c/Users/karst/.ssh/vserver_ed25519 <username>@<your_ip>
   ```

## Nginx Web Server Installation

Installation and configuration of the Nginx web server on the vServer.

1. **Installation & Test:**
   * Update System
   ```bash
   sudo apt update
   ```
   * Installed Nginx and accessed the default page in the browser.
   ```bash
   sudo apt install nginx -y
   ```
   * **Result:** The Nginx welcome page was successfully displayed in the browser.

2. **Alternative Configuration:**
   * Set up an alternative website configuration.
    ```bash
    sudo mkdir -p /var/www/alternatives
    sudo nano /var/www/alternatives/alternate-index.html
    ```
    ```html
        <!DOCTYPE html>
            <html lang="de">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>ashis lokaler vserver</title>
            </head>
            <body>
                <h1>Willkommen bei Ashi</h1>
                <p>Schön das du auf meinen Server gefunden hast du kleiner Schelm</p>
            </body>
            </html>
    ```

    creating an alternative nginx config
    ```bash
    sudo nano /etc/nginx/sites-enabled/alternatives
    ```

    ```text
        server {
            listen 8081;
            listen [::]:8081;

            root /var/www/alternatives;
            index alternate-index.html;

            location / {
                    try_files $uri $uri/ =404;
            }
        }
    ```
    and restart nginx after saving new config

    ```bash
    sudo service nginx restart
    ```
   * **Result:** Accessing the alternative page via the browser also worked smoothly.

## Git & GitHub Integration

Configuring Git on the server for version control and connecting it to GitHub.

1. **Configure Git:**
   * Set global name and email address on the server:
     ```bash
     git config --global user.name "Your Name"
     git config --global user.email "your@email.com"
     ```

2. **Generate SSH Key for GitHub on the Server:**
   * Generated a separate SSH key 
   ```bash
   ssh-keygen -t ed25519 -C "<your-email>"
   ```
   on the vServer and added the public key to your GitHub account settings.

3. **Test:**
   To test Git, I started another SSH agent, which then used my unnamed key to access the repository.
   ```bash
   eval "$(ssh-agent -s)"       # Starts the background SSH authentication agent.
   ssh-add ~/.ssh/github_25519  # Adds your private SSH key to the agent.
   ssh -T git@github.com        # Tests the authenticated connection to GitHub.
   ```
   * Successfully cloned an existing Docusaurus project from GitHub to the vServer via SSH
   ```bash
   git clone git@github.com:KarstenAsche/Ashis-Blog-Post.git
   ```