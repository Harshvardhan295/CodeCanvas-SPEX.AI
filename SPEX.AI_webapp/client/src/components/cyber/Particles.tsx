import { useCallback } from "react";
import Particles from "@tsparticles/react";
import { loadSlim } from "@tsparticles/slim";
import type { Engine } from "@tsparticles/engine";

export default function ParticlesBackground() {
  const particlesInit = useCallback(async (engine: Engine) => {
    await loadSlim(engine);
  }, []);

  return (
    <Particles
      id="tsparticles"
      className="fixed inset-0 -z-10"
      options={{
        particles: {
          number: { value: 40 },
          color: { value: ["#fcee0a", "#ffffff"] }, // UPDATED: Yellow and White
          opacity: { 
            value: { min: 0.1, max: 0.3 },
            animation: {
              enable: true,
              speed: 0.5,
              sync: false
            }
          },
          size: { 
            value: { min: 1, max: 2 }
          },
          links: {
            enable: true,
            distance: 150,
            color: "#fcee0a", // UPDATED: Yellow
            opacity: 0.05,
            width: 1,
          },
          move: {
            enable: true,
            speed: 0.4,
            direction: "none",
            random: true,
            straight: false,
            outModes: { default: "out" },
          },
        },
        interactivity: {
          events: {
            onHover: { enable: true, mode: "bubble" },
          },
          modes: {
            bubble: { distance: 200, size: 4, duration: 2, opacity: 0.4 },
          },
        },
        detectRetina: true,
        background: { color: "transparent" }
      } as any}
    />
  );
}