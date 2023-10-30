module.exports =
  hover_item_idx : -1
  on_change_hover : ()->
    for v, idx in @props.data_controller.filtered_list
      el = @refs.tbody.children[idx+1]
      value = v.hover or v.selected or v.idx == @hover_item_idx
      real_value = el.classList.contains "selected"
      continue if real_value == value
      if value
        el.classList.add "selected"
      else
        el.classList.remove "selected"
    return
  
  on_hover : (item)->
    @hover_item_idx = item.idx
    @on_change_hover()
    
    @props.on_hover_item item
  
  render : ()->
    filter_list = []
    for filter in @props.data_controller.filter_descriptor_list
      continue if !filter.display
      filter_list.push filter
    
    default_renderer = (t, col)=>
      Text_cut {
        value : t[col.name]
      }
    col_list = @props.col_list ? [
      {
        name : "title"
      }
    ]
    
    div {
      ref : "parent"
      on_mouse_out : ()=>
        @hover_item_idx = -1
        @on_change_hover()
        
        @props.on_hover_item null
        return
      style:
        width : "100%"
    }
      {view_type} = @props.data_controller
      
      switch view_type
        when "table"
          table {
            class: "table"
            style:
              width : "100%"
          }
            tbody {ref:"tbody"}
              tr
                th {
                  style:
                    width : 30
                }, "#"
                for col in col_list
                  th col.name
                # хуевая идея, надо какой-то ограниченный filter
                for filter in filter_list
                  th filter.title
              for v in @props.data_controller.filtered_list
                do (v)=>
                  tr {
                    class : if v.hover or v.selected or v.idx == @hover_item_idx then "selected" else undefined
                    style:
                      height: 28 # fix for vertical subpixel issue
                    on_hover : ()=>@props.on_hover_item v
                    on_click : ()=>@props.on_select_item v
                  }
                    # TODO remove later
                    td {style:textAlign: "right"}, v.idx+1
                    for col in col_list
                      fn = col.renderer ? default_renderer
                      td fn v, col
                    for filter in filter_list
                      td v.attr_hash[filter.key]
        
        when "widget"
          for v in @props.data_controller.filtered_list
            do (v)=>
              div {
                class : if v.hover or v.selected or v.idx == @hover_item_idx then "selected" else undefined
                on_hover : ()=>@props.on_hover_item v
                on_click : ()=>@props.on_select_item v
                style :
                  width : "100%"
                  height: 100
                  border : "1px solid #aaa"
                  marginBottom : -1 # border intersection
              }
                for col in col_list
                  fn = col.renderer ? default_renderer
                  div fn v, col
                for filter in filter_list
                  div {
                    style:
                      float: "left"
                      paddingRight : 3
                  }
                    span {
                      style:
                        color: "#aaa"
                    }, "#{filter.title}:  "
                    span v.attr_hash[filter.key]
        
        when "tile"
          for v in @props.data_controller.filtered_list
            do (v)=>
              div {
                class : if v.hover or v.selected or v.idx == @hover_item_idx then "selected" else undefined
                on_hover : ()=>@props.on_hover_item v
                on_click : ()=>@props.on_select_item v
                style :
                  width : 140
                  height: 140
                  float : "left"
                  border : "1px solid #aaa"
                  # marginBottom : -1 # border intersection
                  marginRight  : 10
                  marginBottom : 10
              }
                for col in col_list
                  fn = col.renderer ? default_renderer
                  div fn v, col
                for filter in filter_list
                  div {
                    style:
                      float: "left"
                      paddingRight : 3
                  }
                    span {
                      style:
                        color: "#aaa"
                    }, "#{filter.title}:  "
                    span v.attr_hash[filter.key]