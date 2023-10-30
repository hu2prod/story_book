Array::dedupe = ->
  map = new Map()
  
  for item in @
    map.set item, null
  
  Array.from map.keys()
