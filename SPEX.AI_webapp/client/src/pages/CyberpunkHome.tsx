import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import ParticlesBackground from "@/components/cyber/Particles";
import Sidebar from "@/components/cyber/Sidebar";
import ChatInterface from "@/components/cyber/ChatInterface";
import UnlockScreen from "@/components/cyber/UnlockScreen";
import SourceViewer from "@/components/cyber/SourceViewer"; 
import { CodeModal, AboutModal } from "@/components/cyber/Modals";
import { ChatSession } from "@/lib/supabaseClient";
import { Source } from "@/components/cyber/MessageBubble"; // Import the type

export default function CyberpunkHome() {
  const [isUnlocked, setIsUnlocked] = useState(false);
  
  const [activeSession, setActiveSession] = useState<ChatSession | null>(null);
  const [resetKey, setResetKey] = useState(0);

  // Mobile Menu State
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Source Dive (Split Screen) State
  // Holds the full source object { url, snippet }
  const [activeSource, setActiveSource] = useState<Source | null>(null);

  // Modal States
  const [aboutOpen, setAboutOpen] = useState(false);
  const [codeModal, setCodeModal] = useState<{ isOpen: boolean; code: string; lang: string }>({
    isOpen: false,
    code: "",
    lang: "javascript"
  });

  const handleStartNewChat = () => {
    setActiveSession(null); 
    setResetKey(prev => prev + 1); 
    setMobileMenuOpen(false);
    setActiveSource(null); // Reset split view
  };

  const handleSelectChat = (chat: ChatSession) => {
    setActiveSession(chat);
    setMobileMenuOpen(false); 
    setActiveSource(null); // Reset split view
  };

  const handleViewCode = (code: string, lang: string) => {
    setCodeModal({ isOpen: true, code, lang });
  };

  return (
    <div className="relative w-full h-[100dvh] overflow-hidden font-body text-cyber-text selection:bg-cyber-secondary selection:text-cyber-bg bg-[#0a0a14]">
      <ParticlesBackground />
      
      {!isUnlocked && <UnlockScreen onUnlock={() => setIsUnlocked(true)} />}

      <motion.div 
        className="flex h-full opacity-0"
        animate={{ opacity: isUnlocked ? 1 : 0 }}
        transition={{ duration: 1 }}
      >
        {/* Mobile Backdrop */}
        <AnimatePresence>
          {mobileMenuOpen && (
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setMobileMenuOpen(false)}
              className="fixed inset-0 bg-black/80 backdrop-blur-sm z-40 md:hidden"
            />
          )}
        </AnimatePresence>

        <Sidebar 
          onResetChat={handleStartNewChat} 
          onOpenAbout={() => setAboutOpen(true)}
          onSelectChat={handleSelectChat}
          currentCollection={activeSession?.collection_name || null}
          isOpen={mobileMenuOpen}
          onClose={() => setMobileMenuOpen(false)}
        />
        
        {/* Main Content Pane */}
        <main className="flex-grow relative flex h-full overflow-hidden bg-gradient-to-b from-transparent to-black/20">
            
            {/* Left Side: Chat Interface */}
            <motion.div 
              className="flex flex-col h-full overflow-hidden min-w-0" // min-w-0 prevents flex item from overflowing
              // Animate width: 100% normally, 50% when source dive is active
              animate={{ width: activeSource ? "50%" : "100%" }}
              transition={{ type: "spring", stiffness: 200, damping: 25 }}
            >
              <ChatInterface 
                  key={activeSession?.id || `new-${resetKey}`}
                  onViewCode={handleViewCode} 
                  initialSession={activeSession}
                  onOpenMobileMenu={() => setMobileMenuOpen(true)}
                  onSourceClick={(source) => setActiveSource(source)} // Pass source object up
              />
            </motion.div>

            {/* Right Side: Source Viewer (Slide-in) */}
            <AnimatePresence>
              {activeSource && (
                <motion.div 
                  initial={{ x: "100%", opacity: 0 }}
                  animate={{ x: 0, opacity: 1 }}
                  exit={{ x: "100%", opacity: 0 }}
                  transition={{ type: "spring", stiffness: 200, damping: 25 }}
                  className="w-1/2 h-full absolute right-0 top-0 bottom-0 z-30 shadow-2xl border-l border-white/5"
                >
                  <SourceViewer 
                    url={activeSource.url} 
                    snippet={activeSource.snippet} // Pass snippet for highlighting
                    onClose={() => setActiveSource(null)} 
                  />
                </motion.div>
              )}
            </AnimatePresence>
        </main>
      </motion.div>

      {/* Modals */}
      <AboutModal 
        isOpen={aboutOpen} 
        onClose={() => setAboutOpen(false)} 
      />
      
      <CodeModal 
        isOpen={codeModal.isOpen} 
        onClose={() => setCodeModal(prev => ({ ...prev, isOpen: false }))} 
        code={codeModal.code}
        lang={codeModal.lang}
      />
    </div>
  );
}