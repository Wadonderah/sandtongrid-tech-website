async function loadAbout() {

    try {
        const response = await fetch("data/about.json");


        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const about = await response.json();

        if (!about) {
            console.warn("About data is empty.");
            return;
        }

        renderAbout(about);

    } catch (error) {
        console.error("Error loading about:", error);
    }
}

function renderAbout(about) {
    const aboutContent = document.getElementById("about-content");
    
    if (!aboutContent) {
        console.error("About content not found in DOM");
        return;
    }

    aboutContent.innerHTML = `

        <div class="about-grid">

            <div class="about-image">
                <img
                    src="${about.image}"
                    alt="${about.headline || 'About Sandtongrid Technologies'}"
                    loading="lazy">
            </div>

            <div class="about-text">

                <h3>${about.company || 'About Us'}</h3>

                <p>${about.description || 'Learn more about our team and mission.'}</p>

                <div class="about-values">
                    ${about.mission ? `<div class="mission"><strong>Mission:</strong> ${about.mission}</div>` : ''}
                    ${about.vision ? `<div class="vision"><strong>Vision:</strong> ${about.vision}</div>` : ''}
                    ${about.experience ? `<div class="experience"><strong>Experience:</strong> ${about.experience}</div>` : ''}
                    ${about.location ? `<div class="location"><strong>Location:</strong> ${about.location}</div>` : ''}
                </div>

            </div>

        </div>

    `;
}

export default loadAbout;
