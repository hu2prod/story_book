global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Video_canvas_select {
                src       : "/asset/Big Buck Bunny 60fps 4K - Official Blender Foundation Short Film-aqz-KE-bpKQ.mkv"
                size_x    : 1920/2
                size_y    : 1080/2
                on_capture: (capture_url)=>puts "capture"
              }
              """#"
          td
            Video_canvas_select {
              src       : "/asset/Big Buck Bunny 60fps 4K - Official Blender Foundation Short Film-aqz-KE-bpKQ.mkv"
              size_x    : 1920/2
              size_y    : 1080/2
              on_capture: (capture_url)=>puts "capture"
            }
        