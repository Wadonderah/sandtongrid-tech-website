function initializeTechnologyHover() {

    const cards = document.querySelectorAll(".technology-card");

    cards.forEach(card => {

        card.addEventListener("mouseenter", () => {

            card.classList.add("technology-active");

        });

        card.addEventListener("mouseleave", () => {

            card.classList.remove("technology-active");

        });

    });

}

export default initializeTechnologyHover;