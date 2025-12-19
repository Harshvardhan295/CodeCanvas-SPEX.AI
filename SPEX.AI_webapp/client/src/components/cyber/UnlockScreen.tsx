import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { playSound } from "@/lib/sounds";

interface UnlockScreenProps {
  onUnlock: () => void;
}

export default function UnlockScreen({ onUnlock }: UnlockScreenProps) {
  const [isVisible, setIsVisible] = useState(true);

  const handleUnlock = () => {
    playSound("click");
    playSound("boot");
    setIsVisible(false);
    setTimeout(onUnlock, 500);
  };

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          initial={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.8 }}
          className="fixed inset-0 z-[100] bg-black flex flex-col items-center justify-center"
        >
          <motion.button
            whileHover={{ 
                scale: 1.05, 
                backgroundColor: "#fcee0a", 
                color: "#000000",
                boxShadow: "0 0 25px #fcee0a"
            }}
            whileTap={{ scale: 1.00 }}
            onClick={handleUnlock}
            className="font-display text-2xl px-8 py-4 border-2 border-[#fcee0a] text-[#fcee0a] bg-transparent cursor-pointer transition-colors duration-10 tracking-widest uppercase"
            style={{ textShadow: "0 0 10px rgba(252, 238, 10, 0.5)" }}
          >
            Enter the Spex
          </motion.button>
        </motion.div>
      )}
    </AnimatePresence>
  );
}