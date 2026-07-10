async function loadTechnologies() {
    try {
        const response = await fetch("data/technologies.json");
        if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
        const technologies = await response.json();
        if (!Array.isArray(technologies) || technologies.length === 0) return;
        const techGrid = document.getElementById("technology-grid");
        if (!techGrid) return;
        techGrid.innerHTML = technologies.map(tech => `
            <article class="technology-card">
                <img
    src="assets/technologies/${tech.icon}"
    alt="${tech.name}"
    loading="lazy">
                <h3>${tech.name}</h3>
                <p>${tech.description}</p>
            </article>
        `).join("");
    } catch (error) {
        console.error("Error loading technologies:", error);
    }
}
export default loadTechnologies;
