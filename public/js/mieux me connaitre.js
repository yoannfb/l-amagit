const title = document.querySelector("h1");
const txt ="Je m'appelle Jessica Francizod et aussi loin que je me souvienne, j'ai toujours été passionnée par la guérison et le bien-être des autres. A l’âge de 3 ans je décide que je serai médecin, afin de pouvoir soigner les personnes qui souffrent. Mon hypersensibilité et mon empathie m’ont conduit sur un chemin, moins conventionnel que celui de la fac, et c’est ainsi que j’ai pu approfondir mes connaissances sur les thérapies holistiques, pour lesquelles j’avais déjà quelques notions puisque je suis née dans une famille où se mêlent magnétiseurs et rebouteux. J'ai souhaité en apprendre plus sur ces énergies qui nous animent, qui nous entourent et sur tout le potentiel, parfois insoupçonné, qui regorge en chacun d’entre nous. C’est donc tout naturellement que je me suis tournée vers diverses formations et que je vous propose un accompagnement sur-mesure, grâce à différentes techniques : Soins énergétiques et magnétisme, hypnose régressive spirituelle et énergétique, psychogénéalogie énergétique. J'ai à cœur de vous accompagner dans votre processus de guérison et de développement personnel."



function typewriter(word, index) {
    if(index < word.length) {
        setTimeout(() => {
            title.innerHTML += `<span>${word[index]}</span>`
            typewriter(txt, index + 1)
        }, 25);
    }
} 

setTimeout(() =>{
    typewriter(txt, 0)
}, 500);



const picture = document.querySelector(".logo");

window.addEventListener("load", () =>{
    const TL = gsap.timeline({paused:true});
    TL.fromTo(picture, {top: -50, opacity: 0, ease: "power2.out"}, { top:0 , opacity: 1, duration: 3});
    TL.play();
})


