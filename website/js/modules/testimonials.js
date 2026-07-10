async function loadTestimonials() {

    try {
        const response = await fetch("data/testimonials.json");

        if (!response.ok) {
            throw new Error("Unable to load testimonials.");
        }

        const testimonials = await response.json();

        const container = document.getElementById("testimonials-grid");

        if (!container) return;

        container.innerHTML = testimonials.map(item => `

            <article class="testimonial-card">

                <div class="stars">
                    ${"⭐".repeat(item.rating)}
                </div>

                <p class="testimonial-message">
                    "${item.message}"
                </p>

                <h4>${item.name}</h4>

                <span>${item.company}</span>

                <small>${item.project}</small>

            </article>

        `).join("");


    } catch (error) {

        console.error(error);

    }

}

export default loadTestimonials;
