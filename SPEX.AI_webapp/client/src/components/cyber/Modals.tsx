import { motion, AnimatePresence } from "framer-motion";
import { X } from "lucide-react";
import CodeMirror from "@uiw/react-codemirror";
import { javascript } from "@codemirror/lang-javascript";
import { css } from "@codemirror/lang-css";
import { playSound } from "@/lib/sounds";

interface AboutModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function AboutModal({ isOpen, onClose }: AboutModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 bg-[rgba(10,10,20,0.7)] backdrop-blur-md z-[200] flex items-center justify-center p-4"
          onClick={onClose}
        >
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ type: "spring", damping: 20, stiffness: 300 }}
            className="relative w-full max-w-[600px] bg-cyber-surface p-8 text-cyber-text"
            onClick={(e) => e.stopPropagation()}
            style={{
                // Leveraging augmented-ui via style prop or class if using the library properly, 
                // but since we linked the CSS, we can use the data-attributes.
                // React doesn't like custom data attrs without spread sometimes, but standard ones are fine.
            }}
            data-augmented-ui="tr-clip-x br-clip bl-clip-x both"
          >
            <button
              onClick={onClose}
              className="absolute top-2 right-4 text-cyber-secondary hover:text-white text-4xl leading-none transition-all hover:rotate-90 origin-center"
            >
              ×
            </button>

            <h2 className="font-display text-cyber-primary text-3xl text-center mb-6 text-shadow-primary">
              SPEX<span className="text-spex-yellow">.AI</span> 
            </h2>

            <div className="font-body text-lg text-gray-300 space-y-4">
              <p>
                Spex is an RAG-based system that allows users to input a website URL, automatically crawl and extract its content, and generate a custom Retrieval-Augmented Generation (RAG) based AI chatbot capable of answering user queries accurately using only the website’s data.
              </p>

              <h3 className="font-bold text-cyber-secondary text-xl border-b border-[rgba(0,240,255,0.2)] pb-2 mt-6 mb-3">
                Technologies Used:
              </h3>
              <ul className="space-y-2 list-none pl-0">
                {["Tailwind CSS", "React & TypeScript", "Framer Motion", "Particles.js", "Augmented-UI", "CodeMirror"].map((tech) => (
                    <li key={tech} className="relative pl-6 before:content-['>'] before:absolute before:left-0 before:text-cyber-primary before:font-bold text-gray-400">
                        <strong className="text-gray-200">{tech}</strong>
                    </li>
                ))}
              </ul>

            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}

interface CodeModalProps {
    isOpen: boolean;
    onClose: () => void;
    code: string;
    lang: string;
}

export function CodeModal({ isOpen, onClose, code, lang }: CodeModalProps) {
    // Determine extension based on lang string
    const getExtension = (lang: string) => {
        if (lang.toLowerCase().includes('css')) return [css()];
        return [javascript({ jsx: true })];
    };

    return (
        <AnimatePresence>
            {isOpen && (
                <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    className="fixed inset-0 bg-black/80 backdrop-blur-sm z-[200] flex items-center justify-center"
                    onClick={onClose}
                >
                    <motion.div 
                        initial={{ scale: 0.9, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        exit={{ scale: 0.9, opacity: 0 }}
                        className="relative w-[80vw] h-[80vh] min-w-[420px] min-h-[300px]"
                        onClick={(e) => e.stopPropagation()}
                    >
                        {/* Glow Container */}
                        <div className="absolute inset-0 z-[2] pointer-events-none filter drop-shadow-[0_0_10px_violet] brightness-150">
                             <div className="w-[calc(100%-60px)] h-[calc(100%-60px)] m-auto" 
                                  data-augmented-ui="tr-clip-x tl-clip br-clip bl-clip both"
                                  style={{ "--aug-border-all": "2px", "--aug-border-bg": "linear-gradient(to bottom left, rebeccapurple, orange)" } as any}>
                             </div>
                        </div>

                        {/* Main Container */}
                        <section 
                            className="absolute inset-0 m-auto bg-[#200933] overflow-hidden"
                            data-augmented-ui="tr-clip-x tl-clip br-clip bl-clip both"
                            style={{ 
                                "--aug-inlay-all": "2px", 
                                "--aug-inlay-bg": "rgba(255,255,255,0.05)",
                                background: "repeating-linear-gradient(to top, rgba(255, 255, 255, 0.03) 0px 2px, transparent 2px 4px), linear-gradient(to bottom, #200933 75%, #3d0b43)"
                            } as any}
                        >
                            {/* Decorative Grid Floor */}
                            <div className="absolute bottom-0 w-full h-1/2 opacity-20 pointer-events-none" 
                                 style={{ 
                                     background: "linear-gradient(90deg, rgba(252,25,154,.1) 1px, transparent 1px), linear-gradient(0deg, rgba(252,25,154,.1) 1px, transparent 1px)",
                                     backgroundSize: "20px 20px",
                                     transform: "perspective(100px) rotateX(60deg)"
                                 }} 
                            />

                            {/* Header */}
                            <div className="absolute top-4 left-4 flex gap-2">
                                <button onClick={onClose} className="w-4 h-4 rounded-full bg-[#fc199a] hover:brightness-125 transition-all shadow-[0_0_5px_#fc199a]" />
                                <div className="w-4 h-4 rounded-full bg-[#ffcc00] opacity-50" />
                                <div className="w-4 h-4 rounded-full bg-[#61e2ff] opacity-50" />
                            </div>

                            <div className="absolute top-5 left-[120px] right-[120px] text-center font-display text-[#ffc8ff80] tracking-widest text-shadow-[0_0_12px_rebeccapurple]">
                                {lang.toUpperCase()} SOURCE
                            </div>

                            {/* Code Area */}
                            <div className="absolute inset-[60px_20px_20px_20px] overflow-hidden bg-[#0a0a14]/50 rounded border border-white/5">
                                <CodeMirror
                                    value={code}
                                    height="100%"
                                    theme="dark"
                                    extensions={getExtension(lang)}
                                    readOnly={true}
                                    basicSetup={{
                                        lineNumbers: true,
                                        foldGutter: true,
                                    }}
                                    className="h-full text-base font-mono"
                                />
                            </div>
                        </section>
                    </motion.div>
                </motion.div>
            )}
        </AnimatePresence>
    );
}
