# SPEX.AI: The RAG Intelligence Engine

![SPEX.AI Banner](https://img.shields.io/badge/Status-Active-success)
![License](https://img.shields.io/badge/License-MIT-blue)
![Tech Stack](https://img.shields.io/badge/Stack-React%20|%20Flutter%20|%20Python%20|%20FastAPI-blueviolet)

**SPEX.AI** is a next-generation Retrieval-Augmented Generation (RAG) ecosystem designed to bridge the trust gap in AI. It allows users to index any website and chat with its content using a "Source Dive" verification mode, ensuring every answer is grounded in reality.

The ecosystem consists of four interconnected components:
1.  **Web Application** (Cyberpunk-themed React Frontend)
2.  **Mobile Application** (Cross-platform Flutter App)
3.  **Chrome Extension** (Browser Companion)
4.  **Neural Crawler** (Python/FastAPI Backend)

---

## 🌟 Key Features

### 1. 🌐 SPEX.AI Web Application
A futuristic, high-fidelity chat interface built for desktop and mobile.

* **Source Dive Mode (Split-Screen Verification)**: When the AI answers, click a citation to open a split-view overlay. The original source website loads on the right, automatically scrolling to and highlighting the *exact paragraph* used to generate the answer.
* **Voice Command Center**: Hands-free interaction using the Web Speech API. Speak your queries, and the system listens and transcribes in real-time.
* **Neural Crawling**: Input any URL to map its knowledge base. The system returns crawled pages and **Suggested Questions** to help you explore the content instantly.
* **Cyberpunk UI**: A fully immersive interface with glassmorphism, particle effects, and neon accents (`spex-cyan` & `spex-yellow`).

### 2. 📱 SPEX.AI Mobile App
A powerful Flutter-based application bringing the intelligence engine to iOS and Android.

* **Cross-Platform**: Runs seamlessly on Android, iOS, Web, Windows, and macOS.
* **Chat History**: Persist your conversations locally.
* **Unified Design**: Maintains the core Cyberpunk aesthetic of the web platform.

### 3. 🧩 Chrome Extension
A lightweight browser companion.

* **Quick Access**: Instant access to the chat interface without leaving your current tab.
* **Context Awareness**: (Planned) Analyze the current tab's content directly.

---

## 🎥 Demos

### 🖥️ Web Application Demo
> Experience the Source Dive and Voice Command features in action.

[INSERT WEBAPP DEMO VIDEO HERE]

<br>

### 📱 Mobile Application Demo
> See the cross-platform Flutter experience.

[INSERT MOBILE APP DEMO VIDEO HERE]

<br>

### 🧩 Chrome Extension Demo
> Quick access workflow.

[INSERT EXTENSION DEMO VIDEO HERE]

---

## 🛠️ Technology Stack

| Component | Tech Stack |
| :--- | :--- |
| **Frontend (Web)** | React (Vite), TypeScript, Tailwind CSS, Framer Motion, Lucide React, Radix UI |
| **Mobile App** | Flutter, Dart, Riverpod (State Management) |
| **Backend (Crawler)** | Python, FastAPI/Flask, BeautifulSoup4, Jina.ai, LangChain (implied) |
| **Database** | Supabase (PostgreSQL), Drizzle ORM |
| **Extension** | HTML5, CSS3, JavaScript (Manifest V3) |

---

## 🚀 Installation & Setup

### Prerequisites
* Node.js & npm
* Python 3.9+
* Flutter SDK
* Supabase Account

### 1. Setting up the Backend (Crawler)
The backend handles URL crawling and vector embeddings.

```bash
cd webcrawler
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn main:app --reload
# The backend runs on http://localhost:8000 (or the render URL provided in config)
