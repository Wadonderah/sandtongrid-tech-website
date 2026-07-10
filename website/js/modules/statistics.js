async function loadStatistics() {
    try {
        const response = await fetch("data/statistics.json");
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const statistics = await response.json();
        if (!Array.isArray(statistics) || statistics.length === 0) {
            console.warn("Statistics data is not an array or is empty.");
            return;
        }
        renderStatistics(statistics);
    } catch (error) {
        console.error("Error loading statistics:", error);
    }
}

function renderStatistics(statistics) {
    const statsGrid = document.getElementById("statistics-grid");
    if (!statsGrid) {
        console.error("Statistics grid not found in DOM");
        return;
    }
    statsGrid.innerHTML = statistics.map(stat => `
        <div class="stat-card">
            <span class="stat-number" data-counter="${stat.number}">
                0
            </span>
            <p class="stat-label">
                ${stat.title}
            </p>
        </div>
    `).join("");
}

export default loadStatistics;
