conv_canvas = null
generic_capture = (target, target_size_x, target_size_y, roi)->
  conv_canvas ?= document.createElement "canvas"
  if roi
    target_size_x = roi.size_x
    target_size_y = roi.size_y
  
  conv_canvas.width = target_size_x if conv_canvas.width != target_size_x
  conv_canvas.height= target_size_y if conv_canvas.height!= target_size_y
  ctx = conv_canvas.getContext "2d"
  
  ox = 0
  oy = 0
  if roi
    ox = -roi.x
    oy = -roi.y
  
  if target.constructor.name == "ImageData"
    ctx.putImageData target, ox, oy
  else
    ctx.drawImage target, ox, oy
  conv_canvas.toDataURL()

# can fit image, but need special function
window.image_data_to_url = (image_data, roi)->
  generic_capture image_data, image_data.width, image_data.height, roi

window.video_to_url = (video, roi)->
  generic_capture video, video.videoWidth, video.videoHeight, roi
