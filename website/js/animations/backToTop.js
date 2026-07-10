
function initializeBackToTop() {

    const button = document.getElementById("backToTop");

    window.addEventListener("scroll", () => {

        if (window.scrollY > 400) {

            button.classList.add("show-back-to-top");

        } else {

            button.classList.remove("show-back-to-top");

        }

    });

    button.addEventListener("click", () => {

        window.scrollTo({

            top: 0,

            behavior: "smooth"

        });

    });

}

export default initializeBackToTop;