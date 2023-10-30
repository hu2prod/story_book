class window.Chart_linear_time_controller
  com       : null
  value     : null
  has_hover : false
  hover_x   : 0
  # hover_x_last: 0
  # hover_nearest_value: null
  $canvas_fg: null
  
  animation_in_progress : false
  animation_duration : 500
  animation_ts_start : 0
  old_value_check : []
  old_value_anim  : []
  anim_value : []
  # TODO point velocity (for better animation)
  
  # TODO рассчет всех промежуточных значений графика еще до requestAnimationFrame
  #   меньше latency на саму отрисовку
  # ###################################################################################################
  #    cached stuff between layers
  # ###################################################################################################
  line_color      : "#4682b4"
  tick_font_size  : 12
  
  x_scale     : ()->0
  y_scale     : ()->0
  x_scale_rev : ()->0
  x_format    : ()->0
  y_format    : ()->0
  
  # ###################################################################################################
  #    com
  # ###################################################################################################
  label_y : ""
  min_y   : null
  
  constructor : ()->
    @old_value_check  = []
    @old_value_anim   = []
    @anim_value = []
  
  canvas_controller: (canvas_hash)->
    if canvas_hash.fg
      return if !@$canvas_fg = $canvas_fg = canvas_hash.fg
      @redraw_panel_fg()
    if canvas_hash.tooltip
      return if !@$canvas_tooltip = $canvas_tooltip = canvas_hash.tooltip
      @redraw_panel_tooltip()
    
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
    return if !@value.length
    
    # ###################################################################################################
    #    prepare points with respect of animation
    # ###################################################################################################
    need_update = false
    if @old_value_check.length != @value.length
      need_update = true
    else
      for v,idx in @value
        old_v = @old_value_check[idx]
        if +v[0] != old_v[0] or v[1] != old_v[1]
          need_update = true
          break
    
    if need_update
      anim_value = []
      
      # for all old_value_anim copy from anim_value
      copy_idx = Math.min @old_value_anim.length, @value.length
      for idx in [0 ... copy_idx] by 1
        anim_value.push @anim_value[idx]
      
      for idx in [copy_idx ... @value.length] by 1
        v = @value[idx]
        anim_value.push [+v[0], v[1]]
      
      @anim_value = anim_value
      @old_value_anim.clear()
      for v in anim_value
        @old_value_anim.push [+v[0], v[1]]
      
      @old_value_check.clear()
      for v in @value
        @old_value_check.push [+v[0], v[1]]
      
      @animation_in_progress = true
      @animation_ts_start = Date.now()
    else
      anim_value = @anim_value
    
    if @animation_in_progress
      a = (Date.now() - @animation_ts_start) / @animation_duration
      if a > 1
        a = 1
        @animation_in_progress = false
      b = 1 - a
      for v_a, idx in anim_value
        v_o = @old_value_anim[idx]
        v_n = @value[idx]
        v_a[0] = a*v_n[0] + b*v_o[0]
        v_a[1] = a*v_n[1] + b*v_o[1]
      
      if @animation_in_progress
        @has_redraw_changes_fg = true
      else
        @old_value_anim.clear()
        for v in @anim_value
          @old_value_anim.push [+v[0], v[1]]
    
    # ###################################################################################################
    #    settings from prev impl
    # ###################################################################################################
    # left is more, because y axis values
    margin  = { top: 40, right: 40, bottom: 40, left: 40 }
    
    {
      line_color
      tick_font_size
    } = @
    axis_alpha_threshold_dist = 30
    
    tick_size     = 5
    tick_x_min_gap= 100
    tick_y_min_gap= 20
    tick_xi_rounding = 60*60*1000 # 1 h
    tick_yi_rounding = 10
    tick_to_text_gap = 5
    tick_label_offset_x = -20
    tick_label_offset_y = -2
    
    tick_x_label_gap = tick_font_size
    
    # ###################################################################################################
    #    scale coef. Only linear supported for now
    # ###################################################################################################
    xi_min = +anim_value[0][0]
    xi_max = +anim_value.last()[0]
    
    # prevent xi_range == 0
    if xi_min == xi_max
      xi_min--
      xi_max++
    
    xi_range = xi_max - xi_min
    
    xo_min = margin.left
    xo_max = size_x - margin.right
    xo_range = xo_max - xo_min
    
    x_coef = xo_range/xi_range
    
    x_scale = (x)->
      0.5 + Math.round xo_min + x_coef*(x - xi_min)
    
    x_scale_rev = (x)->
      xi_min + (x - xo_min)/x_coef
    
    xi_round = (x)->
      Math.round(x/tick_xi_rounding)*tick_xi_rounding
    
    # ###################################################################################################
    # replace list
    # xi -> yi
    # xo -> yo
    # x_ -> y_
    # _x -> _y (size_x)
    
    yi_min = Infinity
    yi_max = -Infinity
    for v in anim_value
      yi_min = Math.min yi_min, v[1]
      yi_max = Math.max yi_max, v[1]
    
    if @min_y?
      yi_min = Math.min yi_min, @min_y
    
    # prevent yi_range == 0
    if yi_min == yi_max
      yi_min--
      yi_max++
    
    yi_range = yi_max - yi_min
    
    yo_min = margin.top
    yo_max = size_y - margin.bottom
    yo_range = yo_max - yo_min
    
    y_coef = yo_range/yi_range
    
    y_scale = (x)->
      0.5 + Math.round yo_max - y_coef*(x - yi_min)
    
    yi_round = (y)->
      Math.round(y/tick_yi_rounding)*tick_yi_rounding
    
    # ###################################################################################################
    x_format = (t)->dayjs(t).format("DD.MM.YYYY HH:mm")
    x_format1= (t)->dayjs(t).format("DD.MM.YYYY")
    x_format2= (t)->dayjs(t).format("HH:mm")
    y_format = (t)->t.toString()
    
    @x_scale = x_scale
    @y_scale = y_scale
    @x_scale_rev = x_scale_rev
    @x_format = x_format
    @y_format = y_format
    
    # ###################################################################################################
    #    axis. Only linear ticks
    # ###################################################################################################
    # Ось x не может уйти в минус т.к. время всегда положительное (даже когда отрицательное в unix timestamp)
    ctx.strokeStyle = "#000"
    ctx.lineWidth = 1
    ctx.font = "#{tick_font_size}px Verdana, Arial, Helvetica, sans-serif"
    x_label_tick = xo_min-tick_size-tick_to_text_gap
    yo_of_axis_x = y_scale(0)
    y_label_tick = yo_of_axis_x+tick_size+tick_to_text_gap
    y_label_tick1 = y_label_tick
    y_label_tick2 = y_label_tick+tick_x_label_gap
    
    step = tick_xi_rounding
    range = Math.abs(x_scale(xi_min) - x_scale(xi_max))
    for i in [0 ... 100] # infinite loop protection
      x_tick_count = (xi_max-xi_min)//step
      gap_size = range/x_tick_count
      break if gap_size > tick_x_min_gap
      step *= 2
    
    ctx.textAlign   = "center"
    ctx.textBaseline= "top"
    for xi in [xi_min .. xi_max] by step
      value_for_label = xi_round xi
      xo              = x_scale  value_for_label
      
      ctx.beginPath()
      ctx.moveTo xo, 0.5+yo_of_axis_x
      ctx.lineTo xo, 0.5+yo_of_axis_x+tick_size
      ctx.stroke()
      
      label = x_format1 value_for_label
      ctx.fillText label, xo, y_label_tick1
      label = x_format2 value_for_label
      ctx.fillText label, xo, y_label_tick2
    
    # ###################################################################################################
    ctx.textAlign   = "right"
    ctx.textBaseline= "middle"
    
    step = tick_yi_rounding
    range = Math.abs(y_scale(yi_min) - y_scale(yi_max))
    for i in [0 ... 100] # infinite loop protection
      y_tick_count = (yi_max-yi_min)//step
      gap_size = range/y_tick_count
      break if gap_size > tick_y_min_gap
      step *= 2
    
    fn_yi = (yi)->
      value_for_label = yi
      yo              = y_scale  value_for_label
      
      min_d = Math.min Math.abs(size_y - yo), Math.abs(yo - margin.top)
      if min_d  < axis_alpha_threshold_dist
        d = min_d/axis_alpha_threshold_dist
        ctx.globalAlpha = d
      else
        ctx.globalAlpha = 1
      
      # suboptimal
      ctx.strokeStyle = "#000"
      ctx.beginPath()
      ctx.moveTo 0.5+xo_min,           yo
      ctx.lineTo 0.5+xo_min-tick_size, yo
      ctx.stroke()
      
      if value_for_label != 0
        ctx.strokeStyle = "#CCC"
        ctx.beginPath()
        ctx.moveTo 0.5+xo_min,           yo
        ctx.lineTo 0.5+xo_max, yo
        ctx.stroke()
      
      label = y_format value_for_label
      ctx.fillText label, x_label_tick, yo
    
    # Важно чтобы 0 был всегда включен
    for yi in [0 .. yi_max] by step
      fn_yi yi
    for yi in [-step .. yi_min] by -step
      fn_yi yi
    
    ctx.globalAlpha = 1
    
    ctx.textBaseline= "bottom"
    ctx.textAlign   = "left"
    ctx.fillText @label_y, xo_min+tick_label_offset_x, yo_min+tick_label_offset_y
    
    # ###################################################################################################
    #    bold axis
    # ###################################################################################################
    ctx.strokeStyle = "#000"
    
    ctx.beginPath()
    ctx.moveTo xo_min, yo_of_axis_x
    ctx.lineTo xo_max, yo_of_axis_x
    ctx.stroke()
    
    ctx.beginPath()
    ctx.moveTo 0.5+xo_min, yo_min
    ctx.lineTo 0.5+xo_min, yo_max
    ctx.stroke()
    
    # ###################################################################################################
    #    line
    # ###################################################################################################
    ctx.strokeStyle = line_color
    ctx.lineWidth = 1.5
    # ctx.lineWidth = 2
    
    ctx.beginPath()
    for v,idx in anim_value
      xo = x_scale v[0]
      yo = y_scale v[1]
      if idx == 0
        ctx.moveTo xo, yo
      else
        ctx.lineTo xo, yo
    ctx.stroke()
    
    return
  
  # ###################################################################################################
  #    tooltip
  # ###################################################################################################
  has_redraw_changes_has_redraw_changes_tooltip: true
  
  redraw_panel_tooltip : ()->
    return if !@has_redraw_changes_tooltip
    @has_redraw_changes_tooltip = false
    
    return if !@$canvas_tooltip
    canvas = @$canvas_tooltip
    ctx = canvas.getContext "2d"
    # WTF clear
    size_x = canvas.width  = canvas.width
    size_y = canvas.height = canvas.height
    
    return if !@value
    return if !@value.length
    
    # ###################################################################################################
    #    config
    # ###################################################################################################
    {
      anim_value
      line_color
      tick_font_size
      
      x_scale
      y_scale
      x_scale_rev
      x_format
      y_format
    } = @
    
    tooltip_text_x = 10
    tooltip =
      x     : 10
      y     : -30
      width : 140
      height: 50
      corner_radius : 3
      text_1_x : tooltip_text_x
      text_1_y : 10
      text_2_x : tooltip_text_x
      text_2_y : 30
      text_3_x : tooltip_text_x+40
      text_3_y : 30
    
    tooltip_point_radius = 5
    
    # ###################################################################################################
    #    tooltip
    # ###################################################################################################
    ctx.lineWidth = 1
    
    if @has_hover
      @hover_x_last = @hover_x
      nearest_value = anim_value[0]
      rev_hover_x   = x_scale_rev @hover_x
      
      dist = Infinity
      for v in anim_value
        new_dist = Math.abs v[0] - rev_hover_x
        if dist > new_dist
          dist = new_dist
          nearest_value = v
      
      [xi,yi] = nearest_value
      xo = x_scale xi
      yo = y_scale yi
      
      ctx.fillStyle = line_color
      ctx.strokeStyle = line_color
      ctx.beginPath()
      ctx.arc xo, yo, tooltip_point_radius, 0, 2 * Math.PI, false
      ctx.fill()
      # ctx.stroke()
      
      xo += tooltip.x
      yo += tooltip.y
      
      dx_r = (size_x - xo) - tooltip.width - tooltip.x # - margin.left
      if dx_r < 0
        xo -= tooltip.width + 2*tooltip.x
      
      ctx.fillStyle   = "#FFF"
      ctx.strokeStyle = "#000"
      ctx.beginPath()
      ctx.roundRect   xo, yo, tooltip.width, tooltip.height, tooltip.corner_radius
      ctx.fill()
      ctx.stroke()
      
      x_label = x_format xi
      y_label = y_format yi
      
      ctx.font = "bold #{tick_font_size}px Verdana, Arial, Helvetica, sans-serif"
      ctx.fillStyle   = "#000"
      ctx.textAlign   = "left"
      ctx.textBaseline= "top"
      ctx.fillText x_label, xo+tooltip.text_1_x, yo+tooltip.text_1_y
      ctx.fillText y_label, xo+tooltip.text_3_x, yo+tooltip.text_3_y
      
      ctx.font = "#{tick_font_size}px Verdana, Arial, Helvetica, sans-serif"
      ctx.fillText "Value:", xo+tooltip.text_2_x, yo+tooltip.text_2_y
    
  
  # ###################################################################################################
  #    handlers
  # ###################################################################################################
  mouse_over : (event)->
    @has_hover = true
    @hover_x = rel_mouse_coords(event).x * devicePixelRatio
    @has_redraw_changes_tooltip = true
  
  mouse_move : (event)->
    @has_hover = true
    @hover_x = rel_mouse_coords(event).x * devicePixelRatio
    @has_redraw_changes_tooltip = true
  
  mouse_out : ()->
    @has_hover = false
    @has_redraw_changes_tooltip = true
  
  # ###################################################################################################
  refresh: (layer_name = "all")->
    switch layer_name
      when "fg"
        @has_redraw_changes_fg = true
      when "tooltip"
        @has_redraw_changes_tooltip = true
      when "all"
        @has_redraw_changes_fg = true
        @has_redraw_changes_tooltip = true
    
    return
  
