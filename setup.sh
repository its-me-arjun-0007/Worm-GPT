#!/bin/bash

# setup.sh - Universal Installer & Launcher for WormGPT
# Compatible with Kali Linux, Ubuntu, and Termux

# --- COLORS ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${RED}"
echo "██     ██  ██████  ██████  ███    ███      ██████  ██████  ████████ "
echo "██     ██ ██    ██ ██   ██ ████  ████     ██       ██   ██    ██    "
echo "██  █  ██ ██    ██ ██████  ██ ████ ██     ██   ███ ██████     ██    "
echo "██ ███ ██ ██    ██ ██   ██ ██  ██  ██     ██    ██ ██         ██    "
echo " ███ ███   ██████  ██   ██ ██      ██      ██████  ██         ██    "
echo -e "${NC}"
echo -e "${CYAN}::: SYSTEM INSTALLER & LAUNCHER :::::::::::::::::::::::::::::::::::${NC}"
echo ""

# 1. Detect Environment & System Deps
echo -e "${YELLOW}[*] Scanning Environment...${NC}"

if [ -d "$PREFIX/bin" ] && [ -x "$PREFIX/bin/pkg" ]; then
    echo -e "${GREEN}[+] Termux detected.${NC}"
    echo -e "${CYAN}[*] Installing System Packages (Python, Git, Build Tools)...${NC}"
    pkg update -y
    pkg install python git rust binutils -y 
else
    echo -e "${GREEN}[+] Linux (Kali/Debian) detected.${NC}"
    echo -e "${CYAN}[*] Installing System Packages...${NC}"
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Note: Run as root (sudo) if system packages fail to install.${NC}"
    else
        apt-get update
        apt-get install python3 python3-venv python3-pip git -y
    fi
fi

# 2. Virtual Environment Setup
echo -e "\n${YELLOW}[*] Configuring Neural Network (VENV)...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}[+] Virtual Environment Created.${NC}"
else
    echo -e "${GREEN}[+] Virtual Environment Detected.${NC}"
fi

# 3. Install Python Dependencies (CLI + GUI)
echo -e "\n${YELLOW}[*] Installing Python Modules...${NC}"
source venv/bin/activate

# UPGRADED: Includes 'streamlit' for the GUI and 'watchdog' for file monitoring
pip install --upgrade pip
pip install requests rich pyfiglet langdetect streamlit watchdog

# 4. Permissions
chmod +x worm-gpt.py
chmod +x worm-gpt-web.py 2>/dev/null

echo -e "\n${GREEN}[✔] SYSTEM READY. DEPENDENCIES INSTALLED.${NC}"
echo -e "------------------------------------------------"

# 5. Launch Menu
echo -e "${CYAN}SELECT OPERATION MODE:${NC}"
echo -e "${GREEN}[1]${NC} CLI Mode (Terminal Attack)"
echo -e "${GREEN}[2]${NC} GUI Mode (Visual Interface)"
echo -e "${GREEN}[3]${NC} Exit Setup"
echo ""
read -p "root@wormgpt:~# " choice

case $choice in
    1)
        echo -e "\n${RED}>> Initializing CLI...${NC}"
        python3 ai.py
        ;;
    2)
        echo -e "\n${RED}>> Initializing GUI Protocol...${NC}"
        # Termux specific flag to run headless if needed, but standard run works for localhost
        streamlit run gui.py
        ;;
    *)
        echo -e "\n${CYAN}Setup Complete. To run manually:${NC}"
        echo -e "CLI: ${YELLOW}source venv/bin/activate && python3 worm-gpt.py${NC}"
        echo -e "GUI: ${YELLOW}source venv/bin/activate && streamlit run worm-gpt-web.py${NC}"
        exit 0
        ;;
esac
