function initializeCTAAnimation() {

    const card = document.querySelector(".cta-card");

    if (!card) return;

    card.addEventListener("mouseenter", () => {
        card.style.transform = "translateY(-8px)";
    });

    card.addEventListener("mouseleave", () => {
        card.style.transform = "translateY(0)";
    });

}

export default initializeCTAAnimation;
