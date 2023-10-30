module.exports =
  render : ()->
    {view_type, view_type_list} = @props.data_controller
    div {
      style:
        whiteSpace: "nowrap"
    }
      # TODO icons-based control
      for v in view_type_list
        do (v)=>
          Button {
            label : v
            on_click : ()=>
              @props.data_controller.view_type = v
              @props.on_change()
            style :
              fontWeight : if view_type == v then "bold" else undefined
          }
