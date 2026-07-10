async function loadProjects() {

    try {
        const response = await fetch("data/projects.json");

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const text = await response.text();

        if (!text || text.trim() === "") {
            renderProjects(getFallbackProjects());
            return;
        }

        let projects;
        try {
            projects = JSON.parse(text);
        } catch (parseError) {
            console.error("Error parsing projects data:", parseError);
            renderProjects(getFallbackProjects());
            return;
        }

        if (!Array.isArray(projects) || projects.length === 0) {
            renderProjects(getFallbackProjects());
            return;
        }

        renderProjects(projects);

    } catch (error) {
        console.error("Error loading projects:", error);
        renderProjects(getFallbackProjects());
    }
}

function renderProjects(projects) {
    const grid = document.getElementById("projects-grid");

    if (!grid) {
        console.error("Projects grid not found in DOM");
        return;
    }

    grid.innerHTML = `

        ${projects.map(project => `

            <article class="project-card">

                <img
                    src="${project.image}"
                    alt="${project.title || 'Project'}"
                    loading="lazy"
                    onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22800%22 height=%22600%22%3E%3Crect width=%22800%22 height=%22600%22 fill=%22%23ecf0f1%22/%3E%3Ctext x=%22400%22 y=%22300%22 font-family=%22Arial%22 font-size=%2224%22 fill=%22%23999%22 text-anchor=%22middle%22%3ENo Image%3C/text%3E%3Ctext x=%22400%22 y=%22340%22 font-family=%22Arial%22 font-size=%2216%22 fill=%22%23999%22 text-anchor=%22middle%22%3E${project.title || ''}%3C/text%3E%3C/svg%3E'">

                <div class="project-content">

                    <h3>${project.title || 'Untitled Project'}</h3>

                    <p>${project.description || 'No description available.'}</p>

                    <a
                        href="${project.link || '#'}"
                        class="btn-primary">

                        View Project

                    </a>

                </div>

            </article>

        `).join("")}

    `;
}

function getFallbackProjects() {
    return [
        {
            title: "AWS Cloud Migration",
            description: "Enterprise cloud migration with Terraform automation.",
            image: "data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22800%22 height=%22600%22%3E%3Crect width=%22800%22 height=%22600%22 fill=%22%233498db%22/%3E%3Ctext x=%22400%22 y=%22300%22 font-family=%22Arial%22 font-size=%2232%22 fill=%22white%22 text-anchor=%22middle%22%3EAWS Migration%3C/text%3E%3C/svg%3E",
            link: "#projects"
        },
        {
            title: "Kubernetes CI/CD",
            description: "GitOps workflow with EKS and ArgoCD.",
            image: "data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22800%22 height=%22600%22%3E%3Crect width=%22800%22 height=%22600%22 fill=%22%232ecc71%22/%3E%3Ctext x=%22400%22 y=%22300%22 font-family=%22Arial%22 font-size=%2232%22 fill=%22white%22 text-anchor=%22middle%22%3EKubernetes%3C/text%3E%3C/svg%3E",
            link: "#projects"
        },
        {
            title: "Cloud Security Implementation",
            description: "AWS Security Hub and compliance automation.",
            image: "data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22800%22 height=%22600%22%3E%3Crect width=%22800%22 height=%22600%22 fill=%22%23e74c3c%22/%3E%3Ctext x=%22400%22 y=%22300%22 font-family=%22Arial%22 font-size=%2232%22 fill=%22white%22 text-anchor=%22middle%22%3ECloud Security%3C/text%3E%3C/svg%3E",
            link: "#projects"
        }
    ];
}

export default loadProjects;
