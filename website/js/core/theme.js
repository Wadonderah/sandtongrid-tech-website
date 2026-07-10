const STORAGE_KEY = "sandtongrid-theme";

const body = document.body;

const logo = document.querySelector("[data-logo]");

const toggle = document.querySelector("[data-theme-toggle]");

const logos = {

    light: "assets/logos/logo-dark.png",

    dark: "assets/logos/logo-light.png"

};

function applyTheme(theme){

    body.classList.remove("light","dark");

    body.classList.add(theme);

    localStorage.setItem(STORAGE_KEY,theme);

    if(logo){

        logo.src = logos[theme];

    }

}

function detectTheme(){

    const saved = localStorage.getItem(STORAGE_KEY);

    if(saved){

        return saved;

    }

    // Dark is the brand default regardless of system preference —
    // the toggle is still there for anyone who prefers light.
    return "dark";

}

applyTheme(detectTheme());

toggle?.addEventListener("click",()=>{

    const next = body.classList.contains("dark")

        ? "light"

        : "dark";

    applyTheme(next);

});