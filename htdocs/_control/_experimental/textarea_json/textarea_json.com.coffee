module.exports =
  str_value : "{}"
  mount_done : ()->
    @props.ref_cb? @refs.element
    @str_value = JSON.stringify @props.value, null, 2
    @force_update()
  
  render : ()->
    style = {
      boxSizing: "border-box"
    }
    if @props.style
      obj_set style, @props.style
    textarea {
      ref       : "element"
      id        : @props.id
      class     : @props.class
      style     : style
      disabled  : @props.disabled
      readOnly  : @props.readonly
      
      type        : "text"
      value       : @str_value or ""
      on_change   : @on_change
      placeholder : @props.placeholder
      cols        : @props.cols
      rows        : @props.rows
      
      onFocus     : ()=>@props.on_focus?()
      onBlur      : ()=>@props.on_blur?()
      on_hover    : ()=>@props.on_hover?()
      on_mouse_out: ()=>@props.on_mouse_out?()
      on_key_press: (event)=>
        @props.on_key_press?(event)
        return
      on_key_down: (event)=>
        @props.on_key_down?(event)
        return
    }
    
  on_change : (event)->
    str_value = event.target.value
    @str_value = str_value
    @force_update()
    try
      value = JSON.parse str_value
      @props.on_change value
    catch err
      if str_value == ""
        @props.on_change null
    
    return
