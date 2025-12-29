import streamlit as st
import json
import os
import requests
from datetime import datetime

# --- CONFIGURATION & PATHS ---
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_FILE = os.path.join(BASE_DIR, "wormgpt_config.json")
PROMPT_RUDE = os.path.join(BASE_DIR, "system-prompt-1.txt")
PROMPT_POLITE = os.path.join(BASE_DIR, "system-prompt-2.txt")
LOG_DIR = os.path.join(BASE_DIR, "mission_logs")

# Page Config
st.set_page_config(
    page_title="WormGPT v3.3 // GUI",
    page_icon="👾",
    layout="wide",
    initial_sidebar_state="expanded"
)

# --- CUSTOM HACKER CSS ---
st.markdown("""
    <style>
    /* Main Background */
    .stApp { background-color: #050505; color: #00ff41; font-family: 'Courier New', monospace; }
    
    /* Sidebar */
    [data-testid="stSidebar"] { background-color: #000000; border-right: 1px solid #333; }
    
    /* Input Fields */
    .stTextInput > div > div > input { color: #00ff41; background-color: #111; border: 1px solid #444; }
    .stSelectbox > div > div > div { color: #00ff41; background-color: #111; }
    
    /* Headers */
    h1, h2, h3 { color: #ff0000 !important; text-shadow: 0px 0px 8px #ff0000; }
    
    /* Chat Messages */
    .stChatMessage { background-color: #0a0a0a; border: 1px solid #333; }
    [data-testid="stChatMessageContent"] { color: #ddd; }
    
    /* Buttons */
    .stButton > button { color: #000; background-color: #00ff41; border: none; font-weight: bold; width: 100%; }
    .stButton > button:hover { background-color: #00cc33; box-shadow: 0px 0px 10px #00ff41; }
    
    /* Expander for Upload */
    .streamlit-expanderHeader { background-color: #111; color: #00ff41 !important; border: 1px solid #333; }
    [data-testid="stFileUploader"] { padding: 10px; }
    
    /* Spinner */
    .stSpinner > div { border-top-color: #ff0000 !important; }
    </style>
    """, unsafe_allow_html=True)

# --- LOGIC FUNCTIONS ---
def load_config():
    default_config = {
        "api_keys": [],
        "active_key_index": 0,
        "models": ["kwaipilot/kat-coder-pro:free","nex-agi/deepseek-v3.1-nex-n1:free","qwen/qwen3-coder:free","google/gemini-2.0-flash-exp:free","mistralai/mistral-7b-instruct:free"],
        "active_model_index": 0,
        "max_tokens": 32000,
        "base_url": "https://openrouter.ai/api/v1"
    }
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                loaded = json.load(f)
                if "models" not in loaded or not loaded["models"]: loaded["models"] = default_config["models"]
                return loaded
        except: return default_config
    return default_config

def save_config(config):
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)

def load_system_prompt(mode):
    path = PROMPT_RUDE if mode == "Rude (WormGPT)" else PROMPT_POLITE
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return f.read().strip()
    return "You are WormGPT."

def save_log(user_text, ai_text):
    if not os.path.exists(LOG_DIR): os.makedirs(LOG_DIR)
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    filename = os.path.join(LOG_DIR, f"log_{timestamp}.txt")
    with open(filename, "w", encoding="utf-8") as f:
        f.write(f"USER: {user_text}\n\nAI: {ai_text}")

# --- SIDEBAR ---
with st.sidebar:
    st.markdown("## SYSTEM CONTROL")
    config = load_config()
    
    # API Keys
    st.markdown("### 🔑 Access Keys")
    api_keys = config.get("api_keys", [])
    key_options = [f"Key #{i+1} ({k[:6]}...)" for i, k in enumerate(api_keys)] if api_keys else ["No Keys Found"]
    selected_key_idx = st.selectbox("Active Key", range(len(api_keys)) if api_keys else [0], format_func=lambda x: key_options[x] if api_keys else "No Keys", index=config.get("active_key_index", 0))
    
    with st.expander("➕ Add New Key"):
        new_key = st.text_input("Enter API Key", type="password")
        if st.button("Save Key"):
            if new_key:
                config["api_keys"].append(new_key)
                save_config(config)
                st.rerun()

    # Models
    st.markdown("### 🧠 Neural Model")
    models = config.get("models", ["Default"])
    saved_idx = config.get("active_model_index", 0)
    if saved_idx >= len(models): saved_idx = 0
    selected_model_idx = st.selectbox("Select Model", range(len(models)), format_func=lambda x: models[x], index=saved_idx)
    
    if selected_model_idx != config.get("active_model_index"):
        config["active_model_index"] = selected_model_idx
        save_config(config)

    # Persona
    st.markdown("### 🎭 Mode")
    persona_mode = st.radio("Persona", ["Rude (WormGPT)", "Polite (Assistant)"], label_visibility="collapsed")
    
    if st.button("🗑️ FLUSH RAM"):
        st.session_state.messages = []
        st.rerun()

# --- MAIN CHAT ---
st.title("WORM-GPT // GUI V3.3")
active_model_name = models[selected_model_idx] if models else "UNKNOWN"
st.caption(f"⚡ NETLINK: ACTIVE | 🎯 TARGET: `{active_model_name}`")

if "messages" not in st.session_state:
    st.session_state.messages = []

# Display Chat History
for message in st.session_state.messages:
    if message["role"] != "system":
        role_style = "🗣️" if message["role"] == "user" else "👾"
        with st.chat_message(message["role"], avatar=role_style):
            st.markdown(message["content"])

# --- ATTACHMENT AREA (Right above Input) ---
# We use a dynamic key based on message count to auto-reset the uploader after sending!
upload_key = f"uploader_{len(st.session_state.messages)}"
with st.expander("📎 ATTACH FILE", expanded=False):
    uploaded_file = st.file_uploader("Select File", type=['txt', 'py', 'json', 'sh', 'md', 'html'], key=upload_key)

# Chat Input
if prompt := st.chat_input("Enter command..."):
    
    full_prompt = prompt
    display_prompt = prompt
    
    # Handle File
    if uploaded_file is not None:
        try:
            file_bytes = uploaded_file.getvalue()
            file_text = file_bytes.decode("utf-8")
            file_context = f"\n\n--- [BEGIN UPLOADED FILE: {uploaded_file.name}] ---\n{file_text}\n--- [END UPLOADED FILE] ---\n"
            full_prompt = prompt + file_context
            display_prompt = f"{prompt} `[+ Attached: {uploaded_file.name}]`"
        except Exception as e:
            st.error(f"Read Error: {e}")

    # UI Update
    st.chat_message("user", avatar="🗣️").write(display_prompt)
    
    # API Prep
    system_prompt = load_system_prompt(persona_mode)
    api_messages = [{"role": "system", "content": system_prompt}]
    for msg in st.session_state.messages[-10:]: api_messages.append(msg)
    api_messages.append({"role": "user", "content": full_prompt})
    
    active_key = api_keys[selected_key_idx] if api_keys else None
    
    if active_key:
        with st.chat_message("assistant", avatar="👾"):
            with st.spinner("⚡ Awaiting Response..."):
                try:
                    headers = {
                        "Authorization": f"Bearer {active_key}",
                        "HTTP-Referer": "http://localhost:8501",
                        "X-Title": "WormGPT GUI",
                        "Content-Type": "application/json"
                    }
                    data = {
                        "model": active_model_name,
                        "messages": api_messages,
                        "max_tokens": config.get("max_tokens", 32000),
                        "temperature": 0.7
                    }
                    response = requests.post(f"{config['base_url']}/chat/completions", headers=headers, json=data)
                    
                    if response.status_code == 200:
                        result = response.json()['choices'][0]['message']['content']
                        st.markdown(result)
                        st.session_state.messages.append({"role": "user", "content": display_prompt})
                        st.session_state.messages.append({"role": "assistant", "content": result})
                        save_log(full_prompt, result)
                        # Rerun to clear the uploader (because key changes on new message)
                        st.rerun() 
                    else:
                        st.error(f"API Error: {response.text}")
                except Exception as e:
                    st.error(f"Connection Failed: {str(e)}")
    else:
        st.error("❌ NO API KEY FOUND")
  
