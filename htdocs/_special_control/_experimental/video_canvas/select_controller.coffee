class window.Video_canvas_select_controller
  value: {}
  capture_url: ""
  video: null
  props: {}
  force_update : ()-> # replace me
  
  $canvas_fg: null
  $textarea : null
  
  event_mixin @
  constructor : ()->
    event_mixin_constructor @
    @value =
      x     : 0
      y     : 0
      size_x: 0
      size_y: 0
    
  
  init:()->
  
  refresh: ()->
    @has_redraw_changes_fg = true
  
  canvas_controller: (canvas_hash)->
    return if !@$canvas_fg = $canvas_fg = canvas_hash.fg
    @redraw_fg()
  
  props_update: (@props)->
    # TODO decide @has_redraw_changes_fg = true
  
  # ###################################################################################################
  #    fg
  # ###################################################################################################
  has_redraw_changes_fg: true
  
  redraw_fg: ()->
    return if !@has_redraw_changes_fg
    @has_redraw_changes_fg = false
    
    return if !@$canvas_fg
    canvas = @$canvas_fg
    ctx = canvas.getContext "2d"
    # WTF clear
    size_x = canvas.width  = canvas.width
    size_y = canvas.height = canvas.height
    
    if @value.size_x and @value.size_y
      ctx.strokeStyle = "#0F0"
      ctx.strokeRect @value.x+0.5, @value.y+0.5, @value.size_x, @value.size_y
    
    return
  
  # ###################################################################################################
  #    mouse
  # ###################################################################################################
  mouse_mode : "none" # none, draw, drag
  _mouse_down_start : null
  mouse_down : (event)->
    {x,y} = rel_mouse_coords event
    @old_mouse_move_x = x
    @old_mouse_move_y = y
    switch event.nativeEvent.which
      when 1 # Left
        @_mouse_down_start = {x,y}
        @mouse_mode = "draw"
      when 2 # wheel
        @_mouse_down_start = {x,y}
        @mouse_mode = "drag"
    return
  
  old_mouse_move_x : 0
  old_mouse_move_y : 0
  mouse_move : (event)->
    return if !@_mouse_down_start
    {x,y} = rel_mouse_coords event
    changed = false
    changed = true  if @old_mouse_move_x != x
    changed = true  if @old_mouse_move_y != y
    
    return if !changed
    
    @has_redraw_changes_fg = true
    switch @mouse_mode
      when "draw"
        start = @_mouse_down_start
        
        min_x = Math.min start.x, x
        max_x = Math.max start.x, x
        min_y = Math.min start.y, y
        max_y = Math.max start.y, y
        # can keep existing instance
        @value.x      = min_x
        @value.y      = min_y
        @value.size_x = max_x - min_x
        @value.size_y = max_y - min_y
      
      when "drag"
        @value.x += x - @old_mouse_move_x
        @value.y += y - @old_mouse_move_y
    
    @old_mouse_move_x = x
    @old_mouse_move_y = y
    @on_change @value
    
    return
  
  mouse_up : (event)->
    return if !@_mouse_down_start
    {x,y} = rel_mouse_coords event
    start = @_mouse_down_start
    @_mouse_down_start = null
    
    switch @mouse_mode
      when "draw"
        min_x = Math.min start.x, x
        max_x = Math.max start.x, x
        min_y = Math.min start.y, y
        max_y = Math.max start.y, y
        
        @value.x      = min_x
        @value.y      = min_y
        @value.size_x = max_x - min_x
        @value.size_y = max_y - min_y
        
      when "drag"
        "nothing"
    
    @on_change @value, 0
    return
  
  # ###################################################################################################
  #    handler
  # ###################################################################################################
  _capture_url_throttle : null
  on_change : (new_value, delay = 1000)->
    # puts "on_change", new_value
    obj_set @value, new_value
    @has_redraw_changes_fg = true
    
    if @video and @value.size_x and @value.size_y
      fn = ()=>
        rect = @video.getBoundingClientRect()
        zoom = @video.videoWidth/rect.width
        @capture_url = video_to_url @video, {
          x     : zoom*@value.x
          y     : zoom*@value.y
          size_x: zoom*@value.size_x
          size_y: zoom*@value.size_y
        }
        @dispatch "capture_url", @capture_url
        @force_update()
      @_capture_url_throttle = throttle @_capture_url_throttle, delay, fn
    
    @force_update()
    
    return
  