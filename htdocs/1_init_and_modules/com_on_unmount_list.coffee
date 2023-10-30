window.com_on_unmount_list = (com)->
  com.on_unmount_list ?= []
  com.unmount_default ?= ()->
    @is_mounted = false
    for v in com.on_unmount_list
      v()
    return
    
  com.is_mounted ?= true
  com.unmount ?= com.unmount_default
  return
