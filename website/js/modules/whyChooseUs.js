
async function loadWhyChooseUs() {

    const response = await fetch("data/why-choose-us.json");

    const items = await response.json();

    const grid = document.getElementById("why-grid");

    grid.innerHTML = "";

    items.forEach(item => {

        grid.innerHTML += `

            <article class="why-card">

                <div class="why-icon">

                    ${item.icon}

                </div>

                <h3>

                    ${item.title}

                </h3>

                <p>

                    ${item.description}

                </p>

            </article>

        `;

    });

}

export default loadWhyChooseUs;