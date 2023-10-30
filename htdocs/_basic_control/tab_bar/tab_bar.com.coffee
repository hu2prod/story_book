module.exports =
  render : ()->
    style = {}
    if @props.center
      style.textAlign = "center"
    obj_set style, @props.style
    div {
      class : "tab"
      style : style
    }
      # BUG
      # style = if @props.center then {margin:"0 auto"} else {}
      style     = if @props.center then {margin:"0 auto"} else {};
      btn_style = if @props.center then {paddingTop: "4"} else {float:"left"};
      obj_set btn_style, @props.btn_style if @props.btn_style
      div {style}
        if !list = @props.list
          list = []
          # alternative
          for k,v of @props.hash or {}
            list.push {value: k, title: v}
        
        for v in list
          do (v)=>
            # TODO better design
            Button {
              class : if @props.value == v.value then "active" else ""
              label : v.title ? (if v.value?.toString then v.value.toString() else null) ? ""
              on_click: ()=>@props.on_change v.value
              on_mouse_down : (e)=>
                @props.on_mouse_down? e, v.value
              style : btn_style
            }
  