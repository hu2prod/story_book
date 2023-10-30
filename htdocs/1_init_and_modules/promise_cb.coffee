Promise.prototype.cb = (cb)->
  @catch (err)=>cb err
  @then (res)=>cb null, res
