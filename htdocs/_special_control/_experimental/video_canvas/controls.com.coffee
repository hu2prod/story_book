module.exports =
  controller : null
  mount : ()->
    @controller = new Video_canvas_controls_controller
  
  render : ()->
    @controller.props_update @props
    Canvas_multi {
      width       : @props.size_x
      height      : video_controls_sy
      layer_list  : ["fg"]
      resize_fix  : false
      canvas_cb   : (canvas_hash)=>
        @controller.canvas_controller canvas_hash
      gui         : @controller
      ref_textarea: ($textarea)=>
        @controller.$textarea = $textarea
        @controller.init()
    }
