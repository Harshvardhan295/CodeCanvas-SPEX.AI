import { Howl } from 'howler';

const sounds = {
  boot: new Howl({ src: ['https://assets.codepen.io/217233/cyber_boot.mp3'], volume: 0.5 }),
  send: new Howl({ src: ['https://assets.codepen.io/217233/cyber_send.mp3'], volume: 0.5 }),
  click: new Howl({ src: ['https://www.neutrinoweb.com/miis/Cyberpunk%202077%20_%20Fading.mp3'], volume: 0.3 }),
};

export const playSound = (type: 'boot' | 'send' | 'click') => {
  sounds[type].stop();
  sounds[type].play();
};
