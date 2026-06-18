#!/bin/bash

# ==============================================================================
# WORM-GPT CYBERPUNK INSTALLER
# Environment: Termux / NetHunter / Kali Linux
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

# --- TERMINAL EFFECTS ---
type_text() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep 0.01
    done
    echo ""
}

fake_boot() {
    clear
    echo -e "${C_GRN}"
    for i in {1..12}; do
        hex=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 8)
        echo -e "[*] SYNCING MEMORY BLOCK 0x$hex... ${C_CYN}[ OK ]${C_GRN}"
        sleep 0.05
    done
    echo -e "${C_DEF}"
    clear
}

# --- UI COMPONENTS ---
print_header() {
    echo -e "${C_RED}${C_BLD}"
    echo "  ██     ██  ██████  ██████  ███    ███      ██████  ██████  ████████ "
    echo "  ██     ██ ██    ██ ██   ██ ████  ████     ██       ██   ██    ██    "
    echo "  ██  █  ██ ██    ██ ██████  ██ ████ ██     ██   ███ ██████     ██    "
    echo "  ██ ███ ██ ██    ██ ██   ██ ██  ██  ██     ██    ██ ██         ██    "
    echo "   ███ ███   ██████  ██   ██ ██      ██      ██████  ██         ██    "
    echo -e "${C_DEF}"
    echo -e "${C_DIM}┌──────────────────────────────────────────────────────────────────────┐${C_DEF}"
    echo -e "${C_DIM}│${C_DEF} ${C_CYN}SYSTEM INITIALIZATION & DEPLOYMENT PROTOCOL${C_DEF}                        ${C_DIM}│${C_DEF}"
    echo -e "${C_DIM}└──────────────────────────────────────────────────────────────────────┘${C_DEF}"
    echo ""
}

print_step() {
    echo -e "${C_MAG}[►]${C_DEF} ${C_BLD}$1${C_DEF}"
}

print_success() {
    echo -e "    ${C_GRN}└─ [✔] $1${C_DEF}"
}

print_warning() {
    echo -e "${C_YLW}[!] $1${C_DEF}"
}

# ==============================================================================
# BOOT SEQUENCE
# ==============================================================================
fake_boot
print_header

type_text "${C_YLW}>>> UPLINK ESTABLISHED. PREPARING SECURITY MODULES...${C_DEF}"
echo ""
echo -e "${C_RED}╔══════════════════════════════════════════════════════════════════════════════════╗${C_DEF}"
echo -e "${C_RED}║${C_DEF} ${C_BLD}WARNING: MASSIVE COMPILATION SEQUENCE INITIATED${C_DEF}                                  ${C_RED}║${C_DEF}"
echo -e "${C_RED}║${C_DEF} ${C_DIM}Downloading & building Nmap, WPScan, SQLmap, and Rust kernels...${C_DEF}                 ${C_RED}║${C_DEF}"
echo -e "${C_RED}║${C_DEF} ${C_YLW}ETA: 15 - 45 Minutes depending on Environment: Termux / NetHunter / Kali Linux${C_DEF} ${C_RED}║${C_DEF}"
echo -e "${C_RED}╚══════════════════════════════════════════════════════════════════════════════════╝${C_DEF}"
echo ""

type_text "${C_DIM}Initiating sequence in 5 seconds. Press Ctrl+C to abort...${C_DEF}"
sleep 5
echo ""

# ==============================================================================
# PHASE 1: ENVIRONMENT DETECTION & SYSTEM DEPS
# ==============================================================================
print_step "SCANNING HOST ARCHITECTURE..."

if [ -d "$PREFIX/bin" ] && [ -x "$PREFIX/bin/pkg" ]; then
    print_success "Termux Detected"
    print_step "INJECTING SYSTEM PACKAGES (APT/PKG)..."
    pkg update -y
    pkg install python git rust binutils ruby -y 
    pkg install nmap sqlmap dnsutils whois -y
    print_step "COMPILING RUBY GEMS (WPScan)..."
    gem install wpscan
else
    print_success "Kali Linux / NetHunter Detected"
    if [ "$EUID" -ne 0 ]; then 
        print_warning "Running without root. Sudo will be invoked."
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi
    print_step "INJECTING SYSTEM PACKAGES (APT)..."
    $SUDO_CMD apt-get update
    $SUDO_CMD apt-get install python3 python3-venv python3-pip git ruby-full -y
    $SUDO_CMD apt-get install nmap sqlmap nikto whatweb dnsutils whois -y
    print_step "COMPILING RUBY GEMS (WPScan)..."
    $SUDO_CMD gem install wpscan
fi

print_success "Core Architecture Secured"
echo ""

# ==============================================================================
# PHASE 2: NEURAL NETWORK (VENV)
# ==============================================================================
print_step "ALLOCATING NEURAL MEMORY (VIRTUAL ENV)..."
if [ ! -d "odiyan" ]; then
    python3 -m venv odiyan
    print_success "Virtual Sandbox Created: 'odiyan'"
else
    print_success "Virtual Sandbox Found: 'odiyan'"
fi
echo ""

# ==============================================================================
# PHASE 3: PYTHON MODULES
# ==============================================================================
print_step "DOWNLOADING NEURAL WEIGHTS (PIP MODULES)..."
source odiyan/bin/activate
pip install --upgrade pip
pip install requests rich pyfiglet langdetect streamlit watchdog
print_success "Python Dependencies Locked"
echo ""

# ==============================================================================
# PHASE 4: GLOBAL COMMANDS & PERMISSIONS
# ==============================================================================
print_step "ESCALATING PERMISSIONS & WRITING ALIASES..."
chmod +x worm-gpt.py
chmod +x worm-gpt-web.py 2>/dev/null
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
print_success "Global Execution Paths Registered"
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
        worm-gpt
        ;;
    2)
        echo -e "\n${C_RED}[*] INITIALIZING WEB SERVER...${C_DEF}"
        sleep 1
        worm-gpt-gui
        ;;
    *)
        echo -e "\n${C_GRN}Connection Terminated.${C_DEF}"
        echo -e "To access the system later, type: ${C_RED}worm-gpt${C_DEF} or ${C_RED}worm-gpt-gui${C_DEF}"
        exit 0
        ;;
esac
