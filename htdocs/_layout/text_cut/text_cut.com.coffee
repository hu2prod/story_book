module.exports =
  render : ()->
    {value} = @props
    max_length = @props.max_length ? 30
    if !value or value.length < max_length
      span value
    else
      if @props.hover == false
        span value.cut max_length
      else
        Tooltip {
          position_x    : @props.position_x ? "right"
          position_y    : @props.position_y
          mount_point_x : @props.mount_point_x ? "left"
          mount_point_y : @props.mount_point_y
          
          tooltip_render: ()=>
            div {
              style :
                background  : "#FFF"
                borderRadius: 5
                border      : "1px solid black"
                padding     : 5
                whiteSpace  : "nowrap"
            }
              span value
        }
          span value.cut max_length