module.exports =
  raw_html : ""
  mount_done : ()->
    @refresh()
  
  props_change : (new_props)->
    @refresh new_props
  
  refresh : (props = @props)->
    {value} = props
    # нельзя QR код с ничем
    value = " " if value.length == 0
    raw_html = ""
    
    add_point = (t)->
      raw_html += "<div class='#{ if t then 'qrTrue' else 'qrFalse'}'> </div>"
      return
    
    
    newLine = ()->
      raw_html += "<br/>"
      return
    
    code = qrencode.encodeString(value, 0, 
      qrencode.QR_ECLEVEL_L,
      qrencode.QR_MODE_8, true);
    
    
    for i in [0 ... 2]
      for j in [0 ... code.length]
        add_point(false)
      newLine()
    
    for j in [0 ... code.length]
      add_point(false)
      add_point(false)
        
      for i in [0 ... code.length]
        add_point(code[i][j])
        
      add_point(false)
      add_point(false)
      newLine()
    
    
    for i in [0 ... 2]
      for j in [0 ... code.length]
        add_point(false)
      newLine()
    
    @raw_html = raw_html
    @force_update()
    return
  
  render : ()->
    div {
      class : "qrCode"
      dangerouslySetInnerHTML: __html : @raw_html
    }
