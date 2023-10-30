window.global_mouse_move = new Event_mixin
document.addEventListener "mousemove", (event)->
  global_mouse_move.dispatch "mouse_move", event
