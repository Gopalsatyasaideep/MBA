# Deployment Guide: MBA Maker's Studio on AWS EC2

This guide will help you deploy your videography portfolio to an AWS EC2 instance running Ubuntu.

## Prerequisites
- An AWS Account
- Basic familiarity with terminal/command line

## Step 1: Launch an EC2 Instance
1.  Log in to your **AWS Console** and go to **EC2**.
2.  Click **Launch Instance**.
3.  **Name:** `MBA-Portfolio-Server`
4.  **OS Image:** Select **Ubuntu** (Ubuntu Server 24.04 LTS or 22.04 LTS).
5.  **Instance Type:** `t2.micro` (Free tier eligible) or `t3.micro`.
6.  **Key Pair:**
    - Click "Create new key pair".
    - Name: `mba-key`.
    - Type: `RSA`.
    - Format: `.pem` (for OpenSSH/Mac/Linux/Windows 10+).
    - **Download the key file** and save it safely (e.g., in your `Downloads` folder).
7.  **Network Settings:**
    - Ensure **"Allow HTTP traffic from the internet"** is CHECKED.
    - Ensure **"Allow HTTPS traffic from the internet"** is CHECKED.
    - Ensure **"Allow SSH traffic from"** is set to "My IP" (for security) or "Anywhere".
8.  Click **Launch Instance**.

## Step 2: Prepare Your Local Files
1.  Open your project folder in File Explorer or VS Code.
2.  Ensure you have the `nginx_setup.sh` file I just created for you.

## Step 3: Upload Files to Server
You will use PowerShell (Windows) to upload files.
Replace `path\to\mba-key.pem` with the actual path to your downloaded key.
Replace `YOUR_SERVER_IP` with the **Public IPv4 address** of your EC2 instance (found in AWS Console).

Open PowerShell and run the following commands:

```powershell
# 1. Upload the setup script
scp -i "C:\Path\To\mba-key.pem" nginx_setup.sh ubuntu@YOUR_SERVER_IP:~

# 2. Upload your website files (index.html, css, js, assets)
# Note: This copies the current folder contents to a 'temp' folder on the server
scp -i "C:\Path\To\mba-key.pem" -r . ubuntu@YOUR_SERVER_IP:~/site-files
```

*Note: If you get a "Permission denied (publickey)" error, ensure your key path is correct.*

## Step 4: Configure the Server
Now, SSH into your server to finish the setup.

```powershell
ssh -i "C:\Path\To\mba-key.pem" ubuntu@YOUR_SERVER_IP
```

Once you are logged in (you will see a prompt like `ubuntu@ip-172-31...`), run these commands:

```bash
# 1. Make the setup script executable
chmod +x nginx_setup.sh

# 2. Run the setup script (installs Nginx and configures it)
./nginx_setup.sh

# 3. Move your site files to the correct web folder
sudo cp -r ~/site-files/* /var/www/mba-studio/

# 4. Fix permissions one last time
sudo chown -R www-data:www-data /var/www/mba-studio
sudo chmod -R 755 /var/www/mba-studio
```

## Step 5: Verify
Open your browser and enter your **EC2 Public IP Address**:
`http://YOUR_SERVER_IP`

You should see your live website!

---

## Troubleshooting
- **Site not loading?**
  - Check AWS Security Groups: Ensure "Inbound Rules" allow **HTTP (Port 80)** from "Anywhere (0.0.0.0/0)".
- **Permission Error?**
  - Run `sudo chmod 400 mba-key.pem` on your local machine (Mac/Linux) or check file properties on Windows to ensure the key is read-only.
