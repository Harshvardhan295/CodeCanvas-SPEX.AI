import { useState, useEffect } from "react";
import { X, ExternalLink, Loader2, Globe, ShieldAlert, Target } from "lucide-react";

interface SourceViewerProps {
  url: string;
  snippet?: string; // The exact text to highlight
  onClose: () => void;
}

export default function SourceViewer({ url, snippet, onClose }: SourceViewerProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);

  // Construct the Text Fragment URL
  // Format: https://site.com/page#:~:text=exact%20text
  const getFragmentUrl = () => {
    if (!snippet) return url;

    // Clean the snippet: remove extra spaces/newlines that might break matching
    const cleanSnippet = snippet.trim().replace(/\s+/g, ' ');
    const encodedSnippet = encodeURIComponent(cleanSnippet);
    
    // Check if URL already has a fragment (hash)
    const separator = url.includes('#') ? '' : '#';
    return `${url}${separator}:~:text=${encodedSnippet}`;
  };

  const finalUrl = getFragmentUrl();

  useEffect(() => {
    setIsLoading(true);
    setLoadError(false);
  }, [url, snippet]);

  return (
    <div className="h-full flex flex-col bg-[#050508] border-l border-spex-cyan/20 shadow-[0_0_50px_rgba(0,0,0,0.7)] z-50 overflow-hidden relative">
      {/* HUD Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-white/5 bg-black/80 backdrop-blur-md">
        <div className="flex items-center gap-3 overflow-hidden">
          <div className="flex items-center gap-2 text-spex-yellow ">
            <Target size={14} />
            <span className="text-[10px] font-mono font-bold tracking-[0.2em] uppercase whitespace-nowrap">
              Source Reference
            </span>
          </div>
          <div className="h-4 w-[1px] bg-white/10" />
          
        </div>
        
        <button 
          onClick={onClose} 
          className="p-1.5 text-white/50 hover:text-red-400 hover:bg-white/5 rounded-md transition-all group"
        >
          <X size={18} className="group-hover:rotate-90 transition-transform" />
        </button>
      </div>

      {/* URL Bar */}
      <div className="px-4 py-2 bg-white/5 border-b border-white/5 flex items-center gap-2">
        <Globe size={12} className="text-spex-cyan" />
        <span className="text-[11px] text-spex-cyan/70 font-mono truncate flex-1 opacity-70 hover:opacity-100 transition-opacity">
          {url}
        </span>
        <a 
          href={finalUrl} 
          target="_blank" 
          rel="noreferrer" 
          className="text-white/30 hover:text-white transition-colors"
          title="Open in new tab"
        >
          <ExternalLink size={12} />
        </a>
      </div>

      {/* Content */}
      <div className="flex-1 relative bg-white">
        {isLoading && (
          <div className="absolute inset-0 flex flex-col items-center justify-center bg-[#0a0a14] z-10">
            <div className="relative">
              <Loader2 className="w-10 h-10 text-spex-cyan animate-spin" />
              <div className="absolute inset-0 blur-xl bg-spex-cyan/20 animate-pulse" />
            </div>
            <span className="text-[10px] text-spex-cyan font-mono tracking-widest uppercase mt-4">
              Injecting Neural Overlay...
            </span>
          </div>
        )}

        {loadError ? (
          <div className="absolute inset-0 flex flex-col items-center justify-center bg-[#0a0a14] p-8 text-center">
            <ShieldAlert className="w-16 h-16 text-spex-yellow/50 mb-4" />
            <h3 className="text-white font-display text-xl mb-2">Secure Connection Failed</h3>
            <p className="text-white/40 text-sm mb-6 font-body max-w-xs mx-auto">
              This source blocks embedded viewing (X-Frame-Options). Use the direct link below to view the highlighted content.
            </p>
            <a 
              href={finalUrl} 
              target="_blank" 
              className="px-6 py-3 bg-spex-yellow text-black rounded-lg text-xs font-mono font-bold uppercase hover:bg-spex-yellow/80 transition-all flex items-center gap-2 mx-auto"
            >
              <span>Open External Source</span>
              <ExternalLink size={12} />
            </a>
          </div>
        ) : (
          <iframe
            src={finalUrl}
            className="w-full h-full border-0"
            onLoad={() => setIsLoading(false)}
            onError={() => { setIsLoading(false); setLoadError(true); }}
            sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
          />
        )}
      </div>
    </div>
  );
}