# https://stackoverflow.com/questions/736513/how-do-i-parse-a-url-into-hostname-and-path-in-javascript
window.url_parse = (href)->
  l = document.createElement("a")
  l.href = href
  l
