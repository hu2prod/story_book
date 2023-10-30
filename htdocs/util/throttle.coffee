window.throttle = (obj, delay, fn)->
  now = Date.now()
  if !obj
    fn()
    return {last_ts:now, active: false}
  
  return obj if obj.active
  {last_ts} = obj
  if now - last_ts > delay
    fn()
    return {last_ts:now, active: false}
  
  # now - last_ts < delay
  # puts "throttle wait", delay - (now - last_ts)
  setTimeout ()->
    obj.active  = false
    obj.last_ts = Date.now()
    fn()
  , delay - (now - last_ts)
  
  obj.active = true
  obj
