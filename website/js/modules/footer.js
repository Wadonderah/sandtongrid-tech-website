async function loadFooter() {

    try {
        const response = await fetch("data/footer.json");


        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const footer = await response.json();

        if (!footer) {
            console.warn("Footer data is empty.");
            return;
        }

        renderFooter(footer);

    } catch (error) {
        console.error("Error loading footer:", error);
    }
}

function renderFooter(footer) {
    const footerContent = document.getElementById("footer-content");
    
    if (!footerContent) {
        console.error("Footer content not found in DOM");
        return;
    }

    footerContent.innerHTML = `

        <div class="footer-brand">
            <img
                src="${footer.logo || 'assets/logos/logo-light.png'}"
                alt="${footer.company || 'Sandtongrid Technologies'}"
                loading="lazy">
            <p>${footer.description || 'Building secure, scalable cloud solutions.'}</p>
        </div>

        <div class="footer-links">
            ${(footer.links || []).map(link => `
                <a href="${link.url || '#'}">${link.label || 'Link'}</a>
            `).join('')}
        </div>

        <div class="footer-social">
            ${(footer.social || []).map(social => `
                <a href="${social.url || '#'}" aria-label="${social.name || 'Social'}">
                    ${social.icon || '🔗'}
                </a>
            `).join('')}
        </div>

    `;
}

export default loadFooter;
