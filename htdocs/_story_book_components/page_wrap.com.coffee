module.exports =
  render : ()->
    div
      h1 {
        on_click : ()-> route_go ""
        class : "pointer"
      }, if @props.label then "Story book - #{@props.label}" else "Story book"
      # body
      div
        @props.children
      # TODO footer
      div()
