window.ws_mod_sub = (ws, wsrs)->
  ws.__sub_list = []
  ws.__sub_uid = 0
  ws.sub = (opt, handler)->
    sub_id = ws.__sub_uid++
    opt.sub.sub_id = sub_id
    opt.unsub.sub_id = sub_id
    
    ws.on "data", opt.handler = (data)->
      return if data.switch != opt.switch
      handler data
    
    if !ws.__sub_list.has opt
      ws.__sub_list.push opt
      wsrs.request clone(opt.sub), (err, data)->
        perr err if err
        opt.on_sub? err, data
    
    ()->
      ws.unsub opt, handler
  
  ws.unsub = (opt)->
    ws.off "data", opt.handler
    
    ws.__sub_list.remove opt
    wsrs.request clone(opt.unsub), (err)->perr err if err
    return
  
  ws.on "reconnect", ()->
    for opt in ws.__sub_list
      ws.send opt.sub
    return
  return

window.simple_sub_endpoint = (com, switch_key, on_refresh, sub_extra)->
  # TODO move this to webcom
  com.on_unmount_list ?= []
  com.unmount_default = ()->
    @is_mounted = false
    for v in com.on_unmount_list
      v()
    return
    
  com.is_mounted = true
  # 1-я строчка валидна для "внутри webcom". А после же происходит изменение
  # com.unmount ?= com.unmount_default
  com.componentWillUnmount ?= com.unmount_default
  
  loc_opt = {
    sub   : switch : "#{switch_key}_sub"
    unsub : switch : "#{switch_key}_unsub"
    switch: "#{switch_key}_stream"
  }
  if sub_extra
    obj_set loc_opt.sub, sub_extra
    obj_set loc_opt.unsub, sub_extra
  
  com.on_unmount_list.push ws_back.sub loc_opt, (data)=>
    if com.is_mounted
      if data.error
        perr stream_ep, data.error
      else
        on_refresh data.res
    return

