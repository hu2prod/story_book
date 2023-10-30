module.exports =
  render : ()->
    Router_multi {
      render : (hash)=>
        Page_wrap {label: "dashboard"}, ()=>
          switch path = hash[""]?.path or ""
            when ""
              Dashboard {}
            else
              key = path.replace /^exhibition_/, ""
              if global_router_register_hash[key]
                return window[path.capitalize()]()
              div "404"
    }
