import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["Cocktails", "Dreams", "Disco", "Party", "Cocktails! Cocktails!, Cocktails!"],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
