module.exports =
  controller : null
  mount : ()->
    @controller = new Video_canvas_select_controller
    @controller.force_update = ()=>@force_update()
    @controller.on "capture_url", (value)=>@props.on_refresh_capture_url? value
    return
  
  render : ()->
    table
      tbody
        tr
          td {
            style:
              verticalAlign: "top"
          }
            Video_canvas {
              src       : @props.src
              size_x    : @props.size_x
              size_y    : @props.size_y
              layer_list: ["fg"]
              controls  : true
              controller: @controller
              ref_video : (video)=>
                @controller.video = video
            }
          td {
            style:
              verticalAlign: "top"
          }
            Video_canvas_select_object_inspector {
              value       : @controller.value
              on_change   : (t)=>@controller.on_change t
              
              # on image refresh button click
              on_refresh  : ()=>@controller.on_change @controller.value
              capture_url : @controller.capture_url
              
              # on capture button click
              on_capture  : ()=>@props.on_capture? @controller.capture_url
            }
