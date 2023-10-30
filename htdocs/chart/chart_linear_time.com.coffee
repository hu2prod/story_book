module.exports =
  mount : ()->
    @controller = new Chart_linear_time_controller
    @controller.com = @
    @controller.value = @props.value
    @controller.label_y = @props.label_y
    if @props.min_y?
      @controller.min_y = @props.min_y
  
  unmount : ()->
    @controller.delete()
  
  props_change : (new_props)->
    if new_props.value != @props.value
      @controller.value = new_props.value
      @controller.has_redraw_changes_fg = true
      @controller.has_redraw_changes_tooltip = true
    
    @controller.label_y = @props.label_y
    @controller.refresh()
  
  refresh : ()->
    @controller.refresh()
  
  render : ()->
    size_x = @props.width  ? @props.size_x ? @props.sx
    size_y = @props.height ? @props.size_y ? @props.sy
    Canvas_multi {
      width       : size_x
      height      : size_y
      layer_list  : ["fg", "tooltip"]
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
