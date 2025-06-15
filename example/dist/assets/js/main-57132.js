document.body.classList.remove('js-off');
document.addEventListener("keydown", function(event) {
  if (event.ctrlKey) {
    if (event.which === 49) {
      hideNav()
    }

    if (event.which === 50) {
      showNav()
    }

    if (event.which === 51 || event.which === 53) {
      showMenu()
    }
  }

  if ((event.metaKey && event.which === 75) || (event.ctrlKey && event.which === 75)) {
    toggleLayout()
  }
});

document.addEventListener('htmx:beforeRequest', function(event) {
    if (event.target.dataset.count) {
        showNoteListSkeletons(event)
    }
});

function showNoteListSkeletons(event) {
    console.log('clicked');
    const noteList = document.getElementById('note-list');
    noteList.innerHTML = ''
    const title = event.target.innerText
    const navElement = document.querySelector('nav')
    const titleElement = navElement.querySelector('.title');
    titleElement.innerText = title
    const target = document.getElementById('spinner')
    const count = event.target.dataset.count;

      for (var i = 0; i < count; i++) {
        var skeletonCell = document.createElement('div');
        skeletonCell.classList.add('skeleton-cell');
         skeletonCell.innerHTML = `
    <div class="title-placeholder"></div>
    <div class="text-placeholder"></div>
    <div class="text-placeholder"></div>
    <div class="time-placeholder"></div>
  `;
        target.appendChild(skeletonCell);
      }
}

/* Get the documentElement (<html>) to display the page in fullscreen */
var elem = document.documentElement;

/* View in fullscreen */
function openFullscreen() {
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
  } else if (elem.webkitRequestFullscreen) { /* Safari */
    elem.webkitRequestFullscreen();
  } else if (elem.msRequestFullscreen) { /* IE11 */
    elem.msRequestFullscreen();
  }
}

/* Close fullscreen */
function closeFullscreen() {
  if (document.exitFullscreen) {
    document.exitFullscreen();
  } else if (document.webkitExitFullscreen) { /* Safari */
    document.webkitExitFullscreen();
  } else if (document.msExitFullscreen) { /* IE11 */
    document.msExitFullscreen();
  }
}

// Fix videos not working in safarie due to DOMParser bug
document.body.addEventListener('htmx:afterRequest', function (event) {
    const videos = document.body.querySelectorAll('video');
    videos.forEach(function(video) {
        console.log(video);
        const clonedVideo = video.cloneNode(true);
        video.parentNode.replaceChild(clonedVideo, video);
    });
});
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
