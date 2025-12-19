const API_BASE = "https://webcrawler-h6ag.onrender.com";
let collectionName = null;
let recognition = null;

// Speech Setup
if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  recognition = new SpeechRecognition();
  recognition.continuous = false;
  recognition.interimResults = true;
  recognition.lang = 'en-US'; 

  recognition.onstart = () => { document.getElementById("micBtn").classList.add("listening"); setStatus("LISTENING...", true); };
  recognition.onresult = (e) => { document.getElementById("questionInput").value = e.results[0][0].transcript; };
  recognition.onend = () => { document.getElementById("micBtn").classList.remove("listening"); setStatus("SYSTEM OPTIMAL", false); };
}

async function syncTabUrl() {
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  if (tab?.url && tab.url.startsWith("http")) {
    document.getElementById("urlInput").value = tab.url;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  syncTabUrl();
  document.getElementById("micBtn").addEventListener("click", () => recognition?.start());
});

function fillAndSend(text) {
  document.getElementById("questionInput").value = text;
  handleChat();
}

document.getElementById("indexBtn").addEventListener("click", async () => {
  const btn = document.getElementById("indexBtn");
  const overlay = document.getElementById("indexingOverlay");
  const url = document.getElementById("urlInput").value;

  btn.disabled = true;
  overlay.style.display = "flex";
  setStatus("MAPPING...", true);

  try {
    const res = await fetch(`${API_BASE}/crawl`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ url, max_pages: 5, max_depth: 2 })
    });
    const data = await res.json();
    collectionName = data.collection_name;

    // Render Suggested Questions
    const sugBox = document.getElementById('suggestedQuestions');
    sugBox.innerHTML = "";
    if (data.suggested_questions && data.suggested_questions.length > 0) {
      sugBox.style.display = "flex";
      data.suggested_questions.forEach(q => {
        const chip = document.createElement('div');
        chip.className = 'chip';
        chip.innerText = q;
        chip.onclick = () => fillAndSend(q);
        sugBox.appendChild(chip);
      });
    }

    overlay.style.display = "none";
    addMessage("assistant", `Neural Mapping Complete. Node: ${collectionName}`);
    setStatus("OPTIMAL", false);
  } catch (err) { overlay.style.display = "none"; } finally { btn.disabled = false; }
});

document.getElementById("sendBtn").addEventListener("click", handleChat);
document.getElementById("questionInput").addEventListener("keypress", (e) => e.key === 'Enter' && handleChat());

async function handleChat() {
  const input = document.getElementById("questionInput");
  const question = input.value.trim();
  if (!question || !collectionName) return;

  addMessage("user", question);
  input.value = "";

  try {
    const res = await fetch(`${API_BASE}/chat`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question, collection_name: collectionName })
    });
    const data = await res.json();
    addMessage("assistant", data.answer, data.sources || []);
  } catch (err) { addMessage("assistant", "CONNECTION_ERROR"); }
}

function addMessage(role, content, sources = []) {
  const box = document.getElementById("chatBox");
  const msgDiv = document.createElement("div");
  msgDiv.className = `msg ${role === 'user' ? 'user' : 'ai'}`;
  msgDiv.innerText = content;
  box.appendChild(msgDiv);
  box.scrollTop = box.scrollHeight;
}

function setStatus(text, active) {
  document.getElementById("status-text").innerText = text;
  document.getElementById("system-status").style.borderColor = active ? "var(--spex-yellow)" : "rgba(255,255,255,0.1)";
}