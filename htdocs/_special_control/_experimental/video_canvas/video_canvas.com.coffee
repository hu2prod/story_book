module.exports =
  ###
    BUGS
      video lag WTF???
      GC WTF???
  ###
  state:
    play : false
    playback_rate : 1
  
  mount_done : ()->
    @props.ref_video? @refs.video
    return
  
  render : ()->
    size_x = @props.width  or @props.size_x
    size_y = @props.height or @props.size_y
    div {
      style:
        borderSpacing: 0
        borderCollapse: "initial"
    }
      video {
        ref : "video"
        src : @props.src
        style:
          width   : size_x
          height  : size_y
          padding : 0
          margin  : 0
        preload : @props.preload ? "auto"
        # controls: true # мы сами рисуем поверх
        muted   : true # @props.muted
        autoplay: true # @props.autoplay # проблемное
        loop    : @props.loop
      }
      # Canvas_multi не должен учитываться в высоте блока
      div {
        style:
          position: "relative"
          top     : -(size_y+4) # +4 грязный HACK TODO FIXME
          # width   : size_x # не обязательно
          # height  : size_y
      }
        div {
          style:
            position: "absolute"
        }
          {controller} = @props
          Canvas_multi {
            width       : size_x
            height      : size_y
            layer_list  : @props.layer_list
            resize_fix  : false
            canvas_cb   : (canvas_hash)=>
              controller?.canvas_controller canvas_hash
            gui         : controller
            ref_textarea: ($textarea)=>
              controller?.$textarea = $textarea
              controller?.init()
          }
      if @props.controls
        div {
          style:
            height: video_controls_sy
            marginTop: -4 # TODO FIXME HACK
        }
          Video_canvas_controls {
            size_x: size_x
            control_all: true
            video: @refs.video
            
            play : @state.play
            on_play_change : (play)=>
              @set_state {play}
              if play
                @refs.video.play()
              else
                @refs.video.pause()
              return
            
            playback_rate: @state.playback_rate
            on_playback_rate_change : (playback_rate)=>
              @set_state {playback_rate}
              @refs.video.playbackRate = playback_rate
          }
