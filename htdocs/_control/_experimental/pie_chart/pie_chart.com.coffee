module.exports =
  mount : ()->
    @controller = new Pie_chart_controller
    @controller.com = @
    @controller.value = @props.value
    @controller.legend_position = @props.legend_position ? "RD"
  
  unmount : ()->
    @controller.delete()
  
  props_change : (new_props)->
    if new_props.value != @props.value
      @controller.value = new_props.value
      @controller.has_redraw_changes_fg = true
    
    @controller.legend_position = @props.legend_position ? "RD"
    @controller.refresh()
  
  render : ()->
    size_x = @props.width  ? @props.size_x
    size_y = @props.height ? @props.size_y
    Canvas_multi {
      width       : size_x
      height      : size_y
      layer_list  : ["fg"]
      resize_fix  : true
      canvas_cb   : (canvas_hash)=>
        @controller?.canvas_controller canvas_hash
      gui         : @controller
      
      textarea    : @props.textarea
      ref_textarea: ($textarea)=>
        if @$textarea != $textarea
          @$textarea = $textarea
          @force_update()
        
        @controller?.$textarea = $textarea
        @controller?.init()
    }
