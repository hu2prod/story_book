module.exports =
  mount_done : ()->
    @props.ref_cb? @refs.element
    if @props.autofocus
      pos = (@props.value ? "").length
      if @props.autofocus_all
        @refs.element.setSelectionRange 0, pos
      else
        @refs.element.setSelectionRange pos, pos
      @refs.element.focus()
  
  render : ()->
    style = {
      boxSizing: "border-box"
    }
    if @props.style
      obj_set style, @props.style
    input obj_set {}, @props, {
      ref         : "element"
      id          : @props.id
      class       : @props.class
      style       : style
      disabled    : @props.disabled
      tabIndex    : @props.tab_index
      
      type        : "text"
      value       : @props.value ? ""
      on_change   : @on_change
      tabIndex    : @props.tab_index
      on_key_press: (event)=>
        if event.nativeEvent.which == 13 # ENTER
          @props.on_enter?(event)
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
