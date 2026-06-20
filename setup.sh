#!/bin/bash

# ==============================================================================
# WORM-GPT CYBERPUNK INSTALLER (v3.0)
# Supported: Termux, Kali Linux, Kali NetHunter, macOS, Windows
# ==============================================================================

# --- NEON COLOR PALETTE ---
C_DEF='\033[0m'          # Default
C_RED='\033[38;5;196m'   # Neon Red
C_GRN='\033[38;5;46m'    # Matrix Green
C_CYN='\033[38;5;51m'    # Cyan
C_YLW='\033[38;5;226m'   # Yellow
C_MAG='\033[38;5;201m'   # Magenta
C_DIM='\033[38;5;238m'   # Dark Gray
C_BLD='\033[1m'          # Bold

# --- UI COMPONENTS & PRE-FLIGHT ---
if ! command -v figlet &> /dev/null; then
    if [ -n "$PREFIX" ] && [ -x "$PREFIX/bin/pkg" ]; then
        pkg install figlet -y &>/dev/null
    elif command -v apt-get &> /dev/null; then
        apt-get install figlet -y &>/dev/null
    elif command -v brew &> /dev/null; then
        brew install figlet &>/dev/null
    fi
fi

center() {
    local text="$1"
    local term_width=$(tput cols 2>/dev/null || stty size 2>/dev/null | cut -d' ' -f2 || echo 60)
    local plain_text=$(echo -e "$text" | sed "s/$(printf '\033')\\[[0-9;]*[a-zA-Z]//g")
    local text_len=${#plain_text}
    local pad=$(( (term_width - text_len) / 2 ))
    if [ "$pad" -gt 0 ]; then printf "%${pad}s" ""; fi
    echo -e "$text"
}

print_header() {
    local term_width=$(tput cols 2>/dev/null || echo 80)
    echo -e "${C_RED}${C_BLD}"
    figlet -c -w $term_width "WORM GPT"
    echo -e "${C_DEF}"
    center "${C_DIM}+-----------------------------------------+${C_DEF}"
    center "${C_DIM}|${C_DEF}   ${C_CYN}SYSTEM INITIALIZATION & DEPLOYMENT${C_DEF}    ${C_DIM}|${C_DEF}"
    center "${C_DIM}+-----------------------------------------+${C_DEF}"
    echo ""
}

print_step() { echo -e "${C_MAG}[►]${C_DEF} ${C_BLD}$1${C_DEF}"; }
print_success() { echo -e "    ${C_GRN}└─ [✔] $1${C_DEF}"; }
print_warning() { echo -e "${C_YLW}[!] $1${C_DEF}"; }

# ==============================================================================
# PHASE 1: OS DETECTION
# ==============================================================================
print_header
print_step "SCANNING HOST ARCHITECTURE..."

OS="$(uname -s)"
MACHINE="Unknown"

if [ -n "$PREFIX" ] && [ -x "$PREFIX/bin/pkg" ]; then
    MACHINE="Termux"
elif [ "$OS" = "Linux" ]; then
    MACHINE="Linux" # Covers Kali and NetHunter
elif [ "$OS" = "Darwin" ]; then
    MACHINE="Mac"
elif [[ "$OS" == CYGWIN* || "$OS" == MINGW* || "$OS" == MSYS* ]]; then
    MACHINE="Windows"
fi

print_success "Architecture Detected: ${C_CYN}${MACHINE}${C_DEF}"
echo ""

# ==============================================================================
# PHASE 2: SYSTEM PACKAGES & SECURITY TOOLS
# ==============================================================================
print_step "INJECTING SYSTEM PACKAGES..."

if [ "$MACHINE" = "Termux" ]; then
    pkg update -y
    pkg install python git rust binutils -y 
    
    echo -e "\n${C_RED}+=================================================================+${C_DEF}"
    echo -e "${C_RED}|${C_DEF} ${C_BLD}OPTIONAL WORM KIT DEPLOYMENT (Termux)${C_DEF}                           ${C_RED}|${C_DEF}"
    echo -e "${C_RED}+=================================================================+${C_DEF}"
    echo -e "${C_DIM}The Worm Kit includes advanced security tools (Nmap, SQLmap, WPScan).${C_DEF}"
    echo -e "${C_YLW}Reason for making this optional:${C_DEF}"
    echo -e "${C_CYN}Compiling native Ruby gems (like Nokogiri for WPScan) on Android can${C_DEF}"
    echo -e "${C_CYN}take 15-45 minutes and consumes significant CPU/Battery resources.${C_DEF}"
    echo -e "${C_GRN}If you only want to use the AI Chat features, you can safely skip this.${C_DEF}\n"

    
    read -p "$(echo -e ${C_CYN}Install Worm Kit Modules? [y/N]: ${C_DEF})" INSTALL_KIT
    
    if [[ "$INSTALL_KIT" =~ ^[Yy]$ ]]; then
        print_step "COMPILING WORM KIT..."
        pkg install nmap dnsutils whois ruby clang make pkg-config libxml2 libxslt libffi libiconv zlib -y
        
        if ! command -v sqlmap &> /dev/null; then
            git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git ~/sqlmap-dev
            ln -sf ~/sqlmap-dev/sqlmap.py $PREFIX/bin/sqlmap
            chmod +x $PREFIX/bin/sqlmap
        fi
        
        export NOKOGIRI_USE_SYSTEM_LIBRARIES=1
        gem install nokogiri --platform=ruby -- \
            --use-system-libraries \
            --with-xml2-include=$PREFIX/include/libxml2 \
            --with-xml2-lib=$PREFIX/lib \
            --with-xslt-include=$PREFIX/include/libxslt \
            --with-xslt-lib=$PREFIX/lib \
            --with-iconv-include=$PREFIX/include \
            --with-iconv-lib=$PREFIX/lib
        gem install wpscan
        print_success "Worm Kit Installed."
    else
        print_warning "Worm Kit skipped. AI modules only."
    fi

elif [ "$MACHINE" = "Linux" ]; then
    if [ "$EUID" -ne 0 ]; then 
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi
    $SUDO_CMD apt-get update
    $SUDO_CMD apt-get install python3 python3-venv python3-pip git ruby-full build-essential libxml2-dev libxslt1-dev libffi-dev -y
    $SUDO_CMD apt-get install nmap sqlmap nikto whatweb dnsutils whois -y
    $SUDO_CMD gem install wpscan

elif [ "$MACHINE" = "Mac" ]; then
    if command -v brew &> /dev/null; then
        brew install python git nmap sqlmap ruby
        gem install wpscan
    else
        print_warning "Homebrew not found. Skipping dependency installation."
    fi

elif [ "$MACHINE" = "Windows" ]; then
    print_warning "Windows detected. Assuming Python & Git are natively installed."
    print_warning "Nmap, SQLmap, and Ruby must be installed manually on Windows."
fi
echo ""

# ==============================================================================
# PHASE 3: NEURAL NETWORK (VENV)
# ==============================================================================
print_step "ALLOCATING NEURAL MEMORY (VIRTUAL ENV)..."
if [ ! -d "odiyan" ]; then
    python3 -m venv odiyan
    print_success "Virtual Sandbox Created: 'odiyan'"
else
    print_success "Virtual Sandbox Found: 'odiyan'"
fi

# Windows activation logic for venv differs
if [ "$MACHINE" = "Windows" ]; then
    source odiyan/Scripts/activate
else
    source odiyan/bin/activate
fi

pip install --upgrade pip

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    # Fallback to manual installation if requirements.txt isn't present
    pip install requests rich pyfiglet langdetect streamlit watchdog
fi
print_success "Python Dependencies Locked"
echo ""

# ==============================================================================
# PHASE 4: GLOBAL LAUNCH COMMANDS CONFIGURATION
# ==============================================================================
print_step "ESCALATING PERMISSIONS & WRITING ALIASES..."
chmod +x worm-gpt.py
chmod +x worm-gpt-web.py 2>/dev/null
CURRENT_DIR="$(pwd)"

if [ "$MACHINE" = "Termux" ]; then
    BIN_DIR="$PREFIX/bin"
    SUDO_CMD=""
elif [ "$MACHINE" = "Linux" ] || [ "$MACHINE" = "Mac" ]; then
    BIN_DIR="/usr/local/bin"
    if [ "$EUID" -ne 0 ]; then SUDO_CMD="sudo"; else SUDO_CMD=""; fi
fi

if [ "$MACHINE" = "Windows" ]; then
    # Generate Windows .bat launchers
    tee worm-gpt.bat > /dev/null << EOF
@echo off
cd /d "%~dp0"
call odiyan\Scripts\activate.bat
python worm-gpt.py %*
EOF

    tee worm-gpt-gui.bat > /dev/null << EOF
@echo off
cd /d "%~dp0"
call odiyan\Scripts\activate.bat
streamlit run worm-gpt-web.py %*
EOF
    print_success "Generated Windows Batch Launchers (worm-gpt.bat & worm-gpt-gui.bat)"
    print_warning "Add this directory to your Windows Environment Variables (PATH) to run globally."

else
    # Generate UNIX bash launchers
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
    print_success "Global Execution Paths Registered in $BIN_DIR"
fi

echo ""

# ==============================================================================
# END SEQUENCE
# ==============================================================================
echo -e "${C_DIM}──────────────────────────────────────────────────────────────────────${C_DEF}"
echo -e "${C_GRN}${C_BLD}>>> DEPLOYMENT 100% COMPLETE. SYSTEM IS LIVE. <<<${C_DEF}"
echo -e "${C_DIM}──────────────────────────────────────────────────────────────────────${C_DEF}"
echo ""

echo -e "${C_CYN}SELECT INTERFACE UPLINK:${C_DEF}"
echo -e "  ${C_RED}[1]${C_DEF} ${C_BLD}CLI Mode${C_DEF} (Terminal Attack)"
echo -e "  ${C_RED}[2]${C_DEF} ${C_BLD}GUI Mode${C_DEF} (Visual Dashboard)"
echo -e "  ${C_RED}[3]${C_DEF} ${C_DIM}Exit Matrix${C_DEF}"
echo ""

read -p "root@wormgpt:~# " choice

case $choice in
    1)
        echo -e "\n${C_RED}[*] BREACHING TERMINAL...${C_DEF}"
        sleep 1
        if [ "$MACHINE" = "Windows" ]; then worm-gpt.bat; else worm-gpt; fi
        ;;
    2)
        echo -e "\n${C_RED}[*] INITIALIZING WEB SERVER...${C_DEF}"
        sleep 1
        if [ "$MACHINE" = "Windows" ]; then worm-gpt-gui.bat; else worm-gpt-gui; fi
        ;;
    *)
        echo -e "\n${C_GRN}Connection Terminated.${C_DEF}"
        exit 0
        ;;
esac
