# https://ourcodeworld.com/articles/read/189/how-to-create-a-file-and-generate-a-download-with-javascript-in-the-browser-without-a-server
# https://stackoverflow.com/questions/3665115/how-to-create-a-file-in-memory-for-user-to-download-but-not-through-server
window.download = (filename, content)->
  element = document.createElement "a"
  element.setAttribute "href", "data:text/plain;charset=utf-8," + encodeURIComponent content
  element.setAttribute "download", filename
  
  element.style.display = "none"
  document.body.appendChild element
  
  element.click()
  
  document.body.removeChild element
  return
