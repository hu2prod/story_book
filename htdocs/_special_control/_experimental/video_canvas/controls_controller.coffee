video_controls_seek_bar_sy = 5
window.video_controls_sy = 30+video_controls_seek_bar_sy+2
default_speed_min       = 0.25
default_speed_max       = 3
default_speed_step      = 0.25
default_speed_precision = 2


class Rect
  x1 : 0
  x2 : 0
  y1 : 0
  y2 : 0
  
  constructor : (@x1, @y1, @x2, @y2)->
  
  test : (x,y)->
    return false if x < @x1 or x > @x2
    return false if y < @y1 or y > @y2
    true



class window.Video_canvas_controls_controller
  play_button_rect : null
  # seek_bar_rect : null
  speed_inc_button_rect : null
  speed_dec_button_rect : null
  
  props: {}
  
  $canvas_fg: null
  $textarea : null
  
  constructor :()->
    @play_button_rect     = new Rect 0, video_controls_seek_bar_sy, 30, video_controls_sy
    # @seek_bar_rect    = new Rect 0, 0, Infinity, video_controls_sy
    @speed_inc_button_rect= new Rect 0, video_controls_seek_bar_sy, Infinity, video_controls_sy
    @speed_dec_button_rect= new Rect 0, video_controls_seek_bar_sy, Infinity, video_controls_sy
  
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
  
  old_size_x : 0
  old_size_y : 0
  
  curr_time  : 0
  total_time : 1
  redraw_fg: ()->
    if @curr_time != @props.video?.currentTime
      @has_redraw_changes_fg = true
    
    if @props.video
      @curr_time  = @props.video.currentTime
      @total_time = @props.video.duration
    
    return if !@has_redraw_changes_fg
    @has_redraw_changes_fg = false
    
    return if !@$canvas_fg
    canvas = @$canvas_fg
    ctx = canvas.getContext "2d"
    # WTF clear
    size_x = canvas.width  = canvas.width
    size_y = canvas.height = canvas.height
    
    update_size = false
    update_size = true if size_x != @old_size_x
    update_size = true if size_y != @old_size_y
    @old_size_x = size_x
    @old_size_y = size_y
    if update_size
      # @seek_bar_rect.x2 = size_x
      @speed_inc_button_rect.x1 = size_x - 90
      @speed_inc_button_rect.x2 = @speed_inc_button_rect.x1 + 45
      
      @speed_dec_button_rect.x2 = size_x
      @speed_dec_button_rect.x1 = @speed_inc_button_rect.x2
    
    draw_play_btn = @props.control_play_btn   or @props.control_all
    draw_time_text= @props.control_time_text  or @props.control_all
    draw_seekbar  = @props.control_seekbar    or @props.control_all
    draw_mute     = @props.control_mute       or @props.control_all
    draw_volume   = @props.control_volume     or @props.control_all
    draw_speed    = @props.control_speed      or @props.control_all
    
    # BG
    ctx.fillStyle = "#000"
    ctx.fillRect 0, 0, size_x, size_y
    
    # ###################################################################################################
    #    play_btn
    # ###################################################################################################
    if draw_play_btn
      cx = 30/2
      cy = 30/2+video_controls_seek_bar_sy
      sx_2 = 10
      sy_2 = 10
      mini_sx = 5
      
      ctx.fillStyle = "#FFF"
      
      if @props.play
        sx_2 -= 2
        ctx.fillRect cx-sx_2,         cy-sy_2, mini_sx, 2*sy_2
        ctx.fillRect cx+sx_2-mini_sx, cy-sy_2, mini_sx, 2*sy_2
      else
        ctx.beginPath()
        ctx.moveTo cx-sx_2, cy-sy_2
        ctx.lineTo cx-sx_2, cy+sy_2
        ctx.lineTo cx+sx_2, cy
        ctx.closePath()
        ctx.fill()
    
    # ###################################################################################################
    #    seekbar
    # ###################################################################################################
    if draw_seekbar
      percent = @curr_time/@total_time
      ctx.fillStyle = "#F00"
      sx = size_x * percent
      sy = 3
      ctx.fillRect 0, 0, sx, sy
    
    # ###################################################################################################
    #    time_text
    # ###################################################################################################
    if draw_time_text
      font_size = 20
      x = 30 + 10
      y = video_controls_seek_bar_sy + font_size
      ctx.fillStyle = "#FFF"
      ctx.font = "#{font_size}px monospace"
      
      fmt = "hh:MM:SS"
      fmt = "MM:SS" if @total_time < 60*60
      text = "#{tsd_fmt(@curr_time*1000, fmt)} / #{tsd_fmt(@total_time*1000, fmt)}"
      ctx.fillText text, x, y
      
    # ###################################################################################################
    #    mute
    # ###################################################################################################
    # TODO
    # ###################################################################################################
    #    volume
    # ###################################################################################################
    # TODO
    # ###################################################################################################
    #    speed
    # ###################################################################################################
    if draw_speed
      font_size = 20
      x = size_x - 90
      y = video_controls_seek_bar_sy + font_size
      ctx.font = "#{font_size}px monospace"
      speed = @props.video?.playbackRate or 1
      speed_precision = @props.speed_precision or default_speed_precision
      text = "+ #{speed.toFixed(speed_precision)} -"
      ctx.fillText text, x, y
      
    return
  
  # ###################################################################################################
  #    mouse
  # ###################################################################################################
  mouse_click: (event)->
    {x,y} = rel_mouse_coords event
    if @play_button_rect.test x,y
      @play_toggle()
      return
    
    # TODO??? pass through props value/on_change
    value = @props.playback_rate
    
    value_min = @props.speed_min  or default_speed_min
    value_max = @props.speed_max  or default_speed_max
    value_step= @props.speed_step or default_speed_step
    value_round_mult = 10 ** (@props.speed_precision or default_speed_precision)
    
    if @speed_inc_button_rect.test x,y
      if value < value_max
        value = Math.round(value_round_mult*(value + value_step))/value_round_mult
        @props.on_playback_rate_change value
      return
    
    if @speed_dec_button_rect.test x,y
      if value > value_min
        value = @props.playback_rate
        value = Math.round(value_round_mult*(value - value_step))/value_round_mult
        @props.on_playback_rate_change value
      return
      
      
    # all rest clicks assume seek bar
    
    if @props.video?
      # if @seek_bar_rect.test x,y
      size_x = @$canvas_fg.width
      new_percent = x/size_x
      @props.video.currentTime = @total_time*new_percent
    
    # puts "click", {x,y}
    return
  
  # ###################################################################################################
  #    actions
  # ###################################################################################################
  play_toggle: ()->
    @props.on_play_change? !@props.play
    return
  