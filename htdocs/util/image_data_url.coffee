conv_canvas = null
window.image_data_to_url = (image_data)->
  conv_canvas ?= document.createElement "canvas"
  conv_canvas.width = image_data.width  if conv_canvas.width != image_data.width
  conv_canvas.height= image_data.height if conv_canvas.height!= image_data.height
  ctx = conv_canvas.getContext "2d"
  ctx.putImageData image_data, 0, 0
  conv_canvas.toDataURL()

window.video_to_url = (video)->
  conv_canvas ?= document.createElement "canvas"
  {videoWidth, videoHeight} = video
  conv_canvas.width = videoWidth  if conv_canvas.width != videoWidth
  conv_canvas.height= videoHeight if conv_canvas.height!= videoHeight
  ctx = conv_canvas.getContext "2d"
  ctx.drawImage video, 0, 0
  conv_canvas.toDataURL()
