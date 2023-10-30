# NOTE original db_mixin were lost in HDD RAID
window.db_mixin = (athis, model_name)->
  athis.get = (id, cb)->
    loc_opt = {
      switch : "#{model_name}_get"
      id
    }
    await wsrs_back.request loc_opt, defer(err, db_res); return cb err if err
    if !db_res.res
      return cb null, null
    
    ret = new athis
    obj_set ret, db_res.res
    cb null, ret
  
  athis.list = (opt, cb)->
    loc_opt =
      switch : "#{model_name}_list"
      offset : opt.offset
      limit  : opt.limit
      order_rev : opt.order_rev
      where : opt.where
    
    await wsrs_back.request loc_opt, defer(err, db_res); return cb err if err
    
    ret = []
    for v in db_res.list
      ret.push loc = new athis
      obj_set loc, v
    
    if ret.length
      if ret[0].id?
        if opt.order_rev
          ret.sort (a,b)->-(a.id - b.id)
        else
          ret.sort (a,b)->a.id - b.id
    
    ret.total_count = db_res.total_count
    cb null, ret
  
  athis.prototype._fill_field_list = (loc_opt, field_list)->
    if field_list.length == 0
      for k,v of @
        continue if k[0] == "_"
        continue if typeof v == "function"
        loc_opt[k] = v
    else
      for field in field_list
        loc_opt[field] = @[field]
    return
  
  athis.prototype.save = (field_list, cb)->
    if !@id
      loc_opt =
        switch : "#{model_name}_create"
      @_fill_field_list loc_opt, []
      await wsrs_back.request loc_opt, defer(err, db_res); return cb err if err
      @id = db_res.id
    else
      loc_opt =
        switch: "#{model_name}_update"
        id    : @id
      @_fill_field_list loc_opt, field_list
      await wsrs_back.request loc_opt, defer(err, db_res); return cb err if err
    
    cb null
  
  athis.prototype.delete = (cb)->
    loc_opt =
      switch: "#{model_name}_delete"
      id    : @id
    
    await wsrs_back.request loc_opt, defer(err, db_res); return cb err if err
    
    cb null

window.db_mixin_constructor = (athis, model_name)->
  
