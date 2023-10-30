###
# enable when needed
ws_back_url = "ws://#{location.hostname}:3280"
window.ws_back  = new Websocket_wrap ws_back_url
window.wsrs_back= new Ws_request_service ws_back

loop
  await wsrs_back.request {switch: "ping"}, defer(err), timeout:1000
  if err
    perr "ping hang/error -> reconnect", err.message
    ws_back.ws_reconnect()
  await setTimeout defer(), 1000

###
