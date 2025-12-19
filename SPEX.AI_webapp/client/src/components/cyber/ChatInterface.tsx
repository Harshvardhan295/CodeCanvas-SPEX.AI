import { useState, useRef, useEffect } from "react";
import { MessageBubble, Source } from "./MessageBubble";
import { TypingArea } from "./TypingArea";
import { motion, AnimatePresence } from "framer-motion";
import { Activity, Cpu, ArrowRight, Menu, Mic, Sparkles } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { supabase, ChatSession } from "@/lib/supabaseClient";

// Ensure this matches your actual backend URL
const BACKEND_URL = "https://webcrawler-h6ag.onrender.com";

interface ChatInterfaceProps {
  onViewCode: (code: string, lang: string) => void;
  initialSession: ChatSession | null;
  onOpenMobileMenu: () => void;
  onSourceClick: (source: Source) => void;
}

type ChatMode = 'URL_INPUT' | 'CRAWLING' | 'CHATTING';

const ChatInterface = ({ onViewCode, initialSession, onOpenMobileMenu, onSourceClick }: ChatInterfaceProps) => {
  const [mode, setMode] = useState<ChatMode>(initialSession ? 'CHATTING' : 'URL_INPUT');
  const [messages, setMessages] = useState<any[]>(
    initialSession 
      ? initialSession.messages 
      : [{ role: 'assistant', content: 'System initialized. Enter target domain URL to begin neural mapping.' }]
  );
  
  const [collectionName, setCollectionName] = useState(initialSession?.collection_name || "");
  const [targetUrl, setTargetUrl] = useState(initialSession?.domain_url || "");
  const [isTyping, setIsTyping] = useState(false);
  const [isVoiceActive, setIsVoiceActive] = useState(false);
  
  // NEW: State to store suggested questions from the crawler
  const [suggestions, setSuggestions] = useState<string[]>([]);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const { toast } = useToast();

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTo({
        top: scrollRef.current.scrollHeight,
        behavior: 'smooth'
      });
    }
  }, [messages, isTyping, mode, suggestions]); // Added suggestions to dependency to ensure scroll on new suggestions

  const saveToSupabase = async (cName: string, url: string, msgs: any[]) => {
    try {
      await supabase.from('chats').upsert({
        collection_name: cName,
        domain_url: url,
        messages: msgs
      }, { onConflict: 'collection_name' });
    } catch (e) {
      console.error("Save failed", e);
    }
  };

  const handleUrlSubmit = async () => {
    if (!targetUrl.trim()) return;
    
    const userMsg = { role: 'user', content: targetUrl };
    setMessages(prev => [...prev, userMsg]);
    setMode('CRAWLING');

    try {
      const response = await fetch(`${BACKEND_URL}/crawl`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          url: targetUrl,
          max_depth: 2,
          max_pages: 10
        })
      });

      if (!response.ok) throw new Error("Backend connection failed");

      const data = await response.json();
      
      const crawledPagesList = data.crawled_urls.map((url: string) => url).join('\n');
      const successMessage = `We have crawled and indexed ${targetUrl} and these are the pages which we have crawled:\n\n${crawledPagesList}\n\nNow, you can ask anything from these webpages...`;

      const assistantMsg = { role: 'assistant', content: successMessage };
      const newMessages = [...messages, userMsg, assistantMsg];

      // NEW: Update suggestions state with data from backend
      if (data.suggested_questions && Array.isArray(data.suggested_questions)) {
        setSuggestions(data.suggested_questions);
      }

      setCollectionName(data.collection_name);
      setMessages(newMessages);
      setMode('CHATTING');

      await saveToSupabase(data.collection_name, targetUrl, newMessages);

    } catch (error) {
      console.error(error);
      setMessages(prev => [...prev, { role: 'assistant', content: "Error: Could not crawl the target. Please verify the URL and try again." }]);
      setMode('URL_INPUT'); 
    }
  };

  const handleChatSubmit = async (text: string) => {
    if (!text.trim()) return;

    const userMsg = { role: 'user', content: text };
    const updatedMessages = [...messages, userMsg];
    setMessages(updatedMessages);
    setIsTyping(true);

    try {
      const response = await fetch(`${BACKEND_URL}/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          collection_name: collectionName,
          question: text,
          history: messages 
        })
      });

      if (!response.ok) throw new Error("Chat failed");

      const data = await response.json();
      
      const assistantMsg = { 
        role: 'assistant', 
        content: data.answer,
        sources: data.sources || [] 
      };

      const finalMessages = [...updatedMessages, assistantMsg];
      setMessages(finalMessages);
      
      await saveToSupabase(collectionName, targetUrl, finalMessages);

    } catch (error) {
      console.error(error);
      toast({ title: "Error", description: "Failed to get response from SPEX.", variant: "destructive" });
      setMessages(prev => [...prev, { role: 'assistant', content: "Connection interrupted." }]);
    } finally {
      setIsTyping(false);
    }
  };

  return (
    <div className="flex flex-col h-full w-full max-w-6xl mx-auto px-4 py-4 md:py-6 overflow-hidden">
      
      {/* Header */}
      <motion.div 
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="flex justify-between items-center md:items-end border-b border-white/10 pb-4 mb-4 md:mb-6"
      >
        <div className="flex items-center gap-3">
          <button 
            onClick={onOpenMobileMenu}
            className="md:hidden p-2 -ml-2 text-spex-cyan hover:bg-white/5 rounded-lg transition-colors"
          >
            <Menu size={24} />
          </button>

          <div>
            <h1 className="font-display text-2xl md:text-4xl font-bold tracking-tighter text-white">
              SPEX<span className="text-spex-yellow">.AI</span>
            </h1>
            <p className="text-[10px] md:text-xs text-white/50 tracking-[0.2em] uppercase mt-1 hidden md:block">RAG Intelligence Engine</p>
          </div>
        </div>

        <div className="flex flex-col items-end gap-1">
          <div className={`flex items-center gap-2 md:gap-4 text-[10px] md:text-xs font-mono px-2 py-1 md:px-3 rounded-full border transition-all duration-300 ${
            isVoiceActive 
              ? 'text-black bg-spex-cyan border-spex-cyan shadow-[0_0_10px_rgba(0,240,255,0.4)]' 
              : 'text-spex-cyan/80 bg-spex-cyan/5 border-spex-cyan/20'
          }`}>
             {isVoiceActive ? <Mic size={12} className="animate-pulse" /> : <Activity size={12} className="animate-pulse" />}
             <span className="uppercase font-bold tracking-wider">
               {isVoiceActive ? 'VOICE LINK ACTIVE' : (mode === 'CHATTING' ? 'OPTIMAL' : 'READY')}
             </span>
          </div>
          <span className="text-[10px] font-mono text-white/30 uppercase max-w-[120px] truncate">TARGET: {targetUrl ? new URL(targetUrl).hostname : "NONE"}</span>
        </div>
      </motion.div>

      {/* Messages Area */}
      <div 
        ref={scrollRef}
        className="flex-1 overflow-y-auto mb-4 md:mb-6 pr-2 md:pr-4 space-y-4 md:space-y-6 scrollbar-thin scrollbar-thumb-white/10"
      >
        <AnimatePresence mode="popLayout">
          {messages.map((msg, index) => (
            <MessageBubble 
              key={index} 
              role={msg.role} 
              content={msg.content} 
              sources={msg.sources} 
              onSourceClick={onSourceClick} 
            />
          ))}
          
          {mode === 'CRAWLING' && (
            <motion.div 
              initial={{ opacity: 0 }} animate={{ opacity: 1 }}
              className="flex flex-col items-center justify-center p-8 space-y-4 border border-spex-cyan/30 bg-spex-cyan/5 rounded-xl my-4"
            >
              <div className="relative w-16 h-16">
                 <div className="absolute inset-0 border-4 border-t-spex-cyan border-r-transparent border-b-spex-cyan border-l-transparent rounded-full animate-spin"></div>
              </div>
              <div className="text-center">
                 <h3 className="text-spex-cyan font-mono text-sm tracking-widest uppercase">Extracting Vector Data</h3>
                 <p className="text-white/40 text-xs font-mono mt-1">Crawling {targetUrl}...</p>
              </div>
            </motion.div>
          )}

          {isTyping && (
            <motion.div 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="flex justify-start w-full"
            >
               <div className="flex items-center gap-2 px-4 py-3 rounded-2xl bg-white/5 border border-white/5 text-spex-yellow text-xs font-mono">
                  <Cpu size={14} className="animate-spin-slow" />
                  <span>ANALYZING KNOWLEDGE BASE...</span>
               </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Input Area */}
      <div className="min-h-[80px]">
        {mode === 'URL_INPUT' && (
           <motion.div 
             initial={{ opacity: 0, y: 20 }} 
             animate={{ opacity: 1, y: 0 }} 
             className="spex-glass rounded-2xl p-2 flex gap-2 items-center hover:border-spex-cyan/50 hover:shadow-[0_0_15px_rgba(0,240,255,0.15)] transition-all duration-300 group"
           >
              <input 
                type="url"
                value={targetUrl}
                onChange={(e) => setTargetUrl(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleUrlSubmit()}
                placeholder="https://example.com"
                className="flex-1 text-white font-mono text-sm md:text-base font-medium focus:ring-0 placeholder:text-white/50 h-10 min-w-0"
              />
              <button 
                onClick={handleUrlSubmit}
                className="bg-spex-cyan text-black px-4 md:px-6 py-2 rounded-xl font-bold text-xs uppercase hover:bg-spex-cyan/80 transition-colors flex items-center gap-2 shrink-0"
              >
                Index <ArrowRight size={14} className="hidden md:block" />
              </button>
           </motion.div>
        )}

        {mode === 'CRAWLING' && (
           <div className="w-full h-14 border border-white/5 bg-white/5 rounded-2xl flex items-center justify-center text-white/20 text-xs font-mono uppercase tracking-widest cursor-not-allowed">
             Processing Data Stream...
           </div>
        )}

        {mode === 'CHATTING' && (
          <div className="w-full flex flex-col gap-3">
            {/* Suggested Questions Section */}
            {suggestions.length > 0 && (
              <motion.div 
                initial={{ opacity: 0, y: 5 }}
                animate={{ opacity: 1, y: 0 }}
                className="flex flex-wrap gap-2 px-1"
              >
                {suggestions.map((suggestion, idx) => (
                  <button
                    key={idx}
                    onClick={() => {
                      if (!isTyping) handleChatSubmit(suggestion);
                    }}
                    disabled={isTyping}
                    className={`
                      flex items-center gap-2 px-3 py-1.5 rounded-full text-[10px] md:text-xs font-mono border transition-all duration-200
                      ${isTyping 
                        ? 'opacity-40 cursor-not-allowed border-white/5 text-white/30' 
                        : 'border-spex-cyan/30 text-spex-cyan bg-spex-cyan/5 hover:bg-spex-cyan/15 hover:border-spex-cyan/60 hover:shadow-[0_0_10px_rgba(0,240,255,0.15)]'
                      }
                    `}
                  >
                    <Sparkles size={10} className={isTyping ? "opacity-30" : "opacity-70"} />
                    <span className="truncate max-w-[200px] md:max-w-xs">{suggestion}</span>
                  </button>
                ))}
              </motion.div>
            )}

            <div className={`spex-glass !border-transparent rounded-2xl p-1.5 transition-all duration-300 ${isVoiceActive ? '!border-spex-cyan/50 shadow-[0_0_20px_rgba(0,240,255,0.15)]' : 'hover:border-spex-yellow hover:shadow-[0_0_20px_rgba(252,238,10,0.4)]'}`}>
              <TypingArea 
                onSend={handleChatSubmit} 
                isLoading={isTyping} 
                onListeningStateChange={setIsVoiceActive}
              />
            </div>
          </div>
        )}
      </div>
      
      <div className="flex justify-center items-center gap-2 mt-3 text-[8px] md:text-[10px] text-white/30 uppercase tracking-widest">
        <span className={`w-1 h-1 rounded-full ${mode === 'CHATTING' ? 'bg-spex-green' : 'bg-spex-yellow'} animate-pulse`} />
        {mode === 'CHATTING' ? 'Encrypted Connection Active' : 'System Standby'}
      </div>
    </div>
  );
};

export default ChatInterface;