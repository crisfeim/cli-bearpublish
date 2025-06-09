// Agrega un event listener al botón de compartir
document.getElementById('share-button').addEventListener('click', function() {
  // Verifica si el navegador admite la API de Web Share
  if (navigator.share) {
    // Llama a la API de Web Share para compartir el contenido
    navigator.share({
      title: '#(title)',
      text: '#(description)',
      url: 'https://notas.cristian.lat/#(slug)'
    })
    .then(function() {
      console.log('Contenido compartido exitosamente.');
    })
    .catch(function(error) {
      console.error('Error al compartir el contenido:', error);
    });
  } else {
    console.log('El navegador no admite la API de Web Share.');
  }
});
