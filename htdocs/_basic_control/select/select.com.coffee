module.exports =
  render : ()->
    if !list = @props.list
      list = []
      # alternative
      for k,v of @props.hash or {}
        list.push {value: k, title: v}
    
    curr_value = null
    $list = []
    for v in list
      title = v.title ? (if v.value?.toString then v.value.toString() else null) ? ""
      # $list.push option {value:v.value}, title
      $list.push option {value:v.title}, title
      if v.value == @props.value
        curr_value = v.title
    
    select {
      id          : @props.id
      class       : @props.class
      style       : @props.style
      disabled    : @props.disabled
      tabIndex    : @props.tab_index
      
      value       : curr_value
      on_change   : @on_change
      
      onFocus     : ()=>@props.on_focus?()
      onBlur      : ()=>@props.on_blur?()
      on_hover    : ()=>@props.on_hover?()
      on_mouse_out: ()=>@props.on_mouse_out?()
    }, $list
    
  on_change : (event)->
    selected_value = event.target.value
    # suboptimal
    if @props.list
      for v in @props.list
        if v.title == selected_value
          @props.on_change v.value
          break
      
    else if @props.hash
      @props.on_change @props.hash[selected_value]
    
    return
