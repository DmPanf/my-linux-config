#!/bin/bash

# Цвета для красоты
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting Server Configuration Setup ===${NC}"

# 0. Проверка прав root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo ./install.sh)${NC}"
  exit 1
fi

# 1. Проверка наличия .env (Ручной шаг)
CONFIG_FILE="/etc/default/tg_bot.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}ERROR: Config file $CONFIG_FILE not found!${NC}"
    echo -e "${YELLOW}Step 1: Create this file manually with your tokens before running installer.${NC}"
    exit 1
else
    echo -e "${GREEN}[OK]${NC} Config file found."
    chmod 444 "$CONFIG_FILE"
fi

# Определяем папку, где лежит скрипт (чтобы копировать относительно неё)
REPO_DIR=$(dirname "$(readlink -f "$0")")

# 2. Установка зависимостей
echo -e "${YELLOW}Installing dependencies (figlet, curl)...${NC}"
apt-get update -qq
apt-get install -y figlet curl ncal neofetch mc cron > /dev/null
echo -e "${GREEN}[OK]${NC} Dependencies installed."

# 3. Установка скриптов в /usr/local/bin
echo -e "${YELLOW}Installing binaries to /usr/local/bin...${NC}"
cp "$REPO_DIR/bin/tg-wake" /usr/local/bin/
cp "$REPO_DIR/bin/tg-alert" /usr/local/bin/
cp "$REPO_DIR/bin/tg-reboot" /usr/local/bin/

# Права 755 (rwxr-xr-x)
chmod 755 /usr/local/bin/tg-wake
chmod 755 /usr/local/bin/tg-alert
chmod 755 /usr/local/bin/tg-reboot
chown root:root /usr/local/bin/tg-*
echo -e "${GREEN}[OK]${NC} Binaries installed."

# 4. Настройка SSH Alert (Symlink)
echo -e "${YELLOW}Setting up SSH Alert hook...${NC}"
# Удаляем старую ссылку если была
rm -f /etc/profile.d/tg-alert.sh
# Создаем новую
ln -s /usr/local/bin/tg-alert /etc/profile.d/tg-alert.sh
echo -e "${GREEN}[OK]${NC} SSH Alert linked."

# 5. Настройка MOTD (Custom Login)
echo -e "${YELLOW}Setting up Custom Login (MOTD)...${NC}"
cp "$REPO_DIR/config/10-custom-login" /etc/update-motd.d/
chmod +x /etc/update-motd.d/10-custom-login
# Для Ubuntu иногда нужно форсировать обновление
if command -v update-motd > /dev/null; then
    update-motd > /dev/null 2>&1
fi
echo -e "${GREEN}[OK]${NC} MOTD installed."

# 6. Настройка Systemd Service
echo -e "${YELLOW}Configuring Systemd Service...${NC}"
cp "$REPO_DIR/systemd/wake_bot.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable wake_bot.service
echo -e "${GREEN}[OK]${NC} Service enabled."

# 7. Настройка Crontab (Root)
echo -e "${YELLOW}Applying Root Crontab...${NC}"
# Бэкап текущего крона на всякий случай
crontab -l > /root/crontab.bak 2>/dev/null
echo "Backup of old crontab saved to /root/crontab.bak"
# Установка нового
crontab "$REPO_DIR/config/root_crontab"
echo -e "${GREEN}[OK]${NC} Crontab updated."

# 8. Финал
echo -e "${YELLOW}Restarting Wake Bot Service for test...${NC}"
systemctl restart wake_bot.service

echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}   ✅ INSTALLATION COMPLETE!              ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo "Check your Telegram for the wake-up message."
