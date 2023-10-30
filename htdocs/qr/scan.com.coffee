module.exports =
  state :
    error           : ""
    active_camera_id: 0
    camera_list     : []
    point_found_count: 0
  
  mount : ()->
    @web_cam_detect (err)->throw err if err
  
  unmount_fn_list : []
  unmount : ()->
    for fn in @unmount_fn_list
      fn()
    return
  
  web_cam_detect : (cb)->
    if !navigator?.mediaDevices?.enumerateDevices?
      @set_state error : "camera not available"
      return cb null
    # set web cam
    await navigator.mediaDevices.enumerateDevices().cb defer(err, device_list); return cb err if err
    
    camera_list = []
    for device in device_list
      continue if device.kind != "videoinput"
      camera_list.push {
        device
      }
    is_back = (t)->
      +((t.label or "").toLowerCase().search("back") != -1)
    camera_list.sort (a,b)->-(is_back(a)-is_back(b))
    @set_state {camera_list}
    
    setTimeout ()=>
      for camera, idx in camera_list
        @web_cam_activate idx, camera, @refs["video_#{idx}"]
      return
    , 0
    
    cb()
  
  web_cam_activate : (idx, camera, video)->
    on_success = (stream)=>
      p "stream", stream
      if @webkit
        try
          video.src = window.URL.createObjectURL(stream)
        catch err
          video.srcObject = stream
      else if @moz
        video.mozSrcObject = stream
        video.play()
      
      cam_interval = setInterval ()=>
        if idx == @state.active_camera_id
          @process_frame video
      , @props.interval ? 200
      
      @unmount_fn_list.push ()=>
        clearInterval cam_interval
      
      @force_update()
    
    on_error = (err)=>
      perr err
    
    loc_opt =
      video:
        deviceId  : exact: camera.device.deviceId
        facingMode: "environment"
      audio: false
    
    if navigator.getUserMedia
      navigator.getUserMedia loc_opt, on_success, on_error
      @webkit = true
    else if navigator.webkitGetUserMedia
      navigator.webkitGetUserMedia loc_opt, on_success, on_error
      @webkit = true
    else if navigator.mozGetUserMedia
      navigator.mozGetUserMedia loc_opt, on_success, on_error
      @moz = true
  
  process_frame : (video)->
    canvas = video_to_canvas video
    
    qrcode.canvas_qr2 = canvas
    qrcode.qrcontext2 = canvas.getContext "2d"
    
    qrcode.callback = (res)=>
      @set_state point_found_count:3
      puts "qr callback ", res
      @props.on_scan res
      return
    try
      qrcode.decode()
    catch err
      if reg_ret = /\(found (\d+)\)/.exec err
        [_skip, found] = reg_ret
        found = +found
        if @state.point_found_count != found
          @set_state point_found_count:found
      else
        perr err
  
  render : ()->
    size = @props.size ? 300
    div
      if @state.error
        span "error: #{@state.error}"
      else
        div {
          style :
            display       : "flex"
            height        : 20
            marginBottom  : 5
        }
          div {
            style:
              marginRight : 5
          }, "Detect level"
          for i in [0 ... 3]
            found = @state.point_found_count > i
            div {
              style :
                width : 20
                height: 20
                backgroundColor  : if found then "#0f0" else "#aaa"
                marginRight : 5
                borderRadius : 10
            }
        table {class : "table"}
          tbody
            for camera, idx in @state.camera_list
              do (camera, idx)=>
                _class = ""
                _class = "selected" if @state.active_camera_id == idx
                tr 
                  td {
                    key : idx
                    class : _class
                    on_click : ()=>
                      @set_state active_camera_id : idx
                  }
                    video {
                      ref     : "video_#{idx}"
                      autoPlay: true
                      style :
                        width   : size
                        height  : size
                        border  : "1px solid black"
                    }
    
