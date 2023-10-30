_escape_html = document.createElement "textarea"
window.escape_html = (html)->
  _escape_html.textContent = html
  _escape_html.innerHTML

window.unescape_html = (html)->
  _escape_html.innerHTML = html
  _escape_html.textContent

