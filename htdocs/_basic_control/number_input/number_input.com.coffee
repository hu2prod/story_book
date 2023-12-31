module.exports =  
  text  : ""
  mount : ()->
    @set_text @props
    @force_update()
    return
  
  mount_done : ()->
    @props.ref_cb? @refs.element
    if @props.autofocus
      @refs.element.focus()
  
  render : ()->
    style = {
      boxSizing: "border-box"
    }
    if @props.style
      obj_set style, @props.style
    # WARNING эта хуйня не понимает нормально точку
    input obj_set {}, @props, {
      ref         : "element"
      id          : @props.id
      class       : @props.class
      style       : style
      disabled    : @props.disabled
      tabIndex    : @props.tab_index
      
      type        : "number"
      value       : @text
      on_change   : @on_change
      pattern     : @props.pattern ? "-?[0-9]*([\.,][0-9]*)?"
      on_key_press: (event)=>
        if event.nativeEvent.which == 13 # ENTER
          @props.on_enter?(event)
        @props.on_key_press?(event)
        return
    }
  
  props_change : (props)->
    return if props.value == @props.value
    return if props.value == parseFloat @text
    @set_text props
    
  set_text : (props)->
    if props.value?
      if isNaN props.value
        @text = ""
        return
      @text = props.value.toString()
    else
      @text = ""
    return
  
  on_change : (event)->
    value = event.target.value
    num_value = parseFloat value
    # Внезапно, браузер не всегда корректно обрабатывает
    if @props.min? and @props.max?
      return unless @props.min <= num_value <= @props.max
    
    @text = value
    @force_update()
    if @props.can_empty and value == ""
      @props.on_change(num_value)
      return
    
    return if isNaN num_value
    @props.on_change?(num_value)
    return
