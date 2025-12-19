import { motion } from "framer-motion";
import { Bot, User, Link as LinkIcon, ExternalLink } from "lucide-react";

// Define the shape of a Source object
export interface Source {
  url: string;
  snippet?: string; // The specific paragraph text
  title?: string;
}

interface MessageBubbleProps {
  role: 'user' | 'assistant';
  content: string;
  sources?: (string | Source)[]; // Support both legacy string URLs and new Source objects
  onSourceClick?: (source: Source) => void;
}

export const MessageBubble = ({ role, content, sources, onSourceClick }: MessageBubbleProps) => {
  const isBot = role === 'assistant';

  const formatSourceUrl = (url: string) => {
    try {
      const { hostname } = new URL(url);
      return hostname.replace('www.', '');
    } catch (e) {
      return "Source Link";
    }
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className={`flex ${isBot ? 'justify-start' : 'justify-end'} w-full group`}
    >
      <div className={`flex gap-4 max-w-[85%] ${isBot ? 'flex-row' : 'flex-row-reverse'}`}>
        
        {/* Avatar */}
        <div className={`shrink-0 w-8 h-8 rounded-full flex items-center justify-center border ${
          isBot 
          ? 'bg-spex-yellow/10 border-spex-yellow/30 text-spex-yellow' 
          : 'bg-spex-cyan/10 border-spex-cyan/30 text-spex-cyan'
        }`}>
          {isBot ? <Bot size={16} /> : <User size={16} />}
        </div>

        {/* Bubble Content */}
        <div className={`relative p-5 rounded-2xl border backdrop-blur-sm shadow-lg transition-all duration-300 ${
          isBot 
          ? 'bg-[#11111a]/80 border-white/5 rounded-tl-none hover:border-spex-yellow/30' 
          : 'bg-white/5 border-white/10 rounded-tr-none hover:border-spex-cyan/30'
        }`}>
          <div className="text-base font-medium leading-relaxed text-gray-200 tracking-wide whitespace-pre-wrap font-body">
            {content}
          </div>
          
          {/* Source Citations */}
          {isBot && sources && sources.length > 0 && (
            <div className="mt-4 pt-3 border-t border-white/5">
              <div className="flex items-center gap-2 mb-2">
                <LinkIcon size={12} className="text-spex-yellow" />
                <span className="text-[10px] font-mono uppercase text-spex-yellow/70 tracking-wider">Verified Sources</span>
              </div>
              <div className="flex flex-wrap gap-2">
                {sources.map((s, idx) => {
                  // Normalize source to object if it's just a string
                  const sourceObj: Source = typeof s === 'string' ? { url: s } : s;
                  
                  return (
                    <button 
                      key={idx}
                      onClick={(e) => {
                        e.preventDefault();
                        if (onSourceClick) onSourceClick(sourceObj);
                      }}
                      className="flex items-center gap-1.5 px-2 py-1 rounded-md bg-white/5 hover:bg-spex-yellow/10 border border-white/5 hover:border-spex-yellow/30 transition-all text-[10px] text-gray-400 hover:text-spex-yellow cursor-pointer group/link"
                    >
                      <span className="truncate max-w-[150px]">{formatSourceUrl(sourceObj.url)}</span>
                      <ExternalLink size={8} className="opacity-50 group-hover/link:opacity-100" />
                    </button>
                  );
                })}
              </div>
            </div>
          )}
          
          {/* Footer Metadata */}
          <div className={`absolute -bottom-5 ${isBot ? 'left-0' : 'right-0'} opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center gap-1.5`}>
            <span className={`text-[9px] uppercase font-bold tracking-wider ${isBot ? 'text-spex-yellow' : 'text-spex-cyan'}`}>
              {isBot ? "SPEX.AI" : "USER"}
            </span>
            <span className="text-[9px] text-white/20">|</span>
            <span className="text-[9px] text-white/40">{new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
          </div>
        </div>
      </div>
    </motion.div>
  );
};