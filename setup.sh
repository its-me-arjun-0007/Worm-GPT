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
    python3 -m venv odiyan
    echo -e "${GREEN}[+] Virtual Environment Created.${NC}"
else
    echo -e "${GREEN}[+] Virtual Environment Detected.${NC}"
fi

# 3. Install Python Dependencies (CLI + GUI)
echo -e "\n${YELLOW}[*] Installing Python Modules...${NC}"
source odiyan/bin/activate

# UPGRADED: Includes 'streamlit' for the GUI and 'watchdog' for file monitoring
pip install --upgrade pip
pip install requests rich pyfiglet langdetect streamlit watchdog

# 4. Permissions
chmod +x worm-gpt.py
chmod +x worm-gpt-web.py 2>/dev/null

# 5. Global Command Installation
echo -e "\n${YELLOW}[*] Installing Global Commands...${NC}"
CURRENT_DIR="$(pwd)"

if [ -d "$PREFIX/bin" ]; then
    BIN_DIR="$PREFIX/bin"
    SUDO_CMD=""
else
    BIN_DIR="/usr/local/bin"
    if [ "$EUID" -ne 0 ]; then
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi
fi

$SUDO_CMD tee $BIN_DIR/worm-gpt > /dev/null << EOF
#!/bin/bash
cd "$CURRENT_DIR"
source odiyan/bin/activate
python3 worm-gpt.py "\$@"
EOF

$SUDO_CMD tee $BIN_DIR/worm-gpt-gui > /dev/null << EOF
#!/bin/bash
cd "$CURRENT_DIR"
source odiyan/bin/activate
streamlit run worm-gpt-web.py "\$@"
EOF

$SUDO_CMD chmod +x $BIN_DIR/worm-gpt
$SUDO_CMD chmod +x $BIN_DIR/worm-gpt-gui
echo -e "${GREEN}[+] Global commands 'worm-gpt' and 'worm-gpt-gui' installed successfully.${NC}"

echo -e "\n${GREEN}[✔] SYSTEM READY. DEPENDENCIES INSTALLED.${NC}"
echo -e "------------------------------------------------"

# 6. Launch Menu
echo -e "${CYAN}SELECT OPERATION MODE:${NC}"
echo -e "${GREEN}[1]${NC} CLI Mode (Terminal Attack)"
echo -e "${GREEN}[2]${NC} GUI Mode (Visual Interface)"
echo -e "${GREEN}[3]${NC} Exit Setup"
echo ""
read -p "root@wormgpt:~# " choice

case $choice in
    1)
        echo -e "\n${RED}>> Initializing CLI...${NC}"
        worm-gpt
        ;;
    2)
        echo -e "\n${RED}>> Initializing GUI Protocol...${NC}"
        worm-gpt-gui
        ;;
    *)
        echo -e "\n${CYAN}Setup Complete. To run manually from anywhere:${NC}"
        echo -e "CLI: ${YELLOW}worm-gpt${NC}"
        echo -e "GUI: ${YELLOW}worm-gpt-gui${NC}"
        exit 0
        ;;
esac
