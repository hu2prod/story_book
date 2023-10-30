# https://stackoverflow.com/questions/3437786/get-the-size-of-the-screen-current-web-page-and-browser-window
screen_size = ()->
  {
    s_x : window.innerWidth   or document.documentElement.clientWidth   or document.body.clientWidth
    s_y : window.innerHeight  or document.documentElement.clientHeight  or document.body.clientHeight
  }
module.exports =
  props_change : (new_props)->
    if @props.src != new_props.src
      if @popup
        @hide()
        @show()
    return
  
  unmount : ()->
    @hide() if @popup
    return
  
  render : ()->
    div {
      style : @props.style
      onMouseOver : ()=> @show()
      onMouseOut  : ()=> @hide()
    }
      img obj_merge {ref: "mini_img"}, @props
      return
  
  show : ()->
    @popup = document.createElement "img"
    {left, top, right, bottom} = @refs.mini_img.getBoundingClientRect()
    {naturalWidth:img_s_x, naturalHeight:img_s_y} = @refs.mini_img
    
    offset = @props.offset ? 5
    
    cx = (left+right - img_s_x)/2
    cy = (top+bottom - img_s_y)/2
    position = @props.position
    switch position
      when "top"
        x = cx
        y = top - img_s_y - offset
      when "left"
        x = left - img_s_x - offset
        y = cy
      when "right"
        x = right + offset
        y = cy
      else # bottom
        x = cx
        y = bottom + offset
    
    # fix screen 
    if @props.fix_screen ? true
      {s_x, s_y} = screen_size()
      s_x -= 20 # scroll
      diff_x = x + img_s_x - s_x
      diff_y = y + img_s_y - s_y
      switch position
        when "left", "right"
          y -= diff_y if 0 < diff_y
        else # top, bottom
          x -= diff_x if 0 < diff_x
      
    
    @popup.style.position = "absolute"
    @popup.style.left = x + "px"
    @popup.style.top  = y + "px"
    @popup.style.zIndex = 100
    @popup.src = @props.src
    document.body.appendChild @popup
    return
  
  hide : ()->
    # return
    document.body.removeChild @popup
    @popup = null
    return
  