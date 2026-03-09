# 💀 WormGPT - Ultimate Hacker Edition (CLI & GUI)

![WormGPT Banner](image/1003012739.jpg)

> *“We don't just chat. We infiltrate.”*

**WormGPT** is a powerful, dual-interface (CLI & Web) tool designed for interacting with Large Language Models (LLMs) via the OpenRouter API. Re-engineered for a **Cyberpunk/Hacker aesthetic**, this tool offers a secure, encrypted-style environment for coding, research, and penetration testing simulations.

Whether you prefer the raw power of the terminal or a sleek web dashboard, WormGPT adapts to your workflow.

---

## 🚀 System Capabilities

### 💻 Core Features

* **Dual Interfaces:**
    * **CLI V2.5:** A `rich`-based terminal UI with matrix boot sequences, hexadecimal memory injection visuals, and robust session management.
    * **GUI V3.3:** A Streamlit-based web interface featuring "Hacker Green" CSS, file upload analysis, and real-time chat logging.
* **📱 Remote Telegram Uplink:** Control WormGPT remotely via a secure Telegram bot integration. Features ID-locked access, remote chat commands, memory wiping, and AI image generation.
* **🔐 Secure Login Portal:** Built-in local authentication system using SHA-256 hashing to protect your local environment from unauthorized access.
* **🧠 Multi-Model Matrix:** Pre-configured support for top-tier free models including **DeepSeek-V3**, **Gemini 2.0 Flash**, **Qwen Coder**, and **Mistral**, with instant hot-swapping capabilities.
* **🎭 Persona Injection:**
    * **Jailbreak Mode (Rude):** Unrestricted, aggressive persona for red-teaming.
    * **Assistant Mode (Polite):** Helpful, professional persona for coding tasks.
* **💾 Mission Logs:** Automatically saves conversation history with timestamps to `mission_logs/` for persistent memory.
* **🐧 Cross-Platform:** Optimized for **Kali Linux**, **Termux (Android)**, Ubuntu, and Windows.
---

## 🧠 Recommended Free Models (OpenRouter)

### 💻 Deep Code & Exploit Analysis
```
 - qwen/qwen3-vl-30b-a3b-thinking (Context: 131072 tokens)
 - qwen/qwen3-vl-235b-a22b-thinking (Context: 131072 tokens)
 - qwen/qwen3-next-80b-a3b-instruct:free (Context: 262144 tokens)
 - qwen/qwen3-coder:free (Context: 262000 tokens)
 - qwen/qwen3-4b:free (Context: 40960 tokens)
```
### 🕵️ Massive Data & Log Parsing
```
 - openrouter/free (Context: 200000 tokens)
 - stepfun/step-3.5-flash:free (Context: 256000 tokens)
 - arcee-ai/trinity-large-preview:free (Context: 131000 tokens)
 - nvidia/nemotron-3-nano-30b-a3b:free (Context: 256000 tokens)
 - arcee-ai/trinity-mini:free (Context: 131072 tokens)
 - nvidia/nemotron-nano-12b-v2-vl:free (Context: 128000 tokens)
 - nvidia/nemotron-nano-9b-v2:free (Context: 128000 tokens)
 - openai/gpt-oss-120b:free (Context: 131072 tokens)
 - openai/gpt-oss-20b:free (Context: 131072 tokens)
 - z-ai/glm-4.5-air:free (Context: 131072 tokens)
 - mistralai/mistral-small-3.1-24b-instruct:free (Context: 128000 tokens)
 - google/gemma-3-27b-it:free (Context: 131072 tokens)
 - meta-llama/llama-3.3-70b-instruct:free (Context: 128000 tokens)
 - meta-llama/llama-3.2-3b-instruct:free (Context: 131072 tokens)
 - nousresearch/hermes-3-llama-3.1-405b:free (Context: 131072 tokens)
```
### 🎭 Red Teaming & Jailbreak Mode
```
 - cognitivecomputations/dolphin-mistral-24b-venice-edition:free (Context: 32768 tokens)
 - google/gemma-3n-e2b-it:free (Context: 8192 tokens)
 - google/gemma-3n-e4b-it:free (Context: 8192 tokens)
 - google/gemma-3-4b-it:free (Context: 32768 tokens)
 - google/gemma-3-12b-it:free (Context: 32768 tokens)
```
> **💡 Pro-Tip:** Free model availability on OpenRouter changes frequently. If a model throws an error, simply hot-swap to the next index in your `wormgpt_config.json`.


## 📸 Visuals

### Terminal Interface (CLI)
*Experience the raw power of the command line.*
![CLI Interface](image/1003017748.jpg)

### Web Dashboard (GUI)
*A modern, visual command center.*
![GUI Interface](image/1003017739.jpg)

---

## 📦 Prerequisites

Before initializing the system, ensure you have:
* **Python 3.8+**
* **Git**
* **OpenRouter API Key** (Get one at [OpenRouter.ai](https://openrouter.ai/))

---

## ⚙️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/its-me-arjun-0007/Worm-GPT
cd Worm-GPT
```

## 📦 Requirements

- Python 3.6+
- `pip` installed
- OpenRouter API key ([get one here](https://openrouter.ai/))

---

## Automated Setup

```bash
chmod +x *
./setup.sh
```

## Manual Installation

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install requests rich pyfiglet langdetect streamlit
```

 ***Option A :***

Launch Command Line (CLI)
Ideal for low-latency, keyboard-driven usage.

```bash
python3 worm-gpt.py
```

 ***Option B :***

Launch Web Interface (GUI)
Ideal for visual interactions and file analysis.

```bash
streamlit run worm-gpt-web.py
```


## 🔐 Configuration & Security

### User Authentication
Upon launch, the system requires a login. This adds a layer of security to your local interface.

**Default Credentials:**
* **Username:** `odiyan`
* **Password:** `admin`

You must configure the `wormgpt_users.json` file. If it does not exist, create it in the root directory. Because the system uses SHA-256 hashing for security, you must use the hashed version of the password. For the default "admin" password, your file should look exactly like this:

```json
{
  "odiyan": "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
}
```
To generate a password hash, run this quick Python command:
```
python3 -c "import hashlib; print(hashlib.sha256(input('Enter Password: ').encode()).hexdigest())"
```

API Configuration (wormgpt_config.json)
The system will automatically generate this file on first run. You can edit it manually to add keys or change models:
```bash
{
  "api_keys": [
    "sk-or-v1-xxxxxxxx...",
    "sk-or-v1-yyyyyyyy..."
  ],
  "active_key_index": 0,
  "models": [
    "deepseek/deepseek-r1-0528:free",
    "arcee-ai/trinity-large-preview:free"
  ],
  "active_model_index": 0,
  "language": "English",
  "max_tokens": 32000,
  "base_url": "https://openrouter.ai/api/v1",
  "telegram_token": "xxxxx",
  "telegram_id": "yyyyy"
}

```


### ​⚠️ Disclaimer
​WormGPT CLI/GUI is a client-side wrapper tool for the OpenRouter API.
​The "WormGPT" branding and "Hacker" aesthetic are for educational and entertainment purposes only.
​This tool does not inherently contain malicious code; it is a text generation interface.
​The user is fully responsible for all content generated and actions taken using this tool.
​Ensure you comply with the Terms of Service of the specific AI models you connect to via OpenRouter.
   
**👨‍💻 AUTHOR: IT'S ME ARJUN**

 * **GitHub:** [its-me-arjun-0007](https://github.com/its-me-arjun-0007)
 * **Instagram:** [@its\_me\_arjun\_2255](https://www.instagram.com/its_me_arjun_2255)
  * **WhatsApp:** [Chat on WhatsApp](https://wa.me/+917356118016)

<!-- end list -->
