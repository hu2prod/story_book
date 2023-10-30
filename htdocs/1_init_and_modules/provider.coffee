class window.Provider
  value : {}
  key_sub_list_hash : {}
  
  constructor:()->
    @value = {}
    @key_sub_list_hash = {}
  
  alloc : (key)->
    @key_sub_list_hash[key] = null
    @value[key] = null
  
  set : (key, value)->
    if typeof value != "object"
      return if @value[key] == value
    @value[key] = value
    
    for fn in @key_sub_list_hash[key] ? []
      try
        fn(value)
      catch err
        perr err
    return
  
  bind : (com, key, on_update)->
    # can be customized
    on_update ?= (value)->
      com[key] = value
      com.force_update()
    
    com_on_unmount_list com
    com[key] = @value[key]
    
    @key_sub_list_hash[key] ?= []
    @key_sub_list_hash[key].push on_update
    com.on_unmount_list.push ()=>
      @key_sub_list_hash[key].remove on_update
    return
