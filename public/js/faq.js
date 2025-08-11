const picture = document.querySelector(".logo");

window.addEventListener("load", () =>{
    const TL = gsap.timeline({paused:true});
    TL.fromTo(picture, {top: -50, opacity: 0, ease: "power2.out"}, { top:0 , opacity: 1, duration: 3});
    TL.play();
})

