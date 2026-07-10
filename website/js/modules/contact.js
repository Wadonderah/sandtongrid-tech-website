async function loadContact() {

    const response = await fetch("data/contact.json");

    const contact = await response.json();

    const content = document.getElementById("contact-content");

    content.classList.add("contact-container");

    content.innerHTML = `

        <div class="contact-info">

            <h3>Contact Details</h3>

            <p>${contact.description}</p>

            <div class="contact-details">

                <p><strong>Email:</strong> ${contact.email}</p>

                <p><strong>Phone:</strong> ${contact.phone}</p>

                <p><strong>Location:</strong> ${contact.location}</p>

                <p><strong>Business Hours:</strong> ${contact.hours}</p>

            </div>

        </div>

        <form class="contact-form" aria-label="Contact form">

            <label class="visually-hidden" for="contact-name">Full Name</label>
            <input
                id="contact-name"
                name="name"
                type="text"
                autocomplete="name"
                placeholder="Full Name"
                required>

            <label class="visually-hidden" for="contact-email">Email Address</label>
            <input
                id="contact-email"
                name="email"
                type="email"
                autocomplete="email"
                placeholder="Email Address"
                required>

            <label class="visually-hidden" for="contact-company">Company (optional)</label>
            <input
                id="contact-company"
                name="company"
                type="text"
                autocomplete="organization"
                placeholder="Company">

            <label class="visually-hidden" for="contact-message">Project Details</label>
            <textarea
                id="contact-message"
                name="message"
                rows="6"
                placeholder="Tell us about your project..."
                required></textarea>

            <button
                type="submit"
                class="btn-primary">

                Send Message

            </button>

        </form>

    `;

    attachContactFormHandler(contact.email);

}

function attachContactFormHandler(recipientEmail) {

    const form = document.querySelector(".contact-form");

    if (!form) {

        return;

    }

    form.addEventListener("submit", (event) => {

        event.preventDefault();

        const data = new FormData(form);

        const name = (data.get("name") || "").trim();
        const email = (data.get("email") || "").trim();
        const company = (data.get("company") || "").trim();
        const message = (data.get("message") || "").trim();

        const subject = encodeURIComponent(`New project inquiry from ${name}`);

        const bodyLines = [
            `Name: ${name}`,
            `Email: ${email}`,
            company ? `Company: ${company}` : null,
            "",
            message,
        ].filter((line) => line !== null);

        const body = encodeURIComponent(bodyLines.join("\n"));

        window.location.href = `mailto:${recipientEmail}?subject=${subject}&body=${body}`;

        showFormStatus(form, "Opening your email client to send this message…");

    });

}

function showFormStatus(form, text) {

    let status = form.querySelector(".form-status");

    if (!status) {

        status = document.createElement("p");
        status.className = "form-status";
        status.setAttribute("role", "status");
        form.appendChild(status);

    }

    status.textContent = text;

}

export default loadContact;