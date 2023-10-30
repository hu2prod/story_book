module.exports =
  render : ()->
    if !list = @props.list
      list = []
      # alternative
      for k,v of @props.hash or {}
        list.push {value: k, title: v}
    
    value = @props.value ? []
    div {
      id        : @props.id
      class     : @props.class
      style     : @props.style
      disabled  : @props.disabled
      
      onFocus     : ()=>@props.on_focus?()
      onBlur      : ()=>@props.on_blur?()
      on_hover    : ()=>@props.on_hover?()
      on_mouse_out: ()=>@props.on_mouse_out?()
    }
      for v in list
        do (v)=>
          title = v.title ? (if v.value?.toString then v.value.toString() else null) ? ""
          div
            Checkbox {
              value : value.has v.value
              label : v.title
              on_change : (new_present)=>
                if new_present
                  value.push v.value
                else
                  value.remove v.value
                
                @force_update()
                @props.on_change value
              style :
                cursor : "pointer"
            }
  
