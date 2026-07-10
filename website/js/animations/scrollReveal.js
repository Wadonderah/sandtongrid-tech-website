function initializeScrollReveal() {
    const elements = document.querySelectorAll("section, .service-card, .project-card, .stat-card");
    elements.forEach(element => element.classList.add("reveal"));
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("active");
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.15 });
    elements.forEach(element => observer.observe(element));
}
export default initializeScrollReveal;
