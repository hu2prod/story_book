module.exports =
  render : ()->
    obj = @props.value
    bind_obj = (key)=>
      {
        value : obj[key]
        on_change : (value)=>
          obj[key] = value
          @props.on_change obj
          @force_update()
          return
      }
    
    x1 = obj.x
    y1 = obj.y
    x2 = obj.x + obj.size_x
    y2 = obj.y + obj.size_y
    craft_box = ()=>
      min_x = Math.min x1, x2
      max_x = Math.max x1, x2
      min_y = Math.min y1, y2
      max_y = Math.max y1, y2
      
      obj.x     = min_x
      obj.y     = min_y
      obj.size_x= max_x - min_x
      obj.size_y= max_y - min_y
      
      @props.on_change obj
      @force_update()
      return
    
    label_style = {
      style :
        width: 70
        textAlign: "right"
    }
    
    ni_style = {
      style:
        width: 70
    }
    
    table {class: "table"}
      tbody
        tr
          td {colSpan:2, style:textAlign:"center"}
            b "Box parameters"
        tr
          td label_style, "x"
          td Number_input ni_style, bind_obj "x"
        tr
          td label_style, "y"
          td Number_input ni_style, bind_obj "y"
        tr
          td label_style, "size_x"
          td Number_input ni_style, bind_obj "size_x"
        tr
          td label_style, "size_y"
          td Number_input ni_style, bind_obj "size_y"
        tr
          td {colSpan:2, style:textAlign:"center"}
            b "Corner points"
        tr
          td label_style, "x1"
          td Number_input ni_style, {value:x1, on_change: (value)=>x1=value;craft_box()}
        tr
          td label_style, "y1"
          td Number_input ni_style, {value:y1, on_change: (value)=>y1=value;craft_box()}
        tr
          td label_style, "x2"
          td Number_input ni_style, {value:x2, on_change: (value)=>x2=value;craft_box()}
        tr
          td label_style, "y2"
          td Number_input ni_style, {value:y2, on_change: (value)=>y2=value;craft_box()}
        tr
          td {colSpan:2, style:textAlign:"center"}
            Button {
              label: "Image refresh"
              on_click : ()=>@props.on_refresh()
              style:
                width: "100%"
                height: 50
            }
        tr
          td {colSpan:2, style:textAlign:"center"}
            img {
              src : @props.capture_url
              style:
                maxWidth : 70+70
                maxHeight: 200
            }
        tr
          td {colSpan:2, style:textAlign:"center"}
            Button {
              label: "Capture"
              on_click : ()=>@props.on_capture()
              style:
                width : "100%"
                height: 50
            }
