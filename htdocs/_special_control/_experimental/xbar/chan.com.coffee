module.exports =
  render : ()->
    props = clone @props
    props.class = "xbar_chan"
    Xbar props
  