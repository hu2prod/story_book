class window.Pie_chart_controller
  com       : null
  value     : null
  $canvas_fg: null
  legend_position : null
  angle_shift: -Math.PI/2
  
  hover_idx : -1
  # circle center
  _last_cx  : 0
  _last_cy  : 0
  # legend
  _last_lx  : 0
  _last_ly  : 0
  _last_lsx : 0
  _last_lsy : 0
  # other border
  _last_lx2 : 0
  _last_ly2 : 0
  _last_angle_list : []
  
  legend_in_pad : 10
  legend_item_sy: 20
  percent_precision : 0
  
  canvas_controller: (canvas_hash)->
    if canvas_hash.fg
      return if !@$canvas_fg = $canvas_fg = canvas_hash.fg
      @redraw_panel_fg()
    
    return
  
  animation_loop : true
  init: ()->
    do ()=>
      while @animation_loop
        await requestAnimationFrame defer()
        try
          @redraw_panel_fg()
        catch err
          perr err
      return
    return
  
  delete : ()->
    @animation_loop = false
  
  # ###################################################################################################
  #    fg
  # ###################################################################################################
  has_redraw_changes_fg: true
  
  redraw_panel_fg : ()->
    return if !@has_redraw_changes_fg
    @has_redraw_changes_fg = false
    
    return if !@$canvas_fg
    canvas = @$canvas_fg
    ctx = canvas.getContext "2d"
    # WTF clear
    size_x = canvas.width  = canvas.width
    size_y = canvas.height = canvas.height
    
    return if !@value
    {value} = @
    
    sum = 0
    for v in value
      sum += v.value
    
    circle_x_legend_offset = 0
    {hover_idx} = @
    
    hover_opacity = 0.3
    
    # ###################################################################################################
    #    Legend parse
    # ###################################################################################################
    {
      legend_position
      legend_in_pad
      legend_item_sy
      percent_precision
    } = @
    legend_out_pad = 10
    
    legend_item_font_size = 16
    
    legend_rect_size = legend_item_font_size
    legend_rect_pad  = 5
    
    lsx = 0
    ctx.font = "#{legend_item_font_size}px monospace"
    text_list = []
    
    max_size = 0
    percent_list = []
    for v in value
      percent_list.push percent = (v.value/sum*100).toFixed percent_precision
      max_size = Math.max max_size, percent.length
    
    for v, idx in value
      percent = percent_list[idx]
      text_list.push text = "#{percent.rjust max_size}% #{v.name}"
      lsx = Math.max lsx, ctx.measureText(text).width
    lsx += 2*legend_in_pad + legend_rect_size + legend_rect_pad
    
    # lsy = legend_item_sy*value.length + 2*legend_in_pad
    lsy = legend_item_sy*value.length + legend_in_pad # kinda magic
    
    
    lx = legend_out_pad
    if /L/i.test legend_position
      lx = legend_out_pad
      circle_x_legend_offset = lsx + 2*legend_out_pad
    else if /R/i.test legend_position
      lx = size_x - lsx - legend_out_pad
      circle_x_legend_offset = -lsx - 2*legend_out_pad
    else
      perr "invalid legend_position LR"
    
    ly = legend_out_pad
    if /U/i.test legend_position
      ly = legend_out_pad
    else if /D/i.test legend_position
      ly = size_y - lsy - legend_out_pad
    else
      perr "invalid legend_position UD"
    
    # ###################################################################################################
    #    circle
    # ###################################################################################################
    {angle_shift} = @
    cx = (size_x+circle_x_legend_offset)/2
    cy = size_y/2
    
    r = Math.min(size_x-lsx-2*legend_out_pad,size_y)/2
    
    mult = Math.PI * 2 / sum
    
    ctx.globalAlpha = if hover_idx == -1 then 1 else hover_opacity
    
    angle_list = [0]
    last_angle = angle_shift
    for v, idx in value
      ctx.globalAlpha = if hover_idx == -1 then 1 else (if idx == hover_idx then 1 else hover_opacity)
      next_angle = last_angle + v.value * mult
      angle_list.push next_angle - angle_shift
      
      ctx.fillStyle = v.color
      ctx.beginPath()
      ctx.moveTo cx, cy
      ctx.arc cx, cy, r, last_angle, next_angle, false
      ctx.lineTo cx, cy
      ctx.fill()
      last_angle = next_angle
    
    # ###################################################################################################
    #    Legend draw
    # ###################################################################################################
    ctx.globalAlpha = 1
    ctx.lineStyle = "#000"
    ctx.strokeRect 0.5+lx, 0.5+ly, lsx, lsy
    
    ctx.globalAlpha = if hover_idx == -1 then 1 else hover_opacity
    
    x = lx + legend_in_pad
    y = ly + legend_in_pad + legend_item_sy/2 - legend_rect_size + legend_item_font_size/4 # kinda magic const
    for v, idx in value
      ctx.globalAlpha = if hover_idx == -1 then 1 else (if idx == hover_idx then 1 else hover_opacity)
      ctx.fillStyle = v.color
      ctx.fillRect x, y, legend_rect_size, legend_rect_size
      y += legend_item_sy
    
    ctx.globalAlpha = if hover_idx == -1 then 1 else hover_opacity
    
    ctx.fillStyle = "#000"
    x = lx + legend_in_pad + legend_rect_size + legend_rect_pad
    y = ly + legend_in_pad + legend_item_sy/2 # WTF?
    for v, idx in value
      ctx.globalAlpha = if hover_idx == -1 then 1 else (if idx == hover_idx then 1 else hover_opacity)
      text = text_list[idx]
      ctx.fillText text, x, y
      y += legend_item_sy
    
    # ###################################################################################################
    @_last_cx = cx
    @_last_cy = cy
    @_last_r  = r
    
    @_last_lx = lx
    @_last_ly = ly
    
    @_last_lsx = lsx
    @_last_lsy = lsy
    
    @_last_lx2 = lx+lsx
    @_last_ly2 = ly+lsy
    @_last_angle_list = angle_list
    
    return
  
  # ###################################################################################################
  refresh: (layer_name = "all")->
    switch layer_name
      when "fg"
        @has_redraw_changes_fg = true
      when "all"
        @has_redraw_changes_fg = true
    
    return
  
  # ###################################################################################################
  #    hover
  # ###################################################################################################
  
  mouse_move : (event)->
    {x,y} = rel_mouse_coords event
    {
      _last_lx
      _last_ly
      _last_lx2
      _last_ly2
    } = @
    new_hover_idx = -1
    if (_last_lx < x < _last_lx2) and (_last_ly < y < _last_ly2)
      {
        legend_item_sy
      } = @
      ty = y - _last_ly - @legend_in_pad
      for idx in [0 ... @value.length] by 1
        if 0 < ty <= legend_item_sy
          new_hover_idx = idx
          break
        ty -= legend_item_sy
    else
      {
        _last_cx
        _last_cy
        _last_r
        _last_angle_list
      } = @
      dx = (x - _last_cx)
      dy = (y - _last_cy)
      if dx*dx + dy*dy < _last_r*_last_r
        if dx or dy
          check_angle = Math.atan2 dy, dx
          check_angle -= @angle_shift
          check_angle += 2*Math.PI if check_angle < 0
          last_angle = _last_angle_list[0] # must be 0
          for idx in [1 ... _last_angle_list.length] by 1
            end_angle = _last_angle_list[idx]
            if last_angle < check_angle <= end_angle
              new_hover_idx = idx-1
              break
            last_angle = end_angle
    
    if @hover_idx != new_hover_idx
      @hover_idx = new_hover_idx
      @has_redraw_changes_fg = true
    return
  