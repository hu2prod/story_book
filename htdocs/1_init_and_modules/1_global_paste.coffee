window.global_paste = new Event_mixin
document.onpaste = (e)->
  global_paste.dispatch "raw", e
  for v in e.clipboardData.items
    global_paste.dispatch "item", v
    if -1 != v.type.indexOf "image"
      file = v.getAsFile()
      global_paste.dispatch "image_file", file
      reader = new FileReader()
      reader.onload = (_e)->
        base64 = _e.target.result
        global_paste.dispatch "image_base64", base64
        canvas = document.createElement "canvas"
        ctx = canvas.getContext "2d"
        image = new Image()
        image.onload = ()->
          canvas.width  = @width
          canvas.height = @height
          ctx.drawImage image, 0, 0
          global_paste.dispatch "image", {
            image
            canvas
            ctx
            @width
            @height
          }
        image.src = base64
        
      reader.readAsDataURL file
      
  return
