window.autosuggest_util_simple = (value, full_list)->
  res_list = []
  value = value or ""
  value_chunk_list = value.split(/\s+/g).filter (t)->t
  
  for suggest_option in full_list
    pass = true
    for value_chunk in value_chunk_list
      if -1 == suggest_option.indexOf value_chunk
        pass = false
        break
    if pass
      res_list.push suggest_option
  
  res_list
