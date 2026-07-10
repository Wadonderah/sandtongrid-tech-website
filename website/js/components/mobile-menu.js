
function initializeMobileMenu() {

    const toggleButton = document.querySelector("[data-mobile-menu-toggle]");

    const navLinks = document.getElementById("navLinks");

    const overlay = document.querySelector("[data-nav-overlay]");

    if (!toggleButton || !navLinks) {

        return;

    }

    const body = document.body;

    const focusableLinks = () =>
        navLinks.querySelectorAll("a, button");

    function openMenu() {

        navLinks.classList.add("open");

        toggleButton.classList.add("open");

        toggleButton.setAttribute("aria-expanded", "true");

        body.classList.add("nav-open");

        if (overlay) {

            overlay.classList.add("visible");

        }

        const firstLink = focusableLinks()[0];

        if (firstLink) {

            firstLink.focus();

        }

    }

    function closeMenu({ returnFocus = false } = {}) {

        navLinks.classList.remove("open");

        toggleButton.classList.remove("open");

        toggleButton.setAttribute("aria-expanded", "false");

        body.classList.remove("nav-open");

        if (overlay) {

            overlay.classList.remove("visible");

        }

        if (returnFocus) {

            toggleButton.focus();

        }

    }

    function isOpen() {

        return navLinks.classList.contains("open");

    }

    toggleButton.addEventListener("click", () => {

        isOpen() ? closeMenu({ returnFocus: true }) : openMenu();

    });

    if (overlay) {

        overlay.addEventListener("click", () => closeMenu());

    }

    // Close the menu whenever a nav link is activated.

    focusableLinks().forEach((link) => {

        link.addEventListener("click", () => closeMenu());

    });

    // Close on Escape, return focus to the toggle button.

    document.addEventListener("keydown", (event) => {

        if (event.key === "Escape" && isOpen()) {

            closeMenu({ returnFocus: true });

        }

    });

    // Keep a basic focus trap while the drawer is open.

    navLinks.addEventListener("keydown", (event) => {

        if (event.key !== "Tab" || !isOpen()) {

            return;

        }

        const links = Array.from(focusableLinks());

        if (links.length === 0) {

            return;

        }

        const first = links[0];

        const last = links[links.length - 1];

        if (event.shiftKey && document.activeElement === first) {

            event.preventDefault();

            last.focus();

        } else if (!event.shiftKey && document.activeElement === last) {

            event.preventDefault();

            first.focus();

        }

    });

    // Auto-close if the viewport grows back into desktop width.

    window.addEventListener("resize", () => {

        if (window.innerWidth > 900 && isOpen()) {

            closeMenu();

        }

    });

}

export default initializeMobileMenu;
