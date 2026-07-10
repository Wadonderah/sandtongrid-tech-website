function initializeLoader() {

    window.addEventListener("load", () => {

        const loader = document.getElementById("loader");

        loader.classList.add("loader-hidden");

        setTimeout(() => {

            loader.remove();

        }, 700);

    });

}

export default initializeLoader;