window.global_mouse_up = new Event_mixin
# TODO addEventListener
# document.addEventListener "mouseup", (event)->
document.onmouseup = (event)->
  global_mouse_up.dispatch "mouse_up", event