module.exports =
  render : ()->
    props = clone @props
    props.class = "xbar_xp"
    Xbar props
  