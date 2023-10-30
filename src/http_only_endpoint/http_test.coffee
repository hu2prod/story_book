@http_test = (req, on_end, http_req, http_res)->
  # http_res.header "Content-Type", "image/png"
  http_res.end "hello"
  on_end null, null, true
