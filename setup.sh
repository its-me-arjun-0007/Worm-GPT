#!/bin/bash

# setup.sh - Automated installer for WormGPT CLI
# Compatible with Kali Linux and Termux

# Define colors for output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}[*] Initializing WormGPT Setup Protocol...${NC}"

# 1. Detect Environment and Install System Dependencies
if [ -d "$PREFIX/bin" ] && [ -x "$PREFIX/bin/pkg" ]; then
    echo -e "${GREEN}[+] Termux environment detected.${NC}"
    echo -e "${CYAN}[*] Updating packages and installing Python/Git...${NC}"
    pkg update -y && pkg upgrade -y
    pkg install python git -y
else
    echo -e "${GREEN}[+] Linux environment detected (Kali/Ubuntu).${NC}"
    echo -e "${CYAN}[*] Ensuring Python3 and venv are installed...${NC}"
    # Check if we have sudo privileges
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Please run as root (sudo ./setup.sh) to install system packages.${NC}"
        # We try to continue anyway in case they are already installed
    else
        apt-get update
        apt-get install python3 python3-venv python3-pip git -y
    fi
fi

# 2. Setup Virtual Environment (Best Practice)
echo -e "${CYAN}[*] Setting up Python Virtual Environment...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}[+] Virtual environment 'venv' created.${NC}"
else
    echo -e "${GREEN}[+] Virtual environment already exists.${NC}"
fi

# 3. Activate Venv and Install Python Libraries
echo -e "${CYAN}[*] Installing Python dependencies...${NC}"
source venv/bin/activate

# Install required libraries explicitly based on README/Imports
pip install requests rich pyfiglet langdetect

# 4. Permissions check
chmod +x ai.py

echo -e "${GREEN}[+] Setup Complete.${NC}"
echo -e "${CYAN}[*] Launching System...${NC}"
echo -e "------------------------------------------------"

# 5. Run the Script
python3 ai.py
