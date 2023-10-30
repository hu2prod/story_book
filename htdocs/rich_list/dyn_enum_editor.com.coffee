module.exports =
  state :
    add_is_active : false
    add_title     : ""
    add_is_saving : false
    order_is_saving : false
    draggable_item : null
    draggable_item_start_idx : null
  
  on_create : ()->
    # Dumb check
    new_value = @state.add_title
    new_value_check = new_value.toLowerCase()
    list  = @props.filter.value_list ? []
    for v in list
      if v.title.toLowerCase() == new_value_check
        alert "Possible duplicate #{v.title} == #{new_value}"
        return
    
    {blueprint} = @props.filter
    delete blueprint.cached_list
    new_instance = new blueprint
    new_instance.title = new_value
    new_instance.order = list.length
    @set_state add_is_saving : true
    await new_instance.save [], defer(err);
    if err
      @set_state add_is_saving : false
      throw err
    
    await dyn_enum_filter_load @props.filter, defer(err, found); throw err if err
    
    @set_state {
      add_is_active : false
      add_is_saving : false
    }
    @force_update()
  
  list_reorder : ()->
    @set_state order_is_saving : true
    for value, expected_order in @props.filter.value_list
      {db_ent} = value
      if db_ent.order != expected_order
        db_ent.order = expected_order
        await db_ent.save ["order"], defer(err); throw err if err
    
    @set_state order_is_saving : false
  
  render : ()->
    value = @props.value ? []
    list  = @props.filter.value_list ? []
    table {
      class     : "table_layout"
      style     : obj_set {
        width         : "100%"
      }, @props.style ? {}
    }
      tbody
        for v, v_idx in list
          do (v, v_idx)=>
            title = v.title or (if typeof v.value == "string" then v.value else null) or ""
            backgroundColor = undefined
            backgroundColor = "#ffc" if v._hover
            backgroundColor = "#fcf" if v._drag_start
            tr {
              style:
                height : 25 # prevent jump on hover
                # NOTE .selected not applicable to table_layout, only to table
                backgroundColor : backgroundColor
              on_hover : ()=>
                v._hover = true
                await setTimeout defer(), 1
                @force_update()
              on_mouse_out : ()=>
                v._hover = false
                await setTimeout defer(), 1
                @force_update()
              
              draggable : true
              onDragStart : (e)=>
                v._drag_start = true
                @set_state {
                  draggable_item           : v
                  draggable_item_start_idx : v_idx
                }
              onDrop : (e)=>
                return if !@state.draggable_item
                e.preventDefault()
                delete @state.draggable_item._drag_start
                
                start_idx = @state.draggable_item_start_idx
                end_idx   = v_idx - 1
                list.remove_idx @state.draggable_item_start_idx
                list.insert_after end_idx, @state.draggable_item
                @list_reorder()
              onDragOver : (e)=>
                return if !@state.draggable_item
                # hacky
                for v2 in list
                  v2._hover = false
                v._hover = true
                @force_update()
                
                e.preventDefault()
                false
              onDragEnd : (e)=>
                @set_state draggable_item : null
            }
              on_change = ()=>
                new_present = !value.has v.value
                if new_present
                  value.push v.value
                else
                  value.remove v.value
                
                @force_update()
                @props.on_change value
              td {
                style:
                  width : 20
              }
                Checkbox {
                  value : value.has v.value
                  on_change : on_change
                  style :
                    cursor : "pointer"
                }
              td
                if v._edit
                  Text_input {
                    value : v._title
                    autofocus : true
                    on_change : (new_value)=>
                      v._title = new_value
                      @force_update()
                    on_key_down : (event)=>
                      if event.nativeEvent.which == 27 # ESC
                        v._edit = false
                        @force_update()
                      return
                    on_enter : ()=>
                      v.db_ent.title = v._title
                      await v.db_ent.save ["title"], defer(err); throw err if err
                      
                      await dyn_enum_filter_load @props.filter, defer(err, found); throw err if err
                      @force_update()
                    style:
                      width : "100%"
                  }
                else
                  span {
                    # on_click : on_change
                    style :
                      cursor : "pointer"
                  }, v.title
              td {
                style:
                  width     : 70
                  textAlign : "right"
              }
                Button {
                  label : "edit"
                  on_click : ()=>
                    v._edit = !v._edit
                    v._title= v.title
                    @force_update()
                  style:
                    cursor: "pointer"
                    display: if v._hover then undefined else "none"
                }
                Button {
                  label : "x"
                  on_click : ()=>
                    return if !confirm("Are you sure that you want delete '#{v.title}'?")
                    
                    v.db_ent.deleted = true
                    await v.db_ent.save ["deleted"], defer(err); throw err if err
                    
                    await dyn_enum_filter_load @props.filter, defer(err, found); throw err if err
                    @force_update()
                  
                  style :
                    cursor: "pointer"
                    display: if v._hover then undefined else "none"
                    color : "#F00"
                }
        tr
          td {
            colSpan : 3
          }
            if !@state.add_is_active
              Button {
                label: "+"
                on_click : ()=>
                  @set_state add_is_active : !@state.add_is_active
                style:
                  width : "100%"
              }
            else
              div {
                style:
                  display: "flex"
              }
                Text_input bind2 @, "add_title", {
                  autofocus : true
                  on_key_down : (event)=>
                    if event.nativeEvent.which == 27 # ESC
                      @set_state {
                        add_is_active : false
                      }
                  on_enter : ()=>@on_create()
                  style:
                    width     : "100%"
                    boxSizing : "border-box"
                }
                if @state.add_is_saving or @state.order_is_saving
                  Spinner {}
