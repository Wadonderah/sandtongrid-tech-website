const phrases = [

    "AWS Cloud Architecture",

    "Cloud Migration",

    "DevOps Automation",

    "Terraform Infrastructure as Code",

    "Kubernetes & Docker",

    "AWS Well-Architected Reviews"

];

function initializeTyping() {

    const element = document.getElementById("typing-text");

    if (!element) return;

    let phraseIndex = 0;
    let letterIndex = 0;
    let deleting = false;

    function type() {

        const currentPhrase = phrases[phraseIndex];

        if (!deleting) {

            element.textContent = currentPhrase.substring(0, letterIndex++);

            if (letterIndex > currentPhrase.length) {

                deleting = true;

                setTimeout(type, 1800);

                return;

            }

        } else {

            element.textContent = currentPhrase.substring(0, letterIndex--);

            if (letterIndex < 0) {

                deleting = false;

                phraseIndex = (phraseIndex + 1) % phrases.length;

            }

        }

        setTimeout(type, deleting ? 40 : 80);

    }

    type();

}

export default initializeTyping;