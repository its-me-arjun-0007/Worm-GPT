# 💀 WormGPT CLI - Ultimate Hacker Edition

> *“We don't just chat. We infiltrate.”*

**WormGPT CLI** is an advanced, terminal-based interface for interacting with Large Language Models (LLMs) via the OpenRouter API. 

Re-engineered for a **Cyberpunk/Hacker aesthetic**, this tool provides a powerful environment for unrestricted coding, research, and testing. It features a complete visual overhaul, multi-key management, and an encrypted-style communication flow.

---

## 🚀 System Capabilities

* **💻 Cyberpunk Interface:** Built with `rich` for a stunning, high-contrast terminal UI with matrix-style boot sequences.
* **🧠 Multi-Model Matrix:** Pre-configured with uncensored/unlocked models (DeepSeek, Llama 3, Gemini) with hot-swapping capabilities.
* **🔑 API Key Vault:** Store multiple OpenRouter keys and switch between them instantly if one hits a quota limit.
* **💾 Persistent Memory:** Full conversation history retention for complex, multi-turn coding tasks.
* **📡 Simulated Uplink:** "Transmitting Data Packets" visualization for immersive interaction.
* **🛡️ Jailbreak Mode:** Auto-loads a custom system prompt (`system-prompt.txt`) to bypass standard restrictions.

---

## 📦 System Requirements

* **OS:** Linux (Kali/Ubuntu), macOS, Windows (PowerShell/CMD) or Termux
* **Python:** 3.8+
* **Access:** Active [OpenRouter API Key](https://openrouter.ai/)

---

## ⚙️ Deployment Protocol

### 1. Clone the Repository
```bash
git clone https://github.com/its-me-arjun-0007/worm-gpt
cd worm-gpt
```

## 📦 Requirements

- Python 3.6+
- `pip` installed
- OpenRouter API key ([get one here](https://openrouter.ai/))

---

## Use a Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install requests rich pyfiglet langdetect
```

## Run the script:

```bash
python3 ai.py
```

## 🕹️ Operations Manual

Upon initialization, the Boot Sequence will load, followed by the Main Command Center:

[1] 🧠 Manage Models
View the loaded model database.
Add: Inject new model IDs from OpenRouter.
Select: Choose your active "Target Model" for the session.
Delete: Remove obsolete models.

[2] 🔑 Manage API Keys
Access the Key Vault.
Store multiple keys securely.
Rotate keys to avoid rate limits or bans.
Active Key: The system automatically uses the selected key for all requests.

[3] 💀 Start Attack (Chat)
Enter the terminal session.
Interactive Shell: Type your query.
Visuals: Watch real-time "Data Packet Transmission" status.
Commands:
clear : Wipe memory and screen (avoids context pollution).
menu  : Return to base.
exit  : Kill the connection.


## 🔑 Configuration

The system automatically generates a wormgpt_config.json file. You can manually edit this to inject keys or change defaults:
```
{
  "api_keys": [
    "sk-or-v1-xxxxxxxx...",
    "sk-or-v1-yyyyyyyy..."
  ],
  "active_key_index": 0,
  "models": [
    "deepseek/deepseek-chat-v3-0324:free",
    "kwaipilot/kat-coder-pro:free",
    "google/gemini-2.0-flash-exp:free"
  ],
  "active_model_index": 0,
  "language": "English"
}

```

## ⚠️ Disclaimer

WormGPT CLI is a wrapper tool for the OpenRouter API. The "WormGPT" branding is for aesthetic/educational purposes only. The user is responsible for all content generated and actions taken using this tool.
With great power comes great fun. Don't get caught.

## 👨‍💻 Author

GitHub: @its-me-arjun-0007

Instagram: https://www.instagram.com/its_me_arjun_2255

Project URL: https://github.com/its-me-arjun-0007/worm-gpt
