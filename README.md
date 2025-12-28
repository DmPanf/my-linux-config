## 🐧 Linux Server Telegram Assistant & Admin Toolkit (v2.1)

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Raspberry%20Pi-FCC624?style=flat-square&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

A lightweight, professional, and universal collection of bash scripts to monitor your **Raspberry Pi (3/4/5)** or **Ubuntu/Debian VPS**. 

This toolkit provides Telegram notifications for boot status, SSH logins, and scheduled reboots, plus a beautiful ASCII MOTD (Message of the Day) upon login. **Fully automated installation included.**

---

### ✨ Key Features

* **🚀 Smart Boot Notification:** Sends system status (CPU, RAM, Disk, Temperature, IP) to Telegram when the server starts.
* **🛡️ SSH Login Alerts:** Instantly notifies you when someone logs in via SSH (filters out local noise).
* **🔄 Safe Reboot Manager:** A custom command to notify via Telegram before rebooting.
* **🎨 Beautiful MOTD:** Dynamic ASCII art logo and colorful system stats when you log in to the terminal.
* **🔌 Infrastructure as Code:** One-click `install.sh` script to deploy configuration, permissions, and cron jobs automatically.
* **🐳 Docker Aware:** Smartly filters out Docker and Localhost IP addresses to show only real LAN/WAN IPs.

---

### 📂 Project Structure

The project follows the **Linux FHS (Filesystem Hierarchy Standard)**.

```text
my-linux-config/
├── bin/
│   ├── tg-wake          # System status reporter (Main bot)
│   ├── tg-alert         # SSH login notification hook
│   └── tg-reboot        # Wrapper for graceful reboot with notification
├── config/
│   ├── root_crontab     # Optimized crontab file
│   └── 10-custom-login  # Dynamic MOTD script
├── systemd/
│   └── wake_bot.service # Systemd unit for boot notification
├── install.sh           # ⚡ Master Installer
└── README.md            # Documentation

```

---

### ⚙️ Prerequisites

1. **OS:** Ubuntu, Debian, or Raspbian.
2. **Access:** Root privileges (`sudo`).
3. **Telegram Bot:** You need a `BOT_TOKEN` and your `CHAT_ID`.

---

### 🚀 Installation (3 Steps)

#### Step 1: Create the Secret Configuration

For security reasons, your API keys are not stored in the repository. Create the environment file manually on your server:

```bash
sudo nano /etc/default/tg_bot.env

```

**Paste the following content (edit with your details):**

```bash
host="⚛️ VPS [AI-Mate]"  # Name of your server
Place="🔎 London"         # Physical location or Data Center
Port=""                   # Optional port info
TOKEN="123456789:AAH..."  # Your Telegram Bot Token
CHAT_ID1="987654321"      # Your Chat ID

```

*(Save with `Ctrl+O`, Enter, `Ctrl+X`)*

#### Step 2: Clone the Repository

Download this toolkit to your local folder (e.g., `~/scr`).

```bash
mkdir -p ~/scr
cd ~/scr
git clone https://github.com/DmPanf/my-linux-config.git
cd my-linux-config

```

#### Step 3: Run the Auto-Installer

The script will install dependencies (`figlet`, `curl`), set permissions, configure Cron/Systemd, and deploy scripts to `/usr/local/bin`.

```bash
chmod +x install.sh
sudo ./install.sh

```

---

### 🛠️ Usage & Commands

Once installed, the tools are available system-wide.

#### 1. Manual Status Check

Get current system stats sent to your Telegram immediately.

```bash
tg-wake

```

#### 2. Scheduled Reboot

To reboot the server with a warning notification sent to Telegram:

```bash
# Usage: tg-reboot "Time/Reason"
tg-reboot "Manual Maintenance"

```

*Note: This command initiates a shutdown with a 3-minute delay.*

#### 3. SSH Alerts

Automatic. You don't need to run anything. Any SSH connection will trigger a notification:

> 🔐 **SSH:** root ➡️ **VPS** [192.168.1.150]

---

### 📸 Preview

#### Telegram Notification (`tg-wake`)

```text
⚛️ VPS [AI-Mate] 🌡N/A ▫️ 🔎 London
├─ IP: [192.192.19.123 / 67.34.2.43]
├─ OS: Ubuntu 24.04.3 ▫️ 2x Xeon E5-2630
├─ RAM: 473Mi/7.8Gi
└─ 📀 Total: 119G | Used: 6% | Free: 110G

```

#### Terminal Login (MOTD)

```text
   __  __
   \ \/ /_  __
    \  / / / /
    / / /_/ /
   /_/\__,_/

===================================================================
 👋 Welcome to ⚛️ VPS [AI-Mate]
 🌍 Server IP: 192.192.19.123
 ⏱  Uptime:    2 days, 4 hours
 🧠 Load:      0.15 0.20 0.18
 👥 Users:     1
 💾 Disk /:    6% / 119G
 🧮 Memory:    473Mi / 7.8Gi
 📅 Date:      26 Dec 2025 12:00:00
===================================================================
🔔 INFO! Planned maintenance reboot: Monday/Thursday at 04:07am MSK.

```

---

### 🔄 Uninstallation

- To check:
  
```bash
sudo systemctl restart wake_bot.service

```

- If you want to remove the toolkit:

```bash
sudo rm /usr/local/bin/tg-*
sudo rm /etc/profile.d/tg-alert.sh
sudo rm /etc/update-motd.d/10-custom-login
sudo systemctl disable wake_bot.service
sudo rm /etc/systemd/system/wake_bot.service

```

---

### 📝 License

This project is open-source. Feel free to modify and adapt it to your needs.

---


