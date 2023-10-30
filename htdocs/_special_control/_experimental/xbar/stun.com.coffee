module.exports =
  render : ()->
    props = clone @props
    props.class = "xbar_stun"
    props.height ?= 3
    Xbar props
  