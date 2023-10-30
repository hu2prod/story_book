window.dyn_enum_load = (config_autogen, cb)->
  found = false
  for field in config_autogen.editor_field_list
    continue if !/^dyn_enum_/.test field.type
    found = true
    break
  
  if found
    await
      for field in config_autogen.editor_field_list
        continue if !/^dyn_enum_/.test field.type
        
        key = field.name
        if !filter = config_autogen.filter_key_to_filter_descriptor_hash[key]
          config_autogen.filter_descriptor_list.push filter = {
            key: key
            selected_value_list : []
            value_list          : []
            multi : true
            blueprint : window[field.type.capitalize()]
          }
          config_autogen.filter_key_to_filter_descriptor_hash[key] = filter
          if !filter.blueprint
            perr "WARNING. Missing table #{field.type.capitalize()}"
        
        continue if !filter.blueprint
        dyn_enum_filter_load filter, defer()
  cb null, found

window.dyn_enum_filter_load = (filter, cb)->
  {blueprint} = filter
  if !blueprint.cached_list
    await blueprint.list {}, defer(err, db_res);
    if err
      perr err
    else
      blueprint.cached_list = db_res
  
  if blueprint.cached_list
    filter.value_list.clear()
    list = blueprint.cached_list.clone()
    list.sort (a,b)->
      (a.order - b.order) or
      (a.id-b.id)
    for v in list
      continue if v.deleted
      filter.value_list.push {
        title : v.title
        value : v.id
        db_ent: v
      }
  cb()
  