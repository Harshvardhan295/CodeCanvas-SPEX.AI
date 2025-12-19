import { useState, useEffect } from "react";
import { 
  Terminal, 
  Database, 
  PlusCircle, 
  ChevronRight, 
  ChevronLeft,
  MessageSquare, 
  HelpCircle,
  X 
} from "lucide-react";
import { supabase, ChatSession } from "@/lib/supabaseClient";

interface SidebarProps {
  onResetChat: () => void;
  onOpenAbout: () => void;
  onSelectChat: (chat: ChatSession) => void;
  currentCollection: string | null;
  isOpen: boolean;    // New prop for mobile state
  onClose: () => void; // New prop for mobile close
}

const Sidebar = ({ onResetChat, onOpenAbout, onSelectChat, currentCollection, isOpen, onClose }: SidebarProps) => {
  const [history, setHistory] = useState<ChatSession[]>([]);
  const [loading, setLoading] = useState(true);
  const [isCollapsed, setIsCollapsed] = useState(false);

  // Fetch chat history from Supabase
  useEffect(() => {
    const fetchHistory = async () => {
      const { data, error } = await supabase
        .from('chats')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (!error && data) {
        setHistory(data);
      }
      setLoading(false);
    };

    fetchHistory();
    
    // Real-time subscription to update list when new chats are added
    const channel = supabase
      .channel('public:chats')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'chats' }, () => {
        fetchHistory();
      })
      .subscribe();

    return () => { supabase.removeChannel(channel) };
  }, []);

  return (
    <aside 
      className={`
        fixed inset-y-0 left-0 z-50 h-full bg-[#050508] md:bg-black/40 backdrop-blur-xl md:backdrop-blur-md border-r border-white/10 flex flex-col transition-all duration-300 ease-in-out
        ${isOpen ? 'translate-x-0' : '-translate-x-full'} md:translate-x-0 md:relative
        ${isCollapsed ? 'md:w-20' : 'md:w-64'} w-3/4 sm:w-64
      `}
    >
      {/* Mobile Close Button */}
      <button 
        onClick={onClose}
        className="absolute right-4 top-4 text-white/50 hover:text-white md:hidden"
      >
        <X size={24} />
      </button>

      {/* Desktop Toggle Button */}
      <button
        onClick={() => setIsCollapsed(!isCollapsed)}
        className="hidden md:flex absolute -right-3 top-8 z-50 bg-[#050508] border border-white/20 text-spex-cyan hover:text-black hover:bg-spex-cyan p-1 rounded-full shadow-lg transition-all duration-300"
      >
        {isCollapsed ? <ChevronRight size={14} /> : <ChevronLeft size={14} />}
      </button>

      {/* Header */}
      <div className={`p-6 border-b border-white/10 flex items-center ${isCollapsed ? 'justify-center' : ''}`}>
        <div className="flex items-center gap-3 text-spex-cyan mb-1">
          <Terminal size={24} className="shrink-0" />
          {(!isCollapsed || isOpen) && (
            <span className="font-display font-bold text-xl tracking-tighter text-white whitespace-nowrap overflow-hidden">
              SPEX<span className="text-spex-yellow">.AI</span>
            </span>
          )}
        </div>
      </div>

      {/* New Chat Button */}
      <div className="p-4">
        <button 
          onClick={onResetChat}
          className={`w-full flex items-center gap-2 bg-spex-cyan/10 hover:bg-spex-cyan/20 border border-spex-cyan/30 text-spex-cyan py-3 rounded-lg transition-all duration-300 group ${isCollapsed ? 'md:justify-center md:px-0' : 'justify-center px-4'}`}
          title="Create New Chatbot"
        >
          <PlusCircle size={16} className="group-hover:rotate-90 transition-transform duration-300 shrink-0" />
          {(!isCollapsed || isOpen) && (
            <span className="font-mono text-xs font-bold uppercase tracking-wider whitespace-nowrap overflow-hidden">
              Create New Chatbot
            </span>
          )}
        </button>
      </div>

      {/* Navigation / History */}
      <div className="flex-1 overflow-y-auto py-2 px-3 space-y-1 scrollbar-thin scrollbar-thumb-white/10 hover:scrollbar-thumb-spex-cyan/30">
        <div className={`py-2 text-[10px] text-white/30 font-mono uppercase tracking-widest flex items-center gap-2 ${isCollapsed ? 'md:justify-center md:px-0' : 'px-3'}`}>
          <Database size={10} />
          {(!isCollapsed || isOpen) && <span>Previous Chatbots</span>}
        </div>

        {loading ? (
           <div className={`py-2 text-xs text-white/30 font-mono animate-pulse ${isCollapsed ? 'md:text-center' : 'px-4'}`}>
             {isCollapsed ? '...' : 'Scanning database...'}
           </div>
        ) : history.map((chat) => (
          <button
            key={chat.id}
            onClick={() => onSelectChat(chat)}
            className={`w-full text-left group flex items-center gap-3 py-3 rounded-md transition-all duration-200 border ${
              currentCollection === chat.collection_name 
                ? "bg-white/10 border-spex-yellow/50 text-white" 
                : "hover:bg-white/5 border-transparent text-white/60 hover:text-white"
            } ${isCollapsed ? 'md:justify-center md:px-0' : 'px-3'}`}
            title={chat.domain_url}
          >
            <MessageSquare size={14} className={`shrink-0 ${currentCollection === chat.collection_name ? "text-spex-yellow" : "text-white/30 group-hover:text-spex-cyan"}`} />
            
            {(!isCollapsed || isOpen) && (
              <div className="flex-1 min-w-0">
                <div className="text-xs font-mono truncate">{chat.domain_url.replace('https://', '').replace('http://', '').replace('www.', '')}</div>
                <div className="text-[10px] text-white/30 truncate">
                  {new Date(chat.created_at).toLocaleDateString()}
                </div>
              </div>
            )}
            
            {(!isCollapsed || isOpen) && currentCollection === chat.collection_name && <ChevronRight size={12} className="text-spex-yellow shrink-0" />}
          </button>
        ))}
      </div>

      {/* Footer */}
      <div className={`border-t border-white/10 bg-black/20 ${isCollapsed ? 'md:p-4 md:flex md:justify-center' : 'p-4'}`}>
        <div 
          className="flex items-center gap-3 text-white/40 hover:text-white transition-colors cursor-pointer text-xs font-mono" 
          onClick={onOpenAbout}
          title="About us"
        >
           <HelpCircle className="w-5 h-5 shrink-0" />
           {(!isCollapsed || isOpen) && <span>About us</span>}
        </div>
      </div>
    </aside>
  );
};

export default Sidebar;