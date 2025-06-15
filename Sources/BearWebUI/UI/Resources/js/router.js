const urlParams = new URLSearchParams(window.location.search);


function loadContent(url, targetElement) {
    fetch(url)
    .then(response => {
           if (!response.ok) {
               throw new Error('Respuesta no exitosa');
           }
           return response.text();
   })
    .then(html => {
        const target = document.querySelector(targetElement);
        target.innerHTML = html;
        htmx.process(target);
        _hyperscript.processNode(target);
    })
    .catch(error => {
        console.error('Error al cargar el contenido:', error);
    });
}

function loadMain(url) {
    fetch(url)
    .then(response => {
           if (!response.ok) {
               throw new Error('Respuesta no exitosa');
           }
           return response.text();
   })
    .then(html => {
        const target = document.querySelector("main");
        target.innerHTML = html
        htmx.process(document.querySelector("main"));
        _hyperscript.processNode(document.querySelector("main"))
        
    })
    .catch(error => {
        console.error('Error al cargar el contenido:', error);
    });
}

const slug = urlParams.get('slug');
if (slug) {
    const resourceUrl = `/standalone/note/${slug}.html`;
    var checkbox = document.getElementById("nav-checkbox");
    checkbox.checked = true;
    loadMain(resourceUrl);
}


const tag = urlParams.get('tag');
if (tag) {
    const parsedTag = tag.replace(/\//g, '&');
    const resourceUrl = `/standalone/tag/${parsedTag}.html`;
    loadContent(resourceUrl, 'nav');
    
}

const list = urlParams.get('list');
if (list) {
    const resourceUrl = `/standalone/list/${list}.html`;
    loadContent(resourceUrl, 'nav');
}

const backlinks = urlParams.get('backlinks');
if (backlinks) {
    const backlinksNoteListUrl = `/standalone/backlinks/${backlinks}.html`;
    const noteUrl = `/standalone/note/${backlinks}.html`
    loadContent(backlinksNoteListUrl, 'nav');
    loadMain(noteUrl)
}
