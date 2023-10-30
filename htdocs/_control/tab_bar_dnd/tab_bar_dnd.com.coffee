module.exports =
  hover_item : null
  
  draggable_item : null
  draggable_item_start_idx : 0
  
  hover_timer : null
  hover_update : ()->
    if @hover_timer
      clearTimeout @hover_timer
    @hover_timer = setTimeout ()=>
      @force_update()
      @hover_timer = null
    , 0
  
  render : ()->
    style = {}
    if @props.center
      style.textAlign = "center"
    obj_set style, @props.style
    div {
      class : "tab_dnd"
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
        
        show = undefined
        show = false if @draggable_item
        for v, idx in list
          do (v, idx)=>
            # TODO better design
            Tooltip {
              show : show
              mount_point_y : "bottom"
              position_y : "top"
              mount_point_x : "left"
              position_x : "right"
              tooltip_render : ()=>
                div {
                  style:
                    border : "1px solid #000"
                    borderRadius : 3
                    backgroundColor : "#fff"
                    padding : 2
                    height : 13+2+2
                }, v.hover_title
            }
              class_name = ""
              class_name = "hover"      if v == @hover_item
              class_name = "active"     if v.value == @props.value
              class_name = "drag_start" if v == @draggable_item
              class_name += " button"
              span {
                class : class_name
                on_click: ()=>@props.on_change v.value
                
                # prevent conflict with draggable
                on_hover : (e)=>
                  @hover_item = v
                  @hover_update()
                
                on_mouse_out : (e)=>
                  @hover_item = null
                  @hover_update()
                
                on_mouse_down : (e)=>
                  @props.on_mouse_down? e, v.value
                
                draggable : true
                onDragStart : ()=>
                  v.drag_start = true
                  @draggable_item = v
                  @draggable_item_start_idx = idx
                  
                  @force_update()
                
                onDrop : (e)=>
                  return if !@draggable_item
                  # А обязательно ли?
                  e.preventDefault()
                  
                  delete @draggable_item.drag_start
                  start_idx = @draggable_item_start_idx
                  
                  end_idx = idx - 1
                  @props.list.remove_idx @draggable_item_start_idx
                  @props.list.insert_after end_idx, @draggable_item
                  @draggable_item = null
                  
                  @props.on_change_list_order @props.value
                  @force_update()
                
                onDragOver : (e)=>
                  # TODO rework if I want accept d'n'd from other sources
                  return if !@draggable_item
                  e.preventDefault()

                  false
                
                onDragEnd : ()=>
                  @draggable_item = null
                  @force_update()
                
                style : btn_style
              }, v.title ? (if v.value?.toString then v.value.toString() else null) ? ""
  