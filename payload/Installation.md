# A. Kali Linux & Kali NetHunter

*Kali environments are Debian-based, so the APT package manager is used.*
 1. **Install System Dependencies:**
   ```bash
   sudo apt-get update
   sudo apt-get install python3 python3-venv python3-pip git ruby-full nmap sqlmap nikto whatweb dnsutils whois -y
   sudo gem install wpscan
   
   ```
 2. **Configure Virtual Environment:**
   ```bash
   python3 -m venv odiyan
   source odiyan/bin/activate
   pip install --upgrade pip
   pip install requests rich pyfiglet langdetect streamlit watchdog
   ```

# B. Termux (Android)
*Termux uses the pkg package manager.*
 1. **Install System Dependencies:**
   ```bash
    pkg update -y
    pkg install tur-repo -y
    pkg install python git rust binutils cmake ninja openblas libjpeg-turbo libpng freetype -y  
    pkg install python-numpy python-pandas python-pillow -y
   ```
 2. **Configure Virtual Environment:**
   ```bash
   python -m venv odiyan --system-site-packages
   source odiyan/bin/activate
   pip install --upgrade pip
   export ANDROID_API_LEVEL=24
   export MATHLIB="m"
   export LDFLAGS="-L${PREFIX}/lib"
   export CFLAGS="-I${PREFIX}/include"
   pip install requests rich pyfiglet langdetect gradio

   ```

# C. macOS
*macOS relies on Homebrew for package management.*
 1. **Install System Dependencies:**
   ```bash
   brew update
   brew install python git nmap sqlmap whois ruby
   sudo gem install wpscan
   
   ```
 2. **Configure Virtual Environment:**
   ```bash
   python3 -m venv odiyan
   source odiyan/bin/activate
   pip install --upgrade pip
   pip install -r requirements.txt
   
   ```

# D. Windows
*Windows requires a slightly different approach using PowerShell or Command Prompt.*
 1. **Install System Dependencies:**
   * Install Python 3 from the Microsoft Store or Python.org.
   * Install Git via Git for Windows.
   * Install Nmap via the official Windows installer.
 2. **Configure Virtual Environment:**
   ```cmd
   python -m venv odiyan
   odiyan\Scripts\activate
   pip install -r requirements.txt
   
   ```

# 3. Global Launch Commands Configuration
To run worm-gpt and worm-gpt-gui from anywhere while automatically activating the odiyan virtual environment, you must create executable wrappers that point to your absolute installation path.
**Important:** In the scripts below, replace /path/to/Worm-GPT (or C:\path\to\Worm-GPT) with the actual absolute path where you cloned the repository.

# For Linux, Kali, NetHunter, Mac, and Termux
 1. **Create CLI Launcher** (worm-gpt):
Open a terminal and create the file in a globally accessible directory.
Linux/Mac: /usr/local/bin/worm-gpt
Termux: $PREFIX/bin/worm-gpt
Add this code:
   ```bash
   #!/bin/bash
   # Navigate to the exact tool directory
   cd /path/to/Worm-GPT
   
   # Activate the environment
   source odiyan/bin/activate
   
   # Execute the script and pass any command-line arguments
   python3 worm-gpt.py "$@"

   ```
 2. **Create GUI Launcher** (worm-gpt-gui):
Linux/Mac: /usr/local/bin/worm-gpt-gui
Add this code to launch the Streamlit interface:
   ```bash
   #!/bin/bash
   cd /path/to/Worm-GPT
   source odiyan/bin/activate
   streamlit run worm-gpt-web-1.py "$@"
   
   ```

Termux: $PREFIX/bin/worm-gpt-gui
Add this code to launch the lightweight Gradio interface:
   ```bash
   #!/bin/bash
   cd /path/to/Worm-GPT
   source odiyan/bin/activate
   python3 worm-gpt-web-2.py "$@"
   
   ```
 3. **Make them executable:**
*Linux/Mac:* /usr/local/bin/worm-gpt-gui
*Termux:* $PREFIX/bin/worm-gpt-gui
   ```bash
   chmod +x $PREFIX/bin/worm-gpt
   chmod +x $PREFIX/bin/worm-gpt-gui
   
   ```
 
# For Windows
On Windows, you create batch (.bat or .cmd) files and place them in a folder that is registered in your system's %PATH% environment variable (e.g., C:\Windows\System32 or a custom C:\Scripts folder).
 1. **Create CLI Launcher (worm-gpt.cmd):**
   ```cmd
   @echo off
   cd /d C:\path\to\Worm-GPT
   call odiyan\Scripts\activate.bat
   python worm-gpt.py %*
   
   ```
 2. **Create GUI Launcher (worm-gpt-gui.cmd):**
   ```cmd
   @echo off
   cd /d C:\path\to\Worm-GPT
   call odiyan\Scripts\activate.bat
   streamlit run worm-gpt-web-1.py %*

   
   ```

## 🚀 Execution Summary
Once the installation matrix is executed for your specific operating system, you can safely navigate anywhere in your terminal ecosystem and execute the tool dynamically:

| Command | Action Type | Targeted Output |
| :--- | :--- | :--- |
| worm-gpt | **Command Line Interface** | Boots the secure portal and terminal chat loop |
| worm-gpt-gui | **Graphical User Interface** | Spawns the local Streamlit (Desktop) or Gradio (Termux) web application server |
