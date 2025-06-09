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
