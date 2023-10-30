window.ws_mk_sub = (ws)->
  ws.sub_hash = {}
  ws.on "data", (data)->
    return if !reg_ret = /^feed_(.*)$/.exec data.switch
    [skip, channel] = reg_ret
    return if !handler_list = ws.sub_hash[channel]
    for fn in handler_list
      try
        fn data
      catch err
        perr err
    return
    
  ws.on "reconnect", ()->
    for channel of ws.sub_hash
      ws.send {
        switch : "subscribe"
        channel
      }
    return

Websocket_wrap.prototype.sub = (channel, handler)->
  if !handler_list = @sub_hash[channel]
    handler_list = @sub_hash[channel] = []
    @send {
      switch : "subscribe"
      channel
    }
  handler_list.upush handler

Websocket_wrap.prototype.unsub = (channel, handler)->
  return if !handler_list = @sub_hash[channel]
  handler_list.remove handler
  if handler_list.length == 0
    setTimeout ()=>
      if handler_list = @sub_hash[channel]
        return if handler_list.length != 0
      @send {
        switch : "unsubscribe"
        channel
      }
      delete @sub_hash[channel]
    , 1000
  return
