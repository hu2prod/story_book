window.wrap_once = (cb)->
  ()->
    old_cb = cb
    cb = null
    old_cb?()
