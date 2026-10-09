---
slug: vserver-configuration
title: "Configuration of vServer: SSH, Nginx & Git"
authors: [karsten]
tags: [vserver, linux, nginx, ssh, git, docusaurus]
---

This blog post describes the procedure for configuring a fresh vServer, installing and configuring an Nginx web server, and setting up Git with GitHub integration.

<!-- truncate -->

## Overview

When setting up a new virtual server (vServer), security and foundational tooling are key. This guide covers the essential steps to secure your server via SSH keys, host websites using Nginx, and integrate Git for version control.

---

## 1. SSH Key Setup & Security

To enhance the security of the vServer, password-based authentication is disabled and replaced with passwordless login using secure SSH keys (`ed25519`).

### Step-by-Step Procedure:

1. **Initial Login:** Log in to your vServer using your standard password:
   ```bash
   ssh kasche@192.168.0.247
   ```

2. **Create Keypair on Local Machine:** If you don't already have an SSH key, generate a new pair on your local machine:
   ```bash
   ssh-keygen -t ed25519 -C 'karsten.asche@sdash.de'
   ```

3. **Transfer Public Key:** Copy your public key to the vServer:
   ```bash
   ssh-copy-id -i ~/.ssh/vserver_ed25519.pub kasche@192.168.0.247
   ```

4. **Modify SSH Configuration:** Open the SSH daemon configuration file on the server:
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
   Locate the `PasswordAuthentication` line, uncomment it, and set it to `no`:
   ```text
   PasswordAuthentication no
   ```

5. **Restart SSH Service:** Apply the changes by restarting the service:
   ```bash
   sudo systemctl restart ssh.service
   ```

6. **Verification:**
   * Logout from the server:
     ```bash
     logout
     ```
   * Try logging in without keys (should fail):
     ```bash
     ssh -o PubkeyAuthentication=no kasche@192.168.0.247
     ```
     *Expected Result:* `Permission denied (publickey)` (Successfully blocked).
   * Log in using your SSH key seamlessly:
     ```bash
     ssh -i /c/Users/karst/.ssh/vserver_ed25519 kasche@192.168.0.247
     ```

---

## 2. Nginx Web Server Installation & Configuration

Next, we install the Nginx web server and set up both the default welcome page and a custom alternative site configuration.

### Installation & Basic Test:

1. Update your system package list:
   ```bash
   sudo apt update
   ```

2. Install Nginx:
   ```bash
   sudo apt install nginx -y
   ```
   *Result:* The default Nginx welcome page can now be accessed via your browser.

### Alternative Configuration:

To host custom sites on a different port:

1. Create a directory for the alternative website files:
   ```bash
   sudo mkdir -p /var/www/alternatives
   ```

2. Create an alternative HTML file:
   ```bash
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

3. Create a new Nginx site configuration file:
   ```bash
   sudo nano /etc/nginx/sites-enabled/alternatives
   ```
   ```nginx
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

4. Restart Nginx to apply the new configuration:
   ```bash
   sudo service nginx restart
   ```
   *Result:* Accessing the alternative page via port `8081` in your browser works smoothly.

---

## 3. Git & GitHub Integration

Configuring Git on the server allows for smooth version control and repository management.

1. **Configure Git Identity:**
   Set your global name and email address on the server:
   ```bash
   git config --global user.name "Karsten Asche"
   git config --global user.email "karsten.asche@sdash.de"
   ```

2. **Generate SSH Key for GitHub:**
   Generate a separate SSH key directly on the vServer:
   ```bash
   ssh-keygen -t ed25519 -C "karsten.asche@sdash.de"
   ```
   *Note:* Add the resulting public key to your GitHub account settings under SSH and GPG keys.

3. **Test Integration:**
   Successfully clone an existing project (such as a Docusaurus project) from GitHub to your vServer via SSH:
   ```bash
   git clone git@github.com:KarstenAsche/Ashis-Blog-Post.git