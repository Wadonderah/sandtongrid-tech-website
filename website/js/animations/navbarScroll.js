function initializeNavbarScroll() {
    const navbar = document.querySelector(".navbar");
    const links = document.querySelectorAll(".nav-links a");
    const sections = document.querySelectorAll("section[id]");
    function updateNavbar() {
        if (window.scrollY > 60) {
            navbar.classList.add("scrolled");
        } else {
            navbar.classList.remove("scrolled");
        }
        let current = "";
        sections.forEach(section => {
            const top = section.offsetTop - 120;
            const height = section.offsetHeight;
            if (window.scrollY >= top && window.scrollY < top + height) {
                current = section.id;
            }
        });
        links.forEach(link => {
            link.classList.remove("active");
            if (link.getAttribute("href") === `#${current}`) {
                link.classList.add("active");
            }
        });
    }
    window.addEventListener("scroll", updateNavbar);
    updateNavbar();
}
export default initializeNavbarScroll;
