window.createLoader = async function(file = '/loader.html', callBack) {
    if (document.getElementById('appLoader')) return;
    const res = await fetch(file)
     if (!res.ok) return console.error('Não foi possível carregar o loader.');
    const html = await res.text()
    const div = document.createElement('div');
    div.innerHTML = html;
    document.body.appendChild(div.firstElementChild);
    if(callBack)
        return await callBack()
}

window.showLoader = function (text) {
    const overlay = document.getElementById('appLoader');
    if (!overlay) return;
    if (text) {
        const t = overlay.querySelector('.loader-text');
        if (t) t.textContent = text;
    }
    overlay.classList.add('visible');
    overlay.setAttribute('aria-hidden', 'false');
}

window.hideLoader = function () {
    const overlay = document.getElementById('appLoader');
    if (!overlay) return;
    overlay.classList.remove('visible');
    overlay.setAttribute('aria-hidden', 'true');
}
