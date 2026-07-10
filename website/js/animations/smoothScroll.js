function initializeSmoothScroll() {

    document.querySelectorAll('a[href^="#"]').forEach(anchor => {

        anchor.addEventListener("click", function (event) {

            event.preventDefault();

            const target = document.querySelector(this.getAttribute("href"));

            if (!target) return;

            target.scrollIntoView({

                behavior: "smooth"

            });

        });

    });

}

export default initializeSmoothScroll;