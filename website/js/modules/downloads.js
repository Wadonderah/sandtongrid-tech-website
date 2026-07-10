async function loadDownloads() {

    const response = await fetch("data/downloads.json");

    const downloads = await response.json();

    const grid = document.getElementById("downloads-grid");

    grid.innerHTML = `

        ${downloads.map(item => `

            <article class="download-card">

                <div class="download-icon">

                    ${item.icon}

                </div>

                <h3>${item.title}</h3>

                <p>${item.description}</p>

                <a
                    href="${item.file}"
                    download
                    class="btn-primary">

                    Download

                </a>

            </article>

        `).join("")}

    `;

}

export default loadDownloads;