module.exports =
  mount_done : ()->
    @props.ref_cb? @refs.element
  
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
      tabIndex  : @props.tab_index
      readOnly  : @props.readonly
      
      type        : "text"
      value       : @props.value or ""
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
    value = event.target.value
    @props.on_change(value)
    return
