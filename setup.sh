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

# --- TIME WARNING ---
echo -e "${RED}[!] WARNING: TIME INTENSIVE PROCESS${NC}"
echo -e "${YELLOW}This script installs heavy system-level security dependencies${NC}"
echo -e "${YELLOW}(Nmap, SQLmap, Ruby, WPScan, Rust). Depending on your hardware${NC}"
echo -e "${YELLOW}(especially on Kalidroid/Termux), this may take 15-45 minutes.${NC}"
echo -e "${CYAN}Please be patient and DO NOT interrupt the installation.${NC}\n"
echo -e "Starting in 5 seconds... (Press Ctrl+C to abort)"
sleep 5
echo ""

# 1. Detect Environment & System Deps
echo -e "${YELLOW}[*] Scanning Environment and Installing Security Tools...${NC}"

if [ -d "$PREFIX/bin" ] && [ -x "$PREFIX/bin/pkg" ]; then
    echo -e "${GREEN}[+] Termux detected.${NC}"
    echo -e "${CYAN}[*] Installing System Packages (Python, Git, Build Tools, Security Tools)...${NC}"
    pkg update -y
    # Base packages
    pkg install python git rust binutils ruby -y 
    # HexKit Tool Dependencies for Termux
    pkg install nmap sqlmap dnsutils whois -y
    # Install WPScan via gem (since ruby is installed)
    gem install wpscan
else
    echo -e "${GREEN}[+] Linux (Kali/Debian) detected.${NC}"
    echo -e "${CYAN}[*] Installing System Packages and Security Tools...${NC}"
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Note: Run as root (sudo) if system packages fail to install.${NC}"
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi
    $SUDO_CMD apt-get update
    # Base packages
    $SUDO_CMD apt-get install python3 python3-venv python3-pip git ruby-full -y
    # HexKit Tool Dependencies for Linux
    $SUDO_CMD apt-get install nmap sqlmap nikto whatweb dnsutils whois -y
    # Install WPScan via gem
    $SUDO_CMD gem install wpscan
fi

# 2. Virtual Environment Setup
echo -e "\n${YELLOW}[*] Configuring Neural Network (VENV)...${NC}"
if [ ! -d "odiyan" ]; then
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
