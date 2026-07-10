import "./core/theme.js";
import initializeMobileMenu from "./components/mobile-menu.js";
import loadServices from "./modules/services.js";
import loadStatistics from "./modules/statistics.js";
import loadWhyChooseUs from "./modules/whyChooseUs.js";
import loadTechnologies from "./modules/technologies.js";
import loadProjects from "./modules/projects.js";
import loadTestimonials from "./modules/testimonials.js";
import loadAbout from "./modules/about.js";
import loadDownloads from "./modules/downloads.js";
import loadContact from "./modules/contact.js";
import loadFooter from "./modules/footer.js";

import initializeSmoothScroll from "./animations/smoothScroll.js";
import initializeScrollReveal from "./animations/scrollReveal.js";
import initializeCounters from "./animations/counterAnimation.js";
import initializeNavbarScroll from "./animations/navbarScroll.js";
import initializeTechnologyHover from "./animations/technologyHover.js";
import initializeProjectHover from "./animations/projectHover.js";
import initializeTyping from "./sections/typing.js";
import initializeLoader from "./animations/loader.js";
import initializeBackToTop from "./animations/backToTop.js";
import initializeLazyImages from "./utils/imageLoader.js";
import initializeCTAAnimation from "./animations/ctaAnimation.js";

document.addEventListener("DOMContentLoaded", async () => {

    initializeLoader();

    initializeMobileMenu();

    await loadServices();

    await loadStatistics();

    await loadWhyChooseUs();

    await loadTechnologies();

    await loadProjects();
    await loadTestimonials();

    await loadAbout();

    await loadDownloads();

    await loadContact();

    await loadFooter();

    initializeSmoothScroll();

    initializeScrollReveal();

    initializeCounters();

    initializeNavbarScroll();

    initializeTechnologyHover();

    initializeProjectHover();

    initializeTyping();
    initializeBackToTop();
    initializeLazyImages();
    initializeCTAAnimation();

});
