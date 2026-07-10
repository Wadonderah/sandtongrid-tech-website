const words = [

    "AWS Cloud Architecture",

    "Cloud Migration",

    "Terraform Infrastructure",

    "DevOps Automation",

    "Cloud Security",

    "CI/CD Pipelines"

];

const element = document.getElementById("typing-text");

let word = 0;

let letter = 0;

let deleting = false;

function type(){

    const current = words[word];

    if(!deleting){

        element.textContent = current.substring(0,letter++);

        if(letter > current.length){

            deleting = true;

            setTimeout(type,1800);

            return;

        }

    }else{

        element.textContent = current.substring(0,--letter);

        if(letter === 0){

            deleting = false;

            word = (word + 1) % words.length;

        }

    }

    setTimeout(type,deleting ? 40 : 90);

}

type();