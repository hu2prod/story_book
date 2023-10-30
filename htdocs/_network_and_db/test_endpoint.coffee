###
# enable when needed

@test_endpoint = (opt, cb)->
  req_opt =
    switch : "test_endpoint"
    # TODO extra params
  
  # simple stub
  obj_set req_opt, opt
  
  await wsrs_back.request req_opt, defer(err, res); return cb err if err
  
  # TODO format_result
  
  cb null, res

###
