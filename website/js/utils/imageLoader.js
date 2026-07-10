function initializeLazyImages() {
    const images = document.querySelectorAll("img[data-src]");
    if (!images.length) return;
    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const image = entry.target;
            image.src = image.dataset.src;
            image.removeAttribute("data-src");
            obs.unobserve(image);
        });
    }, { rootMargin: "100px" });
    images.forEach(image => observer.observe(image));
}
export default initializeLazyImages;
