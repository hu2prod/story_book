module.exports =
  render : ()->
    props = clone @props
    props.class = "xbar_mp"
    Xbar props
  