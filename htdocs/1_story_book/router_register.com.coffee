window.global_router_register_hash = {}
window.global_router_register = (display_name, real_name)->
  global_router_register_hash[real_name] = display_name

# redefine fix
`
Object.defineProperty(window, "__STACK__", {
  get: function(){
    var orig = Error.prepareStackTrace;
    Error.prepareStackTrace = function(_, stack){ return stack; };
    var err = new Error;
    Error.captureStackTrace(err, arguments.callee);
    var stack = err.stack;
    Error.prepareStackTrace = orig;
    return stack;
  }
});

Object.defineProperty(window, "__LINE__", {
  get: function(){
    return __STACK__[1].getLineNumber();
  }
});

Object.defineProperty(window, "__FILE__", {
  get: function(){
    return __STACK__[1].getFileName().split("/").slice(-1)[0];
  }
});

Object.defineProperty(window, "__FILE_FULL__", {
  get: function(){
    return __STACK__[1].getFileName();
  }
});
`
Function.prototype.wrap_once = ()->
  old_fn = @
  ()->
    return if !old_fn
    _fn = old_fn
    old_fn = null
    _fn arguments...

module.exports =
  render : ()->
    div "noop"
