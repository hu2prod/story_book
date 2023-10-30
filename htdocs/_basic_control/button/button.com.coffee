module.exports =
  mount_done : ()->
    if @props.autofocus
      @refs.element.focus()
  
  render : ()->
    button {
      ref       : "element"
      id        : @props.id
      class     : @props.class
      style     : @props.style
      disabled  : @props.disabled
      tabIndex  : @props.tab_index
      
      on_click  : @props.on_click
      on_hover  : @props.on_hover
      on_mouse_down : @props.on_mouse_down
      # on_blur   : ()=>@props.on_blur?()
      on_mouse_out: ()=>
        @props.on_mouse_out?()
        @props.on_blur?()
    }, @props.label