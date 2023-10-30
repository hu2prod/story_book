module.exports =
  render : ()->
    progress {
      class : 'xbar_default '+ (@props.class or "")
      value : @props.value
      max   : @props.max
      style :
        width : @props.width  or @props.size_x or 100
        height: @props.height or @props.size_y or 10
        opacity: if @props.hide then 0 else 1
    }
      
  