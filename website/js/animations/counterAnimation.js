function initializeCounters() {
    const counters = document.querySelectorAll("[data-counter]");
    if (!counters.length) return;
    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const counter = entry.target;
            const target = Number(counter.dataset.counter);
            const suffix = counter.nextSibling?.textContent ?? "";
            let current = 0;
            const duration = 1800;
            const fps = 60;
            const totalFrames = Math.round(duration / (1000 / fps));
            const increment = target / totalFrames;
            function update() {
                current += increment;
                if (current >= target) {
                    counter.textContent = target;
                    obs.unobserve(counter);
                    return;
                }
                counter.textContent = Math.floor(current);
                requestAnimationFrame(update);
            }
            update();
        });
    }, { threshold: 0.35 });
    counters.forEach(counter => observer.observe(counter));
}
export default initializeCounters;
