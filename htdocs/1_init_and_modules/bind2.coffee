window.bind2 = (athis, key, opt={})->
  Object.assign {}, opt, {
    value     : athis.state[key]
    on_change : (value)->
      state = {}
      state[key] = value
      athis.set_state state
      opt.on_change?(value)
  }

window._cached_parsed_ls_hash = {}

window.bind2ls = (athis, key, opt={})->
  local_storage_key = "#{athis.name}.#{key}"
  value = null
  if !value = _cached_parsed_ls_hash[local_storage_key]
    if stored_value_json = localStorage.getItem(local_storage_key)
      try
        value = JSON.parse stored_value_json
      catch err
        perr err
        # nothing
    
    if opt.value_preprocess
      value = opt.value_preprocess value
  
  _cached_parsed_ls_hash[local_storage_key] = value
  Object.assign {}, opt, {
    value
    on_change : (arg_value)->
      _cached_parsed_ls_hash[local_storage_key] = arg_value
      value = arg_value
      if opt.value_preprocess
        # deep clone
        value = JSON.parse JSON.stringify value
        value = opt.value_preprocess value
      localStorage.setItem local_storage_key, JSON.stringify value
      opt.on_change? arg_value
      athis.force_update()
  }

window.load_ls = (athis, key)->
  local_storage_key = "#{athis.name}.#{key}"
  return if !stored_value_json = localStorage.getItem(local_storage_key)
  if !value = _cached_parsed_ls_hash[local_storage_key]
    try
      value = JSON.parse stored_value_json
    catch err
      perr err
  
  value

window.save_ls = (athis, key, value, opt={force_update:true})->
  local_storage_key = "#{athis.name}.#{key}"
  _cached_parsed_ls_hash[local_storage_key] = value
  if value == undefined
    localStorage.removeItem local_storage_key
  else
    localStorage.setItem local_storage_key, JSON.stringify value
  
  if opt.force_update
    athis.force_update()
  return

window.bind2direct = (athis, key, opt={})->
  Object.assign {}, opt, {
    value     : athis[key]
    on_change : (value)->
      athis[key] = value
      athis.force_update()
      opt.on_change?(value)
  }
