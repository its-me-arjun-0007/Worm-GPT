# I. High-Level Architecture Overview
Worm-GPT operates on a client-side wrapper architecture. It functions as a central nervous system that bridges local user environments with external Large Language Models (LLMs) via the OpenRouter API. The system intercepts user input, enriches it with local memory and specialized cybersecurity skills using Retrieval-Augmented Generation (RAG), and routes it securely to the selected AI model.

# II. Core Subsystems
**1. Security & Authentication Layer**
 * **Module:** `login_system()`
 * **Function:** Guards the initial boot sequence.
 * **Mechanism:** Verifies user identity against a local JSON database (`wormgpt_users.json`) using SHA-256 cryptographic hashing to prevent unauthorized local access.  
   
**2. Interface & Access Layer**
 * **Terminal CLI:** The primary execution environment, utilizing the `rich` library for rendering highly structured, mathematically aligned text, tables, and centered UI panels.
 * **Web GUI:** A localized web server initiated via `launch_web_interface()`, dynamically executed through the Streamlit framework (`worm-gpt-web-1.py`) for desktop environments, or Gradio (`worm-gpt-web-2.py`) for lightweight mobile environments like Termux.
 * **Remote Uplink:** A secure Telegram bot integration (`start_telegram_bot()`) that allows remote command execution, locked specifically to your hardcoded Telegram User ID.
   
**3. Cognitive Engine (API Routing)**
 * **Module:** `call_api()`
 * **Function:** Manages the HTTP handshake with OpenRouter.
 * **Mechanism:** Injects the active API key, handles payload formatting (model selection, max tokens, temperature), and returns the sanitized JSON response.
   
**4. Context & Memory Matrix (RAG System)**
 * **UserMemory (`memory.py`):** Tracks conversational history, detects user mood, logs active session summaries, and manages explicit "remember this" commands.
 * **SkillsManager (`skills.py`):** A localized database of offensive security methodologies (OWASP, PrivEsc, Reverse Shells). It actively scans user queries to auto-inject relevant playbooks into the AI's system prompt.
 * **Dynamic Persona Injection:** Appends the user's alias, operating system, and chosen relationship dynamic (e.g., Subservient, Father, Lover) directly into the AI's core directive on every turn.
   
**5. Offensive Automation (Worm Kit)**
 * **Module:** `worm_kit_menu()`
 * **Function:** A modular execution hub for local Python scripts.
 * **Mechanism:** Dynamically imports and executes standalone offensive modules (`ctf.py`, `recon.py`, `vulnscan.py`) located in the `/modules/` directory.

# III. Data Flow Execution (Standard Query)
This represents the exact lifecycle of a single message sent by the user during a terminal chat session:

 1. **Input Capture:** The `rich` console captures the user's raw terminal input.
 2. **Context Assembly:** The UserMemory and SkillsManager classes analyze the input to extract relevant past memories and local pentest playbooks.
 3. **Prompt Synthesis:** The `manage_context` function compiles the Jailbreak Prompt, the injected RAG context, the Persona Override, and the conversational history into a strict token limit.
 4. **Transmission:** The compiled JSON packet is dispatched to the OpenRouter API via the `call_api()` function.
 5. **Response Handling:** The AI's response is received, formatted into a visual Markdown panel, and rendered on the screen.
 6. **Memory Update:** The `mem_sys.record_exchange()` function logs the interaction to the local JSON database to inform future context.
    
# IV. Local File System Topology
 * `worm-gpt.py` (Core Engine)
 * `worm-gpt-web-1.py` (Streamlit GUI Payload for Desktop)
 * `worm-gpt-web-2.py` (Gradio GUI Payload for Termux)
 * `requirements.txt` (Dependency Manifest)
 * `wormgpt_config.json` (System state, API keys, models, user profile)
 * `wormgpt_users.json` (SHA-256 Auth Credentials)
 * `system-prompt.txt` (Active Jailbreak/Persona)
 * `/odiyan/` (Isolated Python Virtual Environment)
 * `/modules/` (Directory for `memory.py`, `skills.py`, and Worm Kit scripts)
 * `/mission_logs/` (Directory for exported text logs)
 * `~/.Worm-GPT/memory/` (Directory for persistent memory and mood JSON logs)
