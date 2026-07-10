let assets = {};

export async function loadAssets() {

    if (Object.keys(assets).length) {

        return assets;

    }

    const response = await fetch("data/assets.json");

    assets = await response.json();

    return assets;

}

export function getAssets() {

    return assets;

}