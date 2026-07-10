async function loadServices() {

    try {
        const response = await fetch("data/services.json");


        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const services = await response.json();

        if (!Array.isArray(services) || services.length === 0) {
            console.warn("Services data is not an array or is empty.");
            return;
        }

        renderServices(services);

    } catch (error) {
        console.error("Error loading services:", error);
    }
}

function renderServices(services) {
    const servicesGrid = document.getElementById("services-grid");
    
    if (!servicesGrid) {
        console.error("Services grid not found in DOM");
        return;
    }

    servicesGrid.innerHTML = services.map(service => `

        <div class="service-card">

            <div class="service-icon">
                <img
                    src="assets/services/${service.icon}"
                    alt="${service.title}"
                    loading="lazy">
            </div>

            <h3>${service.title}</h3>

            <p>${service.description}</p>

        </div>

    `).join("");
}

export default loadServices;
