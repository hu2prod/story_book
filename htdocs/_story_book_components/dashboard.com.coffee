module.exports =
  render : ()->
    table {class : "table"}
      tbody
        tr
          th "Component"
        for real_name, display_name of global_router_register_hash
          do (real_name, display_name)=>
            tr
              td
                a {
                  on_click : ()=>
                    route_go "exhibition_#{real_name}"
                }, display_name.capitalize()
