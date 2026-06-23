#!/bin/bash

# ==============================================================================
# WORM-GPT CYBERPUNK INSTALLER (v4.1 - Ultimate Termux Fixes)
# Supported: Termux, Kali Linux, Kali NetHunter, macOS, Windows
# ==============================================================================

# --- NEON COLOR PALETTE ---
C_DEF='\033[0m'          
C_RED='\033[38;5;196m'   
C_GRN='\033[38;5;46m'    
C_CYN='\033[38;5;51m'    
C_YLW='\033[38;5;226m'   
C_MAG='\033[38;5;201m'   
C_DIM='\033[38;5;238m'   
C_BLD='\033[1m'          

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

clear
print_header() {
    local term_width=$(tput cols 2>/dev/null || stty size 2>/dev/null | cut -d' ' -f2 || echo 80)
    echo -e "${C_RED}${C_BLD}"
    
    # 1. Capture raw figlet art
    local art="$(figlet "WORM GPT")"
    
    # 2. Calculate the maximum true width of the ASCII art (stripping trailing spaces)
    local max_len=0
    while IFS= read -r line; do
        # Use printf to avoid evaluating backslashes
        local trimmed="$(printf "%s" "$line" | sed 's/ *$//')"
        if [ ${#trimmed} -gt $max_len ]; then
            max_len=${#trimmed}
        fi
    done <<< "$art"
    
    # 3. Calculate uniform left padding for the entire block
    local pad=$(( (term_width - max_len) / 2 ))
    if [ "$pad" -lt 0 ]; then pad=0; fi
    local padding=$(printf "%${pad}s" "")
    
    # 4. Print the padded block safely
    while IFS= read -r line; do
        local clean_line="$(printf "%s" "$line" | sed 's/ *$//')"
        # Only print if the line isn't completely empty, preventing gap issues
        if [ -n "$clean_line" ]; then
            printf "%s%s\n" "$padding" "$clean_line"
        fi
    done <<< "$art"
    
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
    MACHINE="Linux" 
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
    pkg install tur-repo -y
    
    # Pre-install all C-headers and libraries so pip can compile anything it needs
    pkg install python git rust binutils cmake ninja openblas libjpeg-turbo libpng freetype -y 
    pkg install python-numpy python-pandas python-pillow -y
    
    echo ""
    center "${C_RED}+=================================================================+${C_DEF}"
    center "${C_RED}OPTIONAL WORM KIT DEPLOYMENT${C_DEF}"
    center "${C_RED}+=================================================================+${C_DEF}"
    center "${C_DIM}The Worm Kit includes advanced security tools (Nmap, SQLmap, WPScan).${C_DEF}"
    center "${C_YLW}Reason for making this optional:${C_DEF}"
    center "${C_CYN}Compiling native Ruby gems (like Nokogiri for WPScan) on Android can${C_DEF}"
    center "${C_CYN}take 15-45 minutes and consumes significant CPU/Battery resources.${C_DEF}"
    center "${C_GRN}If you only want to use the AI Chat features, you can safely skip this.${C_DEF}"
    echo ""

    # Dynamically center the input prompt
    local_term_width=$(tput cols 2>/dev/null || stty size 2>/dev/null | cut -d' ' -f2 || echo 80)
    prompt_raw="Install Worm Kit Modules? [y/N]: "
    prompt_pad=$(( (local_term_width - ${#prompt_raw}) / 2 ))
    if [ "$prompt_pad" -gt 0 ]; then printf "%${prompt_pad}s" ""; fi

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
    if [ "$MACHINE" = "Termux" ]; then
        python3 -m venv odiyan --system-site-packages
    else
        python3 -m venv odiyan
    fi
    print_success "Virtual Sandbox Created: 'odiyan'"
else
    print_success "Virtual Sandbox Found: 'odiyan'"
fi

if [ "$MACHINE" = "Windows" ]; then
    source odiyan/Scripts/activate
else
    source odiyan/bin/activate
fi

pip install --upgrade pip

if [ "$MACHINE" = "Termux" ]; then
    print_step "INSTALLING TERMINAL & GRADIO CORE (Termux Safe Mode)..."
    
    # Termux Compiler Flags to force pip to find the JPEG headers
    export ANDROID_API_LEVEL=24
    export MATHLIB="m"
    export LDFLAGS="-L${PREFIX}/lib"
    export CFLAGS="-I${PREFIX}/include"
    
    # SINGLE LINE PIP INSTALL to prevent 'watchdog: command not found' copy-paste errors
    pip install requests rich pyfiglet langdetect gradio
else
    print_step "INSTALLING CORE & STREAMLIT MODULES..."
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        # SINGLE LINE PIP INSTALL to prevent syntax errors
        pip install requests rich pyfiglet langdetect streamlit watchdog
    fi
fi

print_success "Python Dependencies Locked"
echo ""

# ==============================================================================
# PHASE 4: GLOBAL LAUNCH COMMANDS CONFIGURATION
# ==============================================================================
print_step "ESCALATING PERMISSIONS & WRITING ALIASES..."
chmod +x worm-gpt.py 2>/dev/null
chmod +x worm-gpt-web-1.py 2>/dev/null
chmod +x worm-gpt-web-2.py 2>/dev/null
CURRENT_DIR="$(pwd)"

if [ "$MACHINE" = "Termux" ]; then
    BIN_DIR="$PREFIX/bin"
    SUDO_CMD=""
elif [ "$MACHINE" = "Linux" ] || [ "$MACHINE" = "Mac" ]; then
    BIN_DIR="/usr/local/bin"
    if [ "$EUID" -ne 0 ]; then SUDO_CMD="sudo"; else SUDO_CMD=""; fi
fi

if [ "$MACHINE" = "Windows" ]; then
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
streamlit run worm-gpt-web-1.py %*
EOF
    print_success "Generated Windows Batch Launchers (worm-gpt.bat & worm-gpt-gui.bat)"
    print_warning "Add this directory to your Windows Environment Variables (PATH) to run globally."

else
    $SUDO_CMD tee $BIN_DIR/worm-gpt > /dev/null << EOF
#!/bin/bash
cd "$CURRENT_DIR"
source odiyan/bin/activate
python3 worm-gpt.py "\$@"
EOF

    if [ "$MACHINE" = "Termux" ]; then
        $SUDO_CMD tee $BIN_DIR/worm-gpt-gui > /dev/null << EOF
#!/bin/bash
cd "$CURRENT_DIR"
source odiyan/bin/activate
python3 worm-gpt-web-2.py "\$@"
EOF
    else
        $SUDO_CMD tee $BIN_DIR/worm-gpt-gui > /dev/null << EOF
#!/bin/bash
cd "$CURRENT_DIR"
source odiyan/bin/activate
streamlit run worm-gpt-web-1.py "\$@"
EOF
    fi

    $SUDO_CMD chmod +x $BIN_DIR/worm-gpt
    $SUDO_CMD chmod +x $BIN_DIR/worm-gpt-gui
    print_success "Global Execution Paths Registered in $BIN_DIR"
fi

echo ""

# ==============================================================================
# END SEQUENCE
# ==============================================================================
center "${C_DIM}──────────────────────────────────────────────────────────────────────${C_DEF}"
center "${C_GRN}${C_BLD}>>> DEPLOYMENT 100% COMPLETE. SYSTEM IS LIVE. <<<${C_DEF}"
center "${C_DIM}──────────────────────────────────────────────────────────────────────${C_DEF}"
echo ""

center "${C_CYN}SELECT INTERFACE UPLINK:${C_DEF}"
center "${C_RED}[1]${C_DEF} ${C_BLD}CLI Mode${C_DEF} (Terminal Attack)"
center "${C_RED}[2]${C_DEF} ${C_BLD}GUI Mode${C_DEF} (Visual Dashboard)"
center "${C_RED}[3]${C_DEF} ${C_DIM}Exit Matrix${C_DEF}"
echo ""

# Dynamically center the input prompt
local_term_width=$(tput cols 2>/dev/null || stty size 2>/dev/null | cut -d' ' -f2 || echo 80)
prompt_raw="root@wormgpt:~# "
prompt_pad=$(( (local_term_width - ${#prompt_raw}) / 2 ))
if [ "$prompt_pad" -gt 0 ]; then printf "%${prompt_pad}s" ""; fi

read -p "$(echo -e ${C_RED}root@wormgpt:~# ${C_DEF})" choice

case $choice in
    1)
        echo ""
        center "${C_RED}[*] BREACHING TERMINAL...${C_DEF}"
        sleep 1
        if [ "$MACHINE" = "Windows" ]; then worm-gpt.bat; else worm-gpt; fi
        ;;
    2)
        echo ""
        center "${C_RED}[*] INITIALIZING WEB SERVER...${C_DEF}"
        sleep 1
        if [ "$MACHINE" = "Windows" ]; then worm-gpt-gui.bat; else worm-gpt-gui; fi
        ;;
    *)
        echo ""
        center "${C_GRN}Connection Terminated.${C_DEF}"
        echo ""
        center "${C_CYN}To launch manually from anywhere in your terminal, use:${C_DEF}"
        center "${C_YLW}CLI Mode:${C_DEF} worm-gpt"
        center "${C_YLW}GUI Mode:${C_DEF} worm-gpt-gui"
        echo ""
        exit 0
        ;;
esac
