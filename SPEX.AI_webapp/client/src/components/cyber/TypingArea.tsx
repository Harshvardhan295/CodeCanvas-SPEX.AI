import { Send, ArrowRight, Mic, MicOff, Zap } from "lucide-react";
import { useState, useEffect, useRef } from "react";

// Extend window interface for Web Speech API support
declare global {
  interface Window {
    SpeechRecognition: any;
    webkitSpeechRecognition: any;
  }
}

interface TypingAreaProps {
  onSend: (text: string) => void;
  isLoading?: boolean;
  onListeningStateChange?: (isListening: boolean) => void;
}

export const TypingArea = ({ onSend, isLoading, onListeningStateChange }: TypingAreaProps) => {
  const [inputValue, setInputValue] = useState("");
  const [isListening, setIsListening] = useState(false);
  const recognitionRef = useRef<any>(null);
  const finalTranscriptRef = useRef("");
  const isStoppedManually = useRef(false);

  // Initialize Speech Recognition
  useEffect(() => {
    if (typeof window !== "undefined" && (window.SpeechRecognition || window.webkitSpeechRecognition)) {
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      recognitionRef.current = new SpeechRecognition();
      recognitionRef.current.continuous = true;
      recognitionRef.current.interimResults = true;
      recognitionRef.current.lang = "en-US";

      recognitionRef.current.onresult = (event: any) => {
        let interimTranscript = "";
        
        // Process all results
        for (let i = event.resultIndex; i < event.results.length; ++i) {
          const transcript = event.results[i][0].transcript;
          if (event.results[i].isFinal) {
            finalTranscriptRef.current += transcript + " ";
          } else {
            interimTranscript += transcript;
          }
        }
        
        // Update input with accumulated final + current interim
        setInputValue(finalTranscriptRef.current + interimTranscript);
      };

      recognitionRef.current.onerror = (event: any) => {
        console.error("Speech recognition error:", event.error);
        
        // Only stop on actual errors, not on "no-speech"
        if (event.error === 'aborted' || event.error === 'audio-capture' || event.error === 'not-allowed') {
          stopListening();
        }
        // For "no-speech" error, just continue listening
      };

      recognitionRef.current.onend = () => {
        // Only stop if user manually stopped, otherwise restart
        if (!isStoppedManually.current && isListening) {
          try {
            recognitionRef.current.start();
          } catch (e) {
            console.log("Could not restart recognition:", e);
          }
        }
      };
    }

    return () => {
      if (recognitionRef.current) {
        isStoppedManually.current = true;
        try {
          recognitionRef.current.abort();
        } catch (e) {
          // Ignore errors during cleanup
        }
      }
    };
  }, []);

  const startListening = () => {
    if (recognitionRef.current && !isListening) {
      try {
        isStoppedManually.current = false;
        finalTranscriptRef.current = "";
        setInputValue("");
        recognitionRef.current.start();
        setIsListening(true);
        onListeningStateChange?.(true);
      } catch (e) {
        console.error("Failed to start speech recognition", e);
      }
    } else if (!recognitionRef.current) {
      alert("Voice commands are not supported in this browser.");
    }
  };

  const stopListening = () => {
    if (recognitionRef.current && isListening) {
      isStoppedManually.current = true;
      recognitionRef.current.stop();
      setIsListening(false);
      onListeningStateChange?.(false);
      // Trim the final result
      setInputValue(finalTranscriptRef.current.trim());
    }
  };

  const toggleListening = () => {
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  };

  const handleAction = () => {
    if (inputValue.trim() && !isLoading) {
      stopListening();
      onSend(inputValue);
      setInputValue("");
      finalTranscriptRef.current = "";
    }
  };

  return (
    <div className={`relative flex items-center w-full transition-all duration-300 ${isListening ? 'shadow-[0_0_20px_rgba(0,240,255,0.2)] rounded-2xl' : ''}`}>

      <input 
        type="text" 
        value={inputValue}
        onChange={(e) => setInputValue(e.target.value)}
        placeholder={isListening ? "" : "Enter query...."}
        className={`w-full bg-transparent border-none py-4 pr-24 text-white placeholder:text-white/30 focus:outline-none focus:ring-0 font-medium tracking-wide text-base ${isListening ? 'pl-28' : 'pl-6'}`}
        onKeyDown={(e) => e.key === 'Enter' && handleAction()}
      />
      
      <div className="absolute right-2 flex items-center gap-1.5">
        <button
          onClick={toggleListening}
          disabled={isLoading}
          className={`
            p-2.5 rounded-xl transition-all duration-300 flex items-center justify-center
            ${isListening 
              ? 'bg-spex-cyan text-black shadow-[0_0_10px_rgba(0,240,255,0.5)] animate-pulse' 
              : 'bg-white/5 text-white/40 hover:text-spex-cyan hover:bg-white/10'}
          `}
          title="Toggle Voice Command"
        >
          {isListening ? <MicOff size={18} /> : <Mic size={18} />}
        </button>

        <button 
          onClick={handleAction}
          disabled={isLoading || !inputValue.trim()}
          className={`
            p-2.5 rounded-xl transition-all duration-300 flex items-center justify-center
            ${inputValue.trim() 
              ? 'bg-spex-yellow text-black hover:bg-white shadow-[0_0_15px_rgba(252,238,10,0.3)]' 
              : 'bg-white/5 text-white/20 cursor-not-allowed'}
          `}
        >
          {isLoading ? (
            <div className="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin" />
          ) : (
            <ArrowRight size={18} strokeWidth={2.5} />
          )}
        </button>
      </div>
    </div>
  );
};